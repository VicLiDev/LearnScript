#!/usr/bin/env python
#########################################################################
# File Name: 2.thread_create.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:03:28 2024
#########################################################################

# 2. 通过threading.Thread类的实例化： 通过传递一个函数或者可调用对象作为target参数，
#    以及可选的args（位置参数）和kwargs（关键字参数）来创建线程。
import threading

def my_function():
    print("method2: thread start")

# 创建并启动线程
thread = threading.Thread(target=my_function)
thread.start()
