---
title: Docker学习
cover: https://cos.asuka-xun.cc/blog/assets/Docker.jpg
date: 2022/7/31 12:21
categories:
- [运维]
tags:
- 运维
- Docker
---
# Docker

## 什么是Doker

Docker 是一个开源的应用容器引擎，基于 [Go 语言](https://www.runoob.com/go/go-tutorial.html) 并遵从 Apache2.0 协议开源。
<!-- more -->

Docker 可以让开发者打包他们的应用以及依赖包到一个轻量级、可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。

容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）,更重要的是**容器性能开销极低**。

## Docker安装

### 设置仓库

1. 更新 apt 包索引并安装软件包

    ```bash
    sudo apt-get update
    sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    ```

2. 添加 Docker 的官方 GPG 密钥：

   ```bash
   sudo mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   ```

3. 使用以下命令设置存储库：

   ```bash
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

#### 安装 Docker 引擎

1. 更新包索引，并安装*最新版本*的 Docker 引擎、容器和 Docker Compose，或转到下一步以安装特定版本：

   ```bash
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
   ```

2. 要安装*特定版本的* Docker 引擎，需要在存储库中列出可用版本，然后选择并安装：

   一个。列出存储库中可用的版本：

```bash
apt-cache madison docker-ce

docker-ce | 5:20.10.16~3-0~ubuntu-jammy | https://download.docker.com/linux/ubuntu jammy/stable amd64 Packages
docker-ce | 5:20.10.15~3-0~ubuntu-jammy | https://download.docker.com/linux/ubuntu jammy/stable amd64 Packages
docker-ce | 5:20.10.14~3-0~ubuntu-jammy | https://download.docker.com/linux/ubuntu jammy/stable amd64 Packages
docker-ce | 5:20.10.13~3-0~ubuntu-jammy | https://download.docker.com/linux/ubuntu jammy/stable amd64 Packages
```

b.使用第二列中的版本字符串安装特定版本，例如 。`5:20.10.16~3-0~ubuntu-jammy`

```bash
sudo apt-get install docker-ce=<版本号> docker-ce-cli=<版本号> containerd.io docker-compose-plugin
```
3. 运行 `Docker`

```bash
sudo service docker start
```



3. 通过运行映像来验证 Docker 引擎是否已正确安装。`hello-world`

```bash
sudo docker run hello-world
```

输出结果会出现 hello world。



## 卸载 Docker 引擎

1. 卸载 Docker 引擎、CLI、Containerd 和 Docker Compose 包：

   ```bash
   sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin
   ```

2. 主机上的映像、容器、卷或自定义配置文件不会自动删除。删除所有映像、容器和卷：

   ```bash
   sudo rm -rf /var/lib/docker
   sudo rm -rf /var/lib/containerd
   ```

必须手动删除任何已编辑的配置文件。

## 使用镜像加速器

不使用镜像加速器可能会有点慢，我用的是阿里云的镜像加速器。

1. 找到容器镜像服务

![aliyun](https://cos.asuka-xun.cc/blog/aliyun.png)

2. 镜像加速器就有我们需要的加速器地址了，直接复制里面操作文档的代码就行了。![jiasuqi](https://cos.asuka-xun.cc/blog/20220727105742.png)

[官方镜像加速 (aliyun.com)](https://help.aliyun.com/document_detail/60750.html)

---

上面介绍Docker的安装，下面是Docker的操作。

## Docker常用命令

### 帮助启动类命令

- 启动 docker：`systemctl start docker`
- 停止 docker：`systemctl stop docker`
- 重启 docker：`systemctl restart docker`
- 查看 docker 状态：`systemctl status docker`
- 开机启动：`systemctl enable docker`
- 查看 docker 概要信息：`docker info`
- 查看 docker 总体帮助文档：`docker --help`
- 查看 docker 命令帮助文档：`docker xxx某某命令 --help`

其实就是 linux 服务的命令。

---

### 镜像命令

**列出本机上的镜像**

```bash
docker images

参数说明：
1. -a：列出本地所有的镜像（包含历史映像层）
2. -q：只显示镜像ID
```

![images](https://cos.asuka-xun.cc/blog/20220727112123.png)

选项说明：

- REPOSITORY：表示镜像的仓库源
- TAG：镜像的标签版本号
- IMAGE ID：镜像ID
- CREATED：镜像创建时间
- SIZE：镜像大小

需注意：同一仓库源可以有多个 TAG 版本，代表这个仓库源的不同个版本，我们使用`REPOSITORY:TAG`来定义不同的镜像。如果我们不指定一个镜像的版本标签，docker **默认使用最新版本镜像**。

**搜索镜像**

```bash
docker search 镜像名

参数说明：
1. --limit：只列出N个镜像，默认列出25个镜像
如：docker search --limit 5 mysql
```

**下载镜像**

```bash
docker pull 镜像名[:TAG]
```

`TAG`就是标签，可以不加，这样**默认下载最新版本镜像**。`TAG`可以指定版本下载镜像。

**查看镜像/容器/数据卷所占空间**

```bash
docker system df
```

**删除镜像**

```bash
docker rmi 镜像名/镜像ID

参数说明：
1. -f：强制删除
```
批量删除：

```bash
docker rmi 镜像名1:TAG 镜像名2:TAG
```

删除全部：

```bash
docker rmi -f $(docker images -qa)
```

`docker images -qa` 获取所有镜像ID。

**虚悬镜像：**仓库名、标签都是`<none>`的镜像，称作虚悬镜像 dangling image。

---

### 容器命令

有镜像才能创建容器。

**新建+启动容器**

需要运行镜像才能创建容器

```bash
docker run [OPTIONS] IMAGE
```

OPTIONS参数说明（常用）：

- --name="容器新名字"：为容器指定一个名称。
- -d：后台运行容器并返回容器ID。
- -i：以交互模式运行容器，通常与`-t`一起使用。interactive。
- -t：为容器重新分配是一个为输入终端，通常与`-i`同时使用。terminal。
- -P：随机端口映射，注意这是**大写P**。
- -p：指定一个端口映射，注意这是**小写P**。-p 8080:80，第一个物理机端口，第二个容器端口。

例如：

```bash
docker run -it --name=myubuntu01 ubuntu /bin/bash

-it  交互终端
--name  起别名
/bin/bash  shell交互命令
```

![ubuntu](https://cos.asuka-xun.cc/blog/20220727115859.png)

此时我们进入到 docker 的 ubuntu 中了。`exit`退出。此时输入的命令是在 docker 的 ubuntu 中执行。

**查看正在运行的容器**

```bash
docker ps
参数:
-a      查看正在运行的容器和历史运行过的容器
-q      静默模式,只显示容器编号
```

**退出容器**

```bash
exit
run 进去容器，exit 退出，容器停止
```

ctrl+p+q （快捷键）run 进去容器，ctrl+p+q 退出，容器不停止。

**启动 | 重启 | 停止容器**

```bash
docker start 容器名或id    -------开启容器
docker restart 容器名或id  -------重启容器
docker stop 容器名或id     -------正常停止容器
docker kill 容器名或id     -------立即停止容器
```

**删除容器**

如果容器没有停止，则不能删除，除非使用强制删除。

```bash
docker rm 容器名或id
参数:
-f            强制删除正在运行的容器
```

**进入容器**

```bash
docker exec -it 容器名或id bash
exit            退出容器（不会导致容器停止）
```

```bash
docker attach 容器名或id
exit            退出容器（会导致容器停止） 
```

**查看容器内服务日志**

```bash
docker logs 容器ID
参数:
-f              实时输出日志
-t              加入时间戳
--tail n        显示日志最后n行
```

**查看容器内的进程**

```bash
docker top 容器名或ID
```

**查看容器内部细节**

```bash
docker inspect 容器ID
```

**主机与容器进行文件传输**

```bash
docker cp 主机文件 容器名(或id):容器路径  -------将主机文件复制到容器内部
docker cp 容器名(或id):容器文件 主机路径  -------将容器文件复制到主机内部
```

**导出 | 导入容器**

```bash
docker export 容器ID > 文件名.tar

例：
docker export 8053b126ca55 > redis.tar
```

```bash
cat 文件名.tar | docker import-镜像用户/镜像名:镜像版本号

例：
cat redis.tar | docker import - xun/redis:1.0

root@VM-4-12-ubuntu:/# docker images
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
xun/redis     1.0       a4dd13439b9c   5 seconds ago   113MB
```

**将容器打包成镜像**

```bash
docker commit -m "描述信息" -a "作者" 容器名或id 镜像名:标签
```

**将镜像保存成一个.tar 文件**

```bash
docker save 镜像名称:标签 -o 文件名
```

前台交互式启动：

```bash
docker run -it redis
```

Ubuntu这些就需要前台交互式启动。

后台守护式启动：

像 Redis、MySQL这些我们只需要让它们在后台运行就行了。

```bash
docker run -d redis
```

后台守护启动查看日志：

```bash
docker logs 容器ID
```

## 数据卷

数据卷：将docker容器内的数据保存进宿主机的磁盘中，将数据持久化保存， 也实现数据共享。

特点：

1. 数据卷可在容器之间共享或重用数据
2. 卷中的更改可以直接**实时生效**
3. 数据卷中的更改不会包含在镜像的更新中
4. 数据卷中的生命周期一直持续到没有容器使用为止

### 数据卷命令

**创建数据卷**

```bash
docker volume create 卷名
```

**查看所有数据卷**

```bash
docker volume ls
```

**查看某个数据卷的细节**

```bash
docker volume inspect 卷名
```

**删除数据卷**

```bash
docker volume prune    ------自动删除所有未使用的数据卷
docker volume rm 卷名   ------删除指定数据卷
```

**把数据卷挂载到容器中**

```bash
docker run -it --privileged=true -v /宿主机绝对路径目录:/容器内目录 镜像名

例：
docker run -it --privileged=true -v /tmp/host_data:/tmp/docker_data --name=u1 ubuntu

将主机的/tmp/host_data映射到容器的/tmp/docker_data
此时如果在docker_data里新增文件，则主机host_data下也会新增文件，同理在主机下新增，容器内文件也会新增
```

可以使用`docker inspect`查看该容器挂载到哪些目录

![guazai](https://cos.asuka-xun.cc/blog/20220727144337.png)

以上默认该文件可读可写。

我们可能有时候需要设置可读：
```bash
docker run -it --privileged=true -v /宿主机绝对路径目录:/容器内目录:ro 镜像名
:ro表示只读

例：
docker run -it --privileged=true -v /tmp/host_data:/tmp/docker_data:ro --name=u1 ubuntu
```

这里的可读是指：主机可以写入数据到容器，而容器不能写入到主机，容器不能影响主机。通常用于同步数据

### 卷的继承和共享

```bash
docker run -it --privileged=true --volimes-from u1 --name u2 ubuntu

u2继承自u1的数据卷
```

需注意的是，此时如果 u1 容器停止不会影响到 u2 容器。但是如果 u1 容器再次启动，此时 u2 更改的数据卷会共享给 u1 容器。

## 常用服务的安装

服务安装总体步骤：

1. 搜索镜像
2. 拉取镜像
3. 查看镜像
4. 启动镜像 ===》服务端口映射
5. 停止容器
6. 移除容器

### MySQL

```bash
docker pull mysql

docker run -d -p 3307:3306 --privileged=true 
-v $PWD/conf:/etc/mysql/conf.d 
-v $PWD/logs:/logs 
-v $PWD/data:/var/lib/mysql 
-e MYSQL_ROOT_PASSWORD=123456
--name mysql
mysql:latest
 
 
#参数说明
-d: 后台运行容器，并返回容器ID
-p 3307:3306：将容器的 3306 端口映射到主机的 3307 端口(第一个物理机端口，第二个容器端口)。
-v $PWD/conf:/etc/mysql/conf.d：将主机当前目录下的 conf/my.cnf 挂载到容器的 /etc/mysql/my.cnf。
-v $PWD/logs:/logs：将主机当前目录下的 logs 目录挂载到容器的 /logs。
-v $PWD/data:/var/lib/mysql ：将主机当前目录下的data目录挂载到容器的 /var/lib/mysql 。
-e MYSQL_ROOT_PASSWORD=123456：初始化 root 用户的密码。

注意：我这里这样写是为了看得清楚这段命令。
```

进入容器：

```bash
docker exec -it mysql bash
```

登录 MySQL：

```bash
mysql -u root -p
输入密码123456
```

MySQL 好像 8 版本之后都会默认允许外网访问。user 表中的 root用户有两个， 一个是支持 localhost 访问，一个是 % 的数据，表示外部所有IP都可访问。

### Redis

docker 安装的 redis 默认没有配置文件，需要我们自己准备，我是去下载 redis 官网的压缩包自己复制了一份。

```bash
mkdir conf
cd conf
vim redis.conf
 
# 开放外网访问
protected-mode no
# 设置密码之后验证才能zheng'z
requirepass sast_forever

sast forever
```

```bash
docker pull redis
 
docker run -p 6379:6379 --name test-redis -v $PWD/conf/redis.conf:/etc/redis/redis.conf -v $PWD/data:/redis/data -d redis redis-server /etc/redis/redis.conf
 
#参数说明
-p 6379:6379：将容器的 6379 端口映射到主机的 6379 端口(第一个物理机端口，第二个容器端口)。
-v $PWD/conf/redis.conf:/etc/redis/redis.conf：映射配置文件。
-v $PWD/data:/redis/data：映射数据文件。
-d: 后台运行容器，并返回容器ID
redis-server /etc/redis/redis.conf：使用指定的配置文件启动redis
```

## 搭建Redis集群

这个是我搭的例子：

开了六个 Redis 容器：

```bash
sudo docker run -d --name redis-node-1 --net host -v $PWD/conf/redis.conf:/etc/redis/redis.conf -v $PWD/data/share/redis-node-1:/redis/data redis --cluster-enabled yes --appendonly yes --port 6381

sudo docker run -d --name redis-node-2 --net host -v $PWD/conf/redis.conf:/etc/redis/redis.conf -v $PWD/data/share/redis-node-2:/redis/data redis --cluster-enabled yes --appendonly yes --port 6382

sudo docker run -d --name redis-node-3 --net host -v $PWD/conf/redis.conf:/etc/redis/redis.conf -v $PWD/data/share/redis-node-3:/redis/data redis --cluster-enabled yes --appendonly yes --port 6383

sudo docker run -d --name redis-node-4 --net host -v $PWD/conf/redis.conf:/etc/redis/redis.conf -v $PWD/data/share/redis-node-4:/redis/data redis --cluster-enabled yes --appendonly yes --port 6384

sudo docker run -d --name redis-node-5 --net host -v $PWD/conf/redis.conf:/etc/redis/redis.conf -v $PWD/data/share/redis-node-5:/redis/data redis --cluster-enabled yes --appendonly yes --port 6385

sudo docker run -d --name redis-node-6 --net host -v $PWD/conf/redis.conf:/etc/redis/redis.conf -v $PWD/data/share/redis-node-6:/redis/data redis --cluster-enabled yes --appendonly yes --port 6386
```

![搭建的redis集群命令](https://cos.asuka-xun.cc/blog/20220731175310.png)

进入其中一个容器输入以下命令：

```bash
redis-cli --cluster create 你的真实ip:端口号 你的真实ip:端口号  你的真实ip:端口号 你的真实ip:端口号 你的真实ip:端口号 你的真实ip:端口号 --cluster-replicas 1
```

真实ip 可在虚拟机输入 `ifconfig` 查看。

进入 redis 

```bash
redis-cli -p 6385 -c

# 参数
-c         				防止路由失效
--cluster check      	 查看集群信息 例：redis-cli --cluster check 你的真实ip:端口号
```

查看集群节点信息，从这里可以知道节点的主从关系。

```bash
cluster nodes
```

## Dockerfile

**Dockerfile**是用来构建 Docker 镜像的文本文件，是由一条条构建镜像所需的指令和参数构成的脚本。

**Dockerfile 执行大致流程**

![Dockerfile](https://cos.asuka-xun.cc/blog/20220728131726.png)

| 保留字                 | 作用                                                         |
| ---------------------- | ------------------------------------------------------------ |
| FROM                   | 当前镜像是基于哪个镜像 第一个指令必须事 FROM                 |
| MAINTAINER(deprecated) | 镜像维护者的姓名和邮箱地址                                   |
| RUN                    | 构建镜像时需要运行的指令                                     |
| EXPOSE                 | 当前容器对外暴露出的端口号                                   |
| WORKDIR                | 指定在创建容器后，终端默认登录进来的工作目录，一个落脚点     |
| ENV                    | 用来在构建镜像的过程中设置环境变量                           |
| ADD                    | 将主机目录下的文件拷贝进镜像且 ADD 命令会自动处理 URL 和解压 tar 包 |
| COPY                   | 类似于 ADD，拷贝文件和目录到镜像中 将从结构上下文目录中 <原路径> 的文件 / 目录复制到新的一层的镜像的 < 目标路径 > 位置 |
| VOLUME                 | 容器数据卷，用于数据保存和持久化工作                         |
| CMD                    | 指定一个容器启动时要运行的命令 Dockerfile 中可以有多个 CMD 指令，但只有最后一个生效，CMD 会被 docker run 命令行参数中指定的程序替换 |
| ENTRYPOINT             | 指定一个容器启动时要运行的命令 ENTRYPOINT 的目的和 CMD 一样，都是在指定容器启动程序及其参数 |

### FROM

- 当前镜像基于哪个镜像，指定一个已经存在的镜像作为模板
- 第一条必须是 FROM

```bash
  FROM <image>
  FROM <image>[:<tag>]
```

### MAINTAINER

- 镜像维护者的姓名和邮箱地址

### RUN

- 容器构建时需要运行的命令
- 在 docker build 时运行

```bash
  # shell 命令
  RUN <命令行命令>
  # exec 命令
  RUN ["可执行文件","参数1","参数2",...]

  例：
  RUN ["./test.php", "dev", "offline"] ===> RUN 。/test.php dev offline
```

### EXPOSE

- 用来指定构建的镜像在运行为容器时对外暴露的端口

```bash
  EXPOSE <port>[/tcp|/udp]
  EXPOSE 80/tcp    如果没有显示指定，则默认为tcp
  EXPOSE 80/udp
```

### WORKDIR

- 指定在创建容器后，终端默认登录的工作目录，落脚点

```bash
  WORKDIR <dir>
  WORKDIR /data       绝对路径/data
  WORKDIR aa          相对路径，/data下的aa，即/data/aa
```

### USER

- 指定该镜像以什么样的用户去执行
- 默认 root

### ENV

- 用来在构建镜像过程中设置环境变量
- 该环境变量可以在后续的任何 RUN 指令中使用

```bash
ENV <key> <value>

例：
ENV MY_PATH /usr/mytest
这个环境变量可以在后续中的任何RUN指令中使用，就像指定了环境变量前缀

WORKDIR $MY_PATH
也就是说，在我们 RUN 这个镜像的时候会跳转到 MY_PATH 这个目录
```

### VOLUME

- 容器数据卷，用于数据保存和持久化工作

```bash
  VOLUME /data
```

### ADD

- 将宿主机目录下的文件拷贝进镜像且会自动处理 URL 和解压 tar 压缩包

```bash
  ADD <src> <dir>
  ADD url /dir
  ADD test.tar /dir
```

### COPY

- 类似 ADD， 拷贝文件和目录到镜像中
- 路径不存在将会自动创建

```bash
  COPY <src> <dir>
  COPY hom* /mydir/        通配符
  COPY hom?.text /mydir/     通配符添加多个文件
  COPY home.text relativeDir/   可以指定相对路径
  COPY home.text /absoluteDir/  可以指定绝对路径
```

### CMD

- 在 docker run 时运行
- 指定容器启动后需要干的事情
- 语法与 RUN 相似，也是两种格式
- Dockerfile 可以有多条 CMD 指令，但是只有最后一条生效（是最后一条命令覆盖前面的命令）
- CMD 指令会被 docker run 之后的参数替换

```bash
 # shell
 CMD <命令行命令>
 # exec
 CMD ["可执行文件","参数1","参数2",...]
 # 参数格式列表
 CMD ["参数1","参数2",...] 该写法是为 ENTRYPOINT 指令指定的程序提供默认参数；
```

举个栗子说明覆盖操作：

```bash
这是 tomcat 的 dockerfile 的 CMD指令
CMD ["catalina.sh", "run"]

如果在启动 tomcat 时用以下命令
docker run -it -p 8080:8080 tomcat容器ID /bin/bash

那么dockerfile里的 CMD 指令将会被覆盖
CMD ["/bin/bash", "run"]
```

### ENTRYPOINT

- 与 CMD 类似
- 在 docker run 时运行
- 不会被 docker run 的命令行参数指定的指令覆盖，这些命令行参数会被当做参数送给 ENTRYPOINT 指令指定的程序。叠加命令。
- 可以和 CMD 一起用，一般是变参才会使用 CMD ，相当于给 ENTRYPOINT 传参

```bash
  ENTRYPOINT <命令行命令>
  ENTRYPOINT ["可执行文件","参数1","参数2",...]
```

### Docker build 命令

#### 语法

```bash
docker build [OPTIONS] PATH | URL | -
```

OPTIONS说明：

- **--build-arg=[] :** 设置镜像创建时的变量；
- **--cpu-shares :** 设置 cpu 使用权重；
- **--cpu-period :** 限制 CPU CFS周期；
- **--cpu-quota :** 限制 CPU CFS配额；
- **--cpuset-cpus :** 指定使用的CPU id；
- **--cpuset-mems :** 指定使用的内存 id；
- **--disable-content-trust :** 忽略校验，默认开启；
- **-f :** 指定要使用的Dockerfile路径；
- **--force-rm :** 设置镜像过程中删除中间容器；
- **--isolation :** 使用容器隔离技术；
- **--label=[] :** 设置镜像使用的元数据；
- **-m :** 设置内存最大值；
- **--memory-swap :** 设置Swap的最大值为内存+swap，"-1"表示不限swap；
- **--no-cache :** 创建镜像的过程不使用缓存；
- **--pull :** 尝试去更新镜像的新版本；
- **--quiet, -q :** 安静模式，成功后只输出镜像 ID；
- **--rm :** 设置镜像成功后删除中间容器；
- **--shm-size :** 设置/dev/shm的大小，默认值是64M；
- **--ulimit :** Ulimit配置。
- **--squash :** 将 Dockerfile 中所有的操作压缩为一层。
- **--tag, -t:** 镜像的名字及标签，通常 name:tag 或者 name 格式；可以在一次构建中为一个镜像设置多个标签。
- **--network:** 默认 default。在构建期间设置RUN指令的网络模式



### **举个栗子**

编写Dockerfile

```bash
# 基础镜像使用Java
FROM openjdk:11
# 作者
MAINTAINER xun
# VOLUME 指定临时文件目录为/tmp，在主机/var/lib/docker目录下创建了一个临时文件并链接到容器的/tmp
VOLUME /tmp
# 将jar包添加到容器中并更名为 kakaBot_docker.jar
ADD kakaBot-1.0.0-RELEASE.jar kakabot_docker.jar
# 运行jar包
RUN bash -c 'touch /kakabot_docker.jar'
# 相当于 java -jar /kakabot_docker.jar
ENTRYPOINT ["java","-jar","/kakabot_docker.jar"]
# 暴露端口,看你项目暴露的端口是什么,springboot 默认是8081的嘛
EXPOSE 8888
```

使用 `docker build` 创建镜像

```bash
# 注意 -t 等价于 --tag，并且可以看见后面有个小数点
docker build -t kakabot_docker:1.0.0 .
```

使用 `docker images` 查看镜像

运行容器

```bash
docker run -d -p 8888:8888 镜像id
```

使用`docker ps` 查看容器是否运行成功。

## Compose

### Compose安装

```bash
sudo apt-get update
sudo apt-get install docker-compose-plugin
# 可以自己选版本
sudo apt-get install docker-compose-plugin=<VERSION_STRING>
```

测试是否安装成功

```bash
docker compose version
```



### Compose常用命令

#### 1、docker-compose up

示例：

```bash
#启动所有服务
docker-compose up
#在后台所有启动服务
docker-compose up -d
#-f 指定使用的 Compose 模板文件，默认为 docker-compose.yml，可以多次指定。
docker-compose -f docker-compose.yml up -d
```

#### 2、docker-compose ps

```bash
示例：
#列出项目中目前的所有容器
docker-compose ps
```

#### 3、docker-compose -h

```bash
#查看帮助
docker-compose -h
```

#### 4、docker-compose down

```bash
#停止和删除容器、网络、卷、镜像。
docker-compose down [options]
选项包括：
–rmi type 删除镜像，类型必须是：all，删除 compose 文件中定义的所有镜像；local，
删除镜像名为空的镜像
-v, –volumes 删除已经在 compose 文件中定义的和匿名的附在容器上的数据卷
–remove-orphans 删除服务中没有在 compose 中定义的容器
示例：
#停用移除所有容器以及网络相关
docker-compose down
```

#### 5、docker-compose pull

```bash
#拉取服务依赖的镜像
docker-compose pull [options] [SERVICE...]
选项包括：
–ignore-pull-failures 忽略拉取镜像过程中的错误
–parallel 多个镜像同时拉取
–quiet 拉取镜像过程中不打印进度信息
```

#### 6、docker-compose start

```bash
#启动已经存在的服务容器
docker-compose start
```

#### 7、docker-compose restart

```bash
#重启项目中的服务
docker-compose restart [options] [SERVICE...]
选项包括：
-t, –timeout TIMEOUT 指定重启前停止容器的超时（默认为 10 秒）
11、docker-compose rm
#删除所有（停止状态的）服务容器，推荐先执行 docker-compose stop 命令来停止容器
docker-compose rm [options] [SERVICE...]
```

选项包括：
–f, –force，强制直接删除，包括非停止状态的容器
-v，删除容器所挂载的数据卷

#### 8、docker-compose stop

选项包括：
-t, –timeout TIMEOUT 停止容器时候的超时（默认为 10 秒）
示例

```bash
#停止正在运行的容器，可以通过 docker-compose start 再次启动
docker-compose stop
```

#### 9、docker-compose scale

```bash
#设置指定服务运行的容器个数，通过 service=num 的参数来设置数量
docker-compose scale web=3 db=2
```

#### 10、dokcer-compose config

```bash
#验证并查看 compose 文件配置
docker-compose config [options]
```

选项包括：
–resolve-image-digests 将镜像标签标记为摘要
-q, –quiet 只验证配置，不输出。 当配置正确时，不输出任何内容，当文件配置错误，
输出错误信息
–services 打印服务名，一行一个
–volumes 打印数据卷名，一行一个

### docker-compose.yaml配置解释

```yaml
version: "3.7"
services:
 
  example:                     #服务名称
    image: tomcat:8.0-jre8     #使用的镜像
    container_name: example_container_name    #容器启动时的名字
    ports:                     #容器端口映射，前面的是宿主机端口，后面是容器内端口
      - "8080:8080"
    volumes:                   #容器中的哪个路径和宿主中的路径进行数据卷映射
      - /root/apps:/usr/local/tomcat/webapps     #手动映射
      - tomcatwebapps:/usr/local/tomcat/webapps  #自动创建数据卷映射，需要在后面声明数据卷
    networks:                  #指定容器启动使用的网桥
      - aa
    command: xxxxx             #用于覆盖容器默认启动指令
    envoriment:                #指定容器启动时的环境参数
      - xxxxx=xxxx
      
    #env_file:                 使用环境变量文件，书写格式和环境参数相同
    #  - ./xxx.env
    
    depends_on:                #设置这个服务依赖的服务名称（即启动优先级）
      #可以关联其他的服务
      - xxxxx
      
    #sysctls:                  #修改容器内部参数
    #  - xxxx=xxxx
    
volumes:
   tomcatwebapps:
   #external:       默认卷名会带上项目名(yml文件所在文件夹名)，
   #  true          可以声明使用外部以存在的卷
   
networks:
   aa:                #创建逻辑同volume，将不同服务关联到一个网桥
```
