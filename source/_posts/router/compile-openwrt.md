
---
title: 编译 Openwrt 固件
cover: https://cos.asuka-xun.cc/blog/assets/compile-openwrt.jpg
date: 2022/9/6 15:02
categories:
- [路由器]
tags:
- 路由器
- OpenWrt
---
# 编译 Openwrt 固件

前提条件：

- 具有 Linux 系统，我使用的是 WSL，WSL 的安装可以去官网看：[Install WSL | Microsoft Docs](https://docs.microsoft.com/en-us/windows/wsl/install)

  > 注意：使用 Linux 系统编译是**不能直接使用** root 用户的，WSL 默认使用的不是 root 用户。
  >
  > 关于 Linux 用户管理可以看看我写的这篇文章：[Linux 用户管理 - Linux | xun = 不失去热情 = 碎碎念 (asukaxun.com)](https://asukaxun.com/2022/08/21/Linux/linux-user-manager%20/)

- 建议使用代理，不然下载可能会有点慢。（WSL 的代理配置可以看看这篇文章：[Windows Subsystem for Linux 配置记录 | 0xfaner's Blog](https://blog.0xfaner.site/posts/wsl-config/)）

我这里编译的是 L 大的固件，与官方源编译可能会有些不同。L 大源码仓库：[coolsnowwolf/lede: Lean's OpenWrt source (github.com)](https://github.com/coolsnowwolf/lede)

## 编译安装

### 1. 安装编译依赖

```bash
sudo apt update -y
sudo apt full-upgrade -y
sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev \
libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pip libpython3-dev qemu-utils \
rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
```

### 2. 下载源代码，更新源 （feeds） 

```bash
git clone https://github.com/coolsnowwolf/lede
cd lede
./scripts/feeds update -a
./scripts/feeds install -a
```

### 3. 选择配置

如果遇到`Your display is too small to run Menuconfig!`错误，调大屏幕分辨率即可。

```bash
make menuconfig
```

这里会进入到一个菜单：

![image-20220906135736200](https://cos.asuka-xun.cc/blog/image-20220906135736200.png)

使用空格为选中或取消选中（也可以使用 Y 选中和 N 取消选中），使用回车进入子菜单。

选项有三种标志：

- < > 该代码将**不会**被编译
- <M> 只编译不打包进固件。即交叉编译，生成的ipk软件包将被放在 `/buildsystem/bla/bla/bla`, 但该软件包不会放入固件中。固件不能直接使用这个功能，需要手动导入安装。
- <*>  将编译并打包进固件，该代码将被放入固件中 (on the SqashFS partition)，固件可以直接使用这个功能。

#### 选择机型

我自己的路由器是 K2P。所以我这里配置是：

`Target System`：

```
Target System > MediaTek Ralink MIPS
```

> 排序都是按字母排序。
> 输入 `cat /proc/cpuinfo` 可以看到这个信息

`Subtarget`：

```
Subtarget > MT7621 based boards
```

`Target Profile`：

```
Phicomm K2P
```

**关于这些信息的查看**：

```bash
# 查看CPU信息
cat /proc/cpuinfo

# 查看CPU架构
uname -m

# 查看内核信息
uname -a

# 可接受的架构
opkg print-architecture
```

#### 配置软件

`LuCI→Applications` 选择我们需要的软件，也可以取消不需要的软件。注意看标志。

![image-20220906142512588](https://cos.asuka-xun.cc/blog/image-20220906142512588.png)

关于这些插件请看：[OpenWrt 编译 LuCI-> Applications 添加插件应用说明-L大【2021.11.18】-OPENWRT专版-恩山无线论坛 (right.com.cn)](https://www.right.com.cn/forum/thread-344825-1-1.html)，不过这个帖子时间有点久了，有些信息可能不太适用。

```
LuCI ---> Applications ---> luci-app-accesscontrol #访问时间控制
LuCI ---> Applications ---> luci-app-adbyby-plus  #广告屏蔽大师Plus +
LuCI ---> Applications ---> luci-app-arpbind #IP/MAC绑定
LuCI ---> Applications ---> luci-app-autoreboot #支持计划重启
LuCI ---> Applications ---> luci-app-ddns  #动态域名 DNS（集成阿里DDNS客户端）
LuCI ---> Applications ---> luci-app-filetransfer #文件传输（可web安装ipk包）
LuCI ---> Applications ---> luci-app-firewall  #添加防火墙
LuCI ---> Applications ---> luci-app-frpc  #内网穿透 Frp
LuCI ---> Applications ---> luci-app-ipsec-vpnd #VPN服务器 IPSec
LuCI ---> Applications ---> luci-app-nlbwmon  #网络带宽监视器
LuCI ---> Applications ---> luci-app-ramfree #释放内存
LuCI ---> Applications ---> luci-app-samba  #网络共享（Samba）
-------------------------------------------------------------------------------------------
LuCI ---> Applications ---> luci-app-turboacc  #Turbo ACC 网络加速(支持 Fast Path 或者 硬件 NAT)
LuCI ---> Applications ---> luci-app-unblockmusic #解锁网易云灰色歌曲3合1新版本
LuCI ---> Applications ---> luci-app-upnp  #通用即插即用UPnP（端口自动转发）
LuCI ---> Applications ---> luci-app-vlmcsd #KMS服务器设置
LuCI ---> Applications ---> luci-app-vsftpd #FTP服务器
LuCI ---> Applications ---> luci-app-wifischedule #WiFi 计划
LuCI ---> Applications ---> luci-app-wireless-regdb #WiFi无线
LuCI ---> Applications ---> luci-app-wol  #WOL网络唤醒
LuCI ---> Applications ---> luci-app-xlnetacc #迅雷快鸟
LuCI ---> Applications ---> luci-app-zerotier #ZeroTier内网穿透
```

如果采用的是openwrt官方源编译，务必要将LuCI→Collections→luci选上，否则可能无法进入web管理界面。

我们还可以选择主题：`LuCI > Themes`，虽然只有几个而已。`argon` 就挺好看的。

这些配置都配好之后直接保存退出就行了。

接下来就是编译固件。

### 4. 编译固件

-j 后面是线程数，第一次编译推荐用单线程。

**注意注意**：如果使用 WSL 进行编译，由于 WSL 的 PATH 中包含带有空格的 Windows 路径，有可能会导致编译失败，所以我们需要在 `make` 前面加上：

```bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

如下：

```bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make download -j8
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make V=s -j1
```

如果不使用 WSL 编译，那这里直接：

```bash
make download -j8
make V=s -j1
```

执行完这些命令之后就开始编译了，第一次编译需要的时间比较长，大概一小时这样。

### K2P `breed` 刷入：

编译完成后可以在`lede/bin/targets/ramips/mt7621`下找到编译生成的文件，我们需要的是`openwrt-ramips-mt7621-k2p-squashfs-sysupgrade.bin`这个文件。

在`breed`下刷入`sysupgrade`镜像，闪存布局选择“斐讯0xA0000”，如果布局选择错误可能会导致路由器反复重启。

如果我们需要重新配置：

```bash
rm -rf ./tmp && rm -rf .config
make menuconfig
make V=s -j$(nproc)
```



参考文章及文档：

[lede/README.md at master · coolsnowwolf/lede (github.com)](https://github.com/coolsnowwolf/lede/blob/master/README.md)

[[OpenWrt Wiki\] OpenWrt编译 – 说明](https://openwrt.org/zh-cn/doc/howto/build)

[编译k2p的openwrt固件 - 网络资源 - 宅...orz (zorz.cc)](https://zorz.cc/post/k2p-compile-openwrt.html)

[OpenWrt 小白常用命令大全 - 彧繎博客 (opssh.cn)](https://opssh.cn/luyou/232.html)

[OpenWrt 编译 LuCI-> Applications 添加插件应用说明-L大【2021.11.18】-OPENWRT专版-恩山无线论坛 (right.com.cn)](https://www.right.com.cn/forum/thread-344825-1-1.html)