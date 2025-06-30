#!/usr/bin/env python
#########################################################################
# File Name: zip_demo.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Mon 30 Jun 09:54:58 2025
#########################################################################

# `zip()` 是 Python 的一个内置函数，用于将多个可迭代对象（如列表、元组等）“打包”成
# 一个个元素对应的元组，生成一个迭代器。常用于并行遍历多个序列。

# 📌 语法
# zip(iterable1, iterable2, ...)
# 它返回一个 迭代器，每次返回一个元组，元组中的元素来自所有传入的可迭代对象的相同
# 索引位置。

## ✅ 常见用法和例子
### 1. **将两个列表配对（按位置）**
names = ['Alice', 'Bob', 'Charlie']
scores = [85, 90, 95]

zipped = zip(names, scores)
print(list(zipped))
# Output: [('Alice', 85), ('Bob', 90), ('Charlie', 95)]

### 2. **用在 for 循环中并行遍历多个序列**
for name, score in zip(names, scores):
    print(f"{name} scored {score}")
# 输出:
# Alice scored 85
# Bob scored 90
# Charlie scored 95

### 3. **长度不一致时：取最短的序列**
a = [1, 2, 3]
b = ['a', 'b']

print(list(zip(a, b)))
# Output: [(1, 'a'), (2, 'b')]  # 第三个元素被忽略
# 如果你想保留较长的序列，可使用 `itertools.zip_longest`（见下面扩展部分）。

### 4. **解压（zip 的反操作）**
pairs = [('a', 1), ('b', 2), ('c', 3)]
letters, numbers = zip(*pairs)
print(letters)  # ('a', 'b', 'c')
print(numbers)  # (1, 2, 3)

## 🔄 zip 是惰性迭代器（不立即返回列表）
z = zip([1, 2], [3, 4])
print(z)            # <zip object at ...>
print(list(z))      # [(1, 3), (2, 4)]

## 🔧 扩展：zip\_longest（来自 itertools）
from itertools import zip_longest

a = [1, 2, 3]
b = ['a', 'b']

z = zip_longest(a, b, fillvalue='N/A')
print(list(z))
# Output: [(1, 'a'), (2, 'b'), (3, 'N/A')]

## ✅ 应用场景小结
# | 用法场景             | 使用 zip 做什么                 |
# | -------------------- | ------------------------------- |
# | 并行遍历多个列表     | `for a, b in zip(list1, list2)` |
# | 配对打包成元组列表   | `list(zip(list1, list2))`       |
# | 字典构造（键值配对） | `dict(zip(keys, values))`       |
# | 解压元组列表         | `zip(*zipped_list)`             |

