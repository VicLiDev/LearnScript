#!/usr/bin/env python
#########################################################################
# File Name: 1.sys_argv_getopt.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Tue 26 Nov 09:44:23 2024
#########################################################################

# test:
#   ./1.sys_argv.py -h
#   ./1.sys_argv.py -i inputfile -o outputfile

import sys, getopt


def main(argv):
    inputfile = ''
    outputfile = ''

    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print('usage: <exe> -i <inputfile> -o <outputfile>')
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print('usage: <exe> -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg

    print('input  file：', inputfile)
    print('output file：', outputfile)


def main2():
    # sys.argv[0] 是脚本名称，sys.argv[1:] 是传递的参数
    args = sys.argv[1:]  # 获取除脚本名称外的所有参数

    if len(args) == 0:
        print("no paras")
    else:
        print(f"exe  name: {sys.argv[0]}")
        print("para list:")
        # 遍历可迭代对象（如列表、元组或字符串）时，enumerate同时获取每个元素
        # 及其对应的索引。它可以让代码更简洁、更可读，尤其是在需要索引时。
        for i, arg in enumerate(args):
            print(f"  para {i+1}: {arg}")

if __name__ == "__main__":
    print("======> all info <======")
    print('para num :', len(sys.argv))
    print('para list:', str(sys.argv))
    print("======> method1 <======")
    main(sys.argv[1:])   # 过滤掉命令行中的文件名
    print("======> method2 <======")
    main2()
