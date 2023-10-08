---
title: 二分法[已废弃😭️...]
date: 2022/7/2 16:58
categories:
- [来点算法]
tags:
- 算法
---

1. 在一个**有序数组**中找一个数是否存在。
2. 在一个**有序数组**中，找>=某个数最左侧的位置。
3. 局部最小值问题（局部最小：在无序、任意两个相邻的数不相等的数组中，有局部最小定义：如果0位置的数小于1位置的数，那么0称做局部最小，如果位置N-1小于N-2上的数，那么N-1上的数称为局部最小，在相邻的三个数中，中间那个数最小，则这个数叫局部最小。 额好像就是极小值点）。

<!-- more -->

二分法一般用于有序数组中。

二分法有两种表现形式

- >  闭区间[left,right]，这时的`while (left <= right)` 要使用 <= ，因为left == right是有意义的，所以使用 <=。`right = nums.size()`。
  >
  > `if (nums[middle] > target) right` 要赋值为 middle - 1，因为当前这个nums[middle]一定不是target，那么接下来要查找的左区间结束下标位置就是 middle - 1

- > 左闭右开[left, right)，这时的`while (left < right)`，这里使用 < ,因为left == right在区间[left, right)是没有意义的。
  >
  > `if (nums[middle] > target) right` 更新为 middle，因为当前nums[middle]不等于target，去左区间继续寻找，而寻找区间是左闭右开区间，所以right更新为middle，即：下一个查询区间不会去比较nums[middle]

- [35.搜索插入位置](https://programmercarl.com/0035.搜索插入位置.html)
- [704. 二分查找 - 力扣（LeetCode）](https://leetcode.cn/problems/binary-search/)

- [34. 在排序数组中查找元素的第一个和最后一个位置 - 力扣（LeetCode）](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/)
- [69. x 的平方根 - 力扣（LeetCode）](https://leetcode.cn/problems/sqrtx/)
- [367. 有效的完全平方数 - 力扣（LeetCode）](https://leetcode.cn/problems/valid-perfect-square/)

## 34

```cpp
class Solution
{
public:
    vector<int> searchRange(vector<int> &nums, int target)
    {
        int rightBoarder = rightBorder(nums, target);
        int leftBoarder = leftBorder(nums, target);
        // 情况一
        if (leftBoarder == -2 || rightBoarder == -2)
        {
            return {-1, -1};
        }
        // 情况二
        else if (rightBoarder - leftBoarder > 1)
        {
            return {leftBoarder + 1, rightBoarder - 1};
        }
        // 情况三
        else
        {
            return {-1, -1};
        }
    }
private:
    int leftBorder(vector<int> &nums, int target)
    {
        // 这里可以等于-2，-3，-4等等。
        int left = 0, right = nums.size() - 1, leftBoarder = -2;
        while (left <= right)
        {
            int mid = left + ((right - left) >> 1);
            if (nums[mid] >= target)
            {
                right = mid - 1;
                leftBoarder = right;
            }
            else
            {
                left = mid + 1;
            }
        }
        return leftBoarder;
    }
    int rightBorder(vector<int> &nums, int target)
    {
        int left = 0, right = nums.size() - 1, rightBoarder = -2;
        while (left <= right)
        {
            int mid = left + ((right - left) >> 1);
            if (nums[mid] <= target)
            {
                left = mid + 1;
                rightBoarder = left;
            }
            else
            {
                right = mid - 1;
            }
        }
        return rightBoarder;
    }
};
```

这里主要是分三种情况

- 情况一：target 在数组范围的**右边或者左边**，例如数组{3, 4, 5}，target为2或者数组{3, 4, 5},target为6，此时应该返回{-1, -1}
- 情况二：target 在数组范围中，且数组中**不存在target**，例如数组{3,6,7},target为5，此时应该返回{-1, -1}
- 情况三：target 在数组范围中，且数组中存在target，例如数组{3,6,7},target为6，此时应该返回{1, 1}

主要把它分成三种情况就好理解了。

## 69:

```cpp
class Solution {
public:
    int mySqrt(int x) {
        int left = 1, right = x;
        int res = 0;
        while (left <= right) {
            int mid = left + ((right - left) >> 1);
            if (x / mid >= mid) {
                res = mid;
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return res;
    }
};
```

x的平方根可以利用**二分法**，从一开始，跟二分法差不多。

`x / mid >= mid`防止栈溢出，别问我怎么知道的，因为我用`(mid * mid) <= x`的时候给我报栈溢出的错。

只要检测到mid的平方比x小或者等于x的时候就可以将这个值存起来，防止之后的mid变大。

也可以用牛顿迭代法。

## 367

```cpp
class Solution {
public:
    bool isPerfectSquare(int num) {
        int left = 1, right = num;
        while (left <= right) {
            // 这里用int的话不够准确
            // 5 / 2 == 2 显然不对
            double mid = left + ((right - left) >> 1);
            if (num / mid == mid) {
                return true;
            } else if (num / mid < mid) {
                right = mid - 1; 
            } else if (num / mid > mid) {
                left = mid + 1;
            }
        }
        return false;
    }
};
```

和69题差不多，只是把判断条件细化了，和把mid改用double。

要是不改的话会有误差，因为两个数整除会舍去小数。69题因为找不到平方根的话可以返回一个近似的值，所以可以不用double。

也可以用牛顿迭代法。
