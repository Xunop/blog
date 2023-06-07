---
description: 舍入运算是我们平时使用的比较多的运算，最近看 CSAPP 学到了一些关于舍入运算的更详细的内容，在这里记录一下。 IEEE754 定义了四种不同的舍入方式：
title: 向偶数舍入
cover: https://cos.asuka-xun.cc/blog/assets/round-to-even.jpg
date: 2022/10/10
categories:
- [二进制杂谈]
tags:
- 计算机科学
- CSAPP

---

# 舍入运算

舍入运算是我们平时使用的比较多的运算，最近看 CSAPP 学到了一些关于舍入运算的更详细的内容，在这里记录一下。

## 舍入方式

IEEE754 定义了四种不同的舍入方式：

- 向偶数舍入

- 向零舍入

- 向下舍入

- 向上舍入
  IEEE754 默认采用向偶数舍入，用来找到最接近的匹配近似值。而其他三种方式则用于计算上下界。

下表是按照四种不同的方式保留整数后的舍入结果（图与 CSAPP 上一致）：

![one](https://cos.asuka-xun.cc/blog/one.webp)

> 我这里只讨论向偶数舍入，其他舍入方式还是比较容易理解的。

我在看这个示例的时候，看到 1.40 向偶数舍入结果是 1 这个奇数，我是懵的，后来查了查解释向偶数舍入并不是直接舍去进偶数，有个口诀：四舍六入五凑偶或四舍六入五成双。（我在上物理实验课时数据处理也是这个规则）。**注意**：这里的口诀只针对十进制，因为向偶数舍入也可以应用于二进制，后面会介绍。

## 向偶数舍入

向偶数舍入是可以更好的避免系统误差。

如果我们使用向上舍入，那么这组数据计算出来的平均值是比这些数本身的平均值略高的。如果我们是用向下舍入，那么这组数据计算出来的平均值是比这些数本身的平均值略低的。而如果我们使用向偶数舍入，那么它有 50% 的时间是向上舍入， 50% 的时间是向下舍入。

### 规则

向偶数舍入有以下规则：

- 如果最接近的值唯一，则直接向最接近的值舍入。
- 如果是处在**中间值**，那么要看**保留位**是否是偶数，如果是偶数则直接舍去后面的数不进位，如果是奇数则进位后再舍去后面的数。

这里我们提到了两个概念：中间值和保留位，我们在这里对这些概念进行解释。

### 保留位(Guard bit)、近似位(Round bit)和粘滞位(Sticky bit)、中间值

对十进制来说，如果我们需要保留两位小数，即保留十分位和百分位上的数。那么**保留位**(Guard bit)就是**结果的最低位**，即百分位；**近似位**(Round bit)就是**第一个被舍掉的位**，即千分位；而千分位之后的所有位（包括万分位、十万分位等等）构成**粘滞位**(Sticky bit)。

同理，对于二进制，如果我们想要保留两位小数，那么小数点右边第二位就是**保留位**(Guard bit)，小数点右边第三位就是**近似位**(Round bit)，小数点右边第四位开始一直向右的所有小数位或起来构成**粘滞位**(Sticky bit)。

**中间值**

求中间值的方法如下：

1. 保留位(Guard bit)和左边的数字保持不变；
2. 近似位(Round bit)改写为 N/2（N为进制数，十进制就是10，二进制就是2）
3. 粘滞位(Sticky bit)全部写零

| 原始值(十进制) | 中间值 (保留一位小数) | 中间值 (保留两位小数) |
| -------- | ------------ | ------------ |
| 1.334    | 1.350        | 1.335        |
| 1.622    | 1.650        | 1.625        |
| 1.744    | 1.750        | 1.745        |
| 1.835    | 1.850        | 1.835        |
| 1.668    | 1.650        | 1.665        |
| 1.774    | 1.750        | 1.775        |
| 1.488    | 1.450        | 1.485        |

| 原始值(二进制) | 中间值 (保留一位小数) | 中间值 (保留两位小数) |
| -------- | ------------ | ------------ |
| 1.101    | 1.110        | 1.101        |
| 101.111  | 101.110      | 101.111      |
| 11.001   | 11.010       | 11.001       |
| 1.010    | 1.010        | 1.011        |
| 1.100    | 1.110        | 1.101        |

有了对这些概念的理解，我们以例子来理解向偶数舍入。

## 十进制举例

对于以下十进制的数值，我们采用向偶数舍入的方式，保留精确度到十分位，即**保留一位小数**。

1. 第一组例子：
   
   | 原始值     | 中间值  | 近似值 (向偶数舍入) |
   | ------- | ---- | ----------- |
   | 1.36    | 1.35 | 1.4         |
   | 1.751   | 1.75 | 1.8         |
   | 1.852   | 1.85 | 1.9         |
   | 1.77    | 1.75 | 1.8         |
   | 1.45001 | 1.45 | 1.5         |
   
   可以看到，上述这些原始值都比中间值要大，也就是“四舍六入五成双”中的“六入”。所以都向十分位进一，从而使得损失的精度最小。

2. 第二组例子：
   
   | 原始值  | 中间值  | 近似值 (向偶数舍入) |
   | ---- | ---- | ----------- |
   | 1.33 | 1.35 | 1.3         |
   | 1.74 | 1.75 | 1.7         |
   | 1.82 | 1.85 | 1.8         |
   | 1.71 | 1.75 | 1.7         |
   | 1.43 | 1.45 | 1.4         |
   
   可以看到，上述这些原始值都比中间值要小，也就是“四舍六入五成双”中的“四舍”。所以直接舍弃，不进位，从而使得损失的精度最小。

3. 第三组例子：
   
   | 原始值  | 中间值  | 近似值 (向偶数舍入) |
   | ---- | ---- | ----------- |
   | 1.35 | 1.35 | 1.4         |
   | 1.75 | 1.75 | 1.8         |
   | 1.85 | 1.85 | 1.8         |
   | 1.25 | 1.25 | 1.2         |
   | 1.45 | 1.45 | 1.4         |
   
   可以看到，上述这些原始值和中间值相等，也就是“四舍六入五成双”中的“五成双”。对于这些和中间值完全相等的原始值，我们考察**保留位**(Guard bit)，如果保留位是**偶数**，则直接舍弃近似位(Round bit)和粘滞位(Sticky bit)；如果保留位是**奇数**，则先向保留位进一，之后舍弃近似位(Round bit)和粘滞位(Sticky bit)。这样，结果中的保留位就是偶数了。这就是向偶数舍入 名字的由来。1.35 保留位是 3，是奇数，所以我们需要向保留位进一然后舍去后面的近似位和粘滞位，变成 1.4。1.85 保留位是 8，是偶数，所以我们可以直接舍去后面的近似位跟粘滞位，变成 1.8。
   
   所以到这里我们就知道了最初的 1.40 不保留小数，舍入直接变成 1 的原因了，因为中间值是 1.5，1.4 小于 1.5，所以我们直接舍去。
   
   在我们平时计算的时候，我们可以直接看**近似位**（保留位的后一位），如果小于 5，那我们直接舍去近似位和粘滞位，如果大于 5，我们**进位**再舍去近似位和粘滞位，如果等于 5，我们就需要看保留位是否为奇数，为奇数我们就需要进一然后舍去近似位和粘滞位，否则，我们直接舍去近似位和粘滞位。

## 二进制举例

前面说过，向偶数舍入可以应用于二进制。在二进制中，我们将最低有效位的值 0 认为是偶数，值 1 认为是奇数。跟我们平时说的奇偶一致。

对于以下二进制的数值，我们采用向偶数舍入的方式，**保留一位小数**。

1. 第一组例子：
   
   | 原始值(二进制) | 中间值  | 近似值 (向偶数舍入) |
   | -------- | ---- | ----------- |
   | 1.111    | 1.11 | 10.0        |
   | 1.0101   | 1.01 | 1.1         |
   | 1.0111   | 1.01 | 1.1         |
   
   可以看到，上述这些原始值都比中间值要大，也就是“四舍六入五成双”中的“六入”。所以都向小数点右边第1位进一，从而使得损失的精度最小。这里是二进制了，所以 1 进一之后变成了 10。

2. 第二组例子：
   
   | 原始值(二进制) | 中间值  | 近似值 (向偶数舍入) |
   | -------- | ---- | ----------- |
   | 1.001    | 1.01 | 1.0         |
   | 1.10     | 1.11 | 1.1         |
   
   可以看到，上述这些原始值都比中间值要小，也就是“四舍六入五成双”中的“四舍”。所以直接舍弃，不进位，从而使得损失的精度最小。

3. 第三组例子：
   
   | 原始值(二进制) | 中间值  | 近似值 (向偶数舍入) |
   | -------- | ---- | ----------- |
   | 1.110    | 1.11 | 10.0        |
   | 1.010    | 1.01 | 1.0         |
   
   可以看到，上述这些原始值和中间值相等，也就是“四舍六入五成双”中的“五成双”。对于这些和中间值完全相等的原始值，我们考察**保留位**(Guard bit)，如果保留位是**偶数**，则直接舍弃近似位(Round bit)和粘滞位(Sticky bit)；如果保留位是**奇数**，则先向保留位进一，之后舍弃近似位(Round bit)和粘滞位(Sticky bit)。这样，结果中的保留位就是偶数了。这就是向偶数舍入 名字的由来。

---

   参考文章：

   [IEEE754浮点数 向偶数舍入 - 爱码网 (likecs.com)](https://www.likecs.com/show-203508486.html?sc=1547.3778076171875)