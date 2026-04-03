#!/usr/bin/python
# Filename: func_local.py

x=50 # 在函数外部创建全局变量

def func():
  global x
  print ('x is', x)
  x = 2
  print ('Changed local x to', x)

  global y # 在函数内部创建全局变量
  y = "hello"

func()
print('variable x is:', x)
print('variable y is:', y)
