#!/usr/bin/env python
#########################################################################
# File Name: 4.thread_create.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:03:28 2024
#########################################################################

# 4. 使用线程池（concurrent.futures.ThreadPoolExecutor）： 线程池可以用来管理多个
#    线程，避免手动创建和销毁线程的开销。
from concurrent.futures import ThreadPoolExecutor

def my_function():
    print("method4: thread start")

# 创建线程池
with ThreadPoolExecutor(max_workers=3) as executor:
    # 提交任务到线程池
    executor.submit(my_function)
    executor.submit(my_function)
    # ...可以提交更多任务
