---
title: 首次搭建博客遇到的问题（不建议观看）
date: 2022/3/13 22:30:06
categories:
- [旧时期产物]
tags:
- 博客
---
1. 连接数据库错误。
   解决方法：这个错误我是去wordpress配置文件将用户名，密码，数据库一些信息改正。

2. 该站点出现致命错误（白屏）
   这个问题目前还不知道解决方法。

3. 当前无法使用该页面HTTP　ERROR 500
   这个错误是当时看的教程有问题，它改了Apache服务的配置，导致出现这个错误。~~不能乱看教程啊~~

4. 进行wordpress初始化的时候显示Apache服务器的欢迎页。
   解决方法：
   在终端输入命令进入到以下目录
   `cd /etc/httpd/conf.d`
   然后查看当前文件夹下的内容
   `ls`
   用vim编辑器打开首页配置文件 welcome.conf
   `vim welcome.conf`
   只要将这里面的内容注释掉即可。
   `
    <LocationMatch "^/+$">
   
    Options -Indexes
   
    ErrorDocument 403 /error/noindex.html
   
   </LocationMatch>
   `
   
   注释这几句代码就解决问题了，其他代码我并没有动它。
   然后重启Apache服务就好了

5. 关于wp最大文件设置
   这个问题我找解决方法试了好几个方法才解决的。方法如下：
   创建或修改".user.ini"文件
   如果找不到这个文件就新建一个，将如下代码添加到这个文件中：
   `    upload_max_filesize = 32M 
    post_max_size = 64M 
    memory_limit = 128M
   `
   新建的地方在网页的根目录即在WordPress根目录。
   
   以上三个代码控制wp上传文件大小。
   `memory_limit=128M　　//相当于单个脚本可调用内存大小
   post_max_size=8M　　//上传文件大小上限(此参数应>=upload_max_filesize) 
   upload_max_filesize=2M　　 //默认上传文件大小，这个就是2M的限制
   max_execution_time=30　　//最大执行时间，页面等待时间
   max_input_time=60　　　　//接收数据最大时间限制
   `
   
   我在这里说一下我在网上找的方法中最多人说解决方法：
   
   - 在服务器上找到php文件的位置
     在etc/php.ini
   - 将各项数值调大点，这里的各项数值就是我上面说的那几个代码。
     `
     upload_max_filesize = 2M        可以调成20M
     post_max_size = 8M                 可以调成20M
     memory_limit 128M
     max_execution_time 30
     max_input_time 30`
     找到那个文件后就能看见这些管控参数的代码。
     `
     upload_max_filesize: 最大上传尺寸
     post_max_size: POST 请求最大尺寸
     memory_limit: PHP 进程可以使用的内存限制
     max_execution_time：PHP 程序的最大执行时间
     max_input_time：最大输入时间`
   
   注意：我说这个方法是因为我按这个方法并没有改变上传文件的大小，后来我去查了查，说是如果服务器托管服务提供商已锁定了全局PHP设置，则他们可能已将服务器配置为使用.user.ini文件而不是php.ini文件

6. 很好，当我写完这篇博客的上传的时候它又出问题了，我发现它不能查看，出现Not Found的页面，于是我又去找解决方法。
   解决方法：
   
   - 首先我找到第一个方法：修改链接，因为我链接里有中文，所以可能会出问题，于是我改成了用id命名的链接，这时还是进不去网页，然后我开始去寻找其他方法。
   
   - 第二种方法：查看APACHE文件中的httpd.conf文件是否默认设置了AllowOverRide为None，如果是，要改成All。这里的AllowOverRide是一下这部分
     `
     <Directory "/var/www/html">
       Options Indexes FollowSymLinks
        AllowOverride All
     Require all granted
     
     </Directory>
     `
     只需改这部分就行了。然后此时出现的情况还是无法进入文章，出现file not found。
   
   - 出现目录不存在的时候我就再次尝试把链接给改了，这次我改成wp自带的朴素就好了。

在搭建过程中出现了挺多问题的，但是很多都不知道如何解决，只能重新开始教程。
搭建博客中最主要的步骤还是安装LAMP环境。
得知道如何卸载LAMP环境。

# 卸载LAMP环境

- 卸载Mysql
  执行命令
  `rpm -qa|grep mysql`
  会出现MySQL的软件包，这个命令也是为了把MySQL相关的包列出来。卸载的时候从最后一个包开始卸载，卸载使用的命令为：
  `rpm -e`
  我卸载的时候是直接把包名称加版本号一整个卸载的，但是我看的教程好像说不用也行。

- 卸载Apache
  与卸载MySQL一样，首先使用命令
  `rpm -qa|grep httpd`
  Apache在Linux里面是叫httpd的。
  执行命令后一样会出现很多包名，与卸载MySQL一样，这里不再赘述。

- 卸载PHP
  执行命令
  `rpm -qa|grep php`
  会出现包名
  卸载方法跟前面一致。
  这里需要注意的是：
  **卸载的时候可能会出现卸载不掉的情况，Centos会提示包的依赖关系，需要先卸载提示依赖的包。**
  提示的错误信息是这样的：
  <    
  
  # rpm -e php-pdo-5.1.6-27.el5_5.3
  
    error: Failed dependencies:
  
    php-pdo is needed by (installed) php-mysql-5.1.6-27.el5_5.3.i386
  
  > 
  
  **如果实在实在有卸载不掉的包，可以加 -nodeps这个参数来卸载。**
  `rpm -e 包名 -nodeps`
  这个命令是不检查依赖关系强制删除，可能会删不干净，不过不知道我们可不可以直接用这个命令一个一个删除软件包，直到把包删完。
