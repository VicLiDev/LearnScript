# ======== 调用Thread类的构造器创建线程 ========
#
# Thread 类提供了如下的 __init__() 构造器，可以用来创建线程：
#     __init__(self, group=None, target=None, name=None, args=(), kwargs=None, *,daemon=None)
#
# 此构造方法中，以上所有参数都是可选参数，即可以使用，也可以忽略。其中各个参数的含义如下：
#     group：指定所创建的线程隶属于哪个线程组（此参数尚未实现，无需调用）；
#     target：指定所创建的线程要调度的目标方法（最常用）；
#     args：以元组的方式，为 target 指定的方法传递参数；
#     kwargs：以字典的方式，为 target 指定的方法传递参数；
#     daemon：指定所创建的线程是否为后代线程。
#
# 这些参数，初学者只需记住 target、args、kwargs 这 3 个参数的功能即可。
# 默认情况下，主线程的名字为 MainThread，用户启动的多个线程的名字依次为 Thread-1、Thread-2、Thread-3、...、Thread-n 等。
#
# 创建线程之后需要手动启动才能运行，threading 模块提供了 start() 方法用来启动线程。
# 

import threading
import time


#定义线程要调用的方法，*add可接收多个以非关键字方式传入的参数
def action(*add):
    for arc in add:
        time.sleep(1)
        #调用 getName() 方法获取当前执行该程序的线程名
        print(threading.current_thread().getName() +" "+ arc)


#定义为线程方法传入的参数
my_tuple = ("http://c.biancheng.net/python/",\
            "http://c.biancheng.net/shell/",\
            "http://c.biancheng.net/java/")

if __name__ == "__main__":
    #创建线程
    thread = threading.Thread(target = action, args = my_tuple)
    thread.start()

    for i in range(5):
        time.sleep(1)
        print(threading.current_thread().getName())
