#!/usr/bin/env python3
#########################################################################
# TCP 多客户端 Echo 服务器 — select I/O 多路复用模型（单线程）
#
# 与 threading 版的区别：
#   - 只有一个线程，用 select() 同时监听所有 socket
#   - select 返回哪些 socket 可读/可写/异常，然后逐一处理
#   - 避免了线程切换开销，适合高并发场景（C10K）
#
# select 工作原理：
#   把 server_socket 和所有 client_socket 放入一个"监听列表"，
#   select() 会阻塞直到至少一个 socket 有事件发生：
#     - 可读 (readable)：有新连接或新数据到达
#     - 可写 (writable)：可以发送数据
#     - 异常 (exceptional)：连接出错
#
# 关键：socket 必须设为非阻塞模式 (setblocking(False))，
#       否则单个 recv 可能阻塞整个事件循环
#########################################################################

import socket
import select
import signal
import sys


def main():
    host = "0.0.0.0"
    port = 18080

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    # 设置为非阻塞模式 — select 的多路复用要求
    server_socket.setblocking(False)
    server_socket.bind((host, port))
    server_socket.listen(128)
    print(f"[TCP Select Server] listening on {host}:{port}")

    # inputs 列表保存所有需要监听的 socket（包括 server_socket）
    inputs = [server_socket]
    # outputs 预留给可写事件的 socket（本 demo 只做 echo，直接 send 即可，
    # 无需借助可写事件，因此 outputs 始终为空，保留作为扩展占位）
    outputs = []

    running = True

    def graceful_shutdown(signum, frame):
        nonlocal running
        print("\n[TCP Select Server] shutting down...")
        running = False

    signal.signal(signal.SIGINT, graceful_shutdown)
    signal.signal(signal.SIGTERM, graceful_shutdown)

    while running:
        try:
            # select 会阻塞直到至少一个 socket 有事件，或 2 秒超时
            readable, writable, exceptional = select.select(
                inputs, outputs, inputs, 2.0
            )
        except (InterruptedError, OSError):
            # 信号中断或 socket 关闭时会触发
            continue

        # 处理所有"可读"的 socket
        for s in readable:
            if s is server_socket:
                # server_socket 可读 = 有新客户端连接
                client_socket, client_addr = server_socket.accept()
                client_socket.setblocking(False)  # 非阻塞模式
                inputs.append(client_socket)       # 加入监听列表
                print(f"[TCP Select Server] client connected: {client_addr}")
            else:
                # 客户端 socket 可读 = 有数据到达
                try:
                    recv_data = s.recv(1024)
                    if recv_data:
                        data_str = recv_data.decode("utf-8").strip()
                        peer = s.getpeername()
                        print(f"  recv from {peer}: {data_str}")
                        s.send(recv_data)  # 回显
                    else:
                        # recv 返回空 = 客户端断开连接
                        peer = s.getpeername()
                        print(f"[TCP Select Server] client disconnected: {peer}")
                        inputs.remove(s)       # 从监听列表移除
                        if s in outputs:
                            outputs.remove(s)
                        s.close()
                except ConnectionResetError:
                    inputs.remove(s)
                    if s in outputs:
                        outputs.remove(s)
                    s.close()

        # 处理异常 socket（如带外数据、连接错误等）
        # 异常发生时最安全的做法就是关闭连接
        for s in exceptional:
            inputs.remove(s)
            if s in outputs:
                outputs.remove(s)
            s.close()

    # 退出前关闭所有 socket
    for s in inputs:
        s.close()
    print("[TCP Select Server] closed")


if __name__ == "__main__":
    main()
