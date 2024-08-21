---
date: 2024-08-21
title: unwind-orc.md
description: sp 用于计算 PREV_RSP，bp 用于计算 PREV_RBP，PREV_RIP 计算 PREV_RSP。查找与所疑问指令相对应的 ORC 记录。上述每一行对应一个 ORC 记录。每个记录都与一个指令偏移量相关联，并按排序顺序保存这些记录。一个记录从所列的指令偏移量开始有效，直到下一个记录出现。
categories:
- [objtool]
---
sp 用于计算 PREV_RSP，bp 用于计算 PREV_RBP，PREV_RIP 计算 PREV_RSP。

查找与所疑问指令相对应的 ORC 记录。上述每一行对应一个 ORC 记录。每个记录都与一个指令偏移量相关联，并按排序顺序保存这些记录。一个记录从所列的指令偏移量开始有效，直到下一个记录出现。

使用 sp 字段计算 PREV_RSP 值，该字段将指定起始寄存器和偏移量。只需将寄存器值和偏移量相加，即可得到 PREV_RSP 值。

在正常的函数调用过程中，RIP 被推送到堆栈中，这意味着它被写入到 RSP - 8。因此，我们可以通过查看存储在地址 PREV_RSP - 8 处的堆栈中的值来找到 PREV_RIP 的值。我将使用 *(PREV_RSP - 8) 的表示法来表示我们实际上是从堆栈中读取值，就像在 C 中对指针进行解引用一样。
