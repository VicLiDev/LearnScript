#!/bin/python3
#########################################################################
# File Name: client.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Sun Sep 17 14:52:13 2023
#########################################################################

import socket

def main():
    # 1.创建一个udp套接字
    # 数据报格式套接字（Datagram Sockets）也叫“无连接的套接字”，在代码中使用 SOCK_DGRAM 表示。
    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    while True :
        send_data = input("Enter string to send：")

        # 2.准备接收方的地址
        # 127.0.0.1 表示目的地ip
        # 30000  表示目的地端口
        udp_socket.sendto(send_data.encode("utf-8"), ("127.0.0.1", 30000))

        if send_data == "quit" :
            break

    # 3.关闭套接字
    udp_socket.close()


if __name__ == "__main__":
    main()
