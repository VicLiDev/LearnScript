#!/usr/bin/env python
#########################################################################
# File Name: using_list.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:40:08 2024
#########################################################################

# 创建一个空列表
my_list = []

# 向列表中添加元素
my_list.append(1)
my_list.append(2)
my_list.append(3)

# 另一种添加元素的方式，使用加号（+）
my_list += [4, 5, 6]

# 访问列表中的元素
print("First element:", my_list[0])
print("Last element:", my_list[-1])  # 使用负数索引访问最后一个元素

# 修改列表中的元素
my_list[0] = 10
print("Modified list:", my_list)

# 删除列表中的元素
# 使用remove方法删除第一个匹配的元素
my_list.remove(2)
print("After removing 2:", my_list)

# 使用pop方法删除并返回指定索引的元素，如果不指定索引，则默认删除最后一个元素
popped_element = my_list.pop(2)  # 删除索引为2的元素（即原列表中的4）
print("Popped element:", popped_element)
print("After popping 4:", my_list)

# 遍历列表
for element in my_list:
    print(element)

# 使用列表推导式创建新列表
squared_list = [x**2 for x in my_list]
print("Squared list:", squared_list)

# 列表切片
print("First three elements:", my_list[:3])
print("Last two elements:", my_list[-2:])

# 列表排序
my_list.sort()  # 原地排序，不返回新列表
print("Sorted list:", my_list)

# 使用sorted函数进行排序，返回新列表，原列表不变
sorted_list = sorted(my_list, reverse=True)
print("Sorted list in descending order (new list):", sorted_list)

# 列表长度
print("Length of the list:", len(my_list))
