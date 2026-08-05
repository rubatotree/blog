"""Download and parse the official ICRA 2026 PaperCept program pages.

The public program uses repeated ``tr.pHdr`` elements.  Every paper's title,
author rows and optional abstract ``div#Ab<ID>`` are siblings that follow its
header.  This parser retains that DOM relationship instead of relying on a
fragile regular expression over the whole page.
"""

from __future__ import annotations

import argparse
import html
import json
import re
import sys
import unicodedata
from dataclasses import dataclass, field
from datetime import UTC, datetime
from html.parser import HTMLParser
from pathlib import Path
from typing import Iterable
from urllib.request import Request, urlopen


PROGRAM_BASE_URL = "https://ras.papercept.net/conferences/conferences/ICRA26/program/"
PROGRAM_INDEX_URL = f"{PROGRAM_BASE_URL}"
SOURCE_FILENAMES = (
    "ICRA26_ContentListWeb_3.html",
    "ICRA26_ContentListWeb_4.html",
    "ICRA26_ContentListWeb_5.html",
)
SOURCE_UPDATED_AT = "2026-06-08"
EXPECTED_TOTAL_ROWS = 2_951
EXPECTED_PEER_REVIEWED_COUNT = 2_820
EXPECTED_LBR_COUNT = 131
EXPECTED_INTERACTIVE_COUNT = 2_604
EXPECTED_ORAL_COUNT = 216


@dataclass
class Node:
    """A deliberately small HTML DOM node sufficient for PaperCept traversal."""

    tag: str
    attrs: dict[str, str] = field(default_factory=dict)
    children: list[Node | str] = field(default_factory=list)
    parent: Node | None = None

    def descendants(self) -> Iterable[Node]:
        for child in self.children:
            if isinstance(child, Node):
                yield child
                yield from child.descendants()

    def text(self) -> str:
        pieces: list[str] = []

        def visit(item: Node | str) -> None:
            if isinstance(item, str):
                pieces.append(item)
                return
            for nested in item.children:
                visit(nested)

        visit(self)
        return normalize_space(" ".join(pieces))


class PaperCeptHTMLParser(HTMLParser):
    """Build a minimal DOM while tolerating legacy PaperCept HTML."""

    VOID_TAGS = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "wbr"}

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.root = Node("document")
        self._stack: list[Node] = [self.root]

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        node = Node(tag.lower(), {key.lower(): value or "" for key, value in attrs}, parent=self._stack[-1])
        self._stack[-1].children.append(node)
        if tag.lower() not in self.VOID_TAGS:
            self._stack.append(node)

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        self.handle_starttag(tag, attrs)
        if tag.lower() not in self.VOID_TAGS:
            self.handle_endtag(tag)

    def handle_endtag(self, tag: str) -> None:
        tag = tag.lower()
        for index in range(len(self._stack) - 1, 0, -1):
            if self._stack[index].tag == tag:
                del self._stack[index:]
                return

    def handle_data(self, data: str) -> None:
        self._stack[-1].children.append(data)


def normalize_space(value: str) -> str:
    return " ".join(html.unescape(value).replace("\u00a0", " ").split())


def class_tokens(node: Node) -> set[str]:
    return set(node.attrs.get("class", "").split())


def direct_children(node: Node, tag: str | None = None) -> list[Node]:
    return [child for child in node.children if isinstance(child, Node) and (tag is None or child.tag == tag)]


def find_first(node: Node, *, tag: str | None = None, class_name: str | None = None, node_id: str | None = None) -> Node | None:
    for candidate in node.descendants():
        if tag is not None and candidate.tag != tag:
            continue
        if class_name is not None and class_name not in class_tokens(candidate):
            continue
        if node_id is not None and candidate.attrs.get("id") != node_id:
            continue
        return candidate
    return None


def all_matching(node: Node, *, tag: str | None = None, class_name: str | None = None) -> list[Node]:
    matched: list[Node] = []
    for candidate in node.descendants():
        if tag is not None and candidate.tag != tag:
            continue
        if class_name is not None and class_name not in class_tokens(candidate):
            continue
        matched.append(candidate)
    return matched


def normalized_identity(title: str, authors: list[dict[str, str]]) -> tuple[str, tuple[str, ...]]:
    """Create the required title + ordered author-surnames duplicate identity."""

    normalized_title = re.sub(r"[^a-z0-9]+", "", unicodedata.normalize("NFKD", title).lower())
    surnames = tuple(normalize_space(author["name"]).split(",", 1)[0].lower() for author in authors)
    return normalized_title, surnames


def paper_code(header_text: str) -> str:
    match = re.search(r"\bPaper\s+([A-Za-z0-9]+\.[0-9]+)\b", header_text)
    if not match:
        raise ValueError(f"Could not parse PaperCept paper code from header: {header_text!r}")
    return match.group(1)


def paper_session_type(code: str) -> str:
    session_code = code.rsplit(".", maxsplit=1)[0].upper()
    if "LB" in session_code:
        return "late_breaking_result"
    if re.search(r"(?:AT|BT)[0-9]*$", session_code):
        return "oral"
    if session_code.endswith("I"):
        return "interactive"
    raise ValueError(f"Unknown PaperCept session type for {code}")


def extract_keywords_and_abstract(detail: Node) -> tuple[list[str], str]:
    detail_text = detail.text()
    match = re.match(r"^Keywords:\s*(.*?)\s*Abstract:\s*(.*)$", detail_text, flags=re.DOTALL)
    if not match:
        return [], ""
    keywords = [normalize_space(keyword) for keyword in match.group(1).split(",") if normalize_space(keyword)]
    return keywords, normalize_space(match.group(2))


def parse_page(page_html: str, source_url: str) -> list[dict[str, object]]:
    """Parse one PaperCept content-list page using paper-header sibling traversal."""

    parser = PaperCeptHTMLParser()
    parser.feed(page_html)
    parser.close()

    headers = all_matching(parser.root, tag="tr", class_name="pHdr")
    papers: list[dict[str, object]] = []
    for header in headers:
        parent = header.parent
        if parent is None:
            raise ValueError("Paper header has no parent node")
        siblings = direct_children(parent, "tr")
        try:
            header_index = siblings.index(header)
        except ValueError as error:
            raise ValueError("Paper header is not a direct table sibling") from error

        following_rows = siblings[header_index + 1 :]
        next_header_index = next(
            (index for index, row in enumerate(following_rows) if "pHdr" in class_tokens(row)),
            len(following_rows),
        )
        record_rows = following_rows[:next_header_index]
        code = paper_code(header.text())
        title_toggle = next(
            (
                candidate
                for row in record_rows
                for candidate in all_matching(row, tag="a")
                if "viewAbstract" in candidate.attrs.get("onclick", "")
            ),
            None,
        )
        detail_id_match = re.search(
            r"viewAbstract\('([0-9]+)'\)",
            title_toggle.attrs.get("onclick", "") if title_toggle is not None else "",
        )
        detail_id = detail_id_match.group(1) if detail_id_match else None

        title_row = next((row for row in record_rows if find_first(row, class_name="pTtl")), None)
        if title_row is None:
            raise ValueError(f"Missing title row for {code}")
        title_node = find_first(title_row, class_name="pTtl")
        assert title_node is not None
        title = title_node.text()

        authors: list[dict[str, str]] = []
        for row in record_rows:
            author_link = next(
                (
                    candidate
                    for candidate in all_matching(row, tag="a")
                    if "AuthorIndexWeb.html" in candidate.attrs.get("href", "")
                ),
                None,
            )
            cells = direct_children(row, "td")
            if author_link is None or len(cells) < 2:
                continue
            authors.append({"name": author_link.text(), "affiliation": cells[1].text()})

        detail = find_first(parent, tag="div", node_id=f"Ab{detail_id}") if detail_id else None
        keywords, abstract = extract_keywords_and_abstract(detail) if detail is not None else ([], "")
        session_type = paper_session_type(code)
        papers.append(
            {
                "code": code,
                "title": title,
                "authors": authors,
                "affiliations": [author["affiliation"] for author in authors],
                "keywords": keywords,
                "abstract": abstract,
                "detail_anchor": f"#Ab{detail_id}" if detail_id else None,
                "official_summary_available": bool(keywords and abstract),
                "source_page": source_url,
                "session_type": session_type,
                "publication_kind": "conference_presentation",
            }
        )
    return papers


def validate_papers(papers: list[dict[str, object]], *, strict_counts: bool = True) -> dict[str, int]:
    """Check fields, PaperCept classification and title/author duplicate identity."""

    required_fields = ("code", "title", "authors", "source_page")
    for paper in papers:
        missing = [field_name for field_name in required_fields if not paper.get(field_name)]
        if missing:
            raise ValueError(f"{paper.get('code', '<unknown>')} is missing required fields: {', '.join(missing)}")
        if paper["publication_kind"] != "conference_presentation":
            raise ValueError(f"{paper['code']} has an invalid publication kind")

    identities: set[tuple[str, tuple[str, ...]]] = set()
    for paper in papers:
        identity = normalized_identity(str(paper["title"]), list(paper["authors"]))
        if identity in identities:
            raise ValueError(f"Duplicate normalized title and ordered author surnames: {paper['title']}")
        identities.add(identity)

    by_type = {
        "total_rows": len(papers),
        "late_breaking_results": sum(paper["session_type"] == "late_breaking_result" for paper in papers),
        "interactive": sum(paper["session_type"] == "interactive" for paper in papers),
        "oral": sum(paper["session_type"] == "oral" for paper in papers),
        "official_summaries_available": sum(bool(paper["official_summary_available"]) for paper in papers),
    }
    by_type["peer_reviewed_presentations"] = by_type["interactive"] + by_type["oral"]
    expected_counts = {
        "total_rows": EXPECTED_TOTAL_ROWS,
        "late_breaking_results": EXPECTED_LBR_COUNT,
        "interactive": EXPECTED_INTERACTIVE_COUNT,
        "oral": EXPECTED_ORAL_COUNT,
        "peer_reviewed_presentations": EXPECTED_PEER_REVIEWED_COUNT,
    }
    if strict_counts and any(by_type[key] != value for key, value in expected_counts.items()):
        raise ValueError(f"Unexpected ICRA 2026 program counts: {by_type}")
    return by_type


def download_page(source_url: str) -> str:
    request = Request(source_url, headers={"User-Agent": "research-blog-icra2026-scraper/1.0"})
    with urlopen(request, timeout=60) as response:
        return response.read().decode("cp1252")


def scrape_program(fetch=download_page) -> dict[str, object]:
    """Fetch the three official static pages and construct the saved dataset."""

    fetched_at = datetime.now(UTC).isoformat().replace("+00:00", "Z")
    source_pages = [f"{PROGRAM_BASE_URL}{filename}" for filename in SOURCE_FILENAMES]
    all_rows: list[dict[str, object]] = []
    for source_url in source_pages:
        all_rows.extend(parse_page(fetch(source_url), source_url))
    counts = validate_papers(all_rows)
    peer_reviewed = [paper for paper in all_rows if paper["session_type"] != "late_breaking_result"]
    return {
        "schema_version": 1,
        "conference": "ICRA 2026",
        "source_scope": "ICRA 2026 peer-reviewed conference presentations",
        "publication_kind": "conference_presentation",
        "source": {
            "program_index": PROGRAM_INDEX_URL,
            "source_pages": source_pages,
            "source_updated_at": SOURCE_UPDATED_AT,
            "fetched_at": fetched_at,
        },
        "counts": {
            "program_rows": counts["total_rows"],
            "paper_count": counts["peer_reviewed_presentations"],
            "excluded_late_breaking_results": counts["late_breaking_results"],
            "interactive_presentations": counts["interactive"],
            "oral_presentations": counts["oral"],
            "official_summaries_available": sum(bool(paper["official_summary_available"]) for paper in peer_reviewed),
            "official_summaries_missing": sum(not bool(paper["official_summary_available"]) for paper in peer_reviewed),
        },
        "papers": peer_reviewed,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("data/icra2026/papers.json"),
        help="Path for the reproducible structured snapshot.",
    )
    args = parser.parse_args()
    dataset = scrape_program()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(dataset, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(
        f"Saved {dataset['counts']['paper_count']} peer-reviewed presentations to {args.output} "
        f"after excluding {dataset['counts']['excluded_late_breaking_results']} Late Breaking Results."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
