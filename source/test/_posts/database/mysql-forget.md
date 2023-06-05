---
title: MySQL忘记密码解决办法
date: 2022/3/20 22:27
categories:
- [数据库]
tags:
- MySQL
---
距离上次使用MySQL已经过了一段时间，因为不经常使用，所以把密码给忘了。我就得去找如何在不登陆MySQL的情况下重置密码。首先去看的官方文档，重置密码的官方文档：https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html
给了三种方法，我觉得第一种方法太复杂了于是就去用第三种方法，但是使用第三种方法的命令行后并不起效果，命令如下：
`mysqld –skip-grant-tables`
于是去找原因，据说是MySQL8.0版本后该命令行失效了，给出了一下这个命令行：
`mysqld --console --skip-grant-tables --shared-memory`
<!-- more -->
于是我使用这个命令行，结果它给我报一堆错。
看报错的内容一个是缺少data文件夹，还有两个报错都是由于无法创建一个叫mysqld_tmp_file_case_insensitive_test.lower-test的文件，这给我整懵了。它不能创建data文件夹我们去创。找到mysql的安装目录C:\Program Files\MySQL\MySQL Server 8.0创建一个data文件夹。
其他两个错呢我看着其他人的解决方法是打开MySQL安装目录（bin文件夹里）运行这段代码`./mysqld --initialize --lower-case-table-names=1`说是没报错就成功了，我果然是我，没报错但是也没起什么效果。
后面我尝试使用`mysqld --console --skip-grant-tables --shared-memory`这段命令行的时候依旧是会报错，具体报错内容我没截图，反正是data文件夹有问题，然后又去找解决办法，据说是MySQL的bug（我可不知道是不是）。
这里是我苦痛的经历。

------------

以下是正确步骤

我不自己创建data文件夹而是改用命令行
`mysqld  --initialize-insecure`
然后这里才成了。
接下来的一切都那么顺利，停止mysql的服务，使用命令行
`mysqld --console --skip-grant-tables --shared-memory`
使用完这个命令行后这个窗口会卡住就说明成了。
然后就可以直接登录mysql了，登录进去把密码给改咯
`mysql`直接登录MySQL
`FLUSH PRIVILEGES;`刷新权限
`ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';` 更改密码（这里密码是MyNewPass）
`exit`退出MySQL
现在应该能够使用新密码连接到MySQL服务器。停止服务器并正常重新启动它。
记得将新密码存好。
