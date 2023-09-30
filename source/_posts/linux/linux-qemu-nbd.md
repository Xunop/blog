---
date: 2023-08-17
updated: 2023-09-30
title: wayland 腾讯会议共享屏幕
description: 或者直接指定虚拟磁盘的大小的缩写：它是一种允许一台机器访问另一台机器上的块设备的协议。在 linux 中，这一功能由 nbd 模块实现，需要加载该模块：
categories:
- [linux]
---

前置条件：

```
obs-studio xdg-desktop-portal-lxqt xdg-desktop-portal-wlr v4l2loopback-dkms xdg-desktop-portal
```

开启虚拟摄像头：

```
sudo modprobe v4l2loopback devices=1 video_nr=10 card_label='OBS Cam' exclusive_caps=1
sudo modprobe snd-aloop index=10 id='OBS Mic'
```

在 obs 里面就可以打开虚拟摄像头录取屏幕然后在腾讯会议共享屏幕了。

遇到开启虚拟摄像头 obs 卡住的话重启+重新创建虚拟摄像头。
