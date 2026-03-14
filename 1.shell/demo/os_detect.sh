#!/usr/bin/env bash
#########################################################################
# File Name: os_detect.sh
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Sat Mar 14 10:00:00 2026
#########################################################################

# 系统环境检测脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检测操作系统类型
detect_os()
{
    local os_type=""
    local os_name=""

    # 方法1: 使用 OSTYPE (bash 内置变量)
    echo -e "${BLUE}==> 方法1: 使用 OSTYPE 变量${NC}"
    case "$OSTYPE" in
        linux*)     os_type="Linux"; os_name="Linux" ;;
        darwin*)    os_type="Mac"; os_name="macOS" ;;
        cygwin*)    os_type="Windows"; os_name="Windows (Cygwin)" ;;
        msys*)      os_type="Windows"; os_name="Windows (MSYS2)" ;;
        win32*)     os_type="Windows"; os_name="Windows" ;;
        freebsd*)   os_type="FreeBSD"; os_name="FreeBSD" ;;
        *)          os_type="Unknown"; os_name="未知系统" ;;
    esac
    echo -e "  OSTYPE: ${GREEN}${OSTYPE}${NC}"
    echo -e "  检测结果: ${GREEN}${os_name}${NC}"

    # 方法2: 使用 uname 命令
    echo -e "\n${BLUE}==> 方法2: 使用 uname 命令${NC}"
    local uname_result=$(uname -s)
    echo -e "  uname -s: ${GREEN}${uname_result}${NC}"

    case "$uname_result" in
        Linux*)     echo -e "  检测结果: ${GREEN}Linux${NC}" ;;
        Darwin*)    echo -e "  检测结果: ${GREEN}macOS${NC}" ;;
        CYGWIN*)    echo -e "  检测结果: ${GREEN}Windows (Cygwin)${NC}" ;;
        MINGW*)     echo -e "  检测结果: ${GREEN}Windows (MinGW)${NC}" ;;
        MSYS*)      echo -e "  检测结果: ${GREEN}Windows (MSYS)${NC}" ;;
        FreeBSD*)   echo -e "  检测结果: ${GREEN}FreeBSD${NC}" ;;
        *)          echo -e "  检测结果: ${YELLOW}未知系统${NC}" ;;
    esac

    # 方法3: 检测 /etc/os-release (仅 Linux)
    echo -e "\n${BLUE}==> 方法3: 检测 /etc/os-release${NC}"
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo -e "  发行版名称: ${GREEN}${NAME}${NC}"
        echo -e "  版本号: ${GREEN}${VERSION}${NC}"
        echo -e "  ID: ${GREEN}${ID}${NC}"
    else
        echo -e "  ${YELLOW}/etc/os-release 不存在 (非Linux或非systemd系统)${NC}"
    fi

    # 方法4: 使用 sw_vers (仅 macOS)
    echo -e "\n${BLUE}==> 方法4: 使用 sw_vers (macOS 专用)${NC}"
    # command -v: 检查命令是否存在，存在则返回路径，退出码为0；不存在则退出码为1
    # &> /dev/null: 将标准输出和标准错误都丢弃，只关心退出状态码
    if command -v sw_vers &> /dev/null; then
        echo -e "  产品名称: ${GREEN}$(sw_vers -productName)${NC}"
        echo -e "  版本号: ${GREEN}$(sw_vers -productVersion)${NC}"
        echo -e "  构建版本: ${GREEN}$(sw_vers -buildVersion)${NC}"
    else
        echo -e "  ${YELLOW}sw_vers 命令不存在 (非macOS系统)${NC}"
    fi

    # 方法5: 检测 Windows 环境
    echo -e "\n${BLUE}==> 方法5: 检测 Windows 环境变量${NC}"
    if [[ -n "$MSYSTEM" ]]; then
        echo -e "  MSYSTEM: ${GREEN}${MSYSTEM}${NC}"
    fi
    if [[ -n "$WINDIR" ]]; then
        echo -e "  WINDIR: ${GREEN}${WINDIR}${NC}"
    fi
    if [[ -z "$MSYSTEM" && -z "$WINDIR" ]]; then
        echo -e "  ${YELLOW}未检测到 Windows 环境变量${NC}"
    fi
}

# 获取系统架构
detect_arch()
{
    echo -e "\n${BLUE}==> 系统架构信息${NC}"
    echo -e "  uname -m: ${GREEN}$(uname -m)${NC}"

    if command -v arch &> /dev/null; then
        echo -e "  arch: ${GREEN}$(arch)${NC}"
    fi
}

# 获取内核信息
detect_kernel()
{
    echo -e "\n${BLUE}==> 内核信息${NC}"
    echo -e "  内核名称: ${GREEN}$(uname -s)${NC}"
    echo -e "  内核版本: ${GREEN}$(uname -r)${NC}"
    echo -e "  内核发布: ${GREEN}$(uname -v)${NC}"
}

# 主函数
main()
{
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}       系统环境检测工具${NC}"
    echo -e "${GREEN}========================================${NC}"

    detect_os
    detect_arch
    detect_kernel

    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}       检测完成${NC}"
    echo -e "${GREEN}========================================${NC}"
}

main
