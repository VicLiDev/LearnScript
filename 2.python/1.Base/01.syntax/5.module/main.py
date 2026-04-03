#!/usr/bin/env python
#########################################################################
# File Name: main.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:10:07 2024
#########################################################################

# main.py

# 导入math_utils模块
import math_utils

# 使用math_utils模块中的函数
result_add = math_utils.add(5, 3)
print(f"5 + 3 = {result_add}")

result_subtract = math_utils.subtract(5, 3)
print(f"5 - 3 = {result_subtract}")

result_multiply = math_utils.multiply(5, 3)
print(f"5 * 3 = {result_multiply}")

result_divide = math_utils.divide(5, 3)
print(f"5 / 3 = {result_divide}")

# 尝试除以0（捕获可能的错误）
try:
    result_divide_zero = math_utils.divide(5, 0)
    print(f"5 / 0 = {result_divide_zero}")
except Exception as e:
    print(e)
