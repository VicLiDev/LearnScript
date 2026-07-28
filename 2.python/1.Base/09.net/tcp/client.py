#!/usr/bin/env python3
#########################################################################
# TCP Echo Client
#
# 流程：
#   1. 创建 socket → connect 到服务器
#   2. 循环：从键盘读入 → send 发送 → recv 接收回显 → 打印
#   3. 输入 "quit" 退出
#########################################################################

import socket


def main():
    server_addr = ("127.0.0.1", 18080)
    # 1. 创建 TCP socket
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 2. 连接到服务器（三次握手）
    try:
        client_socket.connect(server_addr)
        print(f"[TCP Client] connected to {server_addr}")
    except ConnectionRefusedError:
        # 服务器未启动或端口不对
        print(f"[TCP Client] server {server_addr} refused connection")
        return
    except Exception as e:
        print(f"[TCP Client] connect failed: {e}")
        return

    try:
        # 3. 收发循环
        while True:
            try:
                send_data = input("Enter string to send: ")
            except (EOFError, KeyboardInterrupt):
                # EOF: 管道输入结束或 Ctrl+D
                # KeyboardInterrupt: Ctrl+C
                print("\n[TCP Client] exiting...")
                break

            if send_data == "quit":
                break

            try:
                # 发送数据（编码为 utf-8 字节）
                client_socket.send(send_data.encode("utf-8"))
                # 接收服务器回显
                recv_data = client_socket.recv(1024)
                print(f"  from server: {recv_data.decode('utf-8')}")
            except ConnectionResetError:
                # 服务器主动断开连接
                print("[TCP Client] server reset connection")
                break
            except ConnectionAbortedError:
                # 本机主动中止连接
                print("[TCP Client] connection aborted")
                break
    finally:
        # 4. 关闭 socket，发送 FIN 包（四次挥手）
        client_socket.close()
        print("[TCP Client] closed")


if __name__ == "__main__":
    main()
