#!/usr/bin/python

from multiprocessing import Process, Pipe

def testFun(conn):
    print('sub process send info:')
    conn.send('hello main process')
    print('sub process recv info:')
    print(conn.recv())
    conn.close()

if __name__ == '__main__':
    #关键点，pipe实例化生成一个双向管
    conn1, conn2 = Pipe()
    #conn2传给子进程
    p = Process(target=testFun, args=(conn2,))
    p.start()
    print('main proces recv info:')
    print(conn1.recv())
    print('main proces send info:')
    conn1.send("hello sub process")
    p.join()
    print('test end')
