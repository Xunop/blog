---
title: 使用 GitHub Actions 自动化部署你的项目
cover: https://cos.asuka-xun.cc/blog/assets/github-actions-deployment.jpg
date: 2022/8/23 18:02
categories:
- [运维]
tags:
- Github Actions
- 自动化部署
---
# 使用 GitHub Actions 自动化部署你的项目

## 前言

最近写完了一个项目的后端部分，所以要部署到服务器上给前端调用接口，然后又因为前端调用接口的时候时不时出现一些问题就需要改代码，每次改完代码又需要重新部署项目到服务器，属实麻烦，于是我们的诺天大佬就利用 GitHub Actions 实现自动化部署。我也趁这个机会学习了一波把这个东西用到自己的项目上。
<!-- more -->

不过这东西还真是香啊，被微软收购的 Github 真是财大气粗。

## 组成

GitHub Actions 由四个部分组成：

- **workflow** （工作流程）：持续集成一次运行的过程，就是一个 workflow。
- **job** （任务）：一个 workflow 由一个或多个 jobs 构成，含义是一次持续集成的运行，可以完成多个任务。
- **step**（步骤）：每个 job 由多个 step 构成，一步步完成。
- **action** （动作）：每个 step 可以依次执行一个或多个命令（action）。

我觉得官方文档说这些东西说得绝对比我好：[了解 GitHub Actions - GitHub Docs](https://docs.github.com/cn/actions/learn-github-actions/understanding-github-actions)。所以我这里不在赘述。~~懒得写。~~

我这里还是主要说一下利用 Github Actions 实现自动化部署我的一个 SpringBoot Docker 项目到我的服务器上。多靠了[诺天](https://nuotian.furry.pro/)的帮助❤️（福瑞噢）。

## 编写 `workflow` 文件 

### 用 Maven 打包Java项目

在我们需要实现自动化部署的项目仓库找到 Actions 然后创建一个 workflow 文件。

![image-20220823153838564](https://cos.asuka-xun.cc/blog/image-20220823153838564.png)

我们点进去会发现有很多现成的轮子，我们可以从里面拿几个来用：

```yaml
# 命名
name: Java CI with Maven

# 触发器
on:
# 触发事件
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
	# 将作业配置为在最新版本的 Ubuntu Linux 运行器上运行。
    runs-on: ubuntu-latest

    steps:
    # 运行 actions/checkout 操作的 v3
    - uses: actions/checkout@v3
    - name: Set up JDK 11
      uses: actions/setup-java@v3
      with:
      	# 选择 Java 版本
        java-version: '11'
        distribution: 'temurin'
        # 缓存 maven 依赖项
        cache: 'maven'
    - name: Build with Maven
      # 运行命令
      run: mvn -B package --file pom.xml
```

> 关于缓存 maven 依赖项，我发现 Github Actions 主页的 Java with Maven 中的 `cache: maven` 是没有单引号的，这样好像缓存不了依赖项。我看官方文档给的示例上是有单引号。[actions/setup-java: Set up your GitHub Actions workflow with a specific version of Java](https://github.com/actions/setup-java#caching-packages-dependencies)

以上命令就是使用 `Maven` 打包你的 Java 项目。触发器在官方文档有更详细的解释：[触发工作流程 - GitHub Docs](https://docs.github.com/cn/actions/using-workflows/triggering-a-workflow)。

### 上传 jar 包到服务器

我们的项目是在我们服务器上运行的话，那就需要远程连接我们的服务器将打包好的 `jar` 包上传到我们服务器上面。

我使用的是这个仓库：[easingthemes/ssh-deploy: GitHub Action for deploying code via rsync over ssh. (with NodeJS)](https://github.com/easingthemes/ssh-deploy)

```yaml
      - name: Upload to server
        uses: easingthemes/ssh-deploy@v2.2.11
        env:
          ARGS: '-avz --delete'
          SOURCE: 'target/example.jar'
          TARGET: '/home/username/example'
          REMOTE_HOST: ${{ secrets.SERVER_HOST }}
          REMOTE_USER: username
          SSH_PRIVATE_KEY: ${{ secrets.SERVER_ACCESS_KEY }}
```

关于环境变量 `env` 在仓库中的 `README` 文件也说得很清楚了。 `ARGS` 参数，我们这里使用 `-avzr --delete` 参数，这个是 `rsync` 需要的参数（`rsync` 用来同步文件的，我们这里传 `jar` 包） 。`SOURCE` 就是我们的 `jar` 包位置，`TARGET` 是 `jar` 包存放到我们服务器里的位置，`REMOTE_HOST` 则是我们服务器的 ip，`REMOTE_USER` 我们登录服务器需要的用户名，`SSH_PRIVATE_KEY` 登录所需的私钥。私钥创建看我之前的文章（小声bb）[Linux SSH远程配置及登录 - Linux | xun = 不失去热情 = 碎碎念 (asuka-xun.cc)](https://blog.asuka-xun.cc/2022/08/21/Linux/linux-ssh-config/)，你看我链接都摆这了🥺。

这里的 `secrets.SERVER_ACCESS_KEY` 跟 `secrets.SERVER_HOST` 及后面的这些东西是需要我们在仓库中点击**Settings** > **Secrets** > **Actions** > **New repository secret**。如下图：

![image-20220823175349566](https://cos.asuka-xun.cc/blog/image-20220823175349566.png)

### 重启 docker 容器

可能有点疑惑为什么直接就到重启 docker 容器了，我当时也是疑惑不过我是先跑一边 git action 给我报错了说不存在这个容器（因为我当时是照着诺天大佬模板写的）。看到报错，很快啊，直接打开诺天的聊天窗截图发送，他也马上给了我回复。

我们第一次需要手动创建容器。采用的是使用 Docker 挂载文件功能将主机中的 `jar` 包挂载到容器内部，在容器内部执行 `java -jar` 命令，创建容器：

```bash
sudo docker run -d -p 8081:8080 -v /var/www/example/example.jar:/example.jar -v /var/www/example/config/application-prod.yml:/config/application-prod.yml --name ExampleContainer eclipse-temurin:17-jre java -jar /example.jar --spring.profiles.active=prod
```

> 注意前面是宿主机的绝对路径目录，后面是容器内目录，别搞反了。

刚刚我才发现诺天博客写了篇 Github Actions 的文章有说使用构建镜像的方法：[Github Actions实现项目自动部署 – 诺天的小世界 (furry.pro)](https://nuotian.furry.pro/blog/archives/314)。

我们采用这个仓库的提供的方法[appleboy/ssh-action: GitHub Actions for executing remote ssh commands.](https://github.com/appleboy/ssh-action)连接上我们的服务器并执行 docker 命令（注意这个方法只能执行 docker 命令。还有此处的 `secrets.SERVER_ACCESS_KEY` 这些跟前面一致）：

```yaml
      - name: Restart Docker
        uses: appleboy/ssh-action@v0.1.4
        with:
          key: ${{ secrets.SERVER_ACCESS_KEY }}
          host: ${{ secrets.SERVER_HOST }}
          username: username
          script_stop: true
          script: |
            sudo docker restart Container
```

到此，我们的 workflow 文件基本就写完了。

## 完整示例

我的配置（SpringBoot Docker 项目）如下：

```yaml
name: CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@main
      - uses: actions/checkout@v3
      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: 'maven'
      
      - name: Build with Maven
        run: mvn -B package --file pom.xml
	
	 # 重命名 jar 包 
      - name: Rename target
        run: |
          mv target/*.jar target/example.jar
          
      # 将 jar 包上传到服务器
      - name: Upload to server
        uses: easingthemes/ssh-deploy@v2.2.11
        env:
          ARGS: '-avz --delete'
          SOURCE: 'target/example.jar'
          TARGET: '/home/username/example'
          REMOTE_HOST: ${{ secrets.SERVER_HOST }}
          REMOTE_USER: username
          SSH_PRIVATE_KEY: ${{ secrets.SERVER_ACCESS_KEY }}
      
      - name: Restart Docker
        uses: appleboy/ssh-action@v0.1.4
        with:
          key: ${{ secrets.SERVER_ACCESS_KEY }}
          host: ${{ secrets.SERVER_HOST }}
          username: username
          script_stop: true
          script: |
            sudo docker restart Container
```

**注意**：这里将 `jar` 包重命名了，方便使用。

创建容器(docker 的命令这里不多解释)：

```bash
sudo docker run -d -p 8081:8080 -v /var/www/example/example.jar:/example.jar -v /var/www/example/config/application-prod.yml:/config/application-prod.yml --name ExampleContainer eclipse-temurin:17-jre java -jar /example.jar --spring.profiles.active=prod
```
当然，Github Actions 能做的肯定不止这些，还需要自己发掘。也可以利用它自动化部署博客。

参考文章及文档：

[Github Actions实现项目自动部署 – 诺天的小世界 (furry.pro)](https://nuotian.furry.pro/blog/archives/314)

[GitHub Actions文档 - GitHub Docs](https://docs.github.com/cn/actions)
