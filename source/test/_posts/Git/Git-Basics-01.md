---
title: Git 起步——Git 简介、安装、配置
cover: https://cos.asuka-xun.cc/blog/assets/Git-Base-01.jpg
date: 2022/8/23 1:04
categories:
- [Git]
tags:
- Git
---
# Git 起步——Git 简介、安装、配置

## Git 简介

### Git 是什么
<!-- more -->

**git **是用于Linux内核开发的版本控制工具。与 CVS、Subversion 一类的集中式版本控制工具不同，它采用了**分布式**版本库的作法，不需要服务器端软件，就可以运作版本控制，使得源代码的发布和交流极其方便。git 的速度很快，这对于诸如 Linux 内核这样的大项目来说自然很重要。git 最为出色的是它的合并追踪（merge tracing）能力。看维基百科：[git - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.wikipedia.org/zh-cn/Git)。

git 可以记录你对文件的改动。比如代码文件，你想找到前几天修改的代码，如果我们存有备份也需要一个个文件去翻。在团队开发的时候，团队里的人跟你修改同一份文件，你修改了一些内容，他也修改了一些内容，两人对这个文件都有改动那我们要想合并的话是不是就得手动合并。~~以上，我都没经历过（指手动管理版本）。~~{danger}如果没有 git 这个好东西可能我也需要经历这些，git 的出现改变了手动管理多个“版本”的难题。

### 集中化的版本控制系统和分布式版本控制系统

前面说过 git 采用的是分布式版本库的作法，那这个东西跟集中化的版本控制系统有什么区别？

集中化的版本控制系统是有一个单一的集中管理的服务器，保存所有文件的修订版本，而协同工作的人们都通过客户端连到这台服务器，取出最新的文件或者提交更新。这样每个人都可以看到对文件的改动，但是也有坏处，很明显，要是中央服务器宕机了那所有人都没法提交更新，要是磁盘什么的坏了数据就寄了，没了。

![image-20220822184456478](https://cos.asuka-xun.cc/blog/image-20220822184456478.png)

分布式版本控制系统则没有“中央服务器”，每个人的电脑上都是一个完整的版本库，多人协作也变得更方便，只需要把各自修改的推送给对方，就能看到对方的修改了。其实在使用分布式版本控制系统的时候是有中央服务器的，只是不是利用他存储所有文件，而是交换大家对文件的修改。使用分布式版本控制系统，即时任何一处协同工作用的服务器发生故障，事后都可以用任何一个镜像出来的本地仓库恢复。 因为每一次的克隆操作，实际上都是一次对代码仓库的完整备份。

![image-20220822185406699](https://cos.asuka-xun.cc/blog/image-20220822185406699.png)

## 安装 Git

### 在 Linux 上安装

输入 `git` 看系统是否已经安装 Git：

```shell
git
```

输入以下命令安装：

```shell
sudo apt-get install git
```

官网提供了不知道多少种 Unix 系统的安装方法：[Git (git-scm.com)](https://git-scm.com/download/linux)。

### 在 Windows 上安装

你可以安装 GitHub Desktop [Installing GitHub Desktop - GitHub Docs](https://docs.github.com/cn/desktop/installing-and-configuring-github-desktop/installing-and-authenticating-to-github-desktop/installing-github-desktop)也可以在 Git 官网下载安装程序[Git - Downloads (git-scm.com)](https://git-scm.com/downloads)。GitHub Desktop 包含了图形化和命令行版本的 Git。如果是官网下载的话直接下载安装找到 Git Bash 就行了。

安装完成后，我们需要设置我们的用户名和邮件地址。设置完成后，每一个 Git 提交都会使用这些信息，会写入到我们的每一次提交中，**不可更改**：

```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

## Git 配置

Git 的配置文件存放有三个不同位置（这些位置都是 Git 安装目录下的）：

1. `/etc/gitconfig` 文件: 包含系统上每一个用户及他们仓库的通用配置。 如果在执行 `git config` 时带上 `--system` 选项，那么它就会读写该文件中的配置变量。 （由于它是系统配置文件，因此你需要管理员或超级用户权限来修改它。）
2. `~/.gitconfig` 或 `~/.config/git/config` 文件：只针对**当前用户**。 你可以传递 `--global` 选项让 Git 读写此文件，这会对你系统上 **所有** 的仓库生效。
3. 当前使用仓库的 Git 目录中的 `config` 文件（即 `.git/config`）：针对该仓库。 你可以传递 `--local` 选项让 Git 强制读写此文件，虽然默认情况下用的就是它。。 （需要进入某个 Git 仓库中才能让该选项生效。）

每一个级别会**覆盖**上一级别的配置，所以 `.git/config` 的配置变量会覆盖 `/etc/gitconfig` 中的配置变量。

在 Windows 系统中我们可以使用以下命令查看所有配置及它们所在的文件：

```shell
git config --list --show-origin
```

**注意**：如果 `git config` 使用了 `--global` 选项，那么该命令只需要运行一次，因为之后无论你在该系统上做任何事情， Git 都会使用那些信息（用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置）。 当你想针对特定项目使用不同的用户名称与邮件地址时，可以在那个项目目录下运行没有 `--global` 选项的命令来配置。 因为 `--global` 命令会写入到 `~/.gitconfig` 或 `~/.config/git/config` 文件。

> 检查配置信息，可以列出所有 Git 能找到的配置：
>
> ```shell
> git config --list
> ```
