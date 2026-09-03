#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "“结构感知的 Real2Sim 重建” 工作梳理",
  date: datetime(year: 2026, month: 9, day: 3),
  weight: 0,
  tags: (
    category: ("计算机图形学", "3D Gaussians", "动画技术", "论文笔记")
  ),
  draft: false,
  references: ```bib
    @article{huang2023sc,
      title={SC-GS: Sparse-Controlled Gaussian Splatting for Editable Dynamic Scenes},
      author={Huang, Yi-Hua and Sun, Yang-Tian and Yang, Ziyi and Lyu, Xiaoyang and Cao, Yan-Pei and Qi, Xiaojuan},
      journal={arXiv preprint arXiv:2312.14937},
      year={2023}
    }
    @inproceedings{yao2025riggs,
      author    = {Yao, Yuxin and Deng, Zhi and Hou, Junhui},
      title     = {RigGS: Rigging of 3D Gaussians for Modeling Articulated Objects in Videos},
      booktitle  = {CVPR},
      year      = {2025},
    }
    @misc{chao2026svgssparseview4d,
      title={SV-GS: Sparse View 4D Reconstruction with Skeleton-Driven Gaussian Splatting}, 
      author={Jun-Jee Chao and Volkan Isler},
      year={2026},
      eprint={2601.00285},
      archivePrefix={arXiv},
      primaryClass={cs.CV},
      url={https://arxiv.org/abs/2601.00285}, 
    }
    @article{le2024articulate,
      title={Articulate-Anything: Automatic Modeling of Articulated Objects via a Vision-Language Foundation Model},
      author={Le, Long and Xie, Jason and Liang, William and Wang, Hung-Ju and Yang, Yue and Ma, Yecheng Jason and Vedder, Kyle and Krishna, Arjun and Jayaraman, Dinesh and Eaton, Eric},
      journal={arXiv preprint arXiv:2410.13882},
      year={2024}
    }0
  ```,
)

将现实物体扫描并整理成游戏引擎/具身引擎支持的、可参与交互及编辑的数字模型资产，一直以来是计算机图形学研究的重要方向。过去的工作已经在刚体层面的 Real2Sim 重建上取得了重大进展。但是仿真引擎中支持的交互物体不止有刚体。考虑到具身和游戏需求的 Real2Sim 输出的内容是渲染出的动画，我们重建出的资产也需要为这一点服务。

游戏引擎中的动画可以划分为这几类：刚体动画、骨骼动画、物理仿真动画（除此之外还有在游戏或现实中相对少见的顶点动画、2D帧动画、形变动画、粒子动画等，在此不做考虑）。现有的 4DGS 工作虽然用形变网络或升维的形式取得了较好的进展，但这种形式的资产可以类比顶点动画，并不太适用于编辑或交互，存储和在线计算成本也高于游戏的需求，因此将现在顶点动画级别的重建优化到骨骼动画/物理仿真动画是非常讲得通的工作。

我们这里主要关注骨骼动画级别的 4D 资产重建。从顶点动画到骨骼动画实际上是做了这样的假设：所有顶点的运动可以由少量的基函数线性表示，而这些基函数就对应现实中我们观察到的骨骼结构。因此这里将这类工作称为“结构感知的 Real2Sim 重建”。

我们希望的目标是用尽可能低的采集成本（仅一部手机或相机）和尽可能低的计算成本（仅一台普通 PC）重建出外观真实、结构清晰、且可编辑的骨骼动画资产，且人工需要的操作最好优化到只有采集部分，不需要后续人工参与处理。例如，玩家可以用自己的手机按指示“扫描”一遍自己，就可以上传至游戏中绑定动画预设作为自己的 avatar，理想情况下可以做到这样很酷的效果。

一般来说，这种采集成本意味着我们可以有某个状态的稠密观察（可以对场景扫描一圈），以补充我们对整个场景的信息认知，但对运动只有单视角的稀疏观察（只有单目视频可以用）。而对于具身应用来说，我们拥有的信息还有机械臂的 URDF、运动过程中的关节信息、以及大量良好标注的先验仿真数据集。从具身先验入手，这个问题可能会稍微好做一些。

并且我们希望我们的问题不是欠定的。例如稀疏 3DGS 重建类问题，大部分不可见视角依赖于生成模型的修补，这类方法虽然也有应用价值，但我们更希望能采集到足以恢复完整细节的信息，重建出高质量高保真的资产。

我们精读并梳理一些与这一目标相关的近期工作。

== 一. 骨骼动画级别的 Gaussian 重建与绑定

=== SC-GS: Sparse-Controlled Gaussian Splatting for Editable Dynamic Scenes (CVPR 2024)

=== RigGS: Rigging of 3D Gaussians for Modeling Articulated Objects in Videos (CVPR 2025)

=== SV-GS: Sparse View 4D Reconstruction with Skeleton-Driven Gaussian Splatting (CVPR 2026)

== 二. 基于预训练模型的场景结构预测

=== Articulate-Anything: Automatic Modeling of Articulated Objects via a Vision-Language Foundation Model (ICLR 2025)

== 三. 生成修补式稀疏重建

== 四. 前馈 3DGS 系列工作跟进