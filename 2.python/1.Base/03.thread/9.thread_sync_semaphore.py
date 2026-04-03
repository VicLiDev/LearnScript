#!/usr/bin/env python
#########################################################################
# File Name: 9.thread_sync_semaphore.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:18:07 2024
#########################################################################

# Semaphore 信号量是一个更高级的同步原语，用于控制对资源的访问数量。

import threading
import time

# 创建一个信号量对象，允许最多3个线程同时访问
semaphore = threading.Semaphore(3)

def access_resource():
    with semaphore:
        print(f"{threading.current_thread().name} is accessing the shared resource")
        time.sleep(2)

# 创建多个线程
threads = [threading.Thread(target=access_resource) for _ in range(10)]

# 启动所有线程
for thread in threads:
    thread.start()

# 等待所有线程完成
for thread in threads:
    thread.join()

