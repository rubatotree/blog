#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "SIGGRAPH 2026 论文笔记 III: Monte Carlo PDE & 几何",
  date: datetime(year: 2026, month: 5, day: 29),
  weight: 0,
  tags: (
    category: ("计算机图形学", "Monte Carlo PDE", "Geometry", "论文笔记")
  ),
  draft: false,
  references: ```bib

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
@article{wu2026gradient,
  author = {Wu, Jiaqi and Hu, Xuejun and Zhao, Shuang and Xu, Kun},
  title = {Gradient Domain Reconstruction for Monte Carlo PDE Solvers},
  journal = {ACM Transactions on Graphics},
  volume = {45},
  number = {4},
  articleno = {130},
  numpages = {11},
  year = {2026},
  month = {July},
  doi = {10.1145/3811295},
  publisher = {Association for Computing Machinery}
}
@misc{bao2026montecarlopdesolvers,
  title={Monte Carlo PDE Solvers for Nonlinear Radiative Boundary Conditions}, 
  author={Anchang Bao and Enya Shen and Jianmin Wang},
  year={2026},
  eprint={2604.21717},
  archivePrefix={arXiv},
  primaryClass={cs.GR},
  url={https://arxiv.org/abs/2604.21717}, 
}
@article{Feng2026PAT,
  author = {Feng, Nicole and Gkioulekas, Ioannis and Crane, Keenan},
  title = {Points as Tori: Fast Pointwise Signed Distance for Point Clouds},
  year = {2026},
  issue_date = {August 2026},
  publisher = {Association for Computing Machinery},
  address = {New York, NY, USA},
  volume = {45},
  number = {4},
  issn = {XXXX-XXXX},
  url = {https://doi.org/10.1145/3811385},
  doi = {10.1145/3811385},
  journal = {ACM Trans. Graph.},
  month = {jul},
  articleno = {53},
  numpages = {24}
}
@misc{wang2026manifoldknnacceleratedknn,
  title={Manifold k-NN: Accelerated k-NN Queries for Manifold Point Clouds}, 
  author={Pengfei Wang and Qinghao Guo and Haisen Zhao and Shiqing Xin and Shuangmin Chen and Changhe Tu and Wenping Wang},
  year={2026},
  eprint={2605.02224},
  archivePrefix={arXiv},
  primaryClass={cs.CG},
  url={https://arxiv.org/abs/2605.02224}, 
}
@article{lazybrush,
  author = {Sýkora, Daniel and Dingliana, John and Collins, Steven},
  title = {LazyBrush: Flexible Painting Tool for Hand-drawn Cartoons},
  journal = {Computer Graphics Forum},
  volume = {28},
  number = {2},
  pages = {599-608},
  keywords = {Computer Graphics I.3.4: Graphics Utilities—Graphics editors, Image Processing and Computer Vision I.4.6: Segmentation—Pixel classification, Computer Applications J.5: Arts and Humanities—Fine arts},
  doi = {https://doi.org/10.1111/j.1467-8659.2009.01400.x},
  url = {https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1467-8659.2009.01400.x},
  eprint = {https://onlinelibrary.wiley.com/doi/pdf/10.1111/j.1467-8659.2009.01400.x},
  abstract = {Abstract In this paper we present LazyBrush, a novel interactive tool for painting hand-made cartoon drawings and animations. Its key advantage is simplicity and flexibility. As opposed to previous custom tailored approaches [SBv05, QWH06] LazyBrush does not rely on style specific features such as homogenous regions or pattern continuity yet still offers comparable or even less manual effort for a broad class of drawing styles. In addition to this, it is not sensitive to imprecise placement of color strokes which makes painting less tedious and brings significant time savings in the context cartoon animation. LazyBrush originally stems from requirements analysis carried out with professional ink-and-paint illustrators who established a list of useful features for an ideal painting tool. We incorporate this list into an optimization framework leading to a variant of Potts energy with several interesting theoretical properties. We show how to minimize it efficiently and demonstrate its usefulness in various practical scenarios including the ink-and-paint production pipeline.},
  year = {2009}
}
  ```,
)

= 1. Monte Carlo PDE

== Probe-based Walk on Spheres for Efficient Path Reusing [#link("https://t7imal.github.io/projects/2026wop/", "Project")]
#image("/images/sig26-paper-notes/WoP-teaser.png")
#emph[我自己的文章。]

利用路径信息重用高效优化 Walk on Spheres 系列算法。

考虑到 Walk on Spheres 的采样过程，每一步都要在球面上均匀采样一个点作为该点解值的一个无偏估计。由 Off-center 形式的平均值公式可以得到实际上在球内的偏心点按 Poisson Kernel 分布在球面上采样一个点得到的结果也是解值的无偏估计。因此 WoS 均匀采样得到的解值可以为球内每个点所重用，在算法上就是得到一条完整路径后将求解值 Splat 回路径上的每个球内。这个算法被我们称为 Naive Path Reuse，不清楚现在 sig 上那篇 Talking to Neighbors 有没有扩展成这样的形式。

#figure(
  caption: "我们的 Naive Path Reuse 算法",
  image("/images/sig26-paper-notes/wop_path_reuse.png"),
) <fig-wop-path-reuse>

然后考虑到这样 Splat 的开销过于大（球内每个点都需要查询并访存一次），正好 25 年 11 月又出来了 Harmonic Caching 的文章，发现后者正好可以将 Splat 的任务转化为求解几个 Fourier 系数的任务。因此和 HC 类似地在求解域预放置一些探针球，游走时取一个探针球做 Poisson Kernel 采样找到边界，若不存在探针球就 Fallback 到传统的 WoSt 算法，可以验证这个行为仍然是满足布朗运动的。找到 Dirichlet 边界后就将求解到的结果送回探针球中贡献 Fourier 系数。然后就非常快了。

#figure(
  caption: "我们的 Walk on Probes 算法",
  image("/images/sig26-paper-notes/wop_algorithm.png"),
) <fig-wop-algorithm>

当时这篇文章的 idea 成形已经是 11 月底了，只有两个月的时间做，临近交稿的时候还有各种 ddl 和期末考试，压力巨大。还好做完了，如果再晚半年就要和这些新的方差缩减算法比了，甚至要和 Best Paper 比，好可怕。今后还会继续做 Monte Carlo PDE 吗，不知道，既然能有想法就去做吧。

== Walk on Decomposed Subdomains: A Hybrid Monte Carlo–Deterministic Solver for Elliptic PDEs @wods [#link("https://clementjambon.github.io/wods/index.html", "Project")]
#image("/images/sig26-paper-notes/wods.png")
#emph[今年 Best Paper，太猛了]

通过空间划分解决 WoSt 路径过长的问题，从而高效提升速度。

为了避免常规 Walk on Stars 路径过长的问题，该方法把求解域分为了网格状子域，用虚拟的 Dirichlet 边界分开，逐个求解再合并，这样每个子区域都是 Dirichlet 为主的区域，就易于求解了。

论文内容量好大，做了超级多的实验和探索。总觉得自己也想到过类似的方法，但没能落地到这么实在的程度。

TODO

== Gradient Domain Reconstruction for Monte Carlo PDE Solvers @wu2026gradient [#link("https://jiaoplusjuan.github.io/GDMCPDE.html", "Project")]
#image("/images/sig26-paper-notes/wu2026gradient.png")
#emph[今年 Best Paper Honorable Mentioned，大家都好厉害]

TODO

== Monte Carlo PDE Solvers for Nonlinear Radiative Boundary Conditions @bao2026montecarlopdesolvers [#link("https://arxiv.org/abs/2604.21717", "ArXiv")]
#image("/images/sig26-paper-notes/bao2026montecarlopdesolvers.png")

TODO

= 2. Geometry

== Points as Tori: Fast Pointwise Signed Distance for Point Clouds @Feng2026PAT [#link("https://nzfeng.github.io/research/PointsAsTori/", "Project")]
#image("/images/sig26-paper-notes/Feng2026PAT.png")

#emph[甜甜圈统治世界！这篇真好玩。目前为止最喜欢的一篇。]

本文通过预计算对带法线的点云高效求 SDF。

对每个点预计算出一个局部的环面 (Tori) 表示其邻域的 Geometry，从而就能把点云修补成完备且有解析 SDF 的曲面。求 SDF 时先筛出一些最近邻点，加权取 SDF 值。本文还提出了一些自归一化权重来避免特殊情况产生的误差。

选取环面的原因是，在有解析 SDF 表达式的图元中，环面上曲率的分布非常丰富，因此能很好地表示各类二阶微分的邻域。这个思路太神奇好玩了。

预计算环面参数的方法居然是直接把邻域所有点丢进 Transformer 中吐出来，这一步也很惊人，直觉上一般都会用低鲁棒性的最小二乘法的。这才是变压器的正确使用方法吗。

本文的主页上还有很多很有趣的讨论，诸如为什么选用环面、为什么要用基于学习的方法、为什么不用端到端的学习方法、和其它方法相比有什么优势，几乎都是一些设计哲学问题。感觉这才是所谓理性地使用 AI-based 方法，看这篇的时候完全不会有“AI 来了图形学要完蛋了”的焦虑，反而是一种，“噢，这个设计真有趣，我相信它”的畅快感。

== Manifold k-NN: Accelerated k-NN Queries for Manifold Point Clouds @wang2026manifoldknnacceleratedknn [#link("https://arxiv.org/abs/2605.02224", "ArXiv")]

TODO

= 3. 这段时间读到的一些非 SIG26 文章补充

== LazyBrush: Flexible Painting Tool for Hand-drawn Cartoons @lazybrush (EG 2008)
#image("/images/sig26-paper-notes/lazybrush.png") 

老文章。启发式解决非封闭线稿填色的问题，现在该方法被用在了 Krita 中。

该文章想处理的交互逻辑如上图中间，用一笔选择想要填色的区域内部，即可得到右图这样，线稿内部完美填色，而线稿外部漏出的区域自动被修正掉。该文章将不完美填色问题建模成一个能量优化问题。能量函数由定义在两像素之间连边上的平滑项 $V_(p,q)$ 和像素点上的数据项 $D_p$ 组成。填色区域的边界会贡献平滑项，而一部分内部像素点会贡献数据项。

平滑项 $V_(p,q)$ 用于找到一条合适的边界，定义为和 $p$ 点的亮度正相关，使得在较亮的区域（线稿内部）切换颜色会有较高的代价，而鼓励在较暗的区域（单根线的“中心”区域）切换颜色。这样的能量会鼓励填色区域不断“膨胀”直到被其所在的线稿区域的线条中心约束住，同时也会约束填色区域在线稿不封闭的小缝隙不漏出来。（边界跨过较窄的缝隙，贡献的能量会低于跨过外部更宽的缝隙）算法会像水流寻找地势最低处一样，寻找一条总光度值最低（最黑）的路径来强行连接断开的线条。

数据项 $D_p$ 用于修正填色时溢出边界的部分，定义为如果一个像素被用户指定需要填色但实际算法决定不填色时，贡献一个常数能量。这意味着如果填满一个溢出区域边界贡献的能量比删掉这一块区域的能量还高（小区域填满了大边界），不如直接删去这一块。

具体的求解算法为图论的算法，就不在这里讨论了。老一辈图形学人的启发式方法还是漂亮，可惜目前除了 Krita 好像就没在别的软件里看到过了（Procreate 什么时候才能有！）不知道现代图形学的问题里会不会有类似这样“填色”的需求。