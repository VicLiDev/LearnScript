#!/usr/bin/env python3
#########################################################################
# UDP Echo 客户端
#
# 与 TCP 客户端的区别：
#   - 不需要 connect，直接 sendto 发送
#   - 每次 sendto 都要指定目标地址（因为无连接）
#   - 接收用 recvfrom，可以获知数据来自哪个地址
#   - 可能丢包，所以设置了接收超时
#########################################################################

import socket


def main():
    server_addr = ("127.0.0.1", 30000)
    # 1. 创建 UDP socket（无连接）
    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # 设置接收超时 3 秒，避免 recvfrom 永久阻塞
    udp_socket.settimeout(3.0)

    try:
        # 2. 收发循环
        while True:
            try:
                send_data = input("Enter string to send: ")
            except (EOFError, KeyboardInterrupt):
                print("\n[UDP Client] exiting...")
                break

            is_quit = (send_data == "quit")

            # 3. 发送数据报到服务器（无连接，直接发）
            udp_socket.sendto(send_data.encode("utf-8"), server_addr)

            if is_quit:
                break

            # 4. 接收服务器回显
            try:
                recv_data, _ = udp_socket.recvfrom(1024)
                print(f"  from server: {recv_data.decode('utf-8')}")
            except socket.timeout:
                # UDP 不可靠，可能丢包，超时是正常的
                print("[UDP Client] timeout, no response from server")
    finally:
        # 5. 关闭 socket
        udp_socket.close()
        print("[UDP Client] closed")


if __name__ == "__main__":
    main()
