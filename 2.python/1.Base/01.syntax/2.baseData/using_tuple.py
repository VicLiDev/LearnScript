#!/usr/bin/env python
#########################################################################
# File Name: using_tuple.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:41:55 2024
#########################################################################

# 创建一个元组
my_tuple = (1, 'Hello', 3.14, [1, 2, 3])

# 访问元组中的元素
print("First element:", my_tuple[0])
print("Second element:", my_tuple[1])

# 遍历元组
for element in my_tuple:
    print(element)

# 元组是不可变的，所以不能像列表那样直接修改元素
# 下面这行代码会引发TypeError
# my_tuple[0] = 10  # TypeError: 'tuple' object does not support item assignment

# 但是，如果元组中包含可变类型（如列表），那么可以修改这些可变类型的元素
my_tuple[3][0] = 0  # 修改元组中列表的第一个元素
print("Modified tuple (with mutable element inside):", my_tuple)

# 元组支持切片操作
print("First two elements:", my_tuple[:2])

# 元组支持连接（concatenation）
another_tuple = (4, 'World', True)
combined_tuple = my_tuple + another_tuple
print("Combined tuple:", combined_tuple)

# 元组支持重复（multiplication）
repeated_tuple = my_tuple * 2
print("Repeated tuple:", repeated_tuple)

# 元组还支持一些内置函数，如len()来获取长度，max()和min()（如果元组中的元素支持）
print("Length of the tuple:", len(my_tuple))
# 注意：如果元组包含不同类型的元素，max()和min()可能不会按预期工作
try:
    print("Max element:", max(my_tuple))  # 这将按字典序比较，可能不是你想要的结果
except TypeError as e:
    print(f"TypeError: {e}")

# 如果元组包含可比较的类型，则max()和min()将按预期工作
num_tuple = (1, 5, 3, 9, 2)
print("Max element in num_tuple:", max(num_tuple))
print("Min element in num_tuple:", min(num_tuple))

# 元组作为字典的键（因为元组是不可变的）
my_dict = {(1, 'a'): 'value1', (2, 'b'): 'value2'}
print("Dictionary with tuple keys:", my_dict)
