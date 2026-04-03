#!/usr/bin/env python
#########################################################################
# File Name: 6.thread_sync_rlock.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:15:44 2024
#########################################################################

# RLock是Lock的一个变种，允许同一个线程多次获取锁。

import threading

# 创建一个可重入锁对象
rlock = threading.RLock()

def locked_func():
    with rlock:  # 第一次获取锁
        print("First acquire")
        with rlock:  # 同一线程可以再次获取锁
            print("Second acquire")

# 创建并启动线程
thread = threading.Thread(target=locked_func)
thread.start()
thread.join()
