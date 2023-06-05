---
title: 牛顿迭代法
date: 2022/7/2 17:04
categories:
- [来点算法]
tags:
- 算法
- 天马行空
---
# 牛顿迭代法

![牛顿迭代法推导](https://cos.asuka-xun.cc/blog%2Fnewton_method.jpg)

- [367. 有效的完全平方数 - 力扣（LeetCode）](https://leetcode.cn/problems/valid-perfect-square/)
<!-- more -->
- [69. x 的平方根 - 力扣（LeetCode）](https://leetcode.cn/problems/sqrtx/)

## 367

```cpp
class Solution {
public:
    bool isPerfectSquare(int num) {
        // 初始的值用num
        double x0 = num;
        while (true) {
            // 牛顿迭代法找零点
            double x1 = (x0 + num / x0) / 2;
            if (x0 - x1 < 1e-6) {
                break;
            }
            x0 = x1;
        }
        int x = (int) x0;
        if (x * x == num) return true;
        return false;
    }
};
```

## 69

```cpp
class Solution {
public:
    int mySqrt(int x) {
        if (x == 0) {
            return 0;
        }
        // 初始的值用x
        double x0 = x;
        while (true) {
            // 牛顿迭代法找零点
            double x1 = (x0 + x / x0) / 2;
            if (x0 - x1 < 1e-7) {
                break;
            }
            x0 = x1;
        }
        return (int) x0;        
    }
};
```

