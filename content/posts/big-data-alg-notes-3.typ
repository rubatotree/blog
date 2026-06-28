#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "大数据算法 课程总结笔记 III（作业及个人答案）",
  date: datetime(year: 2026, month: 6, day: 27),
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

#let inner(a, b) = $angle.l #a, #b angle.r$
#let note(body) = block(
    stroke: rgb(230, 180, 165),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
  )[
    #set text(size: 0.9em)
    *Note: *
    #h(0.75em)
    #body
  ]

#let aa = $bold(a)$
#let bb = $bold(b)$
#let cc = $bold(c)$
#let dd = $bold(d)$
#let ee = $bold(e)$
#let ff = $bold(f)$
#let gg = $bold(g)$
#let nn = $bold(n)$
#let mm = $bold(m)$
#let pp = $bold(p)$
#let qq = $bold(q)$
#let uu = $bold(u)$
#let vv = $bold(v)$
#let ww = $bold(w)$
#let rr = $bold(r)$
#let ss = $bold(s)$
#let tt = $bold(t)$
#let xx = $bold(x)$
#let yy = $bold(y)$
#let zz = $bold(z)$
#let b0 = $bold(0)$
#let Var = "Var"
#let f1 = $"I"$
#let f2 = $"II"$
#let aalpha = $bold(alpha)$
#let bbeta = $bold(beta)$
#let ggamma = $bold(gamma)$
#let interior(a, b) = $chevron.l #a, #b chevron.r$
#let exterior(a, b)= $#a and #b$
#let inner(a, b) = $chevron.l #a, #b chevron.r$
#let outer(a, b)= $#a and #b$
#let splitline = line(length: 100%, stroke: rgb(200, 200, 210))

= 作业一

== 作业一 第1题

#image("/images/big-data-alg-notes/hw1-q1.png", width: 90%)

=== 解答

这里的趋近符号似乎含义没有标识清楚，这里默认为是当 $n$ 趋近于无穷大时的极限关系。

由 Chebyshev's Inequality $PP(abs(X-EE[X])>=k)<=Var(X)/k^2$ 得

$
0<=
PP(abs(overline(Z))>=t)
=PP(abs(overline(Z)-EE(Z_i))>=t)
=PP(abs(overline(Z)-EE(overline(Z)))>=t)
<=Var(overline(Z))/t^2=Var(Z_i)/(n t^2)
$

综上 $lim_(n->infinity) Var(Z_i)/(n t^2)=0, forall t>0,Var(Z_i)<infinity $，由夹逼定理得 $lim_(n->infinity) PP(abs(overline(Z))>=t)=0$.

== 作业一 第2题

#image("/images/big-data-alg-notes/hw1-q2.png", width: 90%)

=== 解答

记 $X_t=sum_(i=1)^t (Z_i-EE[Z_i]), t>=0$，则由$Z_i-EE[Z_i]$ 有界且期望为 $0$，结合课上推论有 $X_t$ 是一个鞅。

由 Azuma 不等式及其反向版本，结合条件
$
X_t-X_(t-1)=Z_i - EE[Z_i] in [a-EE[Z_i], b-EE[Z_i]],quad abs((b-EE[Z_i])-(a-EE[Z_i]))<=(b-a)
$
可得
$
PP(1/n sum_(i=1)^n (Z_i-EE[Z_i])<=-t)
=&PP(sum_(i=1)^n (Z_i-EE[Z_i])<=-n t)
=PP(X_t-X_0<=-n t)\
<=&exp(-(2(n t)^2)/(sum_(i=1)^n (b-a)^2))=exp(-(2 n t^2)/(b-a)^2)
\
PP(1/n sum_(i=1)^n (Z_i-EE[Z_i])>=t)
=&PP(sum_(i=1)^n (Z_i-EE[Z_i])>=n t)
=PP(X_t-X_0>=n t)\
<=&exp(-(2(n t)^2)/(sum_(i=1)^n (b-a)^2))=exp(-(2 n t^2)/(b-a)^2)
$
题中不等式即证。

== 作业一 第3题

#image("/images/big-data-alg-notes/hw1-q3.png", width: 90%)

=== 解答

$
mu
=1/n sum_(i=1)^n x_i
=1/n sum_(j=1)^k sum_(x in A_j) x
=1/n sum_(j=1)^k m_j mu_A_j
$
$
x-mu
=x-1/n sum_(j=1)^k m_j mu_A_j
=(1/n sum_(j=1)^k m_j)x-1/n sum_(j=1)^k m_j mu_A_j
=1/n sum_(j=1)^k m_j (x-mu_A_j)
$
$
Phi(A_1,...,A_k)
=&sum_(j=1)^k sum_(x in A_j) norm(x-mu_A_j)^2
=sum_(j=1)^k sum_(x in A_j) norm((x-mu)-(mu_A_j-mu))^2\
=&sum_(j=1)^k (sum_(x in A_j) norm(x-mu)^2 -m_j norm(mu_A_j-mu)^2)
=sum_(i=1)^n norm(x_i-mu)^2 -sum_(j=1)^k m_j norm(mu_A_j-mu)^2
$
则 $EE[Phi(A_1,...,A_k)]=sum_(i=1)^n norm(x_i-mu)^2 - EE[sum_(j=1)^k m_j norm(mu_A_j-mu)^2]$，即只需证明新聚类的加权中心偏离程度的期望等于原数据的平均偏离程度乘以 $(k-1)/(n-1)$。
$
1/(k-1) EE[sum_(j=1)^k m_j norm(mu_A_j-mu)^2]
=& 1/(k-1) sum_(j=1)^k m_j EE[norm(mu_A_j-mu)^2]\
=& 1/(k-1) sum_(j=1)^k m_j (n-m_j)/(n-1) dot 1/m_j dot 1/n sum_(i=1)^n  norm(x_i-mu)^2\
=& 1/(k-1) (sum_(j=1)^k (n-m_j)/(n-1)) dot 1/n sum_(i=1)^n norm(x_i-mu)^2\
=&1/(n-1) sum_(i=1)^n norm(x_i-mu)^2
$
其中 $EE[norm(mu_A_j-mu)^2]$ 的拆分来自不放回抽样得到样本均值的方差公式
$Var(mu_A_j)=(n-m_j)/(n-1) dot Var(x)/m_j$. 综上
$
EE[Phi(A_1,...,A_k)]
=&sum_(i=1)^n norm(x_i-mu)^2 - EE[sum_(j=1)^k m_j norm(mu_A_j-mu)^2]=sum_(i=1)^n norm(x_i-mu)^2-(k-1)/(n-1) sum_(i=1)^n norm(x_i-mu)^2\
=&(n-k)/(n-1) sum_(i=1)^n norm(x_i-mu)^2
$

== 作业一 第4题

#image("/images/big-data-alg-notes/hw1-q4-1.png", width: 90%)
#image("/images/big-data-alg-notes/hw1-q4-2.png", width: 90%)

=== 解答

$
10/epsilon.alt phi.alt_X (C_"opt")
<=&phi.alt_X (S_(i-1))=sum_(A_j in"Good"_i) phi.alt_A_j (S_(i-1))+sum_(A_j in"Bad"_i) phi.alt_A_j (S_(i-1))\
<=& 10 sum_(A_j in"Good"_i) phi.alt_A_j (C_"opt")+sum_(A_j in"Bad"_i) phi.alt_A_j (S_(i-1))\
<=& 10 phi.alt_X (C_"opt")+sum_(A_j in"Bad"_i) phi.alt_A_j (S_(i-1))
$
$
=>& sum_(A_j in"Bad"_i) phi.alt_A_j (S_(i-1))>=(1/epsilon.alt-1)dot 10 phi.alt_X (C_"opt")

\
=>& PP(c_i in "Bad"_i)=1/(1+(sum_(A_j in"Good"_i) phi.alt_A_j (S_(i-1)))/(sum_(A_j in"Bad"_i)phi.alt_A_j (S_(i-1))))
>=& 1/(1+(10 phi.alt_X (C_"opt"))/((1/epsilon.alt-1)dot 10 phi.alt_X (C_"opt")))=1/(1+1/(1/epsilon.alt-1))=1-epsilon.alt
$

== 作业一 第5题

#image("/images/big-data-alg-notes/hw1-q5.png", width: 90%)

=== 解答

我们先研究 $norm(B x)^2, forall x in RR^d, norm(x)=1$ 的分布情况. 记 $y=B x in RR^k$，则 $y_i=sum_(j=1)^d B_(i j) x_j$.

由 Gaussian 分布的线性组合性质有 $y_i ~ cal(N)(0, sigma^2)$，对于方差可计算得
$
sigma^2=sum_(j=1)^d x_j^2 sigma&^2_B_(i j) =sum_(j=1)^d x_j^2 dot 1/k=1/k
$
因此 $y$ 的每个分量都独立采样自 $ cal(N)(0, 1/k)$，满足引理条件，由引理得

$
PP(abs(norm(B x)-1)>=epsilon)<=2 exp (-(epsilon^2 k)/8)
$

采用 Union bound 技术处理，题中点对的总数为 $N(N-1)/2$，得

$
PP(abs(norm(B (v_i-v_j)/norm(v_i-v_j))^2-1)>=epsilon, exists {i, j})
<=& sum_(i<j) PP(abs(norm(B (v_i-v_j)/norm(v_i-v_j))^2-1)>=epsilon)\
=& N(N-1) exp (-(epsilon^2 k)/8)
<= N^2 exp (-(epsilon^2 k)/8)
$

综上，
$
&PP((1-epsilon)norm(v_i-v_j)^2<=norm(B v_i-B v_j)^2<=(1+epsilon)norm(v_i-v_j)^2, forall {i, j})\
=&1-PP(abs(norm(B (v_i-v_j)/norm(v_i-v_j))^2-1)>=epsilon, exists {i, j})\
<=& 1-N^2 exp (-(epsilon^2 k)/8)
<= 1-N^2 exp (-(epsilon^2 dot (32 log N)/epsilon^2)/8)\
=&1-1/N^2
$

= 作业二

== 作业二 第1题

#image("/images/big-data-alg-notes/hw2-q1.png", width: 90%)

=== 解答

$k=0$ 时的情形：全空间都被投影到一个点上 $pi(p)equiv x, forall p in RR^d$. 因此只需要优化
$
sum_(i=1)^n norm(p_i-x)_2^2=sum_(i=1)^n norm(p_i)_2^2-2x^T sum_(i=1)^n p_i + n norm(x)_2^2
$
由二次函数的性质可知，最优解为 $x=1/n sum_(i=1)^n p_i$，即重心.

$k=1$ 时的情形：全空间被投影到一条直线上 $pi(p)= x+t v, forall p in RR^d$，其中 $v$ 为单位向量.
$
E=sum_(i=1)^n norm(p_i-(x+t_i v))_2^2
=sum_(i=1)^n (norm(p_i-x)_2^2-inner(p_i-x, v)^2)
$
对 $x$ 求导得
$
(partial E)/(partial x)=-2 sum_(i=1)^n (p_i-x-inner(p_i-x, v) v)=-2 n (1/n sum_(i=1)^n p_i-x)+2  n inner(1/n sum_(i=1)^n p_i-x, v) v
$
可得最优解为 $x=1/n sum_(i=1)^n p_i$，即重心.

== 作业二 第2题

#image("/images/big-data-alg-notes/hw2-q2.png", width: 90%)

=== 解答

$
&Pr[h(v_1)=h(v_2)]
=Pr[floor((inner(v_1,V_h)+t_h)/T)=floor((inner(v_2,V_h)+t_h)/T)]
<=Pr[abs((inner(v_1,V_h)+t_h)/T-(inner(v_2,V_h)+t_h)/T)<1]\
=&Pr[abs(inner(v_1-v_2,V_h))<T]
 =Pr[-T<=inner(v_1-v_2,V_h)<T]
 =Pr[-T/norm(v_1-v_2)_2<=inner((v_1-v_2)/norm(v_1-v_2)_2,V_h)<T/norm(v_1-v_2)_2]
$
由正态分布可加性有 $inner((v_1-v_2)/norm(v_1-v_2)_2,V_h) ~ N(0,norm((v_1-v_2)/norm(v_1-v_2)_2)_2)=N(0,1)$，因此概率上界与距离负相关，即

$ Pr[h(v_1)=h(v_2)]<=2Phi(T/norm(v_1-v_2)_2)-1. $

== 作业二 第3题

#image("/images/big-data-alg-notes/hw2-q3-1.png", width: 90%)
#image("/images/big-data-alg-notes/hw2-q3-2.png", width: 90%)

=== 解答

*(1)* 这是考试题。由于对量化误差上界的限制，考虑先固定量化中心 $c_s, c_t$. 则 $q_i, u_i$ 的取值范围为以 $c^i_s_i, c^i_t_i$ 为球心、半径为 $eta$ 的闭球内部. 由几何性质有在每个子空间中 $q, c_s, c_t, u$ 的投影都依次共线且 $norm(c_s-c_t)_2$ 取最大值 $L$ 时平方距离差取到上界，因此全空间中
$
max abs(norm(u-q)_2^2-hat(d)(q,u))
= abs(sum_(i=1)^m (norm(u_i-q_i)_2^2-norm(c_t_i-c_s_i)_2^2))
= abs(sum_(i=1)^m ((2eta-L)^2-L^2))
= 4 m eta L+4 m eta^2
$

即得证.

*(2)*
$
hat(d)(q,u)
<=&norm(q-u)_2^2+(4 m eta L+4 m eta^2)
<norm(q-v)_2^2-Delta+(4 m eta L+4 m eta^2)\
<=&norm(q-v)_2^2-(4 m eta L+4 m eta^2)<=hat(d)(q,v)
$
要使得以上不等式链成立只需使得 $8m eta(L+eta)<=Delta$.

所以为了在量化后保证近邻关系不被破坏，需要通过增加量化中心个数以降低 $L$、增加中心并优化算法提升量化精度以降低 $eta$、或或在保证 $eta$ 和 $L$ 的前提下降低量化后维度 $m$ 来取舍.

== 作业二 第4题

#image("/images/big-data-alg-notes/hw2-q4.png", width: 81%)

=== 解答

#let cost="cost"
#let OPT="OPT"

*(1)* 由不放回抽样事件之间的独立性有
$
EE[cost_S (C)]=1/s EE[sum_(v in S) d(v,c)]=EE_(v in V)[d(v,c)]=cost_V (C)
$
因此由 Hoeffding 不等式有对已知的 $C$，
$
Pr[abs(cost_S (C)-cost_V (C))>epsilon]
=&Pr[abs(1/s sum_(v in S) d(v,c)-EE_(v in V)[d(v,c)])>epsilon]
<=2exp(-(2 s epsilon^2)/Delta^2)\
<=& 2exp(-(2 epsilon^2)/Delta^2 dot (Delta^2/(2 epsilon^2) (k ln n+ln 2/delta)))=delta/n^k
$
由 Union Bound 对任意的 $C subset.eq V, abs(C)=k$，有失败事件
$
Pr[exists C, abs(cost_S (C)-cost_V (C))>epsilon]<= n^k dot delta/n^k=delta
$
因此 $Pr[forall C, abs(cost_S (C)-cost_V (C))<=epsilon]>=1-delta$，得证.

*(2)* 记 $C^*=arg min_(C subset.eq V, abs(C)=k) cost_S (C)$. 将上一问的高概率条件应用在 $C_S, C^*$ 上得

$
cost_V (C_S)<=cost_S (C_S)+epsilon
<=alpha cost_S (C^*)+epsilon
<=alpha (cost_V (C^*)+epsilon)+epsilon
<=alpha OPT+(alpha+1)epsilon.
$

= 作业三

== 作业三 第1题

#image("/images/big-data-alg-notes/hw3-q1.png", width: 90%)

=== 解答

#let cost = "cost"
$
&sum_(q_i in (S_1 union S_2)) (w_1+w_2)(q_i) dot cost(q_i,c)\
=&sum_(q_i in (S_1 \\ S_2)) w_1(q_i) dot cost(q_i,c)
+sum_(q_i in (S_2 \\ S_1)) w_2(q_i) dot cost(q_i,c)
+sum_(q_i in (S_2 inter S_1)) (w_1(q_i)+w_2(q_i)) dot cost(q_i,c)\
=&sum_(q_i in S_1) w_1(q_i) dot cost(q_i,c)
+sum_(q_i in S_2) w_2(q_i) dot cost(q_i,c)
$
同理，$f(A_1,c)+f(A_2,c)=f(A_1 union A_2,c)$.

将 $(S_1,w_1),(S_2,w_2)$ 满足的 coreset 不等式相加得到
$
(1-epsilon)f(A_1 union A_2,c) <= sum_(q_i in (S_1 union S_2)) (w_1+w_2)(q_i) dot cost(q_i,c) <= (1+epsilon)f(A_1 union A_2,c)
$
因此 $(S_1 union S_2, w_1+w_2)$ 是 $A_1 union A_2$ 的一个 $(k,epsilon)"-coreset"$.

== 作业三 第2题

#image("/images/big-data-alg-notes/hw3-q2.png", width: 90%)

=== 解答

合并两个 $(k,gamma)"-coreset" S_1, S_2$ 并再计算一个 $(k,gamma)"-coreset" S_3$得到的结果满足：
$
v(C,S_3) in [(1-gamma)dot v(C,S_1 union S_2), (1+gamma)dot v(C,S_1 union S_2)]
subset [(1-gamma)^2 dot v(C,P), (1+gamma)^2dot v(C,P)]
$
递归地计算可以得到根节点得到的带权集合 $S$ 满足
$
v(C,S) in [(1-gamma)^(L+1) dot v(C,P), (1+gamma)^(L+1) dot v(C,P)]
=[(1-gamma)^(L+1) dot v(C,P), (1+eta) dot v(C,P)]
$
由二项式定理容易证明 $(1-gamma)^(L+1)>=1-eta=2-(1+gamma)^(L+1)$，综上满足 $v(C,S) in [(1-eta) dot v(C,P), (1+eta) dot v(C,P)]$，根节点集合是 $P$ 的 $(k,eta)"-coreset"$.

进一步证明：

$eta=(1+gamma)^(L+1)-1<=e^((L+1)gamma)-1<=2(L+1)gamma<=epsilon$，因此此时根节点集合是 $P$ 的 $(k,epsilon)"-coreset"$.

== 作业三 第3题

#image("/images/big-data-alg-notes/hw3-q3.png", width: 90%)

=== 解答

#let VC = "VC"

下界：
对于六个点 $P_(-x)(-1,0,0), P_(+x)(1,0,0), P_(-y)(0,-1,0), P_(+y)(0,1,0), P_(-z)(0,0,-1), P_(+z)(0,0,1)$，设置它们的正负类为 $C_(-x), C_(+x), C_(-y), C_(+y), C_(-z), C_(+z)$.

则我们总能构造出一个符合条件的范围：

$ a=-1-C(-x)/2,b=1+C(+x)/2,c=-1-C(-y)/2,d=1+C(+y)/2,e=-1-C(-z)/2,f=1+C(+z)/2 $

因此 $"VC"(D)>=6$.

上界：
对于任意七个点的集合分布，考虑设置在三个坐标轴上取最大、最小值的点为正类，则剩余一个负类点 $P_-$。由于 $P_-$ 一定位于其它点的轴对齐包围盒中，而轴对齐包围盒一定是满足正类条件的 $D$ 的子集，因此 $P_-$ 无法被正确分类，因此无法实现七个点的任意划分，$"VC"(D)<7$.

综上 $"VC"(D)=6$.

== 作业三 第4题

#image("/images/big-data-alg-notes/hw3-q4-1.png", width: 90%)
#image("/images/big-data-alg-notes/hw3-q4-2.png", width: 90%)

=== 解答

#let KL = "KL"
$
KL(P||x y^T)
=&sum_(i,j) P_(i,j) log (P_(i,j)/(x_i y_j))
=sum_(i,j) P_(i,j) log P_(i,j)-sum_(i,j) P_(i,j) log x_i - sum_(i,j) P_(i,j) log y_j\
=&-h(P)-sum_(i) (P 1)_i log x_i- sum_(j) (P^T 1)_j log y_j\
=&-h(P)-sum_(i) x_i log x_i- sum_(j) y_j log y_j\
=&-h(P)+h(x)+h(y)
$
#note[三角不等式：这里的 $P$ 对应一个"搬运"操作。把信息从 $x$ 搬运到 $y$，再搬运到 $z$，开销一定比直接搬运到 $z$ 更大。]
定义 $P^(x y)$ 为 $x$ 到 $y$ 的最优传输多面体，即 $d_(M,alpha)(x,y)=inner(P^(x y), M)$，$P^(y z), P^(x z)$ 同理。构造
$
P_(i j k)=P^(x y)_(i j) y_j^(-1) P^(y z)_(j k),quad Q=(sum_j P_(i j k))_(i k)=P^(x y) "diag"(y_1^(-1),...,y_n^(-1)) P^(y z)
$
易验证 $Q in U(x,z)$. 接下来证明 $Q in U_alpha (x,z)$.

用对数和不等式可得
$
sum_j P_(i j k) log (P_(i j k)/(x_i P^(y z)_(j k)))>=Q_(i k)log (Q_(i k)/(x_i z_k))
$
再逐项求和即得 $sum_(i j k)P_(i j k) log (P_(i j k)/(x_i P^(y z)_(j k)))>=KL(Q||x z^T)$. 而对左式的操作为
$
sum_(i j k)P_(i j k) log (P_(i j k)/(x_i P^(y z)_(j k)))
=&sum_(i j k)P_(i j k) log ((P^(x y)_(i j) y_j^(-1) P^(y z)_(j k))/(x_i P^(y z)_(j k)))
=sum_(i j) (sum_k P_(i j k)) log ((P^(x y)_(i j))/(x_i y_j))\
=&sum_(i j) P^(x y)_(i j) y_j^(-1) (sum_k P^(y z)_(j k)) log ((P^(x y)_(i j))/(x_i y_j))
=sum_(i j) P^(x y)_(i j) log ((P^(x y)_(i j))/(x_i y_j))\
=&KL(P^(x y)||x y^T)
$
综上 $KL(Q||x z^T)<=KL(P^(x y)||x y^T)<=alpha, Q in U_alpha (x,z)$.

最后
$
d_(M,alpha)(x,z)=&min_(P in U_alpha (x,z)) inner(P,M) <= inner(Q,M)
=sum_(i j k) P^(x y)_(i j) y_j^(-1) P^(y z)_(j k) m_(i k)
<=sum_(i j k) P^(x y)_(i j) y_j^(-1) P^(y z)_(j k) (m_(i j)+m_(j k))\
=&sum_(i j k) P^(x y)_(i j) y_j^(-1) P^(y z)_(j k) m_(i j)+sum_(i j k) P^(x y)_(i j) y_j^(-1) P^(y z)_(j k) m_(j k)
=sum_(i j) P^(x y)_(i j)m_(i j)+sum_(j k) P^(y z)_(j k) m_(j k)\
=&inner(P_(x y), M)+inner(P_(y z), M)=d_(M,alpha)(x,y)+d_(M,alpha)(y,z)
$
因此 $d_(M,alpha)$ 满足三角不等式。

#note[非严格度量：在信息传输存在干扰的条件下，保持信息不变也需要开销，因此原地不动的开销不一定为零。]
我们找到一个反例，不难验证以下 $M,x$ 符合要求：
$
M=mat(0,1;1,0),quad x=vec(0.5,0.5),quad alpha=1/2 log 2\
$
假设 $d_(M,alpha)(x,x)=0 <=> exists P in U_alpha (x,x), inner(P,M)=P_12+P_21=0$.

结合 $P_(i j)>=0$ 的要求有 $P_12=P_21=0$.
结合搬运条件 $P 1=P^T 1=x$ 有 $P=mat(0.5,0;0,0.5)$ 唯一.

但 $KL(P||x x^T)= 2 times 0.5 times log (0.5 / (0.5 times 0.5))=log 2 >alpha, P in.not U_alpha (x,x)$，矛盾。

因此 $d_(M,alpha)(x,x)>0$，$d_(M,alpha)$ 不是一个严格度量。

== 作业三 第5题

#image("/images/big-data-alg-notes/hw3-q5.png", width: 90%)

=== 解答

- 目标函数 $J(P)=inner(P,C)+lambda sum_(i,j) P_(i j) (log P_(i j)-1)$
- 行和约束 $sum_j P_(i j)=r_i$
- 列和约束 $sum_i P_(i j)=c_j$

由此写出拉格朗日函数
$
cal(L)(P, alpha, beta)=&inner(P,C)+lambda sum_(i,j) P_(i j) (log P_(i j)-1)+sum_i alpha_i (r_i-sum_j P_(i j))+sum_j beta_j (c_j-sum_i P_(i j))
$
$
(dif cal(L))/(dif P_(i j))=C_(i j)+lambda log P_(i j)-alpha_i-beta_j=0
=> P_(i j)=e^(alpha_i\/lambda) dot e^(-C_(i j)\/lambda) dot e^(beta_j\/lambda)
$
令
$
u_i=e^(alpha_i\/lambda),quad v_j=e^(beta_j\/lambda),quad K_(i j)=e^(-C_(i j)\/lambda)
$
即得最优化解满足 Sinkhorn 形式.

= 作业四

== 作业四 第1题

#image("/images/big-data-alg-notes/hw4-q1.png", width: 90%)

=== 解答

中心化的一轮更新为
$
r^((t+1))(v)=(1-alpha)/n+alpha sum_((u,v) in E) (r^((t))(u))/(d^+(u))
$
由于求和中项可交换，可验证 MapReduce 的实现是和中心化一致的。

分布式情形下，对于每条跨机器边，需要传输 $L$ bits 的信息，因此一轮迭代中需要跨机器传输的通信量为 $m_"cross" dot L$，由此降低 $m_"cross"$ 可以减少每轮迭代的通信负担，降低通信瓶颈。

== 作业四 第2题

#image("/images/big-data-alg-notes/hw4-q2.png", width: 90%)

=== 解答

由每个分量之间的独立性
$
EE y_i (j)=(x_i (j)-a_i)/(b_i-a_i)b_i+(1-(x_i (j)-a_i)/(b_i-a_i))a_i=x_i (j) => EE y_i=x_i
$
$
EE(y_i (j)-x_i (j))^2=EE(y_i (j)-EE y_i (j))^2=EE(y_i (j)-x_i (j))^2=(b_i-x_i (j))(x_i (j)-a_i)
$
由不同分布式服务器的独立性假设可证
$
EE hat(x)=EE(n^(-1)sum_(i=1)^n y_i)=n^(-1)sum_(i=1)^n EE(y_i)=n^(-1)sum_(i=1)^n x_i=overline(x)
$
$
EE norm(hat(x)-overline(x))^2_2=&EE norm(n^(-1)sum_(i=1)^n (y_i-x_i))^2_2<=n^(-2)sum_(i=1)^n EE norm(y_i-x_i)^2_2=n^(-2)sum_(i=1)^n sum_(j=1)^d EE(y_i (j)-x_i (j))^2\
=&n^(-2)sum_(i=1)^n sum_(j=1)^d (b_i-x_i (j))(x_i (j)-a_i)<=(4n^2)^(-1)sum_(i=1)^n d(b_i-a_i)^2
$
直接上传所有梯度的通信量为 $n d L$，上传二值量化后的通信量为 $n dot (2L+d)$，优化了一个因子.

== 作业四 第3题

#image("/images/big-data-alg-notes/hw4-q3.png", width: 90%)

=== 解答

- SGD $ theta_(t+1)=theta_t - eta dot g_t $ 直接沿着最速梯度下降方向更新。缺陷是容易在鞍点震荡、对全局学习率敏感。
- Momentum $ v_0=0, quad v_t=gamma v_(t-1)+eta dot g_t,quad theta_(t+1)=theta_t - v_t $ 引入了动量（惯性）机制，以减少方向上的震荡、达到更稳定的优化，解决了鞍点及震荡的问题。
- Adagrad $ G_t=G_(t-1)+g_t dot.o g_t ,quad theta_(t+1)=theta_t - eta/sqrt(G_t + epsilon) dot.o g_t $ 引入了自适应学习率机制，通过累积历史梯度的平方来调整每个参数的学习率，适合稀疏数据，但可能导致学习率过早衰减。
- RMSProp $ v_1=g_0 dot.o g_0, quad v_t=gamma v_(t-1)+(1-gamma)g_t dot.o g_t,quad theta_(t+1)=theta_t - eta/sqrt(v_t + epsilon) dot.o g_t $ 引入了指数加权移动平均机制，使得算法只受近期梯度幅度影响，解决了 Adagrad 学习率过早衰减的问题，适合非平稳目标。
- Adam $ m_0=0,quad v_0=0, quad \ m_t=beta_1 m_(t-1)+(1-beta_1)g_t,quad v_t=beta_2 v_(t-1)+(1-beta_2)g_t dot.o g_t,\ hat(m)_t=m_t/(1-beta_1^t),quad hat(v)_t=v_t/(1-beta_2^t),\ theta_(t+1)=theta_t - eta/sqrt(hat(v)_t + epsilon) dot.o hat(m)_t $ 结合了 动量 + 自适应缩放 + 偏置校正机制，适用于大多数优化问题，具有较快的收敛速度和较好的性能表现。

== 作业四 第4题

#image("/images/big-data-alg-notes/hw4-q4.png", width: 90%)

=== 解答

*(1)*
$
nabla R(theta)
=&nabla_theta EE_(z ~ p_theta (z))[R(z)]
=nabla_theta integral_(RR^d) R(z) p_theta (z) dif z
=integral_(RR^d) R(z) nabla_theta p_theta (z) dif z\
=&integral_(RR^d) (R(z) nabla_theta log p_theta (z)) p_theta (z) dif z
=EE_(z ~ p_theta (z))[R(z) nabla_theta log p_theta (z)]
$
由此近似目标函数梯度的一个无偏估计为 $R(z) nabla log p_theta (z)$，参数更新形式为
$
theta_(t+1)=theta_t - eta/M sum_(i=1)^M R(z_i) nabla log p_theta (z_i)
$

*(2)* $max$ 函数的另一重意义是 $l^infinity$ 范数，因此可以按这个思路定义：
$
tilde(R)(theta)=(sum_(i=1)^k theta_i^gamma)^(1/gamma)
$
可验证 $lim_(gamma->infinity) tilde(R)(theta)=max_(i=1)^k theta_i$.
$
nabla tilde(R)(theta)=1/gamma (sum_(i=1)^k theta_i^gamma)^(1/gamma-1) vec(gamma theta_1^(gamma-1),..., gamma theta_k^(gamma-1))=((theta_i/norm(theta)_p)^(p-1))_i\
$
参数更新形式为
$
theta_(t+1)=theta_t - eta((theta_1/norm(theta)_p)^(p-1),...,(theta_d/norm(theta)_p)^(p-1))^T
$

== 作业四 第5题
#image("/images/big-data-alg-notes/hw4-q5-1.png", width: 90%)

#image("/images/big-data-alg-notes/hw4-q5-2.png", width: 90%)

=== 解答

由方差分解定理
$Delta_1^2 (X)=Delta_2^2 (X)+(abs(X_1)abs(X_2))/(abs(X_1)+abs(X_2)) D^2
$
，代入 $Delta_2^2 (X)<=epsilon.alt^2 Delta_1^2 (X)$ 得
$
Delta_2^2 (X)<=epsilon.alt^2/(1-epsilon.alt^2) (abs(X_1)abs(X_2))/(abs(X_1)+abs(X_2)) D^2
$
由定义 $Delta_2^2 (X)=abs(X_1)r_1^2+abs(X_2)r_2^2$ 得
$
r_i^2 <= epsilon.alt^2/(1-epsilon.alt^2) abs(X_(3-i))/(abs(X_1)+abs(X_2)) D^2 <= epsilon.alt^2/(1-epsilon.alt^2) D^2
$

对于 $forall x in X_1^"core"$.
$
norm(x-c_1)_2<=norm(x-mu_1)_2+norm(mu_1-c_1)_2<=sqrt(r_1^2/rho)+alpha D
$
$
norm(x-c_2)_2>=norm(mu_1-mu_2)_2-norm(x-mu_1)_2-norm(mu_2-c_2)_2>=D-sqrt(r_1^2/rho)-alpha D=(1-alpha)D-sqrt(r_1^2/rho)
$
$
norm(x-c_1)_2-norm(x-c_2)_2<=2sqrt(r_1^2/rho)+(2alpha-1)D<=D(2(alpha+epsilon.alt/sqrt(rho(1-epsilon.alt^2)))-1)<0
$
由此 $x$ 会被正确分类到 $c_1$. 对于 $forall x in X_2^"core"$ 同理.

对于任意 $x in X$，其被错误分类的概率为
$
P(norm(x-mu_i)_2>r_i^2/rho)<=EE[norm(x-mu_i)_2]/(r_i^2 rho^(-1))=r_i^2/(r_i^2 rho^(-1))=rho
$
由此被正确分类的点数至少为 $(1-rho)abs(X_1)+(1-rho)abs(X_2)$.

== 作业四 第6题

#image("/images/big-data-alg-notes/hw4-q6.png", width: 90%)

=== 解答

由于 $x,x'$ 为 $k"-"$稀疏向量，显然 $x-x'$ 中非零元素要求必须在 $x$ 和 $x'$ 的非零元素位置上，因此 $x-x'$ 最多有 $2k$ 个非零元素，$x-x'$ 是 $2k"-"$稀疏向量。应用 $2k$ 阶 RIP 即得证
$
(1-delta)norm(x-x')^2_2<=norm(Phi(x-x'))^2_2=norm(Phi x- Phi x')^2_2<=(1+delta)norm(x-x')^2_2
$
基于 $l_1$ 最小化的恢复形式为
$
min_(z in RR^d) norm(z)_1,quad "s.t." y=Phi z
$
由于 $y=Phi z$ 空间的复杂性，通常可写成 Lasso 形式：
$
min_(z in RR^d) (norm(y-Phi z)_2^2+lambda norm(z)_1)
$
基于生成模型的恢复形式为
$
min_(z in RR^k) norm(y-Phi G(z))_2^2
$
$l_1$ 最小化恢复形式实际上假设的是 $x$ 有较多零元素（稀疏性），从而恢复的结果也应当有尽可能小的 $l_1$ 范数。而生成模型假设对 $x$ 的分布有更好的先验，对采样率要求更低，但受限于生成模型的表达能力，可能无法准确恢复 $x$.

== 2025 年期末考试 第 4 题

#image("/images/big-data-alg-notes/2025fin-q4.png", width: 90%)

=== 解答

考虑递归地覆盖集合 $X$ 以得到足够小以能划分所有元素的簇。

每次递归地将集合覆盖成 $2^m$ 个直径不超过原来一半的子集，则经过 $ceil(log(Delta))$ 次划分后，将得到 $2^(m ceil(log(Delta)))=Delta^O(m)$ 个子集，所有子集的直径不超过 $min_(x != y in X) d(x,y)$，因此每个子集最多包含一个元素。

从而可以自然地导出不等式 $abs(X)<=Delta^O(m)$.

== 2025 年期末考试 第 5 题
#image("/images/big-data-alg-notes/2025fin-q5.png", width: 90%)
=== 解答
$
c_i=1/n_i sum_(x_j in X_i) x_j => n_i c_i=sum_(x_j in X_i) x_j => n_1 c_1+n_2 c_2=(n_1+n_2) c
$
这是线性插值形式，自然满足重心共线.