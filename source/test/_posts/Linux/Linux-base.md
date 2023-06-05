---
title: Linux 入门、基础 Shell 【方草地授课】
cover: https://cos.asuka-xun.cc/blog/assets/Linux-introduction.jpg
date: 2022/10/2
categories:
- [Linux]
tags:
- Linux
- Ubuntu
---

## Linux 是什么？

Linux® 是一个**开源**的操作系统（OS）。它由 Linus Torvalds [于 1991 年](https://groups.google.com/forum/#!msg/comp.os.minix/dlNtH7RRrGA/SwRavCzVE7gJ)构思设计而成，最初这只是他的一项兴趣爱好。当时还在读大学的 Linus 想要基于 Unix（是一个强大的多用户、多任务操作系统，支持多种处理器架构，按照操作系统的分类，属于分时操作系统，最早由肯·汤普逊、丹尼斯·里奇和道格拉斯·麦克罗伊于1969年在AT&T的贝尔实验室开发。） 的原则和设计来创建一个免费的开源（指源代码可以任意获取的计算机软件，任何人都能查看、修改和分发他们认为合适的代码）系统，从而代替 MINIX 操作系统。~~人家读大学做出操作系统，我们读大学...~~。自此，这项兴趣爱好便逐步演变成了拥有最大用户群的操作系统。如今，它不仅是公共互联网服务器上最常用的操作系统，还是速度排名前 500 的超级电脑上使用的唯一一款操作系统。

<!-- more -->
## 为什么需要学习使用 Linux？

1. 个人桌面领域的应用

2. **服务器领域**：

   linux在服务器领域的应用是最强的。linux免费、稳定、高效等特点在这里得到了很好的体现，尤其在一些高端领域尤为广泛（c/c++/php/java/python/go）。

3. 嵌入式领域：

   linux运行稳定、对网络的良好支持性、低成本，且可以根据需要进行软件裁剪，内核最小可以达到几百KB等特点，使其近些年来在嵌入式领域的应用得到非常大的提高。就比如我就在一个**随身 Wifi** 中刷入了一个 Debian 系统（Linux 的一个发行版）。

   

## 虚拟机是什么？

虚拟机是一种软件形式的计算机，和物理机一样能运行操作系统和应用程序。虚拟机可使用其所在物理机（即主机系统）的物理资源。虚拟机具有可提供与物理硬件相同功能的虚拟设备，在此基础上还具备可移植性、可管理性和安全性优势。

## 为什么使用虚拟机？

1. 虚拟机拥有操作系统和虚拟资源，其管理方式非常类似于物理机。例如，我们可以像在物理机中安装操作系统那样在虚拟机中安装操作系统。

2. 利用虚拟机软件搭建 Linux 学习环境简单，容易上手，最重要的是利用虚拟机模拟出来的 Linux 与真实的 Linux 几乎没有区别。当然我们也可以直接购买云服务器来学习 Linux 的使用。
3. 使用虚拟机系统环境，我们可以对虚拟系统随意进行任何的设置和更改操作，甚至可以格式化虚拟机系统硬盘，进行重新分区等操作，而且完全不用担心会丢掉有用的数据，因为虚拟机是系统上运行的一个虚拟软件，对虚拟机系统的任何操作都相当于是在操作虚拟机的虚拟机设备和系统，不会影响电脑上的真实数据。

## VMware Workstation Pro 安装

我们这个课使用 VMware Workstation Pro 安装虚拟机。

VMware Workstation Pro 是 VMware 公司推出的一款桌面虚拟计算软件，具有 Windows、Linux 版本。此软件可以提供虚拟机功能，使计算机可以同时运行多个不同操作系统。

**Workstation Pro 的主机系统要求**
用于安装 Workstation Player 的物理机称为主机系统，其安装的操作系统称为主机操作系统。要运行 Workstation Pro，主机系统和主机操作系统必须满足特定的硬件和软件要求：[Workstation Pro 的主机系统要求 (vmware.com)](https://docs.vmware.com/cn/VMware-Workstation-Pro/16.0/com.vmware.ws.using.doc/GUID-47896F7A-2C4F-457E-8ED1-6E5AEFDDD64A.html)

官网下载地址：[Download VMware Workstation Pro](https://www.vmware.com/products/workstation-pro/workstation-pro-evaluation.html)。

激活码（任意一个都行）：

```
ZF3R0-FHED2-M80TY-8QYGC-NPKYF
YF390-0HF8P-M81RQ-2DXQE-M2UT6
ZF71R-DMX85-08DQY-8YMNC-PPHV8
```

来自：[Free VMware Workstation Pro 16 to 16.1.1 full license keys with tested (updated with latest verion) (github.com)](https://gist.github.com/williamgh2019/cc2ad94cc18cb930a0aab42ed8d39e6f)。

安装跟着提示步骤走就行了。

如果遇到这个问题，我们勾选**左下角**的复选框然后点击 Next。

![image-20220929212441651](https://cos.asuka-xun.cc/blog/image-20220929212441651.png)

> 关于这个问题：
>
> Hyper-V 是一个type 1 hypervisor，当在 Windows 中启用 Hyper-V 时，Windows 系统在硬件底层与 Windows 应用层之间插入了一层 Hyper-V，而原来的 Windows 应用层则变成了一个运行在 Hyper-V 上的虚拟机。
>
> 而 VMWare Workstation/Player 使用一种被称为虚拟机监视器（Virtual Machine Monitor，VMM）[3]的机制，直接访问 CPU 内建的虚拟化功能，因此，它们本身不能在虚拟机环境中运行，换句话说，不支持嵌套虚拟化（nested virtualization）。
>
> 当 Windows 启用 Hyper-V 时，原来的 Windows 变成了虚拟机环境，而 VMWare Workstation Player 不能在虚拟机环境中运行，因此，运行VMWare Workstation Player 时会报错。
>
> 但是 VMWare 在 15.5.5 版本就通过利用微软的 Windows Hypervisor Platform (WHP) 的 API 解决了这一问题。这里我们使用的版本是最新的 16 版本，所以我们直接勾选左下角的复选框就可以解决这个问题。

## 下载 ISO 镜像文件

我们这里安装 Ubuntu，它是 Linux 的一个发行版。Linux 发行版可以分为商业发行版，比如 Ubuntu、Red Hat Enterprise Linux；和社区发行版，它们由自由软件社区提供支持，如 Debian、Fedora、Arch。

我下载的默认最新版，我们也可以点击箭头所标处选择其他版本。

下载地址（使用镜像站）：

https://mirrors.bfsu.edu.cn/ubuntu-releases/jammy/ubuntu-22.04.1-desktop-amd64.iso

https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/jammy/ubuntu-22.04.1-desktop-amd64.iso

https://iso.mirrors.ustc.edu.cn/ubuntu-releases/jammy/ubuntu-22.04.1-desktop-amd64.iso

**建议专门创一个文件夹存储这个 `ISO` 镜像文件。**

## 创建虚拟机

点击创建新的虚拟机。

![image-20220929210541304](https://cos.asuka-xun.cc/blog/image-20220929210541304.png)

当然选择简单的安装步骤啦：

![image-20220929210612376](https://cos.asuka-xun.cc/blog/image-20220929210612376.png)

## 试用 Ubuntu

**注意**：我们现场操作使用不同的步骤，我们试用 Ubuntu。

**安装 Ubuntu 的话设置不是这样设置的，可以去看后面的安装的步骤，这里只是为了方便我们采用试用方法。**

![image-20221001223748556](https://cos.asuka-xun.cc/blog/image-20221001223748556.png)

选择 Linux， Ubuntu 64 位：

![image-20221001223808707](https://cos.asuka-xun.cc/blog/image-20221001223808707.png)

因为我们是试用 Ubuntu，所以有些地方需要设置一下：

![image-20221001224208462](https://cos.asuka-xun.cc/blog/image-20221001224208462.png)

选择 CD/DVD(SATA)，按照下面进行配置。使用 ISO 映像文件就是我们所下载的 ISO 文件存储地址。

![image-20221001224343872](https://cos.asuka-xun.cc/blog/image-20221001224343872.png)

这里选择第一项，按回车。

![image-20221001225007185](https://cos.asuka-xun.cc/blog/image-20221001225007185.png)

等待...

![image-20221001225040963](https://cos.asuka-xun.cc/blog/image-20221001225040963.png)

我们把语言换成中文简体，然后点试用 Ubuntu。

![image-20221001225224854](https://cos.asuka-xun.cc/blog/image-20221001225224854.png)

等待一下...我们就会进到 Ubuntu 了。

![image-20221001225330687](https://cos.asuka-xun.cc/blog/image-20221001225330687.png)

点击右下角

![image-20221001225450965](https://cos.asuka-xun.cc/blog/image-20221001225450965.png)

点击软件和更新：

![image-20221001225526061](https://cos.asuka-xun.cc/blog/image-20221001225526061.png)

点箭头所指位置：

![image-20221001225734852](C:\Users\xun\AppData\Roaming\Typora\typora-user-images\image-20221001225734852.png)

点其它：

![image-20221001225707911](https://cos.asuka-xun.cc/blog/image-20221001225707911.png)

快看看这是什么？是南邮的镜像站！（南邮的镜像站最近关闭了外网访问，不过我们用三个校园网中的任一个都能访问到）。可以自己尝试一下使用南邮的镜像站，内网速度应该是挺快的。

南邮镜像站：[mirrors.njupt.edu.cn](https://mirrors.njupt.edu.cn/)。

![image-20221001225849149](https://cos.asuka-xun.cc/blog/image-20221001225849149.png)

我们镜像站可以使用阿里云的，点击选择服务器，逐步退出就行了。

![image-20221001225958325](https://cos.asuka-xun.cc/blog/image-20221001225958325.png)

---

## 安装 Ubuntu

**这里接上创建虚拟机的步骤**

这里选择安装镜像文件，找到镜像文件地址：

![image-20220929210628741](https://cos.asuka-xun.cc/blog/image-20220929210628741.png)

---

这个真的就只是安装信息。

![image-20220929210649524](https://cos.asuka-xun.cc/blog/image-20220929210649524.png)

虚拟机安装位置：

![image-20220929210811898](https://cos.asuka-xun.cc/blog/image-20220929210811898.png)

指定磁盘容量。在 Ubuntu 22.04 中最低要求 25 GB（感觉应该 20 GB 问题也不大）。

![image-20220929210850659](https://cos.asuka-xun.cc/blog/image-20220929210850659.png)

<img src="https://cos.asuka-xun.cc/blog/image-20220925152743219.png" alt="image-20220925152743219" style="zoom: 50%;" />

最后我的配置是这样的：

![image-20220929210904922](https://cos.asuka-xun.cc/blog/image-20220929210904922.png)

点击完成之后就进入到系统安装界面了。

**注意：**因为我们需要更新，所以我们在安装系统的时候需要保持**联网**。

切换语言：

![image-20220925094734940](https://cos.asuka-xun.cc/blog/image-20220925094734940.png)

> 这里选择的语言还需要自己去设置里改，而且语言包似乎也不完整也需要我们进行下载。这也是我们安装需要联网的原因之一。

这里我们选择**最小的安装**，不然到时候安装东西太多会很慢（而且我们也不需要那么多应用）。在 **Other options** 处，**建议两个都勾选**（官方建议）。

![image-20220925153348434](https://cos.asuka-xun.cc/blog/image-20220925153348434.png)

![image-20220925090959922](https://cos.asuka-xun.cc/blog/image-20220925090959922.png)

选择 **Erase disk and install Ubuntu**。

![image-20220925095117975](https://cos.asuka-xun.cc/blog/image-20220925095117975.png)

> 这一步我们选择 **Erase disk and install Ubuntu** 是因为我们只在这台虚拟机上装这一个系统。

直接安装，虚拟机毫无顾虑，我们直接 **Continue**。

![continue-installation](https://cos.asuka-xun.cc/blog/continue-installation.png)

时区选择上海就行了。

![image-20220925095157503](https://cos.asuka-xun.cc/blog/image-20220925095157503.png)

> 如果是联网状态的话，会自动检测。

设置用户名跟密码。

**注意：**你需要记住这里的用户名跟密码，这里的用户名跟密码是你登录你的 `Ubuntu`所需要的。跟我们 `Windows` 的用户名密码一样。

![image-20220925154026589](https://cos.asuka-xun.cc/blog/image-20220925154026589.png)

接下来就是等待安装。

![complete-installation](https://cos.asuka-xun.cc/blog/complete-installation.png)

安装完成会提示你重启。重启就行了。

![restart-now](https://cos.asuka-xun.cc/blog/restart-now.png)

从官网偷一个笑脸给大家，祝贺大家完成安装🥳。

![:slight_smile:](https://discourse.ubuntu.com/images/emoji/emoji_one/slight_smile.png?v=9)

## Ubuntu 简单配置

前面我们已经把 Ubuntu 成功安装到虚拟机上，接下来我们进入系统。

Ubuntu 会有一个欢迎界面，不过这个欢迎界面也没什么设置，看你自己想设置些什么。（这个界面可能会无响应，我们可以直接关闭吗，如果你想设置账号也可以在这里设置）

![welcome](https://cos.asuka-xun.cc/blog/welcome.png)

这个界面包括：

- 将配置文件连接到各种在线帐户。

- 将 Livepatch 配置为自动对设备应用更新(此选项仅在使用 Ubuntu 的长期支持[ LTS ]版本时可用)。

- 选择向 Canonical 发送设备信息以帮助改进 Ubuntu (默认情况下，Canonical 不收集设备信息)。

- 启动定位服务。

- 从 Ubuntu 软件下载附加应用程序。

在进行以下操作的时候可能会弹出一个窗口说要更新，我们可以选择先跳过，当我们把镜像替换之后再进行更新。

### 安装 Vmware Tools

VMware Tools 是一套可以提高虚拟机客户机操作系统性能并改善虚拟机管理的实用工具。

例如，下面是在安装 VMware Tools 后才能使用的一部分功能：

- 显著提高了图形性能，并在支持 Windows Aero 的操作系统上提供 Aero
- Unity 功能；允许在主机桌面上显示虚拟机中的应用程序，就像任何其他应用程序窗口一样
- 在主机与客户机文件系统之间共享文件夹
- 在虚拟机和主机或客户端桌面之间**拷贝**和**粘贴**文本、图形和文件
- 提高了鼠标性能
- 将虚拟机中的时钟与主机或客户端桌面上的时钟进行同步
- 使用脚本帮助自动完成客户机操作系统操作
- 为虚拟机启用客户机自定。

可能有时候安装 VMware Workstation Pro 时没有自动安装 Vmware Tools，这时我们需要自动安装。

强烈建议安装 Vmware Tools。

```shell
sudo apt install open-vm-tools-desktop
```

### 替换镜像

系统安装完毕，我们先替换一下镜像方便我们更新软件。

按 **CTRL+ALT+T** 或者右键鼠标打开终端窗口。

执行以下命令自动替换：

```shell
sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
```

清华源镜像站：

[ubuntu | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/)

### 更新软件

替换完镜像第一件事就是更新软件。

找到 **Software Updater** 打开。

![software-updater](https://cos.asuka-xun.cc/blog/software-updater.png)

或者我们可以在终端窗口执行下面两个命令：

```shell
sudo apt update
```

系统会提示要求输入当前用户登录密码。

```shell
sudo apt upgrade
```

输入 **Y**，然后按 **ENTER** 键来确认完成。

### 更改语言

虽然我们前面选了语言，因为语言包不完整，所以我们还需要下载完整的语言包。

进入设置，找到 **Regional & Language**，或者直接在搜索框搜索 language。 

![image-20220927150002681](https://cos.asuka-xun.cc/blog/image-20220927150002681.png)

点击 **Manage Installed Languages**，会提示让你安装完整语言包，安装完成后我们将 Language 选择 Chinese，然后重启。

![image-20220927140420316](https://cos.asuka-xun.cc/blog/image-20220927140420316.png)

## Linux 系统目录

或许我们都听过一句话：“Linux下一切皆文件”。“一切皆是文件”是 Unix/Linux 的基本哲学之一。我们在这里只讨论目录文件。

当我们输入以下命令：

```shell
ls /
```

会看到如下图所示：

![image-20220929223432802](C:\Users\xun\AppData\Roaming\Typora\typora-user-images\image-20220929223432802.png)

> `/lost+found` 这个目录一般情况下是空的，当系统非法关机后，这里就存放了一些文件。

树状目录结构：

![d0c50-linux2bfile2bsystem2bhierarchy](D:\桌面\d0c50-linux2bfile2bsystem2bhierarchy.jpg)

一些目录的解释：

|       目录        | 描述                                                         |
| :---------------: | ------------------------------------------------------------ |
| `/`（根文件系统） | *第一层次结构* 的根、 整个文件系统层次结构的根目录。在挂载其他文件系统之前，它必须包含引导 Linux 系统所需的所有文件。它必须包含引导其余文件系统所需的所有可执行文件和库。引导系统之后，所有其他文件系统都挂载在标准的、定义良好的挂载点上，作为根文件系统的子目录。 |
|      `/bin/`      | 需要在单用户模式可用的必要命令（可执行文件）；面向所有用户，*例如*： cat（检视档案连续内容）、 ls(列出文件)、 cp（复制文件）)。 |
|     `/boot/`      | 包含引导 Linux 计算机所需的静态引导加载程序、内核可执行文件和配置文件。 |
|      `/dev/`      | 此目录包含连接到系统的每个硬件设备的设备文件。这些不是设备驱动程序，而是代表计算机上每个设备并便于访问这些设备的文件。 |
|      `/etc/`      | 包含主机计算机的本地系统配置文件。                           |
|     `/home/`      | 用户文件的主目录存储。每个用户在/Home 中都有一个子目录。     |
|      `/lib/`      | `/bin/` 和 `/sbin/`中二进制文件必要的库文件。                |
|     `/media/`     | 安装可连接到主机的外部可移动媒体设备(如 U 盘)的地方。        |
|      `/mnt/`      | 常规文件系统的临时挂载点(如在不可移动媒体中) ，可以在管理员修复或处理文件系统时使用。 |
|      `/opt/`      | 可选应用软件包。                                             |
|     `/root/`      | 这不是根 (/) 文件系统，而是根用户的主目录。                  |
|     `/sbin/`      | 必要的系统二进制文件，*例如：* init、 ip、 mount。           |
|      `/tmp/`      | 临时目录。操作系统和许多程序用来存储临时文件。用户也可以在这里暂时存储文件。请注意，存储在这里的文件可能随时被删除，无需事先通知。 |
|      `/usr/`      | 用于存储只读用户数据的*第二层次*； 包含绝大多数的（多）用户工具和应用程序，注意不是 user 的缩写，而是 "Unix Software Resource" 的缩写。它们是可共享的只读文件，包括可执行二进制文件和库、 man 文件和其他类型的文档。 |
|      `/var/`      | 变量文件存储在这里。这可以包括日志文件（/var/log）、 MySQL 和其他数据库文件、 Web 服务器数据文件、电子邮件收件箱等等。 |
|     `/proc/`      | proc 是 Processes(进程) 的缩写，/proc 是一种伪文件系统（也即虚拟文件系统），存储的是当前内核运行状态的一系列特殊文件，这个目录是一个虚拟的目录，它是系统内存的映射，我们可以通过直接访问这个目录来获取系统信息。 |

> Linux 操作系统的文件系统层级结构标准：[文件系统层次结构标准 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.m.wikipedia.org/zh-hans/文件系统层次结构标准)

## Linux 常用命令（vim、nano 使用）

### Vi 和 Vim 编辑器

问：如何生成一个随机字符串？
答：让小白退出vim。

#### 基本介绍

Linux系统会内置 Vi 文本编辑器。

Vim 编辑器可能需要我们自己下载：

```shell
sudo apt install vim
```

Vim 具有程序编辑的能力，可以看做是 Vi 的增强版本，可以主动的以字体颜色辨别语法的正确性，方便程序设计。代码补完、编译及错误跳转等方便编程的功能特别丰富，在程序员中被广泛使用。

语法：

```shell
vim <文件名或文件绝对路径>
```

使用示例：

```shell
vim hello.c
```

```shell
vim /home/xun/workspace/hello.c
```

#### Vi 和 Vim 常用的三种模式

- 命令模式

  以 Vim 打开一个文本就直接进入一般模式了（这是默认的模式）。在这个模式中，你可以使用 [上下左右] 按键来移动光标或者 `k` `j` `h` `l` 来控制光标上下左右。Vim 中有许多快捷键就是在这个模式下进行的。关于 Vim 的快捷键这里给几个常用的：

  - i 切换到插入模式，以输入字符
  - : 切换到底线命令模式，以在最低一行输入命令
  - x 删除当前光标所在处的字符
  - dd 删除当前行
  - yy 复制当前行

  > 想看酷炫的 Vim 编辑器使用可以找后端组的学长：
  >
  > 👉QQ：2339168544
  >
  > 这位学长对 Vim 折腾的比较多。

  若想要编辑文本：启动 Vim，进入了命令模式，按下 i，切换到输入模式。

- 插入模式（输入模式）

  按下 i、I、o、O、a、A、r、R 等任何一个字母后才会进入编辑模式，一般来说按 i 即可。

  这个模式就相当于我们平时编辑文件的状态。

  按下 ESC 退出插入模式，切换到命令模式。

- 底线命令模式

  在命令模式下按下 : （英文冒号）就进入底线命令模式。

  底线命令模式可以输入单个或多个字符的命令，可用的命令非常多。

  在底线命令模式中，基本的命令有（已经省略了冒号）：

  - q 不保存,直接退出
  - q! 不保存，并强制退出
  - e! 放弃所有修改，从上次保存文件开始再编辑
  - w 保存文件,但不退出
  - w! 强制保存，不退出
  - wq 或 x 保存，并退出
  - wq! 强制保存，并退出
  - : set number 设置行号

  按ESC键可随时退出底线命令模式。

**退出 Vim 编辑器**：

在命令模式下按下 : （英文冒号）然后输入 wq 保存退出，强制不保存退出输入 q!。

各种模式的切换：

![](https://www.yumoyumo.top/wp-content/uploads/2022/04/image-20220406205033038.png)

### Nano 编辑器

Nano 编辑器也是我们使用得比较多的编辑器。如果我们安装的 Ubuntu 中并没有 Nano 编辑器的话，我们就需要下载：

```shell
sudo apt install nano
```

语法：

```shell
nano <文件名或文件绝对路径>
```

使用示例：

```shell
nano workspace/hello.c
```

```shell
nano hello.c
```

Nano 在打开文件后，下方会有几行文字，这些是快捷键说明。

![image-20221001170137568](https://cos.asuka-xun.cc/blog/image-20221001170137568.png)

^ 表示 Ctrl。

- `Ctrl` + `G`，显示帮助文本
- `Ctrl` + `O`，保存当前文件
- `Ctrl`+`R`，读取其他文件并插入光标位置
- `Ctrl`+`Y`，跳至上一屏幕
- `Ctrl`+`K`，剪切当前一行
- `Ctrl`+`C`，显示光标位置
- `Ctrl`+`X`，退出编辑文本
- `Ctrl`+`J`，对其当前段落（以空格为分隔符）
- `Ctrl`+`W`，搜索文本位置
- `Ctrl`+`V`，跳至下一屏幕
- `Ctrl`+`U`，粘贴文本至光标处
- `Ctrl`+`T`，运行拼写检查
- `Ctrl`+`_`，跳转到某一行
- `ALT`+`U`，撤销
- `ALT`+`E`，重做
- `ALT`+`Y`, 语法高亮
- `ALT`+`#`，显示行号

Nano 跟 Vim 还有很多进阶操作，这里只是给大家讲解了一些基础的操作，更多进阶的操作感兴趣的同学可以去了解一下。

---

## Linux SSH

### 什么是 SSH

**Secure Shell**（安全外壳协议，简称**SSH**）是一种加密的网络传输协议，可在不安全的网络中为网络服务提供安全的传输环境。SSH最常见的用途是远程登录系统，人们通常利用SSH来传输命令行界面和远程执行命令。看看定义：[Secure Shell - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.m.wikipedia.org/zh-hans/Secure_Shell)

我们通常使用 SSH 远程登录服务器。

SSH 支持不同种类的身份验证技术。最常见的机制之一是密码身份验证，另一种是基于公钥的身份验证。在这两种认证方式中，基于公钥的认证比基于数字签名的密码认证方式更安全、更方便。

因为使用 SSH 连接虚拟机配置有点麻烦，一般是不会这样操作的，我这里只给出教程地址：[windows宿主机如何SSH连接VMware的Linux虚拟机 - 腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1679861)，感兴趣的同学可以自己尝试。

关于设置 SSH 连接，可以参考我之前写的一篇文章：[Linux SSH远程配置及登录 - Linux | xun = 不失去热情 = 碎碎念 (asuka-xun.cc)](https://blog.asuka-xun.cc/2022/08/21/Linux/linux-ssh-config/)。

这些操作相对麻烦，考虑到课上可能讲不到这里，这里只是给出了相应的一些文章教程，感兴趣的同学可以自己尝试。遇到问题也可以向我们提问。

---

参考文章及文档：

[VMware Workstation Pro 文档](https://docs.vmware.com/cn/VMware-Workstation-Pro/index.html)

[wireless - Clarification of the third-party software options during system installation - Ask Ubuntu](https://askubuntu.com/questions/22285/clarification-of-the-third-party-software-options-during-system-installation)

[Install Ubuntu desktop | Ubuntu](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview)

[一文带你了解Linux是什么？Linux优点和应用 _ 红帽 (redhat.com)](https://www.redhat.com/zh/topics/linux)

[An introduction to Linux filesystems | Opensource.com](https://opensource.com/life/16/10/introduction-linux-filesystems)

