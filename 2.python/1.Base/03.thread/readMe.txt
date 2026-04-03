Python 中，有关线程开发的部分被单独封装到了模块中，和线程相关的模块有以下 2 个：
    _thread：是 Python 3 以前版本中 thread 模块的重命名，此模块仅提供了低级别的、
             原始的线程支持，以及一个简单的锁。功能比较有限。正如它的名字所暗示的
             （以 _ 开头），一般不建议使用 thread 模块；
    threading：Python 3 之后的线程模块，提供了功能丰富的多线程支持，推荐使用。


这里以 threading 模块为例介绍线程创建。Python 主要通过两种方式来创建线程：
    1. 使用 threading 模块中 Thread 类的构造器创建线程。即直接对类 threading.Thread
       进行实例化创建线程，并调用实例化对象的 start() 方法启动线程。     对应 demo1
    2. 继承 threading 模块中的 Thread 类创建线程类。即用 threading.Thread 派生
       出一个新的子类，将新建类实例化创建线程，并调用其 start() 方法启动线程。 对应 demo2

