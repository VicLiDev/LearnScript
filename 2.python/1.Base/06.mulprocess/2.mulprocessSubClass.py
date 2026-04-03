#!/usr/bin/python

from multiprocessing import  Process

#继承Process类
class MyProcess(Process):
    def __init__(self, name, idx):
        super(MyProcess, self).__init__()
        self.name = name
        self.idx = idx

    def run(self):
        print('test %s mul process idx:%d' % (self.name, self.idx))


if __name__ == '__main__':
    process_list = []
    # start 5 sub process
    for i in range(5):
        # instance process object
        p = MyProcess('Python', i)
        p.start()
        process_list.append(p)

    for i in process_list:
        p.join()

    print('test end')
