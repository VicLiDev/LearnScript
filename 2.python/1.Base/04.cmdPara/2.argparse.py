#!/usr/bin/env python
#########################################################################
# File Name: 2.argparse.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Tue 26 Nov 10:00:11 2024
#########################################################################

# usage:
#   ./2.argparse.py -h
#   ./2.argparse.py -i min -o mout
#   ./2.argparse.py lhj -i min -o mout

import argparse

def main():
    # 创建解析器
    parser = argparse.ArgumentParser(description="cmd paras proc demo")

    # 定义位置参数
    # 是必须参数，在命令行中必须提供对应的值，程序运行时会按照定义的顺序解析
    # 这些参数。
    # 定义方式：直接使用 add_argument，且不给参数名前加 - 或 -- 前缀。
    parser.add_argument("name", help="user name")  # 必需参数
    # 定义可选参数
    # 可选参数是带有 - 或 -- 前缀的参数，用户可以选择性地提供这些参数。它们通常
    # 有默认值，若未提供则使用默认值。
    parser.add_argument("--age", type=int, default=18, help="user age")  # 带默认值的可选参数
    parser.add_argument("--verbose", action="store_true", help="dump info")  # 布尔值开关
    # 无论通过哪个别名（如 -i、--input 或 -inp）指定参数，所有别名最终都会绑定
    # 到一个统一的属性名，通常是根据长选项名称自动生成（去掉前导的 -- 并将 - 转换为 _）
    parser.add_argument("-i","--input","--inp", help="input file")
    parser.add_argument("-o","--output","--out", help="output file")

    # 解析命令行参数
    args = parser.parse_args()

    # 使用参数
    print(f"Hi, {args.name}!")
    print(f"Your age is: {args.age}")
    print(f"input  file: {args.input}")
    print(f"output file: {args.output}")

    if args.verbose:
        print("verbose was enabled")

if __name__ == "__main__":
    main()
