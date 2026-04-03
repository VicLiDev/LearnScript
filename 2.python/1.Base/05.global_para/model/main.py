import time
import threading

import global_paras
import update_para

global_paras._init()

var1 = 1
var2 = 2
var3 = 3

global_paras.set_value('var1', var1)
global_paras.set_value('var2', var2)
global_paras.set_value('var3', var3)
global_paras.global_var = 4


print('var1', global_paras.get_value('var1'))
print('var2', global_paras.get_value('var2'))
print('var3', global_paras.get_value('var3'))
print("global_var ", global_paras.global_var)


# 其他进程修改无效,可以调用modify_para.py 测试
# 当前进程，其他模块修改有效
update_para.update(4, 5, 6)
global_paras.global_var = 7
print('var1' , global_paras.get_value('var1'))
print('var2' , global_paras.get_value('var2'))
print('var3' , global_paras.get_value('var3'))
print("global_var ", global_paras.global_var)

# 其他线程修改有效
def thread_act(*para):
    var1 = 0
    var2 = 1
    var3 = 2
    while True:
        var1 = var1 + 1
        var2 = var2 + 1
        var3 = var3 + 1
        global_paras.set_value('var1', var1)
        global_paras.set_value('var2', var2)
        global_paras.set_value('var3', var3)
        global_paras.global_var = var3 + 1
        time.sleep(1)

thread = threading.Thread(target = thread_act)
thread.start()


print("======> loop prn <======")
loop = 0
while True:
    print("======> loop", loop)
    loop = loop + 1
    print('var1' , global_paras.get_value('var1'))
    print('var2' , global_paras.get_value('var2'))
    print('var3' , global_paras.get_value('var3'))
    print("global_var ", global_paras.global_var)
    time.sleep(1)
