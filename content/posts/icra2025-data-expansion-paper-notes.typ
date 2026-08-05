#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "ICRA 与 IROS 2025 数据扩展论文速览",
  date: datetime(year: 2026, month: 8, day: 4),
  weight: 0,
  tags: (
    category: ("具身智能", "ICRA", "IROS", "数据扩展", "论文速览")
  ),
  draft: false,
  references: ```bib

  ```,
)

本文联合整理 ICRA 与 IROS 2025 的数据扩展工作。ICRA Proceedings 收录 1,604 篇论文并补全 1,602 篇摘要，自动召回 279 篇候选后人工保留 32 篇；IROS Proceedings 收录 1,985 篇论文并补全 1,983 篇摘要，从 309 篇候选中人工保留 31 篇。两届合计审计 3,589 篇论文，在同一主题框架下比较机器人数据如何被采集、转换、合成、筛选和复用。

这里的“数据扩展”不只指增加轨迹数量，也包括降低采集成本、吸收人类视频、跨本体共享监督、生成物理可执行数据、复用失败示教，以及让触觉和声音等稀缺模态进入通用 Policy。每篇整理基于公开摘要，实验数字均指作者报告的结果。

其中三篇 ICRA 入选工作获得分领域最佳论文奖：Robo-DM 获 Robot Learning，Human-Agent Joint Learning 获 Human-Robot Interaction，PolyTouch 获 Field and Service Robotics。IROS 部分不按奖项筛选，而是优先补充低成本采集、跨本体生成、Real-to-Sim 和数据配方方面与 ICRA 可对照的工作。

= 总览：六种数据扩展方式

- *降低真实采集成本*：用共享控制、众包、增强现实和云端仿真提高单位操作者时间的有效轨迹数。
- *把人类行为转成机器人监督*：从第一视角视频恢复手--物运动、图像轨迹、控制参数或物体中心奖励。
- *围绕少量示教扩展分布*：利用反事实变换、自动轨迹生成、质量筛选和课程学习得到更多可执行样本。
- *把真实场景搬入仿真*：以 Gaussian Splatting 重建视觉环境，再生成交互、奖励和策略 Rollout。
- *提高接触数据复用率*：同步采集力与运动，学习规范化触觉表示，并使用无配对多模态预训练。
- *重新设计数据配方*：研究模拟与真实数据的混合比例，并用语言、VLA 教师或世界模型复用异构监督。

= 1. 数据基础设施与采集

这组工作首先处理采集系统本身：如何降低操作者负担、让非专家参与，并使多模态轨迹能够被高效存储和训练读取。共同趋势是把数据工程从实验脚本提升为机器人学习系统的一等组件。

== ICRA 2025

=== Robo-DM: Data Management for Large Robot Datasets [#link("https://doi.org/10.1109/ICRA55743.2025.11128693", "DOI") / #link("https://arxiv.org/abs/2505.15558", "arXiv")]

大规模遥操作示教同时包含多路视频、文本和数值轨迹，整理、传输与训练读取都很困难。Robo-DM 提供基于云端的开源数据管理工具，以 EBML 保存自包含数据，并用压缩和内存映射解码缓存降低存储与读取成本。相较 OXE 使用的 RLDS，作者报告有损压缩最高节省 70 倍空间、无损压缩节省 3.5 倍；顺序解码相较 LeRobot 最快 50 倍，实际抓取实验使用 75 倍压缩且下游精度无下降。该收益依赖视频压缩质量与解码缓存配置，极端压缩仍需针对任务验证。

=== Human-Agent Joint Learning for Efficient Robot Manipulation Skill Acquisition [#link("https://doi.org/10.1109/ICRA55743.2025.11127637", "DOI") / #link("https://arxiv.org/abs/2407.00299", "arXiv")]

灵巧手和夹爪的遥操作具有高维动作、复杂运动及人机结构差异，示教成本较高。该系统让人类操作者与一个在线学习的辅助 Agent 共享末端控制，并可调节人工与自动控制比例；辅助 Agent 随数据积累逐渐接管重复控制。仿真和真实实验、用户研究及定量评估显示，方法提高采集效率、减少操作者适应负担，同时保留足够的数据质量供下游学习。效果依赖辅助策略的早期学习稳定性以及共享控制比例的选择。

=== RoboCrowd: Scaling Robot Data Collection Through Crowdsourcing [#link("https://doi.org/10.1109/ICRA55743.2025.11127402", "DOI") / #link("https://arxiv.org/abs/2411.01915", "arXiv")]

专家示教难以大规模采集，RoboCrowd 将 ALOHA 双臂平台部署在公共环境，并用物质奖励、内在兴趣和社会比较三类激励吸引非专家参与。为期两周的咖啡馆实地实验中，超过 200 人自发提供了 800 多个交互 Episode，激励设计能够同时影响数据数量和质量。众包数据作为预训练数据时，后续专家微调策略的性能最高提升 20%。参与者能力、任务设计和公共场景会影响数据分布，众包数据不能直接替代专家示教。

=== ARCap: Collecting High-Quality Human Demonstrations for Robot Learning with Augmented Reality Feedback [#link("https://doi.org/10.1109/ICRA55743.2025.11128717", "DOI") / #link("https://arxiv.org/abs/2410.08464", "arXiv")]

脱离机器人硬件采集人类示教虽然便携，但缺少在机器人上的反馈，数据质量容易受操作者经验影响，且常被特定本体限制。ARCap 使用增强现实视觉反馈和触觉警告，引导用户生成符合机器人运动学并避开场景碰撞的示教。用户研究显示，非专家也能采集可执行数据，训练策略可处理杂乱环境和长时序跨本体操作。系统依赖准确的标定、碰撞模型和目标本体映射，反馈误差会直接传入示教。

=== DART: Dexterous Augmented Reality Teleoperation Platform for Large-Scale Robot Data Collection in Simulation [#link("https://doi.org/10.1109/ICRA55743.2025.11128299", "DOI")]

真实机器人数据采集受硬件成本、环境重置和操作者疲劳限制。DART 结合云端仿真与增强现实，构建可众包的灵巧操作遥操作平台，并把数据自动写入云端 DexHub。用户研究显示，相较真实遥操作，它提高采集吞吐并降低身体疲劳；用 DART 数据训练的策略可迁移到真实环境，并能应对未见视觉扰动。Sim-to-Real 效果依赖仿真器的动力学和视觉保真度，平台不能消除真实接触差异。

=== How to Train Your Robots? The Impact of Demonstration Modality on Imitation Learning [#link("https://doi.org/10.1109/ICRA55743.2025.11128520", "DOI") / #link("https://arxiv.org/abs/2503.07017", "arXiv")]

示教模态会同时影响用户体验、轨迹质量和最终 Policy。作者比较动觉示教、VR 控制器遥操作和 spacemouse 遥操作在三项不同运动约束桌面任务上的表现。实验显示，动觉示教最直观且数据最干净、下游学习最好，但身体负担使其不适合单独用于大规模采集。作者因此建议用少量动觉示教与遥操作数据混合，在数据质量和采集成本之间取得平衡；该结论受任务类型和操作者熟练度影响。

=== Feasibility-Aware Imitation Learning from Observations Through a Hand-Mounted Demonstration Interface [#link("https://doi.org/10.1109/ICRA55743.2025.11127364", "DOI") / #link("https://arxiv.org/abs/2503.09018", "arXiv")]

人类动作不一定符合机器人的运动和动力学约束，直接从观察学习可能采集到不可执行示教。FABCO 用预训练正向和逆动力学模型评估每段示教的可行性，并把结果作为视觉反馈，帮助示教者修正动作；训练时再用可行性分数加权数据。四名参与者在移液管插入任务中的实验，以及 NASA-TLX 工作负荷评估，验证了反馈和加权学习的作用。方法依赖动力学模型的准确性，且实验任务规模较小，复杂接触场景仍需验证。

== IROS 2025

=== dARt Vinci: Egocentric Data Collection for Surgical Robot Learning at Scale [#link("https://doi.org/10.1109/IROS60139.2025.11247229", "DOI") / #link("https://arxiv.org/abs/2503.05646", "arXiv")]

手术机器人示教受安全、硬件和场地限制。dARt Vinci 以增强现实手部跟踪和高保真物理引擎采集第一视角手术动作，无需部署实体机器人。用户研究中，数据吞吐平均提高 41%，总实验时间平均降低 10%；数据体积缩小超过 400 倍，同时采样频率翻倍。收益依赖手部跟踪与手术仿真的精度，原始任务仍是基础手术操作。

=== NuExo: A Wearable Exoskeleton Covering all Upper Limb ROM for Outdoor Data Collection and Teleoperation of Humanoid Robots [#link("https://doi.org/10.1109/IROS60139.2025.11247718", "DOI") / #link("https://arxiv.org/abs/2503.10554", "arXiv")]

现有动作采集设备难以同时兼顾全上肢范围、舒适性、多模态传感和户外使用。NuExo 设计了 5.2 kg 背包式外骨骼，覆盖自然上肢全部活动范围，并通过统一遥操作框架采集运动与力等数据，适配多种人形机器人。跨平台和多用户实验验证了运动范围、动态采集稳定性与遥操作精度；实际规模仍受穿戴舒适度、机械标定和操作者差异影响。

=== Bunny-VisionPro: Real-Time Bimanual Dexterous Teleoperation for Imitation Learning [#link("https://doi.org/10.1109/IROS60139.2025.11247017", "DOI") / #link("https://arxiv.org/abs/2407.03162", "arXiv")]

双臂灵巧手需要同时处理高维协调、安全约束与操作者反馈。Bunny-VisionPro 使用 VR 头显和低成本触觉设备实现实时双臂遥操作，并加入碰撞与奇异位形规避。标准任务中，该系统取得更高成功率和更短完成时间，采集的示教也提高了模仿 Policy 的泛化，并支持多阶段长时域任务。效果依赖手部重定向、触觉反馈和安全约束的实时一致性。

=== VRobotix: A Scalable and Cost-Effective Virtual-Reality-Based Robotic Manipulation Dataset Generation Framework [#link("https://doi.org/10.1109/IROS60139.2025.11247610", "DOI")]

VRobotix 用消费级 VR 头显在物理仿真中进行人在回路控制，避免实体机器人和专用实验室，并兼容 URDF 机器人、手柄与身体姿态输入。可回放轨迹能够重新生成同步运动状态、RGB-D 和多种数据格式。推、抓、堆叠三项任务的数据采集成功率平均为 92%，仅用 50 次试验训练的 Policy 达到 100% 成功率；结论仍受任务简单度和仿真物理保真度限制。

=== HACTS: a Human-As-Copilot Teleoperation System for Robot Learning [#link("https://doi.org/10.1109/IROS60139.2025.11247309", "DOI") / #link("https://arxiv.org/abs/2503.24070", "arXiv")]

HACTS 在机器人关节与低成本遥操作硬件之间建立双向实时同步，使人类像自动驾驶副驾驶一样随时接管并留下动作纠正数据。实验表明，该反馈接口提高模仿学习的恢复能力和数据效率，也支持人在回路强化学习。它把完整示教转为稀疏干预，但数据价值依赖介入时机、硬件同步精度以及纠正动作是否覆盖 Policy 的失效分布。

=== Exo-ViHa: A Cross-Platform Exoskeleton System with Visual and Haptic Feedback for Efficient Dexterous Skill Learning [#link("https://doi.org/10.1109/IROS60139.2025.11246287", "DOI") / #link("https://arxiv.org/abs/2503.01543", "arXiv")]

Exo-ViHa 以模块化 3D 打印外骨骼、SLAM 相机、动作捕捉手套和腕部相机同步采集末端位姿、手部运动与第一视角视觉，并让用户直接感受接触反馈。不同机械臂和灵巧手可接入同一系统，实验显示采集成功率与效率均得到改善。跨平台能力仍依赖末端模块、相机和手套的联合标定，直接交互也不能消除人机运动学差异。

= 2. 人类视频与跨本体监督

人类视频数量丰富，却缺少机器人动作标签。这里的关键不是直接复制人体关节，而是寻找可跨本体复用的中间监督，例如物体运动、图像轨迹、交互程序和物体中心奖励。

== ICRA 2025

=== EgoMimic: Scaling Imitation Learning via Egocentric Video [#link("https://doi.org/10.1109/ICRA55743.2025.11127989", "DOI") / #link("https://arxiv.org/abs/2410.24221", "arXiv")]

EgoMimic 将 Project Aria 眼镜采集的第一视角人手视频与三维手部跟踪结合，并使用低成本双臂机器人、跨域对齐和人机数据协同训练来缩小运动学差异。它把人类和机器人数据都视为具身示教，而不只是从视频提取高层意图。作者报告，在长时序、单臂和双臂任务上优于既有模仿学习方法，并能泛化到新场景；增加 1 小时手部数据的收益显著高于增加 1 小时机器人数据。迁移效果依赖手部跟踪质量、机器人形态设计和跨域对齐覆盖范围。

=== ZeroMimic: Distilling Robotic Manipulation Skills from Web Videos [#link("https://doi.org/10.1109/ICRA55743.2025.11128283", "DOI") / #link("https://arxiv.org/abs/2503.23877", "arXiv")]

机器人专属示教通常要求相同本体、房间和物体，而 Web 人类视频提供了规模更大的自然操作数据。ZeroMimic 从 Ego-centric EpicKitchens 视频中结合语义与几何理解、抓取可供性检测和模仿 Policy，直接蒸馏图像目标条件技能，覆盖开关、倒液体、抓取放置、切割和搅拌等类别。作者在两种机器人本体和多种厨房仿真、真实设置中报告了无需额外机器人示教或探索的即插即用执行能力，并发布 Policy 检查点。视频中的遮挡、视角和动作几何仍限制了跨任务、跨本体复用。

=== Hand-Object Interaction Pretraining from Videos [#link("https://doi.org/10.1109/ICRA55743.2025.11127811", "DOI") / #link("https://arxiv.org/abs/2409.08273", "arXiv")]

该方法从自然视频恢复人手与被操作物体的三维交互轨迹，再将人手运动重定向为机器人动作，构造传感运动训练数据。基于这些数据的生成模型学习任务无关的通用操作先验，可作为下游策略的初始化。作者报告，结合强化学习或行为克隆微调能以较少样本适应新任务，并提高鲁棒性和泛化性。性能取决于视频三维重建、手--物对应关系和重定向质量，复杂接触与不可见力信息难以从视频恢复。

=== Chain-of-Modality: Learning Manipulation Programs from Multimodal Human Videos with Vision-Language-Models [#link("https://doi.org/10.1109/ICRA55743.2025.11128270", "DOI") / #link("https://arxiv.org/abs/2504.13351", "arXiv")]

仅靠视觉视频难以推断操作中随阶段变化的力等控制参数。Chain-of-Modality（CoM）让视觉语言模型逐步融合视频、肌电臂带和声音信号，迭代细化任务计划并生成控制参数。单个多模态人类视频即可驱动机器人执行任务；实验显示，计划与控制参数提取准确率相较基线提升 3 倍，并能泛化到新物体和任务设置。方法需要同步的额外传感器信号，跨个体、跨设备校准是主要依赖。

=== Motion Tracks: A Unified Representation for Human-Robot Transfer in Few-Shot Imitation Learning [#link("https://doi.org/10.1109/ICRA55743.2025.11128834", "DOI") / #link("https://arxiv.org/abs/2501.06994", "arXiv")]

人类视频缺少机器人动作标签，难以直接训练模仿 Policy。Motion Track Policy（MT-π）把动作表示为图像上的短时二维运动轨迹，同时描述人手和机器人末端的运动方向，从而建立跨本体动作空间。测试时由双视角轨迹通过多视图合成恢复 6DoF 轨迹；作者报告，仅用数分钟人类视频和少量机器人示教，在 4 个真实任务上平均成功率达到 86.5%，比不使用人类数据或该动作空间的基线高 40%，并能泛化到仅在人类视频中出现的场景。该表示主要覆盖短时几何运动，长时接触和隐含力控制仍需额外建模。

=== Bridging the Human to Robot Dexterity Gap Through Object-Oriented Rewards [#link("https://doi.org/10.1109/ICRA55743.2025.11128690", "DOI") / #link("https://arxiv.org/abs/2410.23289", "arXiv")]

人手视频中的动作不能直接迁移到形态不同的多指机器人。HUDOR 从单段人类视频构造物体中心奖励，利用现成点跟踪器关注物体运动，即使机器人手出现在画面中也能提供学习信号，再通过在线交互微调 Policy。四指 Allegro 手在四项任务中用约 1 小时在线交互即可学习示教技能，作者报告平均性能约为替代方法的 4 倍。方法依赖点跟踪稳定且物体运动足以反映任务进展，细粒度指尖接触意图可能无法由物体奖励表达。

== IROS 2025

=== RoboSwap: A GAN-driven Video Diffusion Framework For Unsupervised Robot Arm Swapping [#link("https://doi.org/10.1109/IROS60139.2025.11246732", "DOI") / #link("https://arxiv.org/abs/2506.08632", "arXiv")]

跨平台机器人视频通常缺少同场景配对数据。RoboSwap 先分割机械臂，以无配对 GAN 将源本体替换为目标本体，再用 Diffusion Model 修复融合区域和交互一致性，从异构环境视频生成跨本体训练数据。三个基准上，其结构连贯性和运动一致性优于通用图像与视频编辑方法。生成视频的控制价值仍取决于臂分割、遮挡恢复和接触几何是否真实。

=== Let Me Show You: Learning by Retrieving from Egocentric Video for Robotic Manipulation [#link("https://doi.org/10.1109/IROS60139.2025.11247760", "DOI") / #link("https://arxiv.org/abs/2511.05199", "arXiv")]

RfV 不把所有人类视频直接并入训练集，而是建立日常任务视频库，按任务描述检索相关示例，并提取物体可供性掩码和手部运动轨迹作为中层监督，再交给 Policy 生成器。仿真与真实实验显示，检索知识可提高未见场景和训练外任务的表现。方法依赖视频库覆盖、检索准确性以及人手轨迹到机器人动作之间的可迁移程度。

=== RwoR: Generating Robot Demonstrations from Human Hand Collection for Policy Learning without Robot [#link("https://doi.org/10.1109/IROS60139.2025.11246192", "DOI") / #link("https://arxiv.org/abs/2507.03930", "arXiv")]

RwoR 用腕部鱼眼相机采集人手示教，再以一套人手与 UMI 夹爪配对数据训练生成模型，把人手外观转换为机器人夹爪观测，同时自动恢复 SE(3) 动作，从而无需实体机器人即可生成 Policy 数据。实验展示了生成示教训练出的稳健操作能力。可扩展性仍受初始配对数据、时间同步、视觉对齐和手--夹爪动作映射质量约束。

=== Geometric Retargeting: A Principled, Ultrafast Neural Hand Retargeting Algorithm [#link("https://doi.org/10.1109/IROS60139.2025.11247700", "DOI") / #link("https://arxiv.org/abs/2503.07541", "arXiv")]

GeoRT 以几何目标函数学习人手关键点到机器人手关键点的无监督映射，无需人工标注手部配对，也不依赖测试时迭代优化。目标同时约束运动保真度、配置空间覆盖、响应均匀性、捏合对应和自碰撞，推理频率达到 1 kHz，便于后续接入动作纠正控制器。性能仍依赖输入关键点质量和目标机器人手的运动学可表达范围。

=== Robust and Expressive Humanoid Motion Retargeting via Optimization-Based Rig Unification [#link("https://doi.org/10.1109/IROS60139.2025.11246607", "DOI")]

该方法先把不同骨架和含噪姿态估计统一到规范 Rig，再修复不可行姿势、施加足部接触约束，并针对目标机器人物理限制优化运动，使异构人体动作数据可被多种人形机器人复用。实验覆盖 12 个仿真人形机器人和 3 个真实平台，能够稳定生成富有表现力的上肢动作。重定向结果仍受源动作质量、接触假设和目标机器人的动力学能力限制。

= 3. 示教生成与增强

这组方法从少量种子示教出发，通过因果变换、仿真生成、质量筛选或课程学习扩大训练分布。判断合成数据是否有效的核心，是动作与观测能否保持几何和物理一致。

== ICRA 2025

=== SuFIA-BC: Generating High Quality Demonstration Data for Visuomotor Policy Learning in Surgical Subtasks [#link("https://doi.org/10.1109/ICRA55743.2025.11127797", "DOI") / #link("https://arxiv.org/abs/2504.14857", "arXiv")]

手术机器人学习受患者数据稀缺、环境接触复杂和标定误差影响。SuFIA-BC 构建包含逼真人体器官的手术数字孪生，并用多视角相机或单目内窥镜提取的三维表示生成和评测视觉行为克隆数据。系统性实验显示，现有行为克隆方法无论采用何种感知或控制架构，都难以解决所评估的接触丰富任务。结果说明手术场景需要定制感知与控制管线，以及更大规模、任务专用的合成数据；仿真到真实的器官和接触差异仍是边界。

=== DexMimicGen: Automated Data Generation for Bimanual Dexterous Manipulation via Imitation Learning [#link("https://doi.org/10.1109/ICRA55743.2025.11127809", "DOI") / #link("https://arxiv.org/abs/2410.24185", "arXiv")]

双臂多指机器人示教需要同时控制多个高维自由度，数据采集成本尤其高。DexMimicGen 从少量人类示教在仿真中自动合成双臂灵巧轨迹，并提供覆盖不同协调需求的环境集合。作者用 60 条源示教生成 21K 条示教，研究数据生成和 Policy 学习选择对性能的影响，并将 Real-to-Sim-to-Real 流程部署到真实人形机器人分拣任务。合成质量受源示教覆盖、任务分解和仿真接触保真度限制。

=== RoCoDA: Counterfactual Data Augmentation for Data-Efficient Robot Learning from Demonstrations [#link("https://doi.org/10.1109/ICRA55743.2025.11128694", "DOI") / #link("https://arxiv.org/abs/2411.16959", "arXiv")]

RoCoDA 将因果不变性、SE(3) 等变性和反事实思路统一到模仿学习数据增强中。它修改与任务无关的环境状态而保持 Policy 输出不变，同时对物体位姿施加刚体变换并同步调整动作，生成合成示教。五项操作任务实验显示，方法提高性能、样本效率以及对未见位姿、纹理和干扰物的泛化，甚至出现重抓取等行为。增强的正确性依赖任务无关状态假设和几何变换的有效性，非刚体接触任务可能不满足这些条件。

=== DABI: Evaluation of Data Augmentation Methods Using Downsampling in Bilateral Control-Based Imitation Learning with Images [#link("https://doi.org/10.1109/ICRA55743.2025.11128686", "DOI") / #link("https://arxiv.org/abs/2410.04370", "arXiv")]

多传感器采样频率不同，传统预处理通常需下采样到最低频率，可能浪费高频关节信息。DABI 在双边控制模仿学习中以 1000 Hz 采集关节角、速度和力矩，并以 100 Hz 夹爪及环境相机图像作为增强基础，使数据量扩大 10 倍。仅使用 5 组专家示教训练 Bi-ACT 的对比实验和真实测试显示，增强显著提高成功率。收益依赖双边控制接口和传感器同步，过度下采样仍可能损失快速接触信息。

=== Learning From Imperfect Demonstrations With Self-Supervision for Robotic Manipulation [#link("https://doi.org/10.1109/ICRA55743.2025.11127918", "DOI") / #link("https://arxiv.org/abs/2401.08957", "arXiv")]

真实采集昂贵，失败示教中往往仍包含可用的局部动作，但常规模仿学习会丢弃这些数据。SSDF 将专家轨迹与不完美轨迹结合，为失败轨迹片段计算自监督质量分数，仅筛选高质量片段扩充离线训练集，不需要奖励或在线探索。ManiSkill2/Sapien 仿真和 Franka 真实操作实验显示，SSDF 能稳定扩充有效数据并提高所有任务的成功率。质量估计依赖轨迹片段内部的可识别进展，任务中间状态不可观或错误具有全局影响时可能失效。

=== DemoStart: Demonstration-Led Auto-Curriculum Applied to Sim-to-Real with Multi-Fingered Robots [#link("https://doi.org/10.1109/ICRA55743.2025.11127813", "DOI") / #link("https://arxiv.org/abs/2409.06613", "arXiv")]

DemoStart 用少量仿真示教和稀疏奖励驱动三指机器人手的自动课程强化学习，减少复杂操作行为的训练和数据需求。策略直接从多相机像素与机器人本体感觉学习，并用域随机化实现零样本 Sim-to-Real。作者报告，真实机器人性能超过仅依赖示教学习的策略，同时仿真所需示教数量减少 100 倍。方法仍依赖可迁移的仿真任务、合适的稀疏奖励和域随机化覆盖，复杂真实接触可能超出仿真分布。

=== Qdgset: a Large Scale Grasping Dataset Generated With Quality-Diversity [#link("https://doi.org/10.1109/ICRA55743.2025.11127427", "DOI") / #link("https://arxiv.org/abs/2410.02319", "arXiv")]

现有合成抓取数据常依赖简单采样和先验，覆盖有限。QDGset 扩展 QDG-6DoF 的质量多样性搜索，通过变换物体网格并迁移已有抓取 repertoire 来扩大数据生成。作者报告，每个稳健抓取所需的评估次数最多降低 20%，生成的数据集包含约 3.5 倍抓取姿态和 4.5 倍物体数量。数据质量取决于网格变换和质量评估器，合成抓取与真实摩擦、柔顺性之间仍存在差异。

=== BODex: Scalable and Efficient Robotic Dexterous Grasp Synthesis Using Bilevel Optimization [#link("https://doi.org/10.1109/ICRA55743.2025.11127930", "DOI") / #link("https://arxiv.org/abs/2412.16490", "arXiv")]

BODex 将灵巧抓取合成为双层优化问题：下层用二次规划求解接触约束，上层用梯度下降优化抓取，并借助 CUDA 机器人库和 GPU QP 求解器并行生成数据。单张 RTX 3090 可达到每秒超过 49 个抓取；Shadow、Allegro 和 Leap 手的仿真成功率均超过 75%，穿透深度低于 1 mm。相较 DexGraspNet，训练模型的仿真成功率从约 40% 提升到 80%，Shadow 手在 20 个物体上的真实成功率为 81%。结果依赖碰撞、接触和摩擦模型，仿真抓取质量不等同于真实部署稳定性。

== IROS 2025

=== DG16M: A Large-Scale Dataset for Dual-Arm Grasping with Force-Optimized Grasps [#link("https://doi.org/10.1109/IROS60139.2025.11246970", "DOI") / #link("https://arxiv.org/abs/2503.08358", "arXiv")]

DG16M 面向稀缺的双臂抓取监督，生成 1,600 万组经改进力闭合约束评估的双臂抓取，并提供包含 300 个物体、约 3 万组物理仿真抓取的基准。用该数据训练的双臂抓取分类器相较现有方法提升 15%，并改善跨物体泛化。数据质量仍取决于力闭合、摩擦和碰撞模型，仿真可行抓取不等同于真实双臂执行稳定性。

=== RoboEngine: Plug-and-Play Robot Data Augmentation with Semantic Robot Segmentation and Background Generation [#link("https://doi.org/10.1109/IROS60139.2025.11247097", "DOI") / #link("https://arxiv.org/abs/2503.18738", "arXiv")]

RoboEngine 提供无需相机标定或绿幕的即插即用视觉增强工具：以机器人场景分割数据集训练通用分割器，再用定制背景生成模型合成满足任务语义的场景。仅从单一场景采集示教后，增强数据支持六个全新场景中的操作泛化，性能相较无增强基线提高超过 200%。方法主要扩展视觉分布，仍需保证生成背景不破坏遮挡、接触和任务因果关系。

=== Learning Generalizable 3D Manipulation With 10 Demonstrations [#link("https://doi.org/10.1109/IROS60139.2025.11247500", "DOI")]

该框架从 10 条示教学习三维操作 Policy，以语义先验提取任务相关 RGB-D 表示，并在 Diffusion Policy 中保持空间等变性。其三维轨迹增强同步变换夹爪与物体，维持二者空间关系，从少量数据覆盖未见位姿。仿真和真实实验均显示其在大幅物体位姿变化下优于对比方法；效果依赖语义感知质量和刚体空间变换对任务的适用性。

=== DiffGen: Robot Demonstration Generation via Differentiable Physics Simulation, Differentiable Rendering, and Vision-Language Model [#link("https://doi.org/10.1109/IROS60139.2025.11247245", "DOI") / #link("https://arxiv.org/abs/2405.07309", "arXiv")]

DiffGen 将可微物理、可微渲染与 VLM 串联，根据自然语言指令优化动作，使操作后的渲染观测在表示空间中接近文本目标，从而绕过强化学习训练和人工奖励设计。实验表明，它能以较少人工参与和训练时间生成机器人示教。生成质量依赖 VLM 表示是否表达任务完成、模拟器梯度是否稳定，以及语言相似度能否约束真实接触可行性。

=== ReBot: Scaling Robot Learning with Real-to-Sim-to-Real Robotic Video Synthesis [#link("https://doi.org/10.1109/IROS60139.2025.11246305", "DOI") / #link("https://arxiv.org/abs/2503.14526", "arXiv")]

ReBot 在仿真中回放真实机器人轨迹并替换被操作物体，再把模拟运动与补全后的真实背景融合，自动生成物理一致、时序连续的视频以扩展 VLA 数据。SimplerEnv 中，Octo 和 OpenVLA 的域内性能分别提高 7.2% 与 21.8%，域外泛化提高 19.9% 与 9.4%；Franka 真实测试成功率分别提高 17% 与 20%。收益依赖轨迹回放、物体动力学和视频合成的一致性。

=== Data-Bootstrapped, Physics-Informed Framework for Object Rearrangement [#link("https://doi.org/10.1109/IROS60139.2025.11247659", "DOI")]

DPR 用随机轨迹反转生成初始高质量数据，再由 Transformer 自举合成更多重排轨迹，并把物理奖励反馈注入序列决策，抑制不可执行预测。球体和房间重排任务中，该框架在效率和效果上优于现有方法。自举过程会继承初始数据与模型偏差，物理反馈的有效性也取决于状态表示和可计算的可行性指标。

= 4. 仿真与 Real-to-Sim

Real-to-Sim 方法先重建真实场景，再在可控环境中生成交互数据、奖励或探索先验。两届工作都使用 Gaussian Splatting 缩小视觉差异，IROS 进一步强调动力学参数识别、持续适应和模拟--真实共训练。

== ICRA 2025

=== SplatSim: Zero-Shot Sim2Real Transfer of RGB Manipulation Policies Using Gaussian Splatting [#link("https://doi.org/10.1109/ICRA55743.2025.11128339", "DOI") / #link("https://arxiv.org/abs/2409.10161", "arXiv")]

依赖 RGB 图像的操作 Policy 在 Sim-to-Real 中面临显著的合成--真实视觉域差异。SplatSim 用 Gaussian Splatting 替代传统网格作为模拟器的主要渲染基元，在保持模拟可扩展性和低成本的同时生成更逼真的合成数据。作者在 SplatSim 中训练操作 Policy 并零样本部署到真实机器人，平均成功率达到 86.25%，而真实数据训练的 Policy 为 97.5%。该结果依赖场景重建质量，且当前差距仍表明 Gaussian Splatting 不能完全替代真实示教。

=== RL-GSBridge: 3D Gaussian Splatting Based Real2Sim2Real Method for Robotic Manipulation Learning [#link("https://doi.org/10.1109/ICRA55743.2025.11128103", "DOI")]

面向特定操作任务的 Sim-to-Real 方法往往需要大量增强数据或大型模型，成本较高。RL-GSBridge 将 3D Gaussian Splatting 接入常规强化学习模拟流程，先用带软绑定约束的网格式 3DGS 提升渲染质量，再通过 GS 编辑同步视觉和物理状态，形成 Real-to-Sim-to-Real 闭环。抓取与 pick-and-place 实验显示，策略迁移到真实世界后仍保持较好的成功率，渲染指标也表明非结构化物体的伪影减少。方法对真实场景重建和视觉--物理同步的准确性较敏感。

=== A Real-to-Sim-to-Real Approach to Robotic Manipulation with VLM-Generated Iterative Keypoint Rewards [#link("https://doi.org/10.1109/ICRA55743.2025.11127585", "DOI") / #link("https://arxiv.org/abs/2502.08643", "arXiv")]

开放环境中的操作任务需要能随人类意图和反馈变化的任务规格，固定奖励难以覆盖多步行为。IKER 让 VLM 根据 RGB-D 观测和自由语言指令采样场景关键点，并生成基于关键点空间关系的 Python 奖励函数，以支持精确 SE(3) 控制和迭代修正。作者将真实场景重建到模拟器中，用生成奖励训练 RL Policy，再部署回真实环境；实验覆盖抓取和非抓取操作，并观察到多步执行、错误恢复和在线策略调整。其效果取决于关键点定位、VLM 常识先验和 Real-to-Sim 重建质量。

== IROS 2025

=== LoopSR: Looping Sim-and-Real for Lifelong Policy Adaptation of Legged Robots [#link("https://doi.org/10.1109/IROS60139.2025.11246873", "DOI") / #link("https://arxiv.org/abs/2409.17992", "arXiv")]

LoopSR 针对域随机化难以兼顾通用鲁棒性和特定环境性能的问题，将部署后的真实轨迹编码到潜空间，预测并检索相应仿真参数，重建动力学数字孪生后继续训练足式 Policy。Sim-to-Sim 与 Sim-to-Real 实验显示，它用有限真实数据获得了更高的数据效率。持续适应依赖真实轨迹对动力学的可辨识性，参数化模拟器也必须覆盖实际环境变化。

=== DISCOVERSE: Efficient Robot Simulation in Complex High-Fidelity Environments [#link("https://doi.org/10.1109/IROS60139.2025.11247559", "DOI") / #link("https://arxiv.org/abs/2507.21981", "arXiv")]

DISCOVERSE 将 Gaussian Splatting 的真实场景外观与 MuJoCo 物理结合，形成模块化开源 Real2Sim2Real 平台，支持多传感器并行模拟、现有三维资产、机器人模型和 ROS 插件。模仿学习实验中，其零样本 Sim-to-Real 表现优于对比模拟器。平台扩展了高保真合成数据吞吐，但视觉 Gaussian 与物理几何的同步、接触建模和真实重建质量仍决定迁移上限。

=== SimLauncher: Launching Sample-Efficient Real-World Robotic Reinforcement Learning via Simulation Pre-Training [#link("https://doi.org/10.1109/IROS60139.2025.11246668", "DOI") / #link("https://arxiv.org/abs/2507.04452", "arXiv")]

SimLauncher 先在 Real-to-Sim 数字孪生中预训练视觉运动 Policy，再用大量模拟示教和预训练 Policy 的真实 Rollout 初始化目标值，并把其动作建议用于真实强化学习探索。多阶段、接触丰富和灵巧手任务中，该方法显著提高样本效率并达到接近满成功率。它仍需要足够准确的数字孪生和可安全部署的初始 Policy，模拟偏差可能同时影响价值估计与探索方向。

=== Can Real-to-Sim Approaches Capture Dynamic Fabric Behavior for Robotic Fabric Manipulation? [#link("https://doi.org/10.1109/IROS60139.2025.11245811", "DOI") / #link("https://arxiv.org/abs/2503.16310", "arXiv")]

该研究在五类织物、两种模拟器和提升、吹风、拉伸三种识别场景上比较两种可微管线、数据驱动方法与新的物理先验神经网络，再在折叠、甩动和抖动等未见场景评估。结果表明，模拟器和参数估计方法都会显著影响迁移；PINN 在准静态任务更好，但动态场景受限。Real-to-Sim 参数并非跨动作通用，数据扩展前必须验证动力学可迁移性。

=== Automatic Real-to-Sim-to-Real System through Iterative Interactions for Robust Robot Manipulation Policy Learning with Unseen Objects [#link("https://doi.org/10.1109/IROS60139.2025.11247488", "DOI")]

ARIC 让机器人用预训练强化学习 Policy 反复改变物体姿态并自主观察，逐步改善三维重建，无需人工持相机扫描或手动摆动物体；随后在复制物体的仿真中训练任务 Policy，并零微调部署到真实环境。三个真实任务平均成功率为 83.3%。闭环采集减少人工成本，但依赖初始交互 Policy、可抓取物体和迭代重建的稳定性。

= 5. 触觉与多模态数据

接触数据不仅难采集，也容易被具体传感器绑定。这些论文分别从低成本硬件、力--运动同步、规范化表示、无配对预训练和多模态数据集切入，试图提高每次真实接触的监督价值。

== ICRA 2025

=== ForceMimic: Force-Centric Imitation Learning with Force-Motion Capture System for Contact-Rich Manipulation [#link("https://doi.org/10.1109/ICRA55743.2025.11128061", "DOI") / #link("https://arxiv.org/abs/2410.07554", "arXiv")]

接触丰富操作中，人类会用随时间变化的力补偿视觉引导轨迹误差，而许多机器人学习方法只学习位置轨迹。ForceMimic 提供 ForceCapture 无机器人示教系统，同步记录运动与力，并用 HybridIL 学习力--运动联合 Policy；执行时通过混合力/位置控制原语拟合预测的力旋量和位姿参数。剥西葫芦实验中，操作员用 ForceCapture 约 5 分钟完成采集，而力反馈遥操作超过 13 分钟且难以完成任务；相较纯视觉模仿学习，成功率相对提高 54.5%。方法依赖力传感器标定以及训练任务中的接触模式覆盖。

=== PolyTouch: A Robust Multi-Modal Tactile Sensor for Contact-Rich Manipulation Using Tactile-Diffusion Policies [#link("https://doi.org/10.1109/ICRA55743.2025.11128816", "DOI") / #link("https://arxiv.org/abs/2504.19341", "arXiv")]

家庭环境中的接触操作常受遮挡、视觉复杂性和精确接触控制影响，仅依赖视觉或本体感觉的 Policy 往往不够稳健。PolyTouch 将相机式触觉、声学感知和周边视觉集成到紧凑耐用的机器人手指中，提供跨时间尺度的多模态接触反馈。作者报告其寿命至少是商用触觉传感器的 20 倍，并将触觉与视觉--本体感觉示教用于训练 Tactile-Diffusion Policy；多个接触操作任务均优于无触觉 Policy。硬件制造和传感器融合仍需在更多手型、材料和长期磨损条件下验证。

=== Tactile Functasets: Neural Implicit Representations of Tactile Datasets [#link("https://doi.org/10.1109/ICRA55743.2025.11127929", "DOI") / #link("https://arxiv.org/abs/2409.14592", "arXiv")]

高维触觉传感器通常输出图像，原始数据存储成本高，也难以跨传感器泛化。本文用神经隐式函数重建触觉数据集，以紧凑潜在表示替代直接处理触觉图像，并保留可进行概率解释的推断形式。作者在手内物体姿态估计上取得优于图像方法的性能，同时简化下游模型。表示的质量依赖训练数据对传感器结构和接触分布的覆盖，极端接触状态可能被压缩丢失。

=== Canonical Representation and Force-Based Pretraining of 3D Tactile for Dexterous Visuo-Tactile Policy Learning [#link("https://doi.org/10.1109/ICRA55743.2025.11128094", "DOI") / #link("https://arxiv.org/abs/2409.17549", "arXiv")]

灵巧手上的 3D 触觉覆盖范围大、维度高，但缺少大规模标准数据集和成熟的预训练骨干，导致特征学习困难。作者提出规范化表示降低 3D 触觉学习难度，并设计基于力的自监督预训练任务，同时捕获局部接触力和整体合力特征。真实实验中，四项精细接触操作任务的平均成功率达到 78%，并优于对比方法。性能依赖触觉几何规范化与力信号质量，跨硬件迁移仍需额外校准。

=== UpViTaL: Unpaired Visual-Tactile Self-Supervised Representation Learning for Dexterous Robotic Manipulation [#link("https://doi.org/10.1109/ICRA55743.2025.11127230", "DOI")]

现有视觉--触觉预训练通常要求同步采集的配对数据，并在真实部署时依赖灵巧手触觉传感器，成本较高。UpViTaL 分别利用相机和触觉手套采集低成本、无配对数据，在三个操作任务上学习视觉与时间序列触觉表示，再通过 RL 奖励融合两种表示。部署时不需要在机器人灵巧手上安装触觉传感器；相较视觉预训练基线，成功率提高超过 30%。这种跨模态融合依赖奖励设计和无配对数据之间的任务相关性。

=== Flat'n'Fold: A Diverse Multi-Modal Dataset for Garment Perception and Manipulation [#link("https://doi.org/10.1109/ICRA55743.2025.11127794", "DOI") / #link("https://arxiv.org/abs/2409.18297", "arXiv")]

衣物从皱缩到折叠的全过程包含显著形变，现有数据集在规模、衣物种类和动作多样性上不足。Flat'n'Fold 收录 1,212 条人类示教和 887 条机器人示教，覆盖 8 类、44 件衣物的铺平与折叠，并同步提供多视角 RGB-D、点云及手/夹爪位姿动作。作者量化了数据集的多样性和复杂度，并建立抓取点预测与子任务分解基准；现有模型在两项任务上仍有明显提升空间。数据主要来自铺平和折叠流程，对更长时序衣物整理的覆盖有限。

== IROS 2025

=== VibeCheck: Using Active Acoustic Tactile Sensing for Contact-Rich Manipulation [#link("https://doi.org/10.1109/IROS60139.2025.11246133", "DOI") / #link("https://arxiv.org/abs/2504.15535", "arXiv")]

VibeCheck 在夹爪两指安装压电元件，一侧激励、另一侧接收穿过物体的声振信号，由此识别物体、抓取位置、内部结构姿态和外部接触类型。作者用传感器性能构造简化模拟转移模型，训练能容忍分类误差的模仿 Policy，并在 UR5 插销任务中仅凭主动声学反馈执行。方法扩展了非视觉接触监督，但依赖声学耦合、夹持条件和模拟误差模型。

=== TwinTac: A Wide-Range, Highly Sensitive Tactile Sensor with Real-To-Sim Digital Twin Sensor Model [#link("https://doi.org/10.1109/IROS60139.2025.11247002", "DOI") / #link("https://arxiv.org/abs/2509.10063", "arXiv")]

TwinTac 联合设计高灵敏、宽量程的实体触觉传感器及其数字孪生。系统采集有限元结果与真实传感输出的同步跨域数据，训练网络把模拟信号映射到真实响应。实验验证了孪生模型与硬件输出的一致性；物体分类中，孪生生成的模拟触觉能够增强真实数据并提高准确率。扩展效果依赖材料模型、同步标定和训练接触分布，跨物体与跨传感器泛化仍需验证。

=== TacCap: A Wearable FBG-Based Tactile Sensor for Efficient Human-to-Robot Skill Transfer [#link("https://doi.org/10.1109/IROS60139.2025.11246050", "DOI")]

人类示教数据通常只有视觉与运动，缺少可迁移触觉。TacCap 使用轻量、耐用且抗电磁干扰的光纤布拉格光栅可穿戴传感器，在人手操作时直接记录触觉。作者评估其灵敏度、重复性和跨传感器一致性，并通过抓取稳定性预测和消融验证触觉数据的迁移价值。方法补足了人类示教模态，但仍需要人手与机器人接触位置、尺度和材料响应之间的对齐。

=== AugInsert: Learning Robust Visual-Force Policies via Data Augmentation for Object Assembly Tasks [#link("https://doi.org/10.1109/IROS60139.2025.11247210", "DOI") / #link("https://arxiv.org/abs/2410.14968", "arXiv")]

AugInsert 用 Perceiver IO 融合视觉与力矩信息，并建立按因素控制的插销装配评测，研究多模态 Policy 在分布外条件下的鲁棒性。结果显示，抓取位姿变化最具挑战，分别对各模态做朴素增强不足以解决联合偏移；在该接触任务中，力矩最有信息量，视觉最弱。论文说明多模态数据扩展必须保持跨模态相关性，结论主要来自特定装配环境并辅以有限真实实验。

=== A Multi-modal Hand Imitation Dataset for Dexterous Hand [#link("https://doi.org/10.1109/IROS60139.2025.11246058", "DOI")]

Multi-Modal Dex 联合视觉、点云与运动学数据描述人手交互，并通过神经渲染和运动学优化，把人手与机器人手姿态对齐到共享规范空间，为灵巧模仿、感知和技能迁移提供多模态数据。它缓解了仅用 RGB 难以表达三维时空关系的问题。数据价值仍取决于规范空间的几何对齐、采集动作覆盖以及人手接触信息能否由现有模态充分恢复。

= 6. 数据配方与异构预训练

最后一组关注模型如何使用已经扩大的异构数据。重点从单纯增加样本转向训练配方：哪些架构能够随多模态示教扩展，以及如何用语言把视觉、触觉和声音映射到共享语义空间。

== ICRA 2025

=== The Ingredients for Robotic Diffusion Transformers [#link("https://doi.org/10.1109/ICRA55743.2025.11127493", "DOI") / #link("https://arxiv.org/abs/2410.10088", "arXiv")]

高容量 Transformer 与生成式 Diffusion Model 在机器人上分别取得进展，但二者组合时的架构、训练和超参数选择缺少清晰配方。本文系统研究 Diffusion Transformer Policy 的关键设计，并据此提出 DiT-Block Policy，使同一模型可在多个机器人本体和任务上工作，减少逐平台调参。作者在双臂 ALOHA 的长时域灵巧任务（超过 1500 个 time-step）上显著超过现有方法；在 10 小时、带语言标注且高度多模态的 ALOHA 示教上也表现出更好的规模扩展。结论依赖数据规模和语言标注质量，未覆盖所有机器人形态。

=== Beyond Sight: Finetuning Generalist Robot Policies with Heterogeneous Sensors via Language Grounding [#link("https://doi.org/10.1109/ICRA55743.2025.11127987", "DOI") / #link("https://arxiv.org/abs/2501.04693", "arXiv")]

通用机器人 Policy 通常只用视觉和本体感觉训练，无法在遮挡或视觉退化时利用触觉、声音等信息。FuSe 以自然语言作为跨模态落地媒介，结合多模态对比损失与感官条件语言生成损失，将异构传感器编码为共享的高层语义。作者在真实操作中展示了视觉、触觉和声音联合推理、组合式跨模态提示及交互物体描述，并适用于 Diffusion 通用 Policy 和 VLA 模型。实验显示成功率较所有基线提高超过 20%，但效果依赖语言生成目标对传感器细节的保真度。

== IROS 2025

=== Empirical Analysis of Sim-and-Real Cotraining of Diffusion Policies For Planar Pushing from Pixels [#link("https://doi.org/10.1109/IROS60139.2025.11246304", "DOI") / #link("https://arxiv.org/abs/2503.22634", "arXiv")]

该工作系统研究 Diffusion Policy 的模拟与真实示教共训练，覆盖 50 余个真实 Policy、1,000 余次真实试验，以及 250 个模拟 Policy、5 万余次模拟试验。结果表明，模拟数据在真实数据稀缺时收益最大，继续增加模拟数据最终会饱和，而更多真实数据能抬高上限；接触任务中物理域差异可能比视觉逼真度更关键，适度视觉差异甚至有助于模型区分数据域。结论目前基于平面推动任务。

=== Refined Policy Distillation: From VLA Generalists to RL Experts [#link("https://doi.org/10.1109/IROS60139.2025.11246761", "DOI") / #link("https://arxiv.org/abs/2503.05833", "arXiv")]

RPD 把通用 VLA 作为强化学习探索教师，以教师动作引导紧凑学生 Policy，同时结合在线 RL 与行为克隆，将通用能力转化为任务专家。ManiSkill3 多项操作实验中，学生在稠密和稀疏奖励下均超过 VLA 教师，比纯 RL 更快收敛，并能适应相机视角和部分任务变化。数据效率依赖教师 VLA 的初始动作质量、奖励可用性和模拟微调环境。

=== Policy Learning from Large Vision-Language Model Feedback Without Reward Modeling [#link("https://doi.org/10.1109/IROS60139.2025.11246902", "DOI") / #link("https://arxiv.org/abs/2507.23391", "arXiv")]

PLARE 面向没有奖励标注的离线轨迹，让 VLM 根据语言任务描述比较两段视觉轨迹并给出偏好标签，再以监督式对比偏好目标直接训练 Policy，不显式拟合奖励模型。MetaWorld 和真实操作实验中，其表现达到或超过现有 VLM 奖励生成方法。它降低人工奖励设计成本，但训练信号受 VLM 对任务进展、视角和失败模式的判断可靠性限制。

=== ManiGaussian++: General Robotic Bimanual Manipulation with Hierarchical Gaussian World Model [#link("https://doi.org/10.1109/IROS60139.2025.11246564", "DOI") / #link("https://arxiv.org/abs/2506.19842", "arXiv")]

ManiGaussian++ 用任务导向 Gaussian Splatting 表示中间视觉特征，并以主从层级世界模型分别预测稳定臂与操作臂引起的场景变化，从未来场景预测中学习双臂多体动力学。十项仿真任务相较现有方法提高 20.2%，九项真实双臂任务平均成功率为 60%。世界模型提高了数据中的动力学利用率，但依赖视觉预测质量，复杂接触和长时误差仍可能累积。

= 综合判断

两届会议共同显示，数据扩展已经从“收集更多同构遥操作”转向“把不同来源转换为任务相关监督”。ICRA 的代表工作更集中于人类视频、少量示教生成、触觉表示和数据管理；IROS 则明显增加了 VR 与外骨骼采集系统、机器人视频合成、自动 Real-to-Sim、触觉数字孪生以及模拟--真实共训练。

最有潜力的方法通常同时处理“规模”和“接口”。EgoMimic、Motion Tracks、RwoR 与 RoboSwap 寻找人类或异构机器人数据进入目标本体的中间表示；ForceMimic、PolyTouch、TacCap 与 TwinTac 为稀缺接触信号建立采集或模拟接口；ReBot、RoboEngine 和 DiffGen 则把视觉生成约束到已有轨迹、机器人分割或可微物理上。单纯生成逼真图像并不自动产生控制价值，合成数据仍需满足动作--观测一致性、接触物理和目标分布匹配。

对资源有限的研究者而言，一条实际路线是：先用少量高质量真实示教确定任务不变量，再按缺口扩展数据。视觉与空间变化可优先使用几何增强、机器人替换或三维重建；接触任务应保留力、触觉或声学监督；跨本体问题应避免直接绑定关节动作；需要在线学习时，可用模拟 Policy 提供初始 Rollout 或动作建议，但必须以真实数据抬高性能上限。最终应通过真实 Rollout 验证新增数据是否扩展了 Policy 支持集，而非只增加训练文件数量。

= 来源与范围

- #link("https://dblp.org/db/conf/icra/icra2025.xml", "DBLP: ICRA 2025 Proceedings XML")，用于确定 1,604 篇正式论文及 DOI。
- #link("https://dblp.org/db/conf/iros/iros2025.xml", "DBLP: IROS 2025 Proceedings XML")，用于确定 1,985 篇正式论文及 DOI。
- #link("https://www.semanticscholar.org/", "Semantic Scholar")，按 DOI 批量补全公开摘要、arXiv 与开放获取信息。
- #link("https://2025.ieee-icra.org/program/awards-and-finalists/", "ICRA 2025 Awards and Finalists")，用于核对获奖论文。
- 自动主题评分只用于召回，最终 ICRA 32 篇与 IROS 31 篇均由人工审计确定；本文不等价于两届会议的全领域最佳论文榜单。
