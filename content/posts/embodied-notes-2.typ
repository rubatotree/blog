#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "图形已死，all in AI具身 II: 机器人会梦到怎样的现实呢",
  date: datetime(year: 2026, month: 6, day: 7),
  weight: 0,
  tags: (
    category: ("计算机图形学", "具身智能", "Rendering", "Monte Carlo PDE", "论文笔记")
  ),
  draft: false,
  references: ```bib
@misc{park2026rendermemrenderingspatialmemory,
      title={RenderMem: Rendering as Spatial Memory Retrieval}, 
      author={JooHyun Park and HyeongYeop Kang},
      year={2026},
      eprint={2603.14669},
      archivePrefix={arXiv},
      primaryClass={cs.AI},
      url={https://arxiv.org/abs/2603.14669}, 
}
@misc{muchacho2024walkspherespdebasedpath,
      title={Walk on Spheres for PDE-based Path Planning}, 
      author={Rafael I. Cabral Muchacho and Florian T. Pokorny},
      year={2024},
      eprint={2406.01713},
      archivePrefix={arXiv},
      primaryClass={cs.RO},
      url={https://arxiv.org/abs/2406.01713}, 
}
@article{wods,
  author     = {Jambon, Cl\'{e}ment and Nabizadeh, Mohammad Sina and Konakovi\'{c} Lukovi\'{c}, Mina},
  title      = {Walk on Decomposed Subdomains: A Hybrid Monte Carlo–Deterministic Solver for Elliptic PDEs},
  year       = {2026},
  issue_date = {July 2026},
  publisher  = {Association for Computing Machinery},
  address    = {New York, NY, USA},
  volume     = {45},
  number     = {4},
  url        = {https://doi.org/10.1145/3811340},
  doi        = {10.1145/3811340},
  journal    = {ACM Trans. Graph.},
  month      = jul,
  articleno  = {132},
  numpages   = {22}
}
@misc{heskey0zhihuembodied,
  title={具身智能 - 9 个方向讲透 2025-2026 灵巧手智能},
  author={Heskey0},
  year={2026},
  url={https://zhuanlan.zhihu.com/p/2046746760459171551},
}
  ```,
)

#figure(
  caption: "玩音乐的最终归宿是转行具身智能。",
  image("/images/embodied-notes-2/teaser.png"),
) <fig-robosplat-teaser>

TODO