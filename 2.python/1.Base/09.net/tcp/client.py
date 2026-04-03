#!/bin/python3
#########################################################################
# File Name: client.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Sat Sep 16 11:47:07 2023
#########################################################################

import socket

# 1.创建socket
# 流格式套接字（Stream Sockets）也叫“面向连接的套接字”，在代码中使用 SOCK_STREAM 表示。
tcp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 2. 链接服务器
server_addr = ("127.0.0.1", 8080)
tcp_socket.connect(server_addr)

# 3. 发送数据
while True :
    send_data = input("Enter string to send：")
    if send_data == "quit" :
        break
    tcp_socket.send(send_data.encode("gbk"))
    recv_data = tcp_socket.recv(1024)
    print("from server: %s" % recv_data.decode("gbk"))

# 4. 关闭套接字
tcp_socket.close()
