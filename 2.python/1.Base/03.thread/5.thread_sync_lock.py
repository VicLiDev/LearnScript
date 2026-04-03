#!/usr/bin/env python
#########################################################################
# File Name: 5.thread_sync_lock.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:13:41 2024
#########################################################################

# Lock锁是最基本的同步原语，用于确保只有一个线程可以访问某个资源。

import threading

# 创建一个锁对象
lock = threading.Lock()

# 定义一个共享资源
shared_resource = 0

def increment():
    global shared_resource
    with lock:  # 使用with语句自动获取和释放锁
        shared_resource += 1
        print(f"Resource value after increment: {shared_resource}")

# 创建多个线程
threads = [threading.Thread(target=increment) for _ in range(10)]

# 启动所有线程
for thread in threads:
    thread.start()

# 等待所有线程完成
for thread in threads:
    thread.join()
