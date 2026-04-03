#!/usr/bin/env python
#########################################################################
# File Name: list_comprehensions.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Thu 26 Sep 15:46:41 2024
#########################################################################


# 基本的语法结构如下：
# new_list = [expression for item in iterable if condition]
#   expression：生成新列表中的元素。
#   item：迭代对象中的每一个元素。
#   iterable：你要迭代的对象（如列表、元组等）。
#   condition：可选的过滤条件，item只有满足条件的元素才会被包含在新列表中


# 基本结构
list = [ x**2 for x in range(10) ]  # [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
print("base: ", list)

# 带条件过滤
list = [ x**2 for x in range(10) if x % 2 == 0]  # [0, 4, 16, 36, 64]
print("with filter: ", list)

# 包含多个for循环
list = [ x + y for x in [1,2,3] for y in [4,5,6] ]  # [5, 6, 7, 6, 7, 8, 7, 8, 9]
print("include multi for loop: ", list)

# 嵌套列表推导式
list = [ [x + y for x in range(3)] for y in range(4) ]
# [[0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5]]
print("embedded list: ", list)

# 带多个if条件，但是它们不能是并列的，必须嵌套
list = [ x*y for x in range(10) for y in range(10) if x % 2 == 0 if y % 2 == 0]
# [0, 0, 0, 0, 4, 4, 4, 4, 16, 16, 16, 16, 36, 36, 36, 36, 64, 64, 64, 64]
print("with multi if: ", list)

# 使用if-else条件，但是必须放在for循环之前
list = [ x if x % 2 == 0 else -x for x in range(10) ]
# [0, -1, 2, -3, 4, -5, 6, -7, 8, -9]
print("with if-else: ", list)
