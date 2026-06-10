#!/opt/homebrew/anaconda3/bin/bash
#########################################################################
# File Name: echo_color.sh
# Author: LiHongjin
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
