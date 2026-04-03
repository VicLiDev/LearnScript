#!/usr/bin/env python
#########################################################################
# File Name: file_opt.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Sat 26 Oct 09:24:08 2024
#########################################################################

'''
open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None,
    closefd=True, opener=None)

fileObject.seek(offset[, whence])
offset: 开始的偏移量，也就是代表需要移动偏移的字节数
whence: 可选，默认值为 0。给offset参数一个定义，表示要从哪个位置开始偏移；
        0代表从文件开头开始算起，
        1代表从当前位置开始算起，
        2代表从文件末尾算起。
'''

def write_to_file(filename, data):
    """将数据写入文件"""
    with open(filename, 'w') as file:
        for line in data:
            file.write(line + '\n')

def read_file_to_list(filename):
    """逐行读取文件到列表中，不缓存整个文件"""
    lines = []
    with open(filename, 'r') as file:
        for line in file:
            lines.append(line.strip())  # 去掉行末的换行符
            '''
            strip() 方法用于移除字符串开头和结尾的空白字符（如空格、换行符、
            制表符等）。如果不带参数，它会默认去除行首和行尾所有类型的空白字符。
            如果提供参数，strip() 会移除参数中指定的字符。
            这里strip表示把头尾的'\n'去掉，split表示以空格来分割行数据，
            然后把处理后的行数据返回到list列表中
            list = line.strip('\n').split(' ')
            '''
    return lines

def read_file_all(filename):
    """一次性读取整个文件"""
    with open(filename, 'r') as file:
        content = file.read()
    return content

def read_lines(filename):
    """读取文件的每一行，返回列表"""
    with open(filename, 'r') as file:
        return file.readlines()

def read_first_line(filename):
    """读取文件的第一行"""
    with open(filename, 'r') as file:
        return file.readline().strip()

def tell_position(filename):
    """返回当前文件位置"""
    with open(filename, 'r') as file:
        file.read(10)  # 读取前10个字符
        return file.tell()

def append_to_file(filename, data):
    """追加数据到文件"""
    with open(filename, 'a') as file:
        for line in data:
            file.write(line + '\n')

def main():
    filename = 'example.txt'

    # 写入数据
    data_to_write = ['Hello, World!', 'This is a test.', 'Python file operations.']
    write_to_file(filename, data_to_write)

    # 逐行读取到列表
    lines = read_file_to_list(filename)
    print("逐行读取的内容:", lines)

    # 一次性读取整个文件
    content = read_file_all(filename)
    print("整个文件内容:\n", content)

    # 使用 readlines 读取文件内容
    lines_with_readlines = read_lines(filename)
    print("readlines 读取的内容:", [line.strip() for line in lines_with_readlines])

    # 读取第一行
    first_line = read_first_line(filename)
    print("第一行内容:", first_line)

    # 获取当前文件位置
    position = tell_position(filename)
    print("当前文件位置:", position)

    # 追加数据
    data_to_append = ['Appending this line.', 'And this one too.']
    append_to_file(filename, data_to_append)

    # 再次读取文件内容
    updated_lines = read_file_to_list(filename)
    print("更新后的文件内容:", updated_lines)

if __name__ == '__main__':
    main()
