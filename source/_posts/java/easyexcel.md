---
title: 记一次easyexcel的踩坑记录
date: 2022/7/23 22:52
categories:
- [Java]
tags:
- easyExcel
- 踩坑
---

easyexcel导出文档正常，但是打开时会弹出 “xxx中的部分内容有问题。是否让我们尽量尝试恢复？”，这给我整傻了，我明明之前也导出一次的，那次还很成功。于是只能去搜了，试了几种方法，后面发现一篇文章成功解决问题。

![error](https://cos.asuka-xun.cc/blog/20220723224908.png)
<!-- more -->

很坑好吧，就是因为我接口返回类型不是`void`返回了其他类型就导致了我导出文档打开需要修复。我也想到我之前导出成功那次确实接口返回类型是`void`。

**解决方法**：自然就是将接口返回类型设置成`void`。具体是因为什么我还不了解。

参考文章：[poi导出excel异常:Excel 已完成文件级验证和修复。此工作簿的某些部分可能已被修复或丢弃 - 紫月java - 博客园 (cnblogs.com)](https://www.cnblogs.com/ziyue7575/p/12697648.html)