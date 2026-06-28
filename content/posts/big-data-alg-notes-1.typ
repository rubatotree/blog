
#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "大数据算法 课程总结笔记 I（章节笔记）",
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

#let inner(a, b) = $chevron.l #a, #b chevron.r$
#let outer(a, b)= $#a and #b$

这是我在 2026 年春季于中科大学习#link("https://hu-ding.github.io/index.html", "丁虎")老师的#link("https://hu-ding.github.io/data%20course_2026.html","《大数据算法》")课程时整理的期末考试复习笔记。非常喜欢的好课。只是可惜讲义编写得比较潦草。这里的笔记尽可能指出讲义中各种概念的几何意义与机器学习意义，并尝试找出各种定义、定理的动机。

= 0 近似算法

本课程中的算法大多是用近似算法解决精确求解较为困难的问题，因此要定义一些概念对算法的误差进行衡量。

一方面，算法的求解结果可能是有误差的。我们定义 $rho"-"$近似算法，其中 $rho>=1$ 为近似比：
- 对于最小化问题、任意输入实例 $I$，$"ALG"(I)<=rho "OPT"(I)$；
- 对于最大化问题、任意输入实例 $I$，$"OPT"(I)<=rho "ALG"(I)$。
由此可以定义这些较强的概念：
- 多项式时间近似方案（PTAS）：对任意 $epsilon>0$，都能给出多项式时间的 $(1+epsilon)"-"$近似算法。
- 完全多项式时间近似方案（FPTAS）：运行时间是关于输入和 $1/epsilon$ 的多项式。

另一方面，算法的求解结果达到期望精度可能是一个随机事件。我们通常希望算法的成功率至少为常数级别（不随输入规模增长而收敛至 0），若未能达到则需要重复多次算法。

除此之外，一些算法可能还需要对输入实例存在一些较好的假设条件，例如良好分离性、平滑分析、扰动弹性等，或能适应更坏的现实条件（分布式、流式等）。

因此本课程中对算法的分析目标通常是：在（计算模型）中，对于（假设）下的输入实例 $I$，算法能在（时间）内以（概率）输出一个 $(rho)"-"$近似解。这也是本课程与分析误差-数值精度/迭代次数关系的数值计算方法课程的不同之处。

为了达到这样的目标，本课程中大部分的证明都是在*研究误差的上界的分布*。

本课程最终的目标是，在*现实条件*假设下，放宽*成功概率*与*近似比*的要求，设计出*高效*、能处理*大规模数据*的算法。

= 1 概率不等式：尾部估计（集中不等式）
== 多项式上界
为了研究误差上界的分布，我们自然希望研究（误差的）概率分布*尾部的上界*，由此我们可以提出一系列多项式上界的概率不等式：
- *Markov 不等式*（一阶估计）：对于非负随机变量 $X$，$Pr(X>=k)<=EE[X]/k$；
- *Chebyshev 不等式*（二阶估计）：对于随机变量 $X$，$Pr(abs(X-EE[X])>=k)<="Var"(X)/k^2$；
这些不等式的成立仅依赖于实分析中积分的定义，不依赖于分布的特征。从另一方面看，这些不等式仅由分布的低阶特征确定，因此比较松。

== 平方指数上界：Chernoff Bound

当我们对分布有了一定先验时，我们可以尝试对分布的上界进行积分以得到更紧的上界。最重要的例子是对于次高斯分布的 *Chernoff 界*：
- 次高斯分布是尾部衰减速度不低于高斯分布 $e^(-x^2\/2)$ 的分布。
- 对于这样的分布尾部，通常能找到一个形如 $Pr(abs(S-mu)>=delta mu)<=e^(-O((delta^2 mu^2)/n))$ 的，被 $e^(-delta^2)$ 控制的上界。这是由高斯分布尾部的积分决定的。
- 从另一个角度看，Chernoff 界是由分布的矩母函数决定的，利用了分布的高阶特征，因此比 Chebyshev 不等式更紧。

Chernoff 界的典型证明方法是取含参指数的期望（即矩母函数）。对 Bernoulli 分布的证明是较重要的例子：

给定 $n$ 个独立的 Bernoulli 随机变量 $X_i$，其中 $Pr(X_i=1)=p_i$，$Pr(X_i=0)=1-p_i$，令 $S=sum_(i=1)^n X_i$，则 $mu=EE[S]=sum_(i=1)^n p_i$。对于任意 $delta>0$，有

$
Pr[S>(1+delta)mu]
=&Pr[e^(lambda S)>e^(lambda (1+delta)mu)]\
<=&e^(-lambda(1+delta)mu) EE[e^(lambda S)] &"（用 Markov 不等式得到矩母函数）"\
=&e^(-lambda(1+delta)mu) product_(i=1)^n EE[e^(lambda X_i)] &"（独立性）"\
=&e^(-lambda(1+delta)mu) product_(i=1)^n (p_i e^lambda + 1-p_i) &"（Bernoulli 分布的矩母函数）"\
<=&e^(-lambda(1+delta)mu) product_(i=1)^n e^(p_i(e^lambda-1)) &"（用 "1+x<=e^x"）"\
=&e^(mu(e^lambda-1))/e^(lambda(1+delta)mu)\
=&(e^delta/(1+delta)^(1+delta))^mu &"（对 "lambda" 求导取最优值）"\
<=&e^(-delta^2/(2+delta) mu)<= e^(-delta^2/3 mu) &"（放缩到性质较好的上界）"
$

我们也可以考虑用 *Hoeffding Lemma* 来证明 Chernoff Bound。这类方法观察到标准高斯分布 $Y~N(0,sigma^2)$ 的矩母函数为 $E[e^(lambda Y)]=e^((lambda^2 sigma^2)/2)$，我们只需要找到一个合适的代理方差 $sigma^2$（有时还要找到系数）使得分布的矩母函数始终不超过代理方差定义的标准高斯分布的矩母函数即可，如以上问题可以取代理方差 $sigma^2 = 1/4$。

上述 Chernoff Bound 的证明依赖于 $1+x<=e^x$ 不等式。除此之外，我们还可以考虑用“最坏情况”作为上界，得到更灵活形式的不等式，如 Hoeffding 系列不等式。不同方法得到的不等式形式通常不同，可以挑选形式较好的使用。

一个重要的不等式 *Hoeffding 不等式*可以得到与均值无关的上界。对于独立的随机变量 $X_i$，其中 $a_i<=X_i<=b_i$，令 $S=sum_(i=1)^n X_i$，则有
$
Pr[abs(S-EE[S])>=t]<=2 exp(-(2 t^2)/(sum_(i=1)^n (b_i-a_i)^2))
$
若我们还有方差信息，我们可以用 *Bernstein 不等式* 来得到更紧的上界。对于独立的随机变量 $X_i$，其中 $EE[X_i]=0$，$abs(X_i)<=M$，令 $S=sum_(i=1)^n X_i$，则有
$
Pr[abs(S_n)>=t]<=2 exp(-(t^2)/(2 sum_(i=1)^n "Var"(X_i)+2 M t\/3))
$
若去掉有界限制，依然存在 Hoeffding 界形式：
$
Pr[abs(S_n)>=t]<=2 exp(-(c t^2)/(sum norm(x_i)^2_"sg")), quad exists c>0
$
其中 $norm(dot)_"sg" = inf{s>0:EE[e^(x^2/s^2)]<=2}$ 为次高斯范数.

有界分布的 Chernoff 界系列常用于误差分析，用估计得到的误差上界得到尽可能紧的分布，因此需要熟练掌握。

== 鞅及其不等式
定义：给定过滤 ${cal(F)_t}_(t>=0)$，随机过程 ${Z_t}_(t>=0)$ 满足：
1. $Z_t$ 可积，且 $Z_t$ 对 $cal(F_t)$ 可测；
2. 对所有 $t>=1$，有 $EE[Z_t|cal(F)_(t-1)]=Z_(t-1)$
则称 ${Z_t}$ 为鞅（martingale）。若不等式改为 $>=$ 或者 $<=$ 则称为下鞅或者上鞅。

对于鞅/下鞅，若满足 $forall i, z_i-z_(i-1) in [a_i, b_i], abs(a_i-b_i)<=c_i$，则有 *Azuma* 不等式：
$
Pr[z_j-z_0<=-t]<=exp(-(2t^2)/(sum_(i=1)^j c_i^2))
$
可以看到这是 Hoeffding 不等式的一种变体。

== 常见概率计算方法及不等式应用

为了计算“多次实验中事件至少发生一次”的概率，我们有 *Union Bound* 方法：
$
Pr(union.big_(i=1)^infinity A_i)<=sum_(i=1)^infinity P(A_i)
$
该不等式可以借助 Venn 图直观理解，即完全不考虑它们相交的部分，并集发生的概率上界情形即每个事件互斥的情形。实质是测度的可数可加性。因此该不等式不需要对事件的独立性、数目、性质做任何假设，非常常用。
- 若在参数 $epsilon$ 下可能发生失败事件 $A_1, ..., A_k$，且要求最终成功概率超过 $1-delta$，则应取合适的 $epsilon$ 使得 $sum_(i=1)^k P(A_i) < delta$.
- 若单次运行失败概率为 $p$，重复 $n$ 次实验后的成功概率应满足 $P("Success")>=1-n p$，从而可以通过重复实验将成功概率控制在常数级别。

= 2 随机算法
== 最大割：MaxCut 算法，带误差放宽

MaxCut 算法将最大割（整数规划）问题放宽为一个半正定规划问题，通过矩阵分解求解后利用半正定规划问题的解随机得到一个性质较好的割。最终可以得到近似比为 0.878 的解。开销主要在做一次 Cholesky 分解。

== 最小割：Karger 算法及其改进，随机背景下的分治

Karger 算法通过随机收缩边得到一个割。单次运行（准确）成功率仅 $2/(n(n-1))$，需要重复 $n^2$ 次达到常数成功率，总时间复杂度 $O(n^4)$. 

Karger 算法比起随机二进制枚举顶点，利用了最小割的性质，将枚举空间从指数级降低到了平方级：对于一个连通图，其最小割的两个子集 $S$ 和 $V\\S$ 在原图中必须各自是连通的。如果其中一方不连通，我们一定可以通过只保留其中一个连通分支，来得到一个边数更少的割。

考虑到 Karger 算法是一个规模逐渐缩小的算法，我们可以考虑试探更多随机分支提高成功率，由此可以设计 Karger-Stein 算法：每次从规模 $abs(V)$ 缩减到规模 $ceil(1+abs(V)/sqrt(2))$ 时做一次分裂，递归计算后取最优解。

由此，发生分裂的次数为 $O(log n)$，第 $k$ 层共有 $2^k$ 支，每支的计算规模为 $n_k=n/(sqrt(2))^k$，每层每支的工作量为 $O(n_k^2)$，综上总计算规模为 $O(n^2 log n)$.

可以递归计算得成功概率为 $Omega(1/log n)$，故常数成功率的时间复杂度为 $O(n^2 log^2 n)$.

== Balls-and-Bins 模型

TODO

== 聚类：k-means 系列算法

- Lloyd 算法：$O(n k d)$，无近似比保证，对初值敏感。
- k-means++：将采样步骤改为按离最近中心平方距离为权重采样。近似比期望 $8 log k$。
- 双准则近似：若允许返回大于 $k$ 个类 $16(k+sqrt(k))=Theta(k)$，可将近似比改进为常数 20。此后再做一次可保证近似比的 k-means 聚类，就可以得到近似比为常数的 k-means 聚类。

TODO：证明

= 3 降维

== PCA 分析
1. 中心化数据
2. 构建协方差矩阵 $Sigma=1/N X^T X$（也可以用 SVD 分解替代避免此步精度损失）
3. 求特征值和特征向量，按特征值从大到小排序，对应的特征向量方向点集方差依次递减，因此可只保留最大的几个特征值。
存在的缺点有：QR 分解复杂度高；数值稳定性不能保证；读写吞吐量大，不能流式处理。

== JL 变换

JL 引理：$forall epsilon in (0,1), exists f: RR^d -> RR^k, k=O(1/epsilon^2 log n)$，使得任意 $RR^d$ 中向量 $x, y$ 满足
$
(1-epsilon)norm(x-y)^2<=norm(f(x)-f(y))^2<=(1+epsilon)norm(x-y)^2
$
给出了一个尽可能保距离的压缩维度下界。接下来我们要尝试构造这样的变换。经典的构造方法是高斯分布随机矩阵：
$
B=1/sqrt(k) A, quad a_(i j) ~ N(0,1), quad A in RR^(k times d)
$
对于 $B$ 中任一列向量 $b_i$：
- 由高斯分布的旋转不变性（做正交变换后加起来仍是高斯分布）可以验证 $b_i$ 的方向均匀分布；
- 由高斯分布方差可验证 $E[norm(b_i)^2]=1$；
- 由变量独立性+高斯分布可乘性可验证 $E[inner(b_i, b_j)]=0$ for $i != j$；
- 利用 Chernoff Bound 可以证明随维数升高长度分布逐渐收紧到 $1$.
因此 $B$ 定义的列向量组几乎是一组朝向随机的正交单位向量组。这样定义的矩阵将点集数据投影到一组高度随机的（几乎）正交基上，可以直观理解 JL 引理定义的情形在大概率下是成立的。

证明方法是研究球面上单位向量变换后长度的分布，求出长度变化量符合要求的概率，再用 Union Bound 计算 $(n(n-1))/2$ 对点均符合要求的概率上界。

#table(columns:3,align:center,[],[JL 变换],[PCA],[Running time],[$Theta(n d (log n)/epsilon^2)$],[$Theta(n d^2)$],[Data],[Data Oblivious（可应用于流数据，并行],[Data Dependent])

除用高斯分布定义外，若考虑别的定义方法并适用以上证明流程，需要保证以下性质：
- 行之间是独立的；
- 投影结果是亚高斯的（保证可以 Chernoff 求上界）；
- 各向同性的二阶归一化（均匀分布的单位向量投影后均值仍为 $0$，长度期望仍为 $1$）。
例如用两点分布或其它稀疏分布定义：
$
A_(i j)=cases(+1 quad &~50%,-1 quad &~50%),quad
A_(i j)=cases(+1 quad &~1/6,0 quad &~2/3,-1 quad &~1/6)
$
为了用稀疏矩阵定义 JL 矩阵以进一步加速，且保证矩阵的隐私、不被 Hack（如对角阵可以被分布在单个轴上的数据 Hack），可以设计 Fast JL 算法，定义 JL 矩阵为 $Theta = P dot H dot D$，其中 $P$ 为稀疏随机矩阵，$H$ 为 Hadamard 变换（正交变换，打散数据），$D$ 为随机取值为 $1,-1$ 的对角矩阵（使得大概率适应大部分数据，防止 Hack）。

- $P in RR^(k times d),quad p_(i j)=cases(N(0,1/q)quad&~q,0quad&~1-q),quad q=min{Theta((log^2 n)/d),1}$
  由此可验证 $P$ 的稀疏性：$norm(P)_0=k dot d dot q =k log^2 n << k d$.
- Hadamard 矩阵可 $d log d$ 地做快速变换，且是正交变换，保证了投影后长度的期望不变。将数据变换到频域，高效打散数据。
- $D in RR^(d times d), D_(i i)=cases(+1 quad &~50%,-1 quad &~50%)$. 要根据 $P$ 的设计构造 Hack 数据必须要知道 $H dot D$，而 $D$ 的信息量避免了这一点。

= 4 近邻查询

精确的近邻查询问题的解决方式通常是空间划分结构，通常存在着难以被数据结构等解决的维数灾难。我们考虑通过放宽精度要求实现性能提升。
 
$(r,R)"-"$近似近邻查询问题定义为：给定 $R^d$ 中集合 $P$ 和点 $q$，要求：
- 当 $"dist"(q,P)<=r$，返回 $u in P$ 使得 $norm(q-u)<=R$；
- 当 $"dist"(q,P)>R$，明确返回 $"dist"(q,P)>r$；
- 当 $r<"dist"(q,P)<=R$，返回任意结果。

当 $R=(1+epsilon)r$ 时，问题也称作 $(1+epsilon)"-"$近似近邻查询。

== 局部敏感哈希

$(r,R,alpha,beta)"-"$Sensitive Hash 定义为：对 $r<R，0<beta<alpha<1$，定义一个哈希映射集合 $F$，使得对 $forall u, q in RR^d$，随机取 $h in F$ 均满足
- $u in B(q,r) => Pr[h(u)=h(q)]>=alpha$；
- $u in.not B(q.R) => Pr[h(u)=h(q)]<=beta$.
典型的构造方式是随机投影并分桶，取多个这样的桶“拼在一起”（串联，对晶格取交集）、建立多张哈希表（并行，对晶格取并集）。

== 乘积量化

把高维空间拆成多个互不重叠的低维子空间，在每个子空间上分别做量化（量化到 k-means 中心），从而在总码长固定时获得更强的表示能力。

TODO

= 5 次线性算法
== 1-median 问题

作二叉树逐层比较加权距离和取最小。通过构造可 $Theta(1)$ 查询的、比较质量参数 $delta'=delta/(log n)$的近似比较 Oracle 并每次比较 $log n$ 次以保证精度，可以在 $O(1/delta^4 n log n)$ 时间内以常数概率找到 $(1+delta)"-"$ 近似解。

Oracle 的定义较复杂，需要分球内外，对球内进行采样并比较，具体流程及证明 TODO。

== 平均距离问题：Indyk 算法

精心设计的蒙特卡洛求和。对于顶点数为 $n$，边数为 $m$ 的度量图，以概率 $s/m$ 对每条边做伯努利采样，对得到的边集求平均距离，就是对全体平均距离的一个良好估计。其中当 $s=a n, a=O(delta^(-7/2))$ 时，该算法为常数概率下，时间复杂度为 $O(n/(delta^(7\/2)))$ 的 $(1+delta)"-"$ 近似算法。

证明方法为利用三角不等式分析边长分布，从而分析蒙特卡洛采样误差。

== k-median

TODO

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

此外，#link("../big-data-alg-notes-2/#loc-30", "作业三第 5 题") 给出了一种基于拉格朗日乘子法的证明。

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
