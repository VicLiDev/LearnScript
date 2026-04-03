#!/usr/bin/env python
#########################################################################
# File Name: func.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:00:17 2024
#########################################################################

# 全局变量示例
global_var = "这是一个全局变量"

def print_function_documentation(func):
    """打印函数的文档字符串"""
    print(func.__doc__)

def my_function(x, y):
    """
    这个函数接受两个参数x和y，并返回它们的和。

    参数:
    x (int): 第一个加数
    y (int): 第二个加数

    返回:
    int: x和y的和
    """
    # 局部变量示例
    local_var = x + y
    return local_var

def use_global_and_local_variables():
    """
    这个函数展示了全局变量和局部变量的使用。
    它修改了一个全局变量，并定义了一个局部变量。
    """
    global global_var  # 声明要修改全局变量
    global_var = "全局变量已被修改"
    local_var = "这是一个局部变量"
    print(f"全局变量: {global_var}")
    print(f"局部变量: {local_var}")

def example_with_lambda():
    """
    这个函数展示了lambda表达式的使用。
    Lambda表达式用于创建匿名函数对象。

    基本语法: lambda arguments: expression
        arguments：输入参数，可以有多个
        expression：执行的单行表达式，返回结果
    """
    # lambda表达式，接受两个参数并返回它们的和
    add = lambda x, y: x + y
    print(f"使用lambda表达式: {add(5, 3)}")

    # 另一个lambda表达式，将列表中的每个元素乘以2
    numbers = [1, 2, 3, 4, 5]
    doubled = list(map(lambda x: x * 2, numbers))
    print(f"列表元素乘以2: {doubled}")

    # 使用 lambda 创建一个嵌套函数
    multiply = lambda x: lambda y: x * y
    double = multiply(2)
    print(f"lambda: {double(5)}")  # 输出: 10

    # 用 lambda 实现条件表达式
    max_num = lambda a, b: a if a > b else b
    print(f"lambda: {max_num(10, 20)}")  # 输出: 20


def map_usage():
    '''
    map 函数将一个函数应用到一个可迭代对象的每个元素上，并返回一个迭代器。
    语法 map(function, iterable)
        function：一个单参数函数，用于处理每个元素。
        iterable：一个可迭代对象（如列表、元组等）。
    '''
    # 将所有元素平方
    nums = [1, 2, 3, 4]
    squared = list(map(lambda x: x**2, nums))
    print(f"map usage: {squared}")  # 输出: [1, 4, 9, 16]
    print(f"map usage: {type(squared)}")

    # 将数字转换为字符串
    nums = [1, 2, 3]
    str_nums = list(map(str, nums))
    print(f"map usage: {str_nums}")  # 输出: ['1', '2', '3']

    # 对两个列表逐元素相加
    nums1 = [1, 2, 3]
    nums2 = [4, 5, 6]
    sum_lists = list(map(lambda x, y: x + y, nums1, nums2))
    print(f"map usage: {sum_lists}")  # 输出: [5, 7, 9]

def filter_usage():
    '''
    filter 函数用于从可迭代对象中筛选出满足特定条件的元素，返回一个迭代器
    语法: filter(function, iterable)
        function：一个返回布尔值的函数，用于测试每个元素
        iterable：一个可迭代对象
    '''
    # 筛选出偶数
    nums = [1, 2, 3, 4, 5, 6]
    even_nums = list(filter(lambda x: x % 2 == 0, nums))
    print(f"filter: {even_nums}")  # 输出: [2, 4, 6]

    # 筛选出长度大于3的字符串
    words = ["cat", "elephant", "dog", "hippopotamus"]
    long_words = list(filter(lambda x: len(x) > 3, words))
    print(f"filter: {long_words}")  # 输出: ['elephant', 'hippopotamus']

def sorted_usage():
    '''
    sorted 函数用于对可迭代对象进行排序，返回一个新的列表
    语法: sorted(iterable, key=None, reverse=False)
        iterable：要排序的可迭代对象
        key：一个函数，用于从每个元素中提取比较的关键字（可选）
        reverse：一个布尔值。如果为 True，则降序排序；默认为升序排序
    '''

    # 对数字列表排序
    nums = [5, 2, 9, 1]
    sorted_nums = sorted(nums)
    print(f"sorted: {sorted_nums}")  # 输出: [1, 2, 5, 9]

    # 按字符串长度排序
    words = ["cat", "elephant", "dog", "hippopotamus"]
    sorted_words = sorted(words, key=lambda x: len(x))
    print(f"sorted: {sorted_words}")  # 输出: ['cat', 'dog', 'elephant', 'hippopotamus']

    # 降序排序
    nums = [5, 2, 9, 1]
    sorted_nums_desc = sorted(nums, reverse=True)
    print(f"sorted: {sorted_nums_desc}")  # 输出: [9, 5, 2, 1]

    # 按元组的第二个元素排序
    items = [(1, 'apple'), (3, 'banana'), (2, 'cherry')]
    sorted_items = sorted(items, key=lambda x: x[1])
    print(f"sorted: {sorted_items}")  # 输出: [(1, 'apple'), (3, 'banana'), (2, 'cherry')]



def main():
    # 打印函数文档
    print_function_documentation(my_function)

    # 调用函数并打印返回值
    result = my_function(5, 3)
    print(f"my_function的返回值: {result}")

    # 展示全局变量和局部变量的使用
    use_global_and_local_variables()

    # 展示lambda表达式的使用
    example_with_lambda()

    # map usage
    map_usage()

    # filter usage
    filter_usage()

    # sorted usage
    sorted_usage()

if __name__ == "__main__":
    main()
