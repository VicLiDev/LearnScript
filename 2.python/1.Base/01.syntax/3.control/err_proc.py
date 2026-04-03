#!/bin/python3
#########################################################################
# File Name: 1.Base/1.syntax/3.control/try_except.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Mon Sep 11 09:19:21 2023
#########################################################################

# reference: https://www.runoob.com/python/python-exceptions.html

# Python提供了两个非常重要的功能来处理程序在运行中出现的异常和错误
# 1. try...except语句，（拓展：try-except-else-finally）
# 2. 另一个是断言

# try：正常情况下，程序计划执行的语句。
# except：程序异常是执行的语句。
# else：程序无异常即try段代码正常执行后会执行该语句。
# finally：不管有没有异常，都会执行的语句。

# 语法规则：
# try:
#   <...>        #运行别的代码
# except <name>:
#   <语句>        #如果在try部份引发了'name'异常
# except <name>，<data>:
#   <...>        #如果引发了'name'异常，获得附加的数据
# except:
#   <...>        # 这里会捕捉所有异常
# else:
#   <...>        #如果没有异常发生




# normal: try --> else --> finally
# error: try --> except --> finally

def divNoRET(num):
  try:
    a = 5.0 / num
    print('in try')
  except:
    print('in except')
  else:
    print('in else')
  finally:
    print('finally')

# 无论是否出现异常，finally 都会被强制执行：
# 1. 如果finally存在return时，最终返回的是finally代码块的返回值
# 2. 如果finally代码块没有返回值，则前边代码块的返回值会有效

# 当 finally 中没有返回值时：
# 1. 正常状态下：try --> finally
#     这里try模块中存在return，会导致不执行 else 代码块，如果try中没有return，则执行
#     顺序为： try --> else --> finally
# 2. 异常状态下：try --> except --> finally
#     因此except中的返回值有效

def divIncRET(num):
  try:
    a = 5.0 / num
    print('in try')
    return 0
  except:
    print('in except')
    return 1
  else:
    print('in else')
    return 2
  finally:
    print('finally')
    # return 3

# 捕捉python标准异常
def standardexception(num):
  try:
    a = 5.0 / num
    print('in try')
  except ZeroDivisionError as info:
  # except ZeroDivisionError: # 也可以不接收异常信息
    print('in div zero')
    print(info)
  else:
    print('in else')
  finally:
    print('finally')

# 自定义异常
# 触发异常：raise [Exception [, args [, traceback]]]
def selfDefErr(num):
  try:
    if (num > 3):
      # 创建异常对象并主动抛出
      raise Exception("Invalid level!", num)

      # #a.创建异常对象
      # ex = Exception("Invalid level!")
      # #b.主动抛出
      # raise ex

  # Exception 是标准错误异常中的 常规错误的基类，几乎可以捕获所有异常
  # 其他标准错误异常可以查看参考文档
  except Exception as err:
    print(err)

if __name__ == "__main__":

  print("====== no ret ======")
  print("==> test div 0")
  divNoRET(0)
  print("==> test div 1")
  divNoRET(1)

  print("====== with ret ======")
  print("==> test div 0")
  print('divIncRET: ', divIncRET(0))
  print("==> test div 1")
  print('divIncRET: ', divIncRET(1))

  print("====== standard exception ======")
  standardexception(0)

  print("====== self def err ======")
  selfDefErr(0)
  selfDefErr(6)

  print("====== with ======")
  with open('./test_runoob.txt', 'w') as file:
    file.write('hello world !')
  # 等价于
  # file = open('./test_runoob.txt', 'w')
  # try:
  #   file.write('hello world')
  # finally:
  #   file.close()
  # 使用 with 关键字系统会自动调用 f.close() 方法， with 的作用等效于
  # try/finally 语句是一样的。
  #
  # 验证file是否已经关闭：
  print("file is closed: {}".format(file.closed))

  print("====== assert ======")
  # 语法：assert expression
  # 等价于：
  # if not expression:
  #   raise AssertionError
  assert (0 != 0),'div should not be 0'
