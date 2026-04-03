#!/usr/bin/env python
#########################################################################
# File Name: using_dict.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:40:50 2024
#########################################################################

# 创建一个空字典
my_dict = {}

# 向字典中添加键值对
my_dict['name'] = 'Alice'
my_dict['age'] = 30
my_dict['city'] = 'New York'

# 访问字典中的值
print("Name:", my_dict['name'])
print("Age:", my_dict['age'])
print("City:", my_dict.get('city'))  # 使用get方法更安全，因为当键不存在时不会抛出异常，而是返回None

# 修改字典中的值
my_dict['age'] = 31
print("Updated Age:", my_dict['age'])

# 删除字典中的键值对
del my_dict['city']
print("After deleting 'city':", my_dict)

# 检查键是否存在
if 'city' in my_dict:
    print("City is still in the dictionary.")
else:
    print("City is not in the dictionary.")

# 遍历字典的键
for key in my_dict:
    print(key)

# 遍历字典的键值对
for key, value in my_dict.items():
    print(f"{key}: {value}")

# 使用字典推导式创建新字典
new_dict = {key.upper(): value for key, value in my_dict.items()}
print("New Dictionary with upper case keys:", new_dict)

# 合并两个字典
another_dict = {'job': 'Engineer', 'hobbies': ['reading', 'traveling']}
merged_dict = {**my_dict, **another_dict}  # Python 3.5+
print("Merged Dictionary:", merged_dict)
