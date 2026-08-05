from __future__ import annotations

import sys
import unittest
from pathlib import Path


SCRIPT_DIRECTORY = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SCRIPT_DIRECTORY))

from scrape import parse_page, paper_session_type, validate_papers  # noqa: E402


PAGE = """
<table>
  <tr class="pHdr"><td><a>09:00, Paper TuAT.1</a></td></tr>
  <tr><td><span class="pTtl"><a onclick="viewAbstract('11')">A Robot Data Paper</a></span></td></tr>
  <tr><td><a href="ICRA26_AuthorIndexWeb.html#1">Doe, Jane</a></td><td>Lab A</td></tr>
  <tr><td><a href="ICRA26_AuthorIndexWeb.html#2">Smith, John</a></td><td>Lab B</td></tr>
  <tr><td><div id="Ab11"><strong>Keywords:</strong> Imitation Learning, Tactile<br><strong>Abstract:</strong> A policy uses real robot data.</div></td></tr>
  <tr class="pHdr"><td><a>10:00, Paper TuLBI.2</a></td></tr>
  <tr><td><span class="pTtl"><a onclick="viewAbstract('12')">Late Result</a></span></td></tr>
  <tr><td><a href="ICRA26_AuthorIndexWeb.html#3">Roe, Jane</a></td><td>Lab C</td></tr>
  <tr><td><div id="Ab12"><strong>Keywords:</strong> Dataset<br><strong>Abstract:</strong> Late abstract.</div></td></tr>
</table>
"""


class ScraperTest(unittest.TestCase):
    def test_parse_paper_siblings_and_keep_author_affiliation_order(self) -> None:
        papers = parse_page(PAGE, "https://example.test/page.html")
        self.assertEqual([paper["code"] for paper in papers], ["TuAT.1", "TuLBI.2"])
        self.assertEqual(papers[0]["session_type"], "oral")
        self.assertEqual(papers[1]["session_type"], "late_breaking_result")
        self.assertEqual(papers[0]["authors"], [{"name": "Doe, Jane", "affiliation": "Lab A"}, {"name": "Smith, John", "affiliation": "Lab B"}])
        self.assertEqual(papers[0]["keywords"], ["Imitation Learning", "Tactile"])
        self.assertEqual(papers[0]["detail_anchor"], "#Ab11")
        self.assertTrue(papers[0]["official_summary_available"])

    def test_session_type(self) -> None:
        self.assertEqual(paper_session_type("ThBT1.3"), "oral")
        self.assertEqual(paper_session_type("WeI2I.4"), "interactive")
        self.assertEqual(paper_session_type("ThLBRI.5"), "late_breaking_result")

    def test_validation_rejects_duplicate_identity(self) -> None:
        papers = parse_page(PAGE, "https://example.test/page.html")
        duplicate = dict(papers[0])
        duplicate["code"] = "TuI1I.99"
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            validate_papers([papers[0], duplicate], strict_counts=False)


if __name__ == "__main__":
    unittest.main()
