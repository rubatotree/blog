#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "SIGGRAPH 2026 论文笔记 II: Rendering",
  date: datetime(year: 2026, month: 5, day: 28),
  weight: 0,
  tags: (
    category: ("计算机图形学", "Rendering", "论文笔记")
  ),
  draft: false,
  references: ```bib

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
@article{scratchart,
author = {Shen, Pengfei and Li, Ruizeng and Wang, Beibei and Liu, Ligang},
title = {Scratch-based Reflection Art via Differentiable Rendering},
year = {2023},
issue_date = {August 2023},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
volume = {42},
number = {4},
issn = {0730-0301},
url = {https://doi.org/10.1145/3592142},
doi = {10.1145/3592142},
abstract = {The 3D visual optical arts create fascinating special effects by carefully designing interactions between objects and light sources. One of the essential types is 3D reflection art, which aims to create reflectors that can display different images when viewed from different directions. Existing works produce impressive visual effects. Unfortunately, previous works discretize the reflector surface with regular grids/facets, leading to a large parameter space and a high optimization time cost. In this paper, we introduce a new type of 3D reflection art - scratch-based reflection art, which allows for a more compact parameter space, easier fabrication, and computationally efficient optimization. To design a 3D reflection art with scratches, we formulate it as a multi-view optimization problem and introduce differentiable rendering to enable efficient gradient-based optimizers. For that, we propose an analytical scratch rendering approach, together with a high-performance rendering pipeline, allowing efficient differentiable rendering. As a consequence, we could display multiple images on a single metallic board with only several minutes for optimization. We demonstrate our work by showing virtual objects and manufacturing our designed reflectors with a carving machine.},
journal = {ACM Trans. Graph.},
month = jul,
articleno = {65},
numpages = {12},
keywords = {scratch rendering, differentiable rendering, 3D reflection art}
}
@inproceedings{ MRPNN,
	author       = {Jinkai Hu and Chengzhong Yu and Hongli Liu and Ling-qi Yan and Yiqian Wu and Xiaogang Jin},
	title        = {Deep Real-time Volumetric Rendering Using Multi-feature Fusion},
	booktitle    = {{SIGGRAPH} '23: Special Interest Group on Computer Graphics and Interactive Techniques Conference, Los Angeles CA, United States, August 6 - 10, 2023},
	publisher    = {{ACM}},
	year         = {2023}
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
  ```,
)

= 1. 材质，外观，可微渲染

== Fiber-level Woven Fabric Capture from a Single Microscopic Image @FiberLevel
#image("/images/sig26-paper-notes/FiberLevel.png")
#emph[另一位助教 #link("https://jerry-shen0527.github.io/", "@JerryShen") 的文章之一。这篇没有上 Sig26，只是录进了 ToG，但也放在这里。]

从单张显微图像通过可微渲染重建织物的纤维级几何和材质。

对于几何建模了基本可微的五层结构：
- 编织模式 Pattern：平纹、斜纹等纹理模式，直接预设好，用预训练的 CNN 分类；
- 中心线层 Yarn Centerline：每根纤维从侧面看高度关于路径长度的函数，用抛物线和圆混合；
- 纤维截面层 Cross-sectional Fiber Distribution：在中心线周围生成 $m$ 根纤维，纤维的螺旋扭转 $alpha$、偏移 $R_i$、周期性挤压变形等都是可微参数；
- 随机噪声层 Randomized Variation：用柏林噪声和白噪声让纤维的半径和纵向产生变化、噪声种子本身不可微但强度可微。
- 飘散纤维层 Flyaway Model：额外手动添加飘散出来的断线等纤维（定义有毛发 Hair 和环路 Loop 两种），模拟现实材质情况。这一层没法可微优化出来。

材质模型采用了 Chiang 的材质模型，特点是建模了光照的多次散射，可以精确模拟纤维的行为。

训练采用三个阶段：
- 初始化：用预训练的 CNN 先预测出这些参数的初值，其中编织模式、截面纤维数目等不可微参数在这一步就固定了。因为 CNN 擅长识别类型、数目等模式，所以这些初值就能非常可靠。对于材质在预测 Chiang 模型参数的同时还预测一组简化材质模型参数。
- 基于光栅化做粗优化：这一步用简化的材质模型（单散+Lambert）进行逆渲染，主要优化几何、颜色等。用 NVDiffRast 的“软边界光栅化”做高速逆渲染。优化 CNN 输出的 Gram 矩阵特征（结构）和 RGB（颜色）两个 Loss。这一步后几何参数被固定。
- 基于路径追踪做精细优化：将材质参数映射回 Chiang 模型，用 mitsuba 做可微路径追踪优化纤维材质参数。因为此时参数已经很少且基本准确，这一步可以做到很稳定的精细优化。

这篇提到的主要 Limitation 有：编制模式是预设的因此覆盖范围有限；不支持空间变化的颜色等、而实际情况是一些织物纤维本身存在渐变或布面印染等，难以 trivial 地支持；飘散纤维没有很好地被建模、无法可微优化；经纬纱颜色相似时边界会变模糊、模式会变得不明显、对初始化和粗优化阶段都不友好；几何模型目前只支持单股纱线、不支持复杂的合股纱；路径追踪阶段仍然耗时。作者说逆向的部分目前其实不那么 work，效果虽然很漂亮但和原图还是对不上。

这篇审美真好，感觉每一步都很合理优雅哇。感觉这个需求是沈学长以往做的划痕艺术 @scratchart 的超级加强版。太厉害了。

== PureSample: Neural Materials Learned by Sampling Microgeometry [#link("https://arxiv.org/abs/2508.07240", "ArXiv")] [#link("https://www.bilibili.com/video/BV1CNGH6aEvY", "GAMES")]
#image("/images/sig26-paper-notes/PureSample.png")

用神经网络表达并学习由微几何定义的复杂材质 BRDF。

现代渲染可以借助 Neural BRDF 来表达过去材质模型无法表达的复杂材质。该文章注意到实际物体的材质基本上由表面的微结构决定，microfacet 模型等都只是对微结构的简化，而直接对微结构做 Path Tracing 开销则过大，因此提出用神经网络去从给出的微结构几何中学出一个可采样的 BRDF。

神经网络的输入来自对微表面的小区域做数次 Path Tracing 模拟（考虑到微结构实际上是 Sampling 易、Eval 难的），得到的数个 $(omega_i, omega_o)$ 的样本，用 Flow Matching 的方法得到一个由简单分布到目标分布的可逆的“速度场”，从而使得 BRDF 可以被高效地采样和估值。具体求解的算法是 MeanFlow @geng2025meanflowsonestepgenerative ，感觉值得一看。注意到重分布只能表示散射行为而不能表示吸收行为，因此还需要对模拟的结果训练一个 Albedo 网络作为整体的吸收系数。由于从速度场中估值 pdf 比较耗，本文还蒸馏了一个轻量的 pdf 用于 MIS 权重和 BRDF 值计算，只在必要时才用无偏的 pdf。

和去年的 Neural BRDF 重参数化采样 @wu2025neuralbrdfimportancesampling 的区别主要在本文的目标微结构 BRDF 是可采样的，且要求得到的 Neural BRDF 可估值，从而采用的是 Flow Matching 算法，而 Wu 的工作则是针对一个难采样的 Neural BRDF 设计可采样的重要性分布，且不要求可估值。

之前没做过材质，几乎都想不到这个问题。果然还是得和做 Rendering 的人多交流。

= 2. 体积渲染

== Multi-feature Radiance Baking Neural Networks for Instant Volumetric Rendering
#image("/images/sig26-paper-notes/MRBNN.png")
#emph[好感动，MRPNN 的优化也被做出来了。同样是靠内部关系拿到的文章。]

用预烘焙的神经辐射场加速参与介质的“MRPNN @MRPNN 式”体渲染，目标是烘焙一个只和密度场相关的预计算特征场，使得可以在各种光照条件下高速渲染体积，且解决 MRPNN 的欠采样情形 failure case。

过去工作提到，体积中的辐射传输可以用一个算子 $cal(K)$ 定义，对于体积中每一个位置，将局部的入射辐射函数映射为该点的出射辐射函数。易知这个算子只和相位函数有关，而和光照无关，而局部入射函数和位置、远场入射辐射、密度/相位函数分布有关。算子 $cal(K)$ 可以形式化表述为一个卷积算子：

$
S(p,omega)=(cal(K)L)(p,omega):=integral_(S^2) phi.alt(p,(omega_i dot omega)) L(p,omega_i) dif omega_i
$

本文的主要观察是，这个算子在球谐函数基下是对角化的，从而算子的作用可以转化为各阶球谐系数和算子系数的逐点乘法，以高效存储和求解。这个思想非常类似于算法中用 FFT 求解多项式乘法，同样是通过做一个傅里叶变换去将卷积算子对角化，非常优雅。

$
S(p,omega)=sum_(l=0)^infinity eta_l (p) sum_(m=-l)^l L_l^m (p,omega_s) Y_l^m (omega)
$

然而局部入射辐射函数仍然是难求的，需要在体积内部模拟多次散射才能得到。并且，这是一个五维函数，本身难以烘焙。因此本文考虑对算子 $cal(K)$ 做低秩分解，分别计算和位置与角度有关的特征，最后组合出辐射值。低秩分解的思路是只求出和光源方向相同方向上的散射值（称为隐空间特征，这样就只需要烘焙和位置相关的特征 $cal(L)(p)$），然后再用 view modifier $cal(V)(omega)$ 微调到实际角度的情形。

$
cal(S):(sum_(l=0)^K n_l (p)sum_(m=-l)^l cal(L)_l^m (p) Y_l^m (omega_s), cal(V)(omega)) -> sum_(l=0)^l n_l (p) sum_(m=-l)^l L_l^m (p,omega_s) Y_l^m (omega)
$

为了保证渲染的效果和效率，最后喂给网络的特征除了有隐空间特征、view modifier 外，还有沿光源采样的基础网格特征 $cal(B)$（烘焙进网格中，用于替代沿路多次估计 $cal(L)$）和透射率分布特征 $cal(T)$，以及在邻域局部采样的相函数特征 $cal(G)$ 和 Albedo 特征 $cal(A)$. 从各个 Mipmap 层 $i$ 采样到的特征最后拼接成送进网络的特征 $cal(F)$. 因为这些特征已经很能概括散射了，所以网络只需要用一个简单的残差连接轻量 MLP。
$
cal(F)_i (p,omega)=(& cal(B)_i (p_i), sum_(l=0)^K g(p)^l sum_(m=-l)^l cal(L)_(i,l)^m (p) Y_l^m (omega_s), cal(V)_i (omega),\ & cal(G)_i (g(p),cos theta), cal(A)_i (alpha(p,omega),cos theta),[cal(T)_i (p_j, omega_s)]_(j=1)^M_2)
$
和 MRPNN 相同，把这个特征送进和场景无关的预训练 MLP 即可得到每个点的散射。

#table(columns:4)[比较维度][MRPNN][MRBNN][性能提升原因][网络参数量][49.7 K][28.5 K][网络规模缩小近一倍，且使用了全融合架构。][采样元素量][480 个][432 个][减少了高维 SH 系数的重复访问。][输入维数][480+][64][烘焙了物理先验，且逐层补充信息。][推理耗时][\~19.0 ms][\~0.753 ms][参数量减小、维度降低、计算对角化。]

并且 MRBNN 的采样步骤更快，因为只需要采样一次球谐系数，其它采样均是在 Mipmap 网格中采样标量，不需要反复访问纹理。MRBNN 输入的特征维数也更小（因为在预计算过程中已经融入了很多物理计算过的内容）。MRBNN 采用的残差连接 MLP 比 MRPNN 用的 SE 架构更轻量。综上能达到 20 倍以上的实时渲染性能提升。

这篇文章的许多细节和设计动机我还没有完全看懂，有时间找原作者聊聊。

参与介质渲染和 MRPNN 是我在图形学科研上痛苦受挫的开始。回忆过去还是比较想哭。这几年的自己不可能想出这样的优化，尽管不该是因为我不够努力。

= 3. 风格化

== Lifting Lines and Tone: Image-space Stylization in Path-space @West2026 [#link("http://www.cg.it.aoyama.ac.jp/yonghao/sig26/abstsig26.html", "Project")]
#image("/images/sig26-paper-notes/West2026.png")

该工作是 NPR 描线 (Feature Lines) 和半调 (Tones) 在全局光照下的渲染系列最新的工作。

West 的往期工作提到用一个风格化渲染方程 $L_o = g_theta (L_e+integral_Omega L_i rho dif omega_i)$ 来建模 NPR 的行为，其中 $g_theta$ 是一个定义上与屏幕空间坐标相关的风格化函数。该工作优化了对世界空间（路径空间）中的点找到其屏幕空间特征的算法（论文中将该操作称为“Lifting”）。

该文章的设计目标基于以下原则：
1. Image-space consistency：线条的宽度和半调图案间距在屏幕坐标系下应该稳定可控，需要在间接光、反射/折射（尤其是带曲率表面）、景深等影响下保持一致；
2. Geometric correctness：从图像空间到路径空间的映射要保持局部几何特征，应该避免曲率造成的失真。
3. Distribution support：不仅需要支持镜面反射，还要支持任意分布定义的散射。
4. Estimator compatibility：积分结果需要无偏，且效率上要和传统路径追踪相当。

#figure(
  caption: "Failure modes（第二排，从左至右）：半调阴影间距沿表面测地线分布而不是在屏幕空间均匀分布；半调图案受表面曲率影响产生偏差；线宽在经过右侧球面反射后发生变化。我其实不太清楚过去工作产生这些 Failure mode 的原因。",
  image("/images/sig26-paper-notes/lifting-failure-cases.png"),
) <fig-lifting-failure-cases>

对于描线，本文设计的方案（Conditional Lifting）是对于一条光路，做一次“Levi-Civita 平行移动”（就是微分几何的那个平行移动）。实际上就是去求屏幕空间中射线方向的微扰会在路径点上产生怎样的微扰、这种微扰是否会让该路径点有特征线的特征（如微扰后可见性发生了变化，或屏幕空间的微扰会造成路径空间的剧烈变化）。这个思路有种可微渲染感，但论文中实际实现方式是有限差分，用“冻结随机变量”的方法重用每步的采样方向保证差分路径间的强耦合性。

对于半调，本文设计的方案（Canonical Lifting）则是先假设所有表面都是理想镜面、做一遍路径追踪在世界空间打下一系列记有对应屏幕空间坐标的锚点；在实际路径追踪时，对每个路径点去找邻域的锚点，并用移动最小二乘法插值出该路径点的屏幕空间坐标。感觉好 Tricky 啊，这个思路还是得参考艺术家是怎样决定经过光学变换后的半调的。

#figure(
  caption: "这张图还是很形象地展示了平行移动描线是 make sense 的，这篇工作中带曲率的曲面会影响微扰在下一跳的微分，而以往工作做不到。"+emph[我和我自己比],
  image("/images/sig26-paper-notes/lifting-levi-civita.png"),
) <fig-lifting-levi-civita>

这篇颇有一种二十年前图形学“看起来对就是对”的 tricky 美感，不像是这个年代能出现在 ToG 的文章（？），不知道还有没有什么别的领域能体验一把这种拿到艺术家对 NPR 的需求并在数学上很好地建模的科研体验。这个系列工作要做的话感觉做不过 West 他们，说实话之前看他们工作的时候都想不出这些问题，就算自己提了新的渲染目标也不一定能把故事讲通，果然这篇只有他们自己能做出来。

这个系列的工作目前基本没有做路径追踪基础上的加速，感觉有机会提炼出一些可 Caching 的东西，能凹到实时就更好了。

NPR 与现代渲染方法结合的话，Neural 方法是难以建模一个相机相关的辐射场的（真的可以力大砖飞加一个相机参数维度吗，说不定呢）；Gaussian Primitives 由于 SH 的低频性质加上描边的特殊性，感觉很难表示描边和半调这种特征。现在做 NeRF/Gaussians 光场的 NPR/ 风格化基本都是用前馈网络做类似后处理的操作实现的，感觉这样做多视角一致性还是个问题，ai 幻觉可能还会有些不适感。

= 4. 这段时间读到的一些非 SIG26 文章补充

== Parameter-space ReSTIR for Differentiable and Inverse Rendering @parameterspacerestir (SIGGRAPH 2023)
#image("/images/sig26-paper-notes/parameter-space-restir.png") 

用 ReSTIR 提速可微渲染。

因为在思考在可微渲染任务里用 ReSTIR 所以看了。这篇主要提到可微渲染需要对梯度做积分，因此考虑用 ReSTIR 加速对梯度的采样。然后因为梯度向量的维数和参数相关，存屏幕空间会过大，因此需要在参数空间给每个参数单独存。并且因为梯度向量在实数域上，所以要对正值和负值分别设置储层，是一个经典 trick 了。这篇在当年也是 Conference Track。看完觉得自己的 idea 不可行了（x

