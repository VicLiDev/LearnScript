#!/usr/bin/env python3
#########################################################################
# TCP 多客户端 Echo 服务器 — threading 线程模型
#
# 与基础版 server.py 的区别：
#   - 每 accept 到一个客户端，就创建一个新线程处理
#   - 主线程只负责 accept，不阻塞在其他客户端上
#   - 可以同时服务多个客户端
#
# 线程模型优点：代码简单直观
# 线程模型缺点：每连接一个线程，高并发时线程开销大（C10K 问题）
#########################################################################

import socket
import signal
import sys
import threading


def handle_client(client_socket, client_addr):
    """在新线程中处理一个客户端的所有通信"""
    print(f"[Thread {threading.current_thread().name}] connected: {client_addr}")
    try:
        while True:
            # 阻塞等待该客户端发送数据
            recv_data = client_socket.recv(1024)
            if not recv_data:
                print(f"[Thread {threading.current_thread().name}] disconnected: {client_addr}")
                break
            data_str = recv_data.decode("utf-8").strip()
            print(f"  recv from {client_addr}: {data_str}")
            # 回显
            client_socket.send(recv_data)
    except ConnectionResetError:
        print(f"[Thread {threading.current_thread().name}] reset: {client_addr}")
    except Exception as e:
        print(f"[Thread {threading.current_thread().name}] error: {e}")
    finally:
        client_socket.close()


def main():
    host = "0.0.0.0"
    port = 18080

    # 1. 创建 TCP socket
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # 允许端口重用，避免 TIME_WAIT 导致重启 bind 失败
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    # 2. 绑定地址和端口
    server_socket.bind((host, port))
    # 3. 监听，128 是等待连接队列的最大长度
    server_socket.listen(128)
    # 设置 timeout 配合信号优雅退出：accept() 每 2 秒超时一次，
    # 让信号处理有机会被响应。超时不会丢连接，内核完成握手后放入 backlog 队列
    server_socket.settimeout(2.0)
    print(f"[TCP Threading Server] listening on {host}:{port}")

    running = True

    def graceful_shutdown(signum, frame):
        nonlocal running
        print("\n[TCP Threading Server] shutting down...")
        running = False
        # 关闭 server socket，让 accept() 抛出 OSError，从而退出主循环
        server_socket.close()

    signal.signal(signal.SIGINT, graceful_shutdown)
    signal.signal(signal.SIGTERM, graceful_shutdown)

    while running:
        try:
            # 主线程阻塞等待新连接
            client_socket, client_addr = server_socket.accept()
        except socket.timeout:
            continue
        except OSError:
            # socket 已被信号处理函数关闭，running 为 False 则退出
            # running 仍为 True 说明是偶发错误（如资源不足），continue 继续等待
            if not running:
                break
            continue

        # 为新客户端创建线程，daemon=True 表示主线程退出时自动终止
        t = threading.Thread(
            target=handle_client,
            args=(client_socket, client_addr),
            daemon=True,
        )
        t.start()

    server_socket.close()


if __name__ == "__main__":
    main()
