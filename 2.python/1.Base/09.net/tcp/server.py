#!/bin/python3
#########################################################################
# File Name: server.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Sat Sep 16 11:47:16 2023
#########################################################################

import socket

# 创建socket
# 流格式套接字（Stream Sockets）也叫“面向连接的套接字”，在代码中使用 SOCK_STREAM 表示。
tcp_server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 本地信息
address = ('', 8080)

# 绑定
tcp_server_socket.bind(address)

tcp_server_socket.listen(128)

# 等待新的客户端连接
client_socket, clientAddr = tcp_server_socket.accept()
while True:
    # 接收对方发送过来的数据
    recv_data = client_socket.recv(1024)  # 接收1024个字节
    if recv_data:
        print('recv data:', recv_data.decode('gbk'))
    else :
        break
    client_socket.send(recv_data)
client_socket.close()


tcp_server_socket.close()
