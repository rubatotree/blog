#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "RSS 2026 论文速览",
  date: datetime(year: 2026, month: 8, day: 4),
  weight: 0,
  tags: (
    category: ("具身智能", "RSS", "论文概要目录")
  ),
  draft: false,
  references: ```bib

  ```,
)

本文使用 AI 工具整理 #link("https://roboticsconference.org/program/papers/", "Robotics: Science and Systems 2026") 的全部接收论文。官网在 2026 年 8 月 4 日实际列出 210 篇论文，分布在 21 个 Session；本文数量以官网实时页面为准。

= Session 导读

RSS 2026 的 Session 划分比按单篇论文罗列更能反映研究热点：

- *Manipulation 1--3*：27 篇，覆盖双臂与灵巧操作、触觉闭环、接触丰富控制、数据合成和通用 Manipulation Policy。
- *Imitation Learning 1--3*：28 篇，是论文数量最多的方向，集中讨论示教扩展、跨本体迁移、Diffusion 或 Flow Policy 与数据选择。
- *Navigation 1--2*：18 篇，涵盖开放词汇导航、动态避障、长时序 VLA、地形可通行性与无人机导航。
- *Humanoids*：13 篇，从高动态全身控制、跑酷和滑板扩展到通用人形 Foundation Model 与长时序 Loco-Manipulation。
- *Multi-robot Systems*：13 篇，研究分布式优化、多智能体协作、时序逻辑、安全导航和多机器人规划。
- *Perception and Estimation*：13 篇，关注机器人场景中的三维感知、状态估计、多模态融合与可部署感知系统。
- *Planning*：13 篇，覆盖采样规划、最优控制、学习增强规划和带安全约束的决策。
- *Control & Dynamics*：13 篇，重点是接触、柔顺性、复杂动力学与学习控制的稳定性。
- *World Models & Memory*：9 篇，探索记忆检索、因果世界模型、仿真预训练和交互式世界模拟器。
- *Localization & Mapping*：9 篇，包含神经地图、Radar 或 LiDAR 里程计、SLAM 不确定性与前馈三维重建。
- *Datasets and Benchmarks*：9 篇，处理机器人数据集、评测协议和真实到仿真的基准构建。
- *HRI*：9 篇，聚焦人机协作、意图理解、交互安全与社会性机器人。
- *Modeling and Optimization*：9 篇，研究可微建模、系统辨识、几何优化与机器人设计中的数值方法。
- *RL*：9 篇，关注真实机器人强化学习、离线到在线适应、奖励学习和样本效率。
- *Robot & Sensor Design*：9 篇，覆盖新型机器人机构、软体系统、触觉与其他传感器设计。
- *VLA Models*：9 篇，集中讨论视觉--语言--动作模型的预训练、推理、泛化与高效部署。

从数量上看，Manipulation 与 Imitation Learning 合计 55 篇，占全部论文约四分之一；人形、多机器人、规划、感知与控制各有 13 篇，说明 RSS 仍然保持学习方法与传统机器人系统研究并重的结构。

= 摘要整理

== Manipulation 1

这一组论文集中体现了 RSS 2026 在操作学习上的两条路线：一条通过合成、跨本体数据和大规模协同训练扩大示教覆盖；另一条把接触、触觉和分布偏移显式建模，使少量数据也能在真实环境中稳定工作。

=== 1. One-Shot Real-World Demonstration Synthesis for Scalable Bimanual Manipulation [#link("https://roboticsconference.org/program/papers/1/", "RSS 页面")]

BiDemoSyn 试图解决双臂灵巧操作中“真实示教可靠但昂贵、仿真数据便宜但存在域差异”的矛盾。它从一个真实示例中分解出不随物体变化的协调模块和与物体相关的调整模块，再通过视觉对齐和轻量轨迹优化生成接触丰富、物理可行的双臂示教。作者报告，系统可以在数小时内生成数千条数据，并在六个双臂任务上改善对新物体姿态和形状的泛化；以物体为中心的观测和 6-DoF 末端动作还支持跨机器人本体迁移。该方法的关键前提是任务能够被拆成可复用的协调结构，复杂接触动力学仍可能超出轨迹优化的覆盖范围。

=== 2. Supervised Mixture-of-Experts for Surgical Grasping and Retraction [#link("https://roboticsconference.org/program/papers/2/", "RSS 页面")]

本文针对手术机器人数据少、工作空间受限且安全要求高的问题，在 Action Chunking Transformer 等基础策略之上加入按手术阶段切换的监督式 Mixture-of-Experts。仅使用立体内窥镜图像和少于 150 条示教，策略就学习了肠组织抓取与持续牵开这类长时序协作任务。作者报告，相比标准 ACT，MoE 在分布内和新抓取位置、低照度、局部遮挡等分布外条件下都更稳健，并能零样本迁移到离体猪组织。这里的专家划分利用了手术阶段结构，因此能否迁移到阶段边界不清晰的操作任务仍需验证。

=== 3. DexImit: Learning Bimanual Dexterous Manipulation from Monocular Human Videos [#link("https://roboticsconference.org/program/papers/3/", "RSS 页面")]

DexImit 将单目人类操作视频转换为物理上合理的机器人双手数据。管线依次完成任意视角下的手--物交互重建、子任务分解与双手调度、与交互过程一致的机器人轨迹合成，以及面向真实部署的数据增强。论文强调该流程不需要额外标注，既可以使用互联网视频，也可以使用视频生成模型产出的数据，并覆盖切苹果、制作饮料和叠杯子等工具使用、长时序和精细操作。它把人类视频的规模优势引入灵巧操作，但从单目重建到机器人轨迹的每一层误差都会影响最终可执行性。

=== 4. Semantic Contact Fields for Category-Level Generalizable Tool Manipulation [#link("https://roboticsconference.org/program/papers/4/", "RSS 页面")]

SCFields 用统一的三维表示同时编码视觉语义和稠密接触估计，目标是在不同工具几何之间实现类别级泛化。作者先用大规模仿真学习一般接触物理，再利用几何启发式与力优化生成的伪标签，在少量真实数据上校准软体触觉传感器。得到的接触场作为 Diffusion Policy 的稠密观测，支持刮擦、蜡笔绘画和削皮等任务。相比直接使用原始触觉，显式接触场更容易跨传感器和工具迁移；但仿真接触模型与软传感器形变之间的差异仍是主要误差来源。

=== 5. Contact-Grounded Policy: Dexterous Visuotactile Policy with Generative Contact Grounding [#link("https://roboticsconference.org/program/papers/5/", "RSS 页面")]

CGP 不把触觉当作普通附加输入，而是预测未来机器人状态与触觉反馈的耦合轨迹，再用学习到的接触一致性映射将其转换为柔顺控制器可执行的目标状态。其核心是压缩潜空间中的条件 Diffusion Model，加上把“预期接触”落到真实控制目标上的映射。作者在四指 Allegro V5 与带密集触觉阵列的五指模拟手上评估了手内操作、精细抓取和工具使用，并报告优于视觉或常规视触觉 Diffusion Policy。方法的优势在于将接触意图接入低层控制，代价是需要稳定预测长时序触觉与状态的联合分布。

=== 6. TactAlign: Human-to-Robot Policy Transfer via Tactile Alignment [#link("https://roboticsconference.org/program/papers/6/", "RSS 页面")]

TactAlign 解决人类穿戴设备采集的触觉信号如何迁移到传感器和本体都不同的机器人。它用 Rectified Flow 将人类和机器人触觉观测映射到共享潜空间，不要求成对数据、人工标签或特权信息；手--物交互结构产生的伪配对用于引导低成本潜变量传输。作者报告，在拨动、插入和合盖任务中，约 5 分钟人类数据即可改善跨本体策略迁移，并在拧灯泡任务上实现零样本迁移。关键假设是不同本体的触觉变化存在可对齐的低维结构，强烈的传感器非线性或接触语义差异可能破坏这一假设。

=== 7. A Systematic Study of Data Modalities and Strategies for Co-training Large Behavior Models for Robot Manipulation [#link("https://roboticsconference.org/program/papers/7/", "RSS 页面")]

这是一项针对大型行为模型协同训练的系统性实证研究。作者比较了视觉语言数据、机器人轨迹的密集语言标注、跨本体机器人数据、人类视频和离散动作 Token 五种模态，并评估单阶段与多阶段训练策略。实验规模包括 4,000 小时机器人和人类操作数据、5,000 万视觉语言样本、89 个策略、58,000 次仿真 Rollout 和 2,835 次真实 Rollout。结果显示，视觉语言与跨本体机器人数据能明显改善分布偏移、未见任务和语言跟随；离散动作 Token 没有显著收益，多种有效模态组合则产生累积增益。它更像一张数据配方地图，而不是新的模型结构，价值在于给出大规模协同训练的可操作消融结论。

=== 8. SID: Sliding into Distribution for Robust Few-Demonstration Manipulation [#link("https://roboticsconference.org/program/papers/8/", "RSS 页面")]

SID 将少样本操作的核心问题表述为在线恢复到示教分布。系统从规范化示教中学习以物体为中心的运动场：当当前状态远离示教流形时，运动场提供较大的纠正；接近流形后，修正自然衰减，再交给轻量的自中心执行策略完成任务。配合保持动作--观测一致性的点云重投影增强，作者在六项真实任务中仅用两条示教就取得约 90% 的分布外初始化成功率，并对干扰和外力保持较小性能下降。这个设计明确区分“回到可执行区域”和“在区域内完成任务”，但运动场本身仍需要足够覆盖不同物体和姿态的几何变化。

=== 9. UMI-Underwater: Learning Underwater Manipulation without Underwater Teleoperation [#link("https://roboticsconference.org/program/papers/9/", "RSS 页面")]

UMI-Underwater 面向水下成像退化、光照变化大且示教采集昂贵的问题，设计了自监督的成功抓取数据采集流程，并用深度 Affordance 表示把陆地人类示教迁移到水下。陆地上训练的 Affordance 模型通过几何对齐零样本部署到水下，随后用自动收集的水下示教训练 Affordance-conditioned Diffusion Policy。池实验显示，该方法提升了背景变化下的抓取鲁棒性，也能泛化到只在陆地数据中出现的物体。深度表示降低了颜色和光照域差异，但水下折射、悬浮物和动力学变化仍不能完全由几何对齐解释。


本片段继续按 RSS 2026 官网 Session 组织论文。摘要中的性能数字和比较均保留为作者报告，尚未替代对正文、补充材料和代码的完整核验。

== Manipulation 2

=== 54. CoRAL: Contact-Rich Adaptive LLM-based Control for Robotic Manipulation [#link("https://roboticsconference.org/program/papers/54/", "RSS 页面")]

CoRAL 将大语言模型从直接控制器改为代价函数设计器，把高层语义推理与 MPPI 低层控制分离。视觉语言模型先提供质量、摩擦等物理参数的语义先验，在线系统辨识再根据交互反馈修正这些参数，语言模型同时调整规划代价，检索记忆则复用重复任务中的成功策略。作者在仿真和真实硬件的接触丰富任务上报告，未见场景的平均成功率相较 VLA 和基础模型规划器提升超过 50%；其效果依赖在线辨识能否及时捕捉接触动力学。

=== 55. GHOST: Hierarchical Sub-Goal Policies for Generalizing Robot Manipulation [#link("https://roboticsconference.org/program/papers/55/", "RSS 页面")]

GHOST 将视觉运动控制分解为两个层次：高层从多视角 RGB-D 预测下一个三维末端位姿子目标，低层目标条件控制器再执行与机器人本体相关的动作。作者用把三维目标投影为图像热图的空间接口连接两层，并利用本体无关的子目标吸收人类视频示教，避免带噪的动作重定向。相比平面 Diffusion Policy，该层次化设计在多项操作任务上提高了泛化与鲁棒性，也能用少量人类示教适配新物体和任务变体；但高层子目标预测错误仍会限制低层执行。

=== 56. Robo3R: Enhancing Robotic Manipulation with Accurate Feed-Forward 3D Reconstruction [#link("https://roboticsconference.org/program/papers/56/", "RSS 页面")]

Robo3R 直接从 RGB 图像和机器人状态实时预测适合操作的度量尺度三维场景。模型联合估计局部几何与相对相机位姿，再通过全局相似变换统一到机器人坐标系，并用掩码点云头和基于关键点的 PnP 精修点云细节及外参；训练数据 Robo3R-4M 包含四百万帧高保真合成标注。作者报告其优于现有重建方法和深度传感器，并在模仿学习、仿真到现实、抓取生成及无碰规划等下游任务中持续带来收益；合成数据与真实材质、遮挡之间的差异仍需实测关注。

=== 57. Semantically Structured Mixture-of-Experts for Compositional Robotic Manipulation [#link("https://roboticsconference.org/program/papers/57/", "RSS 页面")]

SMoDP 用语义任务结构来路由 Diffusion Policy 的专家，而不是依赖低层噪声或潜变量统计。一个由离线视觉语言标注蒸馏出的轻量技能预测器识别行为阶段，双重对比学习分别对齐视觉与语言技能语义，并约束外观不同但功能相同的行为使用一致路由。作者在多任务基准上取得更高性能和更好的参数效率，并通过参数高效微调实现组合式新任务迁移；其收益取决于技能阶段标注和路由语义是否稳定。

=== 58. Learning Native Continuation for Action Chunking Flow Policies [#link("https://roboticsconference.org/program/papers/58/", "RSS 页面")]

Legato 针对动作分块策略在块边界处不连续、外部实时拼接会产生多模态切换的问题，提出训练阶段的原生续接方法。它用已知动作与噪声的调度混合初始化去噪过程，同时重塑流场，使训练与带逐步引导的推理保持一致，并随机化调度条件以适应不同推理延迟。五项真实操作实验中，作者报告轨迹平滑度和任务完成时间相较 RTC 均约提升 10%，且减少犹豫；方法需要在训练时覆盖部署中的延迟范围。

=== 59. DexEvolve: Evolutionary Optimization for Robust and Diverse Dexterous Grasp Synthesis [#link("https://roboticsconference.org/program/papers/59/", "RSS 页面")]

DexEvolve 把高保真仿真器从抓取验证器变成持续优化阶段：先用解析方法生成可能次优的种子抓取，再在 Isaac Sim 中用异步、无梯度进化搜索提升稳定性，同时保留多样性，还可加入人类偏好或领域质量指标。优化后的抓取分布被蒸馏到 Diffusion Model，以支持真实部署。作者在 Handles 和 DexGraspNet 子集上报告每个物体可获得超过 120 个稳定抓取，比未优化解析方法多 1.7 至 6 倍，独特抓取覆盖率也高于扩散基线 46% 至 60%；进化搜索的仿真成本和质量指标设计是主要工程权衡。

=== 60. TACTIC: Tactile and Vision Conditioned Contact-Centric Control for Whole-Arm Manipulation [#link("https://roboticsconference.org/program/papers/60/", "RSS 页面")]

TACTIC 面向接触形成、滑动和断开同时发生的全臂操作，构建融合 RGB-D、分布式触觉和二维邻近表示的接触中心预测模型。学习到的动作条件潜动力学通过接触 Jacobian 与解析运动学耦合，预测未来接触构型和交互力，再由带接触感知采样的 MPC 在调节任务进度和全臂受力之间做权衡。作者在仿真中优于模型式和无模型方法，并在带全臂触觉的机器人上完成假人翻转重定位和三维动态迷宫到达；模型对多链接接触的稀疏覆盖仍较敏感。

=== 61. Distributionally Robust Control via Stein Variational Inference for Contact-rich Manipulation [#link("https://roboticsconference.org/program/papers/61/", "RSS 页面")]

本文把接触丰富操作表述为分布鲁棒控制优化，用 Stein 变分推断构造确定性求解方法，在保留模型式控制效率的同时显式表示任务相关的参数不确定性。得到的控制器会根据任务对不确定参数的敏感度调整策略，而不是仅使用单一标称模型。作者报告在广泛参数不确定性的多项接触任务上鲁棒性最高提升约 3 倍，并优于现有模型式控制；方法仍依赖可用的动力学参数化和不确定性集合。

=== 62. PolaRiS: Scalable Real-to-Sim Evaluations for Generalist Robot Policies [#link("https://roboticsconference.org/program/papers/62/", "RSS 页面")]

PolaRiS 用神经重建把真实场景的短视频扫描转换为可交互仿真环境，并用简单的仿真数据协同训练缩小剩余的真实到仿真差异。该框架旨在让通用机器人策略在大量真实风格场景中可重复、低成本地评估，而不依赖人工逐一建模。配对实验覆盖 600 次真实 Rollout 和超过 93,000 次仿真 Rollout，作者报告其对未微调通用策略排序的相关性显著强于既有仿真基准；重建误差和物理参数缺失仍可能使评估偏离真实表现。

== Manipulation 3

=== 121. R2RGen: Real-to-Real 3D Data Generation for Spatially-generalized Robotic Manipulation [#link("https://roboticsconference.org/program/papers/121/", "RSS 页面")]

R2RGen 直接在真实点云的观测--动作对上做三维增强，避免仿真和渲染带来的 sim-to-real 差距。流程先将不同相机设置下的示教解析到共享三维空间，再用分组回溯策略改变物体和机器人位置，最后通过相机感知的后处理使生成数据匹配真实三维传感器分布。作者报告该即插即用框架在多项实验中提高数据效率，并显示出扩展到移动操作的潜力；其覆盖范围受源示教几何和点云质量限制。

=== 122. DexGrasp-Zero: A Morphology-Aligned Policy for Zero-Shot Cross-Embodiment Dexterous Grasping [#link("https://roboticsconference.org/program/papers/122/", "RSS 页面")]

DexGrasp-Zero 用形态对齐图表示不同灵巧手：将运动学关键点映射为有解剖语义的节点，并为每个节点配置三轴正交运动基元。基于此，MAGCN 编码手部图结构，Physical Property Injection 将连杆长度和驱动限制等本体约束注入特征，从而直接预测适配不同手型的抓取策略。四种手联合训练后，作者在未见 LEAP 和 Inspire 硬件上报告 85% 零样本成功率，真实三种平台对未见物体平均成功率为 82%；跨手型的图对应关系和真实执行限制仍是迁移风险。

=== 123. Minimalist Compliance Control [#link("https://roboticsconference.org/program/papers/123/", "RSS 页面")]

本文仅利用现代伺服器已有的电机电流或电压信号估计外力，不需要力矩传感器、电流控制或强化学习，即可实现任务空间导纳控制。外部力通过执行器信号与 Jacobian 估计，并被接入柔顺控制器，因此高层可继续使用视觉语言模型、模仿学习或模型式规划器。作者在机械臂、灵巧手和 humanoid 上的多种接触任务中展示了安全且可迁移的柔顺交互；估计精度会受到电机模型、摩擦和驱动器信号带宽影响。

=== 124. One Hand to Rule Them All: Canonical Representations for Unified Dexterous Manipulation [#link("https://roboticsconference.org/program/papers/124/", "RSS 页面")]

本文提出参数化的灵巧手规范表示和统一 URDF 格式，把不同手型的形态、运动学及动作空间放入同一坐标体系。该表示支持在结构化潜流形中平滑插值不同本体，同时保留原始 URDF 的动力学和功能属性；作者还用 VAE 学习紧凑的语义嵌入，并训练条件抓取策略。仿真和真实实验显示，策略可迁移到未见形态，例如三指 LEAP 手达到 81.9% 零样本成功率；统一描述能否覆盖更复杂的柔性或欠驱动手仍待验证。

=== 125. AxisGuide: Grounding Robot Action Coordinate System in RGB Observations for Robust Visuomotor Manipulation [#link("https://roboticsconference.org/program/papers/125/", "RSS 页面")]

AxisGuide 认为视觉策略在物体位置变化时失败，部分原因是没有理解机器人基座坐标系中的动作如何映射到图像。方法利用相机参数和末端位姿，将基座坐标轴在各视角中渲染出来，并把表示 +x、+y、+z 运动含义的少量提示通道加入 RGB 观测。作者在 LIBERO 仿真和真实环境中报告明显的性能与泛化提升；额外坐标提示依赖准确标定，标定误差或相机变化可能削弱收益。

=== 126. Learning Deformable Object Manipulation Using Task-Level Iterative Learning Control [#link("https://roboticsconference.org/program/papers/126/", "RSS 页面")]

本文针对绳索等无限自由度、欠驱动物体的动态操作，提出任务层迭代学习控制，并以非平面 flying knot 为例在真实硬件上学习。每次迭代通过二次规划建立机器人--绳索局部逆模型，把任务空间误差传播为动作更新；仅需一次人类示教和简化绳索模型，不依赖大规模示教或仿真。覆盖链条、乳胶管及编织绳等七类绳索时，作者报告最多 10 次试验内达到 100% 成功，并能在多数绳型之间用约 2 至 5 次试验迁移；局部模型在更强拓扑变化下的稳定性仍是问题。

=== 127. CLAMP: Contrastive Learning for 3D Multi-View Action-Conditioned Robotic Manipulation Pretraining [#link("https://roboticsconference.org/program/papers/127/", "RSS 页面")]

CLAMP 用 RGB-D 点云和机器人动作进行三维多视角预训练，以补足二维图像表示缺失的空间几何。它从融合点云和外参重新渲染带深度与三维坐标的多视角观测，包括动态腕部视角，并通过大规模仿真轨迹的对比学习建立几何、位置与动作模式的联系；同时预训练 Diffusion Policy 初始化微调权重。有限示教微调实验覆盖六项仿真和五项真实任务，作者报告优于现有基线并提高未见任务的数据效率；预训练仿真轨迹与真实传感器噪声之间仍存在域差异。

=== 128. Force Policy: Learning Hybrid Force-Position Control Policy under Interaction Frame for Contact-Rich Manipulation [#link("https://roboticsconference.org/program/papers/128/", "RSS 页面")]

Force Policy 从示教中恢复瞬时的局部交互坐标系，用它将接触力调节与运动执行解耦。全局视觉策略负责自由空间动作，接触发生后，高频局部策略根据力反馈估计交互坐标系并执行混合力--位姿控制，从而在全局泛化与局部稳定之间分工。真实接触任务显示，相比强基线，该方法更可靠地建立接触、调节力，并泛化到不同几何和物理属性的新物体；恢复交互坐标系需要示教包含足够丰富的接触变化。

=== 129. ViTacFormer: Learning Cross-Modal Representation for Visuo-Tactile Dexterous Manipulation [#link("https://roboticsconference.org/program/papers/129/", "RSS 页面")]

ViTacFormer 用跨注意力编码器融合高分辨率视觉和触觉，并以自回归触觉预测头预估未来接触信号，再通过由易到难的课程逐步塑造视触觉潜空间。该表示驱动多指手模仿学习，使策略能在遮挡和精细接触中调整动作。作者在多项真实基准上报告成功率约比既有系统高 50%，并完成最多 11 个阶段、连续运行 2.5 分钟的长时序灵巧任务；长期触觉预测误差可能随阶段累积。

== Planning

=== 179. Vec-QMDP: Vectorized POMDP Planning on CPUs for Real-Time Autonomous Driving [#link("https://roboticsconference.org/program/papers/179/", "RSS 页面")]

Vec-QMDP 将不确定性下的 POMDP 搜索改造成适合 CPU SIMD 的数据导向布局，避免传统 CPU-GPU 求解器的同步和分支发散开销。方法用连续缓存结构、跨核心与 SIMD lane 的层次并行扩展树和碰撞检查，并结合 UCB 负载均衡及向量化 STR-tree。作者在大规模自动驾驶基准上报告相较串行规划器 227 至 1073 倍加速，并达到毫秒级延迟；其性能优势依赖规则化数据布局和可向量化的碰撞检测。

=== 180. From Reaction to Anticipation: Proactive Failure Recovery through Agentic Task Graph for Robotic Manipulation [#link("https://roboticsconference.org/program/papers/180/", "RSS 页面")]

AgentChord 将操作任务表示成带恢复分支的有向图，在执行前预先编译针对上下文的纠错行为。系统由负责任务结构化的 composer、编译执行序列的 arranger 和编排恢复的 conductor 协同工作，低延迟监视器检测偏差后直接触发预编译恢复，避免临时重新规划。作者在长时序双臂任务上报告成功率和执行效率提升；预先枚举恢复分支的覆盖度决定了面对未见故障时的鲁棒性。

=== 181. Hypothesis-driven Model Expansion under Uncertainty for Open-World Robot Planning [#link("https://roboticsconference.org/program/papers/181/", "RSS 页面")]

本文面向物体和动作知识不完整的开放世界服务机器人，维护关于抽象世界模型的候选假设及其不确定性。基础模型生成状态与转移假设，自动规划器则把假设验证和目标执行合并到同一动作序列；执行反馈发现假设错误后，系统迭代修正并扩展知识。仿真和真实实验显示该框架能够在未知环境中自主扩展模型并完成任务；初始假设质量和基础模型反馈的可靠性仍直接影响规划安全。

=== 182. ELVIS: Ensemble-Calibrated Latent Imagination for Long-Horizon Visual MPC [#link("https://roboticsconference.org/program/papers/182/", "RSS 页面")]

ELVIS 在 Dreamer 风格循环状态空间模型中规划，用高斯混合 MPPI 保留长时域分支未来，避免把多模态动作价值平均成单一模式。它还用潜在评论家集成给出上置信界，调节随时间变化的 lambda-return，在远期展望和自举之间控制模型误差累积；同一回报同时训练想象轨迹中的 actor-critic 先验并评价候选轨迹。十四项 DeepMind Control Suite 视觉任务上，作者报告优于 TD-MPC2 与 DreamerV3，并在严重遮挡的真实喷砂任务中零样本迁移；集成模型的计算和校准成本可能限制实时应用。

=== 183. Informative Path Planning with Guaranteed Estimation Uncertainty [#link("https://roboticsconference.org/program/papers/183/", "RSS 页面")]

本文把信息路径规划与覆盖保证结合起来，寻找最短路径，使高斯过程后验方差在监测区域内低于给定阈值。方法先学习 GP，再将核函数转成不同候选感知位置的二值覆盖图，最后规划满足全局不确定性约束的近最短路线；非平稳核处理空间相关性变化，障碍物支持非凸环境。作者给出感知点选择及联合选点--路径问题的近似保证，并在地形数据和水面与水下自主航行器实地实验中以更少感知点和更短距离达到目标；保证成立依赖 GP 模型与方差阈值确能代表任务误差。

=== 184. KinDER: A Physical Reasoning Benchmark for Robot Learning and Planning [#link("https://roboticsconference.org/program/papers/184/", "RSS 页面")]

KinDER 是面向运动学和动力学具身推理的基准，包含 25 个程序生成环境、Gymnasium 兼容库、参数化技能与示教，以及覆盖任务规划、运动规划、模仿学习、强化学习和基础模型的 8 个基线。环境将物理推理拆成空间关系、非抓取多物体操作、工具使用、组合几何约束和动态约束，并尽量排除感知与语言复杂度。评测显示现有方法在许多环境中仍难以求解，另有移动操作机的 real-to-sim-to-real 实验检验对应关系；基准的程序化分布与真实任务差异需要额外评估。

=== 185. Integrated Hierarchical Decision-Making in Inverse Kinematic Planning and Control [#link("https://roboticsconference.org/program/papers/185/", "RSS 页面")]

本文提出稀疏层次非线性规划求解器，将决策选择与逆运动学规划、控制紧密结合。它利用层次稀疏结构和较少用于机器人问题的 l0 范数，同时处理稀疏关节选择、从多个离散末端位置中按优先级选点，以及双臂抓取位置选择等非线性问题。相比混合整数非线性规划或 l1 近似，作者主张该方法兼顾效率、灵活性和准确性；摘要未给出统一的跨平台性能数字，实际收益仍需结合具体约束规模判断。

=== 186. HOP: Fast Differential Dynamic Programming for Horizon-Optimal Trajectory Planning [#link("https://roboticsconference.org/program/papers/186/", "RSS 页面")]

HOP 研究在动态可行前提下同时最小化规划时域的 horizon-optimal 控制问题。作者将 Riccati 递推重写为线性分式变换，从而可在时变线性二次系统中复用计算，并进一步与 DDP 结合以处理非线性动力学和非二次代价。在线性时变问题上，方法总能得到与暴力基线相同的最优解，速度最高快 40 倍；非线性场景也优于时不变 LQR 近似，但 DDP 仍可能受局部最优影响。

=== 187. Implicit Null-space Manifold Generation for Redundant Robotic Systems [#link("https://roboticsconference.org/program/papers/187/", "RSS 页面")]

针对冗余机器人同一任务对应的一族构型，本文不只计算单条解，而是建立隐式标量场，使其零水平集表示整个解流形。Jacobian 引导的探索在解流形邻域采样，得到连续距离场来编码到解集的接近程度，并支持任务参数连续变化时的一致建模。三连杆平面机器人和七自由度 Franka 实验验证了表示效果；采样是否充分以及高维流形的全局覆盖仍是扩展到复杂机器人的关键。

=== 188. Exploit Agile Mobility of Steerable-Wheeled Mobile Robots: A Fast Motion Planning Approach [#link("https://roboticsconference.org/program/papers/188/", "RSS 页面")]

本文将可转向轮移动机器人规划统一表述为在执行器可行性约束下最大化运动性能，并允许灵活组合任务目标、轮子布局和执行器限制。为获得实时求解，作者设计反复收缩非凸可行集的算法，并证明其下降、收敛和可行性性质；这种迭代具有 anytime 特征，适合随时返回可行解。轨迹跟踪仿真显示，相比基线计算时间降低一个数量级且约束满足更好；摘要未说明在高维复杂障碍环境中的表现。

=== 189. Sampling-Based Follow-the-Leader Motion Planning for Manipulator-Mounted Continuum Robots [#link("https://roboticsconference.org/program/papers/189/", "RSS 页面")]

本文为安装在六自由度机械臂上的连续体机器人设计 Follow-the-Leader 采样规划器，同时搜索连续体形状、机器人构型和基座位姿。核心做法是把全局形状搜索与基座位姿求解解耦，用闭式几何构造确定基座，避免在线迭代优化，并把主要计算移到离线阶段。理论上，形状搜索具备分辨率完备性，路径插值保持末端精确跟踪；120 条仿真路径中作者报告 100% 成功、末端误差为 0、平均形状偏差为机器人长度的 1.9%，并在腱驱动连续体机器人上验证可行性。

=== 190. Certifiable Gradient-Based Contact-Rich Manipulation via Smoothing-Error Reachable Tubes [#link("https://roboticsconference.org/program/papers/190/", "RSS 页面")]

本文通过平滑接触动力学获得可用梯度，同时把平滑模型与真实混合动力学之间的误差表示为集合值偏差，并纳入可达管优化。时变仿射反馈策略由此能够在只依赖平滑动力学梯度的情况下预测真实闭环行为，并对约束满足与目标可达性给出形式化保证。平面推动、物体旋转和手内灵巧操作实验显示，方法在保证约束的同时比基线具有更低目标误差；保证质量依赖平滑误差集合是否足够保守而不过度放大规划难度。

=== 191. Parallel Differentiable Reachability for Learning and Planning with Certified Neural Dynamics and Controllers [#link("https://roboticsconference.org/program/papers/191/", "RSS 页面")]

本文在 JAX 中实现可并行、可微分的可达性分析，统一连续和离散系统，并支持解析或神经网络动力学与控制器。工具以 Taylor 模型 flowpipe 和 CROWN 风格线性界传播构造 GPU 批处理的可达集，该原语可求导并用于训练动力学模型、控制器及带认证可达集的采样 MPC。非抓取物体操作和四旋翼实验显示，方法在接近基线规划性能的同时提供不确定性下的紧致认证界；界的保守性、神经网络规模和 GPU 内存会影响可扩展性。


本组论文围绕示教学习与视觉--语言--动作（VLA）模型的可迁移性、可控性和持续改进展开。共同趋势是：用更结构化的动作表示、接触或几何先验缩小感知到控制的鸿沟，并把人类数据、失败数据和部署经验纳入训练闭环。

== Imitation Learning 1

=== 72. Emergence of Human to Robot Transfer in Vision-Language-Action Models [#link("https://roboticsconference.org/program/papers/72/", "RSS 页面")]

本文研究人类视频是否能为 VLA 提供可迁移监督。通过简单的机器人数据与人类视频协同预训练，作者发现当场景、任务和机器人本体足够多样时，人到机器人迁移能力会涌现；多样化预训练形成了与本体无关的表示，使仅在人类数据中出现的泛化场景性能近乎翻倍。

=== 73. PointACT: Vision-Language-Action Models with Multi-Scale Point-Action Interaction [#link("https://roboticsconference.org/program/papers/73/", "RSS 页面")]

PointACT 将分层三维点云直接接入动作解码，通过多尺度点--动作交互和窗口注意力同时关注局部几何与全局结构。在 LIBERO、RLBench 上相较预训练 VLA 稳定提升，RLBench-10Tasks 成功率提高约 10%；消融表明，三维几何与二维语义的紧耦合是空间落地控制的关键。

=== 74. Steerable Vision-Language-Action Policies for Embodied Reasoning and Hierarchical Control [#link("https://roboticsconference.org/program/papers/74/", "RSS 页面")]

Steerable Policies 用子任务、运动和像素坐标等多层次合成指令训练 VLA，让高层视觉语言模型能更精细地操控低层策略。无论由学习到的具身推理器还是通过上下文学习驱动的现成 VLM 控制，该方法在真实长时序与分布外操作中都优于仅传递自然语言任务描述的层级基线。

=== 75. OAT: Ordered Action Tokenization [#link("https://roboticsconference.org/program/papers/75/", "RSS 页面")]

OAT 针对连续动作的自回归建模提出有序动作 Token 化方案，同时满足高压缩、完全可解码和从左到右的因果顺序。Transformer、有限标量量化与顺序约束使前缀即可逐步解码，在 20 多个仿真和真实任务上优于其他 Token 化及扩散基线，并提供推理成本与动作精度之间的 anytime 权衡。

=== 76. Beyond Binary Success: Sample-Efficient and Statistically Rigorous Robot Policy Comparison [#link("https://roboticsconference.org/program/papers/76/", "RSS 页面")]

本文将安全 anytime-valid inference（SAVI）扩展到机器人策略比较，不再局限于二元成功率，而是支持任务进度、回报和轨迹平滑度等离散或连续指标。序贯检验可在证据充分时提前停止，实验显示相较批量评估最多减少 70% 成本；细粒度进度指标也比二元成功更快区分策略。

=== 77. mimic-video: Video-Action Models for Generalizable Robot Control Beyond VLAs [#link("https://roboticsconference.org/program/papers/77/", "RSS 页面")]

mimic-video 认为静态网页视觉语言预训练缺少物理因果，因此使用互联网规模视频模型捕获语义与视觉动力学，再以 flow matching 动作解码器（逆动力学模型）生成机器人控制。仿真和真实操作实验报告相较传统 VLA 约 10 倍样本效率和 2 倍收敛速度，说明视频先验可减少专家轨迹负担。

=== 78. TouchGuide: Inference-Time Steering of Visuomotor Policies via Touch Guidance [#link("https://roboticsconference.org/program/papers/78/", "RSS 页面")]

TouchGuide 在推理阶段将视觉策略生成的粗动作交给接触物理模型（CPM）评分和修正，在低维动作空间中融合视觉与触觉，而无需重新训练主策略。配套 TacUMI 用刚性指尖低成本采集可靠触觉示教；鞋带、芯片交接等五项接触丰富任务显示其优于现有视触觉策略。

=== 79. Visual Verification Enables Inference-time Steering and Autonomous Policy Improvement [#link("https://roboticsconference.org/program/papers/79/", "RSS 页面")]

该工作把预训练策略作为动作生成器，并配合无需梯度的视觉验证器在测试时筛选动作，从而无需额外训练即可进行推理期引导。SIMPLER 与 DROID 实验表明 VLM 或启发式验证器都能提升执行效果；验证后的自主 Rollout 还能作为离线监督，持续训练出接近人工示教效率的策略。

=== 80. Set-Supervised Diffusion Policy: Learning Action-Chunking Diffusion through Corrections [#link("https://roboticsconference.org/program/papers/80/", "RSS 页面")]

Set-Supervised Diffusion Policy（SDP）把人类纠正产生的“错误动作块--期望动作块”视为集合监督，而不是只拟合正样本。对比式训练促使扩散策略贴近可接受动作集合，在多项操作任务中提升性能，尤其增强对噪声示教的鲁棒性，并提高人机协同数据聚合效率。

== Imitation Learning 2

=== 139. Tune to Learn: How Controller Gains Shape Robot Policy Learning [#link("https://roboticsconference.org/program/papers/139/", "RSS 页面")]

本文系统研究位置控制器增益对离线模仿、从零强化学习和 sim-to-real 的影响。离线模仿更偏好柔顺且过阻尼的增益；强化学习在各增益区间都可通过匹配超参数成功；而刚性、过阻尼设置会损害 sim-to-real。结论是增益应按学习范式的可学习性选择，而非只按期望任务刚度选择。

=== 140. Robometer: Scaling General-Purpose Robotic Reward Models via Trajectory Comparisons [#link("https://roboticsconference.org/program/papers/140/", "RSS 页面")]

Robometer 将轨迹内的逐帧进度监督与同任务轨迹间的偏好比较结合，既锚定奖励尺度，又能利用大量次优和失败数据。配套 RBM-1M 收集超过百万条跨本体轨迹，得到的奖励模型在基准和真实任务上泛化更好，并改善多种下游机器人学习应用。

=== 141. Contact-Anchored Policies: Contact Conditioning Creates Strong Robot Utility Models [#link("https://roboticsconference.org/program/papers/141/", "RSS 页面")]

CAP 用空间接触点取代运行时语言条件，并将能力拆成模块化效用模型。EgoGym 支持真实到仿真的快速失败分析和迭代；仅用 23 小时示教，三个基础操作技能即可零样本泛化到新环境和本体，较大型 VLA 的零样本评估提升 56%。

=== 142. When to Act, Ask, or Learn: Uncertainty-Aware Policy Steering [#link("https://roboticsconference.org/program/papers/142/", "RSS 页面")]

UPS 同时估计任务语义不确定性与低层动作可行性，并在“执行高置信动作、询问用户澄清、请求动作干预”之间选择。Conformal prediction 为 VLM 与基础策略的组合提供校准保证；部署中收集的干预通过残差学习继续改进策略，在仿真和硬件上减少了昂贵的人类介入。

=== 143. ReSteer: Quantifying and Refining the Steerability of Multitask Robot Policies [#link("https://roboticsconference.org/program/papers/143/", "RSS 页面")]

ReSteer 定义并测量多任务策略的可转向性，指出训练任务轨迹分布重叠不足是常见原因。它用估计器定位低可转向状态，合成针对性运动片段，再通过自精炼训练；在 LIBERO 的 1.8 万次 Rollout 中可转向性提升 11%，真实实验显示这对交互式随时换任务至关重要。

=== 144. Emergent Neural Automaton Policies: Learning Symbolic Structure from Visuomotor Trajectories [#link("https://roboticsconference.org/program/papers/144/", "RSS 页面")]

ENAP 从视觉运动轨迹中用自适应聚类与扩展 L\* 算法推断 Mealy 状态机，将潜在任务模式作为可解释的高层规划器，再由反应式残差网络学习连续控制。离散转移与连续残差的组合无需任务标签，在低数据长时序操作中较端到端 VLA 最高提升 27%，同时保留结构化意图。

=== 145. Universal Pose Pretraining for Generalizable Vision-Language-Action Policies [#link("https://roboticsconference.org/program/papers/145/", "RSS 页面")]

Pose-VLA 将 VLA 训练拆为通用三维空间先验预训练和本体动作对齐后训练，以离散姿态 Token 统一相机中心坐标中的空间表示。姿态监督先建立几何落地能力，再用轨迹监督学习运动；RoboTwin 2.0 平均成功率达 79.5%，LIBERO 达 96.0%，真实任务每项仅 100 条示教也能泛化到多种物体。

=== 146. EigenSafe: A Spectral Framework for Learning-Based Probabilistic Safety Assessment [#link("https://roboticsconference.org/program/papers/146/", "RSS 页面")]

EigenSafe 从随机系统安全概率的动态规划算子出发，学习其主特征对作为状态--动作安全评分及闭环系统安全信息。该谱表示可用于约束或指导策略更新，并在安全强化学习和 UR3 食品准备模仿任务中验证了对策略安全性的提升。

=== 147. DISC: Decoupling Instruction from State-Conditioned Control via Policy Generation [#link("https://roboticsconference.org/program/papers/147/", "RSS 页面")]

DISC 用超网络仅根据语言指令生成完整的任务策略参数，使执行策略不再直接读取语言，从结构上切断观察泄漏导致的场景捷径。两阶段参数精炼网络模拟梯度优化的归纳偏置；在 LIBERO-90、Meta-World 和真实同场景任务中优于纠缠式基线，并支持少量示教适配和改写指令泛化。

== Imitation Learning 3

=== 201. Long-Context Robot Imitation Learning by Focusing on Key History Frames [#link("https://roboticsconference.org/program/papers/201/", "RSS 页面")]

Big Picture Policies（BPP）用 VLM 从长历史中挑选少量与任务相关的关键帧，避免直接建模指数增长的历史空间所产生的偶然相关。四项真实和三项仿真任务中，BPP 在保留历史表达能力的同时降低训练--部署分布差异，真实评估成功率比最佳对比方法高 70%。

=== 202. Functional Force-Aware Retargeting from Virtual Human Demos to Soft Robot Policies [#link("https://roboticsconference.org/program/papers/202/", "RSS 页面")]

SoftAct 利用沉浸式 VR 记录人体运动、接触区域和力分布，并以两阶段力感知重定向教会软体手：先按手指接触力分配机器人手指，再在线结合末端位姿与测地线接触修正。非人形气动软手实验中，指尖轨迹 RMSE 最多降低 55%、方差降低 69%，且零样本真实部署成功率更高。

=== 203. LAP: Language-Action Pre-training Enables Zero-Shot Cross-Embodiment Transfer [#link("https://roboticsconference.org/program/papers/203/", "RSS 页面")]

LAP 将低层机器人动作直接表示为自然语言，使动作监督分布与预训练视觉语言模型对齐，无需学习 Token 化器、额外标注或本体专用结构。LAP-3B 在未见机器人上无需微调即可取得超过 50% 平均成功率，约为此前 VLA 的两倍，并能统一动作预测与视觉问答进行协同训练。

=== 204. Unlocking In-the-Wild Loco-Manipulation with Robot-Free Egocentric Demonstration [#link("https://roboticsconference.org/program/papers/204/", "RSS 页面")]

EgoHumanoid 将大量人类第一视角示教与少量机器人数据协同训练，用视角对齐和动作对齐处理人体与人形机器人的形态差异。便携采集系统支持在真实环境规模化收集数据；加入机器人无关的人类数据后，未见环境中的全身移动操作比机器人专属基线提升 51%。

=== 205. HoMMI: Learning Whole-Body Mobile Manipulation from Human Demonstrations [#link("https://roboticsconference.org/program/papers/205/", "RSS 页面")]

HoMMI 在 UMI 接口上加入第一视角感知，采集移动操作所需的全局上下文，并通过跨本体手--眼策略缩小观察和动作差异。其本体无关视觉表示、宽松头部动作表示与全身控制器，可将手--眼轨迹转化为满足机器人约束的协调运动，覆盖双臂、导航和主动感知的长时序任务。

=== 206. Mimic Intent, Not Just Trajectories [#link("https://roboticsconference.org/program/papers/206/", "RSS 页面")]

MINT 在频域对动作块进行多尺度 Token 化，强制最粗层表示低频全局意图、细层表示高频执行细节。策略按尺度自回归地完成意图到执行的渐进推理，并可注入示教中的 Intent Token 实现一次示范迁移；基准和真实机器人实验显示其具备更高效率、抗扰性和环境适应能力。

=== 207. TAIL-Safe: Task-Agnostic Safety Monitoring for Imitation Learning Policies [#link("https://roboticsconference.org/program/papers/207/", "RSS 页面")]

TAIL-Safe 学习 Lipschitz 连续的 Q 函数，以可见性、可辨识性和可抓取性为任务无关指标定义状态--动作安全集。策略提出超出控制不变集的动作时，依据 Nagumo 定理沿 Q 梯度生成恢复动作；利用 Gaussian Splatting 数字孪生收集失败数据后，Franka 实验显示其能让受扰动易失败的 flow-matching 策略保持稳定成功。

=== 208. TMRL: Diffusion Timestep-Modulated Pretraining Enables Exploration for Efficient Policy Finetuning [#link("https://roboticsconference.org/program/papers/208/", "RSS 页面")]

TMRL 在预训练策略上下文中注入前向扩散噪声，把相近状态混合成可共享的探索模式；部署时由强化学习策略调节扩散时间步，在条件行为与更广泛的边际行为之间切换。导航和操作实验表明，该机制能突破基础策略原有分布，提升新任务微调的探索效率。

=== 209. Action-to-Action Flow Matching [#link("https://roboticsconference.org/program/papers/209/", "RSS 页面")]

A2A 用历史本体动作序列在高维潜空间中的表示初始化 flow matching，而非从无信息高斯噪声开始迭代去噪。这样既利用动力学连续性又显著降低延迟，单步推理可达 0.56 ms；实验显示训练更高效、对视觉扰动更稳健，并能泛化到未见配置，方法还被扩展到视频生成。

=== 210. LDA-1B: Scaling Latent Dynamics Action Model via Universal Embodied Data Ingestion [#link("https://roboticsconference.org/program/papers/210/", "RSS 页面")]

LDA-1B 以统一世界模型思路联合学习动力学、策略和视觉预测，将不同质量的人类与机器人数据分工使用。EI-30k 汇集超过 3 万小时轨迹；结构化 DINO 潜空间和混合频率多模态扩散 Transformer 支撑 10 亿参数训练。相较既有模型，在接触丰富、灵巧和长时序任务上最多提升 21%、48% 和 23%，并能从通常会被丢弃的低质量数据中继续获益。

== VLA Models

=== 81. X-DiffVLA: X-Embodied Diffusion Action Heads for Vision-Language-Action Models [#link("https://roboticsconference.org/program/papers/81/", "RSS 页面")]

X-DiffVLA 用统一扩散动作头处理共享底座、异构末端执行器的跨本体数据。Embodiment Forcing 以无分类器引导隐式注入本体功能差异，Morphological Tree Diffusion 则强化不同末端之间的行为相关性；RoboCasa、Isaac Gym 和真实评估均显示其跨夹爪到灵巧手的迁移能力，性能提升 15.3% 和 12.5%。

=== 82. SkillVLA: Tackling Combinatorial Diversity in Dual-Arm Manipulation via Skill Reuse [#link("https://roboticsconference.org/program/papers/82/", "RSS 页面")]

SkillVLA 显式建模双臂任务由左右单臂技能组合而来的组合多样性，使已学技能可以在新配对中复用，而不必枚举训练每种组合。实验显示技能组合成功率从 0 提升到 51%，并在协作和长时序双臂任务上保持较强表现。

=== 83. BagelVLA: Enhancing Long-Horizon Manipulation via Interleaved Vision-Language-Action Generation [#link("https://roboticsconference.org/program/papers/83/", "RSS 页面")]

BagelVLA 在单一模型中交错执行语言规划、视觉预测和动作生成，将文本推理与未来视觉状态直接放进行动循环。Residual Flow Guidance 从当前观测初始化并以单步去噪提取预测视觉特征，在多阶段仿真和真实任务中较现有基线显著提升，同时保持较低推理延迟。

=== 84. GuidedVLA: Specifying Task-Relevant Factors via Plug-and-Play Action Attention Specialization [#link("https://roboticsconference.org/program/papers/84/", "RSS 页面")]

GuidedVLA 将动作解码器拆成可监督的功能注意力头，分别学习物体定位、空间几何和时间技能逻辑，借助辅助信号抑制视觉捷径和环境噪声。仿真及真实实验中，显式因素引导同时改善分布内外成功率；因素质量与最终任务性能呈正相关。

=== 85. AR-VLA: Autoregressive Action Expert for Vision--Language--Action Models [#link("https://roboticsconference.org/program/papers/85/", "RSS 页面")]

AR-VLA 以独立自回归动作专家持续维护历史记忆，在可刷新视觉语言前缀条件下生成连续因果动作。重锚定机制补偿异步感知的陈旧性，使快速控制与慢速推理解耦；实验显示轨迹更平滑、历史感知更强，同时达到或超过反应式 VLA 的成功率。

=== 86. Towards Long-Lived Robots: Continual Learning VLA Models via Reinforcement Fine-Tuning [#link("https://roboticsconference.org/program/papers/86/", "RSS 页面")]

LifeLong-RFT 用无需在线环境反馈或预训练奖励模型的强化微调适配 VLA。多维过程奖励分别约束离散动作一致性、连续轨迹对齐和输出格式，并以动作块为粒度进行 on-policy 优化；LIBERO 持续学习中比 SFT 平均成功率高 22%，仅用 20% 数据即可适应新任务。

=== 87. π\*₀.₆: a VLA That Learns From Experience [#link("https://roboticsconference.org/program/papers/87/", "RSS 页面")]

RECAP 以优势条件化策略统一利用人类示教、策略 Rollout 和在线纠正等异构经验，在预训练和后训练阶段注入价值信息。π\*₀.₆ 已在真实家庭折衣、工厂装箱和咖啡制作中持续运行数小时；困难任务的吞吐量超过翻倍，失败率约减半。

=== 88. StereoVLA: Enhancing Vision-Language-Action Models with Stereo Vision [#link("https://roboticsconference.org/program/papers/88/", "RSS 页面")]

StereoVLA 用大规模合成双目数据训练 GeoSem 视觉编码器，从视差中提取几何信息，同时保留语言条件下的语义特征。交互区域深度估计和相机参数估计两个协同目标进一步对齐感知与动作坐标；真实实验性能提升 33.4%，并能泛化到近半球范围的相机视角。

=== 89. RLux-VLA: A Unified and Efficient Framework for Reinforcement Learning of Vision-Language-Action Models [#link("https://roboticsconference.org/program/papers/89/", "RSS 页面")]

RLux-VLA 提供统一接口，将多种 VLA 架构、强化学习算法和仿真器接入可扩展训练流水线，并为渲染、推理和训练灵活分配资源。GPU 并行仿真采用混合细粒度流水线后训练速度提升 1.61--1.88 倍；在 LIBERO、ManiSkill、RoboTwin 等基准上，模型性能稳定提升约 20--85%，同时总结了 VLA 强化训练的实践配方。


这两个 Session 共同体现出导航研究从“输出下一步速度”转向显式建模语义目标、动态风险、运动动力学与长时序信用分配。另一条线索是把探索本身视为信息获取或覆盖优化问题，让机器人主动决定去哪里、以何种速度和风险前进。

== Navigation 1

=== 63. MVP-Nav: Multi-layer Value Map Planner Navigator [#link("https://roboticsconference.org/program/papers/63/", "RSS 页面")]

MVP-Nav 面向只使用 RGB 的零样本物体目标导航，将高层语义推理与低层几何执行分开。3D 基础模型从单目观测恢复实例的物理尺度和占据范围，以定向包围盒维护动态空间语义列表；多层 Value Map 再让多模态大模型分配语义权重和导航模式，底层控制器在融合物理约束的代价空间中规划路径。作者报告该方法在无深度方法中取得较强成功率和探索效率，并超过部分深度基线。核心收益来自显式空间记忆，但 3D 恢复错误会直接影响语义目标与几何路径的一致性。

=== 64. Self-Supervised Bootstrapping of Action-Predictive Embodied Reasoning [#link("https://roboticsconference.org/program/papers/64/", "RSS 页面")]

R&B-EnCoRe 认为固定的具身 Chain-of-Thought 模板会迫使策略处理与动作无关的推理原语，因此把推理视作重要性加权变分推断中的潜变量。模型从互联网规模知识中自监督地产生并蒸馏面向具体本体的推理数据，不需要外部奖励、验证器或人工标注。作者在机械臂、腿式导航和自动驾驶等多种本体及不同规模 VLA 上报告了操作成功率、导航得分和碰撞率改善。该路线把“推理质量”定义为对控制结果的预测能力，而不是文本形式的完整性。

=== 65. D-Nav: End-to-End Dynamic UAV Navigation with Dual-Resolution Motion Awareness [#link("https://roboticsconference.org/program/papers/65/", "RSS 页面")]

D-Nav 直接将原始 LiDAR 映射为动态环境中的无人机控制动作。策略先从连续扫描构造球面时空深度表示，捕捉大尺度场景结构和运动趋势，再根据显著性挑出危险区域，提取小尺度、快速运动障碍的细粒度几何与速度信息；任务感知的航点条件则平衡避碰和穿越关键区域。复杂动态仿真中的成功率由 0.37 提升到 0.56，真实实验验证了实时性。双分辨率结构改善了不同尺度障碍的兼顾，但端到端控制的安全解释性仍弱于显式碰撞约束。

=== 66. Learning When to Jump for Off-road Navigation [#link("https://roboticsconference.org/program/papers/66/", "RSS 页面")]

本文指出越野导航中低速并不总是安全，例如跨越沟渠时需要受控加速跳跃才能避免卡住。Motion-aware Traversability 将每个地形区域的可通行性建模为随速度变化的 Gaussian，而不是单一标量；在线阶段只需预测一次 Gaussian 参数，再根据当前动力学快速评估新的速度代价。仿真和真实越野实验显示，该表示在保持安全的同时将路径绕行减少 75%。它把运动动力学纳入地形表示，代价是需要对速度相关代价的形状作足够可靠的估计。

=== 67. OpenFrontier: General Navigation with Visual-Language Grounded Frontiers [#link("https://roboticsconference.org/program/papers/67/", "RSS 页面")]

OpenFrontier 将开放世界导航重写为稀疏子目标识别与到达问题，用导航 Frontier 作为视觉语言先验的语义锚点。系统不需要稠密三维地图、策略训练或任务特定微调，而是组合已有视觉语言模型来选择和到达语义 Frontier。多项导航基准和真实移动机器人实验显示了较强零样本表现。方法结构简洁，主要限制在于 Frontier 质量和高层语义模型的空间定位误差会共同决定最终路径。

=== 68. LongNav-R1: Horizon-Adaptive Multi-Turn RL for Long-Horizon VLA Navigation [#link("https://roboticsconference.org/program/papers/68/", "RSS 页面")]

LongNav-R1 将导航决策从单轮预测改成 VLA 策略与环境之间的连续多轮交互，使模型能够根据历史动作的因果后果和未来序列结果学习。Horizon-Adaptive Policy Optimization 针对不同轨迹长度调整优势估计，改善长序列的时间信用分配并抑制策略坍缩。作者用 4,000 条 Rollout 将 Qwen3-VL-2B 的成功率从 64.3% 提升到 73.0%，并验证了真实长时序导航的零样本表现。多轮 RL 提高了策略自由度，但训练稳定性和在线交互成本仍是关键约束。

=== 69. SanD-Planner: Sample-Efficient Diffusion Planner in B-Spline Space for Robust Local Navigation [#link("https://roboticsconference.org/program/papers/69/", "RSS 页面")]

SanD-Planner 在紧支撑 B-spline 空间中进行基于深度图的 Diffusion 模仿学习。紧凑参数化天然产生平滑轨迹，并限制局部预测误差，适合 Receding-horizon 执行；ESDF 安全检查器提供显式间隙和完成时间指标，免去额外训练 Value Function 判断可行性。仅用基线示教规模 0.25% 的 500 个 Episode，系统在模拟拥挤环境中达到 90.1% 成功率，并在室内场景零样本迁移。其优势是样本效率与轨迹先验结合，但 B-spline 表达能力可能限制急转或非平滑动作。

=== 70. TravSUITE: Traversability via Self-Supervised, Uncertainty-Aware IRL and Terrain Estimation [#link("https://roboticsconference.org/program/papers/70/", "RSS 页面")]

TravSUITE 用视觉基础模型驱动的体素 Mapper 构建几何--语义局部地图，再由统一网络在鸟瞰图中联合预测几何、语义、速度和代价等可通行性量。训练完全自监督，结合地图修补和逆强化学习，同时在部署时用不确定性做风险调整。消融显示，代价学习与修补任务都对规划有贡献，二者结合在真实硬件上可减少 80% 导航错误并提高自主 traversal 速度。方法将地图质量和代价学习统一起来，但复杂地形中的不确定性校准仍需长期验证。

=== 71. HumanFlow: Diffusion-Driven MAV Navigation Among Humans via Tightly-Coupled Motion Tracking, Forecasting, and Control [#link("https://roboticsconference.org/program/papers/71/", "RSS 页面")]

HumanFlow 用带三维场景条件的潜空间 Diffusion Model 联合进行人体运动跟踪与预测，针对遮挡和部分可见情况生成平滑、符合环境的未来轨迹。预测潜变量进一步作为 Flow Matching 近似 MPC 的条件，直接用于微型飞行器在人群中的社会导航。仿真中使用真实人类轨迹验证了部分可观测条件下的无碰撞导航。其贡献在于把感知预测和控制耦合到同一潜空间，风险是人体行为分布外变化会同时影响预测和控制。

== Navigation 2

=== 130. Galilean State Estimation for Inertial Navigation Systems with Unknown Time Delay [#link("https://roboticsconference.org/program/papers/130/", "RSS 页面")]

本文处理 GNSS 测量存在未知 50--300 ms 延迟时的惯性导航估计问题。作者利用 Galilean 对称性建立空间与时间的联合表示，并推导同时估计导航状态和时间延迟的 Equivariant Filter。两架固定翼无人机实验以及最高 500 ms 延迟的仿真显示，该方法保持了精度和一致性，而显式把延迟作为状态的 EKF 随延迟增大而失去一致性。它提供了几何上统一的延迟建模方式，适用于需要严格状态一致性的飞行系统。

=== 131. Learning to Localize Reference Trajectories in Image-Space for Visual Navigation [#link("https://roboticsconference.org/program/papers/131/", "RSS 页面")]

LoTIS 不预测绑定某一机器人的动作，而是在当前相机视野中定位一条参考 RGB 轨迹将出现的图像坐标，不需要相机标定、位姿或机器人专属训练。将感知与动作解耦后，图像空间轨迹点可作为不同本体的通用视觉指引，并直接交给局部规划器。作者报告前向导航成功率相比基线提高 20--50 个百分点，与局部规划器结合后在多种仿真和真实环境达到 94--98%，对反向行驶等困难任务也有明显收益。方法的可迁移性依赖参考视频与当前视角之间存在足够的视觉对应关系。

=== 132. Beyond Isolation: A Unified Benchmark for General-Purpose Navigation [#link("https://roboticsconference.org/program/papers/132/", "RSS 页面")]

OmniNavBench 试图解决导航基准将技能、本体和传感器割裂的问题。它把 PointNav、视觉语言导航、ObjectNav、SocialNav、跟随人和问答六类子任务组合到一个 Episode 中，提供可切换传感器接口，并用人形、四足和轮式机器人测试跨本体泛化。基准包含 170 个混合合成与真实扫描环境，以及 1,769 条人类遥操作轨迹，保留探索性观察和预判避让等行为细节。评测显示现有统一策略难以处理交错任务，说明“单任务高分”与通用导航之间仍有显著差距。

=== 133. Seeing Danger Before Moving: Learning Environment-Centric Risk for Safe Robot Navigation [#link("https://roboticsconference.org/program/papers/133/", "RSS 页面")]

本文从环境本身感知危险，而不等机器人进入危险区域后再依赖反应式避障。多模态时空模型融合环境摄像头与传感器数据，输出概率风险；Bayesian Filter 将风险视为随时间变化的潜在状态，过滤短暂扰动和噪声，最后把风险信念作为导航代价引导规划器提前绕行。物理多危险测试场包含烟雾、热、水、振动和结构障碍，实验显示风险感知策略能减少危险暴露。方法把环境监测引入导航，但需要可靠的外部传感器覆盖与风险先验。

=== 134. Adaptive Smooth Tchebycheff Attention for Multi-Objective Policy Optimization [#link("https://roboticsconference.org/program/papers/134/", "RSS 页面")]

本文研究机器人多目标 RL 中非凸 Pareto 前沿难以优化的问题。线性标量化稳定但无法获得非凸区域，固定 Tchebycheff 标量化虽有理论能力，却常因梯度方差和冲突而不稳定。Adaptive Smooth Tchebycheff 根据实时梯度干扰动态调节优化曲率：目标一致时逐渐接近精确的非线性标量化，冲突出现时退回平滑稳定的近似。受保护生态监测的隐蔽视觉搜索实验显示，该机制能找到线性方法无法到达、固定非线性方法难以稳定训练的策略。

=== 135. Learning Agile Quadrotor Flight in the Real World [#link("https://roboticsconference.org/program/papers/135/", "RSS 页面")]

本文不依赖精确系统辨识或离线 Sim-to-Real，而在真实飞行中在线适应。Adaptive Temporal Scaling 主动探索飞行器的物理极限，在线残差学习修正简单名义模型，再用 RASH-BPTT 在短时域内更新飞行策略。四旋翼能在约 100 秒飞行中将保守基线峰值速度从 1.9 m/s 提升到 7.3 m/s，并接近执行器饱和边界完成敏捷动作。该结果说明在线适应不仅能补偿建模误差，也能用于逐步释放性能；安全探索策略是部署前提。

=== 136. Asymptotically Optimal Ergodic Coverage on Generalized Motion Fields [#link("https://roboticsconference.org/program/papers/136/", "RSS 页面")]

本文将流场随时间变化、且机器人受动力学和欠驱动约束的探索问题表述为动态域上的遍历覆盖。作者扩展基于最大均值差异的遍历度量，把环境流动和域演化直接纳入覆盖目标，从而在开环规划中仍能利用环境动力学。海洋探索、人和牛群运动跟踪，以及空中和腿式机器人实验验证了非凸、受流场限制环境中的覆盖效果。方法提供了渐近意义上的覆盖保证，但实际环境模型误差会影响保证的有效性。

=== 137. Learning What Matters: Adaptive Information Theoretic Objectives for Robot Exploration [#link("https://roboticsconference.org/program/papers/137/", "RSS 页面")]

QOED 用最优实验设计构造更贴近参数可辨识性的探索目标。它先分析 Fisher 信息矩阵的特征子空间，识别可观测和可辨识参数方向，再抑制不可辨识参数带来的干扰；在有界干扰与有限耦合条件下，作者给出相对理想信息目标的常数因子近似。导航和操作的仿真、真实实验中，辨识方向选择和干扰抑制分别带来 35.23% 与 21.98% 的性能改善。它把“收集更多信息”具体化为“收集对模型真正可辨识的信息”。

=== 138. Learning Point Cloud Geometry as a Statistical Manifold: Theory and Practice [#link("https://roboticsconference.org/program/papers/138/", "RSS 页面")]

POLI 将稀疏、非均匀点云的局部几何建模为由 Gaussian 分布族诱导的统计流形，并为每个点预测表示局部几何的 Gaussian。该估计器通过自监督学习得到，不依赖精确标注，同时保留明确的几何归纳偏置；生成的 Point-to-Ellipsoid 表示可以直接接入既有定位、建图和姿态估计 Pipeline。广泛实验显示它能稳定改善多种机器人感知任务。理论表示带来统一接口，但 Gaussian 局部模型对尖锐边界、遮挡和多尺度结构的表达能力需要结合具体任务判断。


这两个 Session 的共同方向是让感知系统在动态、稀疏、传感器退化和物理交互环境中保持可用。论文一方面改进表示与融合，另一方面把不确定性、物理约束和可证明保证直接纳入系统。

== Localization & Mapping

=== 45. TACO: Temporal Consensus Optimization for Continual Neural Mapping [#link("https://roboticsconference.org/program/papers/45/", "RSS 页面")]

TACO 将持续神经建图重写为时间共识优化：把过去的模型快照当作时间邻居，用加权共识约束当前地图。可靠的历史几何可以稳定当前优化，过时或不可靠区域则允许被新观测修正，因此不需要保存或回放历史数据。仿真和真实实验显示，它在场景变化下比既有持续学习基线更稳健。方法在内存效率与适应性之间取得平衡，但快照本身仍可能携带长期错误。

=== 46. Dr-BA: Separable Optimization for Direct Radar Bundle Adjustment & Localization [#link("https://roboticsconference.org/program/papers/46/", "RSS 页面")]

Dr-BA 直接在二维旋转雷达强度图上进行 Bundle Adjustment，不再把雷达回波压缩成稀疏点云。可分离优化将位姿估计与地图构建解耦，同时支持在已有地图中的纯雷达定位。五条路线、超过 200 km 的道路数据表明，它取得了较强的雷达 BA 与跨 Session 定位结果。全回波建模增强了雨雪条件下的鲁棒性，但计算量和雷达外观随环境变化的稳定性需要工程权衡。

=== 47. Efficient Feature-Free Initialization for Monocular Visual-Inertial Systems Using A Feed-Forward 3D Model [#link("https://roboticsconference.org/program/papers/47/", "RSS 页面")]

本文用前馈三维模型预测的按尺度点云替代视觉特征匹配，构造无特征的单目视觉惯性初始化。这样不需要跟踪特征或估计复杂的初始对应关系；公开数据集上的成功率超过 90%，所需传感器时长通常降至 1.2 s 以下，并在视觉退化场景中更稳健。系统把高层三维先验用于初始化而非完整 SLAM，主要依赖前馈模型对场景尺度和几何的泛化。

=== 48. UP-Fuse: Uncertainty-guided LiDAR-Camera Fusion for 3D Panoptic Segmentation [#link("https://roboticsconference.org/program/papers/48/", "RSS 页面")]

UP-Fuse 在共享 Range View 中融合 LiDAR 与相机特征，并预测视觉退化造成的不确定性图，动态调节跨模态信息流。混合二维--三维 Transformer 负责消除投影歧义并输出三维全景分割。Panoptic nuScenes、SemanticKITTI 和 Panoptic Waymo 实验表明，即使相机严重损坏、标定漂移或失效，系统仍能保持较强性能。显式可靠性估计比无条件融合更适合安全关键场景，但不确定性模型本身也需要覆盖真实退化模式。

=== 49. BIEVR-LIO: Robust LiDAR-Inertial Odometry through Bump-Image-Enhanced Voxel Maps [#link("https://roboticsconference.org/program/papers/49/", "RSS 页面")]

BIEVR-LIO 用体素级定向高度图保存细粒度表面几何，可直接用于配准而不必先计算中间几何基元。地图驱动的点采样进一步将计算集中到几何信息丰富的区域，在缺少约束的环境中提升鲁棒性并降低开销。多传感器、多平台评测显示，在基线容易发散的场景中改进明显；这些细粒度几何还可用于机器人行走的高程图生成。主要代价是高分辨率表示的内存和更新成本。

=== 50. Continuum Robot Localization using Distributed Time-of-Flight Sensors [#link("https://roboticsconference.org/program/papers/50/", "RSS 页面")]

连续体机器人难以安装大体积高分辨率 LiDAR，且本体变形使定位更加困难。本文沿机器人长度分布多个低分辨率 ToF 传感器，并把测量与形状先验融合，即使单个传感器频繁处于退化状态也能估计全局位姿。53 cm 机器人在仿真和真实多环境中平均位置误差为 2.5 cm、旋转误差为 7.2 度。方法把传感器数量与形状先验结合起来，但先验偏差会直接影响定位结果。

=== 51. VGGT-SLAM 2.0: Real-time Dense Feed-forward Scene Reconstruction [#link("https://roboticsconference.org/program/papers/51/", "RSS 页面")]

VGGT-SLAM 2.0 重新设计因子图，消除原系统中的高维漂移和平面退化，同时处理未知相机内参导致的重建歧义。作者还发现 VGGT 的某层注意力可免费用于图像检索验证，既拒绝错误回环，也增加有效回环数量。系统能在 Jetson Thor 上实时运行，并可扩展到开放集物体检测；TUM 数据集位姿误差比上一版约低 23%。它展示了如何从前馈三维模型内部结构中挖掘 SLAM 信号，但模型推理开销仍是部署约束。

=== 52. SuperMap: A Spatio-Temporal SLAM System for Visual-Language Navigation [#link("https://roboticsconference.org/program/papers/52/", "RSS 页面")]

SuperMap 用高频几何 SLAM 与异步开放词汇感知构建四维时空地图。系统通过三维实例关联和重新激活维护稳定的物体身份，再以存在概率和标签置信度更新处理遮挡、出现、消失与搬移，最终形成可被视觉语言模型查询的场景图。动态场景和真实机器人实验验证了其组合语义查询能力。它解决了开放词汇标签漂移问题，但长期维护仍依赖实例关联和置信度更新的校准。

=== 53. Provably Guaranteed Polytopic Uncertainty Quantification for SLAM [#link("https://roboticsconference.org/program/papers/53/", "RSS 页面")]

本文为三维地标 SLAM 提供带确定性包含保证的不确定性量化。前向 UQ、后向 UQ 和位姿组合三个模块分别产生多面体不确定集合；当输入边界确定时，输出集合可证明包含真实位姿和地标。Conformal Prediction 被用于从数据校准测量不确定性，使理论保证更接近实际。多面体表示便于统一处理位姿不确定性，但集合传播的计算开销仍需与实时系统预算匹配。

== Perception and Estimation

=== 166. FreeOcc: Training-Free Embodied Open-Vocabulary Occupancy Prediction [#link("https://roboticsconference.org/program/papers/166/", "RSS 页面")]

FreeOcc 完全不依赖三维标注、位姿真值或训练阶段，从单目或 RGB-D 序列构建开放词汇占据图。系统以 SLAM 估计位姿和稀疏几何，用 Gaussian 更新生成稠密三维地图，再关联视觉语言语义并投影为体素占据。作者报告在 EmbodiedOcc-ScanNet 上相对自监督基线 IoU 和 mIoU 超过两倍，并发布 ReplicaOcc 基准。训练自由换来了跨环境便利，但结果仍受 SLAM 和预训练视觉语言模型质量限制。

=== 167. More with LESS – Local Scene Representations for Tactile Imaging [#link("https://roboticsconference.org/program/papers/167/", "RSS 页面")]

LESS 针对触觉成像中的局部接触性质，使用带局部感受野的循环编码器网格表示触觉场景，再融合各局部状态重建软物体内部的二维或三维结构。单夹杂物幻影上训练的模型可以成像多个夹杂物和不同尺寸，并给出空间不确定性。系统还支持外部位姿跟踪下的手持式触觉成像和完整三维重建。局部组合表示提高了泛化性，但要求触摸轨迹覆盖足够的局部结构。

=== 168. AnyAmber: A Generalist for Versatile Anonymous Bearing and Range Based Position Tracking [#link("https://roboticsconference.org/program/papers/168/", "RSS 页面")]

AnyAmber 将不同机器人数量、锚点配置、UWB 标签布局和匿名视觉观测统一为一个定位问题。异构 EGAT 网络联合估计位置与不确定性，级联可微分层 PGO 提升精度，同时用 Embedded-GRU 修正 UWB 偏差、用时序图匹配处理匿名 bearing 分配。模型在大规模仿真与真实多任务数据上联合预训练，目标场景只需一条轨迹微调即可取得较强少样本定位效果。统一建模降低了特例 Solver 的数量，但泛化依赖训练分布的几何覆盖。

=== 169. Anticipatory Motion Suppression in Event-Based Cameras [#link("https://roboticsconference.org/program/papers/169/", "RSS 页面")]

本文让事件相机提前抑制由自运动和独立运动物体产生的干扰事件。轻量模型在当前事件流中分割动态物体并预测其未来运动，在事件到达前过滤潜在干扰；消费级 GPU 上达到 173 Hz、内存低于 1 GB。EVIMO 上分割精度提升 67%，并通过 Token Pruning 加速 Vision Transformer、改善事件视觉里程计。预测式抑制比事后滤波更及时，但对突然改变运动的物体可能出现过抑制或漏抑制。

=== 170. From Local Matches to Global Masks: Template-Guided Instance Detection and Segmentation in Open-World Scenes [#link("https://roboticsconference.org/program/papers/170/", "RSS 页面")]

L2G-Det 用模板图像与查询图像之间的稠密 Patch 匹配绕开脆弱的目标 Proposal。局部匹配生成候选点，经筛选抑制误匹配后，再以实例 Token 提示增强版 Segment Anything Model，恢复被遮挡或杂乱背景中的完整实例掩码。开放世界实验显示其优于 Proposal-based 基线。局部到全局的结构减少了 Proposal 质量的影响，但模板外观与目标实例差异过大时仍可能缺乏稳定对应。

=== 171. TE-SDF: Tetra-Encoded Signed Distance Field for Memory-Efficient and Accurate Collision Detection [#link("https://roboticsconference.org/program/papers/171/", "RSS 页面")]

TE-SDF 将四面体网格的自适应空间划分与局部精确距离计算结合起来：每个四面体只编码一组候选表面面片，便能在有限存储下评估 SDF。作者据此实现全 GPU 碰撞检测器并接入 GPU 仿真框架，在内存效率、准确性和可扩展性之间取得平衡。它直接扩大了接触丰富仿真可处理的场景范围，但四面体网格质量仍会影响距离误差和构建成本。

=== 172. Seeing is Believing: Certified Perception-Based Control from Learned Visual Representations via System Level Synthesis [#link("https://roboticsconference.org/program/papers/172/", "RSS 页面")]

本文从高分辨率 RGB 图像学习低维观测映射，并为其误差建立状态相关边界，再用 System Level Synthesis 优化因果时变输出反馈控制器。序列凸优化使该非凸问题可计算，同时保留部分可观测、噪声和非线性动力学下的约束保证。汽车、四旋翼、人形和真实地面车实验中均未观察到约束违反，并展现了主动收集信息降低不确定性的行为。该工作把视觉表征与鲁棒控制保证连接起来，难点是误差边界的可信校准。

=== 173. Picasso: Holistic Scene Reconstruction with Physics-Constrained Sampling [#link("https://roboticsconference.org/program/papers/173/", "RSS 页面")]

Picasso 认为仅拟合传感器数据的重建可能产生物理不合理的物体穿插或不稳定平衡，因此在多物体场景中联合考虑几何、非穿透和物理可行性。系统从推断的物体接触图出发，用快速拒绝采样生成满足约束的形状与位姿，并发布包含 10 个接触丰富真实场景的 Picasso 数据集及物理合理性指标。新数据集和 YCB-V 实验显示，重建更符合物理与人类直觉。物理约束提高了数字孪生质量，但搜索空间随物体数量和接触关系快速增长。

=== 174. Simulation-Ready Cluttered Scene Estimation via Physics-aware Joint Shape and Pose Optimization [#link("https://roboticsconference.org/program/papers/174/", "RSS 页面")]

本文以可微接触模型为基础，在杂乱场景中联合优化多个刚体的形状和位姿。增强 Lagrangian Hessian 的结构稀疏性被用于构造随场景复杂度良好扩展的线性求解器，完整 Pipeline 还结合学习式初始化和可微纹理细化。最多五个物体、22 个凸包的实验显示，系统能恢复物理有效、可直接用于仿真的场景。该方法将几何估计与接触约束统一起来，但可微形状模型和初始化质量仍会影响收敛。

=== 175. Viser: Imperative, Web-based 3D Visualization for Python [#link("https://roboticsconference.org/program/papers/175/", "RSS 页面")]

Viser 是面向机器人学和计算机视觉的 Python 三维可视化工具包，提供可独立使用或组合的三维场景和二维 GUI 原语。其命令式 API 与 Web Viewer 适配现代 Python 工作流，并降低构建定制调试界面的门槛。论文讨论了系统架构、采用情况与局限。它不是新的感知算法，却补足了研究系统中“看见状态、交互调参和复现实验”的工程基础设施。

=== 176. Motion-Uncertainty-Aware Next-Best-View Planning for Moving Object Reconstruction [#link("https://roboticsconference.org/program/papers/176/", "RSS 页面")]

本文针对移动物体重建中的 Next-Best-View 规划，显式考虑从决策到执行延迟期间的物体运动。系统用固定滞后 Gaussian Process Smoother 维护平面位置和速度信念，预测未来相机--物体配置，再以可达性筛选候选视角，并通过 Monte Carlo 估计预期覆盖增益。仿真和真实实验显示，相比只跟踪或假设静态物体的基线，预测式视角选择能改善表面覆盖和重建完整度。方法适用于平面运动，向复杂六自由度动态物体扩展仍需新的运动模型。

=== 177. Relaxation-Aware Multimodal Sensing of Soft Gripper Driven by Structure-Perception-Learning [#link("https://roboticsconference.org/program/papers/177/", "RSS 页面")]

该工作针对软体材料的黏弹性应力松弛导致抓取力持续衰减的问题，设计了可变刚度软夹爪，并用视觉与红外热成像连续观测形变和温度。温度耦合的黏弹性力表示与物理启发学习模型预测力趋势，再在保持任务中进行显式补偿。280 s 力控制抓取实验的平均绝对误差为 0.066 N，相比固定开口和瞬时观测基线分别改善 80% 和 95%。它展示了机构、感知和学习协同设计的价值，但长期材料老化和温度变化仍需评估。

=== 178. CoCo-InEKF: State Estimation with Learned Contact Covariances in Dynamic, Contact-Rich Scenarios [#link("https://roboticsconference.org/program/papers/178/", "RSS 页面")]

CoCo-InEKF 用连续的接触速度协方差替代二值接触状态，让不变扩展 Kalman Filter 能表达牢固接触、方向性滑移和无接触之间的连续置信度。轻量网络端到端预测候选接触点的协方差，不需要启发式接触标签；自动候选点选择也降低了点位放置敏感性。双足机器人实验改善了线速度估计，并支持舞蹈和复杂地面交互。学习协方差提供了更丰富的不确定性接口，但训练数据覆盖不足时可能产生过度自信。


== Humanoids

这一组工作围绕人形机器人的动态运动、全身交互、感知导航与可泛化控制展开。共同趋势是把运动先验、物理约束和分层策略结合起来，以缩小从仿真到真实硬件的差距。

=== 19. HUSKY: Humanoid Skateboarding System via Physics-Aware Whole-Body Control [#link("https://roboticsconference.org/program/papers/19/", "RSS 页面")]

HUSKY 将人形滑板视为带非完整约束的混合接触系统，显式建模滑板倾角与转向架角度的耦合关系。系统用对抗运动先验学习类人的蹬行动作，再用物理引导的朝向策略实现“倾身转向”，并以轨迹引导平滑切换蹬行和转向。Unitree G1 实验表明，该方法能在真实滑板上完成稳定而敏捷的动态机动；对接触参数和硬件摩擦的依赖仍是部署难点。

=== 20. Perceptive Humanoid Parkour: Chaining Dynamic Human Skills via Motion Matching [#link("https://roboticsconference.org/program/papers/20/", "RSS 页面")]

PHP 用特征空间中的近邻运动匹配，把重定向的人类原子技能组合成长期跑酷轨迹，再训练运动跟踪 RL 专家并通过 DAgger 与 RL 蒸馏为单一深度视觉策略。机器人仅凭机载深度和离散二维速度指令，就能根据障碍物选择跨越、攀爬、跳跃或滚落。Unitree G1 可攀越最高 1.25 米障碍，并在多障碍路线中闭环适应扰动；技能库覆盖范围和重定向误差会限制泛化。

=== 21. Ψ₀: An Open Foundation Model Towards Universal Humanoid Loco-Manipulation [#link("https://roboticsconference.org/program/papers/21/", "RSS 页面")]

Ψ₀ 不直接混合人类与人形数据，而是采用分阶段训练：先用大规模第一视角人类视频自回归预训练 VLM，再用高质量真实人形轨迹后训练基于 Flow 的动作专家。作者发现，高质量人类操作视频加少量本体特定机器人数据，比噪声互联网视频或跨本体数据更有效；约 800 小时人类视频和 30 小时机器人数据在多任务上超过使用十倍数据的基线，整体成功率提升超过 40%。模型、数据处理和实时推理引擎计划开源，但其性能依赖高质量第一视角数据与特定人形本体。

=== 22. X-Loco: Towards Generalist Humanoid Locomotion Control via Synergetic Policy Distillation [#link("https://roboticsconference.org/program/papers/22/", "RSS 页面")]

X-Loco 先训练多个具有特权信息的专家策略，再用按场景自适应的专家选择机制协同蒸馏出仅依赖视觉的通用学生策略。一个策略可在速度指令下统一处理直立行走、地形穿越、全身协调与跌倒恢复，不需要参考动作。仿真与消融实验显示，专家互补性提升了学习效率和综合性能；学生策略仍可能继承专家覆盖不足的失效区域。

=== 23. Learning to Evolve: Multi-modal Interactive Fields for Robust Humanoid Navigation in Dynamic Environments [#link("https://roboticsconference.org/program/papers/23/", "RSS 页面")]

MIF 针对人形行走造成的感知抖动和环境变化导致的地图失配，构建三个协同场：置信度门控的去噪外观场、用于语义推理的层次空间场，以及通过 Flow Matching 重建高保真网格的几何场。交互与适应闭环根据多模态差异分数区分传感器噪声和物体真实位移，触发局部记忆更新并进行交互姿态安全检查。Unitree G1 在动态搬移场景中的成功率由 12% 提升到 94%，语义记忆占用减少 91.4%；系统需要稳定的三维重建和差异阈值设定。

=== 24. MOBIUS: A Multi-Modal Bipedal Robot that can Walk, Crawl, Climb, and Roll [#link("https://roboticsconference.org/program/papers/24/", "RSS 页面")]

MOBIUS 是无需机构重构即可行走、爬行、攀爬和滚动的四肢双足平台，配备两条六自由度机械臂与两条四自由度腿。架构将 RL 用于 locomotion，将带参考调节器和自动调参的导纳控制用于安全柔顺接触，并由高层混合整数二次约束规划器按稳定性和能耗选择运动模式。硬件实验展示了步态切换、动态攀爬和捏持支撑；平台复杂度和模式规划成本是进一步扩展的代价。

=== 25. TeleGate: Whole-Body Humanoid Teleoperation via Gated Expert Selection with Motion Prior [#link("https://roboticsconference.org/program/papers/25/", "RSS 页面")]

TeleGate 保留多个领域专家的完整能力，不将其强行蒸馏为单一策略，而是训练轻量门控网络依据本体状态和参考轨迹实时选择专家。针对在线遥操作缺少未来参考的问题，VAE 运动先验从历史观测推断隐含动作意图，为跳跃和起身等需要预见性的动作提供前馈控制。仅用 2.5 小时动作捕捉数据，系统就在 G1 上实现奔跑、跌倒恢复和跳跃的高精度跟踪；门控切换和动作分布外情况仍需额外鲁棒性机制。

=== 26. Generalizing from References using a Multi-Task Reference and Goal-Driven RL Framework [#link("https://roboticsconference.org/program/papers/26/", "RSS 页面")]

本文把参考动作当作训练期行为先验，而非部署时必须遵循的轨迹约束。一个目标条件策略同时优化参考引导的模仿任务和独立目标驱动的成功任务：前者提供稠密模仿奖励但不把参考输入策略，后者只根据任务结果奖励。该联合目标在箱体跑酷环境中保持自然运动，并能适应未见初始状态和目标，进一步组合成长时序技能；训练仍需精心平衡模仿与任务奖励。

=== 27. Now You See That: Learning End-to-End Humanoid Locomotion from Raw Pixels [#link("https://roboticsconference.org/program/papers/27/", "RSS 页面")]

该工作从原始深度图端到端学习人形 locomotion，首先在仿真中重现立体匹配伪影和标定不确定性，再通过潜空间对齐与噪声不变辅助任务，将特权高度图策略蒸馏到真实深度观测。针对多地形冲突，训练中加入地形专属奖励、多评论家和多判别器，使网络学习各类动力学与运动先验。两种立体相机的人形平台都能处理高台、宽沟和双向长楼梯；高保真传感器仿真是迁移效果的关键前提。

=== 28. Mind Your Steps: A General Learning Framework for Accurate Humanoid Foothold Tracking [#link("https://roboticsconference.org/program/papers/28/", "RSS 页面")]

本文提出轻量的三维落脚点跟踪策略，直接以目标足部位姿为命令，并通过动态目标采样让策略与具体地形和下游任务解耦。新的目标表示显式处理真实部署中的位姿噪声和足部接触估计误差，使策略可作为独立低层控制器连接不同的高层落脚点生成器。仿真和真实实验均显示了准确、自然的定位能力；上游规划器的目标质量仍决定最终导航性能。

=== 29. PRIME: Physically-consistent Robotic Inertial and Motion Estimation for Legged and Humanoid Robots [#link("https://roboticsconference.org/program/papers/29/", "RSS 页面")]

PRIME 将本体运动、执行器指令和接触动力学置于最大后验优化中，同时修正运动轨迹、估计摩擦接触力并辨识物理一致的惯性参数。可微接触动力学、平滑互补约束和 Anitescu 摩擦模型使优化在接触切换处保持稳定。四足和 Unitree G1 的接触丰富运动实验显示，轨迹一致性与惯性辨识均得到改善，并可生成带接触与受力标注的真实运动数据；优化成本和接触模型精度限制实时应用。

=== 30. HiWET: Hierarchical World-Frame End-Effector Tracking for Long-Horizon Humanoid Loco-Manipulation [#link("https://roboticsconference.org/program/papers/30/", "RSS 页面")]

HiWET 将人形 loco-manipulation 重写为世界坐标系末端跟踪，以消除腿式运动累积的机身坐标漂移。高层策略联合规划末端和基座子目标，低层策略在稳定性约束下执行；运动学流形先验通过残差动作嵌入可行操作空间，降低探索维度。仿真中长期跟踪更精确稳定，低层策略还在真实人形上实现零样本 sim-to-real；高层子目标规划尚需覆盖更复杂接触任务。

=== 31. OmniXtreme: Breaking the Generality Barrier in High-Dynamic Humanoid Control [#link("https://roboticsconference.org/program/papers/31/", "RSS 页面")]

OmniXtreme 将通用运动技能学习与真实执行器适配解耦，以解决运动库扩大后跟踪精度下降的问题。高容量 Flow Matching 策略承担多动作表示学习，避免多运动 RL 优化中的相互干扰；随后执行器感知的精炼阶段针对硬件限制提升可执行性。实验表明，统一策略可在多种高难度数据集和真实机器人上保持高保真极限动作跟踪；精炼过程需要面向具体硬件重新训练。

== Control & Dynamics

该 Session 关注高维强化学习、鲁棒与安全 MPC、可微动力学及真实执行器约束。多篇工作把求解器和控制器推进到 GPU 或嵌入式平台，同时显式处理接触、摩擦和不确定性。

=== 99. FlashSAC: Fast and Stable Off-Policy Reinforcement Learning for High-Dimensional Robot Control [#link("https://roboticsconference.org/program/papers/99/", "RSS 页面")]

FlashSAC 通过显式限制权重、特征和梯度范数，抑制高维控制中批评家误差在自举更新中的放大，并用大规模并行仿真、高容量回放池和强探索扩大数据覆盖。它保留离策略方法的样本效率，同时改善训练稳定性；在十个模拟器的五十多个状态和视觉任务中超过 PPO 及其他离策略基线。人形行走 sim-to-real 的训练由数小时缩短到数分钟；稳定性依赖较大的仿真与回放资源。

=== 100. Realizing Robotic Swimming with Unified Fluid-Robot Multiphysics [#link("https://roboticsconference.org/program/papers/100/", "RSS 页面")]

本文从单一最小作用量拉格朗日量联合推导机械臂与不可压 Navier–Stokes 方程，构建可微流体—机器人多物理仿真器。离散变分力学提供稳定且物理一致的积分方案，隐函数定理则给出耦合动力学梯度。借此优化仿生鳗鱼的摆动步态和高动态 C 形逃逸动作，并在实体硬件上验证 sim-to-real；计算规模和流体边界建模仍是主要瓶颈。

=== 101. Grounding Discrete-Time Joint-Level Acceleration Bounds in Voltage-Constrained Actuation [#link("https://roboticsconference.org/program/papers/101/", "RSS 页面")]

AJAC 将离散时间关节加速度限制与电压受限执行器的物理可实现性连接起来，剔除运动学上允许但电机电压无法实现的加速度。电机和轮腿四足硬件实验显示，AJAC 能在边界附近保持一致执行，减少由约束边界引起的振荡。该方法是执行层约束契约，需结合具体电机电气模型校准。

=== 102. cuNRTO: GPU-Accelerated Nonlinear Robust Trajectory Optimization [#link("https://roboticsconference.org/program/papers/102/", "RSS 页面")]

cuNRTO 在 CUDA 上实现非线性鲁棒轨迹优化，分别用 Douglas–Rachford 分裂求解 SOCP 内层子问题，并提出利用结构的 FullADMM 架构提升可扩展性。定制 CUDA 锥投影核和 cuBLAS 矩阵链用于反馈增益更新，在单轮车、四旋翼和 Franka 模型上获得最高 139.6 倍加速。性能收益依赖稀疏结构和 GPU 并行度，嵌入式部署还需评估显存占用。

=== 103. Safe Large-Scale Robust Nonlinear MPC in Milliseconds via Reachability-Constrained System Level Synthesis on the GPU [#link("https://roboticsconference.org/program/papers/103/", "RSS 页面")]

GPU-SLS 在 GPU 上联合优化可行名义轨迹、跟踪控制器和扰动下闭环可达集，从而为高维不确定系统提供带可证明安全性的实时非线性 MPC。基于并行扫描和缓存的 ADMM-QP 求解器将轨迹求解相对 CPU 加速 97.7%，SLS 控制与可达性计算加速 237 倍；61 维四足和 75 维人形系统平均 34 毫秒完成在线策略合成，并达到 100% 实验安全率。其求解规模很大，对 GPU 资源和模型准确性要求较高。

=== 104. Bellman Value Decomposition for Task Logic in Safe Optimal Control [#link("https://roboticsconference.org/program/papers/104/", "RSS 页面")]

本文证明，时间逻辑定义的复杂任务 Bellman Value 可分解为由 Reach-Avoid、Avoid 和新提出的 Reach-Avoid-Loop Bellman 方程连接的值图。基于这一结构，VDPPO 用单一表示嵌入分解后的值图，在高维、多目标配送与驱赶任务中同时优化安全性和任务完成度。结果显示，它减少了形式自动机和稀疏奖励的手工设计；价值分解对任务逻辑正确建模较为敏感。

=== 105. asRoBallet: Closing the Sim2Real Gap via Friction-Aware Reinforcement Learning for Underactuated Spherical Dynamics [#link("https://roboticsconference.org/program/papers/105/", "RSS 页面")]

asRoBallet 面向欠驱动人形球形机器人，提出显式建模 ETH 全向轮离散滚子、寄生振动与接触不连续性的高保真 MuJoCo 仿真，并用摩擦感知 RL 学习轮—球和球—地面之间的耦合滚动、侧向与扭转摩擦。该方法首次在此类人形 ballbot 硬件上实现 RL，并支持零样本 sim-to-real；平台通过旧四足部件重构降低了成本。复杂摩擦、执行器延迟和安全探索仍是落地风险。

=== 106. Stabilizing 3D Continuum-Arm Rollouts via Equilibrium Anchoring and Feature-Lifted Residual Learning [#link("https://roboticsconference.org/program/papers/106/", "RSS 页面")]

针对腱驱动三维连续臂在分布偏移下多步预测发散的问题，本文先从廉价静态数据学习平衡先验，再在递推更新中持续拉回平衡点，并用特征提升的线性残差模型拟合动态瞬态。200 步、比训练更快更强的驱动测试中，骨干位置 RMSE 降低 26%，末端位置 RMSE 降低 27%，且所有轨迹均保持稳定。该混合结构依赖平衡状态可辨识，快速变化或多平衡系统可能需要更丰富先验。

=== 107. Learning-Based Adaptive Control for Surgical Robotic Exposure Task on Deformable Tissues [#link("https://roboticsconference.org/program/papers/107/", "RSS 页面")]

本文将手术组织牵开建模为在线自适应控制问题，根据组织视觉边界变化实时优化控制输入。仿真训练的深度形变估计器用于选择抓取点，并帮助控制器保证收敛与安全；在多种可变形材料上的仿真和真实实验中，系统能从初始抓取到完整暴露自动完成，并对相似任务零样本适应。组织个体差异、遮挡和真实手术安全验证仍需进一步研究。

=== 108. Variance-Reduced Model Predictive Path Integral via Quadratic Model Approximation [#link("https://roboticsconference.org/program/papers/108/", "RSS 页面")]

该方法将 MPPI 目标拆为可解析的近似模型和较小的残差，并用二次近似构造集中于高信息区域的模型引导采样先验。二次模型既可来自精确导数、Gauss/Quasi-Newton 结构，也可来自无梯度随机平滑，因此不依赖特定几何信息来源。在优化基准、欠驱动倒立摆和非光滑接触操作中，低样本条件下收敛更快、性能更高；近似模型失配严重时，方差降低效果会减弱。

=== 109. Tempered Sequential Monte Carlo for Trajectory and Policy Optimization with Differentiable Dynamics [#link("https://roboticsconference.org/program/papers/109/", "RSS 页面")]

TSMC 把控制器设计视为推断，在 KL 正则化的轨迹代价下得到随温度降低而集中到低成本解的 Boltzmann 分布。算法沿退火路径重加权和重采样粒子，并用带可微 rollout 梯度的 Hamiltonian Monte Carlo 保持多样性；对策略优化还扩展了初始状态经验分布和 rollout 随机性的增广空间。多类轨迹与策略基准显示其优于或接近先进方法；粒子数和可微动力学开销限制长时域规模。

=== 110. TinySDP: Real Time Semidefinite Optimization for Certifiable and Agile Edge Robotics [#link("https://roboticsconference.org/program/papers/110/", "RSS 页面")]

TinySDP 是面向嵌入式系统的半定规划求解器，把半正定锥投影集成到带缓存 Riccati 递推的 ADMM 中，并以事后秩一证书把松弛解转化为逐时刻几何安全保证。它可在微控制器上执行带非凸障碍约束的实时 MPC；在死胡同和动态避障基准中实现无碰撞导航，路径长度最多比基线短 73%，并在 Crazyflie 上验证。证书依赖松弛解满足一定秩结构，复杂场景的保守性需评估。

=== 111. High Precision Hydraulic Excavator Control for Heavy Duty Grading [#link("https://roboticsconference.org/program/papers/111/", "RSS 页面")]

本文针对不同液压架构的挖掘机高精度整平，分离液压感知的低层回路与协调关节响应的路径跟踪层，并通过标定适配负载敏感和负流量控制系统。两台不同液压挖掘机实验中，RMSE 为 1.8 cm，较商业方案 4.7 cm 提升约 2.6 倍，同时利用更高的功能压力避免过早停机。该控制器仍需要每种液压架构进行低层参数标定。

== World Models & Memory

这些论文把记忆检索、因果视频预测、仿真蒸馏和交互式世界模拟器用于长时序机器人学习，目标是让策略在闭环执行中具备可预测、可修正和可扩展的想象能力。

=== 10. Memory Retrieval in Visuomotor Policies for Long-Horizon Robot Control [#link("https://roboticsconference.org/program/papers/10/", "RSS 页面")]

HALO 为视觉运动策略加入基于注意力的记忆检索，以回答家庭等部分可观环境中的物体位置、子任务进度和设备状态问题。它利用视觉语言模型从示教轨迹生成任务相关问答，与策略联合训练视频问答目标，抑制检索模块学习伪相关；稀疏注意力只访问历史中最相关片段，降低闭环记忆误差累积。系统可利用最长约两分钟历史提升长时域控制，但问答监督质量和历史表征漂移仍会影响效果。

=== 11. RAG-Diff: Adapting Diffusion Policies to Dynamic Constraints with Retrieval-Augmented Guidance [#link="https://roboticsconference.org/program/papers/11/", "RSS 页面")]

RAG-Diff 为冻结的 Transformer Diffusion Policy 配备偏好记忆 PrefMem，保存视觉语言嵌入、状态—动作片段和约束标注。测试时检索近邻片段，通过 I-Atten 将其作为交叉注意力记忆并重算引导，同时把约束参数加入预测引导以抑制违规采样；在 PushT 和真实护理任务中，涵盖床上擦洗、送药、货架清洁和喂食等时变偏好，成功率与约束满足率均提升。检索库覆盖不足或偏好冲突时，指导可能失效。

=== 12. Self-Improving Robot Policy with Compositional World Model [#link("https://roboticsconference.org/program/papers/12/", "RSS 页面")]

RISE 用组合式世界模型进行“想象中的”机器人强化学习：可控动力学模型预测多视角未来，进度价值模型评价想象结果并产生策略改进优势。闭环管线持续生成虚拟 rollout、估计优势并在想象空间更新策略，避免真实环境中的风险、重置和长时域信用分配。三个真实任务中，动态砖块分类、背包整理和盒子关闭的绝对性能分别提升超过 35%、45% 和 35%；模型预测误差会限制想象更新的可靠性。

=== 13. HAIC: Humanoid Agile Object Interaction Control via Dynamics-Aware World Model [#link("https://roboticsconference.org/program/papers/13/", "RSS 页面")]

HAIC 面向滑板、推车等欠驱动且具有独立动力学的物体交互，利用本体历史预测物体高阶状态（速度和加速度），再将其投影到静态几何先验上构造带空间定位的动态占用表示，使策略能够处理视觉盲区中的碰撞边界和接触可供性。非对称微调让世界模型持续适应学生策略探索带来的分布变化。G1 能在不同负载下完成滑板、推车推拉及多物体长时序搬运；依赖仅本体信号的动力学预测在强遮挡或突发接触时可能退化。

=== 14. Collaborating Visual and Parameter Spaces for Consistent Long-Horizon Embodied World Model [#link("https://roboticsconference.org/program/papers/14/", "RSS 页面")]

ViPSim 通过视觉空间和参数空间协同生成长期一致的具身视频。视觉空间提供动作像素投影、相机视角、深度几何和机器人形态掩码等显式结构约束；参数空间注入动作序列与相机矩阵，提供精确数值驱动。两者结合后，轨迹漂移和机器人—物体几何错位明显减少，并能处理布料折叠、跨本体和分布外交互；性能仍受底层视频模型的物理建模能力限制。

=== 15. Act2Goal: From World Model To General Goal-conditioned Policy [#link("https://roboticsconference.org/program/papers/15/", "RSS 页面")]

Act2Goal 以当前观测和目标图像为输入，通过目标条件世界模型生成中间视觉状态，再用多尺度时间哈希把想象轨迹拆为近端稠密帧和远端稀疏帧，分别服务局部闭环控制与全局一致性。端到端交叉注意力将视觉计划接入电机动作，并支持通过后见之明目标重标记和 LoRA 微调进行无奖励在线自我改进。真实分布外任务中，成功率可在数分钟自主交互内由 30% 提升到 90%；在线更新依赖可靠目标图像和世界模型预测。

=== 16. Causal World Modeling for Robot Control [#link("https://roboticsconference.org/program/papers/16/", "RSS 页面")]

CauVA 用自回归扩散框架统一视频帧预测和动作推断：Mixture-of-Transformers 将帧与动作作为同一因果序列处理，KV cache 保留真实交互历史，带噪潜变量增强则允许直接从中间去噪视频解码动作以加速推理。仿真和真实基准涵盖长时域、高精度及可变形物体操作，均显示出较强性能；统一序列建模仍需要较高的计算与视频数据成本。

=== 17. Simulation Distillation: Pretraining World Models in Simulation for Rapid Real-World Adaptation [#link("https://roboticsconference.org/program/papers/17/", "RSS 页面")]

SimDist 将仿真器中的结构先验蒸馏到潜在世界模型，并把奖励和价值模型直接迁移到真实部署中。在线规划与监督式动力学微调把适应问题化为短时域系统辨识，避免真实环境中探索困难和长时域信用分配。精密操作和四足行走实验显示，在数据效率、稳定性和最终性能上均超过既有 sim-to-real 方法；仿真奖励与真实任务不一致时，迁移的价值信号可能产生偏差。

=== 18. Interactive World Simulator for Robot Policy Training and Evaluation [#link("https://roboticsconference.org/program/papers/18/", "RSS 页面")]

Interactive World Simulator 用中等规模机器人交互数据训练可交互世界模型，能够以 15 FPS 在单张 RTX 4090 上保持超过十分钟的长期交互，并生成物理一致的像素级预测。由模拟器生成的数据可训练 Diffusion Policy、Action Chunking Transformer 和 π 系列策略；在刚体、可变形物体、物体堆及其组合任务上，模拟数据训练的策略与同量真实数据相当，模拟器内外表现也高度相关。其价值在于提供可扩展的数据生成和可复现实验环境，但最终可信度仍取决于交互数据覆盖。


本分片覆盖 Multi-robot Systems、Datasets and Benchmarks、HRI、RL、Modeling and Optimization 以及 Robot & Sensor Design 六个 Session。每条保留英文原标题与 RSS 官方详情页链接；中文内容是基于论文摘要的压缩整理，不替代全文阅读。

== Multi-robot Systems

=== 32. Distributed Pose Graph Optimization via Continuous Riemannian Dynamics [#link("https://roboticsconference.org/program/papers/32/", "RSS 页面")]

本文把分布式位姿图优化写成李群上的二阶连续时间黎曼动力系统，将位姿视为带阻尼的“质量粒子”。半隐式几何积分器统一了黎曼梯度下降和 Gauss--Newton，并通过块对角质量与阻尼矩阵实现多机器人并行求解；显式建模速度还可预测通信延迟下的邻居状态。理论分析给出离散化过程的能量耗散条件，基准实验显示其在同步和异步通信下均优于分布式基线。

=== 33. Adapting Execution-Time Objectives for Multi-Robot Policies via Collaborative Flow Policy Guidance [#link("https://roboticsconference.org/program/papers/33/", "RSS 页面")]

CFPG 允许多机器人策略在执行时组合新目标，而无需重新训练。其 MAFPO 以纯在线方式学习多模态协同行为，再用 Flow Matching 引导动作满足用户临时指定的目标，并通过分层梯度投影处理目标冲突。仿真与真实机器人结果表明，该框架在鲁棒性和目标适应性上超过现有方法；性能依赖于流场引导梯度的稳定估计。

=== 34. Rhythm: Learning Interactive Whole-Body Control for Dual Humanoids [#link("https://roboticsconference.org/program/papers/34/", "RSS 页面")]

Rhythm 面向双 humanoid 的身体接触协作，包含交互感知运动重定向、交互引导强化学习和真实部署系统三个部分。IAMR 从人类动作生成满足双机器人运动学的参考，IGRL 用图结构奖励学习耦合动力学，再通过仿真到现实流程部署到两台 Unitree G1。实验展示了拥抱、跳舞等复杂行为的稳定迁移，但当前验证集中于预定义互动动作。

=== 35. Teaming Linear Temporal Logic: Coordinated Behavior Specification in Heterogeneous Multi-Agent Systems [#link("https://roboticsconference.org/program/papers/35/", "RSS 页面")]

TeamingLTL 扩展线性时序逻辑，使其能够表达大规模异构多智能体系统中的部分可观测性和协作关系。用户只需描述行为与目标，自动化任务规划和分配模块负责具体实现；论文还展示了如何基于该语言进行程序验证并生成正确性可证明的控制器。其贡献主要是规范表达层，实际规划规模仍取决于底层求解器。

=== 36. A Closed-Loop Multi-Agent Framework for Robust Multi-Robot Manipulation [#link("https://roboticsconference.org/program/papers/36/", "RSS 页面")]

本文将大语言模型的高层任务分解与多机器人接触操作组成闭环系统。规划 Agent 分配子任务，各机器人 Manipulation Agent 通过自适应工具使用执行，Verification Agent 监测物理结果并反馈语义修正，从而处理跨工作空间的执行偏差。真实实验报告了比开放环规划更高的成功率和更好的单机器人到多机器人扩展性，但系统仍受视觉验证和语言模型延迟影响。

=== 37. USER: A Unified and Extensible System for Online Real-World Policy Learning in Embodied AI [#link("https://roboticsconference.org/program/papers/37/", "RSS 页面")]

USER 将真实机器人与 GPU 视为统一硬件资源，提供发现、调度、数据通道和权重同步等基础设施。持久化且具缓存感知的异步缓冲区支持长期在线模仿学习或强化学习，并具备崩溃恢复能力；统一接口覆盖 CNN/MLP、生成式策略和 VLA 模型。仿真和真实实验展示了异构机器人、云边协同及长时间训练，价值在于系统工程整合而非单一算法改进。

=== 38. KlaskTron: An Open-Source Platform for Physical Adversarial Multi-Agent RL [#link("https://roboticsconference.org/program/papers/38/", "RSS 页面")]

KlaskTron 是面向对抗式多智能体强化学习的低成本桌面机器人平台，基于动态桌游 KLASK，硬件成本低于 2500 美元。平台提供双 CoreXY 龙门、CAD/BOM、Isaac Lab 数字孪生和神经执行器模型，并验证了零样本仿真到现实策略迁移与涌现的对抗行为。开放硬件和软件有助于复现实验，但任务分布仍集中在单一桌面竞技场景。

=== 39. Event-Driven Sleep-Wake Scheduling for Heterogeneous Robots under LTL Constraints [#link("https://roboticsconference.org/program/papers/39/", "RSS 页面")]

ALIS-WC 用事件驱动强化学习解决带 LTL 安全和先后约束的异构机器人睡眠--唤醒调度。两阶段过滤先剔除物理上不可能贡献的机器人，再依据时序依赖标记可调度机器人；自然语言任务由 8B 翻译器转换为 LTL，基于全局进度的势函数提供难度无关的奖励。大规模图基准中，方法在满足全部时序约束的同时降低完工时间；约束数量显著增加时，过滤质量成为瓶颈。

=== 40. Interactive Knowledge Distillation with Adaptive Teachers in Cooperative Multi-Agent Reinforcement Learning [#link("https://roboticsconference.org/program/papers/40/", "RSS 页面")]

HINT 针对集中式教师与分散式学生之间的分布偏移和观测不匹配，采用分层强化学习构造可扩展教师。学生轨迹以伪离线数据反哺教师，使其适应学生诱导的状态分布；基于性能的过滤器只保留学生可执行的指导信号。FireCommander 与 MARINE 实验中，任务成功率较在线 MARL 基线提升 60%--165%，但教师训练和过滤阈值增加了系统复杂度。

=== 41. Model-Based Diffusion Optimal Control for Multi-Robot Motion Planning [#link("https://roboticsconference.org/program/papers/41/", "RSS 页面")]

MDOC 将多机器人轨迹规划建模为带已知动力学和控制屏障函数约束的扩散最优控制，不依赖示范数据。采样时用 CBF 投影保证动力学可行和碰撞安全，再通过 Conflict-Based Search 处理机器人间冲突。仿真结果显示其在样本效率、轨迹平滑度、成功率和计算时间上优于代表性规划器；安全保证依赖动力学模型与障碍估计准确。

=== 42. Optimal UGV-UAV Cooperative Partitioning and Inspection of Shortest Paths [#link("https://roboticsconference.org/program/papers/42/", "RSS 页面")]

论文研究道路阻塞只能在抵达损坏点时发现的 UGV--UAV 协同最短路问题，推广了 Canadian Traveller Problem。作者推导了单 UGV 在 k 条互不相交路径上的竞争比，并证明 UAV 可通过前缀由地面车、后缀由空中车检查来获得最优分区策略。对全球 50 个大城市路网的随机阻塞实验显示，UGV 行驶时间最多降低 30%；理论简化假设下的 UAV 转场代价在真实部署中需单独建模。

=== 43. Time-Aggregated Connectivity Maintenance for Multi-Robot Networks [#link("https://roboticsconference.org/program/papers/43/", "RSS 页面")]

本文允许机器人暂时断连，再通过时间窗口内的重连保证信息最终可流通，避免持续全局连通对大规模探索的过度限制。TWA-MST 动态选择需要重连的机器人对，adaptive PT-CBF 则在最小偏离名义轨迹的情况下保证限定时间内重连。理论与实验均验证了时间聚合连通性；方法需要合理设置时间窗口与通信模型。

=== 44. Safe Multi-Agent Navigation via Constrained HJB-Informed Learning [#link("https://roboticsconference.org/program/papers/44/", "RSS 页面")]

HJB-GNN 联合学习图神经网络控制屏障函数、分布式导航策略和值函数，用约束 Hamilton--Jacobi--Bellman 方程导出的乘子自适应平衡避碰与到达目标。系统支持集中训练、分布部署，并在密集未知环境中避免过度保守。仿真和 Crazyflie 群体实验显示了较好的安全性、可扩展性和未见场景泛化。

== Datasets and Benchmarks

=== 90. Betting for Sim-to-Real Performance Evaluation [#link("https://roboticsconference.org/program/papers/90/", "RSS 页面")]

本文把受限真实实验下的机器人性能评估重新表述为“下注”问题。作者给出 betting 机制优于普通 Monte Carlo 估计的理论条件，并提出可实现的近似下注与诊断规则，以融合多种保真度模拟器的信息。合成实验和抓取案例表明，该视角可更高效地估计真实成功率；其收益取决于模拟分布与真实分布之间仍保有可校准关联。

=== 91. MolmoSpaces: Large-Scale Open Ecosystem for Robot Manipulation and Navigation [#link("https://roboticsconference.org/program/papers/91/", "RSS 页面")]

MolmoSpaces 提供超过 23 万个室内环境、13 万个物体资产和 4200 万个稳定抓取标注，覆盖静态/移动操作、导航及多房间长时序任务。生态与 MuJoCo、Isaac、ManiSkill 等模拟器解耦，并配套八项 MolmoSpaces-bench 任务。基准与真实表现的相关系数达到 R=0.96、rho=0.98，同时揭示提示措辞、初始关节和遮挡的敏感性；规模带来的资产质量和仿真偏差仍需持续维护。

=== 92. EgoVerse: An Egocentric Human Dataset for Robot Learning from Around the World [#link("https://roboticsconference.org/program/papers/92/", "RSS 页面")]

EgoVerse 将全球协作采集的人类第一视角示范统一到共享平台，当前包含 1,362 小时、8 万段轨迹、1,965 项任务、240 个场景和 2,087 名示范者。数据配有标准格式、操作相关标注及下游训练工具，并在多实验室、多本体协议下研究人类到机器人的迁移。结果显示增加人类数据通常有益，但数据与机器人目标的对齐程度决定了缩放收益。

=== 93. GS-Playground: A High-Throughput Photorealistic Simulator for Vision-Informed Robot Learning [#link("https://roboticsconference.org/program/papers/93/", "RSS 页面")]

GS-Playground 将批量 3D Gaussian Splatting 渲染与并行物理引擎结合，面向视觉驱动的机器人学习。系统在 640x480 分辨率下达到约 10^4 FPS，并用 Real2Sim 流程自动重建具有真实外观和物理一致性的场景。运动、导航和操作实验显示其能同时缩小感知与物理仿真差距；高吞吐建立在特定渲染和硬件实现上。

=== 94. High Fidelity Capture, Reconstruction, and Transfer of Human Demonstrations for Robot-Assisted Bathing [#link("https://roboticsconference.org/program/papers/94/", "RSS 页面")]

本文以接触区域为核心处理单元，采集并重建临床人员为人洗浴时同步的运动、形状、接触和力数据。基于该数据，作者让装有灵巧软手的机械臂在人体模型上执行开放环和闭环洗浴，并验证了多层控制栈的数据迁移。数据集填补了持续接触式 pHRI 的空白，但真实人体安全验证仍是后续工作。

=== 95. RoboVista: Evaluating Vision Language Models for Diverse Robot Applications [#link("https://roboticsconference.org/program/papers/95/", "RSS 页面")]

RoboVista 以 Robot Question Answering 为模块化评测形式，收集 474 个带专家推理标注的问题，覆盖农业、工业、家庭、手术、自动驾驶等 39 类任务。它不只评估端到端成功率，还拆分感知、决策和语言解释能力。当前 VLM 在这些任务上仍存在明显差距，而物理机器人实验显示 RoboVista 得分与真实执行相关；问答能力到控制性能之间仍可能受执行器因素影响。

=== 96. RoboLab: A High-Fidelity Simulation Benchmark for Analysis of Task Generalist Policies [#link("https://roboticsconference.org/program/papers/96/", "RSS 页面")]

RoboLab 提供机器人和策略无关的高保真场景生成器，并用约 80 个视觉、程序、关系和复杂度任务构成 RQA 基准。通过可控扰动，框架同时分析策略表现和对外部因素的敏感性，从而把模拟作为研究真实策略行为的实验工具。评测暴露了当前任务通用策略在分布变化下的显著性能缺口，但生成场景的真实性仍决定分析结论的外推范围。

=== 97. LIBERO-X: Robustness Litmus for Vision-Language-Action Models [#link("https://roboticsconference.org/program/papers/97/", "RSS 页面")]

LIBERO-X 采用分层评测协议，逐级考察空间泛化、物体识别和任务指令理解，并提供多样化的人类遥操作训练数据以缩小训练--测试分布差异。代表性 VLA 在累积扰动下性能显著下降，暴露出场景理解和指令落地的持续弱点。该基准的价值在于把“成功率”拆成可诊断的鲁棒性曲线。

=== 98. OopsieVerse: A Safety Benchmark with Damage-Aware Simulation for Robot Manipulation [#link("https://roboticsconference.org/program/papers/98/", "RSS 页面")]

OOPSIEVERSE 在 MDP 中显式加入损伤观测、奖励和终止条件，将接触力、温度与液体作用转换为机械、热和流体损伤信号。其 DAMAGESIM 框架与 OmniGibson、RoboCasa 解耦，配套任务区分“完成任务”和“无损完成”。作者展示了损伤反馈示教、损伤条件 IL/RL、VLA 安全评测及 sim-to-real 安全改进等用途；损伤模型与用户偏好仍需针对具体设备校准。

== HRI

=== 112. Automated Synthesis of Facial Mechanisms for Conversational Animatronic Robots [#link("https://roboticsconference.org/program/papers/112/", "RSS 页面")]

本文从单张二维肖像重建三维脸，并基于参数化连杆模板自动生成可制造、无碰撞的动画脸机构。算法结合解剖学可行运动体积、面部动作单元轨迹目标和碰撞驱动迭代，同时生成说话与倾听的双身份面部运动。多种脸型、实时部署和用户研究验证了可行性；机构可靠性和长期对话中的情绪语义仍有待扩大评测。

=== 113. Social Human Robot Embodied Conversation (SHREC) Dataset: Benchmarking Foundational Models' Social Reasoning [#link("https://roboticsconference.org/program/papers/113/", "RSS 页面")]

SHREC 收集 400 段真实人机对话视频和超过 1 万条标注，记录机器人的社会错误、能力、原因与纠正方式。八项任务覆盖社会错误识别、互动流程理解、社会属性判断以及生成替代行动。基础模型和人类评估均显示明显差距，说明真实具身社会推理不能由普通人类视频数据直接替代。

=== 114. CANINE: Coaching Visually Impaired Users for Interactive Navigation with a Robot Guide Dog [#link("https://roboticsconference.org/program/papers/114/", "RSS 页面")]

CANINE 为视障用户学习与机器导盲犬协同导航提供自适应口头教练。高层知识追踪器定位最弱子技能，低层基础模型根据练习过程推断错误原因并生成针对性纠正。对照实验、两周保持测试和一名视障用户案例均显示学习效率与最终表现提升；真实部署还需考虑自然环境噪声和个体差异。

=== 115. QuickLAP: Quick Language-Action Preference Learning for Autonomous Driving Agents [#link("https://roboticsconference.org/program/papers/115/", "RSS 页面")]

QuickLAP 用贝叶斯框架融合物理纠正和自然语言反馈，实时推断用户的潜在奖励偏好。语言模型从话语中提取奖励特征注意力和偏好变化，再与动作反馈闭式更新结合，从而处理语言含义模糊的问题。在操作和半自动驾驶模拟器中，奖励学习误差较物理单模态基线降低超过 70%，但依赖语言模型对特征的正确解析。

=== 116. Robots That Know What to Ask: Recovering Misaligned Rewards through Targeted Explanations [#link("https://roboticsconference.org/program/papers/116/", "RSS 页面")]

本文观察示范中不同特征的稳定性，以发现奖励函数被低估或未充分说明的维度。机器人用自然语言解释不确定性，并主动请求针对这些缺口的示范，而不是随机询问。桌面操作模拟和 Franka 用户研究表明，解释引导的定向查询比被动收集或随机查询更快恢复奖励，代价是需要设计可理解的特征解释。

=== 117. Embodiment Meets Environment: Toward Context-Aware, Safe Physical Caregiving Robots [#link("https://roboticsconference.org/program/papers/117/", "RSS 页面")]

E2-CARE 将环境、机器人本体和人统一表示为动态三维场景图，并把护理技能抽象为可在线重塑的交互模板。运行时根据上下文合成约束，使相同技能能够在不同环境和本体上零样本复用并保持安全。四类日常活动的大量仿真以及两台机器人上的用户研究验证了适应性；场景图和约束生成质量直接影响安全边界。

=== 118. Beyond Failure Recovery: An Engagement-Aware Human-in-the-loop Framework for Robotic Systems [#link("https://roboticsconference.org/program/papers/118/", "RSS 页面")]

E-MPC 将用户参与度纳入交互规划，避免人类只在机器人失败时被动介入，也避免过度询问造成负担。交互动力学模型描述频率和交互类型如何影响参与度，MPC 在满足工作量约束的同时安排主动互动。模拟与机器人辅助进食研究显示，不同用户画像下体验有所改善且任务成功率保持；参与度模型需要针对长期使用持续校准。

=== 119. Knowing When Not to Help: Active Estimation of Human Reachability for Just-Right Robot Assistance [#link("https://roboticsconference.org/program/papers/119/", "RSS 页面")]

本文主动估计个体在人关节空间中的可达性，以决定何时帮助、何时让用户自主完成。可达性由受生物力学先验约束的参数化模型表示，机器人选择校准查询并维护对该模型的信念；约 20 次查询可达到约 0.50 IoU。三明治制作和康复式操作实验显示，按能力校准的辅助提高了参与感且不增加工作量，但查询本身会带来交互成本。

=== 120. A Minimal, Deterministic Approach to Shared Control for Safe Powered Wheelchair Driving [#link("https://roboticsconference.org/program/papers/120/", "RSS 页面")]

REACT 在 LUCI 驱动辅助系统上实现最小、确定性的安全共享控制，仅在约束需要时仲裁用户动作。论文同时提出纵向、任务相关且面向个体的评测协议，并在商用电动轮椅上开展案例研究。结果显示辅助效果随障碍类型、控制接口、任务和时间尺度显著变化，但用户总体评价积极，说明共享控制不能只看单次任务成功率。

== RL

=== 148. Zero-Shot Sim-to-Real Robot Learning: A Dexterous Manipulation Study on Reactive Catching [#link("https://roboticsconference.org/program/papers/148/", "RSS 页面")]

DRIS 在一个 episode 内同时传播一组随机化动力学实例，而非只采样一个实例，使策略学习到对多种可能结果都稳健的动作。理论分析指出少量实例即可改善不确定性覆盖；在无被动稳定结构的平板反应式接物任务中，策略实现了可靠的零样本 sim-to-real。方法减轻了真实微调需求，但训练成本会随实例数量增长。

=== 149. Emerging Extrinsic Dexterity in Cluttered Scenes via Dynamics-aware Policy Learning [#link("https://roboticsconference.org/program/papers/149/", "RSS 页面")]

DAPL 学习由接触诱导的物体动力学表示，并将其作为强化学习条件，使策略在杂乱场景中主动利用环境接触实现外在灵巧性。相比抓取式操作、人工遥操作和既有表示方法，仿真未见场景成功率提升超过 25%，真实十个杂乱场景约 50% 成功。方法减少了手工接触启发式，但世界模型误差仍会限制真实泛化。

=== 150. ViserDex: Visual Sim-to-Real for Robust Dexterous In-hand Reorientation [#link("https://roboticsconference.org/program/papers/150/", "RSS 页面")]

ViserDex 在 3D Gaussian 表示空间执行物理一致的域随机化，用单目 RGB 训练手内物体姿态估计器，再以课程式 RL 和师生蒸馏学习重定向策略。无需大型计算集群，消费级硬件即可独立训练感知和控制模块；真实多指手在复杂光照下对五种物体完成重定向。其关键收益来自高保真的视觉变化建模，受限于 Gaussian 场景重建质量。

=== 151. SimToolReal: An Object-Centric Policy for Zero-Shot Dexterous Tool Manipulation [#link("https://roboticsconference.org/program/papers/151/", "RSS 页面")]

SimToolReal 在仿真中程序化生成大量工具形状，以“把任意工具操纵到随机目标姿态”为统一目标训练单一策略。该物体中心策略不需要每个工具和任务单独建模或调奖励，在 24 个任务、12 个实例和 6 类真实工具的 120 次 rollout 中实现零样本泛化。相比重定向和固定抓取基线提升 37%，但对仿真工具几何覆盖有较强依赖。

=== 152. Latent Policy Steering through One-Step Flow Policies [#link("https://roboticsconference.org/program/papers/152/", "RSS 页面")]

LPS 用可微的一步 MeanFlow 策略把原始动作空间的 Q 梯度反传到潜动作策略，避免学习信息损失较大的潜空间代理 critic。生成式先验把策略限制在离线数据支持范围内，同时允许 Q 函数直接推动策略改进。OGBench 和真实机器人实验达到或超过现有离线 RL 方法，且超参数较少；一步流策略的表达能力是核心前提。

=== 153. When Life Gives You BC, Make Q-functions: Extracting Q-values from Behavior Cloning for On-Robot Reinforcement Learning [#link("https://roboticsconference.org/program/papers/153/", "RSS 页面")]

Q2RL 先用少量在线交互从行为克隆策略估计 Q 函数，再依据 BC 和 RL 动作的 Q 值门控采样，避免在线训练迅速覆盖原有好动作。D4RL、robomimic 以及真实装配任务中，方法较离线到在线基线更快收敛；在管道装配和 kitting 上仅需 1--2 小时在线数据即可达到最高 100% 成功率。

=== 154. Offline Policy Evaluation for Manipulation Policies via Discounted Liveness Formulation [#link("https://roboticsconference.org/program/papers/154/", "RSS 页面")]

本文把稀疏奖励下的策略评估重写为带折扣 liveness 的 Bellman 算子，显式处理有限轨迹截断和非单调任务进度。所得保守固定点值函数具有收缩性质，并能更准确地表达“任务是否正在完成”。在 VLA 和 Diffusion Policy 的模拟操作任务中，该方法明显减小截断偏差，优于 TD(0) 与 Monte Carlo 评估。

=== 155. HydroShear: Hydroelastic Shear Simulation for Tactile Sim-to-Real Reinforcement Learning [#link("https://roboticsconference.org/program/papers/155/", "RSS 页面")]

HydroShear 是与物理引擎无关的非完整水弹性触觉模拟器，显式建模粘滑转换、路径相关剪切累积和完整 SE(3) 物体--传感器交互。基于 SDF 跟踪膜面位移后，GelSight Mini 的剪切信号更接近真实；四项任务的零样本 sim-to-real 平均成功率达到 93%，显著高于仅图像或其他剪切模拟。高保真接触计算仍可能增加训练成本。

=== 156. Toward Reliable Sim-to-Real Predictability for MoE-based Robust Quadrupedal Locomotion [#link("https://roboticsconference.org/program/papers/156/", "RSS 页面")]

该工作用门控 Mixture-of-Experts 表示多地形四足运动，并提出 RoboGauge 通过 sim-to-sim 本体感知指标预测 sim-to-real 可迁移性，从而减少危险的实体筛选实验。Unitree Go2 在雪地、沙地、楼梯、斜坡和 30 cm 障碍上均保持运动，最高速度达到 4 m/s。RoboGauge 让策略选择更系统，但预测可靠性仍依赖测试地形和随机化覆盖。

== Modeling and Optimization

=== 157. Guided Streaming Stochastic Interpolant Policy [#link("https://roboticsconference.org/program/papers/157/", "RSS 页面")]

论文从反向 Kolmogorov 方程推导随机插值的最优引导漂移，并将其用于低延迟的 Streaming Stochastic Interpolant Policy。无需训练的 STEG 可在线计算梯度，训练式 CCG 则摊销引导成本，二者都支持测试时偏好对齐和避障。实验显示流式引导比块式策略更具反应性且动作更符合物理约束。

=== 158. Damage Adaptation in Seconds for Architected Materials [#link("https://roboticsconference.org/program/papers/158/", "RSS 页面")]

LEAP 利用软体执行器损伤在低维离散空间中表现的特点，从本体感知信号学习潜在损伤表示，并用简单集成模型在一分钟内适应未见损伤。6-DoF HSA 软腕的轨迹跟踪实验覆盖切割、烧灼和执行器修复，均可在无需仿真的情况下恢复控制。方法适合渐进式损伤，突发且结构性改变的故障仍需额外机制。

=== 159. NeuralActuator: Neural Actuation Modeling for Robot Dynamics and External Force Perception [#link("https://roboticsconference.org/program/papers/159/", "RSS 页面")]

NeuralActuator 用 Transformer 同时预测低成本舵机的非线性扭矩、外力和电机工作状态，摆脱线性电流--扭矩假设。双臂遥操作系统采集带真实外力的数据集，模型只需姿态轨迹监督即可通过可微仿真训练。5-DoF 平台实验验证了动力学建模、无传感器力估计和行为克隆增强；模型对具体执行器和温度条件仍需校准。

=== 160. Muninn: Your Trajectory Diffusion Model But Faster [#link("https://roboticsconference.org/program/papers/160/", "RSS 页面")]

Muninn 是无需再训练的扩散轨迹采样缓存包装器。它根据去噪器输出变化和解析误差系数估计最终轨迹偏差，将该偏差作为不确定性预算，在安全时复用缓存输出、必要时重新计算。D4RL、构型空间规划和视觉运动策略实验显示可显著减少网络调用，同时保持轨迹质量；误差上界估计不准时可能引入规划风险。

=== 161. Consensus-based optimization (CBO): Towards Global Optimality in Robotics [#link("https://roboticsconference.org/program/papers/161/", "RSS 页面")]

CBO 将共识优化引入机器人零阶轨迹和策略优化，并在温和假设下给出收敛到全局最优的理论保证。作者在长时域系统、欠驱动动态平衡和仅有终端代价的高维问题上进行实验，均取得低于 MPPI、CEM 等局部方法的代价。全局性保证依赖连续性和采样条件，实际高维计算量仍需评估。

=== 162. Natural Functional Gradients for Smooth Trajectory Optimization [#link("https://roboticsconference.org/program/papers/162/", "RSS 页面")]

本文在函数空间中直接执行几何感知的自然梯度更新，并以高斯平滑目标改善拥挤环境和狭窄通道中的非凸优化。函数空间内的正则性与时间离散网格解耦，蒙特卡洛估计器只需黑盒代价评估，适合碰撞检查不可导的任务。操作基准显示成功率更高、加速度和 jerk 更低，但采样预算会影响优化稳定性。

=== 163. IMPACT: An Implicit Active-Set Augmented Lagrangian for Fast Contact-Implicit Trajectory Optimization [#link("https://roboticsconference.org/program/papers/163/", "RSS 页面")]

IMPACT 用带收敛保证的增广拉格朗日求解接触隐式轨迹优化，把迭代中自动识别的活动接触集作为核心。开源 C++ 实现针对轨迹优化进行了加速，在 CITO 基准上较强基线获得 2.9--70 倍加速（几何平均 13.8 倍），并改善 CI-MPC 的接触控制。真实 T 形物体推动实验验证了可执行性，但复杂多接触场景仍可能产生数值病态。

=== 164. RIO: Flexible Real-time Robot I/O for Cross-Embodiment Robot Learning [#link("https://roboticsconference.org/program/papers/164/", "RSS 页面")]

RIO 是开源 Python 框架，为机器人控制、遥操作、数据格式、传感器配置和策略部署提供可替换组件。它把机器人、相机、夹爪、中间件与 VLA 策略解耦，在单臂、双臂和 humanoid 三种形态、四种硬件上验证了低配置切换。作者用 RIO 采集数据微调 pi0.5 和 GR00T 完成家务操作；框架收益主要来自标准化和工程复用。

=== 165. Structured Learning for Electromagnetic Field Modeling and Real-Time Inversion [#link("https://roboticsconference.org/program/papers/165/", "RSS 页面")]

本文用多层感知机学习非线性磁场映射，同时严格保留对线圈电流的线性关系，从而可以闭式求解最小范数逆。模型在 OctoMag 和 Navion 的高密度数据上达到与 Multipole Expansion Model 相当的预测精度，逆计算约 1 ms，适合高带宽控制。结构化设计还消除了部分标定造成的工作空间病态；数据驱动模型的外推范围仍由训练线圈几何决定。

== Robot & Sensor Design

=== 192. CRAFT: A Tendon-Driven Hand with Hybrid Hard-Soft Compliance [#link("https://roboticsconference.org/program/papers/192/", "RSS 页面")]

CRAFT 手在关节处使用柔性材料、在连杆处保持刚性，并以滚动接触关节获得可重复运动轨迹；15 个远置电机通过腱驱动以减轻手指。结构测试显示强度和耐久性提高，遥操作可覆盖 Feix taxonomy 的 33/33 种抓取，整手成本低于 600 美元。低成本和开源设计适合复现，但腱传动维护与标定仍是工程难点。

=== 193. LightTact: A Visual-Tactile Fingertip Sensor for Deformation-Independent Contact Sensing [#link("https://roboticsconference.org/program/papers/193/", "RSS 页面")]

LightTact 通过遮蔽环境光和非接触区域内部光，只保留真实接触产生的散射光，因此无需依靠宏观形变即可观测接触。非接触像素平均灰度低于 3，接触分割对材料、力、外观和环境光均较稳健，并支持涂水、蘸面霜和薄膜操作。视觉--触觉图像空间对齐后还能直接输入 VLM；传感器光学结构对封装和照明一致性要求较高。

=== 194. Bridging Language and Physics: Automated Design of Continuum Robots with Large Language Models [#link("https://roboticsconference.org/program/papers/194/", "RSS 页面")]

AID-SR 将 LLM 生成的连续体机器人设计与模拟器反馈闭环连接，把物理状态转成结构化批评并迭代修改。14 项任务中，96.2% 的设计通过仿真可行性检查，经过统一 RL 训练后 26.7% 能完成目标，三台实体原型也成功执行任务。该结果说明语言搜索可以进入物理设计循环，但设计空间、模拟器偏差和制造约束仍限制可靠性。

=== 195. Latent Diffeomorphic Co-Design of End-Effectors for Deformable and Fragile Object Manipulation [#link("https://roboticsconference.org/program/papers/195/", "RSS 页面")]

本文首次联合优化末端执行器形态与控制策略：潜在微分同胚参数化提供可表达且可优化的几何空间，压力感知双层流程同时搜索形态和动作，再把特权策略蒸馏为点云策略用于真实部署。果冻抓取/推动和鱼排舀取的仿真与实验证明协同设计优于单独优化。方法计算开销较高，并依赖可微或可仿真的接触模型。

=== 196. Computational Design of a Low-Visibility UAV Using a Human-Aligned Perceptual Metric [#link("https://roboticsconference.org/program/papers/196/", "RSS 页面")]

Phantom Twist 用高速旋转单桨和运动模糊降低视觉可见度。两阶段设计流程优化电池、控制板、电机螺旋桨和配重布局，以 LPIPS 等人类感知指标最小化可见性，同时满足惯量和气动稳定约束。多台原型的制造与飞行测试确认了可控飞行及较传统四旋翼更低的视觉显著性；应用场景中的安全与法规问题未展开。

=== 197. A Dual-Mode Electrical Capacitance Tomography Sensor for Robotic Proximity Servoing and Grasping [#link("https://roboticsconference.org/program/papers/197/", "RSS 页面")]

该 ECT 系统用大面积阵列和夹爪小型模块统一完成非接触距离、朝向、材料识别与预触觉伺服。物理启发的 CapacitiveServo-Net 直接从互电容扰动提取介电特征，避免昂贵的断层重建，并在 7-DoF 机械臂上实现实时姿态对齐和接近阶段抓取调整。它适合视觉遮挡环境，但电容读数易受周围物体和电磁噪声影响。

=== 198. Continuum Robot Modeling with Action Conditioned Flow Matching [#link("https://roboticsconference.org/program/papers/198/", "RSS 页面")]

作者构建低成本 3D 打印腱驱连续体机器人，并用动作条件点云 Flow Matching 学习腱驱动到连续形变的自模型。模型从随机运动状态中学习任务无关的运动学，在合成与真实实验中比既有三维可变形物体模型更准确地预测机器人形状。该方法降低了建模门槛，但对训练动作空间覆盖和点云质量敏感。

=== 199. A Super-Resolution and Multi-Axis Tactile Sensor with Soft Artificial Skin [#link("https://roboticsconference.org/program/papers/199/", "RSS 页面")]

本文以微型三悬臂结构解耦三维力，再在阵列外覆盖软硅胶皮肤，并结合模型与学习重建接触位置和力。实验达到 0.19 N 三维力 MAE、0.49 mm 接触定位误差，空间分辨率较既有工作提高约 26 倍；遥操作试管放置和抗干扰抓取验证了实用性。软层引入的牵引耦合需要校准，长期耐久性仍需测试。

=== 200. Active Surface-Driven Reconfigurable Gripper: Robust Grasping and Sequential Manipulation of Thin Objects [#link("https://roboticsconference.org/program/papers/200/", "RSS 页面")]

该可重构欠驱动夹爪以主动表面拇指在手内重新定位薄物体，配合柔顺手指建立稳定接触，从而减少对精确接近控制的依赖。作者建立运动学和物理模型，分别优化桌面平放书籍与书架竖放书籍的初始姿态和结构参数。实验覆盖书本、纸张、织物和鼠标垫，并能连续执行抓取--放置；对极端薄、湿滑或高柔性物体的适应性仍待验证。

= 来源与状态

- #link("https://roboticsconference.org/program/papers/", "RSS 2026 Accepted Papers")，访问于 2026 年 8 月 4 日。
- 当前收录 210 篇论文、21 个 Session；所有论文均已保存非空标题、作者、摘要和 PDF 链接。
- 当前已完成 210 篇论文的中文摘要级整理；后续编辑将重点补充跨 Session 研究脉络与更详细的论文笔记。
