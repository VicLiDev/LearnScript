#!/usr/bin/env python3
#########################################################################
# UDP Echo 服务器
#
# UDP 与 TCP 的核心区别：
#   - 无连接：不需要 listen/accept，bind 后直接 recvfrom
#   - 面向消息：recvfrom 返回完整数据报，保留消息边界
#   - 不可靠：数据可能丢失、乱序、重复（但本 demo 在本地测试不受影响）
#   - recvfrom 返回 (data, addr)，addr 可用于 sendto 回复
#########################################################################

import socket
import signal


def main():
    host = "0.0.0.0"
    port = 30000

    # 1. 创建数据报 socket
    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # 允许端口重用
    udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    # 2. 绑定地址和端口（UDP 不需要 listen）
    udp_socket.bind((host, port))
    # 设置 timeout 配合信号优雅退出：recvfrom() 每 2 秒超时回到循环顶，
    # 让 Ctrl+C 信号有机会被响应。超时不会丢包，内核收到数据后放入缓冲区
    udp_socket.settimeout(2.0)
    print(f"[UDP Server] listening on {host}:{port}")

    running = True

    def graceful_shutdown(signum, frame):
        nonlocal running
        print("\n[UDP Server] shutting down...")
        running = False
        # 关闭 socket 让 recvfrom() 抛出 OSError，循环退出
        udp_socket.close()

    signal.signal(signal.SIGINT, graceful_shutdown)
    signal.signal(signal.SIGTERM, graceful_shutdown)

    # 3. 主循环：接收并回显数据报
    while running:
        try:
            # recvfrom 返回 (数据, 发送方地址)
            recv_data, client_addr = udp_socket.recvfrom(1024)
        except socket.timeout:
            continue  # 超时后继续等待
        except OSError:
            break  # socket 已关闭

        data_str = recv_data.decode("utf-8")
        print(f"  recv from {client_addr}: {data_str.strip()}")

        if data_str.strip() == "quit":
            print("[UDP Server] received quit, shutting down...")
            break

        # 4. 原样回显给发送方
        # 注意：UDP 不需要对方事先建立连接，直接用 sendto 发送
        udp_socket.sendto(recv_data, client_addr)

    udp_socket.close()
    print("[UDP Server] closed")


if __name__ == "__main__":
    main()
