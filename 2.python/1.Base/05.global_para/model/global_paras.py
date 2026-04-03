# -*- coding: utf-8 -*-

# 参考: https://zhuanlan.zhihu.com/p/349108535

# 这种使用一个单独的文件定义全局变量的方法，实际上使用的是单独模块在一个进程中
# 的特性，即其他线程或者本线程修改模块的值，都会体现在当前进程中，因此这里无论
# 使用方法一或者方法二，都是可以的，方法一的global只是为了定义一个其他函数也可
# 以访问的变量而已

# 方法一
def _init():  # 初始化
    global _global_dict # 在函数中创建全局变量
    _global_dict = {}

def set_value(key, value):
    #定义一个全局变量
    _global_dict[key] = value

def get_value(key):
    #获得一个全局变量，不存在则提示读取对应变量失败
    try:
        return _global_dict[key]
    except:
        print('read'+key+'fail\r\n')

# 方法二
global_var = 0
