---
description: 计算机网络学习笔记，参考《计算机网络-自顶向下方法》。 这章内容涉及许多层，相当于一个大的概括，之后才会解析每个层次的内容。
title: 《计算机网络-自顶向下》学习笔记
cover: https://cos.asuka-xun.cc/blog/assets/compute-network.jpg
date: 2022/10/23
math: true
categories:
- [计算机网络]
- [计算机科学]
tags:
- 计算机网络
- 计算机科学
- 计算机网络-自顶向下
---
# 计算机网络

计算机网络学习笔记，参考《计算机网络-自顶向下方法》。

## 计算机网络和因特网

这章内容涉及许多层，相当于一个大的概括，之后才会解析每个层次的内容。

### 计算机网络

#### 因特网构成描述

因特网是一个世界范围的计算机网络，即它是一个互联了遍及全世界数十亿计算设备的网络，也被称为 “网中网”，我们现在使用的网络都是大网中的小网。

- 接入网络的设备——**网络边缘**
  
  网络边缘是靠近最终用户并直接连接到网络核心的子网。 网络边缘设备的示例包括WiFi 接入点、带有配线间交换机的分支机构和个人计算机。 
  
  - 与因特网相连的计算机和其他设备称为**端系统**（end system）也称为**主机**（host）

- 通信链路（communication link）——**接入网**
  
  - 媒介：同轴电缆、铜线、光纤、无线电频谱
  - 传输速率：带宽 bps
  - **分组**：一台端系统向另一台端系统发送数据时，发送端系统将数据**分段**，并为每段加上首部字节，由此形成的信息包用计算机网络的术语称为**分组**。

- 分组交换机（packet switch）——**网络核心**
  
  - **路由器**（router）和 **链路层交换机**（link-layer switch）

- **协议**（protocol）：控制发送、接收信息。比如，TCP, IP, HTTP等等。每个层次有每个层次的协议。
  
  > 协议定义了在两个或多个通信实体之间交换的报文的格式和顺序，以及报文发送和/或接收一条报文或其他事件所采取的动作。

- **网络标准**（因特网标准）
  
  - 由**因特网工程任务组（IETF）**制定网络标准
  - IETF 的标准文档称为**请求评论（RFC）**
  
  ![image-20221024162602370](https://cos.asuka-xun.cc//blog/image-20221024162602370.png)

#### 因特网服务描述

此处有提到**套接字接口**（socket interface）。

- 为应用程序提供服务的基础设施
  
  即用户使用应用。

- 应用程序编程接口
  
  即编写应用。

###  网络边缘（Network Edge）

 与因特网相接的计算机及其他设备位于因特网的边缘，称为**端系统**。

端系统 = 主机，可以被划为下面两种：

- 客户（client）
- 服务器（server）：比如有企业存储大量数据的大型**数据中心**（data centers）

#### 接入网

**接入网**是将端系统物理连接到其**边缘路由器**（edge router）的网络。**边缘路由器**是端系统到任何其他远程端系统的第一台路由器。

![image-20221024164006130](https://cos.asuka-xun.cc//blog/image-20221024164006130.png)

##### 家庭接入：DSL、电缆、FTTH、拨号和卫星

这说的啥我也不知道，直接跳也没什么问题，可以去看看原书籍上的说明。

- **数字用户线**（digital subscriber line，**DSL**）
  
  利用**电话线路**接入网络。其中 **ADSL**是非对称的数字用户线，基本都用ADSL，因为一般下行的数据量都远大于上行的数据量，所以要设计成非平衡的链路。
  
  采用**独占**的**频分多路复用**来传输。因为利用的是原有的电话线路，所以需要将DSL传输的网络信号（上行、下行）和电话信号通过频分多路复用来区分开来。

| 频段     | 传输信号   |
|:------ |:------ |
| 0~4K   | 电话语音线路 |
| 4K~50K | 上行信号   |
| 50K~1M | 下行信号   |

![image-20221024164532140](https://cos.asuka-xun.cc//blog/image-20221024164532140.png)

> 上行：上传的速度。
> 
> 下行：下载的速度。
> 
> 一般下行速度大于上行速度。

- **电缆因特网接入**（cable Internet access）
  
  利用**有线电视网**接入网络。结构上，通过粗的同轴电缆接入社区，再用细的同轴电缆接入每家每户。
  
  采用**共享**的**频分多路复用**来传输。

- **混合光纤同轴电缆**（**HFC**）

##### 企业（家庭）接入：以太网和WiFi

- **以太网**：使用双绞铜线与一台以太网交换机相连，速率可达到100Mbps、1Gbps、10Gbps。
- **WiFi**：IEEE802.11技术无线LAN，范围在几十米内。

####  物理媒体（Physical Media）

- 导引型媒体（guided media）：信号在固体媒体中传输，比如光缆、双绞铜线和同轴电缆。
- 非导引型媒体（unguided media）：电波在空气中传播，比如无线局域网或数字卫星频道。

### 网络核心（Network Core）

网络核心：由端系统的分组交换机和链路构成的网状网络。下图画出来的部分即使网络核心。

一共有三种交换方式：报文交换（很少使用）、分组交换和电路交换。

![image-20221024202908744](https://cos.asuka-xun.cc//blog/image-20221024202908744.png)

- **报文**（message）：报文包含协议设计者需要的任何东西。
- **分组**：源端系统向目的地发送报文，源将长报文划分为较小的数据块，称为**分组**。
- 在源和目的地之间，每个分组都通过通信链路和**分组交换机**（packet switch）传送。
- **分组交换机**：交换机有两类：**路由器**（router）和**链路层交换机**（link-layer switch）。

##### 分组交换

1. **存储转发传输**（Store-and-Forward Transmission）
   
   **分组交换**和**报文交换**都采用了存储转发的传输形式。但分组交换的存储转发以分组为单位，即交换机接收到**整个分组**后才能输出该分组的数据；而报文交换的存储转发单位为报文，需要交换机接收到**整个报文**后才能输出。

![image-20221024211644524](https://cos.asuka-xun.cc//blog/image-20221024211644524.png)

传输相同大小的数据包，分组交换比报文交换更快。下面是分组交换传输 3L 大小的报文的时间流，报文分为 3 个大小为 L 的分组，根据分组交换原理，一共耗费了 4L/R 时间完成传输（即**存储转发时延**）。而如果使用报文传输同样的 3L 大小的报文则需要耗费 6L/R 时间。

![zkxt9eo4fQqmLRV](https://cos.asuka-xun.cc//blog/zkxt9eo4fQqmLRV.jpg)

2. **排队时延**（Queuing Delay）和**分组丢失**（Packet Loss）
   
    分组交换机有有一个**输出缓存**（output buffer，也称为输出队列（output queue）），分组可能会在分组交换机上排队等待输出，造成排队时延。
   
    分组交换机的缓存空间是有限的，所以在过于拥堵时会产生分组丢失（丢包）。到达的分组或已经排队的分组之一将被丢弃。
   
   ![image-20221026213332992](https://cos.asuka-xun.cc//blog/image-20221026213332992.png)

3. **转发表**（Forwarding Table）和**路由选择协议**（Routing Protocol）
   
   - **路由**：分组中包括IP地址；
   - **转发**：路由器中将目的地址映射为输出链路。
   
   > 每台路由器具有一个转发表，用于将目的地址（或目的地址的一部分）映射成为输出链路。

##### 电路交换

电路交换网络中，在端系统见通信会话期间，预留了端系统间沿路径通信所需要的资源（缓存，链路传输速率）。

 **端到端连接**（end- to-end connection）：在发送数据之前，必须先在发送和接收两端建立端到端连接，并预留一部分带宽。而分组交换不预留，所以会造成排队和丢包。

![D91fBHdvxo24MFT](https://cos.asuka-xun.cc//blog/D91fBHdvxo24MFT.png)

1. 频分多路复用（Frequency- Division Multiplexing, FDM）
   
   **特点**： 链路中的每条连接专用一个频段。
   
   **带宽**：在电话网络中，这个 频段的宽度通常为4kHz （即每秒4000周期）。毫无疑问，该频段的宽度称为**带宽**（band-width）。

2. 时分复用 （Time-Division Multiplexing, TDM）
   
    远距离传输会有衰减，所以考虑用**数字信号**进行传输。在时域上对信号进行**采样**，接收时再将采样信号恢复。
   
    TDM 在时域上被划分为固定的**帧**（frame），每帧又被划分为固定数量的**时隙**（slot），链路中的每条连接专用一个时隙。
   
   例如，如果链路每秒传输 8000个帧，每个时隙由 8 个比特组成，则每条电路的传输速率是64kbps。

![image-20221026222450427](https://cos.asuka-xun.cc//blog/image-20221026222450427.png)

##### 分组交换 & 电路交换对比

 分组交换的性能优于电路交换，适用于随机数据，可以满足更多用户。

 电路交换需要**预留带宽**，相当于**固定**了链路用户的数量。而分组交换**不需要预留带宽**，用户使用网络是有一定概率的，在一个时刻较多人使用的概率其实相对较低，所以一条链路可以给更多的用户使用。

分组交换不适合实时服务（例如，电话和视频会议），因为它的端到端时延是可 变的和不可预测的（主要是因为排队时延的变动和不可预测所致）。

 电路交换适用于特殊情况，比如要保障传输数据能力。

##### 网络的网络

 网络结构是网中之网，具有层次结构。

- **ISP**：ISP分为许多层级，如**第一层ISP**（tier-1 ISP）、**区域ISP**（regional ISP）、**接入ISP**（access ISP）。端系统通过接入ISP与因特网相连，全球的ISP通过各个层级相连，形成了互联网的互联。
- 因特网交换点（Internet Exchange Point，**IXP**）：由第三方公司创建，IXP是一个汇合点，多个ISP在此处对等。

下图是现今的因特网，网络结构5。

![image-20221027162234415](https://cos.asuka-xun.cc//blog/image-20221027162234415.png)

### 分组交换网中的时延、丢包和吞吐量

我们肯定做不到在任意两个端系统之间随心所欲地瞬间移动数据而没有任何数据丢失，不止无法做到，我们还需要**限制**传送的数据量。计算机网络必定要限制在端系统之间的吞吐量（每秒能够传送的 数据量），在端系统之间引入时延，而且实际上也会丢失分组。

##### 分组交换网中的时延概述

1. 时延：分组从一个节点(主机或路由器)沿着这条路径到后继节 点(主机或路由器)，该分组在沿途的每个节点经受了几种不同类型的**时延**。

   - 节点处理时延(nodal processing delay)：检查分组首部和决定将该分组导向何处所需要的时间是处理时延的一部分。

   - 排队时延(queuing delay)：在队列中，当分组在链路上等待传输时，它经受排队时延。

   - 传输时延 (transmission delay）：将所有分组的比特推向链路(即传输，或者说发射)所需要的时间。

     > 用 L 比特表示该分组的长度，用 R bps (即 b/s)表示从路由器 A 到路由器 B 的链路传输速率。例如，对于一条 10M bps 的以太网 链路，速率 R = 10M bps；对于100M bps 的以太网链路，速率 R = 100M bpso 传输时延是 L/R。

   - 传播时延(propagation delay)：一旦一个比特被推向链路，该比特需要向路由器B传播。从该链路的起点到路由器B 传播所需要的时间是传播时延。

     > 该比特以该链路的传播速率传播。该传播速率取决于该链路的物理媒体（即光纤、双绞铜线等），其速率范围是 $2\times 10^8-3\times10^8m/S$,这等于或略小于光速。

     以上时延总体累加起来是节点总时延(tolal nodal delay)。

2. 传输时延和传播时延的比较：**传输时延**是**路由器推出分组**所需要的时间，它是分组长度和链路传输速率的函 数，而与两台路由器之间的距离无关。**传播时延**是一个比特从一台路由器传播 到另一台路由器所需要的时间，它是两台路由器之间**距离**的函数，而与分组长度或链路传 输速率无关。

##### 排队时延和丢包

此处讨论的是以上时延中的排队时延。

排队时延很大程度取决于流量到达该队列的速率、链路的传输速率和到达流量的性质，即流量是**周期性到达**还是以**突发形式到达**。

1. **流量强度**：令 a 表示分组到达队列的平均速率（a 的单位是分组/ 秒，即 pkt/s）。R 是传输速率，即从队列中推出比特的速率（以 bps 即 b/s 为单 位）。然后我们假设每个分组都是 L 个比特组成。我们可以求出比特到达队列的平均速率为 La bps（这里用 bps 为单位）即分组的比特乘上分组的到达速率就是比特的到达速率。假定该队列非常大，因此它基本能容纳无限数量的比特。比率 La/R 被 称为**流量强度**（traffic intensity）。

   如果 La/R > 1，则比特到达队列的平均速率超过从该队列传输岀去的速率。该队列趋向于无限增加，并且排队时延将趋向无穷大。因此，流量工程中的一条金科玉律是：设计系统时流量强度不能大于1。

   如果 $La/R\leq1$，**到达流量的性质**影响排队时延。例如，如果分组周期性到达，即每 L / R 秒到达一个分组，则每个分组将到达一个空队列中，不会有排队时延。另一方面，如果分组以突发形式到达而不是周期性到达，则可能会有很大的平均排队时延。（这里内容好多啊，我不想写了😭）

   ![image-20221027171121799](https://cos.asuka-xun.cc//blog/image-20221027171121799.png)

2. **丢包**：

   因为该排队容量是有限的，随着流量强度接近 1，排队时延并不真正趋向无穷大。相反，到达的分组将发现 一个满的队列。由于没有地方存储这个分组，路由器将丢弃(drop)该分组，即该分组将会丢失(lost) 。

   可以使用计算机网络书籍提供的网站将 Transmission rate 调低，然后 Emission rate 调高会出现队列一直增加：[Queuing and Loss Interactive Animation (pearsoncmg.com)](https://media.pearsoncmg.com/aw/ecs_kurose_compnetwork_7/cw/content/interactiveanimations/queuing-loss-applet/index.html)

   分组丢失的比例随着流量强度增加而增加。

   ##### 1.4.3 端到端时延

   此处说的是从源到 目的地的总时延。前面所说的是节点时延也就是单台路由器上的时延。

   在 Windows power shell 里可以尝试自己追踪一下 `tracert xxx`。

   Linux 中的话需要可能需要安装 `traceroute`。

   ##### 1.4.4 计算机网络中的吞吐量

   除了时延和丢包，计算机网络中另一个至关重要的性能测度是端到端吞吐量。

   例如，主机 A 到主机 B 跨越计算机网络传送一个大文件，也许是从一个 P2P 文件共享系统中的一个对等方向另一个对等方传送一个大视频片段。在任何时间瞬间 的**瞬时吞吐量**（instantaneous throughput）是主机 B 接收到该文件的速率（以bps计）。
   
   如果该文件由F比特组成，主机 B 接收到所有 F 比特用去 T 秒, 则文件传送的平均吞吐量（average throughput.）是 F/T bps。
   
   串联链路吞吐量取决于**瓶颈链路**（bottleneck link）。
   
   $Throughput=min{R1,R2,...,RN}$
   
   ![image-20221028220549406](https://cos.asuka-xun.cc//blog/image-20221028220549406.png)

### 协议层次（Protocol Layer）及其服务模型

 协议定义了在两个或多个通信实体之间交换的报文格式和次序，以及报文发送和/或接收一条报文或其他时间所采取的动作。

 协议三大要素：

- 语法（Syntax）：每一段内容符合一定规则的格式。
- 语义（Semantics）：每一段内容需要代表某种意义，比如原地址部分的二进制到底是指哪个地址。
- 同步（Timing）：通信的过程，即每一段任务的执行顺序。

#### 分层的体系结构

##### 五层因特网协议栈

因特网协议栈由5个层次组成：物理层、链路层、网络层、传输层和应用层。因特网协议栈是一个理想模型。

 下层为上层提供服务。越下面的层，越靠近硬件；越上面的层，越靠近用户。

![image-20221028221645796](https://cos.asuka-xun.cc//blog/image-20221028221645796.png)

这些层都是在后面会解释，这里放一个大概的内容。

|            层次             | 功能                                                         |
| :-------------------------: | :----------------------------------------------------------- |
| 应用层（Application Layer） | 支持网络应用，应用协议仅仅是网络应用的一个组成部分，运行在不同主机上的进程则使用应用层协议进行通信。位于应用层的信息分组称为**报文**（message） |
|  传输层（Transport Layer）  | 因特网的运输层在应用程序端点之间传送应用层报文。负责为信源和信宿提供应用程序进程间的数据传输服务，这一层上主要定义了两个传输协议，传输控制协议即 TCP 和用户数据报协议 UDP。运输层的分组称为**报文段** (segment) 。 |
|   网络层（Network Layer）   | 负责将**数据报**独立地从信源发送到信宿，主要解决路由选择、拥塞控制和网络互联等问题。 |
|    链路层（Link Layer）     | 负责将 IP 数据报封装成合适在物理网络上传输的**帧**格式并传输，或将从物理网络接收到的帧解封，取出 IP 数据报交给网络层。 |
|  物理层（Physical Layer）   | 负责将**比特流**在结点间传输，即负责物理传输。该层的协议既与链路有关也与传输介质有关。 |

##### OSI 模型

 OSI模型由国际标准化组织（ISO）制定，实际并没有应用，只有理论。

 OSI模型由7层组成：应用层、表示层、会话层、传输层、网络层、数据链路层、物理层。

#### 封装

在发送主机端：

1. 应用层：一个**应用层报文**（application-layer message）被传送到运输层。下图中的 M。
2. 运输层：接收报文M，附上传输层首部信息Ht（包括差错检测位信息等），构成 **传输层报文段**（transport-layer segment），将其传递给网络层；运输层报文段因此**封装**了应用层报文。
3. 网络层：网络层增加了如 源 和 目的端系统地址 等网络层首部信息。
4. 链路层：接收网络层数据段，附上链路层首部信息Hl，构成 **链路层帧**（link-layer frame），将其传递给物理层；
5. 物理层：负责比特流物理传输。

在每一层，一个分组具有两种类型的字段：**首部字段**和**有效载荷字段**（payload field） 。有效载荷通常是来自上一层的分组。

接收端则是反方向从底向上。

![image-20221029163640090](https://cos.asuka-xun.cc//blog/image-20221029163640090.png)

### 面对攻击的网络

#### 坏家伙能够经因特网有害程序放入你的计算机中

**恶意软件**：它们能够进入并感染我们的设备。这些恶意软件可以做许多不正当的事情，包括包括删除我们的文件，安装间谍软件来收集我们的隐私信息，如社会保险号、口令和击键，然后将这些（当然经因特网）发送给**坏家伙**。（坏家伙太坏了😤）。

多数恶意软件是**自我复制**（self-replicating）的：一旦它感染了一台主机，就会从那台主机寻求进人因特网上的其他主机，从而形成新的感染主机，再寻求进入更多的主机。

**僵尸网络**：坏家伙可以利用僵尸网络控制并有效地对目标主机展开垃圾邮件分发或**分布式拒绝服务攻击**。

**病毒**：病毒（virus）是一种需要某种形式的用户交互来感染用户设备的恶意软件。

**蠕虫**：蠕虫（worm）是一种无须任何明显用户交互就能进入设备的恶意软件。

#### 坏家伙能够攻击服务器和网络基础设施

拒绝服务攻击（Denial-of-Service((DoS)attack) ，DoS攻击使得网络、主机或其他基础设施部分不能由合法用户使用

多数 Dos 攻击属于以下三种类型：

- 弱点攻击。这涉及向一台目标主机上运行的易受攻击的应用程序或操作系统发送
  制作精细的报文。如果适当顺序的多个分组发送给一个易受攻击的应用程序或操
  作系统，该服务器可能停止运行，或者更糟糕的是主机可能崩溃。
- 带宽洪泛。攻击者向目标主机发送大量的分组，分组数量之多使得目标的接入链
  路变得拥塞，使得合法的分组无法到达服务器。
- 连接洪泛。攻击者在目标主机中创建大量的半开或全开TCP连接(将在第3章中
  讨论TCP连接)。该主机因这些伪造的连接而陷入困境，并停止接受合法的连接。

分布式DoS （Distributed DoS，DDoS)，攻击者控制多个源并让每个源向目标猛烈发送流量。


![image-20221029172315357](https://cos.asuka-xun.cc//blog/image-20221029172315357.png)

#### 坏家伙能够嗅探分组

**分组嗅探器（packet sniffer）**：记录每个流经的分组副本的被动接收机。

Wireshark 这个软件就是一种分组嗅探器。好，我们也可以成坏家伙了（不行）。

#### 坏家伙能够伪装成你信任的人

生成具有任意源地址、分组内容和目的地址的分组，然后将这个人工制作的分组传输到因特网中，因特网将忠实地将该分组转发到目的地，这些数据是虚假的，但是接收方并不知道这些数据是虚假的，然后执行这些分组内容中的命令。

**IP 哄骗（IP spoofing）**：将具有虚假源地址的分组注入因特网的能力被称为IP哄骗（IPspoofing），它只是一个用户能够冒充另一个用户的许多方式中的一种。

## 应用层（Application Layer）

### 应用层协议原理

- 可以在不同类型主机运行；
- 可以在不同终端间相互通讯；
- 在编写网络应用的过程中，不需要考虑网络核心设备，网络核心不会允许应用；
- 端系统上的应用可以快速开发，而且易于传播。

### 网络应用程序体系结构

#### 客户-服务器体系结构（Client-server architecture）

具有客户端 - 服务器体系结构的应用程序包括 Web、FTP、Telnet 和电子邮件。

**服务器**：

- 永远在线；
- IP地址恒定；
- 服务器往往在数据中心，通过多台服务器进行扩展。

**客户机**：

- 可以和服务器进行通信；
- 可能间断性连接网络；
- 可能是动态的IP地址；
- 客户机之间不会直接通信；

#### P2P 体系结构（P2P architecture）

对位于数据中心的专用服务器有最小的（或者没有）依赖。应用程序在简断连接的主机对之间使用直接通信，这些主机称为**对等方**。常见应用如文件共享（BitTorrent）、对等方协助下载加速器（例如迅雷）。

- 没有一个一直在线的服务器；
- 任意端系统之间直接进行通信；
- 每个点（peer）向其他的点请求服务，同时作为回报也会提供相应的服务；

优点：**自扩展性**（self-scalability）：新的点都会提供服务容量和负荷。

缺点：每个点都是间断性连接，而且IP地址会改变。

### 进程通信

 **进程**（Processe）：一台主机上运行的程序。

- 当多个进程运行在一台主机上时，它们使用进程间通信（inter-process communication）机制相互通信。
- 不同主机上的进程，通过跨越计算机网络交换**报文**（message）。

 **客户机进程**（client process）：发起通信的进程。

 **服务器进程**（server process）：等待连接的进程。

P2P 应用中也存在客户机进程和服务器进程。当对等方 A 请求对等方 B 发送一个特定文件时，在这个特定的通信会话中对等方 A 是客户，而对等方 B 是服务器。

**套接字（Socket）**

 进程之间通过一个名为套接字（socket）来接收/发送消息。套接字也称为应用程序和网络之间的应用程序编程接口（Application Programming Interface，API）。

socket在进程通信中的作用相当于一个信封：

- 通信的信息需要装进socket
- 应用层下的各层作为基础设施，将信传到另一个进程
- 两个进程间的通讯会有两个socket

![image-20221116232132573](https://cos.asuka-xun.cc//blog/image-20221116232132573.png)

**进程寻址（Addressing Processes）**

如果两个主机之间的进程进行通信，发送端不仅要知道接收端的IP地址还需要知道进程相应的端口号。

- **IP地址**：IPv4中32位IP，负责找到接收端主机。

- **端口号**（port number）：每台主机都可能运行着多个进程，每个进程对应一个端口号。

  比如，HTTP服务端口号80、邮件服务端口号25

  > 端口号可以去这个网站查：[Service Name and Transport Protocol Port Number Registry (iana.org)](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml)

通常套接字（Socket）由 IP 地址和端口号组成。

### 因特网提供的运输服务

以下两种协议基于运输层。

#### TCP 服务

TCP 服务模型包括**面向连接服务**和**可靠数据传输服务**。

- 面向连接服务：在应用层数据报文开始流动之前，TCP 让客户和服务器互相交换运输层控制信息（三次握手）。在握手阶段后，一个 TCP 连接（TCP connection） 就在两个进程的**套接字**之间建立了。
- 可靠的数据传送服务：通信进程能依靠 TCP，无差错、按适当顺序交付所有发送的数据。

特点：

- **面向连接**（connection-oriented）：需要客户端和服务器之间能够建立连接
- **可靠传输**（reliable transport）：数据完整性高
- **流量控制**（flow control）：发送方不能发送太多数据导致接收方过载
- **阻塞控制**（congestion control）：不能有太多个主机同时发送导致网络过载
- 不提供的服务：时效性、最小带宽（吞吐率）、安全性

> TCP 和 UDP 都没有提供任何加密机制，所有研究出了一个称为**安全套接字层（Secure Socket Layer， SSL）**的 TCP 加强版本，用 SSL 加强后的 TCP 不仅能够做到传统 TCP 的一切，还提供了**进程到进程**的安全性服务。SSL 不是与 TCP 和 UDP 在相同层次上的第三种因特网运输层协议，而是一种对 TCP 协议的增强，这种增强是在应用层上实现的。我们平时见到的 https 和 http 前者使用了 SSL 加密，后者没使用。

#### UDP 服务

UDP是一种**不提供不必要服务**的轻量传输协议。UDP 是无连接的，没有握手过程。UDP 不保证将报文送达到接收进程，而且不保证到达接收进程的报文顺序。

特点：

- **不需要建立连接**
- **不可靠的数据传输**
- 不提供的服务：基本都不提供，不提供包括可靠传输、流量控制、阻塞控制、时效性、最小带宽（吞吐率）、安全性

常见的应用使用的网络传输协议

![image-20221116234722184](https://cos.asuka-xun.cc//blog/image-20221116234722184.png)

### 可供应用程序使用的运输服务

#### 应用层协议（Application-Layer Protocols）

 网络应用的开发必须遵守网络协议。

#### 应用层协议的分类

**公开网络协议**

- 定义在RFC中
- 统一标准，易于相互操作
- 例如：HTTP、SMTP

**专用网络协议**

- 一些非公开的网络协议
- 例如：Skype

#### 应用层协议内容

应用层协议定义了：

- 消息交换的类型：比如请求、响应
- 消息的语法：消息中有哪些字段以及这些字段如何定义
- 消息的语义：消息字段内容的含义
- 规则：进程什么时候、如何发送/接收消息

**应用程序服务分类**

- 可靠数据传输（可靠数据传输，data integrity）

  一些工作必须确保发送的数据正确完整的发送到对方。

- 吞吐量（throughput）

  吞吐量，即**最小带宽**，一些app存在一个吞吐率下限才能正常使用，比如视频音频等多媒体；有些app运行弹性的吞吐率，比如邮件传输，吞吐率小可以慢慢传过去。

- 时效性（timing）

  一些应用需要较少的时延，直播、游戏等。

![image-20221116233157194](https://cos.asuka-xun.cc//blog/image-20221116233157194.png)

### Web 和 HTTP

 World Wide Web 中的网页由超链接（hyperlink）连接。

- 页面由很多**对象**（object）组成，对象存储在服务器中；
- 对象有多种类型，可以是HTML文件，JPEG图片，动态脚本等等；
- 网页以HTML文件为基础，包括了许多参考对象，每个对象都可以通过URL来寻址。例如一张图片的URL为`www.someshcool.edu/someDept/pic.gif`，其中`www.someshcool.edu`为主机名，`/someDept/pic.gif`为路径名。

#### HTTP 概况

 超文本传输协议（hypertext transfer protocol, HTTP），是 Web 的核心。

- 网页的**应用层**协议
- 基于**客户机-服务器体系结构**
  - 客户机：负责请求、接收和显示Web对象
  - 服务器：Web服务器负责发送对象，响应客户机请求

- HTTP的传输层使用TCP
  1. 客户机发起TCP连接（创建socket，**端口号80**）
  2. 服务器接收TCP连接
  3. 在浏览器和网页服务器之间进行HTTP信息的交换
  4. TCP连接可以断开

- HTTP是**无状态**的（HTTP 是一个无状态协议（stateless protocol））

  服务器不会保留之前客户机发的请求信息。

  协议要维持状态是很复杂的：保留之前的历史记录很消耗资源；如果客户机或着服务器有死机，它们的状态会不一致，还需要重新同步，这很麻烦。

- HTTP消息类型：请求（request）与响应（response）

#### HTTP 连接类型

HTTP 在默认方式下使用持续连接，但是可以配置成非持续连接。

##### 非持续连接和持续连接

**非持续性连接（non-persistent connection）**

每个请求 / 响应对是经过**一个单独**的 TCP 连接发送。

**步骤**

1. TCP 连接开启
2. 通过该 TCP 连接传输一个对象
3. TCP 连接关闭

若发送多个对象，则每个对象需重复上述步骤

![Non-persistent HTTP(1)](https://cos.asuka-xun.cc//blog/Non-persistent%20HTTP(1).png)

**![Non-persistent HTTP(2)](https://cos.asuka-xun.cc//blog/Non-persistent%20HTTP(2).png)**

**非持续连接 HTTP 响应时间**

**RTT**：往返时间（Round-Trip Time），指一个短分组（很小的数据包）从客户到服务器然后再返回客户所花费的时间。

对一个对象来说，非持久性HTTP响应时间为：

$Nonpersistent HTTP response time= 2RTT + file transmission time$

粗略地讲，总的响应时间就是两个 RTT 加上服务器传输文件的时间。

![RTT](https://cos.asuka-xun.cc//blog/image-20221118001857065.png)

**缺点：**

- 必须为每一个请求的对象建立和维护一个全新的连接。给服务器带来严重的负担。
- 每一个对象都需要耗费 2RTT 的时间。一个用于创建 TCP，一个用来请求和接收一个对象。

**持续连接（persistent connection)**

所有请求及其响应经**相同**的 TCP 连接发送。

**步骤：**

1. 开启TCP连接
2. 通过这一个TCP连接可以传多个对象
3. TCP连接关闭

##### 持久性HTTP特点（HTTP1.1）

- 服务器在发送响应后保持连接开启状态
- 后续这个客户机\服务器的HTTP消息都通过该开启的连接发送
- 两种发送对象方式：HTTP1.1采用流水的方式发送：一次性把对象全发了；另一种是客户机接收到一个对象后接着发下一个对象的请求
- 至少需要1个RTT发完所有对象

#### HTTP 报文格式

##### HTTP 请求报文

一个典型的 HTTP 请求报文：

```http
GET /somedir/page.html HTTP/1.1
Host: www.somschool.edu
Connection: close
User-agent: Mozilla/5.0
Accept-language: fr
```

这个报文用 ASCII 文本书写，一共有 5 行，但是平时的请求报文只会比这更多。

**分析：**

- **请求行**（request line）：HTTP 请求报文的第一行叫作请求行。
- **首部行**：位于请求行之后的所有行叫做首部行。

**请求行**

请求行有三个字段：方法字段、URL 字段和 HTTP 版本字段。

- **方法字段**：GET、POST、HEAD、PUT、DELETE。

  > 这些方法参见 MDN 文档：[HTTP request methods - HTTP | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)

- URL 字段：带偶请求对象的表示。
- HTTP 版本号：上面例子为 HTTP/1.1

**首部行**

1. `Host: www.somschool.edu` ：指明了对象所在的主机。

2. `Connection: close`：浏览器告诉服务器不需要使用持续连接，发送完被请求的对象后就关闭这个连接。

3. `User-agent: Mozilla/5.0`：指明用户代理，即向服务器发送请求的浏览器类型，这里是 `Mozilla/5.0`，是 FireFox 浏览器。

4. `Accept-language: fr`：表明用户想要得到的是该对象的法语版本（如果服务器有这个对象的话）；否则，服务器会发送默认版本。

**请求报文的通用格式**

![image-20221119001806628](https://cos.asuka-xun.cc//blog/image-20221119001806628.png)

**实体体（entity body）很奇怪的翻译:** 当使用 GET 方法时，实体体为空，当使用 POST 方法时才会使用实体体（后端人很熟悉）。

> 用户提交表单时，HTTP 客户常常使用 POST 方法，实体体中包含的就是用户在表单字段中的输入值。
>
> 但是在 HTML 表单经常使用GET方法，并在（表单字段中）所请求的URL中包括输入的数据。例如，一个表单使用GET方法，它有两个字段，分别填写的是 “monkeys” 和 “bananasM” , 这样，该 URL 纟吉构为 www. somesite. com/animalsearch? monkeys&bananas。这种 URL 很常见。

#### HTTP 响应报文

以上面的请求报文的响应报文为例：

```HTTP
HTTP/1.1 200 OK
Connection: close
Date: Tue, 18 Aug 2015 15:44:04 GMT
Server: Apache/2.2.3 (CentOS)
Last-Modified: Tuer 18 Aug 2015 15:11:03 GMT
Content-Length: 6821
Content-Type: text/html
(data data data data data .....)
```

**分析：**

- **初始状态行（status line）**：第一行
- **首部行（header line）**：初始状态行后面的 6 行就是首部行。
- **实体体（entity body）**：实体体是报文的主要部分，包含了所请求的对象本身（就是一串 data data ....）

**状态行**

状态行有三个字段：协议版本字段、状态码和相应状态信息。

**首部行**

1. `Connection: close`：发送完报文后关闭 TCP 连接。

2. `Data`：指示服务器产生并发送该响应报文的日期和时间。

> 这个时间不是指对象创建或者最后修改的时间，而是服务器从它的文件系统中检索到该对象，将该对象插入响应报文，并发送该响应报文的时间。

3. `Server`: 首部行指示该报文是由一台 Apache Web 服务器产生的，它类似于HTTP请求报文中的 User-agent:首部行。
4. `Last-Modified`: 首部行指示了对象创建或者最后修改的日期和时间。
5. `Last- Modified`: 首部行对既可能在本地客户也可能在网络缓存服务器上的对象缓存来说非常重要。
6. `Content-Length`：首部行指示了被发送对象中的字节数。
7. `Content-Type`: 首部行指示了实体体中的对象是HTML文本。（该对象类型应该正式地由 Content-Type: 首部行而不是用文件扩展名来指。）

**HTTP 响应报文通用格式**

![image-20221119004007715](https://cos.asuka-xun.cc//blog/image-20221119004007715.png)

##### 一些常见的状态码及短语

- 200 0K：请求成功，信息在返回的响应报文中。
- 301 Moved Permanently：请求的对象已经被永久转移了，新的URL定义在响应报文的Location:首部行中。客户软件将自动获取新的URL。（我博客 http 访问时就使用了 301 跳转，跳转到 https）
- 400 Bad Request: 一个通用差错代码，指示该请求不能被服务器理解。
-  404 Not Found:被请求的文档不在服务器上。
-  505 HTTP Version Not Supported:服务器不支持请求报文使用的HTTP协议版本

我们可以使用 `telnet` 发送一个 HTTP 请求报文，并且查看返回的响应报文，我这里使用的时 Ubuntu：

```bash
telnet gaia.cs.umass.edu 80
GET /kurose_ross/interactive/index.php HTTP/1.1
Host: gaia.cs.umass.edu
```

注意输完最后面的 Host 之后我们需要回车两次。

我们会得到以下响应报文：

```http
HTTP/1.1 200 OK
Date: Fri, 18 Nov 2022 16:47:01 GMT
Server: Apache/2.4.6 (CentOS) OpenSSL/1.0.2k-fips PHP/7.4.30 mod_perl/2.0.11 Perl/v5.16.3
X-Powered-By: PHP/7.4.30
Set-Cookie: DevMode=0
Transfer-Encoding: chunked
Content-Type: text/html; charset=UTF-8

361c
(data data data... 一堆 HTML 代码)
```

#### 用户与服务器的交互： cookie

因为 HTTP 服务器是无状态的，所以我们没法识别到用户，每次都需要重新连接一个用户，不论他是否连接过我们的服务器，这样十分麻烦，于是就创造出了 cookie 这个东西。

HTTP使用了 cookie。cookie在［RFC 6265 ］中定义，它允许站点对用户进行跟踪。目前大多数商务 Web 站点都使用了 cookie。

![image-20221119005434332](https://cos.asuka-xun.cc//blog/image-20221119005434332.png)

cookie技术有4个组件：

1. 在HTTP响应报文中的一个cookie首部行；

2. 在HTTP请求报文中的一个cookie首部行；

3. 在用户端系统中保留有一个cookie文件，并由用户的浏览器进行管理；

4. 位于Web站点的一个后端数据库

过程：

1. 访问网站第一次发送请求，服务器用一个包含 Set-cookie:首部的 HTTP 响应报文对客户进行响应，Set-cookie: 首部含有一个识别码，比如可能是：`Set-cookie: 1678`
2. 客户收到该 HTTP 响应报文时，它会看到 Set-cookie: 首部。客户的浏览器会在它管理的特定 cookie 文件中添加一行，改行包括服务器的主机名和在 Set-cookie: 首部
   中的识别码。
3. 当客户再次访问这个网站时，每请求一个 Web 页面，浏览器就会查询该 cookie 文件并抽取客户对这个网站的识别码，并放到 HTTP 请求报文中包括识别码的 cookie 首部行中。也就是发送给服务器的每个 HTTP 请求报文中都包括首部行：`Cookie: 1678`

通过这种方式，服务器可以跟踪客户在站点的活动（听着多少有点恐怖）。

**总结**

cookie可以用于标识一个用户。用户首次访问一个站点时，可能需要提供一个用户标识（可能是名字）。在后继会话中，浏览器向服务器传递一个 cookie 首部，从而向该服务器标识了用户。因此 cookie **可以在无状态的 HTTP 之上建立一个用户会话层**。

#### Web 缓存

**Web 缓存器（Web cache）** 也叫 **代理服务器**，它是能够代表初始 Web 服务器来满足 HTTP 请求的网络实体。

**Web 缓存器**通常由 **ISP** 购买并安装。

如下图，可以配置用户的浏览器，使得用户的所有 HTTP 请求首先指向 Web 缓存器。一旦某浏览器被配置，每个对某对象的浏览器请求首先被定向到该 Web 缓存器。

![image-20221123194135945](https://cos.asuka-xun.cc//blog/image-20221123194135945.png)

举例来说，假设浏览器正在请求对象 http://wwww.someschool.edu/campus.gif, 将会发生如下情况：
1）浏览器创建一个到 Web 缓存器客户初始服务器，客户通过 Web 缓存器请求对象的 TCP 连接，并向 Web 缓存器中的对象发送一个 HTTP 请求。
2） Web 缓存器进行检查，看看本地是否存储了该对象副本。如果有，Web缓存器就向客户浏览器用 HTTP 响应报文返回该对象。
3） 如果 Web 缓存器中没有该对象，它就打开一个与该对象的初始服务器（即 www.someschool.edu）的 TCP 连接。Web 缓存器则在这个缓存器到服务器的 TCP 连接上发送一个对该对象的 HTTP 请求。在收到该请求后，初始服务器向该 Web 缓存器发送具有该对象的 HTTP 响应。
4） 当 Web 缓存器接收到该对象时，它在本地存储空间存储一份副本，并向客户的浏览器用 HTTP 响应报文发送该副本（通过现有的客户浏览器和 Web 缓存器之间的 TCP 连接）

**使用 Web 缓存的好处**

1. Web 缓存器可以大大减少对客户请求的响应时间。
1. Web 缓存器能从整体上大大减低因特网上的 Web 流量，从而改善了所有应用的性能。

##### 内容分发网络（Content Distribution Network，CDN）

**CDN** 公司在因特网上安装了许多地理上分散的缓存器。做博客的时候会通过 CDN 进行加速，在之后会有详细的讲解。

#### 条件 GET 方法

高速缓存能减少用户感受到的响应时间，但也引入了一个新的问题，即存放在缓存器中的对象副本可能是陈旧的。换句话说，保存在服务器中的对象自该副本缓存在客户上以后可能已经被修改了。但是通过 **条件 GET （conditional GET）**方法，我们可以证实它的对象是最新的。

**特征：**

1. 请求报文使用 GET 方法；
2. 并且请求报文中包含一个 “If-Modified-Since:” 首部行；

拥有以上特征代表这个 HTTP 请求报文就是一个条件 GET 请求报文。

首先，一个代理缓存器（proxy cache）代表一个请求浏览器，向某Web服务器发送一个请求报文: 

```http
GET /fruit/kiwi.gif HTTP/1.1
Host: www.exotiquecuisine.com
```

其次，该Web服务器向缓存器发送具有被请求的对象的响应报文:

```http
HTTP/1.1 200 OK
Date: Sat. 3 Oct 2015 15:39:29
Server: Apache/1.3.0 (Unix)
Last-Modified: Wed, 9 Sep 2015 09:23:24
Content-Type: image/gif
(data data data data data ...)
```

该缓存器在将对象转发到请求的浏览器的同时，也在本地缓存了该对象。重要的是，缓存器在存储该对象时也**存储了最后修改日期**。缓存器在之后会发送一个条件 GET 执行最新检查。即会发送：

```http
GET /fruit/kiwi.gif HTTP/1.1
Host: www•exotiquecuisine•com
If-modified-since: Wed, 9 Sep 2015 09:23:2
```

该条件 GET 报文告诉服务器，仅当自指定日期之后该对象被修改过，才发送该对象。

如果这个对象没有被修改，Web 服务器向该缓存器发送一个响应报文：

```http
HTTP/1.1 304 Not Modified
Date: Satf 10 Oct 2015 15:39:29
Server: Apache/1・ 3 ・ 0 (Unix)
(empty entity body)
```

但是这个报文中并没有包含所请求的对象。状态行中为 304 Not Modified，它告诉缓存器可以使用该对象，能向请求的浏览器转发它（该代理缓存器）缓存的该对象副本。

### 电子邮件

因特网电子邮件系统有 3 个主要组成部分：

1. 用户代理（user agent）

2. 邮件服务器（mail server）
3. 简单邮件传输协议（Simple Mail Tranfer Protocol，SMTP）

#### SMTP

SMTP 是因特网电子邮件的核心。SMTP 用于从**发送方**的邮件服务器**发送**报文到**接收方**的邮件服务器。SMTP 一般不使用中间邮件服务器发送邮件。SMTP 在 25 号端口运行。

我们可以在本地命令行自己连接一下 QQ 的 SMTP 服务器：

```shell
telnet smtp.qq.com 25
```

#### 与 HTTP 的对比

这两个协议都用于从一台主机向另一台主机传送文件：

HTTP 与 Web 服务器向 Web 客户（通常是一个浏览器）传送文件（也称为对象）；

SMTP 从一个邮件服务器向另一个邮件服务器传送文件（即电子邮件报文）。

**相同点：**当进行文件传送时，持续的 HTTP 和 SMTP 都使用持续连接。

**不同点：**

- HTTP 主要是一个**拉协议**（pull protocol），即在方便的时候，某些人在Web服务器上装载信息，用户使用HTTP从该服务器拉取这些信息。

- SMTP 基本上是一个**推协议**（push protocol），即发送邮件服务器把文件推向接收邮件服务器。
- SMTP 要求每个报文（包括它们的体）采用 7 比特 ASCII 码格式。
- 如何处理一个既包含文本又包含图形（也可能是其他媒体类型）的文档。

#### 第三版邮局协议（POP3）、因特网邮件访问协议（IMAP）

由于 SMTP 协议是一个推协议，所以我们并不能取到报文，我们需要引入一个特殊的邮件访问协议来解决这个难题。

![image-20221123212147767](https://cos.asuka-xun.cc//blog/image-20221123212147767.png)

SMTP 用来将邮件从发送方的邮件服务器传输到接收方的邮件服务器；SMTP 也用来将邮件从发送方的用户代理传送到发送方的邮件服务器。如 POP3 这样的邮件访问协议用来将邮件从接收方的邮件服务器传送到接收方的用户代理。

#### POP3

POP3 是一个极为简单的邮件访问协议，由 RFC 1939 进行定义。POP3 是与我们的电子邮件服务器连线，并下载电子邮件服务中的所有新邮件。一旦下载这些邮件到我们的 PC 或 MAC 中，电子邮件服务器就会将它们删除。这说明电子邮件下载之后，就只能使用同一台电脑存取该邮件，当我们尝试从不同装置存取电子邮件，我们无法使用那些之前已下载的邮件。

我们可以在命令行通过这个协议访问邮件服务器：

```shell
telnet pop.qq.com 110
+OK XMail POP3 Server v1.0 Service Ready(XMail v1.0)
user youremail@qq.com
+OK
pass yourpass
```

这时我们就登录到 QQ 的邮件服务器，我们可以使用以下命令：

- list：列出邮件服务器上的邮件
- retr：阅读一份邮件
- dele：删除一份邮件
- quit：退出

#### IMAP

IMAP 让你不论身在何处、使用何种装置，都能够存取电子邮件。当使用 IMAP 存取或读取电子邮件是，并非实际将邮件下载或存储在我们本地的电脑，而是从电子邮件服务中读取，所以使用这个协议我们可以在任何设备上查看我们的邮件，这与 POP3 不同。

同理可以使用以下命令访问 QQ 的邮件服务器：

```shell
telnet imap.qq.com 143 # 访问这个网站的 143 端口
* OK [CAPABILITY IMAP4 IMAP4rev1 ID AUTH=PLAIN AUTH=LOGIN AUTH=XOAUTH2 NAMESPACE] QQMail XMIMAP4Server ready
A01 LOGIN youremail.com yourpassword # 用户登录
```

命令格式：

```shell
命令输入：
  <随机字符串ID> command
响应：
  <随机字符串ID> OK <ANSWER DETAIL>
```

**列出邮件文件夹：**

`LIST "<mailbox path>" "<search argument>"`

1. `<mailbox path>` 邮箱路径，如果为" "， 则列出根目录的所有文件夹
2. `<search argument>`是区分大小写的，可为 “*” 或 “%”，“*” 匹配所有，“%” 只匹配当前层

```shell
A1 LIST "" "*"
```

**选择一个文件夹：**

```shell
A1 SELECT INBOX
  \* 1254 EXISTS  // 共存在1254封邮件
  \* 0 RECENT     // 最新的邮件
  \* OK [UNSEEN 75]  // 未读
  \* OK [UIDVALIDITY 1429146575] UID validity status  
  \* OK [UIDNEXT 2475] Predicted next UID
  \* FLAGS (\Answered \Flagged \Deleted \Draft \Seen)
  \* OK [PERMANENTFLAGS (\* \Answered \Flagged \Deleted \Draft \Seen)] Permanent flags
  A1 OK [READ-WRITE] SELECT complete
```

**查询邮件：**

```shell
A02 Search new			# 查询收件箱所有新邮件
A03 Fetch 5 full         # 获取第5封邮件的邮件头
A04 Fetch 5 rfc822       # 获取第5封邮件的完整内容
A05 LOGOUT               # 退出
```

### DNS：因特网的目录服务

DNS：域名系统（Domain Name System，DNS）通过分布式的数据库来实现 IP 地址和域名的映射。比如：我博客域名是 blog.asuka-xun.cc，你想要访问我的博客你可以直接输入我的域名然后 DNS 解析到我博客部署的服务器的 IP 地址可以访问，你也可以直接访问我博客部署的服务器的 IP 地址进行访问，但是显然前者是更方便的吧。

- **层级结构的域名服务器提供分布式的数据库**
- **应用层协议**：主机和域名服务器通过通信来实现IP地址和域名的转换

**DNS服务**

- IP地址和域名的转换
- 主机的别名
- 邮件服务的别名
- 负荷分配：有些Web可能有多个服务器，即会有多个IP地址对应一个域名，可调整IP地址的顺序以分配负荷。

DNS 采用三层架构：

![image-20221217172508294](https://cos.asuka-xun.cc//blog/image-20221217172508294.png)

#### 根域名服务器（Root Name Server）

- 官方的服务器，是连接的最后的方法（如果知道下级域名服务器的地址就不需要再从头开始查询根域名服务器，不然会对根域名服务器产生很大的流量负荷）
- 对网络运行相当重要，离开根域名服务器网络无法正常工作
- 域名系统安全扩展（Domain Name System Security Extensions，DNSSEC） —— 对DNS提供给DNS客户端（解析器）的DNS数据来源进行认证，并验证不存在性和校验数据完整性验证。
- ICANN（互联网名称与数字地址分配机构，Internet Corporation for Assigned Names and Numbers）—— 管理根域名服务器的组织

#### 顶层域名服务器（Top-Level Domain Server, TLD）

- 各种类型的TLD，比如`.com`、`.org`、`net`、`.edu`等等，国家的TLD，比如`.cn`、`.uk`等等。
- Network Solutions：管理`.com`、`net`TLD的组织
- Educause：管理`.edu`的组织

#### 权威域名服务器（Authoritative Domain Server）

- 组织自己的DNS服务器，用来提供组织内部的域名到IP地址的映射
- 由组织自己或者服务提供商来维护

#### 本地域名服务器（Local DNS Name Server）

- 严格来说**不属于**层级结构
- 每个ISP都会有一个本地域名服务器，也叫做**默认域名服务器**（default name server）
- 当主机要进行DNS查询时，查询会被直接送到本地的DNS服务器。
- 作用：
  - 缓存：可以缓存最近收到的域名到IP地址的映射（缓存有时效，会过期）
  - 代理：可以作为代理，代替主机在层级结构中进行查询



一个客户机得到 www.amazon.com 的 IP 地址的步骤：

1. 客户机先查询根域名服务器，得到顶级域名服务器`.com DNS server`的地址；
2. 客户机查询顶级域名服务器`.com DNS server`，得到权威域名服务器`amazon.com DNS server`的地址；
3. 客户机查询权威域名服务器`amazon.com DNS server`，得到`www.amazon.com`的IP地址。

#### DNS 查询方法

DNS 查询方法分为两种方法：迭代查询（iterated query）和递归查询（recursive query）。

**迭代查询**

被联系到的服务器会将后一个服务器的名字反馈回来，即这个服务器无法解析这个域名，需要到另一个服务器解析。

在下面这个图中，除 1 之外都是迭代查询，因为查询结果直接返回给 dns.nyu.edu。而 1 是递归查询。实践中的查询方法通常都是以下这种形式，即请求主机到本地 DNS 服务器的查询是递归的，其余的查询都是迭代的。

![image-20221217173015373](https://cos.asuka-xun.cc//blog/image-20221217173015373.png)

**递归查询**

所谓递归查询就是：如果主机所询问的本地域名服务器不知道被查询的域名的IP地址，那么本地域名服务器就以DNS客户的身份，

向其它根域名服务器继续发出查询请求报文(即替主机继续查询)，而不是让主机**自己**进行下一步查询。

因此，递归查询返回的查询结果或者是所要查询的IP地址，或者是报错，表示无法查询到所需的IP地址。

![image-20221217173348010](https://cos.asuka-xun.cc//blog/image-20221217173348010.png)

#### DNS 缓存

- 一旦域名服务器学习到了一个映射，它就会**缓存**这个映射。缓存往往在本地域名服务器里，这样可以减轻根域名服务器的压力。
- **缓存有效时间TTL**，过了有效时间该缓存就会被删除。
- **更新/通知机制**：由IETF制定的 RFC2136 标准。
  如果中途域名主机改变IP地址，整个网络可能都不知道真正的IP地址，直到TTL到时，所以需要更新/通知机制。

#### DNS 记录和报文

DNS的分布式数据库里存储了**资源记录**（resource record, RR）

RR的格式：`(name, value, type, ttl)`

**type = A**

- name：主机名
- value：对应的IP地址

**type = NS**

- name：域（如`foo.com`）
- value：对应的权威域名服务器的主机名

**type = CNAME**

- name：别名
- value：对应的规范主机名
- 比如 `www.ibm.com` 是 `servereast.backup2.ibm.com` 的别名，这与负荷的分配有关，可能有多个服务器。一个域名映射另一个域名

**type = MX**

- name：邮件服务器别名
- value：对应的规范主机名

**DNS 报文**

DNS 有两种消息类型：查询（query）和回答（reply），两种消息格式相同。

![image-20221217173938607](https://cos.asuka-xun.cc//blog/image-20221217173938607.png)

我们可以使用 nslookup 程序向任何 DNS 服务器（根、TLD 或权威）发送 DNS 查询。

```bash
nslookup -q=A blog.asuka-xun.cc
```

-q=A说明我们查询的类型 type = A。

结果：

```bash
服务器:  localhost
Address:  192.168.1.1

DNS request timed out.
    timeout was 2 seconds.
非权威应答:
名称:    ru71xdf6.slt-dk.sched.tdnsv8.com
Addresses:  222.218.189.85
          222.218.188.92
          222.218.187.136
          222.218.187.115
          222.218.187.230
          222.218.187.112
          222.218.187.212
          222.218.187.187
Aliases:  blog.asuka-xun.cc
          blog.asuka-xun.cc.cdn.dnsv1.com.cn
```

**在 DNS 数据库中插入记录**

#### 向DNS数据库插入记录

比如要创建一个`networkutopia.com`的网站

- 先在 ` .com` 的TLD提供商 Network Solution 注册 `networkutopia.com`

  - 提供信息：域名、权威域名服务器的IP地址
  - 提供商会向`.com`TLD服务器插入 NS、A 的RR
    (`networkutopia.com`, `dns1.networkutopia.com`, NS)
    (`dns1.networkutopia.com`, `212.212.212.1`, A)

- 在自己的权威域名服务器上进行配置

  - 插入`www.networkutopia.com`的type A记录
  - 如果是邮件服务，插入`networkutopia.com`的type MX记录

#### DNS 查询工具

在命令行用`nslookup`进行DNS查询。

#### nslookup直接查询

查询一个域名的A记录，如果没指定 dns-server，用系统默认的 dns 服务器。

```bash
nslookup domain [dns-server]
```

#### nslookup查询其他记录

```bash
nslookup -qt=type domain [dns-server]
```

type 可以是以下这些类型：

| type  | 类型                                |
| :---- | :---------------------------------- |
| A     | 地址记录                            |
| AAAA  | 地址记录                            |
| AFSDB | Andrew文件系统数据库服务器记录      |
| ATMA  | ATM地址记录                         |
| CNAME | 别名记录                            |
| HINFO | 硬件配置记录，包括CPU、操作系统信息 |
| ISDN  | 域名对应的ISDN号码                  |
| MB    | 存放指定邮箱的服务器                |
| MG    | 邮件组记录                          |
| MINFO | 邮件组和邮箱的信息记录              |
| MR    | 改名的邮箱记录                      |
| MX    | 邮件服务器记录                      |
| NS    | 名字服务器记录                      |
| PTR   | 反向记录                            |
| RP    | 负责人记录                          |
| RT    | 路由穿透记录                        |
| SRV   | TCP服务器信息记录                   |
| TXT   | 域名对应的文本信息                  |
| X25   | 域名对应的X.25地址记录              |

### P2P 文件分发

这个结构与前面所有的 CS （客户-服务器）结构不同，这是点对点体系结构（Peer-peer architecture）

#### P2P概述

- 没有一个一直在线的服务器；
- 任意端系统之间直接进行通信；
- 每个点（peer）向其他的点请求服务，同时作为回报也会提供相应的服务；

优点：**自扩展性**（self-scalability）：新的点都会提供服务容量和负荷。

缺点：每个点都是间断性连接，而且IP地址会改变。

例子：P2P的文件分享，常见的种子下载使用的就是这个架构，所以人做种的人越多下载速度越快。

#### P2P vs 客户机-服务器

从一个服务器分发大小为F的文件到N个节点需要多少时间？（每个节点上传和下载的速率都是有限的，网络中有足够的带宽）

如果选用**客户机-服务器**结构

- 服务器上传：需要上传这份文件 N 次，上传速度为 $u_s$，则需要的上传时间为 $NF/u_s$。
- 客户机下载：每个客户机都需要下载文件，$d_{min}$ 是客户机最小下载速度，则客户机下载的最大时间为 $F/d_{min}$.

客户机-服务器结构的分发时间
$$
Dc_s≥max\{NF/u_s,F/d_{min}\}
$$
此处的 N 导致耗费的时间随要下载的节点的数量**线性增长**，当要下载的节点数目大时，要耗费相当多的时间。

不需要先上传完再下载，参考第一章/网络核心/分组交换，以分组为单位发送，可以忽略上传到下载的时间。

如果选用 **P2P** 结构

- 服务器上传：服务器至少要上传 1 次文件，上传时间为 $F/u_s$
- 客户机下载：每个客户机都要下载文件，客户机最大下载时间为 $F/d_{min}$
- 客户机上传：每个下载了文件的客户机都可以上传文件，此时总上传速率可以达到 $u_s+\sum^nu_i$

P2P结构的分发时间
$$
DP2P≥max\{F/u_s,F/d_{min},NF/(us+∑nu_i)\}
$$
客户机-服务器结构和P2P分发时间对比：

![P2PwithCS](https://cos.asuka-xun.cc//blog/image-20221217180900759.png)

#### BitTorrent

- 文件分为大小为 256Kb 的块（chunk）
- 每个节点负责上传和下载的文件块
- 追踪器（tracker）：追踪参加洪流的节点
- 洪流（torrent）：有一组节点相互交换文件块
- 新的节点想下载文件，先询问追踪器参加的节点，再从相近的节点处下载文件块

- 节点加入洪流：
  - 本身没有文件块，但是随着时间的推移会从其他节点获取文件块
  - 需要在追踪器进行登记，并且一般连接临近的节点
- 下载时，节点会上传文件块到其他节点
- 节点可以更改交换文件块的节点
- 节点随时会上线和下线
- 一旦节点有了完整的文件，它可以离开或者留在洪流中

**请求文件块**

- 在给定的时间，不同的节点拥有不同的文件块
- 一定周期，新的节点会问每个节点有哪些块
- 新节点会从其他节点处下载缺失的文件块
  **最稀缺优先**（rarest first）：如果有10个节点都有第1、2块，只有一个节点有第3块，则先下载第3块。

**发送文件块**

  发送文件块遵守**一报还一报原则（tit-for-tat）**

- 节点会给目前给它发送文件块速率最高的四个节点发送文件块，其他节点就不发送了，每隔 10s 会选出新的top4
- 每隔 30s 会随机选择其他节点发送文件块，这样这个随机节点可能就会成为新的top4

### Socket 编程

**UDP**

UDP：客户机与服务器之间没有连接

- 发送数据前不需要握手
- 发送数据包附加 IP 地址+端口号
- 接收方从数据包中提取处 IP 地址+端口号

UDP 提供的是一种不可靠的数据流传输，传输过程中可能会丢包，接收的时候顺序也可能被打乱。

**TCP**

- 服务器的先行准备
  - 服务器必须先运行
  - 服务器需要创建 socket 来连接客户机
- 客户机连接服务器
  - 客户机需要创建自己的 socket，明确服务器进程的IP地址和端口号
  - 客户机创建 socket 时，客户机和服务器之间需建立 TCP连接
- 服务器接收客户机消息
  - 服务器需创建一个新的 socket，为了服务器进程能够和客户机进行通信
    - 要运行服务器与多个客户机进行通信
    - 用源的端口号来区分不同的客户机

TCP提供的是一种可靠的字节流（byte-stream）传输（pipe）。

#### UDP  套接字编程

UDPServer：

```python
from socket import *

serverHost = ''
serverPort = 12000
# 套接字由 ip 和 端口绑定
ADDR = (serverHost, serverPort)
serverSocket = socket(AF_INET, SOCK_DGRAM)
# 将端口号与该服务器的套接字绑定
serverSocket.bind(ADDR)
print("The server is ready to receive")
while True:
    message, clientAddress = serverSocket.recvfrom(2048)
    print(message)
    modifiedMessage = "Hello, message is receive and i change some word -->" + message.decode().upper()
    serverSocket.sendto(modifiedMessage.encode(), clientAddress)
```

UDPClient：

```python
from socket import *

serverName = '127.0.0.1'
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_DGRAM)
message = input('please input some message:' + '\n')
clientSocket.sendto(message.encode(), (serverName, serverPort))
modifiedMessage, serverAddress = clientSocket.recvfrom(2048)
print(modifiedMessage.decode())
clientSocket.close()
```

#### TCP  套接字编程

TCPClient：

```python
from socket import *

serverName = '127.0.0.1'
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_STREAM)
clientSocket.connect((serverName, serverPort))
sentence = input("please input:" + '\n')
clientSocket.send(sentence.encode())
modifiedSentence = clientSocket.recv(2048)
print('From Server: ', modifiedSentence.decode())
clientSocket.close()
```

TCPServer：

```python
from socket import *

serverPort = 12000
serverSocket = socket(AF_INET, SOCK_STREAM)
serverSocket.bind(('', serverPort))
serverSocket.listen(2)
print('The server is ready to receive')
while True:
    connectionSocket, addr = serverSocket.accept()
    sentence = connectionSocket.recv(2048).decode()
    capitalizedSentence = sentence.upper()
    connectionSocket.send(capitalizedSentence.encode())
    connectionSocket.close()
```

