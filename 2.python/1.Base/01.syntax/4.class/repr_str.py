#!/usr/bin/env python
#########################################################################
# File Name: repr_str.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Wed 11 Dec 09:31:50 2024
#########################################################################

'''
__repr__ 的作用
  当调用 repr(object) 时，会触发对象的 __repr__ 方法。
  在交互式解释器中输入一个对象后，直接回车时，默认会调用 __repr__。
  它主要用于开发和调试，应该尽量提供全面且准确的信息。

与 __str__ 的区别
  __repr__ 的目标是为开发者服务，提供对象的正式和精准表示。其返回值通常是可以用于
  重新创建该对象的字符串。
  __str__ 则是为用户设计的，提供对象的简洁和易读描述，适合用作人类可读的输出。

当同时定义了 __repr__ 和 __str__ 时：
  print(object) 调用的是 __str__。
  如果没有定义 __str__，但定义了 __repr__，则 print(object) 也会调用 __repr__。

明确区分 __repr__ 和 __str__ 的用途：
  如果需要打印用户友好的描述，就实现 __str__。
  如果只需要调试信息，确保 __repr__ 的内容详尽。
'''


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Point(x={self.x}, y={self.y})"

    def __str__(self):
        return f"({self.x}, {self.y})"

# 创建对象
p = Point(1, 2)

# 调用 repr
print(repr(p))  # 输出: Point(x=1, y=2)

# 调用 str
print(str(p))   # 输出: (1, 2)

# 直接输出对象（交互式解释器会显示 __repr__ 的结果）
print(p)        # 输出: (1, 2)

# eval 是一个强大的内置函数，用于动态地执行一个字符串表达式，并返回其结果
new_p = eval(repr(p))
print(new_p)    # 输出: (1, 2)
