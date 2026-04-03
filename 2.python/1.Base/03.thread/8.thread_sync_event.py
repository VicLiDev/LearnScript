#!/usr/bin/env python
#########################################################################
# File Name: 8.thread_sync_event.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:17:32 2024
#########################################################################

# Event 事件对象允许一个线程通知一个或多个线程某些事件已经发生。

import threading

# 创建一个事件对象
event = threading.Event()

def wait_for_event():
    print("Waiting for event to be set")
    event.wait()  # 等待事件被设置
    print("Event is set")

def set_event():
    print("Setting event")
    event.set()  # 设置事件

# 创建线程
thread1 = threading.Thread(target=wait_for_event)
thread2 = threading.Thread(target=set_event)

# 启动线程
thread1.start()
thread2.start()

# 等待线程完成
thread1.join()
thread2.join()

