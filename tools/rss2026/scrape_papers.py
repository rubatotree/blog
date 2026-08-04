#!/usr/bin/env python3
"""Capture RSS 2026 paper metadata from the official conference website."""

from __future__ import annotations

import argparse
import json
import re
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path
from typing import Iterable
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen


DEFAULT_LIST_URL = "https://roboticsconference.org/program/papers/"
DEFAULT_OUTPUT = Path("data/rss2026/papers.json")
USER_AGENT = "rss2026-paper-notes/1.0 (+https://rubatotree.github.io/blog/)"
PAPER_PATH = re.compile(r"^/program/papers/(\d+)/?$")


@dataclass(frozen=True)
class PaperSeed:
    paper_id: int
    title: str
    session: str
    detail_url: str


@dataclass(frozen=True)
class Paper:
    paper_id: int
    title: str
    authors: list[str]
    session: str
    abstract: str
    detail_url: str
    pdf_url: str


def _clean_text(value: str) -> str:
    return " ".join(value.split()).strip()


class ListPageParser(HTMLParser):
    """Parse stable paper rows without depending on CSS or JavaScript."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self._session = ""
        self._row: dict[str, str] | None = None
        self._in_title = False
        self._title_parts: list[str] = []
        self.seeds: list[PaperSeed] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attributes = dict(attrs)
        if tag == "tr" and attributes.get("session"):
            self._session = _clean_text(attributes["session"] or "")
            self._row = {"session": self._session}
        elif self._row is not None and tag == "a":
            match = PAPER_PATH.match(attributes.get("href", "") or "")
            if match:
                self._row["paper_id"] = match.group(1)
                self._row["detail_url"] = attributes["href"] or ""
                self._in_title = True
        elif self._in_title and tag == "b":
            self._title_parts = []

    def handle_data(self, data: str) -> None:
        if self._in_title:
            self._title_parts.append(data)

    def handle_endtag(self, tag: str) -> None:
        if tag == "a" and self._in_title:
            if self._row is not None and "paper_id" in self._row:
                self._row["title"] = _clean_text("".join(self._title_parts))
            self._in_title = False
        elif tag == "tr" and self._row is not None:
            required = ("paper_id", "title", "session", "detail_url")
            if all(self._row.get(key) for key in required):
                self.seeds.append(
                    PaperSeed(
                        paper_id=int(self._row["paper_id"]),
                        title=self._row["title"],
                        session=self._row["session"],
                        detail_url=self._row["detail_url"],
                    )
                )
            self._row = None
            self._in_title = False


class DetailPageParser(HTMLParser):
    """Extract metadata from a paper detail page."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.title_parts: list[str] = []
        self.author_parts: list[str] = []
        self.abstract_parts: list[str] = []
        self.session_parts: list[str] = []
        self.pdf_url = ""
        self.paper_id = ""
        self._capture: str | None = None
        self._abstract_depth = 0

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attributes = dict(attrs)
        classes = set((attributes.get("class") or "").split())
        element_id = attributes.get("id") or ""
        if tag == "h3" and "page-title" in classes:
            self._capture = "title"
        elif tag == "div" and "paper-author-name" in classes:
            self._capture = "authors"
        elif tag == "h3" and element_id.startswith("paper-id-"):
            self._capture = "paper_id"
        elif tag == "h3" and element_id.startswith("session-"):
            self._capture = "session"
        elif tag == "p" and "color:gray" in (attributes.get("style") or ""):
            self._capture = "abstract"
            self._abstract_depth = 1
        elif self._capture == "abstract":
            self._abstract_depth += 1
        if tag == "a" and attributes.get("title") == "Download PDF":
            self.pdf_url = attributes.get("href") or ""

    def handle_data(self, data: str) -> None:
        if self._capture == "title":
            self.title_parts.append(data)
        elif self._capture == "authors":
            self.author_parts.append(data)
        elif self._capture == "paper_id":
            self.paper_id += data
        elif self._capture == "session":
            self.session_parts.append(data)
        elif self._capture == "abstract":
            self.abstract_parts.append(data)

    def handle_endtag(self, tag: str) -> None:
        if self._capture == "abstract":
            self._abstract_depth -= 1
            if self._abstract_depth == 0:
                self._capture = None
        elif tag in {"h3", "div", "p"} and self._capture in {
            "title",
            "authors",
            "paper_id",
            "session",
        }:
            self._capture = None

    def result(self, seed: PaperSeed, base_url: str) -> Paper:
        title = _clean_text("".join(self.title_parts))
        authors_text = _clean_text("".join(self.author_parts))
        abstract = _clean_text("".join(self.abstract_parts))
        session = _clean_text("".join(self.session_parts))
        paper_id = re.search(r"\d+", self.paper_id)
        if not title or not abstract or not session or paper_id is None:
            raise ValueError(f"incomplete detail page for paper {seed.paper_id}")
        authors = [author.strip() for author in authors_text.split(",") if author.strip()]
        return Paper(
            paper_id=int(paper_id.group()),
            title=title,
            authors=authors,
            session=session.removeprefix("Session "),
            abstract=abstract.removeprefix("Abstract: ").strip(),
            detail_url=_absolute_url(base_url, seed.detail_url),
            pdf_url=self.pdf_url,
        )


def _absolute_url(base_url: str, path: str) -> str:
    if path.startswith("http://") or path.startswith("https://"):
        return path
    return base_url.rstrip("/") + "/" + path.lstrip("/")


def fetch(url: str, timeout: float, retries: int) -> str:
    request = Request(url, headers={"User-Agent": USER_AGENT})
    last_error: Exception | None = None
    for attempt in range(retries + 1):
        try:
            with urlopen(request, timeout=timeout) as response:
                return response.read().decode("utf-8", errors="replace")
        except (HTTPError, URLError, TimeoutError) as error:
            last_error = error
            if attempt < retries:
                time.sleep(0.5 * (2**attempt))
    raise RuntimeError(f"failed to fetch {url}: {last_error}")


def parse_seeds(html: str, base_url: str) -> list[PaperSeed]:
    parser = ListPageParser()
    parser.feed(html)
    seeds = [
        PaperSeed(
            paper_id=seed.paper_id,
            title=seed.title,
            session=seed.session,
            detail_url=_absolute_url(base_url, seed.detail_url),
        )
        for seed in parser.seeds
    ]
    if not seeds:
        raise ValueError("no paper rows found; the source HTML may have changed")
    if len({seed.paper_id for seed in seeds}) != len(seeds):
        raise ValueError("duplicate paper ids in list page")
    return sorted(seeds, key=lambda seed: seed.paper_id)


def scrape_paper(seed: PaperSeed, timeout: float, retries: int) -> Paper:
    html = fetch(seed.detail_url, timeout, retries)
    parser = DetailPageParser()
    parser.feed(html)
    paper = parser.result(seed, seed.detail_url.rsplit("/program/papers/", 1)[0])
    if paper.paper_id != seed.paper_id:
        raise ValueError(f"paper id mismatch: expected {seed.paper_id}, got {paper.paper_id}")
    return paper


def scrape(list_url: str, workers: int, timeout: float, retries: int) -> dict[str, object]:
    list_html = fetch(list_url, timeout, retries)
    base_url = list_url.split("/program/", 1)[0]
    seeds = parse_seeds(list_html, base_url)
    papers: list[Paper] = []
    failures: list[dict[str, object]] = []
    with ThreadPoolExecutor(max_workers=workers) as executor:
        futures = {
            executor.submit(scrape_paper, seed, timeout, retries): seed for seed in seeds
        }
        for future in as_completed(futures):
            seed = futures[future]
            try:
                papers.append(future.result())
            except Exception as error:  # preserve all failures for a useful report
                failures.append({"paper_id": seed.paper_id, "url": seed.detail_url, "error": str(error)})
    if failures:
        failures.sort(key=lambda item: int(item["paper_id"]))
        raise RuntimeError(json.dumps({"failed": failures}, ensure_ascii=False, indent=2))
    papers.sort(key=lambda paper: paper.paper_id)
    sessions: dict[str, int] = {}
    for paper in papers:
        sessions[paper.session] = sessions.get(paper.session, 0) + 1
    return {
        "conference": "RSS 2026",
        "source_url": list_url,
        "fetched_at": datetime.now(timezone.utc).isoformat(),
        "paper_count": len(papers),
        "session_counts": dict(sorted(sessions.items())),
        "papers": [asdict(paper) for paper in papers],
    }


def write_json(payload: dict[str, object], output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        "w", encoding="utf-8", dir=output.parent, prefix=f".{output.name}.", delete=False
    ) as temporary:
        json.dump(payload, temporary, ensure_ascii=False, indent=2)
        temporary.write("\n")
        temporary_path = Path(temporary.name)
    temporary_path.replace(output)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--list-url", default=DEFAULT_LIST_URL)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--workers", type=int, default=8)
    parser.add_argument("--timeout", type=float, default=20.0)
    parser.add_argument("--retries", type=int, default=3)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.workers < 1 or args.retries < 0 or args.timeout <= 0:
        raise SystemExit("workers must be positive; retries non-negative; timeout positive")
    payload = scrape(args.list_url, args.workers, args.timeout, args.retries)
    write_json(payload, args.output)
    print(f"wrote {payload['paper_count']} papers to {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
