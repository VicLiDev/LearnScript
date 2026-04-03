#!/usr/bin/python

from multiprocessing import Process,Queue

def testFun(q, i):
    print('sub process %s start put data' % i)
    q.put('I am process %s trans data by Queue' % i)

if __name__ == '__main__':
    q = Queue()

    process_list = []
    for i in range(3):
        #注意args里面要把q对象传给我们要执行的方法，这样子进程才能和主进程用Queue来通信
        p = Process(target=testFun, args=(q,i))
        p.start()
        process_list.append(p)

    for i in process_list:
        p.join()

    print('main process catch Queue data')
    print(q.get())
    print(q.get())
    print(q.get())
    print('test end')
