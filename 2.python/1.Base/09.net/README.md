# 09.net — Python Socket 网络编程

## 1. 这是什么

本目录用三个子目录分别演示三种最常用的 socket 通信方式，
每个子目录都包含完整的 server/client 代码和自动化测试脚本：

- `tcp/` — 基于 IP 网络的可靠流式通信（对标 HTTP、SSH 等）
- `udp/` — 基于 IP 网络的不可靠报文通信（对标 DNS、视频通话）
- `unix/` — 基于文件路径的本机进程间通信 IPC（对标管道、消息队列）

它们共用同一套 Python 标准库 `socket`，区别只在**地址形式**、
**连接方式**和**可靠性语义**三个维度，见第 3 节对比表。

## 2. 目录结构与文件清单

### tcp/ — TCP 可靠流式传输

| 文件                | 作用                           |
|---------------------|--------------------------------|
| server.py           | 基础回显服务器，顺序处理连接   |
| server_threading.py | 每来一个连接开一个线程         |
| server_select.py    | 单线程 + select 多路复用       |
| client.py           | 交互式客户端，三种 server 通用 |
| prjBuild.sh         | 一键测试脚本                   |

### udp/ — UDP 不可靠报文传输

| 文件                | 作用                     |
|---------------------|--------------------------|
| server.py           | 基础回显服务器（无连接） |
| client.py           | 交互式客户端             |
| server_broadcast.py | 广播接收端               |
| client_broadcast.py | 广播发送端               |
| prjBuild.sh         | 一键测试脚本             |

### unix/ — Unix Domain Socket 本机 IPC

| 文件             | 作用                     |
|------------------|--------------------------|
| server_stream.py | 流式服务器（对标 TCP）   |
| client_stream.py | 流式客户端               |
| server_dgram.py  | 数据报服务器（对标 UDP） |
| client_dgram.py  | 数据报客户端             |
| prjBuild.sh      | 一键测试脚本             |

## 3. 三种方式对比总览

| 特性     | TCP (tcp/)    | UDP (udp/)   | Unix (unix/)   |
|----------|---------------|--------------|----------------|
| 地址     | IP:Port       | IP:Port      | 文件路径       |
| 连接     | 面向连接      | 无连接       | 流有/报无      |
| 可靠性   | 可靠有序      | 不可靠       | 可靠           |
| 消息边界 | 无（字节流）  | 有（数据报） | 流无/报有      |
| 范围     | 跨主机        | 跨主机       | 仅本机         |
| 数据路径 | TCP/IP 协议栈 | IP 协议栈    | 内核内存拷贝   |

## 4. 通信规则

### 4.1 TCP：先建立连接，再按字节流对话

TCP 的通信规则可以概括为四句话：

1. **建立连接靠三次握手**：客户端 connect() 发起 SYN，内核
   完成 SYN→SYN+ACK→ACK 的握手后，连接进入服务端 listen 的
   backlog 队列，accept() 只是从队列里取出连接。
2. **数据是字节流**：send/recv 只关心字节，不关心"消息"，
   应用层发两次 10 字节，对端可能一次 recv 收到 20 字节
   （粘包），协议边界需要应用层自己定义。
3. **全双工可靠有序**：双方可同时收发，不丢包、不乱序，
   出错自动重传。
4. **关闭靠四次挥手**：任一方 close() 发出 FIN，对端 recv()
   读到 b""（空字节串）即代表对方关闭。tcp/server.py 第 87 行
   就靠这个判断客户端断开。

### 4.2 UDP：无连接，发出去就不管

1. **无连接**：不需要握手，服务端不需要 listen/accept，
   sendto 直接发包，recvfrom 收包。
2. **报文边界保留**：一次 recvfrom 恰好收到一个完整数据报，
   不粘包也不拆包；单个数据报最大 65507 字节。
3. **不可靠**：可能丢包、乱序、重复。udp/client.py 第 20 行
   设置了 3 秒超时来应对收不到回包的情况。
4. **广播**：目标地址 255.255.255.255（受限广播），需设置
   `SO_BROADCAST` 选项；路由器不转发广播，仅局域网内有效。

### 4.3 Unix Socket：地址是文件路径，规则同 TCP/UDP

1. **地址是文件路径**：服务端 bind() 时内核创建 socket 特殊
   文件（ls -l 显示为 s），客户端 connect() 到该路径。
   **数据不经过这个文件**，它只是"门牌号"。
2. **仅限本机**：不能跨机器通信，本质是进程间通信（IPC）。
3. **同样可靠**：stream 语义与 TCP 一致；dgram 在本机也
   不丢包不乱序（内核内存拷贝不会出错）。
4. **权限控制**：socket 文件有权限位，代码里 chmod 0o600
   限制仅属主可连；还可通过 `SO_PEERCRED` 获取对端进程的
   PID/UID/GID 做校验。
5. **残留清理**：服务端退出后文件残留在磁盘，下次 bind
   会失败，必须手动 os.unlink()（代码中每次启动先删）。
6. **dgram 客户端必须 bind**：UDP 客户端不用 bind，但 Unix
   dgram 客户端不 bind 自己的路径，服务端就不知道回包地址，
   永远收不到回显。
7. **不必须用文件**：Linux 支持抽象命名空间，地址以 `\0`
   开头（如 `'\0my_socket'`），不创建文件也不残留；但失去
   文件权限保护，且 macOS/Windows 不支持，通用性差。

## 5. 原理：socket 是怎么工作的

### 5.1 socket 的本质是一个文件描述符

socket 是**内核提供的通信接口**：进程创建 socket 得到一个
文件描述符（fd），之后 send/recv 本质是系统调用，数据经由
内核缓冲区搬运，进程之间不直接接触。所谓"网络编程"其实是
在配置内核如何搬运数据：

| 要素        | 含义                                        |
|-------------|---------------------------------------------|
| 协议族 AF_* | 地址空间：AF_INET=IP 网络，AF_UNIX=本机路径 |
| 类型 SOCK_* | 语义：SOCK_STREAM=流，SOCK_DGRAM=报文       |
| 地址        | 门牌号：IP:Port 或文件路径                  |

### 5.2 一次发送的完整路径

发送方进程 → send() → 内核发送缓冲 → TCP/IP 协议栈打包
（Unix 则直接拷贝）→ 对端内核接收缓冲 → 对端 recv() → 接收
方进程。

由此可以解释代码里反复出现的"超时不会丢数据"：accept() 或
recv() 超时只是**本次调用**不等待，连接和数据由内核托管，
下次调用照样能取到。

### 5.3 握手与 accept 分离

TCP 三次握手完全由内核完成，与应用代码无关。握手完成的
连接进入 backlog 队列（listen 的第二个参数，代码里是
128），accept() 只做"取出来"这件事。所以：

- settimeout(2.0) 让 accept 周期性返回，配合信号处理优雅
  退出，期间新连接照样能建立，不会丢。
- SO_REUSEADDR 解决 TIME_WAIT：主动关闭方会停留 TIME_WAIT
  约 2 分钟，不设置该选项，重启服务会报 Address already
  in use。

### 5.4 Unix 为什么比 TCP 快

TCP 每次收发要走完整的协议栈：打包、校验、分片、路由查找、
网卡驱动……即使在同一台机器上走回环（loopback）也不省。
Unix socket 不走协议栈，数据在内核内存中直接拷贝到对端
缓冲，延迟低、吞吐高，这也是容器/微服务间通信常选
Unix socket 的原因。

## 6. 多客户端模型对比（tcp/）

| 模型   | 实现                | 特点                          | 适用场景       |
|--------|---------------------|-------------------------------|----------------|
| 顺序   | server.py           | 一次只能服务一个客户端        | 教学、简单工具 |
| 线程   | server_threading.py | 一连接一线程，代码直观        | 几十个连接     |
| select | server_select.py    | 单线程监听所有 fd，无切换开销 | 高并发（C10K） |

select 的原理：把所有 socket 放入监听列表，select() 阻塞
等待"至少一个可读"，事件来了再逐个处理。非阻塞模式
(setblocking(False)) 是必须的，否则单个 recv 会卡死整个
事件循环。

## 7. 运行方式

一键测试（推荐，会自动起服务端、跑客户端、清理残留）：

```bash
bash tcp/prjBuild.sh all
bash udp/prjBuild.sh all
bash unix/prjBuild.sh all
```

手动交互式体验：开两个终端，先起 server 再起 client，
输入 quit 退出：

```bash
python3 tcp/server.py     # 终端 1
python3 tcp/client.py     # 终端 2，连接 127.0.0.1:18080
```

UDP 广播体验：先起接收端再起发送端：

```bash
python3 udp/server_broadcast.py   # 终端 1
python3 udp/client_broadcast.py   # 终端 2
```

## 8. 常见问题速查

| 现象                   | 原因与对策                              |
|------------------------|-----------------------------------------|
| Address already in use | 上次连接处于 TIME_WAIT，加 SO_REUSEADDR |
| Unix 启动 bind 失败    | 残留 .sock 文件，先 os.unlink 再 bind   |
| recv 返回 b""          | 对端已关闭连接（四次挥手完成）          |
| UDP 收不到回包         | 丢包或超时，重发或调大超时              |
| Unix dgram 收不到回包  | 客户端没 bind 自己的地址                |
| 服务端 Ctrl+C 无响应   | accept/recv 永久阻塞，需 settimeout     |
