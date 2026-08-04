#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "图形已死，all in AI具身 I: RoboSplat 论文阅读与杂谈",
  date: datetime(year: 2026, month: 6, day: 4),
  weight: 0,
  tags: (
    category: ("计算机图形学", "具身智能", "3D Gaussians", "论文笔记")
  ),
  draft: false,
  references: ```bib
@misc{yamashita2026chokaguyahime,
  author       = {山下清悟},
  title        = {超かぐや姫！},
  howpublished = {Netflix},
  year         = {2026},
  note         = {アニメーション映画。監督：山下清悟。制作：STUDIO COLORIDO、STUDIO CHROMATO、ツインエンジン。2026年1月22日配信},
  url          = {https://www.netflix.com/title/81756595}
},
@article{robosplat,
  title={Novel Demonstration Generation with Gaussian Splatting Enables Robust One-Shot Manipulation},
  author={Yang, Sizhe and Yu, Wenye and Zeng, Jia and Lv, Jun and Ren, Kerui and Lu, Cewu and Lin, Dahua and Pang, Jiangmiao},
  journal={arXiv preprint arXiv:2504.13175},
  year={2025}
}
@misc{yu2018oneshotimitationobservinghumans,
  title={One-Shot Imitation from Observing Humans via Domain-Adaptive Meta-Learning}, 
  author={Tianhe Yu and Chelsea Finn and Annie Xie and Sudeep Dasari and Tianhao Zhang and Pieter Abbeel and Sergey Levine},
  year={2018},
  eprint={1802.01557},
  archivePrefix={arXiv},
  primaryClass={cs.LG},
  url={https://arxiv.org/abs/1802.01557}, 
}
@misc{heskey0zhihuembodied,
  title={具身智能 - 学术界的10年。从物理仿真到世界模型},
  author={Heskey0},
  year={2025},
  url={https://zhuanlan.zhihu.com/p/1925196445184656677},
}
@misc{octoday_robotics_2026,
  author = {Octoday Embodied-AI Community},
  title  = {具身智能知识索引与产业地图},
  year   = {2026},
  url    = {https://github.com/Octoday-Hub/Embodied-AI}
}
  ```,
)
#figure(
  caption: "玩音乐的最终归宿是转行具身智能。" + cite(<yamashita2026chokaguyahime>),
  image("/images/embodied-notes-1-robosplat/teaser.png"),
) <fig-robosplat-teaser>
这周组会上导师提到现在做 Rendering 已经很难有价值和影响力了，也很难找到好的课题，应该 all in 具身智能。感觉自己从一个转型阵痛期的组跳进了另一个转型阵痛期的组。不过转型是正确的，具身方向的确好发有影响力的论文，就业前景也比传统图形学好。虽然私心比较喜欢简洁优雅但没用的图形学，但确实应该现实一点。我们该思考一下怎样把已有的图形学、渲染经验搬到具身智能的应用上。

组里同学分享的 RoboSplat @robosplat 一文确实相当契合 CG for embodied 的愿景，因此我们从这篇论文开始了解我们能够做什么。

= 论文概要

本文的目标是通过输入场景的多视角 RGB 图片和*单次*示教样本（Expert Demonstration，人工操作机械臂完成一次任务，得到每帧的机械臂状态数据和单监督视角 RGB 图像序列）训练 VLA 模型泛化完成不同干扰场景下的同一任务。本文试图解决的干扰场景分为物体位姿移动(Object Pose)、监督相机移动(Camera View)、光照条件改变(Lighting)、物体种类改变(Object Type)、周边环境改变(Appearance)、机械臂外观改变(Cross Embodiment)六种。

#figure(
  caption: "论文 teaser，展示了 RoboSplat 的训练过程。",
  image("/images/embodied-notes-1-robosplat/robosplat-teaser.png"),
) <fig-robosplat-teaser>

本文做到泛化的具体方法则是做*数据增强*，从单次示教样本中根据这几种干扰情况生成上千条增强样本 (augmented demonstrations)。以往生成增强样本的思路是直接在 2D 图像空间做生成式编辑，而本文考虑将多视角图片训练成 3DGS 场景（并在语义上分离场景、物体、机械臂，给机械臂绑骨），去在 3DGS 场景中做编辑模拟这些干扰，再合成回样本图像序列。这样做的好处是保证了图像之间场景的一致性，且不会有抖动等情况出现，因此能准确指导 VLA 模型学习到正确的操作策略。

本文对这几种任务做了测试：

- Pick Object（抓取物体）：机械臂需要抓起放置在 30cm\*40cm 范围桌面上的目标物体。
  - 难点： 测试基本的空间 3D 定位与抓取能力。
- Close Drawer（关闭抽屉）：机械臂需要推关一个抽屉。抽屉的位置在 15cm\*40cm 范围内随机变化，且抽屉在 Z 轴方向的旋转角度在 [-pi/8, pi/8] 之间随机偏转。
  - 难点： 涉及与关节体（Articulated Object）的物理交互，且需要适应抽屉角度的偏转。
- Pick-Place-Close（抓、放、关抽屉）：这是一个多步骤的长程任务。机械臂需要：(1) 抓起桌上的物体 - (2) 将其放入抽屉 - (3) 最后将抽屉推关上。
  - 难点： 步骤多，任何一步失败都会导致整个任务失败，累积误差大。
- Dual Pick-Place（双目标连续抓放）：机械臂需要连续抓起放置在不同位置的两个目标物体，并依次将它们放入固定的抽屉中。
  - 难点： 测试策略在连续操作和多目标调度下的稳定性。
- Sweep（扫地/清理）：这是一个工具使用（Tool Use）任务。机器人需要：(1) 首先精准抓起一把刷子（扫帚）- (2) 然后使用刷子将砧板上的巧克力豆扫进簸箕（尘推）中。
  - 难点： 涉及复杂的接触力和精细的工具操作轨迹。

#figure(
  caption: "测试这些任务的具体图片场景。",
  image("/images/embodied-notes-1-robosplat/robosplat-tasks.png"),
) <fig-robosplat-tasks>

本文没有做模拟测试，只做了实机测试。得到的结果均在干扰样本下能有 90% 级别的成功率，远远超出过去 2D 图像空间增强的方法。虽然本文需要生成更多增强样本达到和手动收集样本一样的成功率，但相比于手动收集样本的时间成本来说，本文的贡献是显而易见的。

#figure(
  caption: "与手动操作收集样本的对比实验结果。",
  image("/images/embodied-notes-1-robosplat/robosplat-exp-vs-manually.png"),
) <fig-robosplat-exp-vs-manually>

#figure(
  caption: "关于更改光照和外观的消融实验。下方的图例分别是：少量人工示教样本、RoboSplat 方法只增强位姿不增强光照/外观训练的模型、2D 图像空间增强方法、RoboSplat 完整的增强数据。",
  image("/images/embodied-notes-1-robosplat/robosplat-exp-lighting.png"),
) <fig-robosplat-exp-lighting>

= 应用与愿景

具身智能的训练路线大致可以分为“大数据大模型”和“小数据高效率”两条，前者依赖大量的人工操作样本去试图泛化解决大量任务，后者试图根据少量的示范快速学习精确的任务。本文可以归类为后者。

一篇 2018 的单样本具身智能学习论文 @yu2018oneshotimitationobservinghumans 提到，理想的家庭机器人体验是：当你买了一个机器人回家，你希望对它说:“看好了，我演示一次怎么开这个抽屉，你以后就会了。” 这就是*单样本模仿学习(One-Shot Imitation Learning)*的终极愿景。

本文的目的当然也是实现这个愿景，且采用的方式是数据增强：人类只需要做一次演示，剩下的数千次数据由 3DGS 生成，来达到和人类做数千次演示一样的训练结果。

虽然很难不怀疑未来力大砖飞的大模型总能通过微调快速泛化到具体的任务场景，但现实世界的确太复杂了，用高几何先验的手段先去增强数据喂给模型想必效果还是比让模型自己想象“增强”要更行之有效的（对吗）。

= 关于增强数据的物理正确性

本文在 3DGS 场景做干扰这一步做了*刚体假设*，即将物体、机械臂的骨骼视作刚体进行编辑，直接改变它们的位姿来模拟干扰。Appearance、Object Type、Cross Embodiment 这三种干扰是直接在 3DGS 场景中替换物体或机械臂的模型来模拟的。Lighting 则是给全局的 Gaussians 加一层色彩映射类的“滤镜”。换言之，本文完全没有考虑光照的物理正确性，也没有考虑具体运动中的物理交互。

#figure(
  caption: "论文 Method Overview。先将测试数据训练成 3DGS 场景并用语义模型做分割、机械臂绑骨，用示教数据引导生成逐帧的数据。然后展示了几种数据增强的方式。",
  image("/images/embodied-notes-1-robosplat/robosplat-pipeline.png"),
) <fig-robosplat-pipeline>

很难说是不是对任务做了 cherry-pick，专门挑了对光照和物理不敏感的任务。从 @fig-robosplat-tasks 可以看出这些任务的场景都很简单，没有复杂的物理交互或光照，也没有对光照较敏感的任何材质（如金属表面、光滑小球、玻璃材质）。

本文的实验没有对“3D滤镜”增强的数据和单用“2D滤镜”原始方法的数据增强做对比，考虑到它们实际表现都只会改变颜色的分布而没有做重光照，这里的“Lighting”增强可能相比原始 2D 增强的提升并不大（把这种增强叫做 Lighting 实在会惹恼图形学人）。可以认为本文根本没有在“光照条件”这一点上做增强。

3DGS 带来提升的主要是 Object Pose、Camera View、Appearance、Cross Embodiment 这些对 3D 空间的外观做修改、从而高度依赖帧间一致性和多视角一致性的增强（保证几何是正确的，事实上这些任务对几何的依赖也确实高于对光照的依赖）。

本文的 Limitation 也只提到了目前的刚体假设会在物理交互上不正确，完全没有提到光照增强的物理不正确性是否可能造成影响。

然而目前并没有证据表明物理正确的光照能带来更好的训练效果。甚至可能出现这样的现象：大量不正确的光照会引导模型学到更鲁棒的特征，如更关注几何，而不是过拟合于特定的光照条件。也就是说，物理不正确的增强可能反而更有利于模型的泛化能力（“域随机化”）。这对图形学人来说的打击还是很大的。

如果我们要做物理更正确的材质/光照增强，我们需要思考 RoboSplat 的 failure case，在怎样的场景中这种暴力的增强方法的确会干扰模型的判断。一个好想的例子是，一个纯金属的物体，若直接移动 Gaussians，随着物体的移动其外观不会发生改变，但现实中物体移动后表面的光照分布就完全变化了，模型可能不会认为这在前后是同一个物体了，从而造成任务的失败。另一个例子是在环境光分布较复杂的场景中，物体在不同位置的外观不同，模型也可能无法正确识别了。

但一方面这种金属场景/复杂光照分布对物理正确重光照本来就是非常困难的事情，另一方面，我们也可以设计物理不正确但简单、覆盖面广的增强方案（如让物体颜色随时间随机变化）去引导模型只学物体的几何等光照/材质无关特征以提高鲁棒性、自然适应现实中的复杂光照和材质。目前来看“不那么图形学”的后者方案反而更有价值、更能体现“泛化”的力量。

不管怎样，买条机械臂去手动试出来 RoboSplat 及其它 SOTA 方法的 failure case 是现在需要做的实在的事情。

= 图形已死，all in AI具身

看了今年 SIGGRAPH 的许多文章，感觉图形学的确是有一点似了。基本上不是优雅但无用的工作，就是有用但不优雅的工作。Best Paper 及提名文章里也没有看到什么基于新方法的创新工作，做的基本上还是传统的图形学。今年更是没有一篇标题和具身智能相关的工作。虽然自己理想很想做那些优雅但无用的工作，但毕竟是要吃饭的。

目前 GCL 组里有许多老师正在转行具身智能。PKU 和 NJU 过去做渲染的老师也都在往具身的方向靠。但目前这些转型中的组都还在摸索阶段。也许需要多和做具身的人联系，整理一下经验。

从某个图形学转行群 @heskey0zhihuembodied 潜水吃了一下图形学转行具身的新进展。今年暑期的启明星夏令营都已经变成以具身智能为主题了。还在群里摸到了一个#link("https://github.com/Octoday-Hub/Embodied-AI", "具身智能资源收集仓库") @octoday_robotics_2026，感觉会很有用。（虽然看到 RoboSplat 这篇文章似乎还没收录进去？许多收录文章和图形学都没关系。

不管从上文的论文阅读还是最新的论文来看，Rendering 和具身智能的结合还是不太容易的，并且想要把图形学的问题解耦出来而不参与具身的训练感觉不太可能。Monte Carlo PDE 方向在今天 VLA 方法主导下更难蹭上具身智能。物理仿真和动画可能更加贴近具身智能，但我们都不熟悉这个方向。希望我们的转型能早点熬出头。

今后有必要熟悉一下具身智能的整套实验到测试的管线，在买到机械臂之前熟悉一下各种模拟器。没有背景的方向就是很难做哇。