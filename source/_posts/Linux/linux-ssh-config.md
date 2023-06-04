---
title: Linux SSH远程配置及登录
cover: https://cos.asuka-xun.cc/blog/assets/linux-ssh-config.jpg
date: 2022/8/22 2:44
categories:
- [Linux]
tags:
- Linux
- Ubuntu
---
# SSH远程配置

## 什么是 SSH

**Secure Shell**（安全外壳协议，简称**SSH**）是一种加密的网络传输协议，可在不安全的网络中为网络服务提供安全的传输环境[[1\]](https://zh.m.wikipedia.org/zh-hans/Secure_Shell#cite_note-rfc4251-1)。SSH最常见的用途是远程登录系统，人们通常利用SSH来传输命令行界面和远程执行命令。看看定义：[Secure Shell - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.m.wikipedia.org/zh-hans/Secure_Shell)

我们通常使用 SSH 远程登录服务器。

一般为了安全起见，不建议在 SSH 连接中使用 root 用户登录，我们一般都是使用其他用户进行操作。

关于创建用户的操作可以看看我写的这篇博客[Linux 用户管理 - Linux ](https://blog.asuka-xun.cc/2022/08/21/Linux/linux-user-manager/)（私货）。

## 创建用户并赋予权限

注意：我这里输入的命令都是基于 Ubuntu 系统。

```shell
adduser master
```

设置 master 高权限，所以我们需要将这个用户添加到 `sudo` 组中。

输入以下命令：

```shell
visudo /etc/sudoers
```

[注意]{.label .danger} ： 不要使用其他编辑器去编辑这个文件，必须使用 `visudo` 这个命令代替。因为在这个文件中语法不当可能会导致系统崩溃。

赋予用户 master 权限。

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

保存完之后，可以切换到 master 用户测试一下。

## 允许用户使用 SSH 登录

以下示例用户名都为 master。

编辑 `/etc/ssh/sshd_config` 文件，配置只允许 `master` 用户使用SSH登录。

```shell
vim /etc/ssh/sshd_config
```

关键配置是 `AllowUsers`，该配置是配置允许通过ssh登录的用户，多个用户之间用空格间隔。使用后只允许配置中的用户通过ssh登录。

将 master 用户加入到允许列表中。

```
AllowUsers master
```

保存后记得重启 `sshd` 服务。

Ubuntu：

```shell
service sshd restart
```

CentOS 应该是 `systemctl restart sshd`。

重启`sshd`服务后，建议先在服务器上进行本地执行SSH命令测试，看使用该用户是否可登录成功。

```shell
ssh master@localhost
```

我们还可以在 `/etc/ssh/sshd_config ` 配置文件中添加一行配置：

```
PermitRootLogin no
```

禁用 root 用户的 SSH 登录。~~随便你禁不禁。~~

> 用户还可以通过配置`DenyUsers`、`AllowGroups`、`DenyGroups`来控制用户/用户组是否可以使用SSH登录。多个用户/用户组之间依然是使用空格间隔。
>
> `DenyUsers`配置禁止SSH登录的用户。
>
> `AllowGroups`配置允许SSH登录的用户组。
>
> `DenyGroups`配置禁止SSH登录的用户组。
>
> 它们的优先级从高到底依次是：`DenyUsers`、`AllowUsers`、`DenyGroups`、`AllowGroups`。

## 添加公钥认证

查看 root 用户是否已经有密钥对：

```shell
ls -l ~/.ssh/id_*.pub
```

结果类似这样说明没有密钥：

```shell
ls: cannot access '/home/master/.ssh/id_*.pub': No such file or directory
```

### 生成密钥对

如果还没有一个由公钥和私钥组成的 SSH 密钥对，那么我们需要生成一个。

这里利用你的邮箱作为注释生成一个 4096 位的 RSA 密钥：

```shell
ssh-keygen -t rsa -b 4096 -C "你的邮箱地址"
```

> `-t`选项指定加密算法，`-b`选项指定密钥位数。

根据提示生成密钥即可。不过有一步让你输密码，这一步如果你输入密码的话你每次使用 SSH 远程登录你的服务器都会让你输入密码。我直接输入回车跳过了。~~嫌麻烦~~

默认输出的路径是用户目录下的 `.ssh` 目录中。你可以看到你当前用户目录下生成了这个 `.ssh` 文件。公钥默认文件名为`id_rsa.pub`，私钥文件名为`id_rsa`。

> .ssh 目录对权限有要求，如果权限不对，则不会承认这个公钥。
> | 目录或文件                                                   | Man Page                                                     | 推荐权限 | 规定的权限 |
> | :----------------------------------------------------------- | :----------------------------------------------------------- | :------- | :--------: |
> | `~/.ssh/`                                                    | 没有一般的要求来保持这个目录的全部内容的秘密，但是推荐的权限是用户的读/写/执行权限，其他人无法访问。 | 700      |            |
> | `~/.ssh/authorized_keys`                                     | 此文件不是高度敏感的，但推荐的权限是用户的读/写权限，其他人无法访问 | 600      |            |
> | `~/.ssh/config`                                              | 由于存在滥用的可能性，此文件必须具有严格的权限: 用户的读/写权限，其他人不能访问。它可以是组可写的，前提是所讨论的组只包含用户。 |          |    600     |
> | `~/.ssh/identity` `~/.ssh/id_dsa` `~/.ssh/id_rsa`            | 由于存在滥用的可能性，此文件必须具有严格的权限: 用户的读/写权限，其他人不能访问。它可以是组可写的，前提是所讨论的组只包含用户。 |          |    600     |
> | `~/.ssh/identity.pub` `~/.ssh/id_dsa.pub` `~/.ssh/id_rsa.pub` | 包含用于身份验证的公钥。这些文件不敏感，任何人都可以(但不必)读取。 | 644      |            |

建议将公钥重命名为 `authorized_keys`。

如果在 `/etc/ssh/sshd_config` 文件中新增了这些内容：

```
AuthorizedKeysFile      .ssh/authorized_keys
```

`AuthorizedKeysFile` 指定公钥文件路径，此处指定 `.ssh/authorized_keys`，则在用户登录时，会在**对应用户的用户目录**中，查找 `.ssh/autorized_keys` 这个文件。我们必须将公钥重命名为 `authorized_keys`，不过其实好像我们不指定公钥文件路径的话默认也会去  `.ssh` 目录下找。反正建议是将公钥重命名为 `authorized_keys`。防止出错。

```shell
mv id_rsa.pub authorized_keys
```

> 认证文件可以存在多个公钥，也就是 authorized_keys 里面可以有多个公钥。实际上每个公钥就是一行字符串，只要不同公钥在不同行上即可。多个公钥就可以实现多个密钥登录同一个服务器。例如有公钥文件pub1和pub2，可以通过以下命令将它们加入到认证文件中：
>
> ```shell
> cat pub1 >> authorized_keys
> cat pub2 >> authorized_keys
> ```
>
> **注意必须使用`>>`，而不是`>`，前者是附加内容到文件后面，后者会覆盖文件原有内容。**
>
> 认证文件只要能够区分用户即可，不一定要放在相应用户的用户目录下，例如可以将sshd_config的配置修改为：
>
> ```
> AuthorizedKeysFile      /etc/ssh/authfiles/%u/authfile
> ```
>
> 其中`%u`会在发起登录时用登录的用户名替代。
>
> 这个方法挺不错，不同用户可以用不同的密钥登陆。

### 将私钥发送到本地

密钥生成成功了，我们需要利用 SCP 将私钥发送到我们本地电脑上。

```shell
scp -i C:\Users\username\.ssh\id_rsa -r master@ip:/home/master/.ssh /Users/username
```
> - `-i C:\Users\username\.ssh\id_rsa` 我这里是因为我远程服务器已经设置了使用密钥登录，所以才加 `-i` 选项，后面跟的是密钥存储的地方。
> - `-r` 递归复制整个目录，就是将 /.ssh 这个目录全复制到我们本地电脑。
> - `master@ip` 这里 `ip` 填你远程服务器的 ip 地址。master 就是你的用户名
> - `/home/master/.ssh` 你要下载的密钥地址。
> - `/Users/username` 本地存放地址。我这里的地址就相当于 Windows 的 C 盘的用户目录。

~~还有一个更简单的方法，那就是直接 `cat /home/master/.ssh/id_rsa` 直接看这个私钥内容然后复制在本地开个文件粘贴进去。不过需要注意啊，这个文件**不能有后缀**。~~{.danger}后面我自己这样尝试了，登不上。所以千万别这样（我明明记得我之前就是直接复制的）。你可以自己尝试一下。
写完过一天后的更新：好像找到答案了，似乎是因为使用 Windows 自带的记事本编辑这个文件，因为 Microsoft 开发记事本的团队保存UTF-8编码的文件时为每个文件开头添加了0xefbbbf（十六进制）的字符。
然鹅我用 vscode 也不能登录，还是不要复制吧...

**注意**：发送私钥时可能会遇到权限问题，这时你要看一下私钥的属主跟属组。

在 Linux 中我们可以使用 **ll** 或者 **ls –l** 命令来显示一个文件的属性以及文件所属的用户和组。

```shell
$ ls -l
total 4
-rw------- 1 ubuntu ubuntu 2095 Aug 21 23:56 authorized_keys
```

像这里第一个 ubuntu 就是它的属主，第二个是属组。因为我这个公钥是给 ubuntu 这个用户的，所以我就把属组跟属主都设置成了 ubuntu。

### 使用私钥登录

尝试用你本地电脑使用 SSH 远程连接你的服务器：

语法格式：

```shell
ssh -i <私钥路径> <username>@<hostname or IP address>
```

例：

```shell
ssh -i C:\Users\username\.ssh\id_rsa master@ip
```

如果能连上那是最好。

不能咋办🤔？看日志呗。debug 的方法放在后面。这里先接着成功的步骤走下去。

### 禁用 SSH 密码身份验证

这个步骤我们将禁用 SSH 密码身份验证，即不能使用密码登录，必须使用密钥登录。

 进入配置文件 `/etc/ssh/sshd_config` 中，在最新一行加入：

```
PasswordAuthentication no
```

保存退出并重启 sshd 服务：

```shell
service sshd restart
```

## 如何 debug 和看日志

如果我们 SSH 登录不上，我们一般会去看日志，日志位置在 `/var/log/auth.log` 或者 `/var/log/secure`。输入命令：

```shell
cat /var/log/auth.log
```

不过这是没开 debug，看不了多少信息。很难定位问题。

我们要在配置文件 `/etc/ssh/sshd_config` 中寻找 `LogLevel DEBUG3`，如果没有，则自己加。

```shell
vim /etc/ssh/sshd_config
```

在配置文件中加入这段代码开启 debug 功能
```
LogLevel DEBUG3
```

这样就算开启了 debug 功能。我们能从日志中看到更多信息。

## 错误总结

这里总结一下 SSH 可能遇到的问题。不过写的时候才发现好像好多都忘了。不过基本都是能从日志中找出来的。这里就随便写几个我还记得的。

### 登录时 Permission denied (publickey).

这个错误很常见啊，经常报这个错。看日志可能是以下这几个错

1. `Connection reset` 看日志可能会发现最后报错是以下这个。大括号里面是 ip ，这里我用 {ip} 代替了。

   ```
   Connection reset by authenticating user ubuntu {ip} port 57666 [preauth]
   ```

   在这行日志的上几行我们可以看到一些信息。

   - 公钥有问题。

     ```
     userauth_finish: failure partial=0 next methods="publickey" [preauth]
     ```

     > 这个错误我遇到是因为公钥有问题。我是公钥格式错误，也就是当我在直接复制私钥到本地的时候，用这个私钥登录服务器会报错。

2. `Connection closed` 详情同上。

   ```
   Connection closed by authenticating user root {ip} port 46710 [preauth]
   ```

   这行日志前几行可能会看到一些信息。

   - 服务器上的公钥位置不对

     ```
      Could not open authorized keys
     ```

   - 文件权限问题，访问私钥可能因为私钥的组或者属主是 root 等就会访问失败。

     这时我们就需要改我们的文件权限。

     > chgrp 更改文件属组
     > ```shell
     > chgrp [-R] 属组名 文件名
     > ```
     >
     > 参数选项
     >
     > - -R：递归更改文件属组，就是在更改某个目录文件的属组时，如果加上-R的参数，那么该目录下的所有文件的属组都会更改。
     >
     > chown：更改文件属主，也可以同时更改文件属组
     >
     > ```shell
     > chown [–R] 属主名 文件名
     > chown [-R] 属主名：属组名 文件名
     > ```
     

看日志很重要啊，我记不清我遇到的错了，不过每个人可能遇到的错都不同，解决方法也就不同，我这里只是随便列了几个而已，遇到错还需要自己看日志查资料。

参考文章及文档：

[Linux用户管理和SSH远程配置 (xiaog.info)](https://www.xiaog.info/blog/post/user_manager_and_ssh_config)

[Ubuntu Generate SSH key step by step (linuxhint.com)](https://linuxhint.com/generate-ssh-key-ubuntu/)

[云服务器 使用 SSH 登录 Linux 实例-操作指南-文档中心-腾讯云 (tencent.com)](https://cloud.tencent.com/document/product/213/35700)
