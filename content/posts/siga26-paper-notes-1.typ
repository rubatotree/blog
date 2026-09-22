#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "SIGGRAPH Asia 2026 论文笔记 I",
  date: datetime(year: 2026, month: 9, day: 22),
  weight: 0,
  tags: (
    category: (
      "计算机图形学",
      "SIGGRAPH Asia 2026",
      "论文笔记",
      "Rendering",
      "Differentiable Rendering",
      "Ray Tracing",
      "Geometry",
      "Embodied AI"
    )
  ),
  draft: true,
  references: ```bib
@inproceedings{ren2026octaoctree,
  author    = {Ren, Jierui and Jin, Haojie and Pang, Bo and Gai, Meng and Zhu, Fei and Chen, Yisong and Li, Sheng},
  title     = {OctaOctree Neural Radiosity for Real-time Glossy Material Rendering in Static Scenes},
  booktitle = {SIGGRAPH Asia 2026 Conference Papers},
  year      = {2026},
  doi       = {10.1145/3829340.3842363},
  url       = {https://doi.org/10.1145/3829340.3842363}
}
@inproceedings{yang2026intermash,
  title     = {{InterMASH}: A Unified Geometric Representation for Grasp Synthesis},
  author    = {Yang, Xuanze and Liu, Yumeng and Xin, Haiyang and Li, Changhao and Shen, Haowei and Xu, Kai and Liu, Ligang and Hu, Ruizhen},
  booktitle = {SIGGRAPH Asia 2026 Conference Papers},
  series    = {SA Conference Papers '26},
  year      = {2026},
  publisher = {Association for Computing Machinery},
  address   = {New York, NY, USA},
  location  = {Kuala Lumpur, Malaysia},
  numpages  = {11},
  doi       = {10.1145/3829340.3842336},
  url       = {https://doi.org/10.1145/3829340.3842336}
}
@inproceedings{bao2026part,
  title     = {{PART}: Learning 3D Part Assembly and Retrieval with Transformers},
  author    = {Bao, Ruchao and Wu, Wenzheng and Xiang, Chucheng and Liu, Zhongyuan and Liu, Yuan and Dong, Jinxin and Liu, Ligang and Wang, Ziqi},
  booktitle = {SIGGRAPH Asia 2026 Conference Papers},
  year      = {2026},
  url       = {https://iambrc.github.io/PART-project-page/}
}
@article{li2026projectedspecularmanifolds,
  author  = {Li, Ruizeng and Wang, Peiqi and Wang, Beibei and Liu, Ligang},
  title   = {Differentiable Rendering for Specular Materials via Projected Specular Manifolds},
  journal = {ACM Transactions on Graphics},
  year    = {2026},
  volume  = {45},
  number  = {6},
  note    = {Proc. SIGGRAPH Asia},
  url     = {https://rhythm25.github.io/PSMpage/}
}
@article{poirierginter2026gray,
  author    = {Poirier-Ginter, Yohan and Lalonde, Jean-Fran\c{c}ois and Drettakis, George},
  title     = {{GRay}: Ray Tracing 3D Gaussians Near the Speed of Splats},
  journal   = {Proceedings of the ACM on Computer Graphics and Interactive Techniques},
  year      = {2026},
  volume    = {9},
  number    = {1},
  articleno = {14},
  numpages  = {19},
  doi       = {10.1145/3804496},
  url       = {https://doi.org/10.1145/3804496}
}
  ```,
)

// 写作约定：
// 1. 每篇论文都沿用下面七个检查面，读完后删除未使用的小节与 TODO。
// 2. 论文结论只在“实验与证据”和“我的判断”中写，避免摘要和正文混在一起。
// 3. teaser 图统一放在 static/images/siga26-paper-notes/ 下，再取消对应图片行注释。

先建立五篇论文的阅读骨架。读完后会继续补充方法细节、实验判断和与已有工作的联系。

= 1. 神经辐射缓存

== OctaOctree: Neural Radiosity for Real-time Glossy Material Rendering in Static Scenes @ren2026octaoctree [#link("https://arxiv.org/abs/2606.08469", "arXiv")] [#link("https://github.com/jieruijerry/OctaOctree", "Code")] [#link("https://doi.org/10.1145/3829340.3842363", "DOI")]

// #image("/images/siga26-paper-notes/octaoctree.png")

作者：Jierui Ren, Haojie Jin, Bo Pang, Meng Gai, Fei Zhu, Yisong Chen, Sheng Li。发表：SIGGRAPH Asia 2026 Conference Papers。

=== 阅读目标

理解空间层级与方向层级如何互补分配，以及这种表示为何能在主命中点仅做一次网络查询就恢复高频镜面间接光。

=== 读前问题

局部遮挡和视差变化如何映射到八叉树叶节点；八面体方向图在粗层级上保留角分辨率时，空间泄漏与错误可见性如何控制；反射感知先验具体以何种损失或监督进入训练；实时性能、显存和场景规模随八叉树层数如何增长；静态场景假设中最难移除的是哪一部分。

=== 问题与动机

TODO

=== 表征

TODO

=== 训练与推理

TODO

=== 实验与证据

TODO

=== 局限与反例

TODO

=== 我的判断

TODO

=== 待查问题

TODO

= 4. 可微镜面渲染

== Differentiable Rendering for Specular Materials via Projected Specular Manifolds @li2026projectedspecularmanifolds [#link("https://rhythm25.github.io/PSMpage/", "Project")] [#link("https://rhythm25.github.io/PSMpage/static/pdfs/SigAsia26_DiffSpecular_final_v2.pdf", "Paper")] [#link("https://rhythm25.github.io/PSMpage/static/pdfs/SigAsia26_DiffSpecular_supp_final_v1.pdf", "Supplement")] [#link("https://github.com/Rhythm25/PSM", "Code")]

// #image("/images/siga26-paper-notes/projected-specular-manifolds.png")

作者：Ruizeng Li, Peiqi Wang, Beibei Wang, Ligang Liu。发表：ACM Transactions on Graphics (Proc. SIGGRAPH Asia), 45(6), 2026。

=== 阅读目标

理解 projected specular manifolds 如何为镜面光路构造低维且可微的路径参数化，并判断这种投影在移动高光、路径边界和梯度估计稳定性上的作用。

=== 读前问题

论文中的投影把镜面约束映射到哪一组路径参数；“projected” 与直接求解或游走 specular manifolds 的差别是什么；路径参数化在可见性变化和焦散边界处是否连续；梯度估计是无偏的、有偏的，还是只在局部有效；粗糙材质、有限粗糙度和多跳镜面链如何进入该框架；与 path-space differentiable rendering、specular manifold sampling 和 reparameterization 方法相比，它真正减少的是搜索维度、梯度方差还是实现复杂度。

=== 问题与动机

TODO

=== Projected Manifold 参数化

TODO

=== 梯度估计与实现

TODO

=== 实验与证据

TODO

=== 局限与反例

TODO

=== 我的判断

TODO

=== 待查问题

TODO

= 5. 非 SIGGRAPH Asia 2026 补充

== GRay: Ray Tracing 3D Gaussians Near the Speed of Splats @poirierginter2026gray [#link("https://repo-sam.inria.fr/nerphys/gray/", "Project")] [#link("https://arxiv.org/abs/2606.30869", "arXiv")] [#link("https://doi.org/10.1145/3804496", "DOI")] [#link("https://github.com/graphdeco-inria/gray", "Code")]

// #image("/images/siga26-paper-notes/gray.png")

作者：Yohan Poirier-Ginter, Jean-François Lalonde, George Drettakis。发表：I3D 2026（*非 SIGGRAPH Asia 2026*）。

=== 阅读目标

理解为什么大量微小 Gaussian 会让光栅化变慢却让光线追踪变快，以及 GRay 如何通过密集初始化、尺度约束和 BVH 更新优化把 3D Gaussian 光线追踪的优化与渲染速度推到接近 3DGS。

=== 读前问题

光线追踪相对光栅化的对数复杂度在有限高斯半径、截断核和 BVH 更新开销下如何实际体现；密集初始化如何同时影响初始 Gaussian 数量、每像素相交数和优化步数；尺度衰减、提前停止和激进剪枝是否会损失高频细节或导致训练不稳定；有向包围盒对 BVH 更新速度的收益来自哪里；GRay 与 3DGRT 的质量差距集中在哪些视角相关效果或高频区域；分辨率、Gaussian 密度和像素密度之间的匹配关系如何决定两种管线的速度交叉点；相对 Splatting 的质量差距是否来自光线追踪本身，还是来自训练策略与初始化；这项加速对可微渲染、路径追踪和可编辑 Gaussian 场景意味着什么。

=== 问题与动机

TODO

=== 相交复杂度与密集初始化

TODO

=== 训练与光线追踪实现

TODO

=== 实验与证据

TODO

=== 局限与反例

TODO

=== 我的判断

TODO

=== 待查问题

TODO

= 2. 跨本体抓取

== InterMASH: A Unified Geometric Representation for Grasp Synthesis @yang2026intermash [#link("https://inter-mash.github.io/", "Project")] [#link("https://arxiv.org/abs/2609.18504", "arXiv")] [#link("https://doi.org/10.1145/3829340.3842336", "DOI")]

// #image("/images/siga26-paper-notes/intermash.png")

作者：Xuanze Yang, Yumeng Liu, Haiyang Xin, Changhao Li, Haowei Shen, Kai Xu, Ligang Liu, Ruizhen Hu。发表：SIGGRAPH Asia 2026 Conference Papers。

=== 阅读目标

理解 sphere-fixed anchors 如何在不同手部形态之间建立稳定对应，以及球谐编码的局部手部几何、物体几何和接触如何共同组成可直接生成的 token 序列。

=== 读前问题

锚点如何放置、排序并跨本体建立语义对应；低阶球谐是否足以表达指间、掌心和高曲率区域的局部几何；Diffusion Transformer 如何保证手部几何与接触的一致性；物理引导训练和采样分别约束了哪些失败模式；patch-wise IK 会不会抵消生成阶段获得的部分物理可行性；跨本体和人类到机器人迁移的收益是否来自共享几何，而非数据量增加。

=== 问题与动机

TODO

=== 表征与对应关系

TODO

=== 生成模型与物理约束

TODO

=== 实验与证据

TODO

=== 局限与反例

TODO

=== 我的判断

TODO

=== 待查问题

TODO

= 3. 部件检索与装配

== PART: Learning 3D Part Assembly and Retrieval with Transformers @bao2026part [#link("https://iambrc.github.io/PART-project-page/", "Project")] [#link("https://arxiv.org/abs/2609.19872", "arXiv")] [#link("https://github.com/iambrc/PART", "Code")] [#link("https://huggingface.co/datasets/Iambrc/PART", "Data")]

// #image("/images/siga26-paper-notes/part.png")

作者：Ruchao Bao, Wenzheng Wu, Chucheng Xiang, Zhongyuan Liu, Yuan Liu, Jinxin Dong, Ligang Liu, Ziqi Wang。发表：SIGGRAPH Asia 2026 Conference Papers。

=== 阅读目标

理解检索与装配如何统一为可变长度的集合预测问题，以及部件位姿估计和目标分割之间的对偶关系如何帮助检索与 6-DoF 对齐。

=== 读前问题

模型如何在指数级增长的部件库搜索空间中避免显式组合；instance queries 与空类如何表达不同目标所需的部件数量；匹配损失和类别分配如何处理置换、重复部件与近似替代件；segmentation-enhanced optimization 在何时真正修正装配结果；对训练库之外的几何、材质和拓扑是否具备泛化能力；装配结果是否检查碰撞、稳定性和物理可行性；80K+ 数据集的构建偏差会怎样影响真实扫描上的表现。

=== 问题与动机

TODO

=== 检索与集合预测

TODO

=== 位姿估计与分割对偶

TODO

=== 实验与证据

TODO

=== 局限与反例

TODO

=== 我的判断

TODO

=== 待查问题

TODO
