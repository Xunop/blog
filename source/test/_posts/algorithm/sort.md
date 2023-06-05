---
title: 排序[更新中...]
date: 2022/6/27 15:51
categories:
- [来点算法]
tags:
- 算法
- 天马行空
---
# 排序

## 交换(swap)

### 异或
<!-- more -->

  异或（xor）是一个数学运算符。它应用于逻辑运算。异或的数学符号为“⊕”，计算机符号为“xor”。其运算法则为：

a⊕b = (¬a ∧ b) ∨ (a ∧¬b)

**如果a、b两个值不相同，则异或结果为1。如果a、b两个值相同，异或结果为0**。

异或也叫半加运算，其运算法则相当于不带进位的二进制加法：二进制下用1表示真，0表示假，则异或的运算法则为：0⊕0=0，1⊕0=1，0⊕1=1，1⊕1=0（同为0，异为1），这些法则与加法是相同的，只是不带进位，所以异或常被认作**不进位加法**（0+1+1，1+1等于1）。

异或略称为XOR、EX-OR

#### 性质

1. 0 ^ N = N，任何一个数与0异或等于自身。
2. N ^ N = 0，任何一个数异或本身等于0。
3. 异或运算满足交换律和结合律。a ^ b = b ^ a，a ^ b ^ c = a (b ^ c)
4. 由3推出本结论

#### 利用异或交换两个值（排序中的交换可以这样写）

```java
int a = 1, b = 2;
a = a ^ b;// a = 1 ^ 2, b = 2
b = a ^ b;// a = 1 ^ 2, b = 1 ^ 2 ^ 2 = 1 ^ 0 = 1
a = a ^ b;// a = 1 ^ 2 ^ 1 = 1 ^ 1 ^ 2 = 2, b = 1;
```

以上操作能交换两个数，不需要申请额外的空间， 前提**a和b必须是内存是不同的。**

**查找数组中出现奇数次的数可用异或查找**。

> 查找一个出现奇数的数
>
> `int eor = 0;`
>
> 用eor分别异或数组中的每个数，最终eor的值就是出现奇数次的数字。利用异或的性质，任意相同的数异或为0，偶数次则异或为0， 0异或一个数为本身。

> 查找两个出现奇数的数
>
> `int eor = 0;`
>
> 用eor分别异或数组中的每个数，最终eor的值为`eor = a ^ b`（a，b为出现奇数次数的数字）。所以这样就拿到了a，b的异或值eor。a!=b，所以eor != 0。这里做个假设：
>
> 假设eor中的第八位为1，则可按第八位为0还是1将数组中的数分成两类，再新建一个变量`int eor1 = 0;`用这个分别去异或数组中第八位为1的数，最终结果为`eor1 = a or b;`因为出现偶数次的数都会被抹掉，所以最终要么留下a要么留下b。~~好难解释，我要是不理解的话我也看不懂我写的~~。

代码实现:

```java
    public static void printOddTimesNum2(int [] arr){
        int eor = 0;
        for (int i : arr) {
            eor ^= arr[i];
        }
        // eor = a ^ b
        // eor != 0
        // eor必然由一个位置上是1
        int rightOne = eor & (~eor + 1); // 提取出最右的1 不懂可以自己画出二进制算一下

        int onlyOne = 0;
        for (int i : arr) {
            // 要么取1要么取0
            // 取哪个都一样
            if ((i & rightOne) == 0) {
                // onlyOne就是a或者b
                onlyOne ^= i;
            }
        }
        System.out.println(onlyOne + " " + (eor ^ onlyOne));
    }
```



## 选择排序

对于要排序的数组，设置一个minIdx记录最小数字下标。先假设第1个数字最小，此时minIdx = 0，将`arr[minIdx]`与后续数字**逐一比较**，当遇到更小的数字时，使minidx等于该数字下标，**第一轮比较找出该数组中最小的数字**。找到后将minIdx下标的数字与第1个数字交换，此时称一个数字已被排序。然后开始第2轮比较，令minIdx = 1，重复上述过程。每一轮的比较将使得当前未排序数字中的最小者被排序，未排序数字总数减1。第`arr.length - 1`轮结束后排序完成。**每次找最小的**。

找到一个动图，动图好理解：

![select](https://cos.asuka-xun.cc/blog/background picture1652692082-UXzLDc-select.gif)

#### 复杂度分析

时间复杂度：两层for循环，第一轮比较`n-1`次，最后一轮比较1次，等差数列，总比较次数 `n * (n - 1) / 2`次，时间复杂度为O（n^2）。

空间复杂度：常数项变量，O(1)。

代码块：

```java
    public static void selectionSort(int[] arr) {
        if (arr == null || arr.length < 2) {
            return;
        }
        // -1是为了防止下面for语句超出界限
        for (int i = 0; i < arr.length - 1; i++) {  // i ~ N-1
            int minIndex = i;
            // 比较两个数选择更小的
            for (int j = i + 1; j < arr.length; j++) {  // i ~ N-1上找最小值的下标
                minIndex = arr[j] < arr[minIndex] ? j : minIndex;
            }
            // 拿到最小的之后就可以将小的交换到前面，大的放后面
            swap(arr, i, minIndex);
        }
    }
```



## 冒泡排序

逐个进行比对，**每一轮比对都将使未排序数字总数减1**。从**第一位开始比较**两个数字，若前者大，则交换两者位置，比较位往后移。也就是说比较`arr[0]`和`arr[1]`，如果`arr[0]`>`arr[1]`,交换两者位置，比较位移到`arr[1]`和`arr[2]`这两个数字，直到比较到`arr[n-2]`和`arr[n-1]`(`n=arr.length`)。这一轮结束，最大的数字被放到后面，下一轮比较总数减一。**相邻两个数两两比较，小的放前面，比较一轮后大的在最后面**。

![bubble.gif](https://pic.leetcode-cn.com/1652691998-pJaTQD-bubble.gif)

#### 复杂度分析

时间复杂度：每轮交换总数都减一，等差数列。第一轮比较N-1次，依次递减。所以前n项和为`aN^2+bN+c`所以时间复杂度为O(N^2);

空间复杂度：算法中只有常数项变量，O(1)。

代码块：

```java
public static void bubbleSort(int[] arr) {
        if (arr == null || arr.length < 2) {
            return;
        }
        // -1防止越界
        // 每轮比较次数-1
        for (int i = arr.length - 1; i > 0; i--) {
            for (int j = 0; j < i; j++) {
                if (arr[j] > arr[j + 1]) {
                    swap(arr, j, j + 1);
                }
            }
        }
    }
```



## 插入排序

对于待排序数组，从**第2个元素开始**（称作插入对象元素）

，比较它与之前的元素（称作比较对象元素），当插入对象元素小于比较对象元素时，继续往前比较，直到不小于（≥）比较对象，此时将插入对象元素插入到该次比较对象元素之后。重复这个插入过程直到最后一个元素作为插入对象元素完成插入操作。**遍历数组，每个数都去比较，找到小的数字合适的位置插入进去。**

动图：

![insert.gif](https://pic.leetcode-cn.com/1652692170-fPOTLH-insert.gif)

#### 复杂度分析

时间复杂度：两层for循环，第一层N-1轮，逐次减少比较。所以也是等差数列。时间复杂度为O(N^2)。

空间复杂度：算法中只有常数项变量。

代码块：

```java
public static void insertionSort(int [] arr) {
        if (arr == null || arr.length < 2) {
            return;
        }
        // 0~0 有序的
        // 0~i 想有序
    	// 从1开始
        for (int i = 1; i  < arr.length; i++) {
            for (int j = i - 1; j >= 0 && arr[j] > arr[j + 1]; j--) {
                swap(arr, j, j + 1 );
            }
        }
    }
    // 交换
    public static void swap (int [] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
```



## 归并排序

利用递归进行排序。首先将数组分成左右两部分，分别进行排序。最终两边都排序完成，然后两边分别设置一个指针，然后两个指针比较，谁小谁就拿下来，然后这边的指针往后移动。相等时可以取左也取右，自己规定。指针移动直到有一边越界。

![merge.gif](https://pic.leetcode-cn.com/1652692297-eViXmh-merge.gif)

```java
public static int[] mergeSort(int[] arr) {
        if (arr.length < 2) return arr;
        int[] tmpArr = new int[arr.length];
        mergeSort(arr, tmpArr, 0, arr.length - 1);
        printArray(arr);
        return arr;
    }

    private static void mergeSort(int[] arr, int[] tmpArr, int left, int right) {
        if(left < right) {
            // 取中间值
            int center = left + (right - left) / 2;
            // 左边
            mergeSort(arr, tmpArr, left, center);
            // 右边
            mergeSort(arr, tmpArr, center + 1, right);

            merge(arr, tmpArr, left, center, right);
        }
    }

    // 非原地合并方法
    private static void merge(int[] arr, int[] tmpArr, int leftPos, int leftEnd, int rightEnd) {
        // center + 1
        int rightPos = leftEnd + 1;
        // 左边开始的值
        int startIdx = leftPos;
        int tmpPos = leftPos;
        // 两个都不越界
        while (leftPos <= leftEnd && rightPos <= rightEnd) {
            // 取最小放到tmp中
            if (arr[leftPos] <= arr[rightPos]) {
                tmpArr[tmpPos++] = arr[leftPos++];
            }
            else {
                tmpArr[tmpPos++] = arr[rightPos++];
            }
        }
        // 比较完成后若左数组还有剩余，则将其添加到tmpArr剩余空间
        while (leftPos <= leftEnd) {
            tmpArr[tmpPos++] = arr[leftPos++];
        }
        // 比较完成后若右数组还有剩余，则将其添加到tmpArr剩余空间
        while (rightPos <= rightEnd) {
            tmpArr[tmpPos++] = arr[rightPos++];
        }
        // 容易遗漏的步骤，将tmpArr拷回arr中
        // 从小区间排序到大区间排序，大区间包含原来的小区间，需要从arr再对应比较排序到tmpArr中，
        // 所以arr也需要动态更新为排序状态，即随时将tmpArr拷回到arr中
        for(int i = startIdx; i <= rightEnd; i++) {
            arr[i] = tmpArr[i];
        }
    }
```

#### 复杂度分析



符合master公式，则由性质知时间复杂度
$$
O({N}^{d} * \log_2N)
$$
其中d为1。

额外空间复杂度：建立了一个辅助数组所以为O(N)。

