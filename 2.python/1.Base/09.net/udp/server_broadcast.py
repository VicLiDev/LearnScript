#!/usr/bin/env python3
#########################################################################
# UDP 广播接收端
#
# 接收广播包的要点：
#   - bind 到 0.0.0.0 和广播端口，监听从任意网卡来的数据
#   - 需要 SO_BROADCAST 选项才能接收广播包（部分系统要求）
#   - 收到数据后 recvfrom 会返回发送方地址，可以区分来源
#########################################################################

import socket
import signal


def main():
    host = "0.0.0.0"     # 监听所有网卡
    port = 37020

    # 创建 UDP socket
    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # 允许端口重用（多个接收端可以 bind 同一端口）
    udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    # 允许接收广播包
    udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    # 绑定端口
    udp_socket.bind((host, port))
    # 设置 timeout 配合信号优雅退出：recvfrom() 每 2 秒超时回到循环顶。
    # 超时不会丢包，内核收到数据后放入缓冲区，下次 recvfrom() 可取走
    udp_socket.settimeout(2.0)
    print(f"[UDP Broadcast Receiver] listening on {host}:{port}")

    running = True

    def graceful_shutdown(signum, frame):
        nonlocal running
        print("\n[UDP Broadcast Receiver] shutting down...")
        running = False
        # 关闭 socket 让 recvfrom() 抛出 OSError，循环退出
        udp_socket.close()

    signal.signal(signal.SIGINT, graceful_shutdown)
    signal.signal(signal.SIGTERM, graceful_shutdown)

    # 循环接收广播消息
    while running:
        try:
            # 接收数据报，client_addr 是广播发送方的地址
            recv_data, client_addr = udp_socket.recvfrom(1024)
        except socket.timeout:
            continue
        except OSError:
            break

        data_str = recv_data.decode("utf-8")
        print(f"  broadcast from {client_addr}: {data_str.strip()}")

    udp_socket.close()


if __name__ == "__main__":
    main()
