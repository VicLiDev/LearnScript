#!/usr/bin/env python
#########################################################################
# File Name: 10.thread_sync_queue.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri 27 Sep 14:19:32 2024
#########################################################################

# 在这个例子中，生产者线程生产一系列的数字并将它们放入队列。消费者线程从队列中
# 取出数字并处理它们。队列确保了数据在生产者和消费者之间的安全传递。

# queue.Queue 是线程安全的，这意味着多个线程可以安全地向队列中添加或从队列中删除
# 项，而不需要额外的锁。这是因为它内部实现了必要的锁机制来防止竞态条件。

# 当使用队列时，还可以使用 q.join() 方法来阻塞调用线程，直到队列中的所有项都已被
# 处理。这在生产者生产完所有项后，确保所有项都被消费者处理完毕非常有用。在下面的
# 示例中，我们通过在消费者中检查特定的项来决定何时停止消费者线程。如果需要确保所
# 有项都被处理，可以在生产者线程结束时调用 q.join()。

import queue
import threading
import time

# 创建一个队列实例
q = queue.Queue()

# 生产者线程的任务函数
def producer():
    for i in range(5):
        print(f"生产者生产了 {i}")
        q.put(i)  # 将数据放入队列
        time.sleep(1)

# 消费者线程的任务函数
def consumer():
    while True:
        item = q.get()  # 从队列中获取数据
        print(f"消费者消费了 {item}")
        q.task_done()  # 通知队列，当前item已经处理完成
        if item == 4:  # 假设当生产到4时，消费者可以停止
            break

# 创建生产者和消费者线程
producer_thread = threading.Thread(target=producer)
consumer_thread = threading.Thread(target=consumer)

# 启动线程
producer_thread.start()
consumer_thread.start()

# 等待线程完成
producer_thread.join()
consumer_thread.join()
