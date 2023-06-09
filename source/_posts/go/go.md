---
description: 每个Go程序都是由包构成的。程序从main包开始运行。按照约定，包名与导入路径的最后一个元素一致。一个包的名字和包的导入路径的最后一个字段相同，例如`gopl.io/ch2/tempconv`包的名字一般是`tempconv`。使用包直接使用`tempconv`加上一个`.`然后就可以选择包里的方法了。 导入包有两种方法":"
title: Go基础语法
date: 2022/5/7 19:58
categories:
- [Golang]
tags:
- 编程语言
---
在这里记录一下自己记录的Go的一些常用的语法。Go跟之前学过的C，C++，Java差别有点大。不太习惯。

## 包

每个Go程序都是由包构成的。程序从main包开始运行。按照约定，包名与导入路径的最后一个元素一致。一个包的名字和包的导入路径的最后一个字段相同，例如`gopl.io/ch2/tempconv`包的名字一般是`tempconv`。使用包直接使用`tempconv`加上一个`.`然后就可以选择包里的方法了。

### 导入

导入包有两种方法:

1. 分组形式导入:
   
   ```go
   import(
    "fmt"
    "math"
   )
   ```
2. 编写多个导入语句:
   
   ```go
   import "fmt"
   import "math"
   ```
   
   推荐使用第一种。
   
   ### 导出名

在Go中规定，如果一个名字以大写字母开头，那么它就是已导出的。如：`Pi`导出自`math`包。

## 函数

Go中的函数可以没有参数或者接受多个参数，还可以**返回多个值**。
需要注意的是，Go语言中是变量在前，类型在后。

当连续两个或多个函数的已命名形参类型相同时，除最后一个类型以外，其他都可以省略。
如：
`x int y int` 可写成 `x,y int`

### 命名返回值

Go函数中的返回值可以被命名，它们被看为定义在函数顶部的变量。
看代码:

```go
//这里是对返回值进行命名，这样返回值就和参数一样拥有参数变量名和类型。
//括号里的就是返回值类型，因为这里返回两个数，所以使用两个string
func exists(m map[string]string, k string) (v string, ok bool) {
   v, ok = m[k]
   return v, ok
}
```

这个代码中如果return后面没跟参数，则默认返回`string`和`bool`类型的两个参数。

## 变量

Go中变量声明有两种方法:

1. `var`语句声明。`var`语句可以出现在包或函数级别（后面介绍那个则只能在函数中）。例，`var x int`。Go语言中还有类型推导，你可以写成`var x = 6`，它根据你写给的参数自动命名（类型推导）。
2. 短变量声明。使用符号`:=`可在类型明确的地方代替`var`声明,它不能在函数外使用。
   例如:`g := 99` 这里也是自动判断是什么类型的。

跟其他语言一样，如果声明却没有赋值，则根据这几种情况默认赋值：

- 数值类型为0
- 布尔类型为`false`
- 字符串为`""`
  需要注意的是，Go语言中不允许声明而不使用的变量。
  所以根据这个特性Go中定义了空标识符`_`,这个东西可以怎么用呢？看下面这段代码
  
  ```go
  sum := 0
  for _, value := range array{
    sum += value
  }
  ```
  
  这里呢就是相当于我们在C语言这样写(意思差不多就行了)：
  
  ```go
  int sum = 0;
  for (int i = 0; i < 2; i++){
    sum++;
  }
  ```
  
  就是只是为了索引而已。

## 常量

常量的声明与变量类似，只是多了一个`const`关键字。
常量不能用`:=`语法声明。
`const x = 9`

## range

`range`语言范围。
用于 **for 循环**中迭代数组(array)、切片(slice)、通道(channel)或集合(map)的元素。在数组和切片中它返回元素的索引和索引对应的值，在集合中返回 key-value 对。

```go
nums := []int{1, 2, 3}
sum := 0
for _, value := range nums{
    sum += value
}
```

sum的值为6。

## Map

Map 是一种无序的键值对的集合。
Map的定义有两种：

1. 使用`make`关键字
2. 使用`map`关键字
   
   ```go
   //使用make定义
   //也可以使用map关键字定义
   //var map_variable map[key_data_type]value_data_type
   //key是string类型，值是int类型
   m := make(map[string]int)
   m2 := map[string]int{"one": 1, "two": 2}
   ```

## 总结

Go语言与之前学的几种都不太相同，比如它if和for都不用加括号，代码行尾不用加分号，变量在前类型在后等等。不过要是有一些语言的基础，理解这些基础语法并不难。