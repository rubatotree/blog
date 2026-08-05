"""Create an auditable high-recall shortlist from the ICRA 2026 snapshot."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


def normalized_text(paper: dict[str, Any]) -> str:
    return " ".join(
        [paper["title"], " ".join(paper["keywords"]), paper["abstract"]]
    ).lower()


def title_and_keywords_text(paper: dict[str, Any]) -> str:
    """Use explicit metadata, not incidental abstract prose, for lifecycle recall."""

    return " ".join([paper["title"], " ".join(paper["keywords"])]).lower()


def matches(text: str, terms: list[str]) -> list[str]:
    return [term for term in terms if term.lower() in text]


def candidate_score(text: str, category_matches: dict[str, list[str]], config: dict[str, Any]) -> tuple[int, dict[str, bool]]:
    """Score the explicit 0--7 manual-audit rubric with textual evidence only."""

    lifecycle = bool(category_matches)
    reusable = bool(matches(text, ["dataset", "benchmark", "data collection", "data generation", "augmentation", "synthetic", "teleoperation", "demonstration"]))
    downstream = bool(matches(text, ["policy", "control", "imitation learning", "reinforcement learning", "robot learning", "execution"]))
    real_evidence = bool(matches(text, ["real robot", "real-world", "physical robot", "hardware", "on a robot"]))
    evidence = {
        "lifecycle_contribution": lifecycle,
        "reusable_dataset_or_generation": reusable,
        "downstream_policy_or_control": downstream,
        "real_data_or_robot_evidence": real_evidence,
    }
    score_config = config["selection_policy"]["manual_score"]
    score = sum(score_config[key] for key, present in evidence.items() if present)
    return score, evidence


def select_candidates(dataset: dict[str, Any], config: dict[str, Any]) -> list[dict[str, Any]]:
    """Apply the two-pass recall filter; this is not the final editorial selection."""

    candidates: list[dict[str, Any]] = []
    for paper in dataset["papers"]:
        # The post's Chinese summaries are constrained to official abstracts.
        if not paper.get("official_summary_available", bool(paper.get("abstract"))):
            continue
        text = normalized_text(paper)
        lifecycle_text = title_and_keywords_text(paper)
        if matches(text, config["excluded_terms"]):
            continue
        category_matches = {
            category: matches(lifecycle_text, terms)
            for category, terms in config["taxonomy"].items()
            if matches(lifecycle_text, terms)
        }
        learning_matches = matches(text, config["learning_mechanism_terms"])
        robot_matches = matches(text, config["robot_context_terms"])
        if not (category_matches and learning_matches and robot_matches):
            continue
        score, evidence = candidate_score(text, category_matches, config)
        if score < config["selection_policy"]["shortlist_score_minimum"]:
            continue
        candidates.append(
            {
                "code": paper["code"],
                "title": paper["title"],
                "source_page": paper.get("source_page"),
                "detail_anchor": paper.get("detail_anchor"),
                "suggested_categories": list(category_matches),
                "taxonomy_matches": category_matches,
                "learning_matches": learning_matches,
                "robot_context_matches": robot_matches,
                "suggested_manual_score": score,
                "score_evidence": evidence,
            }
        )
    return sorted(candidates, key=lambda item: (-item["suggested_manual_score"], item["code"]))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data", type=Path, default=Path("data/icra2026/papers.json"))
    parser.add_argument("--config", type=Path, default=Path("tools/icra2026/selection.json"))
    parser.add_argument("--output", type=Path, default=Path("data/icra2026/candidates.json"))
    args = parser.parse_args()
    dataset = json.loads(args.data.read_text(encoding="utf-8"))
    config = json.loads(args.config.read_text(encoding="utf-8"))
    candidates = select_candidates(dataset, config)
    payload = {
        "source_scope": dataset["source_scope"],
        "method": config["selection_policy"],
        "candidate_count": len(candidates),
        "candidates": candidates,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Saved {len(candidates)} high-recall candidates to {args.output}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
