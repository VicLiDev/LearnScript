def Fibonacci(n):
    if n < 1:
        print('输入错误！')
        return -1
    if n == 1 or n==2:
        return 1
    else:
        return Fibonacci(n-1) + Fibonacci(n-2)

result = Fibonacci(20)
if result != -1:
    print('总共有%d对小兔崽子诞生！'%result)
