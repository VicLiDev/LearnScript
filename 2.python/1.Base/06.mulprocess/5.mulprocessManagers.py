#!/usr/bin/python

from multiprocessing import Process, Manager

def testFun(dic, lis, index):

    dic[index] = 'a'
    dic['2'] = 'b'    
    lis.append(index)    #[0,1,2,3,4,0,1,2,3,4,5,6,7,8,9]
    #print(l)

if __name__ == '__main__':
    with Manager() as manager:
        dic = manager.dict()#注意字典的声明方式，不能直接通过{}来定义
        l = manager.list(range(5))#[0,1,2,3,4]

        process_list = []
        for i in range(10):
            p = Process(target=testFun, args=(dic,l,i))
            p.start()
            process_list.append(p)

        for res in process_list:
            res.join()
        print(dic)
        print(l)
