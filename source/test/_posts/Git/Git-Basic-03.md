---
title: Git 基础———创建仓库及提交更新
cover: https://cos.asuka-xun.cc/blog/assets/Git-Base-03.jpg
date: 2022/8/23 1:06
categories:
- [Git]
tags:
- Git
---
# Git 基础———创建仓库及提交更新

## 创建仓库

有两种创建仓库的方法：
<!-- more -->

1. 将没有进行版本控制的本地目录转换为 Git 仓库；

2. 从其他服务器克隆一个已存在的 Git 仓库。

   > 我们就可以从 GitHub 上使用 'git clone' 这个命令克隆一个 Git 仓库。

### 在没有进行版本控制的本地目录初始化仓库

进入到你想进行版本控制的目录，使用以下命令：
```shell
$ git init
```

这个命令会创建一个名为 `.git` 的子目录，这个子目录含有你初始化的 Git 仓库中所有的必须文件，这些文件是 Git 仓库的骨干。 

使用 `git add` 命令来指定所需的文件进行跟踪及初始化提交：

```shell
$ git add *.c
$ git add LICENSE
$ git commit -m 'initial project version'
```

`git add` 将文件提交到暂存区。

> 关于 `LICENSE ` 开源许可证，可以看看这篇文章：[如何选择开源许可证？ - 阮一峰的网络日志 (ruanyifeng.com)](https://www.ruanyifeng.com/blog/2011/05/how_to_choose_free_software_licenses.html)

`git commit` 将暂存区中的所有内容提交到当前分支（创建版本库时 git 自动创建一个 master 分支）

> `-m` 是提交信息，查看别人或者自己的历史记录的时候，这个东西是挺重要的。以下是 Git 的标准注解：
>
> ```
> 第1行：提交修改内容的摘要
> 第2行：空行
> 第3行以后：修改的理由
> ```

### 克隆现有的仓库

`git clone` 命令：

```shell
$ git clone <url>
```

比如克隆我的一个项目：

```shell
$ git clone https://github.com/Xunop/kakaBot
```

这会在当前目录下创建一个叫 kakaBot 的目录，并在这个目录下初始化一个 `.git` 文件夹， 从远程仓库拉取下所有数据放入 `.git` 文件夹，然后从中读取最新版本的文件的拷贝。可以在后面添加自定义本地仓库的名字。

## 举例

我会将命令及执行结果放在一起。中间会夹带 Git 命令的介绍。

### 初始化仓库

```shell
$ git init
Initialized empty Git repository in D:/gitDemo/.git/
```

### 查看当前文件状态

使用   `git status` 查看当前文件状态：

```shell
$ git status
On branch main
No commits yet
nothing to commit (create/copy files and use "git add" to track)
```

> `git status` 命令输出还可以使用缩短，使用 `-s` 或者 `-short` 选项可以缩短状态命令的输出。
>
> ```shell
> $ git status -s
> A  README
> ```
>
> 新添加的未跟踪文件前面有 `??` 标记，新添加到暂存区中的文件前面有 `A` 标记，修改过的文件前面有 `M` 标记。 输出中有两栏，左栏指明了暂存区的状态，右栏指明了工作区的状态。

这说明我们现在的工作目录相当干净。换句话说，所有已跟踪文件在上次提交后都未被更改过。这个命令还显示了当前分支，我当前分支名是 `main`。好像是之前我学长帮我改成 `main` 的。

创建一个 `README` 文件。如果之前不存在这个文件，使用 `git status` 命令会有看到一个未跟踪文件：

```shell
$ echo 'README' > README
$ git status
On branch main
No commits yet
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        README
nothing added to commit but untracked files present (use "git add" to track)
```

`Untracked files` 表示为跟踪文件清单。未跟踪的文件意味着 Git 在之前的快照（提交）中没有这些文件；Git 不会自动将之纳入跟踪范围。

### 跟踪新文件

使用命令 `git add` 开始跟踪一个文件。 所以，要跟踪 `README` 文件，运行：

```shell
$ git add README
```

此时再运行 `git status` 命令，会看到 `README` 文件已被跟踪，并处于暂存状态：

```shell
$ git status
On branch main
No commits yet
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README
```

只要在 `Changes to be committed` 这行下面的，就说明是已暂存状态。如果我们现在提交，那么这个文件就会从暂存区提交到我们的分支 `main` 中。 `git add` 命令使用文件或目录的路径作为参数；如果参数是目录的路径，该命令将递归地跟踪该目录下的所有文件。

### 暂存已修改的文件

我们创建一个文件 `test.md`，然后将它加入到暂存区中。之后我们修改这个文件再查看状态：

```shell
$ git status
On branch main
No commits yet
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README
        new file:   test.md
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   test.md
```

这个文件出现在 `Changes not staged for commit` 这行下面，说明已跟踪文件的内容发生了变化，但还没有放到暂存区。 要暂存这次更新，需要运行 `git add` 命令。 这是个多功能命令：可以用它开始跟踪新文件，或者把已跟踪的文件放到暂存区，还能用于合并时把有冲突的文件标记为已解决状态等。运行 `git add` 将这个文件加入到暂存区中，再次查看状态：

```shell
$ git status
On branch main
No commits yet
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README
        new file:   test.md
```

如果此时我们再次修改 `test.md` 文件，然后查看状态：

```shell
$ git status
On branch main
No commits yet
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README
        new file:   test.md
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   test.md
```

`test.md` 同时出现在暂存区跟非暂存区，如果我们此时提交的话，提交的是在暂存区中的文件，因为我们最后一次修改的文件还没加入到暂存区。

### 查看已暂存和未暂存的修改

这个的话如果使用可视化倒是很清晰，直接看命令行还是有点累。

使用 `git diff` 命令可以通过文件补丁的格式更加具体地显示哪些行发生了改变。

使用 `git diff --staged` 命令或者 `git diff --cached` 查看已暂存的将要添加到下次提交里的内容。 这条命令将比对已暂存文件与最后一次提交的文件差异：

```shell
$ git diff --staged
diff --git a/README b/README
new file mode 100644
index 0000000..e845566
--- /dev/null
+++ b/README
@@ -0,0 +1 @@
+README
diff --git a/test.md b/test.md
new file mode 100644
index 0000000..36198c5
--- /dev/null
+++ b/test.md
@@ -0,0 +1,3 @@
+test
+test1
+test2
```

> 我么可以使用 `git difftool` 调用一些可视化软件帮助我们查看修改，如果你没有下载的话会提示你下载的。
>
> 使用 `git difftool --tool-help` 命令来看你的系统支持哪些 Git Diff 插件。

### 提交更新

中间插了这么多步骤，这里总算可以提交了。

```shell
git commit
```

这样会启动你选择的文本编辑器来输入提交说明。我是用 vscode。
> 启动的编辑器是通过 Shell 的环境变量 `EDITOR` 指定的，一般为 vim 或 emacs。 可以使用 `git config --global core.editor` 命令设置喜欢的编辑器。直接改文件 `~/.gitconfig` 这个文件中有编辑器配置设置。我在前面的文章中也有提到 `--global` 选项更改文件是在这个目录下。

编写了提交说明直接退出编辑器就行了。打开编辑器会显示更新内容，不过这些更新内容是用 `#` 注释了的，不会提交。

使用 `-m` 选项提交：

```shell
git commit -m 'first commit'
```

> 此时我们使用 `git log` 查看 git 日志：
>
> ```shell
> $ git log
> commit 5abccae89d89d1bdb52a724d7bc40da0dd685c2e (HEAD -> main)
> Author: Xunop <1234567@qq.com>
> Date:   Mon Aug 22 23:13:55 2022 +0800
> ```
>
> 出现了我们的提交记录

### 跳过暂存区

每次提交都需要将文件加入到暂存区，文件一多就有点繁琐，我们可以使用选项 `-a` 这样 Git 会自动把所有**已经跟踪**过的文件暂存起来一并提交，从而跳过 `git add` 步骤：

```shell
git commit -a -m 'add df'
```

不过需注意，有时这个选项会将不需要的文件添加到提交中。

### 移除文件

其实 Git 也提示了我们，在之前的命令输出中出现过这种提示：

```shell
 (use "git rm --cached <file>..." to unstage)
```
还有这种：

```shell
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
```

又捡到一个命令 `git restore <file>...` 

> 这个命令有点好玩，可以恢复已删除文件。
>
> 如果你删除一个已经加入到暂存区的文件，不过还没有暂存这个更改，也就是出现我说的*简单地从工作目录中手工删除文件*的情况，我们可以使用 `git restore` 来恢复这个文件：
>
> ```shell
> rm file1.txt
> $ ll
> total 2
> -rw-r--r-- 1 xun 197121 32  8月 22 23:24 df
> -rw-r--r-- 1 xun 197121  7  8月 22 22:38 README
> $ git restore file1.txt
> $ ll
> total 3
> -rw-r--r-- 1 xun 197121 32  8月 22 23:24 df
> -rw-r--r-- 1 xun 197121  9  8月 22 23:59 file1.txt
> -rw-r--r-- 1 xun 197121  7  8月 22 22:38 README
> ```
>
> 如果我们删除了一个已经加入到暂存区的文件，并且还暂存了这个更改，我们使用这个命令就会报错：
>
> ```shell
> $ rm file1.txt
> $ git add .
> $ git restore file1.txt
> error: pathspec 'file1.txt' did not match any file(s) known to git
> ```
>
> > 关于 `git add .` 是添加当前目录下的所有文件到暂存区。
>
> 这样就不能恢复了吗？如果你之前已经提交过这个文件的话还能恢复的，我们使用 `git restore --staged --worktree <filename>` 这个命令：
>
> ```shell
> $ git restore --staged --worktree file1.txt
> ```
>
> > `--staged` 参数告诉 Git 从 HEAD 恢复索引（暂存区）中的文件，`--worktree` 告诉 Git 恢复工作树（工作区）。
>
> 这个文件恢复的只是我们之前提交的，如果我们对这个文件进行过更改且没有提交到当前分支，那么那些修改是没有恢复的。
>
> 还有更极限的情况就要使用 `git checkout` 命令了。可以去了解一下。这篇文章有记载的：[Recovering Deleted Files in GitHub - Rewind](https://rewind.com/blog/recovering-deleted-files-in-github/)。

要从 Git 中移除某个文件，就必须要从已跟踪文件清单中移除（确切地说，是从暂存区域移除），然后提交。 可以用 `git rm` 命令完成此项工作，**并连带从工作目录中删除指定的文件**，这样以后就不会出现在未跟踪文件清单中了。

如果只是简单地从工作目录中手工删除文件（我这里删除 `test.md` 文件），运行 `git status` 时就会在 “Changes not staged for commit” 部分（也就是 *未暂存清单*）看到：

```shell
$ git status
On branch main
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        deleted:    test.md
no changes added to commit (use "git add" and/or "git commit -a")
```

如果这时候提交还是显示这个的，出现这个的原因是我们删除（修改）了 `test.md` 文件但是尚未添加到暂存区。前面当我们修改了一个文件但是没有加入到暂存区也是显示这个。

如果我们使用 `git rm test.md` 就不会显示这个：

```shell
$ git rm test.md
rm 'test.md'
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        deleted:    test.md
```

如果要删除之前修改过或已经放到暂存区的文件，则必须使用强制删除选项 `-f`。这是防止误删，因为 Git 并不能恢复这些数据。

有个问题就是我们只是想把这个文件从 Git 仓库中删除而不是在我们工作目录（也就是我们本地）中也删除，我们使用 `git rm` 命令时会把我们本地的这个文件也删除。有时候我们就遇到忘记把一些文件添加到 `.gitignore` 文件里（`.gitignore` 文件一旦确定就不能再改，它的介绍在后面），然后被添加到暂存区里 的情况（写这篇文章的时候刚好遇到这个问题，一个不能上传的配置文件差点给我上传了）。这时我们使用 `--cached` 选项就很有用了：

```shell
$ git rm --cached README
```

使用这个不会从我们本地删除，而是让 Git 不再跟踪。

> `git rm` 命令后面可以列出文件或者目录的名字，也可以使用 `glob` 模式。比如：
>
> ```console
> $ git rm log/\*.log
> ```
>
> 注意到星号 `*` 之前的反斜杠 `\`， 因为 Git 有它自己的文件模式扩展匹配方式，所以我们不用 shell 来帮忙展开。 此命令删除 `log/` 目录下扩展名为 `.log` 的所有文件。 类似的比如：
>
> ```console
> $ git rm \*~
> ```
>
> 该命令会删除所有名字以 `~` 结尾的文件。

### 移动文件

既然如此，当你看到 Git 的 `mv` 命令时一定会困惑不已。 要在 Git 中对文件改名，可以这么做：

```shell
$ git mv fileNem newFileName
```

```shell
$ git mv README.md README
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    renamed:    README.md -> README
```

其实，运行 `git mv` 就相当于运行了下面三条命令：

```console
$ mv README.md README
$ git rm README.md
$ git add README
```

运行 `git mv` 就相当于运行了下面三条命令：

```shell
$ mv README.md README
$ git rm README.md
$ git add README
```

### 忽略文件

一般我们总会有些文件无需纳入 Git 的管理，也不希望它们总出现在未跟踪文件列表。 通常都是些自动生成的文件，比如日志文件，或者编译过程中创建的临时文件等。 在这种情况下，我们可以创建一个名为 `.gitignore` 的文件，列出要忽略的文件的模式。 来看一个实际的 `.gitignore` 例子：

```console
$ cat .gitignore
*.[oa]
*~
```

第一行告诉 Git 忽略所有以 `.o` 或 `.a` 结尾的文件。一般这类对象文件和存档文件都是编译过程中出现的。 第二行告诉 Git 忽略所有名字以波浪符（~）结尾的文件，许多文本编辑软件（比如 Emacs）都用这样的文件名保存副本。 此外，你可能还需要忽略 log，tmp 或者 pid 目录，以及自动生成的文档等等。 要养成一开始就为你的新仓库设置好 `.gitignore` 文件的习惯，以免将来误提交这类无用的文件。

文件 `.gitignore` 的格式规范如下：

- 所有空行或者以 `#` 开头的行都会被 Git 忽略。
- 可以使用标准的 glob 模式匹配，它会递归地应用在整个工作区中。
- 匹配模式可以以（`/`）开头防止递归。
- 匹配模式可以以（`/`）结尾指定目录。
- 要忽略指定模式以外的文件或目录，可以在模式前加上叹号（`!`）取反。

所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。 星号（`*`）匹配零个或多个任意字符；`[abc]` 匹配任何一个列在方括号中的字符 （这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）； 问号（`?`）只匹配一个任意字符；如果在方括号中使用短划线分隔两个字符， 表示所有在这两个字符范围内的都可以匹配（比如 `[0-9]` 表示匹配所有 0 到 9 的数字）。 使用两个星号（`**`）表示匹配任意中间目录，比如 `a/**/z` 可以匹配 `a/z` 、 `a/b/z` 或 `a/b/c/z` 等。

我们再看一个 `.gitignore` 文件的例子：

```
# 忽略所有的 .a 文件
*.a

# 但跟踪所有的 lib.a，即便你在前面忽略了 .a 文件
!lib.a

# 只忽略当前目录下的 TODO 文件，而不忽略 subdir/TODO
/TODO

# 忽略任何目录下名为 build 的文件夹
build/

# 忽略 doc/notes.txt，但不忽略 doc/server/arch.txt
doc/*.txt

# 忽略 doc/ 目录及其所有子目录下的 .pdf 文件
doc/**/*.pdf
```

我一般使用 IDEA 自带的😎，不过 Github 有一个项目是包括了很多种情况的`.gitignore` 文件列表，看这里：[github/gitignore: A collection of useful .gitignore templates](https://github.com/github/gitignore)。我写这个东西写得比较少，也就加几个配置文件，~~IDEA 生成的足够使用了~~。

参考文章及文档：

[Recovering Deleted Files in GitHub - Rewind](https://rewind.com/blog/recovering-deleted-files-in-github/)

[Git - Book (git-scm.com)](https://git-scm.com/book/zh/v2)
[如何选择开源许可证？ - 阮一峰的网络日志 (ruanyifeng.com)](https://www.ruanyifeng.com/blog/2011/05/how_to_choose_free_software_licenses.html)