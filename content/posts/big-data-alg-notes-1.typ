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

= VC 维，核心集

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

= 最优传输

= 分布式算法

= Beyond worst case analysis

= SGD 随机梯度下降

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