#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "北京大学 2023-2025 推免机试题笔记",
  date: datetime(year: 2026, month: 6, day: 29),
  weight: 0,
  tags: (
    category: ("TCS", "题解")
  ),
  draft: false,
  references: ```bib
  ```,
)

#let Var = "Var"
#let inner(a, b) = $chevron.l #a, #b chevron.r$
#let outer(a, b)= $#a and #b$

北京大学计算机学院推免夏令营机考为 ACM 赛制，时长 2 小时，每场共 8 题，题目可能是中文或英文，部分题目（主要是英文题）选自 OJ 中已有的题目。题目不按难度排序，整体难度在 CF Div4（大部分题）到 Div2 D（1\~2题） 之间，能切 Div2 D 的同学可以放心考试。据说实际不爆零就能通过。

有意向报考北大计算机学院研究生的同学可以提前准备刷题。

= 题源整理

== 2025 #link("http://bailian.openjudge.cn/tm2025cs/", "比赛（无数据）")
- #link("http://bailian.openjudge.cn/practice/2992/","A. Lab 杯") 
- #link("http://bailian.openjudge.cn/practice/2976/","B. All in All")
- #link("http://bailian.openjudge.cn/tm2025cs/C/","C. 表达式求值") （无数据）
- #link("http://bailian.openjudge.cn/tm2025cs/D/","D. 忍者道具") （无数据）
- #link("http://bailian.openjudge.cn/tm2025cs/E/","E. 神奇的数列") （无数据）
- #link("http://bailian.openjudge.cn/practice/2994/","F. 拼装模型")
- #link("http://bailian.openjudge.cn/practice/2367/","G. Genealogical Tree")
- #link("http://bailian.openjudge.cn/tm2025cs/H/","H. 怀表问题") （无数据）

== 2024 #link("http://bailian.openjudge.cn/tm2024cs/", "比赛（无数据）")
- #link("http://bailian.openjudge.cn/tm2024cs/A/", "A. 字符串中最长的连续出现的字符") （无数据）
- #link("http://bailian.openjudge.cn/practice/4133/", "B. 垃圾炸弹")
- #link("http://bailian.openjudge.cn/tm2024cs/C/", "C. 传送法术") （无数据）
- #link("http://bailian.openjudge.cn/tm2024cs/D/", "D. 电影院排座") （无数据）
- #link("http://bailian.openjudge.cn/practice/2002/", "E. 正方形")
- #link("http://bailian.openjudge.cn/practice/1240/", "F. Pre-Post-erous!")
- #link("http://bailian.openjudge.cn/practice/1789/", "G. Truck History")
- #link("http://bailian.openjudge.cn/practice/2449/", "H. Remmarguts' Date")

== 2023 #link("http://bailian.openjudge.cn/tm2023cs/", "比赛（无数据）")
- #link("http://bailian.openjudge.cn/practice/1936/", "A. 全在其中")
- #link("http://bailian.openjudge.cn/tm2023cs/B/", "B. 最接近的分数") （无数据）
- #link("http://bailian.openjudge.cn/practice/4103/", "C. 踩方格")
- #link("http://bailian.openjudge.cn/tm2023cs/D/", "D. 核电站") （无数据）
- #link("http://bailian.openjudge.cn/tm2023cs/E/", "E. 合法出栈序列") （无数据）
- #link("http://bailian.openjudge.cn/tm2023cs/F/", "F. 海盗船") （无数据）
- #link("http://bailian.openjudge.cn/practice/2485/", "G. Highways")
- #link("http://bailian.openjudge.cn/practice/1684/", "H. Dynamic Declaration Language (DDL)")

下文为我个人编写的题解，无数据的题不保证正确，欢迎在评论区中反馈。按题目难度排序。

= 2025 题解

个人向难度排序：A < B < F < D < (Div4) < G < E < (Div2 C) < C < H < (Div2 D)。

== A. Lab 杯：模拟
```cpp
const int maxn = 100 + 10;

int n, a[maxn][maxn];

int main()
{
	scanf("%d", &n);
	for(int r = 1; r <= n; r++)
		for(int c = 1; c <= n; c++)
			scanf("%d", &a[r][c]);
	int k = 0, winmost = 0;
	for(int r = 1; r <= n; r++)
	{
		int win = 0;
		for(int c = 1; c <= n; c++)
		{
			if(a[r][c] >= 3)
			{
				win++;
			}
		}
		if(win > winmost)
		{
			winmost = win;
			k = r;
		}
	}
	printf("%d\n", k);
	return 0;
}
```
== B. All in All：简单字符串
```cpp
const int maxn = 100000 + 10;

char s[maxn], t[maxn];

int main()
{
	while(true)
	{
		scanf("%s %s", s, t);
		if(s[0] == '\0') break;
		int p = 0;
		int lens = strlen(s), lent = strlen(t);
		for(int i = 0; i < lent; i++)
		{
			if(t[i] == s[p])
				p++;
			if(p == lens) break;
		}
		printf(p == lens ? "Yes\n" : "No\n");

		s[0] = '\0';
		t[0] = '\0';
	}
	return 0;
}

```
== C. 表达式求值：较复杂的模拟；编译原理

编译原理题。

有点懒得写编译原理那套 LL/LR 文法，干脆直接对栈内状态做一些假设：栈顶端的值一旦能确定就马上确定，直到无法确定是否会受到新加入的值影响为止。我们分析一下布尔表达式：
- 遇到 `)` 时，直到最近的 `(` 内的值都不会受到后续值影响了，应立即 collapse 到一个布尔值。处理完这一步后，我们消去了栈顶的所有括号，栈顶一定是一个布尔值 `var` ，栈顶的前一个符号一定是运算符 `symbol`，或者左括号 `(`，或者是空值 `NULL`。如果是空值意味着运算已经结束；如果是左括号就意味着需要继续接受符号。
- 此时当 `symbol == !` 时，`!var` 值可以直接确定，不受后续影响，直接 collapse 栈顶的布尔值 `var` 到 `!var`，并将栈顶的 `!` 和 `var` 消去。此后栈顶的前一个符号一定是 `&`, `|`, `(`, `NULL` 中的一个。
- 由于此时表达式右部的优先级仅有 `& > |`，因此当前一个符号是 `&` 时，栈顶的布尔值 `var` 和栈顶的前一个布尔值 `var2` 可以直接 collapse 到 `var2 & var`，并将栈顶的 `&` 和两个布尔值消去。此后栈顶的前一个符号一定是 `|`, `(`, `NULL` 中的一个，一直向后处理直至读完或者遇到右括号，括号内的部分一定是 `var | var | var ...` 的形式，括号内的值可以直接简单 collapse 到一个布尔值。

技巧是能够假设出一些好处理的栈状态。

```cpp
const int maxn = 100000 + 10;
string line;
char stk[maxn];
int p = 0;
bool tb(char c) { return c == 'V'; }
bool isvf(char c) { return c == 'V' || c == 'F'; }
char tc(bool b) { return b ? 'V' : 'F'; }
void debug_stack()
{
	printf("stack: ");
	for(int i = 0; i < p; i++)
		printf("%c", stk[i]);
	printf("\n");
}
int main()
{
	while(true)
	{
		getline(cin, line);
		if(line[0] == '\0') break;
		for(char c : line)
		{
			if(c == ' ') continue;
			stk[p++] = c;
			debug_stack();
			if(stk[p - 1] == ')')
			{
				char ket_symbol = stk[--p];
				bool final_bool = false;
				char expect_symbol;
				do
				{
					char var_symbol = stk[--p];
					final_bool |= tb(var_symbol);
					expect_symbol = stk[--p];
				}
				while(expect_symbol != '(');
				stk[p++] = tc(final_bool);
				debug_stack();
			}
			while(p >= 2 && isvf(stk[p - 1]) && stk[p - 2] == '!')
			{
				char var_symbol = stk[--p];
				char not_symbol = stk[--p];
				stk[p++] = tc(!tb(var_symbol));
				debug_stack();
			}
			while(p >= 3 && isvf(stk[p - 1])  && stk[p - 2] == '&')
			{
				char b_symbol = stk[--p];
				char and_symbol = stk[--p];
				char a_symbol = stk[--p];
				stk[p++] = tc(tb(a_symbol) && tb(b_symbol));
				debug_stack();
			}
		}
		bool final_bool = false;
		for(int i = 0; i < p; i++)
		{
			if(stk[i] == 'V') final_bool = true;
		}
		printf("%c\n", tc(final_bool));
		p = 0;
		line[0] = '\0';
	}
	return 0;
}
```
== D. 忍者道具：搜索
看到数据范围 $N<=18$ 我们就知道可以枚举全排列。
```cpp
const int maxn = 100000 + 10, inf = 1 << 30;

int n, w, c[maxn], vis[maxn];

int dfs(int ci, int cw, int cm)
{
	vis[ci] = true;
	if(cw >= c[ci])
	{
		cw -= c[ci];
	}
	else
	{
		cw = w;
		cm++;
	}
	int ans = inf;
	for(int i = 1; i <= n; i++)
		if(!vis[i])
			ans = min(dfs(i, cw, cm), ans);
	vis[ci] = false;
	return ans == inf ? cm : ans;
}

int main()
{
	scanf("%d%d", &n, &w);
	for(int i = 1; i <= n; i++)
		scanf("%d", &c[i]);
	int ans = inf;
	for(int i = 1; i <= n; i++)
		ans = min(dfs(i, w, 1), ans);
	printf("%d\n", ans);
	return 0;
}

```
== E. 神奇的数列：动态规划
动态规划。考虑维护 `dp[l][r]` 表示区间 `[l, r]` 的最少操作数。我们可以考虑区间的两端：
- 如果 `a[l] == a[r]`，则我们可以考虑将两端的相同元素一次解决，中间的区间 `[l', r']` 需要 `dp[l'][r']` 次操作，最终结果为 `dp[l'][r'] + 1`。
- 如果 `a[l] != a[r]`，则我们可以枚举一个中间点 `mid`，将区间 `[l, r]` 分为 `[l, mid]` 和 `[mid + 1, r]` 两个子区间分别分解，最终结果为 `dp[l][mid] + dp[mid + 1][r]` 的最小值。
因为懒得列方程所以就记忆化搜索解决了。
```cpp
const int maxn = 200 + 10, inf = 1 << 30;

int n, a[maxn];
int dp[maxn][maxn];

int dfs(int l, int r)
{
	if(dp[l][r] != -1) return dp[l][r];
	if(l == r) return dp[l][r] = 1;
	if(a[l] == a[r])
	{
		int c = a[l];
		int tl = l, tr = r;
		while(tl <= tr && a[tl] == c) tl++;
		while(tl <= tr && a[tr] == c) tr--;
		if(tl > tr) return dp[l][r] = 1;
		else return dp[l][r] = dfs(tl, tr) + 1;
	}
	dp[l][r] = inf;
	for(int mid = l; mid <= r - 1; mid++)
	{
		dp[l][r] = min(dfs(l, mid) + dfs(mid + 1, r), dp[l][r]);
	}
	return dp[l][r];
}

int main()
{
	int t;
	scanf("%d", &t);
	for(int T = 1; T <= t; T++)
	{
		scanf("%d", &n);
		for(int i = 1; i <= n; i++)
			scanf("%d", &a[i]);
		for(int i = 1; i <= n; i++)
			for(int j = 1; j <= n; j++)
				dp[i][j] = -1;
		printf("Case %d: %d\n", T, dfs(1, n));
	}
	return 0;
}
```
== F. 拼装模型：贪心
每次取开销最小的两个模型拼接。
```cpp
const int maxn = 100000 + 10;
int n;
priority_queue<ll, vector<ll>, greater<ll>> q;

int main()
{
    scanf("%d", &n);
    for(int i = 1; i <= n; i++)
    {
        int x;
        scanf("%d", &x);
        q.push(x);
    }
    ll ans = 0;
    while(q.size() > 1)
    {
        ll a = q.top(); q.pop();
        ll b = q.top(); q.pop();
        ans += a + b;
        q.push(a + b);
    }
    printf("%lld\n", ans);
    return 0;
}
```
== G. Genealogical Tree：拓扑排序
拓扑排序模板题。
```cpp
const int maxn = 100 + 10;
int n;
vector<int> es[maxn];
int deg[maxn], vis[maxn], ans[maxn], p = 1;

void dfs(int o)
{
    if(vis[o]) return;
    vis[o] = true;
    ans[p] = o;
    p++;
    for(int i = 0; i < es[o].size(); i++)
    {
        int v = es[o][i];
        deg[v]--;
        if(deg[v] == 0) dfs(v);
    }
}

int main()
{
    scanf("%d", &n);
    for(int i = 1; i <= n; i++)
    {
        deg[i] = 0;
        vis[i] = false;
    }
    for(int i = 1; i <= n; i++)
    {
        while(true)
        {
            int x;
            scanf("%d", &x);
            if(x == 0) break;
            es[i].push_back(x);
            deg[x]++;
        }
    }
    for(int i = 1; i <= n; i++)
        if(deg[i] == 0)
            dfs(i);
    for(int i = 1; i <= n; i++)
        printf("%d ", ans[i]);
    return 0;
}
```
== H. 怀表问题：简单组合计数
一道比较麻烦的组合计数。

对于题目所说的各种情形，我们简化为：我们要用 `aa`, `ab`, `bb`, `ba` 四种表链组合在一起，使得头尾为 `a, b (have_tail == 0)` 或 `a, a (have_tail == 1)`。先考虑头尾为 `a, b` 的情形，由连接规则可得组合形式是 `aa* ab bb* ba aa* ab ... ba aa* ab bb*`（其中 `*` 表示任意个，可为空，我们这里称为“bubble”，代表需要往里面填 `aa` 或 `bb`）。我们考虑枚举 bubbles 的数目，即可得到 `aa` bubble 和 `bb` bubble 的数目、得到该状态下需要的 `ab` 和 `ba` 的数量并检查是否足够、得到还需要填充多少（`n_need`）个 `aa` 或 `bb`。枚举我们目前有且可以组合出 `n_need` 个表链的 `(aa, bb)` 数目，则剩下的部分就是组合数问题了：将 `a` 个 `aa` 放进 `a_bub` 个桶中，将 `b` 个 `bb` 放进 `b_bub` 个桶中（可以转换为隔板法，将 `a_bub-1` 个隔板插入 `a+1` 个位置），用乘法原理相乘，再将所有答案加起来。

```cpp
const int maxn = 42;
const int LL = 0, LV = 1, VV = 2, VL = 3;
int str_to_type(char x, char y)
{
	if(x == 'L' && y == 'L') return LL;
	if(x == 'L' && y == 'V') return LV;
	if(x == 'V' && y == 'V') return VV;
	if(x == 'V' && y == 'L') return VL;
	return -1;
}

int n, k;
ll c[maxn][maxn];

ll calc(ll x, ll y)
{
	// 把 x 件物品放进 y 个桶中的放法数目。
	return c[x + 1][y - 1];
}

ll calc_bubbles(int aa, int ab, int bb, int ba, int have_tail)
{
	ll ans = 0;
	for(int bub = 2 - have_tail; bub - 1 <= k; bub += 2)
	{
		int a_bub = bub / 2 + have_tail;
		int b_bub = bub / 2;
		int n_need = k - (bub - 1);
		int l = max(n_need - bb, 0);
		int r = min(n_need, aa);
		if(ab < bub / 2 || ba < bub / 2 - 1 + have_tail || aa + bb < n_need)
			continue;
		for(int a = l; a <= r; a++)
		{
			int b = n_need - a;
			ans += calc(a, a_bub) * calc(b, b_bub);
		}
	}
	return ans;
}

int main()
{
	// 预计算组合数
	{
		c[0][0] = 1;
		c[1][0] = 1;
		c[1][1] = 1;
		for(int n = 2; n < maxn; n++)
		{
			c[n][0] = 1;
			for(int r = 1; r <= n; r++)
				c[n][r] = c[n - 1][r - 1] + c[n - 1][r];
		}
	}
	while(true)
	{
		scanf("%d %d", &n, &k);
		if(n == -1) break;
		char s[3];
		int num[4], exp_type;
		num[LL] = num[LV] = num[VV] = num[VL] = 0;
		scanf("%s", s);
		exp_type = str_to_type(s[0], s[1]);
		for(int i = 1; i <= n; i++)
		{
			scanf("%s", s);
			num[str_to_type(s[0], s[1])]++;
		}
		ll ans = 0;
		if(exp_type == LL) ans = calc_bubbles(num[LL], num[LV], num[VV], num[VL], 1);
		if(exp_type == VL) ans = calc_bubbles(num[LL], num[LV], num[VV], num[VL], 0);
		if(exp_type == VV) ans = calc_bubbles(num[VV], num[VL], num[LL], num[LV], 1);
		if(exp_type == LV) ans = calc_bubbles(num[VV], num[VL], num[LL], num[LV], 0);
		if(ans > 0) printf("YES\n%lld\n", ans);
		else printf("NO\n");
		n = -1; k = -1;
	}
	return 0;
}

```

= 2024 题解

这场难度是按顺序排序的（除了实际上 G 可能比 F 简单一点）。除最后一题外整体比 2025 年简单一些，我认为前 7 题难度不超过 CF Div3。

== A. 字符串中最长的连续出现的字符：简单字符串
```cpp
const int maxn = 200 + 10;

char s[maxn];
int main()
{
	scanf("%s", s);
	int n = strlen(s), ans = 0, cur = 1;
	char anschar;
	for(int i = 1; i <= n; i++)
	{
		if(s[i] == s[i - 1]) cur++;
		else
		{
			if(cur > ans)
			{
				anschar = s[i - 1];
				ans = cur;
			}
			cur = 1;
		}
	}
	printf("%c %d\n", anschar, ans);
	return 0;
}
```
== B. 垃圾炸弹：模拟
因为炸弹至少要炸掉一个垃圾，我们考虑只暴力检查垃圾周围的位置，时间复杂度就足以通过了。

这题的坑非常多，交的时候挂了几次，务必多检查。
```cpp
const int maxn = 20 + 10, maxx = 1025;

int d, n, xx[maxn], yy[maxn], ii[maxn];
bool vis[maxx][maxx];

int check(int x, int y)
{
	int res = 0;
	for(int i = 1; i <= n; i++)
		if(abs(xx[i] - x) <= d && abs(yy[i] - y) <= d)
			res += ii[i];
	return res;
}

int main()
{
	scanf("%d%d", &d, &n);
	for(int i = 1; i <= n; i++)
		scanf("%d%d%d", &xx[i], &yy[i], &ii[i]);
	int ans = 0, ansn = 1;
	for(int i = 1; i <= n; i++)
		for(int y = yy[i] - d; y <= yy[i] + d; y++)
			for(int x = xx[i] - d; x <= xx[i] + d; x++)
			{
				if(x < 0 || x >= maxx || y < 0 || y >= maxx) continue;
				int cur = check(x, y);
				if(cur > ans)
				{
					ansn = 1;
					ans = cur;
					vis[x][y] = true;
				}
				else if(cur == ans && !vis[x][y])
				{
					ansn++;
					vis[x][y] = true;
				}
			}
	printf("%d %d\n", ansn, ans);
	return 0;
}

```
== C. 传送法术：搜索；问题转化
可以消耗一个代价传送到镜像位置，那么就等价于给地图复制反转并粘到下一行形成一个 2\*n 的迷宫。剩下的就是搜索了。
```cpp
const int maxn = 1000 + 10, inf = 1 << 30;

struct tr { int x, y, d; };
int n, sx, ans = -1;
char maze[2][maxn];
queue<tr> q;

int main()
{
    scanf("%d\n%s", &n, maze[0]);
    for(int x = 0; x < n; x++)
    {
        maze[1][n - x - 1] = maze[0][x];
        if(maze[0][x] == 'S') sx = x;
    }
    q.push({sx, 0, 0});
    while(!q.empty())
    {
        tr t = q.front(); q.pop();
        if(maze[t.y][t.x] == '#') continue;
        if(maze[t.y][t.x] == 'T') 
        {
            ans = t.d;
            break;
        }
        if(maze[t.y][t.x] == 'V') continue;
        maze[t.y][t.x] = 'V';
        if(t.x >= 1) q.push({t.x - 1, t.y, t.d + 1});
        if(t.x < n - 1) q.push({t.x + 1, t.y, t.d + 1});
        if(t.y == 0) q.push({t.x, 1, t.d + 1});
        if(t.y == 1) q.push({t.x, 0, t.d + 1});
    }
    printf("%d\n", ans);
    return 0;
}
```
== D. 电影院排座：动态规划
比较经典的 DP 题。记 $f_(j, i, k)$ 为目前分配到前 $j$ 个座位、共分配了 $i$ 人、在当前座位有人（$k=1$）或无人（$k=0$）时，能取得的最大舒适度。不合法的状态舒适度设置为 $-infinity$。则最终答案应为 $max{f_(n,m,0),f_(n,m,1)}$.

对于状态转移，若要在当前位置分配人，则前一个位置必须没有人；如果不分配，则前一个位置有没有人都没关系，因此可以列出状态转移方程：
$
f_(j,i,0)&=max{f_(j-1,i,0),f_(j-1,i,1)},quad
f_(j,i,1)&=f_(j-1,i-1,0)+a_j
$
直接 DP 即可。注意到这个方程还可以用滚动数组优化，但这题没卡空间就懒了。
```cpp
const int maxn = 4000 + 10, maxm = 2000 + 10, inf = 1 << 30;

int n, m, a[maxn], dp[maxn][maxm][2];

int main()
{
    scanf("%d%d", &n, &m);
    for(int i = 1; i <= n; i++) scanf("%d", &a[i]);
		dp[0][0][1] = -inf;
    for(int i = 1; i <= m; i++)
    {
        dp[0][i][0] = -inf;
        dp[0][i][1] = -inf;
    }
    for(int j = 1; j <= n; j++)
        for(int i = 1; i <= m; i++)
        {
            dp[j][i][0] = max(dp[j - 1][i][0], dp[j - 1][i][1]);
            dp[j][i][1] = dp[j - 1][i - 1][0] + a[j];
        }
    printf("%d\n", max(dp[n][m][0], dp[n][m][1]));
    return 0;
}
```
== E. 正方形：计算几何
考虑枚举对角线，并用向量计算的方法找到另外两点的坐标并检查是否都存在顶点，即能找到正方形。因为正方形有两条对角线所以会重复统计两次，答案除以 2 即可。需要注意的是对负数向量取模的操作会有坑。
```cpp
const int maxn = 1000 + 10;

int n, x[maxn], y[maxn];
map<pair<int, int>, bool> mp;

int main()
{
	while(true)
	{
		scanf("%d", &n);
		if(n == 0) break;
		mp.clear();
		for(int i = 1; i <= n; i++) 
		{
			scanf("%d%d", &x[i], &y[i]);
			mp[{x[i], y[i]}] = true;
		}
		int ans = 0;
		for(int i = 1; i <= n - 1; i++)
			for(int j = i + 1; j <= n; j++)
			{
				int vx = x[j] - x[i], vy = y[j] - y[i];	// 向量
				int rvx = -vy, rvy = vx;	// 逆时针旋转 90°
				if((vx + rvx + 40000) % 2 == 1 || (vy + rvy + 40000) % 2 == 1) continue;	// 中点不在格点上
				int tvx = (vx + rvx) / 2, tvy = (vy + rvy) / 2;	// 取中值就是正方形边向量
				if(mp[{x[i] + tvx, y[i] + tvy}] && mp[{x[j] - tvx, y[j] - tvy}])
					ans++;
			}
		printf("%d\n", ans / 2);
	}
	return 0;
}

```
== F. Pre-Post-erous!：树
这题的题目表述有一个陷阱：已知先序遍历序和后序遍历序，其实是可以完全确定树的结构的。知道这个结论后就很简单了，我们需要做的是找到有多少种填充空位的方式，实际上就是计算每个节点关于容量和子节点数的组合数，然后乘法原理乘起来即可。

我做这题的时候忘记怎样从先序遍历序和后序遍历序确定树结构了，现场推了一下。先序遍历序中一个节点到下一个节点的关系可能是子节点，也有可能子节点已经遍历完，是某个父亲的下一个子节点。观察到后序遍历中父子关系一定呈现逆序，因此不断检查这一点向上递归地找到一个合适的父节点添加子节点即可。
```cpp
const int maxn = 26 + 3;

int n, m;
char s1[maxn], s2[maxn];
int num2[maxn], fa[maxn], odeg[maxn], c[maxn][maxn];

int main()
{
  {
    // 预计算组合数
		c[0][0] = 1;
		c[1][0] = 1;
		c[1][1] = 1;
		for(int n = 2; n < maxn; n++)
		{
			c[n][0] = 1;
			for(int r = 1; r <= n; r++)
				c[n][r] = c[n - 1][r - 1] + c[n - 1][r];
		}
	}
    while(true)
    {
        scanf("%d ", &m);
        if(m == 0) break;
        for(int i = 0; i < 26; i++)
        {
            odeg[i] = 0;
            num2[i] = 0;
            fa[i] = -1;
        }
        scanf("%s %s\n", s1, s2);
        n = strlen(s1);
        for(int i = 0; i < n; i++)
            num2[s2[i] - 'a'] = i;
        for(int i = 1; i < n; i++)
        {
            int u = s1[i - 1] - 'a';
            int v = s1[i] - 'a';
            int o = u;
            while(num2[o] < num2[v]) o = fa[o];
            fa[v] = o;
            odeg[o]++;
        }
        ll ans = 1;
        for(int i = 0; i < 26; i++)
            if(odeg[i] > 0)
                ans *= c[m][odeg[i]];
        printf("%lld\n", ans);
    }
    return 0;
}
```
== G. Truck History：最小生成树
题目看上去比较唬人，找一棵代价最小的“继承树”，实际上考虑到继承关系边无论怎么指向都是一样的权重，本题就可以转化为在完全图上找一棵最小生成树了。
```cpp
const int maxn = 2000 + 10, maxm = 2000 + 10, inf = 1 << 30;

int n, m;
char s[maxn][maxm];
int fa[maxn];

int Find(int o) { return o == fa[o] ? o : fa[o] = Find(fa[o]); }
void Union(int u, int v) { fa[Find(u)] = Find(v); }

struct edge
{
    int u, v, w;
    bool operator<(const edge& b) const { return w > b.w; }
};

int main()
{
    while(true)
    {
        scanf("%d\n", &n);
        if(n == 0) break;
        for(int i = 1; i <= n; i++) scanf("%s\n", s[i]);
        m = strlen(s[1]);
        for(int i = 1; i <= n; i++) fa[i] = i;
        priority_queue<edge> pq;
        for(int i = 1; i < n; i++)
            for(int j = i + 1; j <= n; j++)
            {
                int w = 0;
                for(int k = 0; k < m; k++)
                    if(s[i][k] != s[j][k])
                        w++;
                pq.push({i, j, w});
            }
        int ans = 0;
        while(!pq.empty())
        {
            edge e = pq.top(); pq.pop();
            if(Find(e.u) != Find(e.v))
            {
                ans += e.w;
                Union(e.u, e.v);
            }
        }
        printf("The highest possible quality is 1/%d.\n", ans);
    }
    return 0;
}
```
== H. Remmarguts' Date：k 短路

防 AK 题。有向图 k 短路模板题，然而我还不会 k 短路，所以不写了。参考：
- #link("https://oi-wiki.org/graph/kth-path/", "k 短路 - OI Wiki")
- #link("https://www.luogu.com.cn/problem/P2483", "P2483 【模板】k 短路 / [SDOI2010] 魔法猪学院 - 洛谷")

= 2023 题解

这场整体比 2024 年 2025 年都简单，主要是有两道大模拟。

== A. 全在其中：简单字符串
和 #link("#loc-7","2025B All in All") 完全相同。说明还是会考往年题。
== B. 最接近的分数：枚举
```cpp
int main()
{
	int n, a, b;
	scanf("%d %d %d", &n, &a, &b);
	int ansi = 0, ansj = 1;
	for(int i = 1; i <= n; i++)
		for(int j = 1; j <= n; j++)
			if(i * b < a * j && ansi * j < i * ansj)
			{
				ansi = i; ansj = j;
			}
	printf("%d %d\n", ansi, ansj);
	return 0;
}
```
== C. 踩方格：搜索
```cpp
const int maxn = 100 + 10;
int n, vis[maxn][maxn];
ll dfs(int x, int y, int d)
{
	if(vis[x][y]) return 0;
	if(d == n) return 1;
	vis[x][y] = 1;
	ll ans = dfs(x - 1, y, d + 1) + dfs(x + 1, y, d + 1) + dfs(x, y - 1, d + 1);
	vis[x][y] = 0;
	return ans;
}
int main()
{
	scanf("%d", &n);
	printf("%lld\n", dfs(50, 50, 0));
	return 0;
}
```
== D. 核电站：动态规划
设 $f_(i, j)$ 表示在前 $i$ 个位置上，最后有 $j$ 个连续的核弹时的方案数。则可设置初值 $f_(0, 0)=1$ 代表没有位置、什么都不放算一种方案。可以在尾部添加一个虚拟空位使得 $f_(n+1, 0)$ 表示所求答案。状态转移为，下一个空位不放核弹，则方案数为此前所有可行状态的方案数之和；否则如果放核弹，方案数为此前状态中最后有 $j-1$ 个连续核弹的方案数。

注意到这题还可以用滚动数组优化。进一步地，可以写成一个 $m times m$ 矩阵，然后手算特征值或者矩阵快速幂解决。但这题数据范围给得很小所以直接 DP 就够了。

$
"ans"=mat(1,1,1,1,...,1)mat(1,1,1,1,...,1;1,0,,,...,;,1,0,,...,;,,1,0,...,;,,,,...,;,,,,1,0)^n vec(1,0,0,0,...,0)
$

其实感觉这个数据范围剪枝爆搜也能做出来。
```cpp
const int maxn = 50 + 10;

int n, m;
ll f[maxn][maxn];

int main()
{
	scanf("%d%d", &n, &m);
	f[0][0] = 1;
	for(int i = 1; i <= n + 1; i++)
	{
		f[i][0] = f[i - 1][0];
		for(int j = 1; j <= m - 1; j++)
		{
			f[i][0] += f[i - 1][j];
			f[i][j] = f[i - 1][j - 1];
		}
	}
	printf("%lld\n", f[n + 1][0]);
	return 0;
}
```
== E. 合法出栈序列：模拟
同时维护一个栈和一个出栈队列，可以理解为不断按给定顺序入栈，不断检查当前栈头是不是该出栈了，如果可以出栈，就弹出栈头并让出栈序列移到下一个。模拟即可。
```cpp
const int maxn = 100 + 10;
char x[maxn], s[maxn], stk[maxn];
int main()
{
	scanf("%s\n", x);
	int n = strlen(x);
	while(true)
	{
		scanf("%s\n", s);
		if(s[0] == '\0') break;
		int p = 0, q = 0;
		for(int i = 0; i < n; i++)
		{
			stk[p++] = x[i];
			while(q < n && p > 0 && s[q] == stk[p - 1])
			{
				p--; q++;
			}
		}
		printf((p == 0 && q == n) ? "YES\n" : "NO\n");
		s[0] = '\0';
	}
	return 0;
}
```
== F. 海盗船：搜索，模拟
大模拟，暂时不是很想做，考场遇到肯定放后面。由于深搜可能会陷入一直转来转去的坏情况，这里需要用广搜或者迭代加深搜索做。
== G. Highways：最小生成树
由 Highway 的定义我们需要求出图的最大边最小的生成树，由 Kruskal 算法的过程可知 Kruskal 可以自然求出这棵生成树。
```cpp
const int maxn = 2000 + 10, maxm = 2000 + 10, inf = 1 << 30;
int n, m, fa[maxn];
int Find(int o) { return o == fa[o] ? o : fa[o] = Find(fa[o]); }
void Union(int u, int v) { fa[Find(u)] = Find(v); }
struct edge
{
    int u, v, w;
    bool operator<(const edge& b) const { return w > b.w; }
};
int main()
{
    int t;
    scanf("%d", &t);
    for(int T = 1; T <= t; T++)
    {
        scanf("%d", &n);
        priority_queue<edge> pq;
        for(int u = 1; u <= n; u++) fa[u] = u;
        for(int u = 1; u <= n; u++)
            for(int v = 1; v <= n; v++)
            {
                int w;
                scanf("%d", &w);
                if(v > u)
                    pq.push({u, v, w});
            }
        int ans = 0;
        while(!pq.empty())
        {
            edge e = pq.top(); pq.pop();
            if(Find(e.u) != Find(e.v))
            {
                ans = e.w;
                Union(e.u, e.v);
            }
        }
        printf("%d\n", ans);
    }
    return 0;
}

```
== H. Dynamic Declaration Language (DDL)：模拟；计算机系统

又一道大模拟。汇编语言模拟器。暂时不想做。