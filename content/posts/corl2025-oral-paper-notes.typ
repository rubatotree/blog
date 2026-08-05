#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "CoRL 2025 Oral 论文速览",
  date: datetime(year: 2026, month: 8, day: 3),
  weight: 0,
  tags: (
    category: ("具身智能", "CoRL", "论文速览")
  ),
  draft: false,
  references: ```bib

  ```,
)

本文使用 AI 工具整理 #link("https://openreview.net/group?id=robot-learning.org/CoRL/2025/Conference#tab-accept-oral", "CoRL 2025 Oral") 的 42 篇论文。为了避免把列表写成摘要搬运，下面按研究问题重新分为六组，并分别概括方法、主要结果与值得留意的边界。

需要说明的是，这是一份基于 OpenReview 标题与摘要的“地图式速览”，适合用来筛选待读论文，不等价于逐篇精读或实验复现。文中的“提升”“达到”等结果均指作者报告的结果。

= 总览：Oral 在解决什么问题

这 42 篇论文呈现出一条很清楚的主线：机器人学习的瓶颈正在从“能否学会一个任务”转向“能否低成本地扩展到新任务、新环境和新本体”。对应地，工作重点也从单纯设计更大的 Policy，转向数据生产、跨本体迁移、推理效率、真实世界评测与失败恢复等完整系统问题。

其中有四个趋势尤其明显。第一，真实机器人示教不再是唯一的数据来源：人类视频、手机扫描、生成模型、仿真与低成本外骨骼都在被转化为训练数据。第二，Diffusion Policy 与 VLA 已成为基础组件，研究开始优化其执行速度、在线适应与推理机制。第三，触觉、音频、力与 LiDAR 等模态被纳入闭环控制，而不只是作为附加观测。第四，研究者开始正面处理评测偏差、分布外失败和开放世界泛化，说明领域正在从 Demo 走向可部署系统。

= 1. 通用策略、推理、评测与安全

这一组关注的不是某项具体技能，而是通用机器人策略如何获得开放世界泛化能力，以及我们如何可信地评价和保护这些策略。

== 1. $pi_(0.5)$: a Vision-Language-Action Model with Open-World Generalization [#link("https://openreview.net/forum?id=vlhoswksBO", "OpenReview")]

$pi_(0.5)$ 在 $pi_0$ 的基础上联合训练多机器人数据、Web 数据、高层语义预测与低层动作。训练样本混合图像、语言、目标检测、子任务预测和动作，使语义知识能够迁移到控制中。作者展示了模型在全新住宅内完成清理厨房、卧室等长时序灵巧任务的能力。它的重要性不只在模型规模，而在于说明异构数据与中间语义任务可以共同支撑端到端 VLA 的开放世界泛化；代价则是系统对数据覆盖、模型规模和推理基础设施的依赖很强。

== 2. Training Strategies for Efficient Embodied Reasoning [#link("https://openreview.net/forum?id=bt1Tovn0SW", "OpenReview")]

本文拆解机器人 Chain-of-Thought 的作用，分别检验表示学习、课程学习与模型表达能力三种假设。结论是：生成推理过程会改善 VLA 表示，而动作预测阶段关注这些推理表示，才能真正兑现性能增益。基于这一分析，作者提出两个更轻量的训练方案，在 LIBERO-90 上取得摘要所称的 SOTA，同时比标准机器人推理快约 3 倍。它提醒我们，显式输出冗长推理文本不是唯一选择，关键可能是训练期间形成并在控制阶段读取有用的中间表示。

== 3. RoboArena: Distributed Real-World Evaluation of Generalist Robot Policies [#link("https://openreview.net/forum?id=cpmwi3Xwcr", "OpenReview")]

RoboArena 不固定任务、环境或实验室，而让分布在多个机构的评测者自由选择真实任务，再对两种匿名策略做成对比较，最终聚合偏好得到排名。作者在七所机构、DROID 平台和七种通用策略上收集了 600 余次真实机器人对比，认为这种众包式评测比单点集中评测更能反映通用能力。其核心价值是把“统一硬件与任务”改为“统一比较协议”；但排名质量仍取决于任务分布、评测者一致性和成对样本覆盖。

== 4. Geometric Red-Teaming for Robotic Manipulation [#link("https://openreview.net/forum?id=ux5EptB7xZ", "OpenReview")]

本文用几何红队测试主动寻找让 Manipulation Policy 崩溃的物体形变。CrashShapes 在满足用户约束和结构有效性的前提下，通过 Jacobian Field 形变与无梯度仿真搜索生成。插入、关节操作与抓取实验表明，常规测试集没有暴露的脆弱性可以被这种搜索稳定找到；再用特定 CrashShape 微调的“蓝队”训练，能针对性恢复性能。它把鲁棒性评测从随机扰动推进到有目标的反例搜索，但对某个反例修补成功并不意味着获得了邻域或开放世界鲁棒性。

== 5. Real-Time Out-of-Distribution Failure Prevention via Multi-Modal Reasoning [#link("https://openreview.net/forum?id=hh9afiQMb2", "OpenReview")]

FORTRESS 将慢速、多模态的高层推理与快速、动力学感知的局部规划解耦。系统在正常运行时低频预测目标和潜在失败；运行时监控器一旦报警，便快速生成回退目标，并规划避开语义危险区域的运动。它试图替代手写 fallback，在 ANYmal 数据、仿真与四旋翼实验中改善安全分类和规划成功率。真正的风险仍在监控器的漏检，以及高层模型没有预见到的危险类别，因此它更像一层可泛化的安全外壳，而非形式化安全保证。

== 6. Belief-Conditioned One-Step Diffusion: Real-Time Trajectory Planning with Just-Enough Sensing [#link("https://openreview.net/forum?id=t2asRJv2SD", "OpenReview")]

B-COD 同时处理轨迹规划与传感器开关：模型以位姿 Belief Raster 和传感器 Mask 为条件，一次前向传播输出短时轨迹、逐点偶然不确定性与定位误差代理。随后由 Soft Actor-Critic 选择维持任务所需的最小传感器集合。作者在无人水面艇上以约 10 ms 的规划开销降低感知能耗，同时保持目标到达能力。关键假设是扩散轨迹的离散程度能够校准为定位误差；当环境或传感器噪声分布改变时，这个代理是否仍可靠值得重点检查。

= 2. 数据扩展与跨本体迁移

这组工作的共同目标，是把昂贵的机器人遥操作数据替换成更容易获得的人类演示、合成轨迹或少量目标域样本。

== 7. Visual Imitation Enables Contextual Humanoid Control [#link("https://openreview.net/forum?id=C6VxzSpjrv", "OpenReview")]

VideoMimic 构造了一条 Real-to-Sim-to-Real 管线：从普通人类视频联合重建人体动作与环境，将二者放入仿真训练全身控制器，再迁移到真实人形机器人。单个环境条件策略能执行上下楼、在椅子或长凳上坐下与起立等依赖场景几何的动作。与只做 Motion Tracking 的工作相比，它把环境上下文也纳入动作复现；误差来源则沿视频重建、人体到机器人重定向和 Sim-to-Real 逐级累积。

== 8. X-Sim: Cross-Embodiment Learning via Real-to-Sim-to-Real [#link("https://openreview.net/forum?id=BO7qo66YJ2", "OpenReview")]

X-Sim 不直接把人手动作映射成机器人关节，而把物体运动视作跨本体的稠密监督。系统从 RGB-D 人类视频重建照片级仿真并追踪物体轨迹，以物体中心奖励训练 RL Policy，再将合成 Rollout 蒸馏为图像条件 Diffusion Policy，部署时在线对齐真实与仿真观测。作者报告其无需机器人遥操作数据，并在五项任务上优于手部重定向和常规 Sim-to-Real。瓶颈由动作标注转移到了可靠的物体重建、追踪与可训练仿真。

== 9. Real2Render2Real: Scaling Robot Data Without Dynamics Simulation or Robot Hardware [#link("https://openreview.net/forum?id=VVhAhzr2WV", "OpenReview")]

用单条人手交互数据生成大量合成示教数据。本文认为示教数据的关键信息是交互对象的运动序列。不考虑碰撞，仅扫描交互对象的 3DGS 外观和位置序列，IK 生成机械臂动作，在渲染器中播放交互对象之间的动画形成示教序列。随机化在于可以随机化交互对象的初始位置和环境外观。

R2R2R 输入手机扫描和一段人类演示，用 3DGS 重建外观与几何、追踪物体六自由度运动，再从不同机器人视角渲染数千条轨迹。方法刻意关闭碰撞动力学，只生成适用于 VLA 和模仿学习的视觉与本体状态数据。作者称单条人类演示生成的数据可以匹配 150 条遥操作示教的训练效果。这是用“外观与运动合成”绕开昂贵动力学仿真的激进路线，适合轨迹可迁移的任务，但难以覆盖接触力、失败恢复和由机器人动作改变的真实动力学。

== 10. AirExo-2: Scaling up Generalizable Robotic Imitation Learning with Low-Cost Exoskeletons [#link("https://openreview.net/forum?id=ksOrtEgIC0", "OpenReview")]

AirExo-2 用低成本外骨骼在自然环境采集人类操作，并通过视觉适配器将视频转换为伪机器人示教；配套的 RISE-2 Policy 融合 3D 空间信息与 2D 语义特征。作者报告，仅使用适配后的野外数据即可接近遥操作数据训练的策略，并在域内与泛化测试上优于既有方法。这种方案用采集设备和视觉适配换取规模，但其跨机器人迁移上限仍受外骨骼运动可达性与伪示教误差约束。

== 11. DexUMI: Using Human Hand as the Universal Manipulation Interface for Dexterous Manipulation [#link("https://openreview.net/forum?id=XrgRvBklWu", "OpenReview")]

DexUMI 同时处理运动学域差异和视觉域差异：可穿戴手部外骨骼把人手运动限制到机器人手可行空间并提供直接触觉反馈，视频中的人手则由高保真的机器人手 Inpainting 替换。作者在两种灵巧手平台上得到平均 86% 的任务成功率。相比纯视觉人类视频，它提供了更可信的关节动作标签；但“通用接口”仍需要面向具体手型的硬件适配与图像生成质量保证。

== 12. ImMimic: Cross-Domain Imitation from Human Videos via Mapping and Interpolation [#link("https://openreview.net/forum?id=7iaYcss56y", "OpenReview")]

ImMimic 用少量机器人示教来吸收大量人类视频。它先将重定向的人手姿态通过 Dynamic Time Warping 与机器人轨迹对齐，再在配对轨迹之间做 MixUp，制造从人域到机器人域的连续中间分布并联合训练。四项真实任务、四种夹爪或灵巧手实验显示，方法能改善成功率与执行平滑度。插值能够缓和域差异，但前提是人类轨迹与机器人轨迹之间存在语义一致、可对齐的路径。

== 13. Data Retrieval with Importance Weights for Few-Shot Imitation Learning [#link("https://openreview.net/forum?id=wnWYoetLhC", "OpenReview")]

IWR 研究如何从大型先验数据集中为少样本目标任务取回训练样本。作者指出常用的最近邻距离等价于 Gaussian KDE 的极限情形，既有高方差，又忽略先验数据自身的密度；因此改用目标分布与先验分布的 KDE 密度比作为重要性权重。仿真与 Bridge 数据实验中，这一小改动稳定改善既有检索方法。它的优点是简单且有统计解释，风险则是高维表示空间中的密度估计仍可能失真。

== 14. One View, Many Worlds: Single-Image to 3D Object Meets Generative Domain Randomization for One-Shot 6D Pose Estimation [#link("https://openreview.net/forum?id=kto4zVmo4w", "OpenReview")]

本文从一张参考图生成带纹理 3D Mesh，用 2D--3D 特征和深度做由粗到细的尺度与位姿对齐，再通过文本引导的生成增强构造多个合理 3D 变体，在 Blender 中渲染大规模域随机化数据以微调位姿估计器。它把单实例参考图扩展成一个合成训练分布，并在多个六自由度位姿基准及真实灵巧抓取中验证。主要不确定性来自单图生成几何的幻觉：域随机化可以覆盖外观变化，却未必能纠正系统性的形状错误。

= 3. 模仿学习的速度、奖励与在线适应

这一组不再只问 Policy 能否完成任务，而是进一步优化执行吞吐、闭环频率和少样本改进能力。

== 15. DemoSpeedup: Accelerating Visuomotor Policies via Entropy-Guided Demonstration Acceleration [#link("https://openreview.net/forum?id=Tl7girqoLi", "OpenReview")]

DemoSpeedup 先在原速示教上训练任意生成式 Policy，并把它用作逐帧动作熵估计器。低熵片段通常需要稳定精细的动作，少做加速；高熵片段相对宽松，可以更激进地下采样。使用重新定时的数据训练后，作者报告执行速度最高提升 3 倍，同时维持甚至改善成功率。这个方法不改推理架构，成本低；但“高熵等于可安全加速”是经验对应，在多模态关键决策点可能恰好不成立。

== 16. SAIL: Faster-than-Demonstration Execution of Imitation Learning Policies [#link("https://openreview.net/forum?id=EGSSHukI05", "OpenReview")]

SAIL 从完整机器人系统出发解决超越示教速度的问题，组合连续动作推断、与控制器无关的高保真目标跟踪、按运动复杂度自适应调速以及面向真实延迟的动作调度。十二项任务上，作者报告仿真最高 4 倍、真实平台最高 3.2 倍加速。它比简单重采样更重视动力学和系统延迟，因此更适合高吞吐部署；相应地，收益也依赖底层控制器的跟踪带宽与硬件安全边界。

== 17. Streaming Flow Policy [#link("https://openreview.net/forum?id=jnpILGz9gQ", "OpenReview")]

传统 Diffusion 或 Flow Matching Policy 生成的是“动作轨迹的去噪轨迹”，中间结果被丢弃，机器人必须等采样结束。Streaming Flow Policy 改为从上一动作附近的窄 Gaussian 出发，沿学习到的速度场增量生成一条动作轨迹，并在积分过程中直接流式执行。训练时让 Flow 在示教轨迹周围稳定，以减小分布偏移。这个重参数化同时提升响应频率并保留多模态行为，不过边生成边执行也减少了撤销错误早期动作的机会。

== 18. Steering Your Diffusion Policy with Latent Space Reinforcement Learning [#link("https://openreview.net/forum?id=jU7AbGq3se", "OpenReview")]

DSRL 不微调 Diffusion Policy 权重，而在其输入噪声的潜空间上运行 RL，从而“引导”黑盒行为克隆策略。因为搜索空间已被示教 Policy 限制在较合理的行为流形附近，真实机器人在线适应所需样本显著减少，也避免直接微调生成模型的不稳定。摘要中的仿真、真实任务和通用预训练策略实验均显示有效。方法的能力上限受基础 Policy 支持集限制：如果所需行为从未出现在其潜空间中，Steering 很难凭空创造。

== 19. ReWiND: Language-Guided Rewards Teach Robot Policies without New Demonstrations [#link("https://openreview.net/forum?id=XjjXLxfPou", "OpenReview")]

ReWiND 从一小批示教中学习语言条件奖励模型，并用该奖励重新标注数据、通过 Offline RL 预训练语言条件 Policy。面对未见任务变体时，系统复用奖励模型，以少量在线交互微调策略，不再为每项新任务收集示教或手写奖励。作者报告奖励泛化和策略对齐指标最高提升 2.4 倍，并在仿真与真实双臂平台验证。核心风险是 Reward Hacking：奖励模型在新任务上的小偏差可能被在线 RL 主动放大。

= 4. 操作、装配与结构化规划

这些论文面向拥挤抓取、双臂协作、衣物、进食和多步装配等具体难题。共同点是将学习模块嵌入显式结构：几何、搜索、状态机、任务规划或物理 Affordance。

== 20. ClutterDexGrasp: A Sim-to-Real System for General Dexterous Grasping in Cluttered Scenes [#link("https://openreview.net/forum?id=4XKKUifQ9c", "OpenReview")]

ClutterDexGrasp 采用 Teacher--Student 两阶段框架。Teacher 在仿真中通过杂乱度 Curriculum、几何与空间嵌入的场景表示以及安全 Curriculum 学习闭环目标抓取，再蒸馏到只看局部点云的 3D Diffusion Policy。作者称这是首个面向杂乱场景、零样本 Sim-to-Real 的目标导向灵巧抓取系统。它把大规模仿真特权信息压进可部署视觉策略，但蒸馏后对遮挡和安全性的保持程度是判断系统价值的关键。

== 21. FetchBot: Learning Generalizable Object Fetching in Cluttered Scenes via Zero-Shot Sim2Real [#link("https://openreview.net/forum?id=5ySSVlJBOn", "OpenReview")]

FetchBot 在一百万个合成场景和五十万条代表性示教上学习杂乱环境取物。模型以深度结构线索生成避障动作，同时用 Foundation Model 从真实 RGB 预测深度，并把局部 Occupancy 预测作为联合任务来弥合深度域差异。作者报告杂乱环境平均成功率 89.95%，并测试透明、反光和不规则物体。系统的巧妙之处是不用真实深度直接对齐仿真；但基础深度模型在特殊材质上的系统误差仍可能传入规划。

== 22. Fabrica: Dual-Arm Assembly of General Multi-Part Objects via Integrated Planning and Learning [#link("https://openreview.net/forum?id=aSUNzvEJIf", "OpenReview")]

Fabrica 将长时序全局规划与接触丰富的局部控制分层组合。上层联合处理装配优先级、序列、抓取和运动规划，并自动生成 Fixture；局部插接步骤则由带等变性先验和规划残差动作的通用 RL Policy 完成。作者在多类工业与日常物体上实现零样本真实迁移，报告接触步骤成功率 80%。这种混合架构比纯端到端方法更可解释，但模块间接口误差和长序列成功率乘积仍是系统瓶颈。

== 23. Latent Theory of Mind: A Decentralized Diffusion Architecture for Cooperative Manipulation [#link("https://openreview.net/forum?id=b24y5SENo5", "OpenReview")]

LatentToM 为每个机械臂维护本体专属的 Ego Embedding 和跨机器人一致的 Consensus Embedding，并让机器人从共识表示推断队友的 Ego 表示。训练中的一阶 Cohomology Loss 强制不同观测视角下的共识对齐；执行时既可共享一次 Embedding，也可完全不通信，仅从对方动作的场景后果隐式协作。真实双臂实验中，其表现接近集中式 Diffusion Policy，并对临时故障或延迟更稳健。推广到更多机器人时，共识表示的容量和隐式可观测性将成为难点。

== 24. Planning from Point Clouds over Continuous Actions for Multi-object Rearrangement [#link("https://openreview.net/forum?id=XF69ltYlMU", "OpenReview")]

本文直接在点云重排空间中做 A\* Search，不先把对象关系和动作离散成 Symbol。搜索候选由学习到的领域先验采样点云变换，再由启发式函数组合成长时序方案。真实餐桌清理和仿真积木实验表明，显式搜索优于单纯 Policy Learning。它保留了连续几何细节，又获得搜索的可回溯性；计算量则取决于动作先验能否高概率提出有效变换，否则连续分支因子会迅速膨胀。

== 25. “Stack It Up!”: 3D Stable Structure Generation from 2D Hand-drawn Sketch [#link("https://openreview.net/forum?id=pukgxvcOwL", "OpenReview")]

StackItUp 允许用户只画正视图草图来指定三维积木结构。系统先抽取忽略度量噪声的关系图，表示左右关系和“双柱桥”等稳定模式，再用组合式 Diffusion Model Ground 到三维位姿，并迭代补全草图中不可见但承重所需的内部与后部支撑。相比直接回归 3D，关系图提供了有用的离散中间层；但评测需要同时权衡视觉相似、结构稳定和可执行性，三者并不总是一致。

== 26. Reactive In-Air Clothing Manipulation with Confidence-Aware Dense Correspondence and Visuotactile Affordance [#link("https://openreview.net/forum?id=sXoaNAECCK", "OpenReview")]

本文不要求先把衣物铺平，而直接处理悬空、褶皱和自遮挡状态。仿真训练的稠密视觉描述子用分布式 Loss 表达布料对称性并输出对应置信度，反应式状态机据此选择折叠策略；触觉 Affordance 网络同时预测抓取位置并在线验证抓取。视觉处理全局形态，触觉确认局部接触，组合适合高不确定性衣物任务。状态机提高了可靠性，但也可能限制方法对训练时未覆盖拓扑变化的适应。

== 27. SAVOR: Skill Affordance Learning from Visuo-Haptic Perception for Robot-Assisted Bite Acquisition [#link("https://openreview.net/forum?id=VrNSv02Xfu", "OpenReview")]

SAVOR 把进食动作的 Skill Affordance 分解为餐具能做什么与食物允许什么。工具 Affordance 离线标定；食物的软硬、含水量和黏度先由视觉语言模型给出常识先验，再在交互中用视触觉网络动态修正，从而实时选择叉取或舀取等技能。二十种单品和十种自然餐食上，作者报告相对类别规则提升 13%。这种在线物性估计能处理食物冷却等时变现象，但探测本身可能改变食物状态，也需要纳入决策代价。

== 28. ScrewSplat: An End-to-End Method for Articulated Object Recognition [#link("https://openreview.net/forum?id=gD6YV5OuW3", "OpenReview")]

ScrewSplat 只用 RGB 观测，随机初始化若干 Screw Axis，再与 Gaussian Splatting 的外观和几何重建联合优化，最终同时恢复刚性部件分割与关节运动学。相较依赖已知部件数、深度图或多阶段 Pipeline 的方法，它把可动对象识别压缩为一个端到端优化问题，并可将恢复的运动学模型用于零样本文本引导操作。随机初始化和联合优化也意味着结果可能对视角覆盖、运动激励与局部最优敏感。

= 5. 触觉、声音与软体硬件

这一组显示，多模态机器人学习的关键不只是“加一个传感器”，而是建立跨传感器表示、可标定硬件以及从仿真到真实的模态桥梁。

== 29. Cross-Sensor Touch Generation [#link("https://openreview.net/forum?id=oGcC8nMOit", "OpenReview")]

本文研究不同视触觉传感器之间的图像翻译。Touch2Touch 使用成对数据做端到端转换；T2D2 则以深度作为中间表示，实现无配对的 Touch-to-Depth-to-Touch。这样，原本绑定某一传感器训练的杯子堆叠和工具插入模型可以迁移到另一传感器。显式深度瓶颈更容易跨设备，但会丢失与几何无关的材料、剪切或光学细节；端到端方案保真度更高，却依赖昂贵配对数据。

== 30. Tactile Beyond Pixels: Multisensory Touch Representations for Robot Manipulation [#link("https://openreview.net/forum?id=sMs4pJYhWi", "OpenReview")]

TacX 在 Digit 360 约一百万次接触交互上，自监督融合触觉图像、音频、运动和压力四种模态，学习跨时空尺度的统一表示。作者报告，相对只用触觉图像的端到端模型，TacX 将 Policy 成功率提升 63%，将触觉恢复物体状态的鲁棒性提升 90%，并改善材质、数量和力等物理属性推断。大规模预训练展示了多模态互补性，但表示仍与 Digit 360 的硬件频响和采集分布绑定。

== 31. DexSkin: High-Coverage Conformable Robotic Skin for Learning Contact-Rich Manipulation [#link("https://openreview.net/forum?id=CNPCSuwxJw", "OpenReview")]

DexSkin 是可贴合复杂曲面的柔性电容电子皮肤，覆盖平行夹爪手指的大部分表面并提供局部、可校准的接触信号。作者在手内重定向和绕盒缠橡皮筋等需要大面积接触感知的任务上验证模仿学习，又通过跨传感器实例标定支持模型迁移和真实机器人在线 RL。相比只在指尖放触觉传感器，高覆盖率能观测意外接触；工程挑战则在耐久性、布线、标定漂移与大面积信号带宽。

== 32. KineSoft: Learning Proprioceptive Manipulation Policies with Soft Robot Hands [#link("https://openreview.net/forum?id=PwKsCO6TAF", "OpenReview")]

KineSoft 把软手的柔顺性从控制困难变成示教接口：人可以直接牵引软手做 Kinesthetic Teaching，内部应变阵列在无遮挡条件下估计手形，再由低层 Shape-conditioned Controller 跟踪形状轨迹，上层 Diffusion Policy 学习本体感觉到动作的映射。真实实验显示其形状估计、跟踪和任务成功率优于基线。它避免依赖外部视觉估计软体形变，但应变到形状的映射可能随材料老化、温度和负载历史漂移。

== 33. The Sound of Simulation: Learning Multimodal Sim-to-Real Robot Policies with Generative Audio [#link("https://openreview.net/forum?id=a9RXjOt5bU", "OpenReview")]

MultiGen 用大型生成模型补足物理仿真器难以模拟的感知模态。论文以倒液体为例，根据仿真视频生成逼真音频，在完全没有真实机器人数据的视听轨迹上训练 Policy，再零样本迁移到新容器和液体。它把生成模型放在“传感器模拟器”而非动作生成器的位置，思路很有扩展性；但生成音频必须与隐藏物理状态因果一致，仅有听感逼真并不足以保证控制有效。

= 6. 移动、平衡与力控制

最后一组覆盖四足、人形和腿式操作。相比早期只追求稳定行走，这些工作更强调跨本体适应、极限平衡、全身接触、能耗与动态避障。

== 34. Sampling-based System Identification with Active Exploration for Legged Sim2Real Learning [#link("https://openreview.net/forum?id=UTPBM4dEUS", "OpenReview")]

SPI-Active 先通过大规模并行采样，让仿真轨迹与真实轨迹的状态预测误差最小，以识别腿式机器人关键物理参数；再优化探索 Policy 的输入命令，使采集轨迹的 Fisher Information 最大。它不要求可微动力学或直接力矩测量，适合接触丰富系统。作者报告多项 Locomotion 任务相对基线提升 42% 到 63%。主动探索提高可辨识性，也必须受到真实硬件安全约束，否则“信息最大”可能对应高风险动作。

== 35. Non-conflicting Energy Minimization in Reinforcement Learning based Robot Control [#link("https://openreview.net/forum?id=kUA2ec94LI", "OpenReview")]

本文不再把能耗乘一个手调权重塞进 Reward，而在 Policy Gradient 空间投影任务目标与能耗目标，阻止节能更新损害任务表现。DM-Control、HumanoidBench 和 Unitree Go2 实验中，作者报告在维持相近任务性能的同时减少 64% 能耗。它提供了近乎无超参数的多目标优化接口，不过“不冲突”是基于当前批次梯度的局部判断，未必等价于长期 Pareto 最优。

== 36. Versatile Loco-Manipulation through Flexible Interlimb Coordination [#link("https://openreview.net/forum?id=Spg25qkV81", "OpenReview")]

ReLIC 让机器人按任务动态决定哪条腿负责支撑、哪条腿负责操作。自适应控制器在 Manipulation Motion Execution 与稳定步态生成两个模块之间协调，并接受目标轨迹、接触点或自然语言等不同任务规格。十二项真实任务平均成功率为 78.9%。模块化接口让同一低层能力适配多种任务，但肢体角色切换时的稳定裕度，以及上层指令不可行时的处理，是实际部署关键。

== 37. Divide, Discover, Deploy: Factorized Skill Learning with Symmetry and Style Priors [#link("https://openreview.net/forum?id=Ddb8w8FVV9", "OpenReview")]

本文将无监督 Skill Discovery 的状态空间按因素拆分，为不同因素配置不同内在奖励，并加入面向机器人形态的对称性先验；额外的 Style Factor 与正则项用于约束安全性和动作风格。四足仿真中发现的技能具有更清晰的人类可解释结构，并能零样本迁移到真实硬件、服务下游任务。Factorization 提高可控性，却也把状态如何拆分这一强先验交给设计者，可能遗漏跨因素耦合技能。

== 38. HuB: Learning Extreme Humanoid Balance [#link("https://openreview.net/forum?id=FCpYuGtN4j", "OpenReview")]

HuB 针对极限单脚平衡中的三类问题，分别设计参考动作修正、Balance-aware Policy Learning 与 Sim-to-Real 鲁棒训练，处理参考误差、人体和机器人形态差异以及未建模动力学。Unitree G1 能完成燕式平衡和高踢等准静态动作，并承受足球冲击。它说明高质量 Reference 不是固定真值，而应与机器人动力学共同优化；实验主要集中在准静态极限姿态，向动态连续技能迁移仍需验证。

== 39. FACET: Force-Adaptive Control via Impedance Reference Tracking for Legged Robots [#link("https://openreview.net/forum?id=EcOGafgvuC", "OpenReview")]

FACET 让 RL Policy 模仿一个虚拟质量--弹簧--阻尼系统，通过改变虚拟弹簧控制机器人在外力下的柔顺性。仿真中系统能承受较大冲量并把碰撞冲量降低 80%，真实四足能由指尖轻推启动或停止，也能拖动 10 kg 负载；作者还扩展到腿式操作和人形机器人。它在学习控制与经典阻抗控制之间建立了清晰接口，但性能依赖虚拟参考模型覆盖真实接触动态。

== 40. Learning a Unified Policy for Position and Force Control in Legged Loco-Manipulation [#link("https://openreview.net/forum?id=MpJTyAqA0t", "OpenReview")]

本文在没有力传感器的条件下，用历史状态估计外力，并通过位置与速度调整联合响应力命令和位置命令。仿真中随机组合主动命令与外部扰动训练后，同一 Policy 可以执行位置跟踪、施力、力跟踪与柔顺控制；作为轨迹模仿的低层控制器时，四项接触任务成功率平均提高约 39.5%。其可迁移性依赖力估计器的可观测性，未建模柔性接触可能使估计产生偏差。

== 41. Omni-Perception: Omnidirectional Collision Avoidance of Legged Robots in Dynamic Environments [#link("https://openreview.net/forum?id=KUSYJIlKor", "OpenReview")]

Omni-Perception 直接从时空 LiDAR 点云学习腿式移动，不经过 Elevation Map 等中间表示。核心 PD-RiskNet 分层建模近端与远端风险；配套的高保真 LiDAR 仿真工具加入噪声和快速 Ray Casting，可接入 Isaac Gym、Genesis 与 MuJoCo。真实实验展示了对静态、动态和非平面障碍的全向避障。端到端点云减少了地图瓶颈，但安全分析更困难，也会受 LiDAR 稀疏区和反射异常影响。

== 42. LocoFormer: Generalist Locomotion via Long-context Adaptation [#link("https://openreview.net/forum?id=VqmAvBkFhw", "OpenReview")]

LocoFormer 在程序生成的大量腿式与轮式机器人上进行大规模 RL 和激进 Domain Randomization，并把上下文长度扩展到跨 Episode。测试时，同一 Policy 无需精确运动学即可控制未见本体，并能适应负载变化、电机故障等扰动；极端情况下，模型会从前几次跌倒中改善后续 Episode 的控制。长上下文把在线 System Identification 隐式放入序列模型，但跨 Episode 记忆也可能积累错误，需要明确重置和安全恢复机制。

= 我会优先精读什么

如果关注 VLA 与通用 Policy，优先读 $pi_(0.5)$、Training Strategies for Efficient Embodied Reasoning 和 RoboArena：三篇分别对应训练、推理与评测。如果关注低成本数据，VideoMimic、R2R2R、X-Sim 与 DexUMI 展示了四种差异很大的路线：视频重建、渲染合成、物体中心奖励和硬件重定向。如果关注可落地的控制系统，Streaming Flow Policy、Fabrica、FACET 与 LocoFormer 更值得精读，因为它们都在学习算法之外认真处理了执行频率、模块接口或真实动力学。

从选题角度看，CoRL 2025 Oral 最值得借鉴的不是某一个网络结构，而是“找到系统瓶颈后重新定义问题”的能力：RoboArena 重定义通用策略评测，SAIL 重定义模仿学习的速度目标，Geometric Red-Teaming 重定义鲁棒性测试，MultiGen 则把生成模型重定义为难模拟传感器的替身。这些问题定义比单点指标提升更可能产生长期影响。

= 来源

- #link("https://openreview.net/group?id=robot-learning.org/CoRL/2025/Conference#tab-accept-oral", "CoRL 2025 Conference — Accept (Oral)")，共 42 篇，访问于 2026 年 8 月 3 日。
- 各小节标题后的 OpenReview 链接指向对应论文页面；本文的数量、标题和摘要级事实均以这些公开页面为准。
