#!/usr/bin/env python3
#########################################################################
# Unix Domain Socket 数据报（Dgram）服务器
#
# SOCK_DGRAM 对标 UDP：面向消息、保留边界、无需连接的报文传输。
# 本质上是单机进程间通信（IPC），不走网卡和 TCP/IP 协议栈，
# 通过内核内存直接拷贝数据。地址是文件路径，不能跨机器。
#   ┌─────────────────┬───────────────────────────┬─────────────────────┐
#   │                 │  UDP (AF_INET + DGRAM)    │  Unix Dgram         │
#   ├─────────────────┼───────────────────────────┼─────────────────────┤
#   │ 可靠性          │  不可靠（丢包/乱序/重复） │  可靠（不丢不乱）   │
#   │ 消息边界        │  保留                     │  保留               │
#   │ 客户端需 bind?  │  不需要                   │  需要（接收回包时） │
#   │ 地址            │  IP:Port                  │  文件路径           │
#   │ 网络范围        │  可跨主机                 │  仅本机             │
#   └─────────────────┴───────────────────────────┴─────────────────────┘
#
# 注意：Unix datagram 客户端必须 bind 一个地址才能接收服务端的回包，
#       这是与 UDP 最大的使用差异点。
#########################################################################

import os
import socket
import signal

# .sock 文件是 Unix socket 的地址（等同于 TCP 的 IP:Port），
# 由 bind() 时内核创建。服务端退出后文件残留，必须手动删除。
SERVER_PATH = "/tmp/unix_dgram_server.sock"


def main():
    # 清理残留文件
    if os.path.exists(SERVER_PATH):
        os.unlink(SERVER_PATH)

    # 1. 创建 Unix 域数据报 socket
    server_socket = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
    # 2. 绑定到文件路径
    server_socket.bind(SERVER_PATH)
    # 限制 socket 文件权限为仅属主可读写，避免其他用户连接
    os.chmod(SERVER_PATH, 0o600)
    # 设置 timeout 配合信号优雅退出：recvfrom() 每 2 秒超时回到循环顶。
    # 超时不会丢包，内核收到数据后放入缓冲区，下次 recvfrom() 可取走
    server_socket.settimeout(2.0)
    print(f"[Unix Dgram Server] listening on {SERVER_PATH}")

    running = True

    def graceful_shutdown(signum, frame):
        nonlocal running
        print("\n[Unix Dgram Server] shutting down...")
        running = False
        # 关闭 socket 让 recvfrom() 抛出 OSError，循环退出
        server_socket.close()

    signal.signal(signal.SIGINT, graceful_shutdown)
    signal.signal(signal.SIGTERM, graceful_shutdown)

    # 3. 接收循环
    while running:
        try:
            # recvfrom 返回 (数据, 客户端地址)
            # 客户端地址是它 bind 的文件路径（如果客户端未 bind 则为空字符串）
            recv_data, client_addr = server_socket.recvfrom(1024)
        except socket.timeout:
            continue
        except OSError:
            break

        data_str = recv_data.decode("utf-8")
        print(f"  recv from {client_addr}: {data_str.strip()}")

        if data_str.strip() == "quit":
            print("[Unix Dgram Server] received quit, shutting down...")
            break

        # 回显 — 需要检查 client_addr 是否存在
        # 如果客户端没有 bind 地址，client_addr 为空，无法回包
        if client_addr:
            server_socket.sendto(recv_data, client_addr)
        else:
            print("  [warning] client has no address, cannot echo back")

    server_socket.close()
    if os.path.exists(SERVER_PATH):
        os.unlink(SERVER_PATH)
    print("[Unix Dgram Server] closed")


if __name__ == "__main__":
    main()
