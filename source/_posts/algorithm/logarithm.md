---
title: 对数器的概念和使用
date: 2022/6/26 18:56
categories:
- [来点算法]
tags:
- 算法
---

1. 有一个你想要测的方法a
2. 实现复杂度不好但是容易实现的方法b
3. 实现一个随机样本产生器
<!-- more -->
4. 把方法a和方法b跑相同的随机样本，看看得到的结果是否一样。
5. 如果有一个随机样本使得比对结果不一致，打印样本进行人工干预，改对方法a或者方法b。
6. 当样本数量很多时比对测试依然正确，可以确定方法a已经确定。

**简而言之就是测试你的方法是否写对了**

```java
package src.main.java.day01;

import java.util.Arrays;



/**
 * @Author xun
 * @create 2022/6/26 18:11
 */
public class Test {
    // 生成随机数组，长度随机，值随机
    public static int[] generateRandomArray(int maxSize, int maxValue) {
        // Math.random()  ->  [0,1)  所有的小数，等概率返回一个
        // Math.random() * N  ->  [0,N) 所有小数， 等概率返回一个、
        // (int)(Math.random() * N)  -> [0,N-1]  所有的整数，等概率返回一个


        int[] arr = new int[(int) ((maxSize + 1) * Math.random())]; // 长度随机
        for (int i = 0; i < arr.length; i++) {
            arr[i] = (int) ((maxValue + 1) * Math.random()) - (int) (maxValue * Math.random());
        }
        return arr;
    }

    public static int[] copyArray(int[] arr) {
        if (arr == null) {
            return null;
        }
        int[] res = new int[arr.length];
        for (int i = 0; i < arr.length; i++) {
            res[i] = arr[i];
        }
        return res;
    }

    public static void collation (int [] arr) {
        Arrays.sort(arr);
    }

    public static boolean isEqual(int[] arr1, int[] arr2) {
        if (arr1.length != arr2.length) {
            return false;
        }
        for (int i = 0; i  <arr1.length; i++) {
            if (arr1[i] != arr2[i]) {
                return false;
            }
        }
        return true;
    }

    public static void printArray(int[] arr) {
        for (int j : arr) {
            System.out.println(j);
        }
    }

    /**
     * 测试排序是否正确
     * @param args
     */
    public static void main(String[] args) {
        int testTime = 500000;
        int maxSize = 100;
        int maxValue = 100;
        boolean succeed = true;
        for (int i = 0; i < testTime; i++) {
            int [] arr1 = generateRandomArray(maxSize,maxValue);
            int [] arr2 = copyArray(arr1);
            InsertionSort.insertionSort(arr1);
            collation(arr2);
            if (!isEqual(arr1, arr2)) {
                succeed = false;
                break;
            }
         }
        System.out.println(succeed ? "Nice!" : "Fucking fucked!");
        int [] arr = generateRandomArray(maxSize,maxValue);
        printArray(arr);
        InsertionSort.insertionSort(arr);
        printArray(arr);
    }
}

```

