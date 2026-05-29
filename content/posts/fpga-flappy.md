---
title: 用 FPGA 写 Flappy Bird！
date: 2026-05-11
tags:
- 游戏开发
- 计算机体系结构
thumbnailImage: fpgaflappy.png
---

同步一下之前（2024冬）写过的文章~

不知不觉快到期末了，也做完了本学期数字电路实验课程的最后一个实验。我选择了实验中分值最高的，组队用 FPGA 完成一个能在 VGA 屏幕上显示的小游戏。正好，在多年前我用 Gamemaker 复刻过一个 Flappy Bird，于是决定把它搬到 FPGA 上。

<!--more-->

![1734955410118](/blog/images/fpga-flappy/1734955410118.png)

在写完开发文档后才想到去搜网上的实现，结果发现已经有超多人做过了......好在我们应该是完成度最高的（好耶！）。虽然我们的完成度很大一部分贡献来自找到了原版的素材（呜呜），而且还因为没有经验写下了一些超时的组合逻辑（Critical Waring，但是上板不会出问题？），不过还是有一些值得一提的小设计的。

~~其实有看到华科也做过一个完成度相当高的FlappyBird，但他们的实现是写了CPU的，和我们的思路完全不同~~

源代码 → [tinatanhy/Flappybird: A project implementing Flappy Bird using Verilog](https://github.com/tinatanhy/Flappybird)

我发的展示视频 → https://www.youtube.com/shorts/InrxOJ-FaT0

队友发的展示视频 → https://www.bilibili.com/video/BV1w6CNYPEak

本文在经过微调后会作为实验报告提交。

---

## 1 | FPGA 与常规游戏开发的不同之处

### 硬件编程思维

在 FPGA 上，我们需要编写的是硬件模块，而不是串行执行的 CPU 逻辑。这使得我们面向过程或面向对象的思维都不太好用了，除非自己手搓一个 CPU，否则一切都要用状态机实现。因此，我们需要在设计时就完全地考虑游戏中需要的内容，并有层次地设计出状态的更新逻辑。

“函数调用”的思维也不再好用——如果需要把数据交给一个时序逻辑元件计算，就得在本地维护一个状态机，在计算时不断轮询直到计算完毕，再进入下一个状态。与其把游戏逻辑设计成函数的形式，不如思考有没有更“硬件”的实现......？

数据的依赖关系、时序的先后关系也要妥善处理。硬件上的数据都是“并行”处理的，如果有数据依赖另一些数据，就得设计调度器让它们按顺序被计算出来。还有一些元件，如 BROM，有两个 clk 的延时，这种延时引起的问题也常常会引发各种难以修改的 bug。

硬件的一切资源都是静态的，如果要做出“动态生成”的效果，与其设计对象池，不如想想有没有什么更好的替代方案。

---

### 浮点数与图像插值

现代游戏中会有大量浮点数的运算，而对 FPGA 而言，浮点数运算是相当奢侈的。我们希望完全避免浮点数的运算，所以我们选择了 Flappy Bird，并且通过各种设计绕过了游戏中的各种浮点数。

游戏中常见的图像的插值缩放、旋转等操作也会涉及大量浮点数的运算。因此要在游戏开始设计时，就想清楚有哪些不可避免的图像插值，尽可能地将它们预计算好。我们涉及图像插值的操作只有鸟的旋转，而这是在外部算好旋转的帧动画后再导入进来的。

浮点数的困难也让 3D 游戏开发变得比想象中更加困难......就算有计算机图形学基础，在 FPGA 上搓数学库怎么想都会有点噩梦。所以还是稳稳地复刻小游戏吧。

#### 我们的解决方案

我们解决浮点数问题的思路是：

1. 将需要用到除法、三角函数等复杂浮点数运算的地方隔离出来，用预计算处理：只有鸟的旋转。
2. 用「定点数」处理相对简单浮点数的加减乘运算。

浮点数难处理是因为“浮”，所以把点定住不就好了（！）所以我们定义了一种新的数据类型，定点小数。它实际上就是在二进制的数位中打了一个“小数点”。若一共有 `N` 位，其中低 `m` 位前打了小数点，则可以得到以下的运算关系：

|         数学运算         |             代码             |
| :----------------------: | :--------------------------: |
|          $a+b$           |    `a[N-1:0] + b[N-1:0]`     |
|          $a-b$           |    `a[N-1:0] - b[N-1:0]`     |
| $\text{Int} (a)$（取整） |          `a[N-1:m]`          |
|       $a\times b$        | `(a[N-1:0] * b[N-1:0]) >> m` |

我们的游戏中主要用了两种定点小数：

1. `N=32, m=16`，用于处理鸟的运动。

2. `N=8, m=4`，用于处理图像的透明度混合：$C_\text{new}=(1-\alpha)C_\text{src}+\alpha C_\text{dest}$。

   这是经典的的透明度混合公式，用于将抗锯齿的鸟和透明渐入的 Game Over 绘制在屏幕上。颜色的取值范围为$[0,1)$（ `4'h0`到`4'hF`），透明度 $\alpha$ 的取值范围为$[0,1]$（ `5'b0` 到 `5’b10000`），因此 `N=8` 就能保证运算不溢出。

---

### 空间资源的不足

FPGA 上可用于存储图像的 ROM 资源并不富裕。其实觉得 Lab 8 Part 1 放视频的小作业就是为了让我们意识到这一点（？）所以需要在游戏开发前估算好需要的 ROM 资源，尽可能地减少不必要的图像资源，或尽可能压缩现有的图像资源。

---

### 综合、实现要等很久......

每次从修改完成到上板都需要等至少十分钟时间，这没办法。所以要利用好板上的 LED、数码管等资源，将尽可能多的状态信息、Debug 信息输出到板上，在一次更新迭代中观察到更多的信息，以避免反复迭代寻找一个 bug 的来源。

就算如此，一个 bug 修一下午的情况也不会少见。

---

## 2 | 游戏的框架结构

和一般的游戏引擎一样，我们的框架以帧（tick）为基本单位更新游戏状态。因为我们使用的 VGA 屏幕刷新率为 72Hz，所以帧率也设置为了 72FPS。在一帧内，游戏逻辑和游戏绘制分配在两个大模块中运行，此外还有帧时钟、处理按钮输入的模块和根据游戏状态更新的板上 LED、数码管等处理模块。

游戏逻辑（CalcCore）模块是一个「大状态机」，它每帧更新一次，读入外部的输入和上一帧的状态信息，在计算完成后再更新状态机的输出。游戏状态、分数、游戏对象（鸟、管道等）的更新和碰撞检测等均在这个大模块里执行。考虑到这些数据的更新存在依赖关系，如应该先更新管道和鸟的位置，再进行碰撞检测、更新游戏状态和分数，所以大模块的内部设计了一个调度各种小模块的状态机，保证各个数据更新的时序。

而游戏绘制（ViewCore）模块负责读入游戏的各种状态，根据这些状态输出屏幕上各个像素的颜色。它本身不会改变游戏状态。这个大模块中主要有三部分。一部分负责在显示器每轮刷新时锁存游戏状态（因为和游戏逻辑模块不一定是同步更新的，不锁存会导致画面撕裂）；一部分负责和 VGA 显示器对接，输出当前被刷新像素的位置；还有一部分（PixelRenderer）根据像素位置读入各种图像资源 ROM，计算、渲染当前像素的颜色。

![img](/blog/images/fpga-flappy/62d1ce49d0d81ba189889648e9aa04e6.png)

---

## 3 | 每轮游戏的状态设计

我们根据原游戏的设计，将每轮游戏的周期设置为了四个状态：Reset（00）-Ready（01）-Ingame（10）-Gameover（11）。状态的控制由逻辑模块中的 StatusUpdate 模块控制，在下一节中会具体介绍。

---

### 00. Reset 状态

板子启动、从 Gameover 界面重试、按 BTNU 键强制重试时，都会转移至这一状态。这一状态只会持续一帧，在一帧内将重置工作做完后，下一帧就会转入 Ready 状态，开始游戏。

这一状态下会做这些事情：

1. 重置 CalcCore 中所有元件的数据，将所有元件重置到开始游戏前应有的状态。
2. 生成一个世界种子（WorldData.v）。世界种子 `world_seed[15:0]` 一共 16 位，其中第 `15` 位表示当前的场景是白天还是黑夜；第 `[14:13]` 位表示鸟的颜色（因为空间不足只做了黄色鸟，这一特性只在鸟无法旋转的旧版中有所表现）；第 `[12:0]` 位用于生成整个世界的管道，每个世界种子唯一对应一种管道高度分布。在后文会讲到世界种子是怎样参与管道生成的。

世界种子由一个 RNG16 元件生成。我们本来打算做成真随机数，不过队友用一个简单计数器带上小变换实现的效果也不错（？）所以就这样了。毕竟每局游戏的时长是很难控制的，加上世界种子的大部分是用于再随机一次生成管道的，所以以上一局游戏时长为标准生成世界种子也是不错的选择。

---

### 01. Ready 状态

这一状态是开始界面，播放鸟上下浮动、地板向前行进的动画，并显示 Ready 的字样和简单的教程。直到按下 BTNC 时，鸟就会向上跳跃，并进入游戏。

![1734955301565](/blog/images/fpga-flappy/1734955301565.png)

原版的教程图片是手指戳戳，因为上了板子，所以我重绘了一下，做成了提示按 BTNC 按钮的小动图。效果还不错。

![1734955369661](/blog/images/fpga-flappy/1734955369661.png)

---

### 10. Ingame 状态

这是游戏运行中的状态，屏幕上显示分数和管道，玩家正常游玩，直到撞击管道时再进入 Gameover 状态。

![1734955578021](/blog/images/fpga-flappy/1734955578021.png)

---

### 11. Gameover 状态

屏幕震动几帧，半透明渐入地显示 Game Over 字样；鸟下坠落地，地板停止运动，在屏幕上方显示玩家最终的分数。提示玩家游戏已经失败，再按 BTNC 就可以重置游戏，回到 Reset 状态。

![1734955730528](/blog/images/fpga-flappy/1734955730528.png)

---

## 4 | 一帧中的游戏状态更新

### 每帧需要更新的数据

经过我们的归纳总结，绘制模块总共需要以下状态信息参与。这也说明，这些状态信息唯一地决定了当前会显示的画面内容：

```verilog
// Top-WorldData模块：世界背景、鸟的颜色；
input [15:0]          world_seed_in,

// GlobalDataUpdate板块：帧随机数，屏幕震动的信息
input [7:0]              shake_x_in,
input [7:0]              shake_y_in,

// TubeUpdate板块：四根被绘制管道的状态信息
input [11:0]       score_decimal_in,
input [31:0]           tube_pos0_in,
input [15:0]        tube_height0_in,
input [7:0]        tube_spacing0_in,
input [31:0]           tube_pos1_in,
input [15:0]        tube_height1_in,
input [7:0]        tube_spacing1_in,
input [31:0]           tube_pos2_in,
input [15:0]        tube_height2_in,
input [7:0]        tube_spacing2_in,
input [31:0]           tube_pos3_in,
input [15:0]        tube_height3_in,
input [7:0]        tube_spacing3_in,

// BirdUpdate板块：鸟相关的位置、动画状态信息
// 还有相机的横坐标，用于计算屏幕坐标和游戏坐标的关系；
// 不过游戏里的相机是始终跟随鸟的，所以也在这里更新。
input [31:0]              bird_x_in,
input [31:0]           p1_bird_y_in,
input [31:0]    p1_bird_velocity_in,
input [1:0]       bird_animation_in,
input [7:0]        bird_rotation_in,
input [31:0]            camera_x_in,

// StatusUpdate模块：主状态、计数器、时间戳、分数等游戏进行状态信息。
input [1:0]          game_status_in,
input [31:0]               timer_in,
input [31:0]  gameover_timestamp_in,
input [15:0]               score_in,
```

这些信息会传回 Top 模块，被 Top 送进绘制总模块 ViewCore，再被送进像素渲染器 PixelRenderer，被拆分成各个画面元素所需的信息，最终得到每个像素点显示的颜色。一部分信息还会通过 Top 模块显示在板子上。

逻辑总模块 CalcCore 的工作就是负责调度各个子模块，以计算出这些能够决定屏幕显示内容的信息。

---

### 时序元件的统一标准

为了便于时序的控制，我们规定逻辑模块中所有的时序元件需要遵守这样的运行规则：

1. 输入接口中的 `clk` 和 `rstn` 是全局的时钟信号和低电平复位信号；
2. 每当需要开始计算时，外部会向元件发送一时钟周期的 `upd` 脉冲信号，表示应该以该时钟周期时的输入信号为操作数开始运算；
3. 输出接口中的 `finish` 表示是否运算完毕。在接收到 `upd` 信号后，若在当前周期无法计算出结果，就将 `finish` 设置为 0，直到计算完毕再将 `finish` 设置为高电平；需保证 `finish` 处于高电平的时钟周期的输出结果一定是正确的结果。

不管是 CalcCore 这样的大模块，还是其中计算中间数据的小模块，都需要按照这样的规则进行设计，这样就能用统一的方法控制时序。

时序元件内部遵守规则的模式可以体现为状态机；若功能实际上是以组合逻辑模式实现的，即第一周期就能计算出结果，也可以将 `finish` 始终置为 1。

---

### 一帧的具体组成

作为一个大状态机，负责调度数据计算模块的 CalcCore 分为 8 个状态，标号为偶数的状态为等待状态，而标号为奇数的状态会向对应的计算模块发送一个时钟周期的 upd 信号后，立即转移到下一个状态，以按上述规则启动计算模块。

下文将按照每帧的执行顺序，具体讲解逻辑模块涉及的各种元件设计。

#### > 状态 0：等待帧时钟信号

负责等待外部的 `upd` 信号输入。

在 Top 元件中有一个 FrameClock 模块，每 $72\text{Hz}$ 向 CalcCore 发送一个 upd 信号，以启动每帧的数据更新。FrameClock 模块是一个简单实现的计数器。原则上 FrameClock 应该还需要等待 CalcCore 模块的 `finish` 信号，在计数器记录到一帧且 CalcCore 计算完毕后再发送一次 `upd` 信号，以避免中间数据的混乱；不过我们大致估算了计算量，认为这里不会超时，所以没有实现这一功能。

#### > 状态 1→2：更新帧计数器，处理并等待按钮输入和帧随机数

##### A. 帧计数器

CalcCore 主模块中维护了一个 `timer[31:0]` 变量，在游戏开始（Ready 界面）时设置为 0，并在每一帧的开头自增 1。这一计数器在后文会有各种用途，如生成帧随机数、打时间戳等。

##### B. 按钮输入

鸟的运动会依赖按钮输入。我们规定按钮输入也按帧更新，以保证同一帧内各个元件接收到的按钮输入状态均是相同的。输入模块在 `Calc/KeyInput.v` 中实现。

按钮输入状态设计成了一个 3bits 的信号，分别表示：按钮是否刚好在这一帧被按下（Pressed, “上升沿”），按钮在这一帧是否被按住（Check, “高电平”），按钮是否刚好在这一帧被松开（Released, “下降沿”）。

这样设计是为了考虑不同的按钮行为，如鸟只应在按钮刚好按下的一帧设置一次向上的速度；若在按钮按住时一直设置向上速度，鸟就会一直向上飞了，这不符合我们的预期。实际上我们整个游戏中也只用到了 Pressed 信号。Checked 和 Released 为以后可能的应用做准备，但到做出成品也并没有用上。

输入状态的内部实现即边沿检测，且因为是以帧为单位，已经可以忽略抖动，所以用二级寄存器简单实现即可。

##### C. 帧随机数

游戏中可能有一些依赖随机数的情景。在硬件编程中，与其动态地调用生成随机数的模块，不如在每帧开始时就生成一些每帧不同的随机数，来供给帧内的使用。帧随机数（实际上已经变成了专门负责屏幕抖动）的模块在 `Calc/GlobalDataUpdate.v` 中实现。

我们用到帧随机数的场景只有一个：鸟撞到柱子后的几帧触发屏幕抖动。我们尚且不清楚 FPGA 能不能生成真随机数，不过用哈希实现伪随机数对这一项目更加有用。我们实现了一个接收 32 位信号，输出 16 位信号的时序哈希元件，保证输入信号发生微小变化都会使得输出信号发生较大的变化。这样，只要每帧都将 `timer` 输入哈希元件，就可以得到一个每帧都不同的随机数了。

如果要使得每轮游戏的帧随机数都不同，还可以将 `timer` 的一部分异或上世界种子；不过因为这对屏幕抖动的功能并不重要，所以我们没有这样实现。

哈希元件位于 `Utils/Hash32to16.v`。元件内部会对输入信号做多次运算，为了避免组合逻辑超时，我在运算过程中打了几拍。

```verilog
// Tick 0
internel_seed <- seed		// 锁存输入种子，避免下一个时序发生更改

// Tick 1
hash_buffer_next <- ((internal_seed[15:0] ^ (internal_seed[31:16] << 8)) + ((internal_seed[31:16] >> 8) ^ internal_seed[15:0])) * 1209846;  

// Tick 2
hash_buffer_next = (hash_buffer ^ (hash_buffer >> 4)) * 169150151;

// Tick 3
hash_buffer_next = hash_buffer ^ (hash_buffer >> 8);
```

将 Tick 3 后的结果作为最终输出的结果。

#### > 状态 3→4：更新管道，更新鸟的运动和动画帧

##### A. 管道的具体设计

游戏中，我们的主角（鸟）需要越过一根根管道。管道的硬件实现在 `Calc/TubeUpdate.v` 中。

每根管道被抽象成了三个基本信息：`tube_pos[31:0]` 管道的世界坐标；`tube_height[15:0]` 管道的高度；`tube_spacing[7:0]` 上下管道之间的间距。通过这些信息可以完全地进行管道的碰撞检测与绘制。

![1734953895474](/blog/images/fpga-flappy/1734953895474.png)

管道高度应该是完全随机的；管道的世界坐标和间距应当随着分数增长越来越密，以让游戏越来越难，但我们最终没有实现这一效果。管道的世界坐标间隔和上下管道间距在最终的版本中仍然是常数。

在传统的程序设计中，我们的第一想法可能是用一个队列维护管道：当管道进入视野时，就将管道入队；离开视野时，就将管道出队；每帧更新队列中管道的位置，并对这些管道做碰撞检测。这种「实例化」的思想在软件编程中是很实用的，但在硬件编程中确实显得麻烦了。

因此，我做了这样的硬件设计：用 4 组寄存器存储可能被绘制在屏幕上的 4 根管道的基本信息；每一帧都根据当前的分数，计算一次这些管道的基本信息。

注意到如果给每根管道标号，游戏开始时的第一根管道标注为 0 号，那么玩家只会和**标号与玩家分数相同**的管道发生碰撞（分数的增加发生在越过管道后，此时可能与玩家发生碰撞的管道也会相应更新）；屏幕中会显示的管道也是标号与玩家分数临近的几根管道。所以我们可以根据分数确定 4 组寄存器中的管道标号：

| 寄存器编号 | 0            | 1       | 2           | 3           |
| ---------- | ------------ | ------- | ----------- | ----------- |
| 管道标号   | `score - 1 ` | `score` | `score + 1` | `score + 2` |

确定了标号后就能确定帧间同一根管道的**同一性**：我们只要根据标号用同样的算法计算世界坐标、管道间距和高度，得到的同一标号管道的基本信息就是相同的。世界坐标关于标号是简单的线性函数（`-1` 号除外，它会被放在屏幕外的远处，可以特殊讨论），管道间距是常数（如果要做出难度变化也可以加一个曲线映射），而随机高度的计算方法也呼之欲出了：将世界种子和分数打包在一起，送进哈希里得到结果。

```verilog
// ...
Hash32to16 hash32to16_2(
    .clk(clk),
    .rstn(rstn),
    .start(upd),
    .seed({score + 16'd1, 3'b000, seed}),
    .finish(finish2),
    .hash(hash2)
);
// ...
wire [31:0] score_expand = {16'd0, score};
wire [31:0] score_shift = (score_expand << 7) + (score_expand << 6);
// ...
assign tube_pos2_calc = bird_start_x + 32'd576 + score_shift;
assign tube_spacing2_calc = 120;
assign tube_height2_calc = hash2[10:4] + hash2[15:11] + 44;
// ...
assign finish = finish0 & finish1 & finish2 & finish3;
```

其中的数据有经过一些 Tricky 的微调，目的都是为了平衡游戏体验。

~~管道的设计是整个工程里我最喜欢的地方（捂脸）~~

##### B. 鸟的运动更新

游戏中，鸟的运动符合重力的规律。而每按下一次按键，就会把鸟的竖直速度重置为一个向上的速度，这样就能让鸟“跳起来”。因此只要维护鸟的位置和速度，就能确定鸟的运动。鸟的模块实现在 `Calc/BirdUpdate.v`。动画更新也在这个模块中。

鸟的运动是队友写的。其实实现逻辑并不难。枚举游戏状态，若在 Ready 状态，就让鸟上下平移；若在 Ingame 状态，就让鸟随着重力和输入运动；若在 Gameover 状态，就让鸟自由下坠。

在确定鸟运动的同时判断是否越过上边界或者下边界，如果越界就将鸟的位置设置为边界前的位置，这样就能让边界“拦住”鸟了。

不过，由于非阻塞赋值的逻辑，我们不太应该让赋值之间存在依赖关系；注意到这些赋值条件是可以设计成分支结构的，所以我们可以用 `if` 设计好分支，在每个分支中唯一确定下一个速度和位置。按下键盘的初始速度和重力都可以写成 32 位定点小数的形式，如 `32'h00004400`。下文是 Ingame 状态的更新逻辑：

```verilog
if(p1_input[0])begin
    if($signed(p1_bird_y[31:16]) < $signed(BIRD_MINIMUM_Y))begin
        p1_bird_y[31:16] <= BIRD_MINIMUM_Y;
        p1_bird_y[15:0] <= 0;
    end
    p1_bird_velocity <= BIRD_MAX_VELOCITY;
end else begin
    if($signed(p1_bird_y[31:16] + p1_bird_velocity[31:16]) < $signed(BIRD_MINIMUM_Y)) begin
        p1_bird_y[31:16] <= BIRD_MINIMUM_Y;
        p1_bird_y[15:0] <= 0;
        p1_bird_velocity <= 0;
    end else if($signed(p1_bird_y[31:16] + p1_bird_velocity[31:16]) > $signed(BIRD_MAXIMUM_Y)) begin
        p1_bird_y[31:16] <= BIRD_MAXIMUM_Y;
        p1_bird_y[15:0] <= 0;
        p1_bird_velocity <= 0;
    end else begin
        p1_bird_y <= p1_bird_y + p1_bird_velocity;
        p1_bird_velocity <= p1_bird_velocity - 32'h00004400;
    end
end
```

有许多细节需要注意：数值比较需要加 `$signed`；赋值都要对整数部分和小数部分分别处理。

除此之外，每帧还需要将鸟的水平位置平移一下。

##### C. 鸟的动画更新

鸟的动画分为两个维度：翅膀扇动动画和旋转动画。

![1734953319179](/blog/images/fpga-flappy/1734953319179.png)

翅膀扇动动画只需要在帧计时器中每过一个固定的帧数就将动画自增 1 即可；这里的实现方式是也将动画当成了一个“定点小数”，内部用一个 5bit 计数器实现，而输出时只输出 `[4:3]` 位。这样就能得到每 8 帧更新一次动画，4 次更新一循环的效果。

而旋转动画做起来就很麻烦了。我们需要根据鸟的速度做一个曲线，来确定旋转中的帧。鸟的旋转一共有 30 帧，从 $-90^\circ$ 变化到 $+60^\circ$；第 18 帧是 $0^\circ$。

按下按键时，鸟的速度是瞬间变化的，而鸟不应该瞬间旋转；我们用游戏开发中常见的“帧线性插值缓动”技巧来让鸟平滑地旋转到目标位置。此时，线性插值的系数和鸟的竖直速度与目标帧之间的映射都成为了可控制的因素。

FPGA 一次编译需要十分钟以上，这样微调当然是不太现实的。所以我在曾经的复刻版本里实现了一个帧动画控制的鸟旋转，并将系数抄进了 FPGA 版。

不过似乎因为组合逻辑太长，Implement 时这里会报组合超时......但没有出什么大问题，我猜是因为等待管道和后面的碰撞检测的时间里，输入没有变化，足够让这些组合逻辑计算出正确的结果了。

下面是超级 Tricky 的代码......

```verilog
// 第一次映射：给速度映射到一个线性函数上，主要确定缩放和保证速度为 0 时处于 0° 的帧上。
p1_velparam_temp <= ($signed(-p1_bird_velocity) >>> 3) * PARAM_MULT + {16'd15, 16'b0};

// 第二次映射：根据映射给目标帧做一个 Clamp，将目标帧限制在 [1, 36] 之间。
// 注意到上下界还留了空位（区间超过了 30 帧），这是为了让动画更加符合直觉的小 Trick。
if($signed(p1_velparam_temp) < $signed(1)) begin
    p1_bird_velparam <= 32'd1;
end else if($signed(p1_velparam_temp[31:16]) > $signed(36)) begin
    p1_bird_velparam[31:16] <= 16'd36;
    p1_bird_velparam[16:0] <= 0;
end else begin
    p1_bird_velparam <= p1_velparam_temp;
end

// 第三次映射：将实际帧向目标帧做一个线性插值。
p1_bird_velparam_delayed <= (p1_bird_velparam_delayed >>> 7) * (128 - PARAM_LERP) + (p1_bird_velparam >>> 7) * PARAM_LERP;

// 第四次映射：再做一个 Clamp + 平移，将空位切掉，并将区间平移到精灵帧对应的下标。
if($signed(p1_bird_velparam_delayed[31:16] + 1) < $signed(4)) begin
    bird_rotation <= 8'd29;
end else if ($signed(p1_bird_velparam_delayed[31:16] + 1) > $signed(33)) begin
    bird_rotation <= 8'd0;
end else begin
    bird_rotation <= 8'd32 - p1_bird_velparam_delayed[23:16];
end
```

也许在中间打几拍可以规避组合逻辑超时的问题。

#### > 状态 5→6：做碰撞检测，更新分数和游戏状态

CalcCore/StatusUpdate.v 负责这一部分的工作。

这一模块内部例化了一个负责碰撞检测的组合逻辑模块（CalcCore/CollisionCheck.v），将鸟的世界坐标和 1 号管道寄存器的信息输入碰撞检测模块，输出 `collide` 和 `passed` ，前者为 1 则说明该帧发生了碰撞，而后者为 1 则说明该帧玩家通过了 1 号寄存器中的管道，该加分了。

因为管道和玩家的碰撞箱都很简单，所以这里用不等式做判断就好。

```verilog
module CollisionCheck(
    input [31:0] tube_pos,
    input [15:0] tube_height,
    input [7:0] tube_spacing,
    input [31:0] bird_x,
    input [15:0] p1_bird_y,
    output collide,
    output passed
);

parameter TUBE_HITBOX_L = 2;
parameter TUBE_HITBOX_R = 50;
assign passed = bird_x >= tube_pos + TUBE_HITBOX_R;
assign collide = 
    ($signed(p1_bird_y) <= $signed(14)) 
    || (   ($signed(bird_x) <= $signed(tube_pos + TUBE_HITBOX_R + 12))
        && ($signed(bird_x) >= $signed(tube_pos + TUBE_HITBOX_L - 12))
        && ( ($signed(p1_bird_y) <= $signed(tube_height + 8)
           || $signed(p1_bird_y) >= $signed(tube_height + tube_spacing - 8))));
endmodule
```

而 StatusUpdate 模块的其他部分负责维护游戏状态 `game_status[1:0]`、分数 `score`、十进制分数 `score_decimal`（避免在数码管和屏幕上显示时取模）和游戏结束时间戳 `gameover_timestamp[31:0]`（用于控制屏幕震动和 Gameover 标志渐入）。

这一部分会按照以下规则维护游戏状态 `game_status[1:0]`：

- 状态 `00`（Reset）：将分数、十进制分数、游戏结束时间戳都置为 0，并在下一个状态即转入 `01`（Ready）；
- 状态 `01` （Ready）：等待，直到按钮按下（Pressed），就将下一个状态设置为 `10`（Ingame）。
- 状态 `10`（Ingame）：先检查是否发生碰撞，若发生碰撞，则打上游戏结束时间戳，并将下一个状态设置为 `11`（Gameover）；否则检查是否 Passed，如果 Pass 就将分数和十进制分数都自增 1。
- 状态 `11`（Gameover）：等待，直到按钮按下（Pressed），就将下一个状态设置为 `00`（Reset）以重置游戏。

此外，该模块还会接收一个 `reset` 输入（由 BTNU 控制，新开一轮游戏），若 `reset` 输入高电平，则将下一状态设置为 `00` 以强制重置游戏。

#### > 状态 7→0：完成运算

在最后一个状态，向 Top 模块输出一个 Finish 信号，表示完成了所有逻辑运算。

---

## 5 | 游戏的绘制逻辑

### “Shader Approach”

我们并没有采用游戏开发常见的“画布逻辑”，维护一张屏幕大小的画布、由每个对象负责将自己绘制在画布上，而是选择了和 Shader 类似的逻辑，每个像素都读入游戏状态，并根据这些状态和像素位置自行思考自己应该是什么颜色。

我们改造了提供的 DDP 代码，DDP 不再输出地址，而是输出具体的像素坐标；将像素坐标和游戏状态信息送进 PixelRenderer 里，就能通过一套组合逻辑计算出像素自身的颜色。

显示部分的主模块 **ViewCore** 负责锁存信息、调度显示器相关模块，将像素坐标和状态信息送进 PixelRenderer里一起渲染得到显示在屏幕上的颜色。

ViewCore 会在第一帧锁存所有的状态信息。因为绘制帧和逻辑帧不保证同步，状态信息可能在绘制过程中发生更改，因此这一步锁存有助于避免画面撕裂。

每访问到一个新的像素时，PixelRenderer 负责做以下事情：

1. 先根据像素在 VGA 的坐标计算出像素在游戏显示区域的**屏幕坐标**（`screen_x, screen_y`）和在游戏内的**世界坐标**（`game_x, game_y`）。
2. 然后会将这些坐标和各个对象需要的状态数据送给各个对象对应的“子渲染器”，得到须在 ROM 中读取的**地址和遮罩**（如果当前像素上该对象不应被绘制，无法保证地址的正确性，则遮罩为 0，否则遮罩为 1）；
3. 在读取出颜色后再送回子渲染器做**后处理**，得到每个对象的颜色贡献；
4. 最后对它们分层，做**透明度混合**，以确定像素最终的颜色。

这样一套做下来肯定组合逻辑超时了......毕竟一个像素（pclk）仅有两个 clk 的时间。不过居然意外的能跑，很惊喜。

BROM 访问的延时引起了不少难修的 bug。比较违背预期的是遮罩的横坐标需要**提前两个 pclk**，以提前把地址送进 BROM 访问模块里。

---

### PixelRenderer 的渲染过程

#### 1. 像素坐标的预处理

PixelRenderer 会先将像素坐标转换为屏幕坐标和世界坐标。屏幕震动的效果在这一阶段通过偏移（经过有符号扩展的）屏幕坐标实现：

```verilog
wire [15:0] screen_x = $signed(pixel_x + 2 - 256 + $signed({{8{shake_x[7]}}, shake_x}));
wire [15:0] screen_y = $signed(pixel_y - 44 +  $signed({{8{shake_y[7]}}, shake_y}));
wire [31:0] game_x = $signed(camera_x + {31'b0, screen_x} - 31'd80);
wire [31:0] game_y = 400 - screen_y;
```

这一阶段还会顺便把背景棋盘格的颜色计算出来。

```verilog
wire [10:0] grid_x = pixel_x >> 5, grid_y = pixel_y >> 5;
wire [11:0] col_outside = (grid_x[0] ^ grid_y[0]) ? 12'h333 : 12'h222;
```

接下来，PixelRenderer 里会例化一系列子渲染器和 BROMAccess 模块，以对各个画面元素的颜色进行确定。

---

#### 2. BROMAccess：管理 BROM 数据的访问

这一模块（View/BROMAccess.v）负责例化所有的 BROM 模块，输入对各个 BROM 想要访问的地址，输出 BROM 中的颜色信息。

```verilog
input   [16:0]  addr_bg,
input   [9:0]   addr_land,
input   [9:0]   addr_tube,
input   [15:0]  addr_bird,
input   [13:0]  addr_ui,
input   [11:0]  addr_score,
output reg [11:0]  col_bg,
output reg [11:0]  col_land0,
output reg [15:0]  col_tube_0,
output reg [15:0]  col_bird00,
output reg [15:0]  col_bird01,
output reg [15:0]  col_bird02,
output reg [15:0]  col_ui,
output reg [15:0]  col_score
```

该模块还会在每个 pclk 开始锁存所有输入信息，以避免在两个 pclk 之间、数据访存之间改变输入的地址。这样的操作会使得一些 BROM 直接坏掉，导致存储的颜色信息出错、显示出一些杂点杂线，只有重新烧写 bitstream 才能解决。当时我们完全无法找到逻辑出错的问题，也不知道该怎样解决这个 bug，所以叫它「宇宙射线 bug」。最终修好的方式也是连蒙带猜修好的，感谢玄学。

下图框出来的区域是那些「宇宙射线」：

![1734958038470](/blog/images/fpga-flappy/1734958038470.png)

---

#### 3. 子渲染器

子渲染器负责生成蒙版、访存地址和最终的颜色。需要通过子渲染器渲染的元素有：游戏背景、游戏地板、管道、鸟、UI、分数。因为硬件无法选择将要显示的是哪几个元素的内容，所以不如把它们的颜色全部访问出来，再最终根据蒙版选择混合。

游戏中的素材全部是由像素图放大两倍显示的，因此会有明显的像素感。这也需要在渲染器实现。

##### 最简单的：背景渲染器

```verilog
// View/Renderers/BGRenderer.v
module BGRenderer#(
    parameter LATENCY = 0
) (
    input  [15:0] screen_x, screen_y,
    input  [15:0] game_x, game_y,
    input  [15:0] world_seed,
    input  [11:0] col_in,
    output [16:0] addr,
    output        mask,
    output [11:0] col_out
);

assign mask = ($signed(screen_x - LATENCY) >= $signed(1) && $signed(screen_y) >= $signed(0) && $signed(screen_x - LATENCY) < $signed(288) && $signed(screen_y) < $signed(512));
assign addr = ((screen_x + 1) >> 1) + ((screen_y >> 1) << 4) + ((screen_y >> 1) << 7) + ({16'b0, world_seed[15]} << 12) + ({16'b0, world_seed[15]} << 15);
assign col_out = col_in;

endmodule
```

这里通过不等式确定了有无背景的蒙版；通过代数运算将屏幕坐标映射到了背景的访存地址；再将背景颜色不加修改地直接输出。

##### 复杂的：管道渲染器

虽然计算了四根管道的数据，我们最终只绘制了三根。代码看上去虽然很复杂，但重复的内容其实很多。

```verilog
// View/Renderers/TubeRenderer.v
localparam  TUBE_WIDTH = 52;

// 并行 Pass 1

// 计算管道的屏幕坐标
wire [31:0] tube_0_x = game_x - tube_pos0;
wire [31:0] tube_1_x = game_x - tube_pos1;
wire [31:0] tube_2_x = game_x - tube_pos2;
wire [15:0] tube_0_down_y = tube_height0 - game_y;
wire [15:0] tube_1_down_y = tube_height1 - game_y;
wire [15:0] tube_2_down_y = tube_height2 - game_y;
wire [15:0] tube_0_up_y = game_y - (tube_height0 + tube_spacing0 + 1);
wire [15:0] tube_1_up_y = game_y - (tube_height1 + tube_spacing1 + 1);
wire [15:0] tube_2_up_y = game_y - (tube_height2 + tube_spacing2 + 1);

// Mask 由横向和纵向分开计算。二者之并为最终的 Mask。
// 计算横向的 Mask
wire tube_mask_0_x =    $signed(game_x) >= $signed(tube_pos0) && $signed(game_x - LATENCY) < $signed(tube_pos0 + TUBE_WIDTH + 1);
wire tube_mask_1_x =    $signed(game_x) >= $signed(tube_pos1) && $signed(game_x - LATENCY) < $signed(tube_pos1 + TUBE_WIDTH + 1);
wire tube_mask_2_x =    $signed(game_x) >= $signed(tube_pos2) && $signed(game_x - LATENCY) < $signed(tube_pos2 + TUBE_WIDTH + 1);
// 计算下方管道的纵向 Mask
wire tube_mask_0_down = ($signed(game_y) <= $signed(tube_height0)) && tube_mask_0_x;
wire tube_mask_1_down = ($signed(game_y) <= $signed(tube_height1)) && tube_mask_1_x;
wire tube_mask_2_down = ($signed(game_y) <= $signed(tube_height2)) && tube_mask_2_x;
// 计算上方管道的纵向 Mask
wire tube_mask_0_up =   ($signed(game_y) >  $signed(tube_height0 + tube_spacing0)) && tube_mask_0_x;
wire tube_mask_1_up =   ($signed(game_y) >  $signed(tube_height1 + tube_spacing1)) && tube_mask_1_x;
wire tube_mask_2_up =   ($signed(game_y) >  $signed(tube_height2 + tube_spacing2)) && tube_mask_2_x;

// 求并
wire tube_place_mask = (tube_mask_0_up || tube_mask_0_down || tube_mask_1_up || tube_mask_1_down || tube_mask_2_up || tube_mask_2_down);

// 并行 Pass 2
// 将屏幕坐标标准化成管道在未压缩的图上的坐标
wire [9:0] tube_x = (({10{tube_mask_0_x}} & tube_0_x[9:0]
                  |   {10{tube_mask_1_x}} & tube_1_x[9:0]
                  |   {10{tube_mask_2_x}} & tube_2_x[9:0])) >> 1;
wire [9:0] tube_y = ({10{tube_mask_0_down}} & tube_0_down_y[9:0]
                  |  {10{tube_mask_1_down}} & tube_1_down_y[9:0]
                  |  {10{tube_mask_2_down}} & tube_2_down_y[9:0]
                  |  {10{tube_mask_0_up}}   &   tube_0_up_y[9:0]
                  |  {10{tube_mask_1_up}}   &   tube_1_up_y[9:0]
                  |  {10{tube_mask_2_up}}   &   tube_2_up_y[9:0]) >> 1;

// Pass 3
// 根据未压缩图上的 y 坐标计算压缩后图上的 y 坐标
wire [3:0] tube_img_y = {3{($signed(tube_y) == 0)}} & 4'd0
                      | {3{($signed(tube_y) == 1)}} & 4'd1
                      | {3{($signed(tube_y) >= 2 && $signed(tube_y) <= 9)}} & 4'd2
                      | {3{($signed(tube_y) == 10)}} & 4'd3
                      | {3{($signed(tube_y) == 11)}} & 4'd0
                      | {3{($signed(tube_y) == 12)}} & 4'd5
                      | {3{(tube_y > 12)}} & 4'd6;

// 与透明度结合决定 Mask
assign mask = col_in[3] & tube_place_mask;
// 根据压缩图上的 x，y 坐标决定访问地址
assign addr = tube_place_mask ? (tube_img_y * 26 + tube_x) : 10'd256;
// 不做后处理，直接输出颜色
assign col_out = col_in;
```

管道的图像在压缩后如下，是一张 26*7 的图片：

![1734959412856](/blog/images/fpga-flappy/1734959412856.png)

管道的纵向坐标将会经过一个分段函数映射后得到正确的颜色。

##### 显示数字：分数渲染器

十进制分数最高只能增加到 999。这为我们的偷懒提供了帮助：我们只要对一位数、两位数、三位数分别写好分数的绘制方式，根据位数做一次选择，就能得到最终绘制的蒙版和颜色。

而分数字体用一个 120 * 18 的精灵存储：

![1734959639147](/blog/images/fpga-flappy/1734959639147.png)

```verilog
// View/Renderers/ScoreRenderer.v
localparam num_w = 12, num_h = 18, img_w = 120,
		   score_y = 54, 
           score_x11 = 144 - 12,
		   score_x21 = 144 - 24,
		   score_x22 = 144 - 0,
		   score_x31 = 144 - 12 - 24,
		   score_x32 = 144 - 12,
		   score_x33 = 144 - 12 + 24;
// Pass 1
// 这是一个选择器，决定当前显示的位数；
wire score_view_1 = ~(|score_decimal[11:8]) & ~(|score_decimal[7:4]),
     score_view_2 = ~(|score_decimal[11:8]) & (|score_decimal[7:4]),
     score_view_3 = (|score_decimal[11:8]);
// 计算分数的访存坐标
wire [11:0] score_posx_11 = (screen_x - score_x11) >> 1;
wire [11:0] score_posx_21 = (screen_x - score_x21) >> 1;
wire [11:0] score_posx_22 = (screen_x - score_x22) >> 1;
wire [11:0] score_posx_31 = (screen_x - score_x31) >> 1;
wire [11:0] score_posx_32 = (screen_x - score_x32) >> 1;
wire [11:0] score_posx_33 = (screen_x - score_x33) >> 1;
wire [11:0] score_posy    = (screen_y - score_y) >> 1;
// 计算每一位数的访存地址
wire [11:0] score_addr_11 = score_posx_11 + img_w * score_posy + score_decimal[3:0] * num_w;
wire [11:0] score_addr_21 = score_posx_21 + img_w * score_posy + score_decimal[7:4] * num_w;
wire [11:0] score_addr_22 = score_posx_22 + img_w * score_posy + score_decimal[3:0] * num_w;
wire [11:0] score_addr_31 = score_posx_31 + img_w * score_posy + score_decimal[11:8] * num_w;
wire [11:0] score_addr_32 = score_posx_32 + img_w * score_posy + score_decimal[7:4] * num_w;
wire [11:0] score_addr_33 = score_posx_33 + img_w * score_posy + score_decimal[3:0] * num_w;

// Pass 2
// 根据显示位数、游戏状态，对 x 和 y 分量分别计算 Mask；
wire score_mask_y = ($signed(screen_y) >= score_y) && ($signed(screen_y) < score_y + 36);
wire score_mask_x11 = game_status[1] && score_view_1 && ($signed(screen_x) >= $signed(score_x11)) && ($signed(screen_x - LATENCY) < $signed(score_x11 + 24));
wire score_mask_x21 = game_status[1] && score_view_2 && ($signed(screen_x) >= $signed(score_x21)) && ($signed(screen_x) < $signed(score_x21 + 24));
wire score_mask_x22 = game_status[1] && score_view_2 && ($signed(screen_x) >= $signed(score_x22)) && ($signed(screen_x - LATENCY) < $signed(score_x22 + 24));
wire score_mask_x31 = game_status[1] && score_view_3 && ($signed(screen_x) >= $signed(score_x31)) && ($signed(screen_x) < $signed(score_x31 + 24));
wire score_mask_x32 = game_status[1] && score_view_3 && ($signed(screen_x) >= $signed(score_x32)) && ($signed(screen_x) < $signed(score_x32 + 24));
wire score_mask_x33 = game_status[1] && score_view_3 && ($signed(screen_x) >= $signed(score_x33)) && ($signed(screen_x - LATENCY) < $signed(score_x33 + 24));
// 求并，得到位置 Mask。
wire score_place_mask = score_mask_y & (score_mask_x11 || score_mask_x21 || score_mask_x22 || score_mask_x31 || score_mask_x32 || score_mask_x33);

// 结合透明度信息得到最终的 Mask。
assign mask = score_place_mask & col_in[3];
// 将不同位数字对应的 Mask 信息通过一个选择器决定访存的地址；而 12'd2161 是一个透明像素的地址。
assign addr = score_place_mask ? ({12{score_mask_y}} & (
	  {12{score_mask_x11}} & score_addr_11
	| {12{score_mask_x21}} & score_addr_21
	| {12{score_mask_x22}} & score_addr_22
	| {12{score_mask_x31}} & score_addr_31
	| {12{score_mask_x32}} & score_addr_32
	| {12{score_mask_x33}} & score_addr_33
)) : 12'd2161;
// 不加后处理地输出颜色
assign col_out = col_in;
```

##### UI 渲染器

这里只展示根据时间戳计算 Gameover 渐入的透明度的部分。

```verilog
wire [31:0] gameover_delta_time = timer - gameover_timestamp;
wire [31:0] alpha_time = $signed(gameover_delta_time) < 0 ? 0 :
                         $signed(gameover_delta_time) > 31 ? 31 : 
                         $signed(gameover_delta_time);
assign col_out = {col_in[15:4], (col_in[3:0] & {4{mask}} & ({4{game_status != 2'b11}} | alpha_time[4:1]))};
```

先将时间和时间戳相减，得到经过的时间；再做一个 Clamp，将透明度限制在 $[0,1)$ 上；再和颜色一起输出透明度。

其余的子渲染器与这些渲染器类似，都是一些很麻烦的代码（呜呜）可以参见源代码。

---

#### 4. Alpha 混合

我们将游戏的图层分为了三层：UI层（最上层）、鸟层（中间层）和其他元素层（最下层）。最上层有 Gameover 的透明度需要加以混合；鸟层有边缘抗锯齿的半透明像素需要混合；而其他元素层不含任何透明度混合。

PixelRenderer 会先用选择器综合得到每一层对应的像素颜色和透明度，再用线性插值方法将它们混合起来。

```verilog
// Layer 0
wire [11:0] rgb_layer0 = 
	(~screen_mask) ? col_outside :
	(score_mask) ? col_score[15:4] : 
	(land_mask) ? col_land :
	(tube_mask) ? col_tube[15:4] :
	col_bg;

// Layer 1
wire [11:0] rgb_layer1 = col_bird[15:4];
wire [4:0] a_layer1 = ({1'b0, col_bird[3:0]} + |col_bird[3:0]) & {5{screen_mask}};

// Layer 2
wire [11:0] rgb_layer2 = col_ui[15:4];
wire [4:0] a_layer2 = {1'b0, col_ui[3:0]} + |col_ui[3:0];

// Blending Layer 0&1
wire [7:0] r_blend_1 = rgb_layer0[11:8] * (8'b00010000 - a_layer1) + rgb_layer1[11:8] * a_layer1;
wire [7:0] g_blend_1 = rgb_layer0[ 7:4] * (8'b00010000 - a_layer1) + rgb_layer1[ 7:4]  * a_layer1;
wire [7:0] b_blend_1 = rgb_layer0[ 3:0] * (8'b00010000 - a_layer1) + rgb_layer1[ 3:0]  * a_layer1;

// Blending Blend1 & Layer2
wire [7:0] r_blend_2 = r_blend_1[7:4] * (8'b00010000 - a_layer2) + rgb_layer2[11:8] * a_layer2;
wire [7:0] g_blend_2 = g_blend_1[7:4] * (8'b00010000 - a_layer2) + rgb_layer2[ 7:4]  * a_layer2;
wire [7:0] b_blend_2 = b_blend_1[7:4] * (8'b00010000 - a_layer2) + rgb_layer2[ 3:0]  * a_layer2;

// Final Result
assign rgb = {r_blend_2[7:4], g_blend_2[7:4], b_blend_2[7:4]};
```

其中，透明度值都加上了一个 `|col_bird[3:0]` 或者 `|col_ui[3:0]`。这相当于一个分段函数，将大于 0 的值都加 1，而 0 保持为 0 不变。这个小 Trick 是为了将透明度的范围从 `[0,15]`（$[0,1)$）映射到 `[0,16]` （$[0,1]$），以在后面的混合中得到完全不透明时的结果。因为玩家不易注意到低透明度时的透明度变化，所以挖掉 `1` 比挖掉其他的透明度更加合算。

而混合部分就是对每个分量做平凡的线性插值混合，在计算机图像处理或者计算机图形学一类的课会经常见到：
$$
C_\text{new}=(1-\alpha)C_\text{src}+\alpha C_\text{dest}
$$
这一部分大概吃了不少组合延时。能算出来真的相当神奇了，再次感谢玄学（什么）

## 6 | 板上的控制

### 按钮与拉杆

板上的 BTNC 负责游戏的主要控制，BTNU 负责重置游戏，在上文已经介绍过了。

`SW[15]` 控制无敌模式，当拉杆拉下时不会再受到伤害。

`SW[14]` 控制超速模式，使鸟的水平速度增加到原来的 20 倍，可以快速飞到分数比较远的地方检查有没有 Bug 发生。

![1734961005729](/blog/images/fpga-flappy/1734961005729.png)

### 通过拉杆输出 Debug 信息

为了 Debug 的方便，我们在 Top 模块中对不同的 SW 输入情况输出了不同的 LED 灯值和数码管。具体如下，也欢迎自行探索：

#### SW[15:0]=??00_0000_0000_0000

如果没有开启无敌模式，就会根据游戏状态输出不同视效信息：

- Ready 状态：数码管闪烁输出「FLAPPY」字样；LED 闪烁。
- Ingame 状态：数码管输出十进制分数；LED 播放流动动画。
- Gameover 状态：数码管输出十进制分数；LED 闪烁。

如果开启了无敌模式，LED 就会加速闪烁，数码管闪烁输出「god bird」字样。

#### SW[15:0]=0000_0000_0000_0001

输出 CalcCore 的各个状态信息。

- `LED[7:0]`：哪个灯亮，就表示 CalcCore 目前处于哪个状态，用于在状态卡住时进行 Debug；也能起 Profile 作用，灯的亮度会显示状态的耗时；但实际的测试结果是状态 0 常亮，说明每帧的时间是充裕的。
- `LED[8]`：由 timer 控制闪烁，表示游戏在正常进行。如果不闪了就说明 CalcCore 卡住了。
- `LED[11:9]`：输出 BTNC 的按键信息，检查按键是否被正确处理（似乎有时会有玄学 bug 导致按键不被处理）。从 9 到 11 分别对应 Pressed，Check，Released 状态。Pressed 和 Released 只会闪烁一瞬间，相机很难捕捉到。
- `LED[12]`：输出 BTNU 的按下信号，表示触发重试。
- `LED[13]`：常暗。亮了就说明板子的其他地方出了玄学问题。
- `LED[15:14]`：输出游戏主状态 `game_status`，用于检查。
- 左侧四组数码管：输出鸟的 y 坐标（十进制）。
- 右侧四组数码管：前三位输出十进制的分数信息 `score_decimal`；第四位输出 `score % 10`，用于检查。

#### SW[15:0]=0000_0000_0000_0010

- LED 和右侧四组数码管都显示世界种子 `world_seed[15:0]`。

#### SW[15:0]=0000_0000_0000_0100

- 数码管和 LED 都显示计时器 `timer` 的值（16 进制/二进制）。

#### SW[15:0]=0000_0000_0000_1000

- LED 显示二进制的分数值；
- 左侧四组数码管显示鸟的游戏坐标的后四位（十进制）；
- 右侧四组数码管显示屏幕上 1 号寄存器的管道右边缘横坐标的后四位（十进制），即唯一与玩家可能碰撞的管道位置。

#### SW[15:0]=0000_0000_0001_0000

- LED 显示二进制的分数值；
- 右侧四组数码管显示屏幕上 1 号寄存器的管道左边缘横坐标的后四位（十进制），即唯一与玩家可能碰撞的管道位置。
- 左侧四组数码管显示管道的高度（十进制）。

#### SW[15:0]=0000_0000_0010_0000

- LED 同 SW=0000_0000_0000_0001 的情形。不会显示 BTNU 的信号，是因为忘记了。
- 右侧四组数码管显示玩家的速度整数部分，但是是按照无符号十进制显示的。
- 左侧四组数码管显示玩家的高度（十进制）。

#### SW[15:0]=0000_0000_0100_0000

- 显示专为 CalcCore 预留的 Debug 输出接口信息。测试用。

#### SW[15:0]=0000_0000_1000_0000

- 显示专为 ViewCore 预留的 Debug 输出接口信息。测试用。

### 数码管的实现

实际开发板的数码管信号和 FPGA Online 不一样。实际开发管中每根管的亮灭都是可以控制的，须通过一个 7 bit 、低电平有效的信号向每组数码管输出每根管是否点亮。

```
//   ---6--- 
//  |       |
//  1       5
//  |       |
//   ---0--- 
//  |       |
//  2       4
//  |       |
//   ---3---
```

我们实现了两种数码管的显示模式，一种是输入每根数码管的 16 进制数字，在数码管上显示出来，和平时作业中的 SegWithMask 的行为是相同的；这种模式能够方便地输出各种 Debug 信息。

```verilog
// Hardware/SegWithMask.v
module SegWithMask(  
    input                   clk,        // 100MHz 时钟  
    input                   rst,        // 复位信号 (高电平有效)  
    input       [31:0]     output_data,// 输出数据  
    input       [ 7:0]     output_valid, // 每个数码管的有效信号  
    output reg  [ 6:0]     seg_data,   // 7段显示器数据输出  
    output reg  [ 7:0]     seg_an      // 8位数码管阳极控制  
);  

    reg [31:0] counter;  
    reg [2:0]  seg_id; // 管 Id, 用于选择哪个数码管  
    reg [3:0]  seg_data1; // 存储当前要显示的4位数据  

    // 生成400Hz的信号  
    always @(posedge clk) begin  
        if (rst) begin  
            counter <= 0;  
            seg_id <= 0;  
        end else begin  
            if (counter >= 24999) begin   
                counter <= 0;  
                seg_id <= seg_id + 1;   
                if (seg_id >= 3'b111) begin // 0-7的循环  
                    seg_id <= 0; // Reset seg_id when it exceeds the last index (7)  
                end  
            end else begin  
                counter <= counter + 1;  
            end  
        end  
    end  

    // 控制数码管  
    always @(*) begin  
        if (output_valid[seg_id]) begin // 检查当前管是否有效  
            case (seg_id)  
                3'b000: begin  
                    seg_data1 = output_data[3:0];   
                    seg_an = 8'b11111110;  // 选择第一个数码管  
                end       
                3'b001: begin  
                    seg_data1 = output_data[7:4];      
                    seg_an = 8'b11111101;  // 选择第二个数码管  
                end  
                3'b010: begin  
                    seg_data1 = output_data[11:8];      
                    seg_an = 8'b11111011;  // 选择第三个数码管  
                end  
                3'b011: begin  
                    seg_data1 = output_data[15:12];     
                    seg_an = 8'b11110111;  // 选择第四个数码管  
                end  
                3'b100: begin  
                    seg_data1 = output_data[19:16];     
                    seg_an = 8'b11101111;  // 选择第五个数码管  
                end  
                3'b101: begin  
                    seg_data1 = output_data[23:20];     
                    seg_an = 8'b11011111;  // 选择第六个数码管  
                end  
                3'b110: begin  
                    seg_data1 = output_data[27:24];     
                    seg_an = 8'b10111111; // 选择第七个数码管  
                end  
                3'b111: begin  
                    seg_data1 = output_data[31:28];     
                    seg_an = 8'b01111111;  // 选择第八个数码管  
                end  
                default: begin  
                    seg_data1 = 4'b0000;  // 如果没有选择，默认输出为0  
                    seg_an = 8'b11111111; // 关闭所有数码管  
                end  
            endcase   
        end else begin  
            seg_data1 = 4'b0000;  // 如果无效，输出为0  
            seg_an = 8'b11111111;  // 关闭所有数码管  
        end   

        // 根据4位数字选择7段显示  
        case(seg_data1)  
            4'b0000: seg_data = ~7'b0111111; // 0 -> inverse   
            4'b0001: seg_data = ~7'b0000110; // 1 -> inverse   
            4'b0010: seg_data = ~7'b1011011; // 2 -> inverse   
            4'b0011: seg_data = ~7'b1001111; // 3 -> inverse   
            4'b0100: seg_data = ~7'b1100110; // 4 -> inverse   
            4'b0101: seg_data = ~7'b1101101; // 5 -> inverse   
            4'b0110: seg_data = ~7'b1111101; // 6 -> inverse   
            4'b0111: seg_data = ~7'b0000111; // 7 -> inverse   
            4'b1000: seg_data = ~7'b1111111; // 8 -> inverse   
            4'b1001: seg_data = ~7'b1101111; // 9 -> inverse   
            4'b1010: seg_data = ~7'b1110111; // A -> inverse   
            4'b1011: seg_data = ~7'b1111111; // B -> inverse   
            4'b1100: seg_data = ~7'b0111001; // C -> inverse   
            4'b1101: seg_data = ~7'b1011110; // D -> inverse   
            4'b1110: seg_data = ~7'b1111001; // E -> inverse   
            4'b1111: seg_data = ~7'b1110001; // F -> inverse   
            default: seg_data = 7'b1111111;  // Close all segments (i.e., turned on)  
    endcase  
    end  
endmodule
```

另一种输入模式则是通过一个 56 位信号直接输入每根管的点亮与否，可以用来显示各种非数字的字符或者图案。具体实现就是上述代码除去了查表的部分。例如，下面的 56 位信号表示了 “FLAPPY” 字样：

```verilog
SegData2 = 56'b1111111_0001110_1000111_0001000_0001100_0001100_0010001_1111111;
```

## 7 | 显示屏输出

这一部分是最早实现的，却放在了文章的后面（？）

![img](/blog/images/fpga-flappy/317290c10d9c81ec9a7b8a62d6af2990.jpg)

只要跟着文档一步步做，就能显示出视频啦。因为没什么设计，这里就简单放一下实现的方法，作为实验报告了。

### DST

用于控制显示屏是否接收串口的颜色信息。只要输出理想的波形就好。其中的 Latency 参数用于控制图片的访存延迟。

```verilog
module DST#(
    parameter  LATENCY = 2
) (
    input                   [ 0 : 0]            rstn,
    input                   [ 0 : 0]            pclk,

    output      reg         [ 0 : 0]            hen,        //水平显示有效
    output      reg         [ 0 : 0]            ven,        //垂直显示有效
    output      reg         [ 0 : 0]            hs,         //行同步
    output      reg         [ 0 : 0]            vs          //场同步
);

localparam HSW_t    = 119;
localparam HBP_t    = 63 - LATENCY;
localparam HEN_t    = 799;
localparam HFP_t    = 55 + LATENCY;

localparam VSW_t    = 5;
localparam VBP_t    = 22;
localparam VEN_t    = 599;
localparam VFP_t    = 36;

localparam SW       = 2'b00;
localparam BP       = 2'b01;
localparam EN       = 2'b10;
localparam FP       = 2'b11;

reg     [ 0 : 0]    ce_v;

reg     [ 1 : 0]    h_state;
reg     [ 1 : 0]    v_state;

reg     [15 : 0]    d_h;
reg     [15 : 0]    d_v;

wire    [15 : 0]    q_h;
wire    [15 : 0]    q_v;

CntS #(16,HSW_t) hcnt(          //每个时钟周期计数器增加1，表示扫描一个像素
    .clk        (pclk),
    .rstn       (rstn),
    .d          (d_h),
    .ce         (1'b1),

    .q          (q_h)
);

CntS #(16, VSW_t) vcnt(           
    .clk        (pclk),  
    .rstn       (rstn),  
    .d          (d_v),  
    .ce         (ce_v),  
    .q          (q_v)  
); 
always @(*) begin
    case (h_state)
        SW: begin
            d_h = HBP_t;  hs = 1; hen = 0;
        end
        BP: begin
            d_h = HEN_t;  hs = 0; hen = 0;
        end
        EN: begin
            d_h = HFP_t;  hs = 0; hen = 1;
        end
        FP: begin
            d_h = HSW_t;  hs = 0; hen = 0;
        end
    endcase
    case (v_state)  
        SW: begin  
            d_v = VBP_t;  vs = 1; ven = 0; 
        end  
        BP: begin  
            d_v = VEN_t;  vs = 0; ven = 0; 
        end  
        EN: begin  
            d_v = VFP_t;  vs = 0; ven = 1; 
        end  
        FP: begin  
            d_v = VSW_t;  vs = 0; ven = 0; 
        end  
        default: begin  
            d_v = 0; vs = 0; ven = 0; 
        end  
    endcase  
end

always @(posedge pclk) begin
    if (!rstn) begin
        h_state <= SW; v_state <= SW; ce_v <= 1'b0;
    end
    else begin
        if(q_h == 0) begin
            h_state <= h_state + 2'b01;
            if (h_state == FP) begin
                ce_v <= 0;
                if (q_v == 0)
                    v_state <= v_state + 2'b01;
            end
            else
                ce_v <= 0;
        end
        else if (q_h == 1) begin
            if(h_state == FP)
                ce_v <= 1;
            else
                ce_v <= 0;
        end
        else ce_v <= 0;
    end
end
endmodule
```

### PS

上边沿检测模块，也可以用来检测下边沿。考虑到 DST 输出的信号应该没有明显抖动，且需要及时响应，这里只用了二级寄存器。

```verilog
module PS#(
	parameter  WIDTH = 1
) (
	input             s,
	input             clk,
    input             rstn,
	output            p
);

reg sig_r1, sig_r2;

always @(posedge clk) begin
    if(~rstn) begin
        sig_r1 <= 1'b0;
        sig_r2 <= 1'b0;
    end else begin
        sig_r1 <= s;
        sig_r2 <= sig_r1;
    end
end

assign p = sig_r1 & ~sig_r2;
endmodule
```

在我的理解里，去抖动应该是为了按钮、拉杆等输入信号服务，而不是为了这些内部信号服务的？我们其实全程都没有涉及到“去抖动”的设计。

### DDPGame

DDP 像一个“像素计数器”（？）对显示在屏幕上的像素作计数，将计数器的值映射到颜色。对助教的 DDP 做了大幅度的修改，从输出访存地址改为了输出像素位置。只要放开用乘法器（？）用像素位置做访存似乎更自然。

```verilog
module DDPGame#(
        parameter H_LEN = 800,
        parameter V_LEN = 600
)(
    input               hen,
    input               ven,
    input               rstn,
    input               pclk,
    input  [11:0]       rdata,

    output reg [11:0]   rgb,
    output reg [10:0]   pixel_x, pixel_y
);

wire p;
PS #(1) ps(
    .s      (~(hen&ven)),
    .clk    (pclk),
    .rstn(rstn),
    .p      (p)
);

always @(posedge pclk) begin            //可能慢一个周期，改hen,ven即可
    if(!rstn) begin
        rgb   <= 12'b0;
        pixel_x <= 0;
        pixel_y <= 0;
    end 
    else if(hen && ven) begin
        rgb <= rdata;
        pixel_x <= pixel_x + 1;
    end                             
    else if(p) begin                
        rgb <= 0;
        pixel_x <= 0;
        if(pixel_y == V_LEN - 1) begin
            pixel_y = 0;
        end
        else begin
            pixel_y <= pixel_y + 1;
        end
    end
    else rgb <= 0;
end

endmodule
```

## 8 | 碎碎念

Blog 怎么写了这么长！（呜呜）

设计的部分思考了好几天。写代码的时间一共是 5 个下午 + 4 个晚上（？）感觉还是很充实快乐的。

与其把它当成 Verilog 的大作业，我更愿意把它当成一个限制性编程的小挑战。打破传统思维，用一种新的硬件编程思维去做游戏，意外地很新鲜很好玩。对下个学期的组原课程也许也充满动力了。

终于做完了！耶