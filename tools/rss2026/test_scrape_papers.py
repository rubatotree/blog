from __future__ import annotations

import unittest

from scrape_papers import DetailPageParser, parse_seeds


class ScraperParserTests(unittest.TestCase):
    def test_parse_list_rows(self) -> None:
        html = """
        <table>
          <tr session="Manipulation &amp; 1">
            <td><a href="/program/papers/7/"><b>Example &amp; Paper</b></a></td>
          </tr>
        </table>
        """
        seeds = parse_seeds(html, "https://roboticsconference.org")
        self.assertEqual(len(seeds), 1)
        self.assertEqual(seeds[0].paper_id, 7)
        self.assertEqual(seeds[0].title, "Example & Paper")
        self.assertEqual(seeds[0].session, "Manipulation & 1")
        self.assertEqual(seeds[0].detail_url, "https://roboticsconference.org/program/papers/7/")

    def test_parse_detail_page(self) -> None:
        html = """
        <h3 class="page-title"><b>A Robot Paper</b></h3>
        <div class="paper-author-name">Ada Lovelace, Grace Hopper</div>
        <div class="paper-pdf"><a href="https://www.roboticsproceedings.org/rss22/p007.pdf" title="Download PDF">PDF</a></div>
        <h3 id="paper-id-7">Paper ID 7</h3>
        <h3 id="session-manipulation-1"><a>Session Manipulation 1</a></h3>
        <p style="color:gray; font-size: 120%;"><b>Abstract: </b>A concise abstract with <b>markup</b>.</p>
        """
        parser = DetailPageParser()
        parser.feed(html)
        seed = parse_seeds(
            '<tr session="Manipulation 1"><a href="/program/papers/7/"><b>A Robot Paper</b></a></tr>',
            "https://roboticsconference.org",
        )[0]
        paper = parser.result(seed, "https://roboticsconference.org")
        self.assertEqual(paper.paper_id, 7)
        self.assertEqual(paper.authors, ["Ada Lovelace", "Grace Hopper"])
        self.assertEqual(paper.session, "Manipulation 1")
        self.assertEqual(paper.abstract, "A concise abstract with markup.")
        self.assertTrue(paper.pdf_url.endswith("p007.pdf"))


if __name__ == "__main__":
    unittest.main()
