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
@inproceedings{mcnerf,
author = {Gupta, Kunal and Hasan, Milos and Xu, Zexiang and Luan, Fujun and Sunkavalli, Kalyan and Sun, Xin and Chandraker, Manmohan and Bi, Sai},
title = {MCNeRF: Monte Carlo Rendering and Denoising for Real-Time NeRFs},
year = {2023},
isbn = {9798400703157},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3610548.3618221},
doi = {10.1145/3610548.3618221},
abstract = {The volume rendering step used in Neural Radiance Fields (NeRFs) produces highly photorealistic results, but is inherently slow because it evaluates an MLP at a large number of sample points per ray. Previous work has addressed this by either proposing neural scene representations that are faster to evaluate or by pre-computing (and approximating) scene properties to reduce render times. In this work, we propose MCNeRF, a general Monte Carlo-based rendering algorithm that can speed up any NeRF representation. We show that the NeRF volume rendering integral can be efficiently computed via Monte Carlo integration using an importance sampling scheme based on ray density distributions. This allows us to use a small number of MLP evaluations to estimate pixel radiance. These noisy Monte Carlo estimates can be further denoised using an inexpensive image-space denoiser trained per-scene. We demonstrate that MCNeRF can be used to speed up NeRF representations like TensoRF by 7 \texttimes{} while closely matching their visual quality and without making the scene approximations that real-time NeRF rendering methods usually make.},
booktitle = {SIGGRAPH Asia 2023 Conference Papers},
articleno = {98},
numpages = {11},
keywords = {Monte Carlo Rendering, Neural Radiance Fields, Neural Rendering, Real-Time NeRF},
location = {Sydney, NSW, Australia},
series = {SA '23}
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
@misc{fan2026refdgsreflectivedualgaussian,
  title={Ref-DGS: Reflective Dual Gaussian Splatting}, 
  author={Ningjing Fan and Yiqun Wang and Dongming Yan and Peter Wonka},
  year={2026},
  eprint={2603.07664},
  archivePrefix={arXiv},
  primaryClass={cs.CV},
  url={https://arxiv.org/abs/2603.07664}, 
}
@misc{ding2026learningviewdependentsplattingkernels,
  title={Learning View-Dependent Splatting Kernels}, 
  author={Huakeng Ding and Zhanpeng Liu and Fan Pei and Kun Zhou and Hongzhi Wu},
  year={2026},
  eprint={2605.25426},
  archivePrefix={arXiv},
  primaryClass={cs.GR},
  url={https://arxiv.org/abs/2605.25426}, 
}
@article{does3dgsneedaccuratevolrendering,
author = {Celarek, A. and Kopanas, G. and Drettakis, G. and Wimmer, M. and Kerbl, B.},
title = {Does 3D Gaussian Splatting Need Accurate Volumetric Rendering?},
journal = {Computer Graphics Forum},
volume = {44},
number = {2},
pages = {e70032},
keywords = {CCS Concepts, • Computing methodologies → Image-based rendering, Volumetric models, Rasterization, Ray tracing},
doi = {https://doi.org/10.1111/cgf.70032},
url = {https://onlinelibrary.wiley.com/doi/abs/10.1111/cgf.70032},
eprint = {https://onlinelibrary.wiley.com/doi/pdf/10.1111/cgf.70032},
abstract = {Abstract Since its introduction, 3D Gaussian Splatting (3DGS) has become an important reference method for learning 3D representations of a captured scene, allowing real-time novel-view synthesis with high visual quality and fast training times. Neural Radiance Fields (NeRFs), which preceded 3DGS, are based on a principled ray-marching approach for volumetric rendering. In contrast, while sharing a similar image formation model with NeRF, 3DGS uses a hybrid rendering solution that builds on the strengths of volume rendering and primitive rasterization. A crucial benefit of 3DGS is its performance, achieved through a set of approximations, in many cases with respect to volumetric rendering theory. A naturally arising question is whether replacing these approximations with more principled volumetric rendering solutions can improve the quality of 3DGS. In this paper, we present an in-depth analysis of the various approximations and assumptions used by the original 3DGS solution. We demonstrate that, while more accurate volumetric rendering can help for low numbers of primitives, the power of efficient optimization and the large number of Gaussians allows 3DGS to outperform volumetric rendering despite its approximations.},
year = {2025}
}


@misc{jungerman2026radiancefieldsphotons,
  title={Radiance Fields from Photons}, 
  author={Sacha Jungerman and Aryan Garg and Mohit Gupta},
  year={2026},
  eprint={2407.09386},
  archivePrefix={arXiv},
  primaryClass={cs.CV},
  url={https://arxiv.org/abs/2407.09386}, 
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
@misc{geng2025meanflowsonestepgenerative,
  title={Mean Flows for One-step Generative Modeling}, 
  author={Zhengyang Geng and Mingyang Deng and Xingjian Bai and J. Zico Kolter and Kaiming He},
  year={2025},
  eprint={2505.13447},
  archivePrefix={arXiv},
  primaryClass={cs.LG},
  url={https://arxiv.org/abs/2505.13447}, 
}
@misc{wu2025neuralbrdfimportancesampling,
  title={Neural BRDF Importance Sampling by Reparameterization}, 
  author={Liwen Wu and Sai Bi and Zexiang Xu and Hao Tan and Kai Zhang and Fujun Luan and Haolin Lu and Ravi Ramamoorthi},
  year={2025},
  eprint={2505.08998},
  archivePrefix={arXiv},
  primaryClass={cs.GR},
  url={https://arxiv.org/abs/2505.08998}, 
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
@misc{wu2025mvinversefeedforwardmultiviewinverse,
  title={MVInverse: Feed-forward Multi-view Inverse Rendering in Seconds}, 
  author={Xiangzuo Wu and Chengwei Ren and Jun Zhou and Xiu Li and Yuan Liu},
  year={2025},
  eprint={2512.21003},
  archivePrefix={arXiv},
  primaryClass={cs.CV},
  url={https://arxiv.org/abs/2512.21003}, 
}
@inproceedings{parameterspacerestir,
author = {Chang, Wesley and Sivaram, Venkataram and Nowrouzezahrai, Derek and Hachisuka, Toshiya and Ramamoorthi, Ravi and Li, Tzu-Mao},
title = {Parameter-space ReSTIR for Differentiable and Inverse Rendering},
year = {2023},
isbn = {9798400701597},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3588432.3591512},
doi = {10.1145/3588432.3591512},
abstract = {Differentiable rendering is frequently used in gradient descent-based inverse rendering pipelines to solve for scene parameters – such as reflectance or lighting properties – from target image inputs. Efficient computation of accurate, low variance gradients is critical for rapid convergence. While many methods employ variance reduction strategies, they operate independently on each gradient descent iteration, requiring large sample counts and computation. Gradients may however vary slowly between iterations, leading to unexplored potential benefits when reusing sample information to exploit this coherence. We develop an algorithm to reuse Monte Carlo gradient samples between gradient iterations, motivated by reservoir-based temporal importance resampling in forward rendering. Direct application of this method is not feasible, as we are computing many derivative estimates (i.e., one per optimization parameter) instead of a single pixel intensity estimate; moreover, each of these gradient estimates can affect multiple pixels, and gradients can take on negative values. We address these challenges by reformulating differential rendering integrals in parameter space, developing a new resampling estimator that treats negative functions, and combining these ideas into a reuse algorithm for inverse texture optimization. We significantly reduce gradient error compared to baselines, and demonstrate faster inverse rendering convergence in settings involving complex direct lighting and material textures.},
booktitle = {ACM SIGGRAPH 2023 Conference Proceedings},
articleno = {18},
numpages = {10},
keywords = {differentiable rendering, inverse rendering, resampling},
location = {Los Angeles, CA, USA},
series = {SIGGRAPH '23}
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

#image("/images/sig26-paper-notes-1/teaser.png")
= 3D Gaussians (I) 正向渲染加速

== Gaussian Point Splatting @Rijsdijk2026GaussianPointSplatting [#link("https://jorisar.nl/gaussian_point_splatting/", "Project")]
#image("/images/sig26-paper-notes-1/Rijsdijk2026GaussianPointSplatting.png")

本文用蒙特卡洛方法代替深度排序，加速了超大 3DGS 场景在 GPU 上的正向渲染过程。目前仅支持正向渲染。

本文注意到单个 Gaussian Splat 到屏幕空间的行为可以等价于在屏幕空间上按一个 Gaussian 分布放回采样 $N$ 个点的结果的期望（$N$ 和 Gaussian 的参数相关）。而一系列 Gaussians 做 Alpha Blending 的行为可以等价于，对每个 Gaussian $G_i$ 采样 $N_i$ 个点，然后对每个像素取深度上最靠前的点 $min_(d^j) c_x^j$ 作为 Splat 结果的无偏估计值。

一方面该方法优化掉了每个 Tile 都要 GPU 排序的瓶颈，优化到了关于 Gaussian 数量的线性复杂度，还可以通过遮挡剔除等方式进一步剪枝。另一方面这个过程还可以高度并行化，取 $min_(d^j) c_x^j$ 的操作也只需要在屏幕空间缓冲区做一个很高效的原子查询+覆盖，因此跑起来就很快。并且对于超大场景，由于存在大量小于 1 像素的极小 Gaussians，这些 Gaussians 在传统管线中会占用大量的排序计算，造成性能瓶颈，而在该管线中可能只对应非常小的采样点数，因此效率提升会更大。

由于其将深度排序行为替换成了蒙特卡洛方法，它还天然支持渲染出 3DGRT 特有的 “Gaussian 穿插”行为，避免了相机移动时的 Popping 现象。这种 Splatting 方法似乎是可以做到和 3DGRT 管线一致的。（3DGRT 管线可能被迫在射线相交的高斯球过多时放弃靠后的高斯球，但这一方面影响不大，另一方面也可以用随机终止 @xu2026Stoch3DGS 代替 Alpha Blending 做到一致无偏）

#figure(
  caption: "Popping 行为和穿插行为",
  image("/images/sig26-paper-notes-1/gaussian-popping.png"),
) <fig-popping>


论文提到可微渲染的困难主要有：$N_i$ 是整数，关于 Gaussian 的位姿和密度不可微；$min$ 操作不可微；可微难以做到 $O(1)$ 空间复杂度。

这篇的效率瓶颈主要在原子操作互斥锁、采样 Gaussians 时的显存吞吐、分布本身缺陷造成大 Gaussians 生成过多采样点拖慢效率等。对于这些问题本文都用了一些策略去应对。对于采样过程论文提到计算 CDF 并二分的方法比用别名法要快，每次相机移动都会改变所有 Gaussian 的 $N_i$ 分布的确是个麻烦事。

感觉这篇 Monte Carlo 方法的主要缺陷是，对屏幕空间颜色贡献较大的 Gaussian Point 主要是靠近相机的 Gaussian Point，被挡住的 Gaussian Point 实际上的贡献密度很小。感觉缺一点重要性采样，也许可做哇。这个问题在传统 3DGS 管线中也存在。本文的方法主要是靠遮挡剔除解决这个问题的。

本文和 Stochastic Ray Tracing for the Reconstruction of 3D Gaussian Splatting @xu2026Stoch3DGS 同属于用 Monte Carlo 概率方法优化 3D Gaussian Primitive 渲染的方法。区别在于后一篇是基于 3DGRT 管线直接用 Monte Carlo 方法代替了 排序 + Alpha Blending 的过程，保持可微，效率瓶颈仍在求交；而该论文提出了一种比较新的 Splatting 方式，不需要求交、排序等操作，但仅支持正向渲染。二者每 spp 的像素颜色分布也有所不同。这篇的思路中被挡住的 Gaussians 基本就不会被采样到，从而不会影响效率。

在 NeRF 上的类似工作则在 2023 年就有人做过 @mcnerf，大致思路就是考虑到密度估计比颜色估计更快（只用查哈希表），因此先求路径上颜色贡献关于路径的 CDF，然后按该累计分布密度随机采样几个点得到无偏估计，最后做图像空间降噪。这篇的效率提升是传统方法的 7 倍，要低于 Gaussian Point Splatting 的提升倍数，可能深度排序在 3DGS 中还是太耗了。这篇在当年是 Conference Paper。不知道这样改进后密度估计的开销占比有多大。如果要设计基于和 Gaussian Point Splatting 一样的采样-覆写的方法，主要困难是对视锥内的密度场采样。不知道能不能靠预计算做一下。这篇由于是用贡献 CDF 采样颜色，所以天然不易采样到被挡住的点，比较类似 Stochastic 3DGRT。

由于这篇和 Stochastic 3DGRT 一起将随机深度采样的方法变成了最高效的 3D Gaussian Primitives 正向渲染方法，基于低 spp 渲染结果先验的降噪工作可能会变得更加重要。

这个项目没有什么依赖，工程非常好编译，感觉对进一步优化很友好。在我的 4060 笔记本电脑上试着跑了一下， 30M Gaussians 的场景可以跑到实时，但是帧间的噪声还是很明显。感觉网络降噪需求很迫切哇，想想每个像素能不能拿到更多信息，比如其对应的 Gaussian 的元信息，然后在相邻像素之间做一点概率统计重用什么的，感觉很有搞头啊。

#figure(
  caption: link("https://www.youtube.com/watch?v=bMXM9ep6Y5I","St. Sebastian church (30 M Gaussians)")+" 场景在我的电脑上运行的结果。帧率在 30 帧左右，帧间噪声还是很明显的。",
  image("/images/sig26-paper-notes-1/gaussian-point-splatting-screenshot.png"),
) <fig-gaussian-point-splatting-screenshot>

== Mobile3DGS³: Accelerate Mobile 3DGS Rendering via Gradient-Aware Super-Sampling and Frame Interpolation
#image("/images/sig26-paper-notes-1/Mobile3DGS3.png")

#emph[曾经助教、现好朋友 #link("https://github.com/SyouSanGin", "@SyouSanGin") 的第一篇 SIGGRAPH，靠内部关系拿到了文章。]

本文做的是 3DGS 的超分。

主要是观察到 3DGS 的屏幕空间梯度可以提前计算并缓存，在 0.25x 分辨率渲染时 Splat 颜色的同时也 Splat 每个像素的梯度信息，进一步做像素间多项式样条插值，即可在更快的速度内得到高质量的正向渲染结果。

由于 3DGS 在图像空间的渲染结果本来就是比较光滑的（受到 3DGS 基元大小的限制，还受到训练集分辨率的限制），因此样条插值效果就很好。

据原作者所说，后期的神经网络图像调优和帧间插值在本文的方法中贡献并不大。作者也测试过用二阶微分信息进一步优化插值的信息量，但并没有明显提升。

过去的渲染超分方法（不限于 GS）普遍需要 GBuffer 作为网络的补充信息，而本文面对 3DGS 的任务当然是没有 GBuffer 的，合理利用已有信息量（像素点的微分信息）对邻域进行插值是相当漂亮的思路。在 25 年 11 月该文作者发现有一篇 ArXiv 论文 @niedermayr2025lightweightgradientawareupscaling3d 和他的思路撞了。但这篇提出了切空间梯度缓存的方法并且在工程上实现在了 GPU+NPU 上，在效率上做到了 make sense。

很喜欢这种充分挖掘并高效利用信息量，而不是靠神经网络去暴力发现信息的规律的工作。

= 3D Gaussians (II) 表达能力优化

== Ref-DGS: Reflective Dual Gaussian Splatting @fan2026refdgsreflectivedualgaussian [#link("https://straybirdflower.github.io/Ref-DGS/", "Project")]
#image("/images/sig26-paper-notes-1/refdgs.png")

靠构建“虚像”实现 2DGS 近场镜面反射的工作。#strike[靠神经网络去暴力发现信息的规律的工作]

过去的工作在重建镜面/Specular 场景时经常存在强行拟合镜面反射导致几何塌陷的问题，在几何出问题的同时光照也没能很好地拟合。因此本文希望解耦仅与几何相关的视角无关光照和 Specular 光照，从而在可微渲染过程中同时得到可信的几何和可信的 Specular 光照。

考虑将光照分为视角无关和视角相关两部分相加，视角无关的部分可以很好地由传统的、几何紧贴表面的 2DGS（Geo-GS）表示。因为有了可信的几何所以也可以在上面得到 Normal 并优化 Diffuse 和 Roughness 材质参数。注意这里的 Diffuse 是加性的光照“直流分量”，而不是乘性的 Albedo，在定义上和材质模型有一些区别。

视角相关部分进一步分为相机位姿无关（远场）和相机位姿相关（近场）部分，前者可以用可学习的环境贴图表示，后者则是本文主要的创新点，用另一组存储特征向量的 2DGS（Local-GS）表示，表示镜面内部的“虚像”。将 Local-GS Splat 到屏幕上、对每个像素将 Roughness 信息、相机与法线夹角信息和环境光贴图一起送进一个轻量的可学习 MLP 得到 Specular，直接加到 Diffuse 图上。

#figure(
  caption: "Ref-DGS 的渲染管线展示。Geo-GS 为视角无关的 GS，Sph-Mip 为远场光照（环境贴图 MipMap），Local-GS 为渲染近场视角相关光照使用的虚拟“虚像”高斯。",
  image("/images/sig26-paper-notes-1/refdgs-pipeline.png"),
) <fig-refdgs-pipeline>

Geo-GS 的训练是有深度先验做引导的。在合适的超参数下，Geo-GS 会忠实地贴在几何表面，Local-GS 则会进入物体内部拟合 Specular，从而得到优秀的几何。同时论文也确实能很好地表现将 Diffuse 部分和 Specular 部分解耦开（虽然这不是我们想要的解耦“烘焙式光照”）。

很难信任用“虚像”的方法来做 Specular 的视差现象。在有曲率的曲面内部仍然做透视投影感觉根本说不通，不知道神经网络学到什么东西就拟合出来了。很难想象物体内部多个视角生成的 Local-GS 和轻量 MLP 是怎么耦合的。MLP 训练的参数是针对全局的，不知道为什么不做预训练。这个方法看起来也做不了薄物体，不知道怎样才能避免干扰。对 3DGS 不擅长处理的视角相关光照分开处理当然是合理的，但这样做实在让人不安。实验展示了指标上升，但看不出指标上升是因为渲染管线好了还是单纯因为几何好了（考虑到这里几何还用了先验）。

但有启发性的一点是，把特征放在物体内部确实是合乎 Specular 信息的规律的：当绕着金属物体旋转时，高曲率边界的光照会高频快速地改变，这一部分较大的信息量可以由贴近边界的小高斯去拟合得到；内部的光照会相对较慢地流动，这一部分视角间共用的信息可以由靠近物体内部的大特征高斯拟合。总觉得反射信息共用应当有更好的方式去做。

== Learning View-Dependent Splatting Kernels @ding2026learningviewdependentsplattingkernels [#link("https://optkernel.github.io/", "Project")] [#link("https://www.bilibili.com/video/BV1FGGH6ZESR", "GAMES")]
#image("/images/sig26-paper-notes-1/learn-view-dep-kernel.png")

尝试通过学习 Splatting Kernel 提高表达能力。看实验感觉主要优化的是输入视角不充分的区域。 #strike[靠神经网络去暴力发现信息的规律的工作之二]

本文的渲染管线是先将 Gaussian 椭球作为代理几何 Splat 到屏幕空间以得到 Splat 区域每个点到重心的标准化距离；而得到颜色的方法是对每个 Gaussian 将 Gaussian 存储的隐向量（通常为 5 维）、相机空间变换（坐标、缩放因子、旋转矩阵）送进一个全局的“神经投影”MLP $Theta_"proj"$ 中“投影”得到一个 2D 空间的隐向量，再对每个像素点用另一个全局“解码器” MLP $Theta_"dec"$ 接受每个 Gaussian 的隐向量以及标准化距离、输出该 Gaussian 对该像素的贡献，最后做 Alpha Blending 得到最终颜色。训练过程中，Gaussian 的隐向量和相机空间变换都是可学习的参数。

#figure(
  caption: "本文的渲染与训练管线展示。",
  image("/images/sig26-paper-notes-1/learn-view-dep-kernel-pipeline.png"),
) <fig-learn-view-dep-kernel>

投影过程换成了“神经投影”，输出值自然可以根据视角不同发生变化，比原先用球谐函数的表达能力要强很多。正向渲染过程中由于 $Theta_"dec"$ 的推理开销较大，因此直接对每个 Gaussian 预计算标准化后径向每个采样点的颜色值并线性插值。

一个有趣的现象是，学习到的 Kernel 参数在相似的场景、物体下会有相似的分布，如可以为树叶、头发等材质生成相似的“最适合”的 Kernel 形状，说明 Kernel 确实学到了一些物体本身的光照特征。

作者提到这篇解决的问题是让 3DGS 的视角一致性更好了，如一个“长条形”的高斯从短边积分和从长边积分的密度应该不同，一篇 EG2025 的文章《Does 3D Gaussian Splatting Need Accurate Volumetric Rendering?》@does3dgsneedaccuratevolrendering 也论述了这种视角依赖性的现象，虽然没太看懂，感觉怪怪的。

我觉得这篇之所以效果比较好是因为它把高斯的不同视角变得独立了，如优化正面能只优化正面，而不会在侧面产生一些伪影（所以输入不充分的区域效果好）。同时它的神经 Kernel 也保证了比较光滑，不会优化出一些比较明显的伪影（和 GabSplat 相比）。总之感觉更多是降低了“出错”的概率，而不是去让好的地方更好了。比较期待能用一个足够好的 Kernel 把细节变得更漂亮，消掉那种“3DGS 痕迹”。实验上的提升比起传统的 3DGS 在 2dB PSNR 左右，和 SOTA 方法相比基本上不到 1dB。

= 3D Gaussians (III) 辐射场的新应用

== Radiance Fields from Photons @jungerman2026radiancefieldsphotons [#link("https://arxiv.org/abs/2407.09386", "ArXiv")]
#image("/images/sig26-paper-notes-1/radiance-fields-photons.png")

针对“单光子相机”提出的 NeRF 辐射场训练方法。

“单光子相机”（Single Photon Camera）指每个像素仅有 $0$ 和 $1$ 状态表示是否有光子，但帧率极高，可以理解为曝光时间极短、曝光次数极多的相机。“传统相机”（Conventional Camera）则指像素值在 $[0,1]$ 之间、帧率正常、曝光时间长的相机。可以用前者的图像通过累计多次曝光得到后者的图像。前者能提供更多的信息量，特别地，可以避免长时间曝光产生的过曝、拖影等瑕疵，也能解决低亮度下传统相机信息量不足导致重建效果差的问题。现在越来越多的设备开始支持这种单光子相机，因此该论文提出的方法具有很大的实际应用价值。

单光子相机的输入数量极大、每张输入的噪声也很高，且由于高噪无法通过几张相邻输入的关系得到相机位姿。本论文针对这种输入解决了三个问题：
- 辐射场训练：根据泊松分布，一个像素被打进一个光子的概率 $P$ 和像素内辐射强度 $phi.alt$、曝光时间 $tau$ 的关系为 $ P=1-e^(-phi.alt tau) $
  单光子相机得到的结果服从以上概率的二项分布，训练一个可做体积分的概率场而非辐射场，由最大似然估计的原理知优化 $norm(P-B)_2$ 即可，形式上和传统 NeRF 是相同的，只是积分后从概率转换到辐射强度需要经过一个含曝光时间 $tau$ 参数的映射。
- 相机位姿：先根据相邻帧模拟曝光一次重建一个相对不可靠的“虚拟”位姿，然后在辐射场训练的同时把相机位姿也作为可训练参数进行优化。考虑到曝光极频繁的相机运动一定是非常光滑的，本文用低通滤波后的位姿和当前位姿的 Loss 作为一个正则项引导位姿的平滑优化。
- 大输入量：bit 压缩、实时磁盘读取等 common trick。

本文 claim 的针对运动相机、低光照场景、过曝场景的优化是显然的，因为单光子相机提供了足够多的信息量。技术上感觉也没什么难想到的地方，感觉像是纯粹应用比较小众且有前景就上了。这篇论文的 writing 也很神奇，每一段都有小标题，大标题的用词也很不同寻常，第一次见这种风格的文章。

到底是从哪里知道这种新应用的哇，我也想找一点冷门的应用场景写论文......不知道这篇的应用能不能继续往后水几篇。

= Rendering

== Lifting Lines and Tone: Image-space Stylization in Path-space @West2026 [#link("http://www.cg.it.aoyama.ac.jp/yonghao/sig26/abstsig26.html", "Project")]
#image("/images/sig26-paper-notes-1/West2026.png")

该工作是 NPR 描线 (Feature Lines) 和半调 (Tones) 在全局光照下的渲染系列最新的工作。

West 的往期工作提到用一个风格化渲染方程 $L_o = g_theta (L_e+integral_Omega L_i rho dif omega_i)$ 来建模 NPR 的行为，其中 $g_theta$ 是一个定义上与屏幕空间坐标相关的风格化函数。该工作优化了对世界空间（路径空间）中的点找到其屏幕空间特征的算法（论文中将该操作称为“Lifting”）。

该文章的设计目标基于以下原则：
1. Image-space consistency：线条的宽度和半调图案间距在屏幕坐标系下应该稳定可控，需要在间接光、反射/折射（尤其是带曲率表面）、景深等影响下保持一致；
2. Geometric correctness：从图像空间到路径空间的映射要保持局部几何特征，应该避免曲率造成的失真。
3. Distribution support：不仅需要支持镜面反射，还要支持任意分布定义的散射。
4. Estimator compatibility：积分结果需要无偏，且效率上要和传统路径追踪相当。

#figure(
  caption: "Failure modes（第二排，从左至右）：半调阴影间距沿表面测地线分布而不是在屏幕空间均匀分布；半调图案受表面曲率影响产生偏差；线宽在经过右侧球面反射后发生变化。我其实不太清楚过去工作产生这些 Failure mode 的原因。",
  image("/images/sig26-paper-notes-1/lifting-failure-cases.png"),
) <fig-lifting-failure-cases>

对于描线，本文设计的方案（Conditional Lifting）是对于一条光路，做一次“Levi-Civita 平行移动”（就是微分几何的那个平行移动）。实际上就是去求屏幕空间中射线方向的微扰会在路径点上产生怎样的微扰、这种微扰是否会让该路径点有特征线的特征（如微扰后可见性发生了变化，或屏幕空间的微扰会造成路径空间的剧烈变化）。这个思路有种可微渲染感，但论文中实际实现方式是有限差分，用“冻结随机变量”的方法重用每步的采样方向保证差分路径间的强耦合性。

对于半调，本文设计的方案（Canonical Lifting）则是先假设所有表面都是理想镜面、做一遍路径追踪在世界空间打下一系列记有对应屏幕空间坐标的锚点；在实际路径追踪时，对每个路径点去找邻域的锚点，并用移动最小二乘法插值出该路径点的屏幕空间坐标。感觉好 Tricky 啊，这个思路还是得参考艺术家是怎样决定经过光学变换后的半调的。

#figure(
  caption: "这张图还是很形象地展示了平行移动描线是 make sense 的，这篇工作中带曲率的曲面会影响微扰在下一跳的微分，而以往工作做不到。"+emph[我和我自己比],
  image("/images/sig26-paper-notes-1/lifting-levi-civita.png"),
) <fig-lifting-levi-civita>

这篇颇有一种二十年前图形学“看起来对就是对”的 tricky 美感，不像是这个年代能出现在 ToG 的文章（？），不知道还有没有什么别的领域能体验一把这种拿到艺术家对 NPR 的需求并在数学上很好地建模的科研体验。这个系列工作要做的话感觉做不过 West 他们，说实话之前看他们工作的时候都想不出这些问题，就算自己提了新的渲染目标也不一定能把故事讲通，果然这篇只有他们自己能做出来。

这个系列的工作目前基本没有做路径追踪基础上的加速，感觉有机会提炼出一些可 Caching 的东西，能凹到实时就更好了。

NPR 与现代渲染方法结合的话，Neural 方法是难以建模一个相机相关的辐射场的（真的可以力大砖飞加一个相机参数维度吗，说不定呢）；Gaussian Primitives 由于 SH 的低频性质加上描边的特殊性，感觉很难表示描边和半调这种特征。现在做 NeRF/Gaussians 光场的 NPR/ 风格化基本都是用前馈网络做类似后处理的操作实现的，感觉这样做多视角一致性还是个问题，ai 幻觉可能还会有些不适感。

== Fiber-level Woven Fabric Capture from a Single Microscopic Image @FiberLevel
#image("/images/sig26-paper-notes-1/FiberLevel.png")
#emph[另一位助教的文章之一。]

TODO

== PureSample: Neural Materials Learned by Sampling Microgeometry [#link("https://arxiv.org/abs/2508.07240", "ArXiv")] [#link("https://www.bilibili.com/video/BV1CNGH6aEvY", "GAMES")]
#image("/images/sig26-paper-notes-1/PureSample.png")

用神经网络表达并学习由微几何定义的复杂材质 BRDF。

现代渲染可以借助 Neural BRDF 来表达过去材质模型无法表达的复杂材质。该文章注意到实际物体的材质基本上由表面的微结构决定，microfacet 模型等都只是对微结构的简化，而直接对微结构做 Path Tracing 开销则过大，因此提出用神经网络去从给出的微结构几何中学出一个可采样的 BRDF。

神经网络的输入来自对微表面的小区域做数次 Path Tracing 模拟（考虑到微结构实际上是 Sampling 易、Eval 难的），得到的数个 $(omega_i, omega_o)$ 的样本，用 Flow Matching 的方法得到一个由简单分布到目标分布的可逆的“速度场”，从而使得 BRDF 可以被高效地采样和估值。具体求解的算法是 MeanFlow @geng2025meanflowsonestepgenerative ，感觉值得一看。注意到重分布只能表示散射行为而不能表示吸收行为，因此还需要对模拟的结果训练一个 Albedo 网络作为整体的吸收系数。由于从速度场中估值 pdf 比较耗，本文还蒸馏了一个轻量的 pdf 用于 MIS 权重和 BRDF 值计算，只在必要时才用无偏的 pdf。

和去年的 Neural BRDF 重参数化采样 @wu2025neuralbrdfimportancesampling 的区别主要在本文的目标微结构 BRDF 是可采样的，且要求得到的 Neural BRDF 可估值，从而采用的是 Flow Matching 算法，而 Wu 的工作则是针对一个难采样的 Neural BRDF 设计可采样的重要性分布，且不要求可估值。

之前没做过材质，几乎都想不到这个问题。果然还是得和做 Rendering 的人多交流。

== Multi-feature Radiance Baking Neural Networks for Instant Volumetric Rendering
#image("/images/sig26-paper-notes-1/MRBNN.png")
#emph[好感动，MRPNN 的优化也被做出来了。同样是靠内部关系拿到的文章。]

TODO

= Monte Carlo PDE

== Probe-based Walk on Spheres for Efficient Path Reusing
#image("/images/sig26-paper-notes-1/WoP-teaser.png")
#emph[自己的文章，嘿嘿]

利用路径信息重用高效优化 Walk on Spheres 系列算法。

考虑到 Walk on Spheres 的采样过程，每一步都要在球面上均匀采样一个点作为该点解值的一个无偏估计。由 Off-center 形式的平均值公式可以得到实际上在球内的偏心点按 Poisson Kernel 分布在球面上采样一个点得到的结果也是解值的无偏估计。因此 WoS 均匀采样得到的解值可以为球内每个点所重用，在算法上就是得到一条完整路径后将求解值 Splat 回路径上的每个球内。这个算法被我们称为 Naive Path Reuse，不清楚现在 sig 上那篇 Talking to Neighbors 有没有扩展成这样的形式。

#figure(
  caption: "我们的 Naive Path Reuse 算法",
  image("/images/sig26-paper-notes-1/wop_path_reuse.png"),
) <fig-wop-path-reuse>

然后考虑到这样 Splat 的开销过于大（球内每个点都需要查询并访存一次），正好 25 年 11 月又出来了 Harmonic Caching 的文章，发现后者正好可以将 Splat 的任务转化为求解几个 Fourier 系数的任务。因此和 HC 类似地在求解域预放置一些探针球，游走时取一个探针球做 Poisson Kernel 采样找到边界，若不存在探针球就 Fallback 到传统的 WoSt 算法，可以验证这个行为仍然是满足布朗运动的。找到 Dirichlet 边界后就将求解到的结果送回探针球中贡献 Fourier 系数。然后就非常快了。

#figure(
  caption: "我们的 Walk on Probes 算法",
  image("/images/sig26-paper-notes-1/wop_algorithm.png"),
) <fig-wop-algorithm>

当时这篇文章的 idea 成形已经是 11 月底了，只有两个月的时间做，临近交稿的时候还有各种 ddl 和期末考试，压力巨大。还好做完了，如果再晚半年就要和这些新的方差缩减算法比了，甚至要和 Best Paper 比，好可怕。

== Walk on Decomposed Subdomains: A Hybrid Monte Carlo–Deterministic Solver for Elliptic PDEs @wods [#link("https://clementjambon.github.io/wods/index.html", "Project")]
#image("/images/sig26-paper-notes-1/wods.png")
#emph[今年 Best Paper，太猛了]

通过空间划分解决 WoSt 路径过长的问题，从而高效提升速度。

为了避免常规 Walk on Stars 路径过长的问题，该方法把求解域分为了网格状子域，用虚拟的 Dirichlet 边界分开，逐个求解再合并，这样每个子区域都是 Dirichlet 为主的区域，就易于求解了。

论文内容量好大，做了超级多的实验和探索。总觉得自己也想到过类似的方法，但没能落地到这么实在的程度。

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

= 这两周读到的一些非 SIG26 文章

== MVInverse: Feed-forward Multiview Inverse Rendering in Seconds @wu2025mvinversefeedforwardmultiviewinverse [#link("https://maddog241.github.io/mvinverse-page/", "Project")] (CVPR2026)
#image("/images/sig26-paper-notes-1/mvinverse.png")

输入多视角图片，输出多视角 G-Buffer，效率优化到实时级别。

本文提出了交替注意力网络结构，在以往单图注意力网络的基础上交替叠加全局、多图之间的注意力网络，从而能在不同视角的注意力之间“对账”保证多视角一致性。

对于编码器，在使用 DINOv2 提供语义先验的基础上还用了 ResNeXt 编码器提取高频特征，保证输出图片是锐利的。

训练阶段采用两阶段训练，第一阶段在标注正确的 3D 数据集上学习物理规律，第二阶段自监督、用真实视频的光流约束，保证两帧之间对同一点的预测输出一致，以提高训练数据量。用锚点损失防止模型微调时产生漂移。

因为以往的预测都是单图的，这里多图提供了更大的信息量，因此指标提升是可以预见的。并且因为多图逆渲染的需求是存在的（可微渲染这边基本都在做这种），故事也说得通。

我没有怎么看过生成方面的文章，每学一个新东西都觉得好神奇。总感觉材质重建这种任务还是得靠生成式方法。

== Parameter-space ReSTIR for Differentiable and Inverse Rendering @parameterspacerestir (SIGGRAPH 2023)
#image("/images/sig26-paper-notes-1/parameter-space-restir.png") 

用 ReSTIR 提速可微渲染。

因为在思考在可微渲染任务里用 ReSTIR 所以看了。这篇主要提到可微渲染需要对梯度做积分，因此考虑用 ReSTIR 加速对梯度的采样。然后因为梯度向量的维数和参数相关，存屏幕空间会过大，因此需要在参数空间给每个参数单独存。并且因为梯度向量在实数域上，所以要对正值和负值分别设置储层，是一个经典 trick 了。这篇在当年也是 Conference Track。看完觉得自己的 idea 不可行了（x

== HDR-NeRF: High Dynamic Range Neural Radiance Fields @huang2022hdr #link("https://xhuangcv.github.io/hdr-nerf/", "Project") (CVPR 2022)
#image("/images/sig26-paper-notes-1/HDR-NeRF.png") 

用多个曝光条件不同的图片训练 HDR 的 NeRF 场。

在体积分得到辐射量的后端再接一个根据相机曝光原理设计的可学习含参函数，就能顺便把该视角图片的曝光曲线也学了，因为信息量充分，所以能学到准确的 HDR NeRF 场。

因为当时想着材质重建做不好可能是光场 LDR 的原因，就看了这篇，结果做了实验发现 HDR 的光场并不能得到什么提升，遂放弃。这篇感觉也是一篇从应用切入的文章，好羡慕这种发现小众应用场景的科研能力。

== LazyBrush: Flexible Painting Tool for Hand-drawn Cartoons @lazybrush (EG 2008)
#image("/images/sig26-paper-notes-1/lazybrush.png") 

老文章。启发式解决非封闭线稿填色的问题，现在该方法被用在了 Krita 中。

该文章想处理的交互逻辑如上图中间，用一笔选择想要填色的区域内部，即可得到右图这样，线稿内部完美填色，而线稿外部漏出的区域自动被修正掉。该文章将不完美填色问题建模成一个能量优化问题。能量函数由定义在两像素之间连边上的平滑项 $V_(p,q)$ 和像素点上的数据项 $D_p$ 组成。填色区域的边界会贡献平滑项，而一部分内部像素点会贡献数据项。

平滑项 $V_(p,q)$ 用于找到一条合适的边界，定义为和 $p$ 点的亮度正相关，使得在较亮的区域（线稿内部）切换颜色会有较高的代价，而鼓励在较暗的区域（单根线的“中心”区域）切换颜色。这样的能量会鼓励填色区域不断“膨胀”直到被其所在的线稿区域的线条中心约束住，同时也会约束填色区域在线稿不封闭的小缝隙不漏出来。（边界跨过较窄的缝隙，贡献的能量会低于跨过外部更宽的缝隙）算法会像水流寻找地势最低处一样，寻找一条总光度值最低（最黑）的路径来强行连接断开的线条。

数据项 $D_p$ 用于修正填色时溢出边界的部分，定义为如果一个像素被用户指定需要填色但实际算法决定不填色时，贡献一个常数能量。这意味着如果填满一个溢出区域边界贡献的能量比删掉这一块区域的能量还高（小区域填满了大边界），不如直接删去这一块。

具体的求解算法为图论的算法，就不在这里讨论了。老一辈图形学人的启发式方法还是漂亮，可惜目前除了 Krita 好像就没在别的软件里看到过了（Procreate 什么时候才能有！）不知道现代图形学的问题里会不会有类似这样“填色”的需求。