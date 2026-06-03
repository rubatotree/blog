#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "实分析 课程总结笔记",
  date: datetime(year: 2026, month: 5, day: 11),
  weight: 0,
  tags: (
    category: ("数学", "分析", "课程笔记")
  ),
  draft: false,
  references: ```yml
    ra-lecture-note:
      type: Blog
      title: "实分析讲义"
      author: 于树澄
      date: 2024
      url:
        value: https://icourse.club/uploads/files/729afc03c905ad7a94546c7cecfdd24f8a3dcaae.pdf
        date: 2024-03
    pksq-1:
      type: Blog
      title: "实分析（刘聪文）2023春课程评价"
      author: 所以你还是你吗？
      date: 2023
      url:
        value: https://icourse.club/course/12373/#review-67036
        date: 2023-07-10
    mathstackexchange-1:
      type: Blog
      title: "Constructing a Borel set that intersects every interval with positive but non-full measure"
      author: VADupleix, bof
      date: 2014
      url: 
        value: https://math.stackexchange.com/questions/961745/constructing-a-borel-set-that-intersects-every-interval-with-positive-but-non-fu
        date: 2014-10-07
    pksq-2:
      type: Blog
      title: "实分析（赵立丰）2015春课程评价"
      author: 章俊彦
      date: 2015
      url:
        value: https://icourse.club/course/2058/#review-153
        date: 2015-07-15
  ```,
)

这是我在 2025 年春季于中科大学习#link("https://faculty.ustc.edu.cn/yushucheng/zh_CN/index.htm", "于树澄")老师的《实分析》@ra-lecture-note 课程时整理的期末考试复习笔记。课程录像已有同学上传到 #link("https://www.bilibili.com/video/BV1LRJHz9Eub", "Bilibili"). 

= 实分析复习笔记 期中部分

== Lebesgue 测度的建立

=== 1. 集合论基础：规定一类集合的代数性质，使得简单生成元上的性质可被推广

1. 集合的运算，集合列的极限，点集拓扑

- *作业 1a.3*：上下极限的等价表述
  - $limsup$：事件无穷多次发生
  - $liminf$：事件从某时刻开始一直在发生

  相关的定理：Borel-Cantelli 引理，Fatou 引理 

2. $sigma$-代数：含有空集（单位元）、对补封闭、对可数并封闭（如果只对有限并封闭则称为代数）

3. Borel $sigma$-代数：包含 $bb(R)^d$ 中所有开集的最小 $sigma$-代数。

  要证明性质在 Borel $sigma$-代数上成立，只需要证明性质对开集成立、对补封闭、对可数并封闭即可。而证明对开集成立只需要证明对开区间（$bb(R)$ 上）或对方体（$bb(R)^d$ 上）成立。

  而因为 Borel $sigma$-代数和 Lebesgue 可测集只相差一个零测集，所以可以顺着把性质推广到可测集上。

4. - $F_sigma$ 集：可数个闭集的交集；
   - $G_delta$ 集：可数个开集的交集。
   - 有理数集是 $F_sigma$ 集，但不是 $G_delta$ 集。
      
      证明：借助开集结构定理和稠密性说明。
   - 无理数集是 $G_delta$ 集，但不是 $F_sigma$ 集。

=== 2. 开集结构定理：把集合的结构简化成可研究的简单小单元（代数生成元）

1. $bb(R)$ 上：$bb(R)$ 中开集均可唯一写成可数个开区间的不交并。

2. $bb(R)^d$ 上：$bb(R)^d$ 中开集均可写成可数方体的几乎不交并。2 进方体之类的概念。

  从而可以用*方体几乎不交并*的结构去逼近任何开集。后面推出可以逼近任何 Lebesgue 可测集（Littlewood 1）。

所以 $bb(R)$ 上可测集的结构是：可数个开区间的并、补操作加一个零测集。

$bb(R)^d$ 上可测集的结构是：可数个开集的并、补操作加一个零测集，或可数个方体的并、补操作加一个测度小于 $epsilon$ 的集合。

=== 3. 外测度：规定一个对任何集合都存在的，可计算的，性质稍差的测度

1. 定义：方体覆盖测度下界

2. 基础性质：空集、单点集、可数点集为零测集。

3. 性质：单调性，次可数可加性，外正则性，特殊集合下的有限可加性（距离大于0的集合、两两不交紧集）。

4. 推论：线性变换下保持测度（作业 1c.3,4）。限制在 Lebesgue 测度下仍然成立。（作业2a.4）

5. 技巧：比较 $L$ 与 $m_*(E) $的大小：
   - $L(E) <= m_*(E)$：证明 $L$ 小于任何方体覆盖的体积和。
   - $m_*(E) = L(E)$：证明对 $forall epsilon$ 存在方体覆盖体积满足 $sum |Q_j|<=L+epsilon$。

=== 4. Lebesgue 测度：保留 Borel $sigma$-代数性质，逼近性质，可数可加性，连续性的好性质

1. 可测性：$forall epsilon>0, exists cal(O), s.t.  m_*(cal(O)\\E)<epsilon$

2. 等价条件：Caratheodory 条件 $forall A subset bb(R)^d, m_*(E inter A)+m_*(E^c inter A)=m_*(A)$（作业2a.3）在抽象测度下也能很好地表述。可测集将任何两个集合切成两部分，保持两部分的和仍为原测度。

3. 基础性质：$cal(B)_(bb(R)^d) subset.neq cal(L)_(bb(R)^d)$, Borel $sigma$-代数是 Lebesgue 可测集的真子集（作业 3a.2）。零测集可测；对可数并、补封闭（对可数交封闭）开集均可测（闭集均可测)。

“好+小”：任何可测集只和 Borel 集相差一个零测集。（讲义定理 1.38，对于 $G_delta$ 集，一侧是由 Lebesgue 可测的定义动机直接得来，另一侧则由零测集可测性质保证。）

任何可测集只和方体覆盖、外部开集、内部闭（紧！）集相差一个测度小于 $epsilon$ 的集合。

4. 重要性质：可数可加性。从而推出可以减。

  证明：有界情形取相差 $epsilon/2^j$ 的紧子集求并即可。无界情形加个极限，把全空间划分成可数个有界集合，再用有界集合的可数可加性加起来。

5. 测度连续性：单调集列极限的测度是测度的极限。递减集额外要求测度从某时刻起有限。

  单调递增情形把单调集列变成增量并的形式再用可数可加性，研究从集合并到级数的对应即可。

  单调递减情形取第一个有限集和后面集合的差集（就是想办法取补），就和递增情形相同了。

6. 可测集只和内部紧集，有限方体几乎不交并相差一个测度小于 $epsilon$ 的集合。（Littlewood 1）

  紧集：取 $[-n, n]^d$ 与内部闭集相交，得到一列递增集列，由测度连续性逼近。

  有限方体几乎不交并：把外部开集写成方体几乎不交并，再套一层测度连续性。

7. 不可测集：补充在后面。

8. “插值”：（作业2b.1）紧集的测度有介值性。启发是有包含关系的有界集合间可以连续“插值”。现在看来用 $([-x,x]^d union E_1) inter E_2$ 插值更加漂亮。

9. Borel-Cantelli 引理：$sum _(j=1)^infinity m(E_j) < infinity => m(limsup_(j -> infinity) E_j)=0$.

  用概率论的语言表述，就是如果事件概率和是有限的，那么存在事件发生无穷次的概率为 0（？）

  用类似柯西列的想法去反证。$forall epsilon, k, $

  $
    m(limsup_(j -> infinity) E_j)>epsilon =>  sum _(j=k)^infinity m(E_j)>=m(inter_(j=k)^infinity E_j)>=m(limsup_(j -> infinity) E_j)>epsilon => "Not Cauchy!"
  $

  逐项积分证明（作业5a.3）：$sum integral chi_E_j d x = integral sum chi _E_j d x < +infinity => sum chi _E_j< infinity " "a.e.$

=== 5. 可测函数：对极限、四则运算、minmax、几乎处处相等、几乎处处收敛 封闭

1. 定义：广义实值函数 

2. 原始定义：${f<a}$（即 $(-infinity, a)$ 的逆像）可测。

  （等价定义）换成  ${f>a}, {f<=a}, {f>=a}$ 都行。退一步 $1/n$ 去逼近、取补即可。

  （作业 3a.3）只要任意开区间/任意开集/任意闭集/任意Borel集的逆像可测即可推出函数可测。只要用开集结构定理推广到开集上，然后说明对可数并和补封闭即可。

3. 示性函数可测（简单函数可测），$bb(R)^d$ 上连续函数可测。

4. 可测函数对复合不封闭。连续(可测($E$)) 可测（因为开集在连续映射下的逆像仍为开集），可测(连续($E$))不一定可测。（讲义命题 1.57，作业 3a.2）

5. 可测函数对极限（上下极限）封闭。因为极限函数值域的开子集逆像就是函数列值域对应开子集逆像（上下极限意义下是单调集列）的极限。

6. 可测函数对 max, min, 四则运算封闭。对取绝对值封闭。

7. 定义：可测函数的正部和负部。

8. 可测函数在几乎处处相等意义下封闭。(作业 3b.1）连续性在几乎处处相等意义下不封闭。（作业 3b.2，塞一个 Dirichlet 函数即可。）

9. 可测函数在几乎处处收敛意义下封闭。

10. 单调递增函数可测。（作业 3b.2）

=== 6. 简单函数逼近

1. 简单函数：有限个可测集的示性函数的线性组合。存在唯一标准表示：两两不交，系数不等。

2. 阶梯函数：有限个矩体的示性函数的线性组合。

3. 简单函数逼近系列定理
  1. *非负*可测函数可以用一列（有紧支集的）非负简单函数*单调递增*、*逐点收敛*逼近。
    
    逼近的形态是：$phi_k$ 取 $k$ 为最高点；底下按照 $1/2^k$ 为步长去“切”函数。

    如果要求紧支集，那就用 $[-k,k]^d$ 再限制一下。

  2. 如果函数*有界*，就可以*一致收敛*。
    
    因为不用限定最高点了。

  3. 任意可测函数可以用一列（有紧支集的）简单函数在绝对值意义下单调递增、逐点收敛逼近。同理可要求有紧支集，可在有界条件下一致收敛。

  4. 可测函数可被阶梯函数*几乎处处收敛*逼近。

    因为可测集（在这里是简单函数示性的集合）和方体的有限并只差一个测度为 $epsilon$ 的集合，所以先用简单函数逐点收敛逼近可测函数，再用阶梯函数按 $epsilon=2^(-k)$ 逼近简单函数，最后取“不能逼近的集合”的上极限用 Borel-Cantelli 定理说明不能逼近的函数值的集合是零测集即可（我没看懂那个证明）。

4. Lusin 定理：设集合 $E subset bb(R)^d$ 可测，$f$ 为 $E$ 上的可测函数，且 $f$ *几乎处处有限*. 则对任意 $epsilon>0$，存在闭集 $F subset E$ 满足 $m(E \\ F)<epsilon$ 且 $f|_F$ 连续.

  1. 微积分中的一个引理：连续函数列在一致收敛意义下的极限函数也连续。

  2. 证明：
    1. 先说明简单函数的情形：对每块可测集都能用闭集按 $epsilon/N$ 逼近。
    2. 再证明有界可测函数（比几乎处处有限更严）的情形：用简单函数列可以一致收敛逼近它，从而能够说明在限制集下的连续性。限制集可以通过对简单函数连续的闭子集取交得到（闭集可数交仍然为闭集），用 $epsilon/2^k$ 限制即可。
    3. 最后用一个连续双射推广到几乎处处有限的可测函数上：$g(x)=f(x)/(1+|f(x)|), f(x)=g(x)/(1-|g(x)|)$. 取 Sigmoid, $arctan$ 之类的函数也都可以。
  
  3. 应用：
    1. 任何几乎处处有限的可测函数都离一个连续函数只差测度为 $epsilon$ 的集合。先用 Lusin 定理得到连续部分的闭集，再用连续函数延拓定理连接这些闭集即可。

5. Egorov 定理：设 $f$, ${f_n}_(n=1)^infinity$ 为可测集 $E subset bb(R)^d$ 上的可测函数，且 $m(E)<infinity$. 若 $f_n -> f, a.e." " x in E$，则对任意 $epsilon>0$，存在闭子集 $F subset E$ 满足 $m(E \\ F)<epsilon$ 且 $f_k$ 在 $F$ 上一致收敛到 $f$.

  1. 想法：令 $E_k^n:={x in E: |f_j (x)-f(x)|<1/n, forall j>=k}$. 那么存在下标列 ${k_n}$ 使得 $inter_(n=1)^infinity E^n_k_n$，即满足一致收敛的集合（在测度意义下）足够大。

  2. 证明：
    1. 对于固定的 $n$，$E_k^n$ 关于 $k$ 单调递增且收敛到 $E$. 由测度连续性推出 $lim_(k -> infinity)m(E\\E_k^n)=0$. 
    2. 为每个 $n$ 取 $k_n$ 满足 $m(E\\E^n_k_n)<epsilon/2^(n+1)$.  
    3. 令 $tilde(F):=inter_(n=1)^infinity E^n_k_n$. 那么它与原来的 $E$ 只相差 $epsilon$（它的形态是什么样的？）；
    4. 说明 $tilde(F)$ 上的一致收敛性；(想法:给定 $delta$，则函数在 $E^(n_delta)_k_n_delta$ 上和极限函数只差 $delta$)
    5. 再给 $tilde(F)$ 取一个相差 $epsilon$ 的闭子集 $F$ 即可。

  3. 理解：$n$ 增大会让 $E^n_k$ 变小；$k$ 增大会让 $E^n_k$ 增大（且收敛到 $E$）；所以对于每个 $n$ 都取合适的 $k$ 再并起来即可得到一致收敛的集合。但得到的其实还是和测度里 $epsilon$ 相关的类似“内闭一致收敛”的东西。

== Lebesgue 积分

=== 1. 积分理论的建立过程

==== 1.1 非负简单函数

1. 定义：各个集合测度按系数加权求和。另遵循 $0 dot (+infinity)=0$ 的规定。

2. 性质：正线性，可加性，单调性，连续性

==== 1.2 非负可测函数

1. 定义：不大于 $f$ 的简单函数的的积分的上确界
    
    可积性：仅要求这个上确界是有限值。$integral f d x<+ infinity$

2. 性质：正线性，可加性，单调性，连续性；几乎处处意义下相等。

3. 定理（*MCT，单调收敛定理*）：设 $E subset bb(R)^d$ 可测，${f_k}, f$ 是 $E$ 上的非负可测函数. 若 ${f_k}$ 单调递增并收敛到 $f$（可弱化为几乎处处），那么 $ lim _(k->infinity)integral_E f_k d x=integral_E f d x $
  
    1. 证明：单调性可以得到 $integral f_k d x <= integral f d x$；另一侧通过“退一小步”的想法得到 $forall lambda, exists k, integral f_k d x >= integral lambda f d x$.
    2. 用法：
      1. 简单函数可以单调递增、逐点收敛逼近非负可测函数，从而可以继承性质（正线性证明）；
      2. 可以用于把用 $[-k, k]^d -> [0, k]$ 限制区域的函数列 $f_k$ 的性质推到 $bb(R)^d -> bb(R)$ 上（连续性证明）。
      3. 可以证明几乎处处相等的函数有相同积分值。取一个比二者都大的几乎处处相等函数即可。（作业 5a.4）
    3. 要求单调，否则有 escape of mass 的反例，与 Fatou 引理情形相同。（作业 5a.3）

4. 定理（*逐项积分定理*）：设 ${a_k}_(k=1)^infinity$ 在可测集 $E$ 上非负可测，则 $ integral_E sum_(k=1)^infinity a_k (x) d x=sum_(k=1)^infinity integral_E a_k (x)d x $

    1. 证明：对 RHS 操作，先写成部分和的极限形式，有限求和积分可换，交换后部分和函数单调递增，收敛到 $sum_(k=1)^infinity a_k (x)$，因此用 MCT 即可。

5. 可积性的一些命题：设 $f, g$ 在可测集 $E$ 上非负可测。

  1. *被可积函数控制则可积*：$f<=g, g in L^1(E) => f in L^1 (E)$. 特别地，有界集合上的有界函数可积。这里的“控制”就是给了一个积分的上界。

  2. *可积则 a.e. 有限*：$f in L^1(E) => f(x)<infinity " "a.e." "x in E$.

6. 定理（*Fatou 引理*）：设 ${f_k}^infinity_(k=1)$ 为可测集 $E$ 上的非负可测函数列. 则$
  integral_E liminf_(k->infinity)f_k (x) d x <= liminf_(k->infinity)integral_E f_k (x) d x $
    1. 严格不等号的情形：escape of mass. 
    2. 证明：讨论一列“下界函数列”$g_k=inf_(n>=k)f_n$ 的极限的积分。一方面，其单调收敛到下极限函数，由 MCT，极限的积分为左式；另一方面，$g_k<=f_k$ 总成立，因此每项积分小于右式，极限的积分也小于右式。（有更好的概括方式吗？）
    3. 用法：判断极限函数的可积性。
    4. 反 Fatou 引理（作业5b.4）：设 ${f_k}^infinity_(k=1)$ 为可测集 $E$ 上的非负可测函数列，且要求被可积函数 $g$ 控制. 则$
limsup_(k->infinity)integral_E f_k (x) d x<=  integral_E limsup_(k->infinity)f_k (x) d x $
       从而可以两边夹一下，证明非负可测函数的控制收敛定理。

       证明方法是对 ${g-f_k}$ 函数列用 Fatou 引理。

==== 1.3 可测函数

1. 定义： 正部积分减负部积分

2. 性质：线性性，可数可加性，单调性，三角不等式，绝对连续性，平移不变性，几乎处处意义下相等，可积推出几乎处处有限。

3. 定理（*DCT，控制收敛定理*）：设 $E subset bb(R)^d$ 可测，${f_k}$ 是 $E$ 上的可测函数列且几乎逐点收敛到 $E$ 上某个函数 $f$. 若存在 $g in L^1 (E)$ 使得对任意 $k>=1, |f_k|<=g$，则 $ lim _(k -> infinity) integral_E |f_k-f| d x = 0, lim _(k->infinity)integral_E f_k d x=integral_E f d x $

    1. 证明：研究 $h_k=|f_k-f|<=2 g, liminf_(k->infinity)=0$，用 Fatou 引理说明 $k->infinity$,  $h_k$ 对非负可测函数 $2 g - h_k$ 的积分无贡献，从而 $h_k$ 的积分收敛到 0. $ integral 2 g d x = integral liminf_(k->infinity) (2 g - h _k) d x <= liminf_(k->infinity) integral (2 g - h _k) d x =integral 2 g d x - limsup_(k->infinity) h_k d x $

    2. 可以反过来用于证明 MCT. 主要是讨论收敛目标函数不可积的情形。

4. 推论（*BCT，有界收敛定理*）：设 $E subset bb(R)^d$ 可测，${f_k}_(k=1)^infinity$ 是 $E$ 上的一列可测函数且 $f_k$ 几乎逐点收敛到 $E$ 上某个函数 $f$. 若 $m(E)<infinity$ 且 ${f_k}_(k=1)^infinity$ 在 $E$ 上一致有界，即存在 $M>0$ 使得对任意 $k>=1$ 对任意 $x in E$ 有 $|f_k (x)|<=M$，则$ lim _(k -> infinity) integral_E |f_k-f| d x = 0, lim _(k->infinity)integral_E f_k d x=integral_E f d x  $

5. 定理（*“质量”落在紧集内*）：存在紧集 $B in bb(R)^d$ 使得 $integral_(B^c)|f|d x < epsilon$.
  1. 证明：构造越来越大的紧集，用积分的连续性推出紧集内积分的极限是 $bb(R)^d$ 上的积分，从而可以取得符合要求的紧集。
  2. 可积性并不代表 $f$ 在无限远处趋于 0，不过如果要求一致连续则没问题（作业 5b.1）。

6. 定理（*绝对连续性*）：$exists delta>0$ 使得对任意可测集 $E subset bb(R)^d$，$m(E)<delta => integral_E |f| d x < epsilon$.
  1. 证明：对有界函数该定理显然；利用单调收敛定理将有界函数逼近研究的函数。
  2. 推论：变上限积分函数 $F(x):=integral_(-infinity)^x f(t) d t$ 关于 $x$ 一致连续。

==== 1.4 与 Riemann 积分的联系

1. “兼容”性证明：Riemann 可积要求在闭区间上有界。（从 Riemann 积分的定义出发）用阶梯函数去从上、下两个方向逼近，由定义 Riemann 积分意义下积分值即阶梯函数积分的极限；另一方面有界收敛定理说明 Lebesgue 积分意义下的积分值也是阶梯函数积分的极限。所以 Riemann 可积条件下两种积分方式得到的积分值是相同的。

2. 用法：把积分用 Lebesgue 积分相关的定理转化成一系列 Riemann 积分来计算。

3. 定理（Lebesgue）：黎曼可积 $<=>$ 几乎处处连续（作业 6a.4）

=== 2. $L^p$-空间

==== 2.1. 范数的建立与证明

1. 定义略

2. 性质：完备赋范线性空间。以几乎处处相等作为等价类。其中范数要求正定性、齐次性、三角不等式。

3. 定理（*Holder 不等式*）：$norm(f g)_1<=norm(f)_p norm(g)_q ,forall f in L^p (E), g in L^q (E), 1/p+1/q=1.$

  1. 引理（Young 不等式）：$1/p+1/q=1;a,b>0=>a^(1/p) b^(1/q)<=1/p a+1/q b$
  2. 证明：将 $f/norm(f)_p, g/norm(g)_q$ 代入不等式，积分即得.

4. 定理（*Minkowski 不等式*）：三角不等式，$norm(f+g)_p<=norm(f)_p+norm(g)_p$
  1. 证明：写回积分定义，拆成两部，对每一部用 Holder 不等式放缩。

==== 2.2. 完备性

1. 性质：设 $1<=p<=infinity$，$L^p (E)$ 在度量 $d(f, g):=norm(f-g)_p$ 下完备.

==== 2.3. 几种收敛方式

- 逐点收敛

- 一致收敛

- 几乎处处收敛：$m({x in E: lim_(n->infinity)f_n (x) != f(x)})=0$

- 依测度收敛：$lim_(n -> infinity) m({x in E: |f_n - f| >= epsilon})=0$

- 依范数收敛：$lim_(n->infinity)norm(f_n-f)_p=0$

1. 定理：依范数收敛推出依测度收敛。

2. 定理：几乎一致收敛推出几乎处处收敛。

3. 定理：几乎一致收敛推出依测度收敛。

4. 定理（*Egorov*)：*有限集*条件下，几乎处处收敛推出几乎一致收敛。

5. 定理（*Lebesgue*）：*有限集、几乎处处有限*条件下，几乎处处收敛推出依测度收敛。

  1. 证明：类似 Egorov 定理的想法。

  2. 观察：${f_n_k arrow.not f}=union_(epsilon>0) limsup_(k->infinity) E_n (epsilon)$.

6. 定理（*Riesz*）：*几乎处处有限*条件下，依测度收敛推出存在几乎处处收敛子列。

  1. 证明：证明存在子列使得对于任意 $epsilon$，$limsup_(k->infinity) E_n_k (epsilon)$ 是零测集。这只需要利用依测度收敛条件取出一系列集合 $E_n_k$ 使得不收敛部分越来越少，求和起来有限，再用Borel-Cantelli 定理说明上极限是零测集即可。取出集合还要求随着下标增大，收敛要求 $b_j$ 逐渐收敛到 0，以满足定理对任意 $epsilon$ 的需求。 $ forall epsilon>0, limsup_(j->infinity) E_n_j (epsilon) subset limsup_(j->infinity) E_n_j (b_j) $

7. 反例（逐点收敛但不依测度收敛）：无限集上的函数。

8. 反例（依测度收敛但处处不收敛）：“扫描”。

9. （作业 7a.1）“$L^p$ 收敛推出几乎处处收敛”仅在 $p=infinity$ 可行。

    反例：用一个逐渐缩小的区间不断扫描逐渐扩大的区间，使得每个位置都不收敛，但积分因区间缩小而减小。

==== 2.4. 稠密性定理

1. 定义：任意邻域均与另一集合有交。

2. 定理：$1<=p<infinity, $则：${L^p"-简单函数"} subset^"dense" L^p (bb(R)^d), {"阶梯函数"}subset^"dense" L^p (bb(R)^d)$

  1. 引理（稠密的传递性）：$x subset^"dense" V, Y subset^"dense" X => Y subset^"dense" V$.

  2. 证明：好长......

3. 定理：$1<=p<infinity, $则：$C_c (bb(R)^d) subset^"dense" L^p (bb(R)^d)$ （具有紧支集的连续函数稠密）

  1. 证明：把阶梯函数“连接”起来。

4. 应用：Lebesgue 积分的变量替换法则（换元）：$integral_(bb(R)^d)f(A(x))d x=|det(A)|^(-1) integral_(bb(R)^d)f(x)d x.$

5. 应用：平移变换的连续性：$1<=p<+infinity, f in L^p (bb(R)^d). $ 则 $h->0, norm(f_h-f)_p -> 0$.

==== 2.5. 性质

1. 有限测度集上 $p_1<p_2 => L^(p_2) (E) subset L^(p_1) (E)$（作业 6b.4）
  
  证明：$p$ 减小，有限集上小于 1 的部分至多增大为 1（无法贡献无穷大），大于 1 的部分一定减小。

2. $bb(R)^d$ 上 $p$ 不同的空间互不包含。具体反例由作业 5a.2，作业 6b.4 给出，用 $1/(|x|^a), |x|<=1 " or "|x|>1$ 的形式构造。

== 方法

=== 1. “好”+“小”

将简单集合的性质推广到可测集主要有两种证明思路：

1. 任何 Lebesgue 可测集只和 Borel 集相差一个零测集。证明性质在简单集合上成立，在可数并、补下保持，并证明零测集不影响性质（或是几乎处处意义下的性质）即可。

2. 任何 Lebesgue 可测集只和外部开集、内部闭（甚至紧）集、方体覆盖相差一个测度小于 $epsilon$ 的集合。证明性质在开集上成立，并证明 $epsilon$ 取极限后性质也能保持即可。

=== 2. 用好的逼近坏的

==== “退 $epsilon$ 步海阔天空”

1. *作业 1b.1*：用开集列逼近闭集、用闭集列逼近开集
  - ${x: f(x) <= a}=inter _(k=1) ^infinity {x: f(x)<a+1/k}$
  - ${x: f(x) < a}=union _(k=1) ^infinity {x: f(x)<=a-1/k}$

2. MCT 的证明

3. 切比雪夫不等式（$m({f>alpha})<=1/alpha integral f d x$，作业 5a.1）的应用： 
    
    可以把 $alpha$ 逐步收敛到任意一个想要的数，如 0.（作业 4b.3，作业 5b.2）.

==== 方体覆盖

集合的外测度为方体覆盖测度的下极限。

==== 用紧集逼近无限集合

性质在 $bb(R)^d$ 上成立 $<==>$ 性质在 $forall n, [-n, n]^d$ 上成立。

性质在 $bb(R)^d -> bb(R)^+$ 上成立 $<==>$ 性质在 $forall n, [-n, n]^d -> [0, n]$ 上成立。 可以用 MCT 一类的定理推过去。


==== 单调递增集列可以写成增量集合的不交并

从而用 Lebesgue 测度的可数可加性。

==== Littlewood 三原则

1. 可测集几乎是区间的有限并：“开集结构定理”

2. Lusin: 可测函数几乎是连续函数

3. Egorov: 函数列几乎是一致收敛

== 特殊的结构

=== Cantor 集，类 Cantor 集

“某进制下小数部分不含某个数的点集合”。

1. 性质：零测集

    （作业 2b.3）类 Cantor 集：给定一列正实数 ${cal(l)_k}_(k=1)^infinity$ 满足 $sum_(k=1)^infinity 2^(k-1) cal(l)_k <= 1$（收敛条件），令 $hat(C)_k$ 为 $hat(C)_(k-1)$ 每个区间中挖去长度为 $l_k$ 的开子区间得到的新集合，$hat(cal(C))=inter_(k=1)^infinity hat(C)_k$ 称为类 Cantor 集。

    则 $m(hat(cal(C)))=1-sum_(k=1)^infinity 2^(k-1) cal(l)_k$. 由此可以构造出测度大于 0 的类 Cantor 集。

2. （作业2a.1）性质：不连通、无内点、是完全集（极限完备）、

3. （作业2a.2）类 Cantor 集之间的映射。

  - Cantor-Lebesgue 函数：将 Cantor 集映射到 $[0,1]$ 上的单调函数。是*连续双射*。（连续统基数）

=== 不可测集

1. 构造（Vitali）：按有理数划分等价类，每个等价类找一个代表元。

2. 不可测性证明：有理数集可数，$[0, 1]$ 上所有有理数平移后的并有限且充满整个 $[0, 1]$ 区间，但是由可数可加性，无限并只能取值 0 或无穷，从而矛盾。

3. 分球悖论

4. （作业 3a.1）Vitali 集的可测子集必为零测集。

5. （作业 3a.1）测度大于 0 的集合必有不可测子集。（用 Vitali 集取并构造）

6. （作业 3a.2）零测集的子集必可测（是零测集）。

7. （作业 3a.2）可测但非 Borel 集：类 Cantor 集给出了测度大于 0 的集合到零测集的连续双射；测度大于 0 的集合必有不可测子集；不可测子集映射到零测集的子集后是可测的（零测集的子集必可测）；Borel 集在连续双射下保持；但是 Borel 集必可测，矛盾。

8. （作业 3a.2）可测(连续($E$)) 映射不保可测性：想法是零测集上的映射一定可测，且可以把不可测集连续映射到零测集上。$cal(C)_(m>0) ->^(F,"连续") cal(C)_(m=0)->^(chi_(F cal((N)))){0,1}$，合并后的映射即 $chi_(F(cal(N)))$。

= 期末部分

== 1 Fubini 定理

1. Fubini 定理
  
设 $f in L^1 (RR^d)$，则

  (F1) $f^y in L^1 (RR^(d_1))  " a.e." y in RR^(d_2)$；

  (F2) 函数 $y |-> integral_(RR^(d_1)) f^y (x) dif x$ 可积；

  (F3) $integral _(RR^d) f(x, y) dif x dif y=integral_(RR^(d_2))(integral_(RR^(d_1)) f(x,y) dif x) dif y$.


2. Tonelli 定理
  
设 $f$ 是 $RR^d$ 上*非负*可测函数，则

  (T1) $f^y$ 可测 $ " a.e." y in RR^(d_2)$；

  (T2) 函数 $y |-> integral_(RR^(d_1)) f^y (x) dif x$ 可测；

  (T3) $integral _(RR^d) f(x, y) dif x dif y=integral_(RR^(d_2))(integral_(RR^(d_1)) f(x,y) dif x) dif y$. 其中等式两端允许取 $+infinity$.

  证明：可积情形由 Fubini 推出；不可积情形用包围盒限制-MCT 的技术推出。



3. Fubini 定理证明： // TODO

  1. 证明满足定理的集族对线性组合、单调极限封闭。

  2. 证明可积简单函数（“生成元”）都在集族中。
    
    证明顺序：方体-符合条件的零测集的子集-有限个闭方体的几乎不交并-有限测度开集-有限测度 $G_delta$ 集-任意零测集-一般有限测度集合.

  3. 说明可积函数可以由可积简单函数线性组合及取单调极限得到。

4. 推论：换元积分法。对三个初等矩阵证明测度不变性即可。

5. 推论：乘积集合的可测性

  1. 由 Tonelli 定理可以直接得到可测集 $E subset RR^d$ 的切片集合可测：
    
    (i) $E^y$ 可测 $"a.e." y in RR^(d_2)$.

    (ii) 函数 $y |-> m^(d_1) (E^y)$ 可测.

    (iii) $m(E)=integral_(RR^(d_2)) m^(d_1) (E^y) dif y$.

  记 $E_1 subset RR^(d_1), E_2 subset RR^(d_2), E=E_1 times E_2 in RR^d$ 称为 $E_1$ 与 $E_2$ 的乘积集合. 则有

  2. 两个正测集的乘积集合可测，那么两个集合都可测。
    
    （设 $E=E_1 times E_2 subset RR^(d_1) times RR^(d_2)$ 可测，且 $m_*^d_2(E_2)>0$，则 $E_1$ 可测.）

  3. （引理）$m_* (E)<=m_*^d_1(E_1) times m_*^d_2(E_2)$，其中右端满足 $0 dot (+infinity)=0$.

  4. 两个可测集的乘积集合一定可测，且测度为集合测度之积。

  5. 推论：零测集 $times$ 零测集 $=$ 零测集（可测）.

  6. 推论：$m_*^d_1(E_1)m_*^d_2(E_2)>0$，则 $E$ 可测 $<=> E_1, E_2$ 均可测.

  7. Lebesgue 积分的几何意义：面积

6. 卷积：$f$ 可测 $=> tilde(f)(x,y)=f(x-y)$ 可测.

== 2 积分的微分理论

=== 2.1 Lebesgue 微分定理（LDT）


$ f in L^1_"loc" (RR^d)=>lim_(m(B)->0 \ B in.rev x) 1/m(B) integral_B f(y) dif y=f(x) " a.e." x in RR^d $

表述：闭区间上可积函数有原函数，且原函数的导数几乎处处等于函数本身。

$f in L^1 ([a,b]) => F(x):=integral_a^x f(t) dif t$ 在 $(a,b)$ 上可微且对任意 $x in (a,b)$ 有 $F'(x)=f(x)$.

1. 思想：研究局部可积性。如果 $lim_(m(B)->0) 1/m(B) integral_B f(y)dif y=f(y)$，那么将左右式在区间上累积起来即可得到一个“原函数”。

2. 局部可积：$forall$ 开球 $B subset RR^d, f chi_B in L^1(RR^d)$. 记作 $f in L^1_"loc" (RR^d)$.

$L^1_"loc" (RR^d)$ 空间性质：(1). 线性空间；(2). $f in L^1_"loc" (RR^d) => abs(f(x))<infinity "a.e." x in RR^d$.

3. Hardy-Littlewood 极大函数：$forall x in RR^d: f^*(x):= sup_(B in.rev x) 1/m(B) integral_B abs(f(y)) dif y$

  1. $f$ 可测 $=> f^*$ 可测；
  证明：研究 ${f^*>alpha}$，借助 $f^*$ 定义说明 $forall x in {f^*>alpha}$，$x$ 有开邻域（定义中开球所有点都有 $f^*(x')>alpha$）. 可以借助这个证明理解用开球定义的动机。

  2. （H-L 极大不等式）：设 $f in L^1 (RR^d)$，则对任意 $alpha >0$，$m({f^*>alpha})<=3^d/alpha norm(f)_1$.

  证明：
  $
    1/m(B_x)integral_B_x abs(f(y)) dif y>alpha<=>m(B_x)<1/alpha integral_B_x abs(f(y)) dif y\
    =>m(E_alpha)<=^"Vitali" 3^d sum_(j=1)^k m(B_j)<3^d/alpha integral_(union.sq_(j=1)^k B_j) abs(f(y)) dif y<=3^d/alpha norm(f)_1
  $

  3. 推论：$f in L^1(RR^d) => f^*(x)<infinity "a.e." x in RR^d$. 
  
  只需说明 $m({f^*=infinity})<=lim_(alpha->infinity)m({f^*>alpha})<=lim_(alpha->infinity)3^d/alpha norm(f)_1=0$.

  4. 推论：$f in L^1_"loc" (RR^d)$，则 $f^*(x)>=abs(f(x)), " a.e." x in RR^d$. 这是因为 LDT 给出了局部可积函数在小局部上的平均值就是它本身，而这个均值在定义上就小于 H-L 极大函数.

4. Vitali 覆盖引理：令 $N in NN$. $cal(F)={B_1, ..., B_N}$ 为 $RR^d$ 中 $N$ 个开球，则存在一系列开球 $B_i_1, ..., B_i_k in cal(F)$ 两两不交且 $m(union_(i=1)^N B_i)<= 3^d sum_(j=1)^k m(B_i_j)$.

5. *定理证明*：用稠密的连续函数（自动满足微分定理）近似，误差部分用 HL 极大函数控制住。

6. 密度点：$E in RR^d$ 可测. 密度点定义为满足 $lim_(m(B)->0\ B in.rev x) m(B inter E)/m(B)=1$ 的 $x$.

例子：集合的内点；零测集无密度点（分子恒为0）；满测集上所有点.

推论：可测集中的点几乎处处是密度点，补集上的点几乎处处不是密度点.

7. Lebesgue 点：$f in L^1_"loc" (RR^d)$. 满足 $abs(f(x))<infinity, lim_(m(B)->0\ B in.rev x) 1/m(B) integral_B abs(f(y)-f(x))dif y=0$ 的点. 点集记作 $L_f$. 该条件比 Lebesgue 微分定理中极限等式更强。

连续点一定是 Lebesgue 点，Lebesgue 点一定满足微分定理的等式.

推论：$f in L^1_"loc" (RR^d)=>L_f$ 满测. （所以满足微分定理等式但是不是 Lebesgue 点的点集是零测的，从而能专注研究 $L_f$ 这些性质更好的点？）

8. 正则收缩：用更一般的集合平均。

定义：集合“差不多是开球”

  (i) $forall epsilon>0, exists U in cal(F)_x "s.t." "diam"(U)<epsilon;$（外部可用开球包裹）
  
  (ii) $exists c>0 " s.t." forall U in cal(F)_x, exists "开球" B, x in B, U subset B, m(U)>=c m(B)$.（和外部开球差不多大）

引理：$x in L_f => lim_(m(U)->0\ U in.rev x) 1/m(U) integral_U abs(f(y)-f(x))dif y=0$

证明：$abs(f(y)-f(x))$ 在 $U$ 上的积分是不大于在外部开球上的积分的.

推论：相对于中心球的 Lebesgue 微分定理等.
/*

9. 恒等元逼近：用更一般的卷积核平均。$(f*g)(x):=integral_(RR^d) f(x-y) g(y) dif y$.

  1. 卷积函数的性质：交换律；有界紧支撑 $*$ 局部可积 $=>$ a.e. 有意义；范数三角不等式；可积 $*$ 有界 $=>$ 一致连续.

  2. 恒等元逼近的定义：${K_delta}_(delta>0)$ 是 $RR^d$ 上一族可测函数，满足：
    1. $integral_(RR^d) K_delta (x) dif x=1, forall delta>0$. （“平均”，归一化条件）
    2. $exists C>0 "s.t." abs(K_delta (x))<=C/(delta^d), forall delta>0, forall x in RR^d$.（限制顶部）
    3. $abs(K_delta (x)) <= (C delta)/(abs(x)^(d+1)), forall delta>0, forall x in RR^d$.（用幂函数再压一下）

  3. 例子：开球平均；各种卷积核
  意义：对于任意可积函数，用恒等元逼近卷积后得到的函数在 Lebesgue 点上收敛且依范数收敛到原函数.

  4. 定理：（在 Lebesgue 点上收敛）
  ${K_delta}_(delta>0)$ 是恒等元逼近，则 $forall f in L^1 (RR^d), forall x in L_f, lim_(delta->0^+) f*K_delta (x)=f(x)$.
    1. 引理：$f in L^1(RR^d),x in L_f, cal(A)(r):=1/r^d integral_(abs(y)<=r)abs(f(x-y)-f(x))dif y, forall r>0$.
    
    有 $cal(A)(r)$ 在 $(0,infinity)$ 连续且 $lim_(r->0^+)cal(A)(r)=0$；$cal(A)(r)$ 有界.

  5. 定理：（依范数收敛）
  ${K_delta}_(delta>0)$ 是恒等元逼近，则对任意 $f in L^1 (RR^d)$，当 $delta->0^+$ 时，$norm(f*K_delta-f)_1->0.$
  */

=== 2.2 Newton-Leibnez 公式

表述：$F in A C[a, b] => F' "a.e."$ 存在且 $integral_a^x F'(t) dif t=F(x)-F(a)$.

反过来，$forall f in L^1 ([a,b]), exists F in A C[a,b] "s.t. " F'(x)=f(x), "a.e." x in [a, b]$.

==== 2.2.1 有界变差

1. 定义：
  
  - 变差 $V(f, P):=sum_(j=1)^n abs(f(t_j)-f(t_(j-1)))$
  - 全变差：$V_a^b (f):=sup_P V(f,P)$（几何含义：$f$ 在 $[a,b]$ 的取值变化量）
  - 有界变差：$f in "BV"([a,b]) <=>^"def" V_a^b (f)<infinity$

意义:$F "a.e."$ 可微，且 $F' in L^1([a,b])$ 的充分条件。

例子：单调函数，有界 Lipschitz 连续函数 ......

2. 引理
  1. $V_a^b (f)>=V(f,P)>=abs(f(b)-f(a))$
  2. 线性空间；
  3. $P_1 subset [a, c], P_2 subset [c, b] => V(f, P_1 union P_2)=V(f, P_1)+V(f, P_2)$
  4. 精细划分 $V(f,P')>=V(f, P)$

3. 性质
  1. $forall x in [a, b], V_a^b (f) = V_a^x (f)+V_x^b (f)$.
  2. $f in "BV"([a,b]) => x |-> V_a^x (f)$ 在 $[a, b]$ 单调递增.

4. $f(x)=cases(x^a sin(1/x^b) quad&0<x<=1, 0 &x=0.), quad f in "BV"([0,1]) <=> a>b$.

4. 可求长曲线：$z:[a,b]->RR^2, t|->z(t)=(x(t)),y(t)), x(t),y(t)$ 连续.

曲线可求长 $<=> exists M, forall P, sum_(j=1)^n abs(z(t_j)-z(t_(j-1)))<=M<=>x(t),y(t) in "BV"([a,b])$

证明方法就是利用范数关系。$max(abs(x), abs(y))<=sqrt(x^2+y^2)<=abs(x)+abs(y)$.

弧长 $L(gamma):=sup_P sum_(j=1)^n abs(z(t_j)-z(t_(j-1)))$

5. Jordan 分解定理：$f in "BV"([a,b]) <=> exists g, h$ 单调递增 $"s.t." f=g-h$.

证明：“$arrow.l.double$”：闭区间上单调函数是有界的。

“$=>$”：$g=V_a^x (f), h=g-f$. 只需证明 $h$ 单调递增；用定义证明即可。

$h(x_2)-h(x_1)=V_(x_1)^(x_2)(f)-(f(x_2)-f(x_1))>=V_(x_1)^(x_2)(f)-abs(f(x_2)-f(x_1))>=0$

推论：$f in "BV"([a,b]) => f$ 可微 $a.e.$ 且 $f' in L^1 ([a,b])$.

==== 2.2.2 单调函数微分定理

1. 闭区间上单调递增函数 $f$ 满足：
  1. $f$ a.e. 可微；
  2. $f' in L^1([a,b])$；
  3. $integral_a^b f'(t) dif t<=f(b)-f(a)$.

2. *证明*：

  1. Dini 导数：
    - $D^+ f(x)L=limsup_(h->0^+) (f(x+h)-f(x))/h$
    - $D_+ f(x)L=liminf_(h->0^+) (f(x+h)-f(x))/h$
    - $D^- f(x)L=limsup_(h->0^-) (f(x+h)-f(x))/h$
    - $D_- f(x)L=liminf_(h->0^-) (f(x+h)-f(x))/h$
  2. 引理：注意逻辑关系！
  
  $(f$ 单增 $=>f' "a.e."$ 存在$) <=> (f$ 单增 $=>E_1(f):={x in (a,b): D^+ f(x)> D_- f(x)}$ 零测$)$.
    
    证明：“$=>$”显然. 下文证明“$arrow.l.double$”.

    定义 $E_2(f):={x in (a,b): D^- f(x)> D_+ f(x)}$ 零测$)$

    则由假设及对称性，$f$ 单增 $=> m(E_1(f))=m(E_2(f))=m(E_1(f)union E_2(f))=0$.

    $forall x in.not E_1(f)inter E_2(f), D^+(f(x))>=D_+(f(x))>=_(x in.not E_2(f)) D^- f(x)>=D_- f(x)>=_(x in.not E_1(f)) D^+ f(x)$

    从而四个 Dini 导数相等，从而 $f' "a.e."$ 存在.

  3. 证明：只需证 $E_1(f)$ 零测. //TODO


3. Vitali 覆盖：满足每个点都有充分小邻域的无穷覆盖
$E subset RR, Gamma={I_alpha}. forall x in E, forall epsilon >0, exists I in Gamma "s.t." x in I, abs(I)<epsilon$，则称 $Gamma$ 是 $E$ 的一个 Vitali 覆盖.

等价定义：$forall x in E, exists {I_n}_(n=1)^infinity subset Gamma "s.t." forall n, x in I_n; lim_(n->infinity) abs(I_n)->0.$

*定理*：$forall epsilon >0, exists I_1, ..., I_n in Gamma $ 两两不交，使得 $m_*(E\\ union.sq_(j=1)^n I_j)<epsilon$.
  
  即，存在任意大的有限不交子覆盖. 

证明：// TODO

==== 2.2.3 绝对连续性

1. 定义：$f in "AC"([a,b]) <=> forall epsilon>0, exists delta>0 "s.t." forall$ 有限个两两不交的开区间 $(a_1, b_1), ..., (a_N, b_N)$，只要 $sum_(k=1)^N (b_k-a_k)<delta$，就有 $sum_(k=1)^N abs(f(b_k)-f(a_k))<epsilon$.

2. 关系：Lipschitz 连续 $subset$ 绝对连续 $subset$ 一致连续 $subset$ 逐点连续
  
  绝对连续但不 Lipschitz 连续的例子：$f(x)=sqrt(x)$

  一致连续但不绝对连续的例子：Cantor-Lebesgue 函数.

3. 定理：用积分定义的函数 $F(x):=integral_a^x f(t)dif t$ 绝对连续。（NL 定理的必要性）
证明：用 Lebesgue 积分的绝对连续性转化一下。

4. 性质：线性空间；对乘法封闭；$"AC"([a,b])subset"BV"([a,b]).$

证明：只证明最后一个.

$forall I=(x,y) subset [a,b], abs(I)<delta => V_I (f):=V_x^y (f)<=epsilon$. 这是因为 $V_x^y$ 在定义上就大于所有区间划分的区间两侧之和。把 $[a,b]$ 切成 $M$ 份使得每一份长度都小于 $delta$，则函数差的绝对值加起来就小于 $M epsilon$ 了.

5. （从H班偷的）连续且 BV，且将零测集映射为零测集 $=>$ AC

6. 复合（从 H 班偷来的）
  1. $f, g in "AC"([a,b]) arrow.r.double.not f compose in "AC"([a,b])$

  反例：$[0,1]$ 上，$f(t)=t^(1/3), g(t)=cases(t^3 sin^3(1/t) quad &0<t<=1,0 & t=0), f compose g(t)=cases(t sin(1/t) quad &0<t<=1,0 & t=0)$

  2. $f:[a,b]->RR, g:[c,d]->[a,b], f,g in "AC". $

  当 (i) $g$ 单增 或 (ii) $f$ Lipschitz 连续时，$f compose g in "AC"([a,b])$.

  3. $f, g in "AC", f compose g in "BV" => f compose g in "AC"$.

  证明：$f compose g in "BV"([a,b]) inter C([a,b])$ 且将零测集映射为零测集.

7. 定理：$f in "AC"([a,b]) => f'$ 存在 $a.e.$ 且若 $f'=0 "a.e."$，则 $f$ 为 $[a,b]$ 上常值函数.

证明：$f'=0$ 的集合是满测集，里面每一点都可以在右侧取到满足差商小于 $epsilon$ 的闭邻域（因为导数用极限定义），它们构成 Vitali 覆盖。用 Vitali 覆盖定理取到有限个不交闭邻域，这些邻域对积分贡献小于 $(b-a)epsilon$；剩下的区间足够小，可以用绝对连续性将积分贡献控制下来。最后极限收紧。

8. 微积分基本定理的证明：

原函数存在性：直接用变上限积分定义，Lebesgue 微分定理保证了原函数的微分是函数.

NL 公式：$H(x)=F(x)-integral_a^x F'(t)dif t$，则 $H'(x)=0 "a.e."$. 由上面的定理，$H(x)$ 常值函数，从而推出 NL 公式.

==== 2.2.4 其他课题

1. 复值函数的绝对连续性保持所有我们想要的性质.

2. 可求长曲线弧长公式：$L(gamma)=integral_a^b sqrt((x'(t))^2+(y'(t))^2) dif t$

公式成立的充要条件：$f(t)=x(t)+i y(t) in "AC"([a,b]_CC)$

$
  V_a^b (f)=L(gamma)=integral_a^b sqrt((x'(t))^2+(y'(t))^2) dif t=integral_a^b abs(f'(t)) dif t
$

== 3 抽象测度

1. $sigma-$代数：空集全集；可数并封闭；补封闭。代数：“可数”变成了“有限”.

例子：$cal(L)_(RR^d), cal(B)_(RR^d),...$

2. 可测空间 $(X, cal(M))$；测度空间 $(X, cal(M)， mu)$. 其中 $mu: cal(M) -> [0,infinity]$ 要求满足可数可加性.

特殊性质的测度：有限测度、概率测度

例子：“子空间”；“加权”Lebesgue 测度；Dirac 测度；计数测度.

性质：单调性、次可数可加性、单调集列测度连续性.

3. 完备测度：任意 $mu-$零测集的子集都属于 $cal(M)$.
    
4. 延拓定理：任意测度可在 $sigma$-代数中添加所有零测集的子集以唯一地延拓成完备测度.

证明：主要部分是证明补集封闭，作 Venn 图之后就能得到要用的集合恒等式 trick.

5. 外测度：要求满足空集零测、单调性、次可数可加性。

6. Caratheodory 定理

满足条件 $mu_* (A)=mu_* (E inter A) + mu_* (E^c inter A), forall A subset X$ 的集合称为 $mu_*$-可测集；

$X$ 上所有 $mu_*$-可测集组成的集合 $cal(M)$ 是一个 $sigma$-代数，且 $mu:=mu|_cal(M)$ 是 $(X, cal(M))$ 上完备测度。

由此可以由外测度引导出测度。

7. 外测度的构造

预测度：在 $X$ 上代数 $cal(A)$ 上满足空集零测性、可数可加性。

预测度诱导出外测度：$mu_*(E):=inf{sum_(j=1)^infinity mu_0(E_j):{E_j} subset cal(A), E subset union_(j=1)^infinity E_j}$.

满足：$mu_*$ 是 $X$ 上外测度；$mu_*|_cal(A)=mu_0$；$cal(A)$ 中元素均 $mu_*$-可测（Caratheodory条件）.

8. 测度空间的一种构造方式：$(X, cal(A), mu_0, mu_*) -->^(cal(M)=sigma(cal(A)))_(mu=mu_*|_cal(M)) (X,cal(M),mu)$

满足： $mu|_cal(A)=mu_0$；若 $mu$ $sigma$-有限，则 $mu$ 是 $cal(M)$ 上唯一的 $mu_0$ 延拓测度。

$sigma$-有限：存在 ${E_j} subset cal(M) "s.t." X=union_j E_j, forall j, mu(E_j)<infinity$.

== 一些刷到的有用的话的整理
“这个题大家做的真有点离谱了，一直在让我反思是不是学期内没有好好强调这些我认为简单的东西。首先，Fubini的条件是积分2维可积，一些学的比较好的同学也认为累次积分可积便可以了，但还差了一个 Tonelli（累次等于另一个累次等于二重积分），这也是Tonelli这个定理存在的一大意义。绝大部分同学（可以说几乎所有）都没提这个步骤。里面的大部分同学甚至是，上来就用Fubini换序，换完以后声称第一问可积和第三问换序的结论都做出来了。这种我都大概给了 12 分，我感觉如果按其他题一样定一个得分点严格改，最多 2 分，因为你完全没有表现出你学过实分析这门课的样子。所以希望大家以后学习的时候见到一个积分交换了次序，还是要下意识的去验证一下是不是多重绝对可积，就像看到极限和积分交换次序要去check控制收敛定理一样。这应该是实分析应该刻进DNA里的样子。” @pksq-1

$0<m(I inter E) <m(I)$ 作业题整理 @mathstackexchange-1

“为什么要引进积分收敛定理？很简单，因为构造一般可测函数的萝卜干积分时就要用到！

怎么应用积分收敛定理？优先考虑单调收敛定理和控制收敛定理，其次考虑Fatou引理/广义控制收敛定理，如果以上方法全都不灵，则考虑Egorov定理。如果以上方法仍有问题，则85%概率以上是这道题目自己有问题。

为什么是这个顺序？因为Egorov定理结论最强：可以做到一致收敛，从而无条件交换lim和积分号。其次，DCT, 广义DCT都是Fatou引理的直接推论，当然是先上儿子再上老子。

如何选取合适的定理？有控制函数的，用DCT；无控制函数但有范数收敛的（例如fn的Lp范数收敛到f的Lp范数），用Fatou；仅有积分上界无收敛性的，考虑Egorov定理。什么都没有的，这题85%以上概率是错题。” @pksq-2


/*
8. 积分理论

可测函数、简单函数、简单函数逼近定理；

积分、可积性、积分性质；

MCT, Fatou, DCT, BCT

9. 乘积测度和 Fubini 定理

== 技术性引理总结
*/