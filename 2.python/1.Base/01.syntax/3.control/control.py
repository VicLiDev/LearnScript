#!/usr/bin/env python
#########################################################################
# File Name: control.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:51:35 2024
#########################################################################

def main():
    # 调用各个演示控制流方法的函数
    demonstrate_if_elif_else()
    demonstrate_for_loop()
    demonstrate_while_loop()
    demonstrate_break_continue()
    demonstrate_try_except()

def demonstrate_if_elif_else():
    number = 5
    if number > 10:
        print("Number is greater than 10")
    elif number == 10:
        print("Number is equal to 10")
    else:
        print("Number is less than 10")

def demonstrate_for_loop():
    fruits = ["apple", "banana", "cherry"]
    for fruit in fruits:
        print(fruit)

def demonstrate_while_loop():
    count = 0
    while count < 5:
        print(f"Count is {count}")
        count += 1

def demonstrate_break_continue():
    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    for number in numbers:
        if number % 2 == 0:
            continue  # 跳过偶数
        if number > 5:
            break     # 退出循环
        print(number)

def demonstrate_try_except():
    try:
        # 尝试执行可能会引发异常的代码
        result = 10 / 0
    except ZeroDivisionError:
        # 处理除数为0的异常
        print("Cannot divide by zero.")
    finally:
        # 无论是否发生异常都会执行的代码块
        print("This block will always execute.")

if __name__ == "__main__":
    main()
