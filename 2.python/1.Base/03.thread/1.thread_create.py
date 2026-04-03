#!/usr/bin/env python
#########################################################################
# File Name: 1.thread_create.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:03:28 2024
#########################################################################

# 1. 继承threading.Thread类并重写run方法： 通过继承threading.Thread类，并重写其
#    run方法，可以在创建的线程中执行自定义的任务。

import threading

class MyThread(threading.Thread):
    def run(self):
        # 在这里编写线程要执行的任务
        print("method1: thread start")

# 创建并启动线程
thread = MyThread()
thread.start()
