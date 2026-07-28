#!/usr/bin/env python3
#########################################################################
# TCP Echo Server — 支持多个顺序连接的客户端
#
# 流程：
#   1. 创建 TCP socket (AF_INET + SOCK_STREAM)
#   2. bind 到 0.0.0.0:18080，监听所有网卡
#   3. listen 等待客户端连接
#   4. accept 接受连接 → recv/send 回显 → 关闭客户端
#   5. 回到步骤 4，等待下一个客户端
#
# 要点：
#   - SO_REUSEADDR 允许端口重用，避免重启时报 "Address already in use"
#   - settimeout(2.0) 让 accept() 每 2 秒超时一次（非退出，而是回到循环顶），
#     避免永久阻塞导致 Ctrl+C 信号无法被响应。超时不会导致连接丢失：
#     TCP 三次握手由内核完成，握手完毕的连接放入 backlog 队列，
#     accept() 只是从这个队列中取出，不在 accept() 期间也能正常建立连接
#   - 信号 (SIGINT/SIGTERM) 配合 running 标志实现优雅关闭
#########################################################################

import socket
import signal
import sys


def main():
    host = "0.0.0.0"  # 监听所有网卡，外网可访问
    port = 18080

    # 1. 创建面向连接的 TCP socket
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # 允许端口重用，避免 TIME_WAIT 状态导致 bind 失败
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    # 2. 绑定地址和端口
    server_socket.bind((host, port))
    # 3. 开始监听，128 是等待连接队列的最大长度
    server_socket.listen(128)
    # 设置 accept() 超时，与信号处理配合实现优雅退出：
    # 如果没有新客户端连接，accept() 最多阻塞 2 秒，然后抛出 socket.timeout，
    # 捕获后回到循环继续等待。这样 Ctrl+C 信号不会被永久阻塞的 accept 吞掉。
    # 超时不会丢连接：TCP 三次握手由内核完成，连接建立后放入 listen 的 backlog
    # 队列，accept() 只是从队列取出。即使恰好处于超时间隙，客户端也能正常连接。
    # 注意：超时只影响 accept（等待新连接），不影响已连接客户端的 recv/send。
    server_socket.settimeout(2.0)
    print(f"[TCP Server] listening on {host}:{port}")

    # 退出标志：信号处理函数设置为 False，主循环和内层 recv 循环检测到后退出
    running = True

    # 注册信号处理函数，Ctrl+C (SIGINT) 或 kill (SIGTERM) 时优雅关闭
    def graceful_shutdown(signum, frame):
        nonlocal running
        print("\n[TCP Server] shutting down...")
        running = False
        # 关闭 server_socket 让 accept() 抛出 OSError，主循环退出
        server_socket.close()

    signal.signal(signal.SIGINT, graceful_shutdown)
    signal.signal(signal.SIGTERM, graceful_shutdown)

    # 4. 主循环：等待客户端连接
    while running:
        try:
            # 阻塞等待客户端连接（最多 2 秒超时）
            client_socket, client_addr = server_socket.accept()
        except socket.timeout:
            continue  # 超时不是错误，回到循环继续等待
        except OSError:
            break  # socket 已关闭（信号触发），退出循环

        print(f"[TCP Server] client connected: {client_addr}")

        # 给客户端 socket 也设置超时，解决内层 recv() 永久阻塞的问题：
        # recv() 每 2 秒超时一次回到循环顶，检查 running 标志决定是否退出。
        # 超时不会丢数据：内核收到数据后放入接收缓冲区，下次 recv() 可取走
        client_socket.settimeout(2.0)

        # 5. 与该客户端的通信循环
        try:
            while running:
                try:
                    # 接收数据，最多 1024 字节
                    recv_data = client_socket.recv(1024)
                except socket.timeout:
                    continue  # 超时后检查 running 标志，决定继续还是退出
                if not recv_data:
                    # 收到空数据 = 客户端正常关闭连接
                    print(f"[TCP Server] client disconnected: {client_addr}")
                    break
                print(f"  recv: {recv_data.decode('utf-8').strip()}")
                # 原样回显给客户端
                client_socket.send(recv_data)
        except ConnectionResetError:
            # 客户端异常断开（如进程被强杀）
            print(f"[TCP Server] client reset: {client_addr}")
        except OSError:
            pass  # 信号处理函数关闭了 socket
        except Exception as e:
            print(f"[TCP Server] error: {e}")
        finally:
            # 无论正常还是异常，都要关闭客户端 socket
            client_socket.close()

    server_socket.close()


if __name__ == "__main__":
    main()
