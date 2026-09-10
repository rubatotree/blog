#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "MiracleAug: 用 GPT-6 Astra 点燃具身数据增强的核弹吧",
  date: datetime(year: 2026, month: 9, day: 10),
  weight: 0,
  tags: (
    category: ("计算机图形学", "具身智能", "Agent", "Blender")
  ),
  draft: false,
  references: ```bib
  @video{timliuqian,
    author = {影视飓风, 刘谦},
    title = {决战刘谦！魔术VS超高速摄影机，能拍到破绽吗？},
    year = {2021},
    date = {2026-09-19},
    url = {https://www.bilibili.com/video/BV1Uh411p7r3}
  }
  @software{zhu2026miracleaug,
    author  = {Zhu, Yutian},
    title   = {MiracleAug},
    year    = {2026},
    date    = {2026-09-10},
    version = {0.1.3},
    url     = {https://github.com/rubatotree/miracle-aug-skill/tree/v0.1.3}
  }
  ```,
)

#figure(
  image("/images/miracle-aug-1/teaser.png"),
  caption: "你要用 GPT-6 Astra 毁了我们整个行业吗。" + cite(<timliuqian>)
)

本周我尝试完成了一个名叫 #link("https://github.com/rubatotree/miracle-aug-skill", "MiracleAug") #cite(<zhu2026miracleaug>) 的项目，用 GPT-6 Astra + Blender 代替过去我们具身数据增强管线中的几乎所有环节。

周一下班后，由于 GPT-Plus 在周一晚上就重置了，而我还有 70% 的 Plus 额度，看到社区上巨大的讨论，我计划试试 GPT-6 Astra 的 3D 建模能力。我首先给 GPT-5.6 Sol 发了一段我曾经尝试过的“请给我一段用于生成梦幻可爱风格粉色女生房间造景3D三渲二场景的提示词，我稍后会将提示词交给Astra模型进行Blender 3D建模。”提示词，让它扩写这段提示词，并将扩写后的提示词发给了 GPT-6 Astra。一个小时后，5小时额度见底了，这是它交付给我的结果：

#figure(
  image("/images/miracle-aug-1/astra-room.png"),
  caption: "场景完成度意外的非常高非常漂亮。三渲二的质感也很好。"
)

于是我把我周日周报上画的 pipeline 图改了一下，本意是制作一张 meme 图。

#figure(
  image("/images/miracle-aug-1/meme-pipeline.png"),
)

后来想到反正额度还没见底，要不就真的试试这条管线呢。于是我为 Astra 准备了之前环绕场景拍摄的一段视频，以及一段具身示教数据。在用尽两次 5 小时额度后，它向我交付了这样的结果（背景已脱敏处理）：

#figure(
  image("/images/miracle-aug-1/gpt-astra-recon.png")
)
#figure(
  image("/images/miracle-aug-1/task-sequence.jpg")
)
#figure(
  image("/images/miracle-aug-1/overview.jpg")
)

这个视频以及后面的增强数据发出来后身边所有人都爆炸了。

在新的任务中，我仅提供了多视角照片，要求 MiracleAug 完整重建场景、生成示教轨迹并生成大量 Augmentation 数据集。在这一任务中 GPT-6 Astra 则花费了非常长的时间与非常大量的 token（是上一个任务的数十倍）才完成任务。

能观察到的问题：

- 不擅长大量复杂几何物体的建模，需要花费非常大量 token 和时间在上面。
- 无示教情况下的轨迹生成会验证很久物理正确性。
- 得到的场景因为仍然是 Mesh 几何体建模，少了一些现实中的“瑕疵感”和“随机性”，这是相比 3DGS 表示的缺陷。（也许能解决）
- 正向渲染仍然是重大开销，上千条示教数据没有很好的 Batch Rendering 机制。
- 防御性编程。反复检查轨迹正确性、甚至反复检查视频压缩帧正确率，增大了很多不必要的时间与 token 开销。

MiracleAug 揭示了大语言模型本身已经能完全走通具身数据增强的管线。那么自然地，我们需要考虑的问题变成了，怎么用传统图形学方法替代掉 MiracleAug 管线中的困难环节、怎么用大语言模型方法替换掉传统图形学管线中的困难环节、以及大语言模型方法为这条管线提供了怎样的新的可能性。