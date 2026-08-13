#!/usr/bin/env bash
#########################################################################
# File Name: echo_color.sh
# Author: Hongjin Li
# mail: 872648180@qq.com
# Created Time: Thu Nov 30 17:03:08 2023
#########################################################################

# 如果想要输出不同的颜色进行区分，就需要用到printf的控制命令：\033[m。
# 控制命令以\033[开头，以m结尾，而中间则是属性码，属性代码之间使用;分隔，
# 如\033[1;34;42m。而属性代码的含义见下面的表格。
#
# 通用格式控制               前景色               背景色
# 属性代码 功能              属性代码 颜色        属性代码   颜色
# 0        重置所有属性      30       黑色        40         黑色
# 1        高亮/加粗         31       红色        41         红色
# 2        暗淡              32       绿色        42         绿色
# 4        下划线            33       黄色        43         黄色
# 5        闪烁              34       蓝色        44         蓝色
# 7        反转              35       品红        45         品红
# 8        隐藏              36       青色        46         青色
#
# 更多命令可参考： https://en.wikipedia.org/wiki/ANSI_escape_code
#
# ESC字符的三种写法：\033（八进制）、\e（简写）、\x1b（十六进制）
# 它们都表示ASCII 27（ESC），效果完全一样，区别仅在于兼容性：
#   \033  echo -e 和 printf 都支持，兼容性最好
#   \e    echo -e 支持，printf 不支持（会原样输出\e），写法最简洁
#   \x1b  echo -e 和 printf 都支持
# 建议：printf 用 \033 或 \x1b，echo -e 三种都行，\e 最简洁

echo "==> echo"
echo -e "\e[0m\e[1;31m hello world \e[0m"
echo -e "\e[0m\e[1;32m hello world \e[0m"
echo -e "\e[0m\e[1;33m hello world \e[0m"
echo -e "\e[0m\e[1;34m hello world \e[0m"
echo -e "\e[0m\e[1;35m hello world \e[0m"
echo -e "\e[0m\e[1;36m hello world \e[0m"
echo -e "\e[0m\e[1;37m hello world \e[0m"


printf "\n==> printf\n"
printf "\033[0m\033[1;31m hello world \033[0m\n"
printf "\033[0m\033[1;32m hello world \033[0m\n"
printf "\033[0m\033[1;33m hello world \033[0m\n"
printf "\033[0m\033[1;34m hello world \033[0m\n"
printf "\033[0m\033[1;35m hello world \033[0m\n"
printf "\033[0m\033[1;36m hello world \033[0m\n"
printf "\033[0m\033[1;37m hello world \033[0m\n"


echo "==> 日志分级函数"

# 日志分级函数: 常用于部署/构建脚本, 颜色 + 等宽前缀区分信息级别
# (deploy.sh 同款写法: 前缀宽度一致, 多行日志对齐美观)
# 注意: 输出重定向到文件/管道时 ANSI 码会污染内容,
#       需要落日志的场景可用 [ -t 1 ] 判断是否终端再决定是否上色
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${CYAN}[ info ]${NC} $*"; }
ok()    { echo -e "${GREEN}[  ok  ]${NC} $*"; }
warn()  { echo -e "${YELLOW}[ WARN ]${NC} $*"; }
err()   { echo -e "${RED}[ FAIL ]${NC} $*"; }

info "hello world"
ok "hello world"
warn "hello world"
err "hello world"


echo ""
echo "==> 日志函数族 (带日志文件落盘 + 静默模式)"
echo "==> log file: /tmp/echo_color_demo.log"

# 日志函数族: 统一处理 着色/落盘/级别/静默/调试, 常用于验证/构建脚本
# (rk_dec_verify.sh 同款写法)
#
# 设计要点:
#   1. 颜色: 1;3x 高亮色, 每条消息完整包裹着色串, 打印完立即恢复, 无残留
#   2. 落盘: tee -a 同时写日志文件, 终端看到什么文件里就是什么
#   3. 分流: 常规日志走 stderr (>&2), 防止被 $(...) 命令替换吞掉;
#            log_summary 走 stdout, 作为脚本对外输出结果
#   4. 门控: q_gate 静默模式整体禁用常规日志; log_dbg 仅在 verbose 下输出
RED="\033[1;31m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; NC="\033[0m"
log_file="/tmp/echo_color_demo.log"

function q_gate()      { [ "${cmd_quiet}" = "1" ] && return 1; return 0; }
function log_line()    { q_gate || return; echo -e "$*" | tee -a "${log_file}" >&2; }
function log()         { q_gate || return; echo "$*" | tee -a "${log_file}" >&2; }
function log_dbg()     { [ "${cmd_verbose}" = "1" ] && log "$*"; }
function log_pass()    { log_line "${GREEN}[PASS] $*${NC}"; }
function log_fail()    { log_line "${RED}[FAIL] $*${NC}"; }
function log_warn()    { log_line "${YELLOW}[WARN] $*${NC}"; }
function log_summary() { echo -e "$*" >>"${log_file}"; echo -e "$*"; }

log "normal line"
log_pass "decode ok"
log_fail "decode failed"
log_warn "frame count mismatch"
cmd_verbose=1
log_dbg "debug line (verbose only)"
log_summary "summary line (stdout)"

echo "==> quiet mode (常规日志静默, summary 不受影响)"
cmd_quiet=1
log "this line is suppressed"
log_summary "summary still visible"

rm -f "${log_file}"
