#!/usr/bin/env python3
#########################################################################
# Unix Domain Socket 流式（Stream）服务器
#
# SOCK_STREAM 对标 TCP：面向连接、字节流、可靠的流式传输。
# 本质上是单机进程间通信（IPC），不走网卡和 TCP/IP 协议栈，
# 通过内核内存直接拷贝数据，因此性能高于 TCP，但不能跨机器。
# 区别是地址用文件路径而非 IP:Port，仅限本机通信。
#   ┌─────────────────┬──────────────────────┬────────────────────────┐
#   │                 │  TCP (AF_INET)       │  Unix (AF_UNIX)        │
#   ├─────────────────┼──────────────────────┼────────────────────────┤
#   │ 地址            │ IP:Port              │ 文件路径               │
#   │ 网络范围        │ 跨主机               │ 仅本机                 │
#   │ 协议栈          │ TCP/IP 内核栈        │ 直接内核内存拷贝       │
#   │ 性能            │ 较慢（经过协议栈）   │ 更快（零拷贝）         │
#   │ 残留清理        │ 无                   │ socket 文件需手动删除  │
#   │ 额外能力        │ 无                   │ SO_PEERCRED, SCM_RIGHTS│
#   └─────────────────┴──────────────────────┴────────────────────────┘
#
# 流程：与 TCP 类似 — socket → bind → listen → accept → recv/send → close
# 关键差异：
#   1. AF_UNIX 代替 AF_INET
#   2. bind 到文件路径而非 (host, port)
#   3. 服务退出后 socket 文件残留在磁盘，必须手动删除
#   4. 可获取对端进程凭证 (PID/UID/GID) 做权限校验
#########################################################################

import os
import struct
import socket
import signal

# socket 文件路径（文件系统可见）
# .sock 文件就是 Unix domain socket 的"地址"，作用等同于 TCP 的 IP:Port。
# 由服务端 bind() 时内核创建，是 socket 类型的特殊文件（ls -l 显示 s），
# 客户端 connect() 到该路径即可建立连接。数据不经过该文件，走内核内存拷贝。
# 该文件不可读写（cat 会报错），只是一个内核标识。服务端退出后文件残留，
# 必须 os.unlink() 删除，否则下次 bind 失败。
SOCKET_PATH = "/tmp/unix_stream_demo.sock"


def main():
    # 如果上次运行残留了 socket 文件，先删掉，否则 bind 会报错
    if os.path.exists(SOCKET_PATH):
        os.unlink(SOCKET_PATH)

    # 1. 创建 Unix 域流式 socket（类似 TCP SOCK_STREAM）
    server_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    # 2. 绑定到文件路径（而非 IP:Port）
    server_socket.bind(SOCKET_PATH)
    # 设置 socket 文件权限为仅属主可读写 (0o600)。
    # bind() 创建的文件权限受 umask 影响，显式 chmod 避免其他用户连接
    os.chmod(SOCKET_PATH, 0o600)
    # 3. 监听
    server_socket.listen(128)
    # 设置 accept() 超时配合信号优雅退出：每 2 秒超时回到循环顶，
    # 让 Ctrl+C 信号有机会被响应。超时不会丢连接：Unix socket 也是
    # 内核管理连接建立，accept() 只是从就绪队列中取出
    server_socket.settimeout(2.0)
    print(f"[Unix Stream Server] listening on {SOCKET_PATH}")

    running = True

    def graceful_shutdown(signum, frame):
        nonlocal running
        print("\n[Unix Stream Server] shutting down...")
        running = False
        # 关闭 server_socket 让 accept() 抛出 OSError，主循环退出
        server_socket.close()

    signal.signal(signal.SIGINT, graceful_shutdown)
    signal.signal(signal.SIGTERM, graceful_shutdown)

    # SO_PEERCRED 返回 struct ucred 结构体（3 个 int 字段: pid, uid, gid）。
    # 这里用 struct 模块计算该结构体所需的字节数，以便 getsockopt 分配缓冲区。
    # "3i" = 三个有符号整数 (signed int)，分别在 getpeername 之后 unpack 取出
    struct_size = struct.calcsize("3i")

    while True:
        try:
            # 4. 等待客户端连接
            client_socket, _ = server_socket.accept()
        except socket.timeout:
            continue
        except OSError:
            break

        # 5. 获取对端进程凭证 (PID, UID, GID) — Unix socket 特有的安全特性
        try:
            peer_cred = client_socket.getsockopt(
                socket.SOL_SOCKET, socket.SO_PEERCRED, struct_size
            )
            pid, uid, gid = struct.unpack("3i", peer_cred)
            print(f"[Unix Stream Server] client connected, PID={pid}, UID={uid}, GID={gid}")
        except Exception:
            print(f"[Unix Stream Server] client connected")

        # 给客户端 socket 也设置超时，解决内层 recv() 永久阻塞的问题：
        # recv() 每 2 秒超时一次回到循环顶，检查 running 标志决定是否退出。
        # 超时不会丢数据：内核收到数据后放入接收缓冲区，下次 recv() 可取走
        client_socket.settimeout(2.0)

        try:
            while running:
                try:
                    recv_data = client_socket.recv(1024)
                except socket.timeout:
                    continue
                if not recv_data:
                    print(f"[Unix Stream Server] client disconnected")
                    break
                print(f"  recv: {recv_data.decode('utf-8').strip()}")
                # 回显
                client_socket.send(recv_data)
        except ConnectionResetError:
            print(f"[Unix Stream Server] client reset")
        except OSError:
            pass  # 信号处理函数关闭了 socket
        except Exception as e:
            print(f"[Unix Stream Server] error: {e}")
        finally:
            client_socket.close()

    server_socket.close()
    # 清理残留的 socket 文件
    if os.path.exists(SOCKET_PATH):
        os.unlink(SOCKET_PATH)


if __name__ == "__main__":
    main()
