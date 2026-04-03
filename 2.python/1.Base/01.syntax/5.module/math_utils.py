#!/usr/bin/env python
#########################################################################
# File Name: math_utils.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:10:07 2024
#########################################################################

# 封装:
#   容器——>数据的封装
#   函数——>语句的封装
#   类——>方法和属性的封装
#   模块——>任何保存为.py的文件的代码（可以是.py，.pyc，.pyo）
#   包——>Python的模块可以按目录组织为包



# 导入模块
#   1、import  模块名    这种方法导入模块之后，如果想调用模块中的函数需要使用  <模块名>.<函数名>  的形式。
#   2、from  模块名  import  函数名    这种方法导入模块之后，如果想调用模块中的函数直接使用函数名即可。
#      如果想调用多个函数则用逗号隔开，如果想调用所有函数，可用“*”代替所有函数名。
#   3、import  模块名  as  新名字     这种方法相当于给模块改了名，调用函数时使用  <新名字>.<函数名>  的形式。

# 搜索路径
#   搜索路径是当需要导入一个文件时，Python会在这些路径下寻找，这些路径在Python中是一个列表。
#   首先查找的是当前目录下的文件，如果没有再去别的地方查找。
#   查看路径：import  sys     sys.path
#   如何添加搜索路径：sys.paht.append(‘<你的路径>’)
#   在linux的bash环境下查看Python路径的一种方法：rpm –ql python


# 包（package）
# 步骤：
#   1、创建一个文件夹，用于存放相关的文件，文件夹的名字即包的名字
#   2、在文件夹里边创建一个__init__.py的模块文件，内容可以为空，他可以告诉Python这个文件夹是一个包
#   3、将相关的模块或者扩展子包放入文件夹中
# 如何导入包的模块：import  <包名>.<模块名>
# 如何探索模块
#  打开Help中的Python Docs

# math_utils.py

def add(x, y):
    """返回两个数的和"""
    return x + y

def subtract(x, y):
    """返回两个数的差"""
    return x - y

def multiply(x, y):
    """返回两个数的乘积"""
    return x * y

def divide(x, y):
    """返回两个数的商。如果y为0，则返回错误信息"""
    if y == 0:
        return "Error: Division by zero is not allowed."
    else:
        return x / y
