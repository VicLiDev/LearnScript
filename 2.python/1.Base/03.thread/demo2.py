# ======== 继承Thread类创建线程类 ========
#
# 通过继承 Thread 类，我们可以自定义一个线程类，从而实例化该类对象，获得子线程。
# 需要注意的是，在创建 Thread 类的子类时，必须重写从父类继承得到的 run() 方法。因为该方法即为要创建的子线程执行的方法，其功能如同第一种创建方法中的 action() 自定义函数。
# 下面程序，演示了如何通过继承 Thread 类创建并启动一个线程：


import threading
import time


#创建子线程类，继承自 Thread 类
class my_Thread(threading.Thread):
    def __init__(self,add):
        threading.Thread.__init__(self)
        self.add = add
    # 重写run()方法
    def run(self):
         for arc in self.add:
             time.sleep(1)
             #调用 getName() 方法获取当前执行该程序的线程名
             print(threading.current_thread().getName() +" "+ arc)



#定义为 run() 方法传入的参数
my_tuple = ("http://c.biancheng.net/python/",\
            "http://c.biancheng.net/shell/",\
            "http://c.biancheng.net/java/")


if __name__ == "__main__":
    #创建子线程
    mythread = my_Thread(my_tuple)
    #启动子线程
    mythread.start()
    #主线程执行此循环
    for i in range(5):
        time.sleep(1)
        print(threading.current_thread().getName())
