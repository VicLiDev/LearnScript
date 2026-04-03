#!/usr/bin/env python
#########################################################################
# File Name: 7.thread_sync_condition.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:16:49 2024
#########################################################################

# Condition 条件变量允许一个或多个线程等待，直到它们被另一个线程通知。

import threading

# 创建一个条件变量
condition = threading.Condition()

def consumer():
    with condition:
        condition.wait()  # 等待通知
        print("Consumer notify")

def producer():
    with condition:
        print("Producer notify")
        condition.notify()  # 通知一个等待的线程

# 创建线程
consumer_thread = threading.Thread(target=consumer)
producer_thread = threading.Thread(target=producer)

# 启动线程
consumer_thread.start()
producer_thread.start()

# 等待线程完成
consumer_thread.join()
producer_thread.join()

