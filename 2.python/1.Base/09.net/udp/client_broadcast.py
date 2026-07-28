#!/usr/bin/env python3
#########################################################################
# UDP 广播发送端
#
# 广播 (broadcast) 的特点：
#   - 目标地址是广播地址（如 255.255.255.255 或子网广播地址）
#   - 同一子网内所有主机都能收到
#   - 必须启用 SO_BROADCAST 选项，否则 sendto 会报 PermissionError
#   - 广播只在局域网内有效，路由器不会转发
#
# 常见广播地址：
#   - 255.255.255.255   — 受限广播（本网所有主机）
#   - 192.168.1.255     — 定向广播（192.168.1.0/24 子网）
#########################################################################

import socket


def main():
    # 目标：广播到本网所有主机
    broadcast_addr = ("255.255.255.255", 37020)

    # 创建 UDP socket
    udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # 必须开启广播权限，否则无法发送广播包
    udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

    print(f"[UDP Broadcast Sender] sending to {broadcast_addr}")
    print("  type 'quit' to exit")

    try:
        while True:
            try:
                send_data = input("Enter broadcast message: ")
            except (EOFError, KeyboardInterrupt):
                print("\n[UDP Broadcast Sender] exiting...")
                break

            if send_data == "quit":
                break

            # 发送广播数据报
            udp_socket.sendto(send_data.encode("utf-8"), broadcast_addr)
            print(f"  sent: {send_data}")
    finally:
        udp_socket.close()
        print("[UDP Broadcast Sender] closed")


if __name__ == "__main__":
    main()
