from __future__ import annotations

import json
import sys
import unittest
from pathlib import Path


SCRIPT_DIRECTORY = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SCRIPT_DIRECTORY))

from select_candidates import select_candidates  # noqa: E402


class CandidateSelectionTest(unittest.TestCase):
    def test_requires_taxonomy_learning_and_robot_context(self) -> None:
        config = json.loads((SCRIPT_DIRECTORY / "selection.json").read_text(encoding="utf-8"))
        dataset = {
            "papers": [
                {
                    "code": "TuI1I.1",
                    "title": "Tactile Sensor Dataset Augmentation for Robot Imitation Learning",
                    "keywords": ["Tactile Sensing"],
                    "abstract": "We train a manipulation policy with real robot demonstrations.",
                    "official_summary_available": True,
                },
                {
                    "code": "TuI1I.2",
                    "title": "SLAM Dataset for Localization",
                    "keywords": ["SLAM"],
                    "abstract": "A learning method improves mapping.",
                    "official_summary_available": True,
                },
                {
                    "code": "TuI1I.3",
                    "title": "A Robot Dataset",
                    "keywords": ["Dataset"],
                    "abstract": "This paper describes hardware without a learning method.",
                    "official_summary_available": True,
                },
            ]
        }
        candidates = select_candidates(dataset, config)
        self.assertEqual([candidate["code"] for candidate in candidates], ["TuI1I.1"])
        self.assertGreaterEqual(candidates[0]["suggested_manual_score"], 5)


if __name__ == "__main__":
    unittest.main()
