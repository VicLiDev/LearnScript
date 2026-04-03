#!/usr/bin/env python
#########################################################################
# File Name: 3.thread_create.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:03:28 2024
#########################################################################

# 3. 使用threading.Thread类的target参数传递类实例的方法： 可以传递一个类实例的方法
#    作为target。
import threading

class MyClass:
    def my_method(self):
        print("method3: thread start")

# 创建类实例
my_instance = MyClass()

# 创建并启动线程，传递类实例的方法
thread = threading.Thread(target=my_instance.my_method)
thread.start()

