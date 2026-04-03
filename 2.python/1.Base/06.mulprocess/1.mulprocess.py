#!/usr/bin/python

from multiprocessing import  Process

def testFun(name, idx):
    print("test %s mul process idx:%d" %(name, idx))

if __name__ == '__main__':
    process_list = []
    # start 5 sub process
    for i in range(5):
        # instance process object
        p = Process(target=testFun, args=('Python', i))
        p.start()
        process_list.append(p)

    for i in process_list:
        p.join()

    print('test end')
