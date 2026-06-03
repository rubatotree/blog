#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "大数据算法 课程总结笔记 I（期末部分）",
  date: datetime(year: 2026, month: 6, day: 3),
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

这是我在 2026 年春季于中科大学习#link("https://hu-ding.github.io/index.html", "丁虎")老师的#link("https://hu-ding.github.io/data%20course_2026.html","《大数据算法》")课程时整理的期末考试复习笔记。非常喜欢的好课。

= VC 维，核心集

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