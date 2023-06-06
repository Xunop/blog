---
description: 本篇用于总结 Linux 用户管理常见操作。以下使用 Ubuntu 系统为例。 Ubuntu 添加用户有两条命令。`adduser` 和 `useradd` 都可以创建用户，Ubuntu 则通常使用 `adduser`，在其他 Linux 发行版本中通常使用 `useradd`。
title: Linux 用户管理
cover: https://cos.asuka-xun.cc/blog/assets/linux_user.jpg
date: 2022/8/21 19:44
categories:
- [Linux]
tags:
- Linux
- Ubuntu
---
# Linux 用户管理

本篇用于总结 Linux 用户管理常见操作。以下使用 Ubuntu 系统为例。

## Linux 系统用户账号的管理

### 1、添加用户

Ubuntu 添加用户有两条命令。`adduser` 和 `useradd` 都可以创建用户，Ubuntu 则通常使用 `adduser`，在其他 Linux 发行版本中通常使用 `useradd`。

- 使用 `useradd` 命令：

  ```shell
  useradd [option] username
  ```

  > 选项：
  >
  > - -c comment 指定一段注释性描述。
  > - -d 目录 指定用户主目录，如果此目录不存在，则同时使用-m选项，可以创建主目录。
  > - -g 用户组 指定用户所属的用户组。
  > - -G 用户组，用户组 指定用户所属的附加组。
  > - -s Shell文件 指定用户的登录Shell。
  > - -u 用户号 指定用户的用户号，如果同时有-o选项，则可以重复使用其他用户的标识号。

  ```shell
  useradd -d /home/user1 -m user1
  ```

  创建一个新用户 user1，且使用 -d 和 -m 选项为为这个账号创建了一个主目录 /home/user1。`-m` 就是 `--move-home` 将用户主目录的内容移动到新位置，只能跟 `-d` 一起使用。

  为这个用户设置密码：

  ```shell
  passwd user1
  ```

- 使用 `adduser` 命令：

  这个就很方便了，采用的是人机交互的形式，会提示操作者按照步骤设置。

  ```shell
  adduser user2
  ```

  执行结果：

  ```shell
  Adding user `user2' ...
  Adding new group `user2' (1003) ...
  Adding new user `user2' (1003) with group `user2' ...
  Creating home directory `/home/user2' ...
  Copying files from `/etc/skel' ...
  New password:
  Retype new password:
  passwd: password updated successfully
  Changing the user information for user2
  Enter the new value, or press ENTER for the default
          Full Name []:
          Room Number []:
          Work Phone []:
          Home Phone []:
          Other []:
  Is the information correct? [Y/n] y
  ```

  自动帮我们创建了主目录，一步步提示我们，我们不需要输入的信息直接回车就行了。

### 2、赋予用户权限

```bash
visudo /etc/sudoers
```

[注意]{.label .danger} ： 不要使用其他编辑器去编辑这个文件，必须使用 `visudo` 这个命令代替。因为在这个文件中语法不当可能会导致系统崩溃。

赋予用户权限，在 `%sudo ALL=(ALL:ALL) ALL`下面添加：

```
master ALL=(ALL)        ALL
```

> 关于权限介绍，我们可以看到 root 的权限：
>
> `root    ALL=(ALL:ALL) ALL`
>
> 依次解释 ALL 的意思
>
> 1. 第一个 `ALL` 表示此规则适用于所有主机。
> 2. 这个 `ALL` 表示 root 用户可以作为所有用户运行命令。
> 3. 这个 `ALL` 表示 root 用户可以作为所有组运行命令。
> 4. 最后一个 `ALL` 表示这些规则（指以上规则）适用于所有命令。
>
> 这说明我们的 root 用户可以使用 `sudo` 运行任何命令。

因为 Ubuntu 中默认使用 nano 编辑器（其他系统可能使用 vi 编辑器），所以保存退出是需要按快捷键来完成。当然你可以手动改成 vi 编辑器，使用命令 `sudo update-alternatives --config editor` 不细讲，可以去了解一下。

> - 保存：[Ctrl]{.kbd} + [O]{.kbd .red}
> - 退出：[Ctrl]{.kbd} + [X]{.kbd .red}

保存完之后，可以切换到用户测试一下。

还有一点就是我们给予了这个用户权限，但是我们每次 `sudo` 的时候都需要输入一次密码，我觉得很麻烦，我们可以更改赋予权限的配置上让我们输入 `sudo` 时不需要输入密码：

```bash
master ALL=(ALL) NOPASSWD:ALL
```

### 3、删除用户

直接使用 `userdel` 命令。

```shell
userdel -r user2
```

> 可以使用 `-r` 连着删除用户的主目录

### 4、修改用户

```shell
usermod 选项 用户名
```

> `-c`, `-d`, `-m`, `-g`, `-G`, `-s` 等跟添加用户的选项一样
>
> 命令选项有很多的，可以去[Ubuntu Manpage: usermod - modify a user account](https://manpages.ubuntu.com/manpages/xenial/en/man8/usermod.8.html)看。

```shell
usermod -d /home/newuser -m user1
```

执行这条命令之后，我们可以在 /etc/passwd 中看到 `user1:x:1002:1002::/home/newuser:/bin/sh` 主目录改变了。

### 5、用户口令的管理

用来更改用户密码。root 用户可以改变任何用户的密码，其他用户只能改变自己的密码。

```shell
passwd [option] username
```

> 选项：
>
> - -d 删除密码
> - -f 强迫用户下次登录时必须修改口令
> - -w 口令要到期提前警告的天数
> - -k 更新只能发送在过期之后
> - -l 停止账号使用
> - -S 显示密码信息
> - -u 启用已被停止的账户
> - -x 指定口令最长存活期
> - -g 修改群组密码
> - 指定口令最短存活期
> - -i 口令过期后多少天停用账户

## 用户组的管理

### 查看所有用户和用户组

可以通过查看`/etc/shadow`文件来查看系统中存在的所有用户。

可以通过查看`/etc/group`文件来查看系统中存在的所有用户组。

可以通过查看 `/etc/passwd` 文件查看所有用户信息。

可以使用命令 `who am i` 查看当前登录的用户。

每个用户都有一个用户组，像我们前面使用 `adduser` 命令的时候，`Adding new user `user2' (1003) with group `user2' ...` 这里表示新建了一个用户组并且将 user2 加入到其中。

1. 增加用户组

   ```shell
   groupadd [option] 用户组
   ```

   > 选项：
   >
   > - -g GID 指定新用户组的组标识号（GID）。
   > - -o 一般与-g选项同时使用，表示新用户组的GID可以与系统已有用户组的GID相同。

2. 删除用户组

   ```shell
   groupdel 用户组
   ```

3. 修改用户组

   ```shell
   groupmod [option] 用户组
   ```

   > 选项：
   >
   > - -g GID 为用户组指定新的组标识号。
   > - -o 与-g选项同时使用，用户组的新GID可以与系统已有用户组的GID相同。
   > - -n新用户组 将用户组的名字改为新名字

4. 切换用户组

   用户同时属于多个组时切换用户组使用：

   ```shell
   newgrp 用户组
   ```

   
