#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "SIGGRAPH 2026 论文笔记 I",
  date: datetime(year: 2026, month: 5, day: 27),
  weight: 0,
  tags: (
    category: "计算机图形学"
  ),
  draft: false,
  references: ```bib
@article{Rijsdijk2026GaussianPointSplatting,
  title = {Gaussian Point Splatting},
  author = {Rijsdijk, Joris and Peters, Christoph and Weinnman, Michael and Marroquim, Ricardo},
  journal = {ACM Trans. Graph.},
  volume = {45},
  number = {4},
  publisher = {Association for Computing Machinery},
  year = {2026},
  doi = {10.1145/3811272}
}
@misc{xu2026Stoch3DGS,
  title        = {Stochastic Ray Tracing for the Reconstruction of 3D Gaussian Splatting},
  author       = {Peiyu Xu and Xin Sun and Krishna Mullia and Raymond Fei and Iliyan Georgiev and Shuang Zhao},
  year         = {2026},
  eprint       = {2603.23637},
  archivePrefix= {arXiv},
  primaryClass = {cs.CV},
  url          = {https://arxiv.org/abs/2603.23637}
}
@misc{niedermayr2025lightweightgradientawareupscaling3d,
  title={Lightweight Gradient-Aware Upscaling of 3D Gaussian Splatting Images}, 
  author={Simon Niedermayr and Christoph Neuhauser Rüdiger Westermann},
  year={2025},
  eprint={2503.14171},
  archivePrefix={arXiv},
  primaryClass={cs.CV},
  url={https://arxiv.org/abs/2503.14171}, 
}
@article{West2026,
  author = {West, Rex and Mukherjee, Sayan and Yue, Yonghao},
  title = {Lifting Lines and Tone: Image-space Stylization in Path-space},
  journal = {ACM Transactions on Graphics},
  volume = {45},
  number = {4 (Proc. of SIGGRAPH 2026)},
  year = {2026},
  articleno = {138},
  numpages = {15},
  doi = {10.1145/3811359}
}
@article{FiberLevel,
author = {Li, Zixuan and Shen, Pengfei and Sun, Hanxiao and Zhang, Zibo and Guo, Yu and Liu, Ligang and Yan, Lingqi and Marschner, Steve and Hasan, Milos and Wang, Beibei},
title = {Fiber-level Woven Fabric Capture from a Single Microscopic Image},
year = {2026},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
issn = {0730-0301},
url = {https://doi.org/10.1145/3816036},
doi = {10.1145/3816036},
note = {Just Accepted},
journal = {ACM Trans. Graph.},
month = may,
keywords = {fabric capture, fabric rendering, fiber-level}
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
@inproceedings{huang2022hdr,
  title={Hdr-nerf: High dynamic range neural radiance fields},
  author={Huang, Xin and Zhang, Qi and Feng, Ying and Li, Hongdong and Wang, Xuan and Wang, Qing},
  booktitle={Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition},
  pages={18398--18408},
  year={2022}
}
@misc{martinbrualla2021nerfwildneuralradiance,
  title={NeRF in the Wild: Neural Radiance Fields for Unconstrained Photo Collections}, 
  author={Ricardo Martin-Brualla and Noha Radwan and Mehdi S. M. Sajjadi and Jonathan T. Barron and Alexey Dosovitskiy and Daniel Duckworth},
  year={2021},
  eprint={2008.02268},
  archivePrefix={arXiv},
  primaryClass={cs.CV},
  url={https://arxiv.org/abs/2008.02268}, 
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

WIP

= 3D Gaussians

== Gaussian Point Splatting @Rijsdijk2026GaussianPointSplatting [#link("https://jorisar.nl/gaussian_point_splatting/", "Project")]
#image("/images/sig26-paper-notes-1/Rijsdijk2026GaussianPointSplatting.png")

本文用蒙特卡洛方法代替深度排序，加速了超大 3DGS 场景在 GPU 上的正向渲染过程。目前仅支持正向渲染。

本文注意到单个 Gaussian Splat 到屏幕空间的行为可以等价于在屏幕空间上按一个 Gaussian 分布放回采样 $N$ 个点的结果的期望（$N$ 和 Gaussian 的参数相关）。而一系列 Gaussians 做 Alpha Blending 的行为可以等价于，对每个 Gaussian $G_i$ 采样 $N_i$ 个点，然后对每个像素取深度上最靠前的点 $min_(d^j) c_x^j$ 作为 Splat 结果的无偏估计值。

一方面该方法优化掉了每个 Tile 都要 GPU 排序的瓶颈，优化到了关于 Gaussian 数量的线性复杂度，还可以通过遮挡剔除等方式进一步剪枝。另一方面这个过程还可以高度并行化，取 $min_(d^j) c_x^j$ 的操作也只需要在屏幕空间缓冲区做一个很高效的原子查询+覆盖，因此跑起来就很快。

由于其将深度排序行为替换成了蒙特卡洛方法，它还天然支持渲染出 3DGRT 特有的 “Gaussian 穿插”行为，避免了相机移动时的 Popping 现象。这种 Splatting 方法似乎是可以做到和 3DGRT 管线一致的（3DGRT 管线可能被迫在射线相交的高斯球过多时放弃靠后的高斯球，但这一方面影响不大，另一方面也可以用随机终止 @xu2026Stoch3DGS 代替 Alpha Blending 做到一致无偏）。

#figure(
  caption: "Popping 行为和穿插行为",
  image("/images/sig26-paper-notes-1/gaussian-popping.png"),
) <fig-popping>


论文提到可微渲染的困难主要有：$N_i$ 是整数，关于 Gaussian 的位姿和密度不可微；$min$ 操作不可微；可微难以做到 $O(1)$ 空间复杂度。

这篇的效率瓶颈主要在原子操作互斥锁、采样 Gaussians 时的显存吞吐、分布本身缺陷造成大 Gaussians 生成过多采样点拖慢效率等。对于这些问题本文都用了一些策略去应对。对于采样过程论文提到计算 CDF 并二分的方法比用别名法要快，每次相机移动都会改变所有 Gaussian 的 $N_i$ 分布的确是个麻烦事。

本文和 Stochastic Ray Tracing for the Reconstruction of 3D Gaussian Splatting @xu2026Stoch3DGS 同属于用 Monte Carlo 概率方法优化 3D Gaussian Primitive 渲染的方法。区别在于后一篇是基于 3DGRT 管线直接用 Monte Carlo 方法代替了 排序 + Alpha Blending 的过程，保持可微，效率瓶颈仍在求交；而该论文提出了一种比较新的 Splatting 方式，不需要求交、排序等操作，但仅支持正向渲染。二者每 spp 的像素颜色分布也有所不同。

由于这篇和 Stochastic 3DGRT 一起将随机深度采样的方法变成了最高效的 3D Gaussian Primitives 正向渲染方法，基于低 spp 渲染结果先验的降噪工作可能会变得更加重要。

== Mobile3DGS³: Accelerate Mobile 3DGS Rendering via Gradient-Aware Super-Sampling and Frame Interpolation
#image("/images/sig26-paper-notes-1/Mobile3DGS3.png")

#emph[曾经助教、现好朋友 #link("https://github.com/SyouSanGin", "@SyouSanGin") 的第一篇 SIGGRAPH，靠内部关系拿到了文章。]

本文做的是 3DGS 的超分。主要是观察到 3DGS 的屏幕空间梯度可以提前计算并缓存，在 0.25x 分辨率渲染时 Splat 颜色的同时也 Splat 每个像素的梯度信息，进一步做像素间多项式样条插值，即可在更快的速度内得到高质量的正向渲染结果。

由于 3DGS 在图像空间的渲染结果本来就是比较光滑的（受到 3DGS 基元大小的限制，还受到训练集分辨率的限制），因此样条插值效果就很好。

据原作者所说，后期的神经网络图像调优和帧间插值在本文的方法中贡献并不大。作者也测试过用二阶微分信息进一步优化插值的信息量，但并没有明显提升。

过去的渲染超分方法（不限于 GS）普遍需要 GBuffer 作为网络的补充信息，而本文面对 3DGS 的任务当然是没有 GBuffer 的，合理利用已有信息量（像素点的微分信息）对邻域进行插值是相当漂亮的思路。在 25 年 11 月该文作者发现有一篇 ArXiv 论文 @niedermayr2025lightweightgradientawareupscaling3d 和他的思路撞了。但这篇提出了切空间梯度缓存的方法并且在工程上实现在了 GPU+NPU 上，在效率上做到了 make sense。

很喜欢这种充分挖掘并高效利用信息量，而不是靠神经网络去暴力发现信息的规律的工作。

= Rendering

== Lifting Lines and Tone: Image-space Stylization in Path-space @West2026 [#link("http://www.cg.it.aoyama.ac.jp/yonghao/sig26/abstsig26.html", "Project")]
#image("/images/sig26-paper-notes-1/West2026.png")

TODO

== Fiber-level Woven Fabric Capture from a Single Microscopic Image @FiberLevel
#image("/images/sig26-paper-notes-1/FiberLevel.png")
#emph[另一位助教的文章之一。]

TODO

== PureSample: Neural Materials Learned by Sampling Microgeometry [#link("https://arxiv.org/abs/2508.07240", "ArXiv")]
#image("/images/sig26-paper-notes-1/PureSample.png")

TODO

== Multi-feature Radiance Baking Neural Networks for Instant Volumetric Rendering
#image("/images/sig26-paper-notes-1/MRBNN.png")
#emph[好感动，MRPNN 的优化也被做出来了。同样是靠内部关系拿到的文章。]

TODO

= Monte Carlo PDE

== Probe-based Walk on Spheres for Efficient Path Reusing
#image("/images/sig26-paper-notes-1/WoP-teaser.png")
#emph[自己的文章，嘿嘿]

TODO

== Walk on Decomposed Subdomains: A Hybrid Monte Carlo–Deterministic Solver for Elliptic PDEs @wods [#link("https://clementjambon.github.io/wods/index.html", "Project")]
#image("/images/sig26-paper-notes-1/wods.png")
#emph[今年 Best Paper，太猛了]

TODO

== Gradient Domain Reconstruction for Monte Carlo PDE Solvers @wu2026gradient [#link("https://jiaoplusjuan.github.io/GDMCPDE.html", "Project")]
#image("/images/sig26-paper-notes-1/wu2026gradient.png")
#emph[今年 Best Paper Honorable Mentioned，大家都好厉害]

TODO

== Monte Carlo PDE Solvers for Nonlinear Radiative Boundary Conditions @bao2026montecarlopdesolvers [#link("https://arxiv.org/abs/2604.21717", "ArXiv")]
#image("/images/sig26-paper-notes-1/bao2026montecarlopdesolvers.png")

TODO

= Geometry

== Points as Tori: Fast Pointwise Signed Distance for Point Clouds @Feng2026PAT [#link("https://nzfeng.github.io/research/PointsAsTori/", "Project")]
#image("/images/sig26-paper-notes-1/Feng2026PAT.png")

#emph[甜甜圈统治世界！这篇真好玩。目前为止最喜欢的一篇。]

本文通过预计算对带法线的点云高效求 SDF。

对每个点预计算出一个局部的环面 (Tori) 表示其邻域的 Geometry，从而就能把点云修补成完备且有解析 SDF 的曲面。求 SDF 时先筛出一些最近邻点，加权取 SDF 值。本文还提出了一些自归一化权重来避免特殊情况产生的误差。

选取环面的原因是，在有解析 SDF 表达式的图元中，环面上曲率的分布非常丰富，因此能很好地表示各类二阶微分的邻域。这个思路太神奇好玩了。

预计算环面参数的方法居然是直接把邻域所有点丢进 Transformer 中吐出来，这一步也很惊人，直觉上一般都会用低鲁棒性的最小二乘法的。这才是变压器的正确使用方法吗。

本文的主页上还有很多很有趣的讨论，诸如为什么选用环面、为什么要用基于学习的方法、为什么不用端到端的学习方法、和其它方法相比有什么优势，几乎都是一些设计哲学问题。感觉这才是所谓理性地使用 AI-based 方法，看这篇的时候完全不会有“AI 来了图形学要完蛋了”的焦虑，反而是一种，“噢，这个设计真有趣，我相信它”的畅快感。

== Manifold k-NN: Accelerated k-NN Queries for Manifold Point Clouds @wang2026manifoldknnacceleratedknn [#link("https://arxiv.org/abs/2605.02224", "ArXiv")]

TODO

= 这周读到的一些非 SIG26 文章

== HDR-NeRF: High Dynamic Range Neural Radiance Fields @huang2022hdr #link("https://xhuangcv.github.io/hdr-nerf/", "Project")
#image("/images/sig26-paper-notes-1/HDR-NeRF.png")

TODO

== NeRF in the Wild: Neural Radiance Fields for Unconstrained Photo Collections @martinbrualla2021nerfwildneuralradiance [#link("https://arxiv.org/abs/2008.02268", "ArXiv")]
#image("/images/sig26-paper-notes-1/nerfw.png")

TODO

== LazyBrush: Flexible Painting Tool for Hand-drawn Cartoons @lazybrush
#image("/images/sig26-paper-notes-1/lazybrush.png")

TODO