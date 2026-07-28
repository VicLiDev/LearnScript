#!/usr/bin/env python3
#########################################################################
# Unix Domain Socket 数据报（Dgram）客户端
#
# SOCK_DGRAM 对标 UDP：面向消息、保留边界、无需连接。
# 本质是单机进程间通信（IPC），走内核内存拷贝而非网络协议栈。
# 与 UDP 客户端的关键差异：
#   1. 必须 bind 自己的地址才能接收服务端回包
#   2. 通信是可靠的（不丢包、不乱序）
#   3. connect/sendto 用文件路径而非 IP:Port，仅限本机通信
#########################################################################

import os
import socket

# 服务端的 socket 文件地址，由服务端 bind() 时创建
SERVER_PATH = "/tmp/unix_dgram_server.sock"
# 客户端自己的地址，Unix dgram 客户端必须 bind 才能接收回包
CLIENT_PATH = "/tmp/unix_dgram_client.sock"  # 客户端必须有自己的地址


def main():
    # 清理上次残留的客户端 socket 文件
    if os.path.exists(CLIENT_PATH):
        os.unlink(CLIENT_PATH)

    # 1. 创建 Unix 域数据报 socket
    client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
    # 2. 客户端必须 bind 自己的地址 — 这是与 UDP 最大的不同
    #    不 bind 的话 sendto 能发出，但永远收不到回包
    client_socket.bind(CLIENT_PATH)
    # 限制 socket 文件权限为仅属主可读写
    os.chmod(CLIENT_PATH, 0o600)
    client_socket.settimeout(3.0)
    print(f"[Unix Dgram Client] bound to {CLIENT_PATH}")

    try:
        # 3. 收发循环
        while True:
            try:
                send_data = input("Enter string to send: ")
            except (EOFError, KeyboardInterrupt):
                print("\n[Unix Dgram Client] exiting...")
                break

            is_quit = (send_data == "quit")

            try:
                # 发送数据报到服务器的路径
                client_socket.sendto(send_data.encode("utf-8"), SERVER_PATH)
            except FileNotFoundError:
                print(f"[Unix Dgram Client] server not running (no socket at {SERVER_PATH})")
                break

            if is_quit:
                break

            try:
                # 接收服务器回显
                recv_data, _ = client_socket.recvfrom(1024)
                print(f"  from server: {recv_data.decode('utf-8')}")
            except socket.timeout:
                print("[Unix Dgram Client] timeout, no response from server")
    finally:
        # 4. 关闭 socket 并清理残留文件
        client_socket.close()
        if os.path.exists(CLIENT_PATH):
            os.unlink(CLIENT_PATH)
        print("[Unix Dgram Client] closed")


if __name__ == "__main__":
    main()
