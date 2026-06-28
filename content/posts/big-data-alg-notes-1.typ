
#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "大数据算法 课程总结笔记 I（期末部分）",
  date: datetime(year: 2026, month: 6, day: 8),
  weight: 0,
  tags: (
    category: ("TCS", "数学", "课程笔记")
  ),
  draft: false,
  references: ```bib
@misc{bigdataalg_note,
  title        = {大数据算法讲义},
  author       = {丁虎},
  year         = {2026},
  url          = {https://hu-ding.github.io/data_pdf/2026/Big_Data_Alg_Draft.pdf}
}
  ```,
)

这是我在 2026 年春季于中科大学习#link("https://hu-ding.github.io/index.html", "丁虎")老师的#link("https://hu-ding.github.io/data%20course_2026.html","《大数据算法》")课程时整理的期末考试复习笔记。非常喜欢的好课。只是可惜讲义编写得比较潦草。这里的笔记尽可能指出讲义中各种概念的几何意义与机器学习意义，并尝试找出各种定义、定理的动机。

= 6 VC 维

== VC 维及其几何概念

VC 维和核心集（coreset）是描述模型表达能力的数学工具。

直观来看，VC 维描述的是一个分类器在任意的正负类指定下，能够区分（称为“打散”）的最大数据点数目。如：
- 在二维平面上，二维直线可以打散（不共线的）3 个点，但不能打散（任何分布下的）4 个点，因此二维直线的 VC 维为 3；
- X 是二维平面 $R^2$，$r$ 是二维平面里的一个圆，那么 $"VC"(Sigma)=3$
- X 是三维平面 $R^3$，$r$ 是三维平面里的一个球，那么 $"VC"(Sigma)=4$
- X 是二维平面 $R^2$，$r$ 是二维平面里的一个多边形，那么 $"VC"(Sigma)=+infinity$

严格的数学的定义见讲义。以下是这些几何概念和机器学习中概念的对应，提供一些直观的理解。

#table(
  columns: 3,
  align: center,
  [几何术语],
  [机器学习标准术语],
  [形象化解释],
  [基集 $X$],
  [输入空间],
  [所有可能的数据样本的特征集合（如 $RR^d$）。],
  [范围族 $cal(R)$],
  [假设空间 $cal(H)$],
  [全参数下的模型集合。其中的每一个“范围” $r in cal(R)$ 都对应模型在某组特定参数下，判定为正类的决策区域。],
  [有限子集 $A subset X$],
  [样本集 / 训练集],
  [实际观测或用于训练的 $m$ 个无标签数据点。],
  [投影 $cal(R)_A$],
  [二分集 (Dichotomies)],
  [分类的行为集合。\ 即当模型参数在整个参数空间内变化时，我们的模型在当前这 $m$ 个特定样本上，所有可能输出的“正负标签向量”的集合。],
  [打散 (Shattering)],
  [完美拟合 / 记忆能力],
  [如果当前训练集 $A$ 被打散，意味着：无论这些数据点的真实标签是什么，模型总能找到正确分类这些数据的参数。],
)

范围空间由基集和范围族共同确定。$Sigma=(X,cal(R))$

VC 维的定义是“存在”性的，如果存在大小为 $k$ 的点集能被打散，则 $"VC"(Sigma) >=k$. 反过来，如果对于任意大小为 $k+1$ 的点集都不能被打散，则 $"VC"(Sigma) < k+1$.

VC 维并不是越高越好。能完全打散样本集的模型容易产生过拟合，VC 维适当（较低）的模型能够有更强的泛化潜力。当 VC 维低于样本集大小时，泛化误差界开始起作用，训练集上的表现具有了代表性，这由 VC 不等式保证。

*定理 6.1：*如果有一个 Range Space $Sigma = (X, cal(R))$，它的 VC 维 $"VC"(Sigma) = d$，那么定义两个集合：
$
cal(R)^(inter k) = {RR "中" k "个 Range 的交集"},quad
cal(R)^(union k) = {RR "中" k "个 Range 的并集"}
$
令 $Sigma_1 = (X, cal(R)^(inter k))$，$Sigma_2 = (X, cal(R)^(union k))$，则这两个 Range Space 的 VC 维在 $d k$ 和 $d k log k$ 之间，即：
$
d k <= "VC"(Sigma_1), "VC"(Sigma_2) <= d k log k
$
这个定理描述了多个模型用并、交操作组合出来的新模型表达能力的上下界，提供了一个模型组合的“安全边界”。

对于给定的范围空间 $Sigma=(X,cal(R))$，数据集合 $P$，误差参数 $epsilon in (0,1)$. 可在空间上定义一些“网状”结构：
- $epsilon"-net"$：对于 $S subset.eq P$，若 $cal(R)$ 中任意大小足够的范围 $abs(r inter P)>=epsilon abs(P)$ 均一定包含 $S$ 中的点，则称 $S$ 是 $P$ 关于 $cal(R)$ 的一个 $epsilon"-net"$。
  - 要求采样范围“不能漏掉”显著的区域。
- $epsilon"-sample"$：对于 $S subset.eq P$，如果对于任意范围 $r in cal(R)$，$abs(frac(abs(r inter S), abs(S)) - frac(abs(r inter P), abs(P))) < epsilon$，即采样集合 $S$ 计算出来的密度与真实密度的误差都不超过 $epsilon$，则称 $S$ 是 $P$ 的一个 $epsilon"-sample"$。
  - 要求采样范围“能正确估计”显著的区域。

显然 $epsilon"-sample"$ 的定义是更强的条件。

*定理 6.2 & 6.3：* $Sigma=(X,cal(R)), "VC"(Sigma)=d; epsilon, delta in (0,1)$，$Q$ 是 $X$ 的均匀采样子集。
- $Q$ 是 $epsilon"-sample"$ 的概率 $>=1-delta$ 的条件为 $abs(Q)=Theta(1/epsilon^2 (d log d/epsilon +log 1/delta)) approx tilde(Theta)(d/epsilon^2)$
- $Q$ 是 $epsilon"-net"$ 的概率 $>=1-delta$ 的条件为 $abs(Q)=max{4/epsilon log 2/delta, (8 d)/epsilon log (8d)/epsilon} approx tilde(Theta)(d/epsilon)$

可以观察到这些概率和 $X$ 无关。

实际意义：经验观察可以推广到实际真理。无论多大的数据，学习一个能良好分类这些数据的模型只需要一个（良好采样的）小样本，这个小样本的大小仅和模型的复杂程度与对误差的容忍度有关，而与数据集的大小无关。

假如说有一个巨大的包含正负样本的数据集，数据集的数据维度为 $d$，在该数据集上存在一个良好的分类超平面能很好的分开正样本和负样本，那么我们根据这两个定理，可以得出，当我们的SVM分类器的训练数据集的大小大概为 $Theta(d/epsilon)$ 时，我们可以保证，对任何一个新来的数据点，分类出错的概率小于 $epsilon$。

== VC 维与 PAC Learning

可高效 PAC 学习的实际意义是：高概率的采样条件下（失败概率 $delta$），对任意分布的训练&测试集，算法可学习到误差足够小（小于 $epsilon$）的模型，且算法时间复杂度是 $1/epsilon, 1/delta$ 的多项式级别。（能大概率学到足够好的模型的多项式算法）

*定理6.4（奥卡姆剃刀）：*如果一个算法能够高效地找到一个一致的假设（consistent hypothesis），那么对于任何有限概念类 $C$ ，只要提供至少 $m$ 个样本，该算法就能实现 PAC 学习。其中样本数 $m$ 满足：$ m>=1/epsilon (log abs(H)+log 1/delta) $
- 一致的假设是指能精确区分训练数据集上所有正负样本的假设，于是这样的假设训练误差为0.

实际意义：“若无必要，勿增实体”，假设越小，泛化能力越强。对于两个能通过训练数据集的分类的模型，选择更简单的那个（即 VC 维更小的那个），能得到更好的泛化能力。

= 7 核心集

#let cost = "cost"
#let VC = "VC"

定义：对于数据集 $P$ 上特定的问题 $f(P,c)=sum_(p in P) cost(p,c)$，对于解空间 $cal(F)$ 中任意解，满足以下误差约束的带权数据集 $S$（足够具有代表性的数据集）
$
(1-epsilon) f(P,c) <= sum_((q_i, w_i) in S) w_i cost(q_i, c) <= (1+epsilon) f(P,c), quad forall c in cal(F)
$

带权是核心集必要的属性，这里的权重类似于将一个数据点复制多份来代表它在原始数据集中的重要程度。

核心集的使用通常遵循”构建 -> 求解 -> 映射”的三步范式：
- 数据缩减（构建核心集）： 给定一个包含数亿条记录的海量数据集 $P$，使用一种快速算法（通常是线性的，甚至是亚线性的时间复杂度）从中提取出一个极小的核心集 $S$。核心集中的每个数据点通常会被赋予一个权重（Weight），用来代表它”代表”了原始数据集中的多少个点。
- 在核心集上运行算法（求解）： 将原来计算复杂度极高（例如 $O(n^2)$ 或 $O(n^3)$）的机器学习或数据挖掘算法应用到核心集 $S$ 上。因为 $S$ 的规模远小于 $P$（例如 $P$ 有 10 亿个点，$S$ 只有 1 万个点），计算时间被成千上万倍地缩短。
- 结果映射（应用结果）： 将在核心集 $S$ 上训练出的模型或得到的参数，直接作为原始数据集 $P$ 的近似最优解。

对每个问题通常都有特定的核心集构建方式，包括分治、几何划分/聚类、贪心、重要性采样等。有一些直观的例子：
- 点云最小包围球问题的核心集是临近边界的点（凸性）；
- k-means 聚类问题的核心集是靠近数据密集区的点；k-means++ 可以作为一个核心集初始化算法，其思想也是很多核心集构建算法的基础。

讲义及作业、考试中有介绍一些核心集的构建方法。(TODO)

深度学习中核心集的主要应用有：
- 持续学习：在历史样本中选择核心集作为记忆。
  - Yoon 等人提出的准则：小批量相似性、样本多样性、Coreset 亲和性。
- 池式主动学习：模型主动以 coreset 原则选取重要样本。
- 生成模型：优化数据子集选取、自适应动态选择数据点等。(Small-GAN)
- LLM：CoLM 技术。传统 coreset 方法用于语言数据存在 (1) 小数据源样本容易被忽略; (2) Adam 优化器的梯度缩放影响未被考虑; (3) 语言模型维度极高、距离度量容易退化。
  - CoLM 提出的三步策略：小数据源样本保留、梯度归一化、梯度维度压缩。

= 8 最优传输

#let inner(a, b) = $chevron.l #a, #b chevron.r$
#let outer(a, b)= $#a and #b$

问题形式：有两个离散归一化分布向量 $r in RR_+^n, c in RR_+^m$，成本矩阵（“距离”）$C in RR_+^(n times m)$，目标是找到一个传输计划（“耦合”）矩阵 $P in RR_+^(n times m)$ 满足 $P bold(1)=r, P^T bold(1)=c$（记这类矩阵集合为 $U(r,c)$），最小化总运输成本 $L_C (r,c)=min_(P in U(r,c)) inner(P, C)$.

即：找到一个从分布 $r$ 到分布 $c$ 的最优传输计划 $P$，使得运输成本（由成本矩阵 $C$ 定义）最小。

原始问题是一个维数极高的线性规划问题，直接求解非常困难，因此考虑引入熵正则化，用参数 $lambda$ 控制 $P$ 趋向离散或者均匀分布，同时将问题转化为凸优化问题。熵的定义如下：
$
H(P)=-sum_(i, j) P_(i j) (log P_(i j)-1)
$
熵正则化的最优传输问题为：
$
L_C^lambda (r,c)=min_(P in U(r,c)) F(P)=min_(P in U(r,c)) inner(P, C)-lambda H(P)
$
则对能量求导得到最优化条件
$
(partial F)/(partial P_(i j))=C_(i j)+lambda log P_(i j)=0 => P_(i j)=exp(-C_(i j)/lambda)
$

Sinkhorn 算法：从初值 $u^(0), v^(0)=bold(1)$ 简单迭代至符合约束条件的解。“在不破坏 $K$ 内部相对能量比例的前提下，寻找一组最优雅的‘局部变形力’ $u$ 和 $v$，将 $K$ 扣入边界约束中”。
1. 计算 Gibbs 核矩阵 $K=exp(-C/lambda)$
2. 初始化 $v^(0)=bold(1)$
3. 迭代更新：
   - $u^((l+1))=r\/(K v^((l)))$
   - $v^((l+1))=c\/(K^T u^((l+1)))$
收敛结果为 $u^*, v^*$，令 $P^*="diag"(u^*)K"diag"(v^*)$，即 $P^*_(i j)=u_i v_j K_(i j)$. 由上面迭代更新的条件可以知道，收敛时满足
$
u^*=r\/(K v^*),quad v^*=c\/(K^T u^*) quad=>quad u^* dot.o K v^*=r, quad v^* dot.o K^T u^*=c
$
故可以验证 $P^*$ 的确符合传输计划约束：
$
P^* bold(1)=u^* dot.o K v^* = r,quad (P^*)^T bold(1)=v^* dot.o K^T u^* = c
$
关于最优性，需要先证明问题等价于最小化 $"D"_("KL")(P||K)$：
$
"D"_("KL")(P||K)
&=sum_(i, j) P_(i j) log(P_(i j)/K_(i j))-sum_(i, j) P_(i j)+sum_(i, j) K_(i j)\
&=sum_(i, j) P_(i j) (log P_(i j)+C_(i j)/lambda)-sum_(i, j) P_(i j)+sum_(i, j) K_(i j)\
&=(1/lambda inner(P, C)-H(P))+sum_(i, j) K_(i j)\
&=1/lambda F(P)+"const"
$
利用传输计划约束可以证明：
$
sum_(i,j)P^*_(i j)log P_(i j)^* /K_(i j)=sum_(i,j)P_(i j)log P_(i j)^* /K_(i j)=sum_i r_i log u^*_i + sum_j c_j log v^*_j
$
从而可以得到毕达哥拉斯等式：
$
&"D"_("KL")(P||K)-"D"_("KL")(P^*||K)\
=&(sum_(i, j) P_(i j) log(P_(i j)/K_(i j))-sum_(i, j) P_(i j)+sum_(i, j) K_(i j))-(sum_(i,j)P^*_(i j)log P_(i j)^* /K_(i j)-sum_(i,j)P^*_(i j)+sum_(i,j)K_(i j))\
=&(sum_(i, j) P_(i j) log(P_(i j)/K_(i j))-sum_(i, j) P_(i j)+sum_(i, j) K_(i j))-(sum_(i,j)P_(i j)log P_(i j)^* /K_(i j)-sum_(i,j)P^*_(i j)+sum_(i,j)K_(i j))\
=&sum_(i, j) P_(i j) log(P_(i j)/P^*_(i j))-sum_(i, j) P_(i j)+sum_(i, j) P^*_(i j)\
=&"D"_("KL")(P||P^*) >= 0
$
即 $"D"_("KL")(P^*||K)<="D"_("KL")(P||K), forall P in U(r,c)$，证明了 $P^*$ 是最优解。

此外，#link("../big-data-alg-notes-3/#loc-30", "作业三第 5 题") 给出了一种基于拉格朗日乘子法的证明。

熵正则化解的传输成本部分称为 Sinkhorn 距离 $d_(C, lambda)(r,c)=inner(P^lambda, C)_F$。
- Sinkhorn 距离是真实 OT 距离的一个通常更大的近似。
- 较小的 $lambda$ 意味着近似更精确，但迭代次数更多、数值更易不稳定；较大的 $lambda$ 会使解更均匀粗糙“模糊”、但求解更加稳定。

应用：
- 生成式模型：Flow Matching, Diffusion Model.
- 领域自适应：在源领域上训练一个模型，利用最优传输将源领域的分布映射到目标领域，从而实现模型在目标领域的迁移。怎么感觉和我们在做的需求有点像，有空认真研究一下。
- Wasserstein 鲁棒分布优化：TODO


= 9 分布式算法

Google提出的MapReduce模型是分布式计算的经典框架，适用于TB甚至PB级数据的并行处理。其核心
流程包括：
1. 数据划分：将输入数据拆分为多个块（split)，分配给不同的 Mapper 节点;
2. Map 阶段：每个 Mapper 执行用户定义的Map函数，产生若干 $("key", "value")$ 对；
3. Shuffle 阶段：系统自动将相同 $"key"$ 的数据发送到同一Reducer节点；
4. Reduce 阶段：Reducer 对相同 $"key"$ 的数据进行聚合处理；
5. 结果输出：输出结果存储到分布式文件系统（如 HDFS）。

讲义举例的分布式算法有：
- 分布式 $k"-center"$ 聚类：中心化贪心算法为 $2"-"$近似；采用分布节点-中心节点两阶段的贪心算法仍能保持常数级别 $4"-"$近似。
- 分布式 PCA 降维。
- 分布式 PageRank：瓶颈在跨机器边的通信。
- 分布式机器学习训练。
- 联邦学习。
- 分布式重心估计：用随机二值量化方法压缩通信量。

= 10 Beyond worst case analysis

BWCA 是从实际问题特征出发研究算法的复杂度的方法，通常基于对问题的结构化假设，分析算法在这些假设下的性能。BWCA 的目标是设计出在实际问题中表现良好的算法，而不仅仅是针对最坏情况的理论分析。常见的假设有：
- 稳定性：假设问题实例的最优解在输入数据的微小扰动下不会发生显著变化。
- 分离性：不同簇之间的距离足够大，使得簇结构明显。
- 扰动弹性：假设问题实例在面对随机扰动时仍然能够保持一定的性能。
- 平滑分析：允许对输入数据进行小幅随机扰动，并分析扰动后的期望运行时间。

== 良好分离性下的 $k"-means"$

$k"-means"$ 是 BWCA 的经典研究对象。

我们定义一个集合 $X$ 是 $epsilon"-Seperated"$，当 $Delta^2_k (X)<=epsilon^2 Delta^2_(k+1) (X)$，即 $X$ 明显地有 $k$ 个簇。

关于重心和 $1"-means" $能量（有“方差”意义）有如下引理：
1. 期望两两平方距离：$sum_(x, y in X) norm(x-y)^2=2n Delta_1^2 (X)$
2. 全方差公式（方差分解）：$Delta_1^2 (X)=Delta_1^2 (X_1)+Delta_1^2 (X_2)+(n_1 n_2)/n norm(mu_1-mu_2)^2$
3. 条件均值偏离不等式：$norm(mu(X_1)-mu(X))^2 <= (Delta_1^2 (X))/n dot n_2/n_1$

$epsilon"-"$分离性假设下的 $2"-means"$ 算法：
1. 按 $norm(x-y)^2$ 权重采样一对点 $(hat(mu)_1, hat(mu)_2)$.
2. 在以 $hat(mu)_i$ 为球心、半径为 $r=norm(hat(mu)_2-hat(mu)_2)\/3$ 的球内再计算一次质心 $overline(mu)_i$ 作为最终聚类中心。
算法求得的聚类代价最多为 $(Delta_2^2 (X))/(1-rho)$，且以至少 $1-O(rho)$ 概率成功，$rho=(100 epsilon^2)/(1-epsilon^2)$。

算法的时间复杂度为 $O(n d)$，其中采样步可以拆成以下两步：
- 按 $(sum_(y in X) norm(x-y)^2)/(sum_(x, y in X) norm(x-y)^2)=(Delta_1^2 (X)+n norm(x-mu(X))^2)/(2n Delta_1^2 (X))$ 权重采样 $x$（预计算 $Delta_1^2 (X)$）.
- 按 $norm(y-hat(mu)_1)^2/(Delta_1^2 (X)+n norm(mu(X)-hat(mu)_1)^2)$ 权重采样 $y$.

误差证明 TODO。

对于 $k"-means"$，算法的流程是这样的：
1. 先按 $norm(x-y)^2$ 权重采样一对点 $(hat(mu)_1, hat(mu)_2)$，然后用类似 $k"-means"$++ 的方式迭代采样 $k-2$ 个点，得到 $k$ 个初始聚类中心。
2. 有 Ball-k-means 和 Centroid Estimation 两种方式优化中心：
  - Ball-k-means：在 $hat(d)_i\/3$ 球内重建中心。时间复杂度 $O(n k d+k^3 d)$，成功概率 $1-O(sqrt(epsilon))$，代价不超过 $(1-epsilon^2)/(1-37 epsilon^2) Delta_k^2 (X)$.
  - Centroid Estimation：在扩展 Voronoi cell 内采样子集，在子集内再筛选一次子集，取最优中心。在 $O(2^(O(k(1+epsilon^2)\/omega))n d)$ 时间内以常数概率返回一个 $(1+omega)"-"$近似解。

== 压缩感知

考虑到许多实际信号（图片、声音、文字）等在语义空间中维度实际上会小很多，我们会考虑将实际信号编码进性质良好的低维隐空间中进行处理，且要求能从隐空间恢复出良好的信号，这就引出了压缩感知(Compressed Sensing)问题。

设计合适的 Encoder $Phi$ 和 Decoder $Delta$，使得最大压缩误差 $max_(x in RR^d) norm(Delta(Phi x)-x)_2^2$ 最小。

其中 $x in RR^d$ 为实际信号，$y=Phi x in RR^N$ 为我们对该信号的测量/压缩信号/隐空间向量/特征向量。

我们可以假设 $x$ 的稀疏性先验设计压缩感知方法：

- 稀疏性：$x$ 为 $k$ 稀疏当 $x$ 仅有 $k<<d$ 个非零分量。（$l_0$ 范数不大于 $k$）
- 限制等距性质(RIP)：$forall norm(x)_0<=k, exists epsilon in (0,1) "s.t." (1-epsilon) norm(x)_2^2 <= norm(Phi x)_2^2 <= (1+epsilon) norm(x)_2^2$.

若 $Phi$ 满足 RIP，则 $Delta(y)=min norm(x)_1 "s.t." Phi x = y$ 是一个良好的解码器，误差满足 $norm(x-Delta Phi x)_2<=(C dot norm(x)_1)/sqrt(k)$.

利用生成模型可以不必假设信号分量的稀疏性。基于用生成模型 $G$ 建模高维信号的先验分布流形，可以这样设计解码器：
$
Delta(y)=G(z^*), "s.t." z^*=arg min_(z) (norm(Phi G(z)-y)_2^2 +lambda norm(z)_2^2)
$
使用生成模型进行建模依赖于生成模型的表达能力。

= 11 SGD 随机梯度下降

随机梯度下降系列算法目前研究的方向可以分为这四大类：
1. Variance Reduction 技术：尽可能缩减随机采样梯度的方差；SAG, SVRG, SAGA 等。
2. 动量法：解决梯度方向来回震荡的问题；Nesterov 加速等。
3. 自适应算法：对不同参数自适应调整学习率；AdaGrad, RMSProp（均方根传播）。
4. 二阶优化方法：基本上没什么人用，只在学术界出现；Hessian 矩阵求逆太慢了（计算量大）；近似又会引入误差，抵消了二阶微分引入的修正；claim 的优势是不受鞍点影响，但实际上动量法、自适应法也能解决。

目前影响力最广泛的算法是结合 2 和 3 的思想提出的 Adam 优化器 (2015)。2024 年 Keller Jordan 在博客中提出了 MUON 算法，

回顾一下问题背景。我们先形式化一下机器学习想解决的问题：

$
"Input Space" X &->^(h in H) "Output Space" Y \
{x_1, x_2, ..., x_n} &|->^h {1, 2, ..., k}
$

其中有误差情形 $h(x)->j$. 误差分为三部分
$
"Error"(h)=E_"Approx"+E_"generalization"+E_"train"
$

其中 $E_"Approx"$ 是模型的近似误差（函数空间 $H$ 自身的缺陷），$E_"generalization"$ 是泛化误差（模型对训练集 $P$ 外数据分布估计的误差，也取决于函数空间的 VC 维），$E_"train"$ 是训练误差（训练方法造成的误差）。SGD 主要关注的是训练误差的优化。

由于随着函数空间变得复杂时，函数空间会变大从而近似误差会增加，但是 VC 维也会增加，使得泛化误差增大，因此近似误差和泛化误差之间（在 VC 维理论上）存在 trade-off。但是这一 trade-off 在当前的深度学习理论中并不清晰，存在许多实际应用中的反例。

例子有线性回归、逻辑回归、神经网络等。

为了保证梯度下降符合预期，人们提出了各种正则化策略，如 Ridge Regression（L2 正则化，=Weight Decay，解决多重共线性问题），Lasso 正则化（L1 正则化）。这些正则化策略能惩罚大的系数，让模型不仅尽可能拟合数据，还要尽量简单（“奥卡姆剃刀”），以减少过拟合风险。可以用偏差-方差分解理论解释（将一部分方差转化为偏差），也可以用贝叶斯先验（认为系数不应过大）解释。

一般的梯度下降方法形式为：$h^((0)) in RR^d, h^((k+1)) = h^((k)) - gamma_k nabla f(h^((k)))$，终止条件为 $norm(nabla f(h^((k)))) < epsilon$（注意该终止条件在一些鞍点上也被满足，这是非预期的情形）。其收敛依赖于 Lipschitz 假设和强凸性。

- SGD $ theta_(t+1)=theta_t - eta dot g_t $ 直接沿着最速梯度下降方向更新。缺陷是容易在鞍点震荡、对全局学习率敏感。
- Momentum $ v_0=0, quad v_t=gamma v_(t-1)+eta dot g_t,quad theta_(t+1)=theta_t - v_t $ 引入了动量（惯性）机制，以减少方向上的震荡、达到更稳定的优化，解决了鞍点及震荡的问题。
- Adagrad $ G_t=G_(t-1)+g_t dot.o g_t ,quad theta_(t+1)=theta_t - eta/sqrt(G_t + epsilon) dot.o g_t $ 引入了自适应学习率机制，通过累积历史梯度的平方来调整每个参数的学习率，适合稀疏数据，但可能导致学习率过早衰减。
- RMSProp $ v_1=g_0 dot.o g_0, quad v_t=gamma v_(t-1)+(1-gamma)g_t dot.o g_t,quad theta_(t+1)=theta_t - eta/sqrt(v_t + epsilon) dot.o g_t $ 引入了指数加权移动平均机制，使得算法只受近期梯度幅度影响，解决了 Adagrad 学习率过早衰减的问题，适合非平稳目标。
- Adam $ m_0=0,quad v_0=0, quad \ m_t=beta_1 m_(t-1)+(1-beta_1)g_t,quad v_t=beta_2 v_(t-1)+(1-beta_2)g_t dot.o g_t,\ hat(m)_t=m_t/(1-beta_1^t),quad hat(v)_t=v_t/(1-beta_2^t),\ theta_(t+1)=theta_t - eta/sqrt(hat(v)_t + epsilon) dot.o hat(m)_t $ 结合了 动量 + 自适应缩放 + 偏置校正机制，适用于大多数优化问题，具有较快的收敛速度和较好的性能表现。
