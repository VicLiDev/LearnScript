#!/usr/bin/env python3
#########################################################################
# Unix Domain Socket 流式（Stream）客户端
#
# SOCK_STREAM 对标 TCP：面向连接、字节流、可靠。
# 本质是单机进程间通信（IPC），走内核内存拷贝而非网络协议栈。
# 区别：connect 到文件路径而非 IP:Port，仅限本机通信。
#########################################################################

import socket

# 必须与服务器端的路径一致
# Unix socket 地址：客户端 connect() 到此路径，内核根据它找到服务端。
# 注意客户端不创建该文件，由服务端 bind() 时创建。
SOCKET_PATH = "/tmp/unix_stream_demo.sock"


def main():
    # 1. 创建 Unix 域流式 socket
    client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

    # 2. 连接到 socket 文件
    try:
        client_socket.connect(SOCKET_PATH)
        print(f"[Unix Stream Client] connected to {SOCKET_PATH}")
    except FileNotFoundError:
        # socket 文件不存在 = 服务器未启动
        print(f"[Unix Stream Client] server not running (no socket file at {SOCKET_PATH})")
        return
    except ConnectionRefusedError:
        print(f"[Unix Stream Client] server refused connection")
        return
    except Exception as e:
        print(f"[Unix Stream Client] connect failed: {e}")
        return

    # 3. 收发循环（与 TCP 客户端完全相同）
    try:
        while True:
            try:
                send_data = input("Enter string to send: ")
            except (EOFError, KeyboardInterrupt):
                print("\n[Unix Stream Client] exiting...")
                break

            if send_data == "quit":
                break

            try:
                client_socket.send(send_data.encode("utf-8"))
                recv_data = client_socket.recv(1024)
                print(f"  from server: {recv_data.decode('utf-8')}")
            except BrokenPipeError:
                # Unix socket 断开时会收到 SIGPIPE / BrokenPipeError
                print("[Unix Stream Client] server closed connection")
                break
    finally:
        # 4. 关闭连接（客户端不需要清理 socket 文件，只有服务端需要）
        client_socket.close()
        print("[Unix Stream Client] closed")


if __name__ == "__main__":
    main()
