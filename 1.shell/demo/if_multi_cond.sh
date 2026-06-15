#!/usr/bin/env bash
#########################################################################
# File Name: if_multi_cond.sh
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Sun Jun 15 17:30:00 2026
#########################################################################

# 本脚本系统演示 shell 中 if 的【多条件判断】，是 1.shell/06.flow_control.md 的
# 配套可运行示例。配套文档章节：
#   • "if 的本质：判断命令的退出码"
#   • "多条件处理"（① 组合运算符 ② 条件载体 ③ 注意事项）
#
# 核心思想（贯穿全文）：
#   if 判断的不是"条件表达式"，而是【命令的退出码】：
#     退出码 0   → 真 → 执行 then
#     退出码 非0 → 假 → 执行 else
#   [ ]、[[ ]]、(( ))、test、grep、command、cd …… 都是"会返回退出码的命令"。
#   所谓"多条件"，就是用 && / || / ! 把这些退出码组合起来。
#
# 结构说明：
#   每个小节是一个 demo_xxx 函数；末尾 main() 按顺序调用它们，调用列表即目录索引。
#   想跳过某节，注释掉 main 里对应行即可。
#   想单独跑某节：用 bash source 后手动调用（注意本脚本含 bash 专属语法，
#   请在 bash 下 source，不要在 zsh 下），例如：
#       bash -c 'source if_multi_cond.sh; setup_fixtures; demo_and'
#
# 运行： bash if_multi_cond.sh

set -u   # 引用未定义变量直接报错（好习惯；本脚本用到的变量都已定义）

# ---------- 颜色 ----------
# 用 $'...' (ANSI-C quoting) 让变量里存的是【真正的 ESC 字节】，这样无论 echo 有没有
# -e 都能正确着色；单引号 '\033...' 存的是字面量反斜杠，只有 echo -e 才会解释。
RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'; CYAN=$'\033[0;36m'; BOLD=$'\033[1m'; NC=$'\033[0m'
T="${GREEN}真${NC}"; F="${RED}假${NC}"

# ---------- 输出辅助 ----------
section() { echo -e "\n${BOLD}${BLUE}========== $* ==========${NC}"; }
title()   { echo -e "\n${CYAN}--- $* ---${NC}"; }
note()    { echo -e "${YELLOW}>> $*${NC}"; }

# ---------- 测试数据（全局，供各 demo 函数读取）----------
setup_fixtures()
{
    str1="hello"; str2="world"; empty=""
    num1=10; num2=20
    file="/etc/passwd"          # 几乎一定存在
    nofile="/nonexistent_xyz"   # 一定不存在
    nocmd="definitely_not_installed_xyz"   # 一定没装
    tmpf="$(mktemp 2>/dev/null || echo /tmp/if_demo_$$.txt)"
    printf 'INFO: start\nERROR: something wrong\nDEBUG: detail\n' > "$tmpf"
    trap 'rm -f "$tmpf"' EXIT
}


# =====================================================================
# 0. 前置测试数据
# =====================================================================
demo_setup()
{
    section "0. 前置测试数据"
    echo "  str1=$str1  str2=$str2  empty=(空)"
    echo "  num1=$num1  num2=$num2"
    echo "  file=$file (存在)   nofile=$nofile (不存在)   nocmd=$nocmd (没装)"
    echo "  tmpf=$tmpf (含 INFO / ERROR / DEBUG 三行)"
}


# =====================================================================
# 1. 核心概念：if 看的是【退出码】，不是条件表达式
# =====================================================================
demo_exit_code()
{
    section "1. 核心概念：if 看的是【退出码】，不是条件表达式"
    note "下面 if 后面跟了 4 类完全不同的命令，但 if 处理它们的方式一模一样：看退出码"
    if [  -f "$file" ]; then echo "  [ -f file ]      —— test 命令，退出码 0 → 进 then"; fi
    if [[ $str1 == hello ]]; then echo "  [[ str==hello ]] —— [[ 命令，退出码 0 → 进 then"; fi
    if (( num1 < num2 )); then echo "  (( num<num ))    —— 算术命令，退出码 0 → 进 then"; fi
    if grep -q ERROR "$tmpf"; then echo "  grep -q ERROR   —— grep 命令，退出码 0 → 进 then"; fi
    note "结论：if 后面永远是【一个/一组命令】，[ ] 只是其中最常见的一种。"
}


# =====================================================================
# 2. 三大组合运算符：&& (AND) / || (OR) / ! (NOT)
# =====================================================================
demo_operators()
{
    section "2. 三大组合运算符：&& (AND) / || (OR) / ! (NOT)"
    note "它们作用于【任意命令的退出码】，优先级：! > && > ||"

    title "2.1 AND：&& —— 两边都成功(0) 才为真"
    { [ -f "$file" ] && [ -d /etc ];      } && echo "  文件存在 && /etc是目录  → $T" || echo "  文件存在 && /etc是目录  → $F"
    { [ -f "$file" ] && [ -f "$nofile" ]; } && echo "  文件存在 && 不存在的文件 → $T" || echo "  文件存在 && 不存在的文件 → $F"

    title "2.2 OR：|| —— 任一边成功(0) 即为真"
    { [ -f "$nofile" ] || [ -f "$file" ];  } && echo "  不存在 || 文件存在  → $T" || echo "  不存在 || 文件存在  → $F"
    { [ -f "$nofile" ] || [ -d "$nofile" ]; } && echo "  不存在 || 不存在    → $T" || echo "  不存在 || 不存在    → $F"

    title "2.3 NOT：! —— 对退出码取反"
    { ! [ -f "$nofile" ]; }     && echo "  ! [不存在的文件]    → $T" || echo "  ! [不存在的文件]    → $F"
    { ! grep -q NOPE "$tmpf"; } && echo "  ! grep(没匹配NOPE)  → $T" || echo "  ! grep(没匹配NOPE)  → $F"
}


# =====================================================================
# 3. AND 的几种写法（同语义，不同载体）
# =====================================================================
demo_and()
{
    section "3. AND 的几种写法（同语义，不同载体）"
    note "目标：num1 < num2 且 str1 非空"

    # 写法1：[[ ]] 里写 &&（最简洁，仅 bash 的 [[ 支持）
    if [[ $num1 -lt $num2 && -n "$str1" ]]; then echo "  写法1  [[ ... && ... ]]   → $T"; fi
    # 写法2：两个独立 [ ] 用 && 连（POSIX 兼容，最推荐的可移植写法）
    if [ "$num1" -lt "$num2" ] && [ -n "$str1" ]; then echo "  写法2  [ ] && [ ]        → $T"; fi
    # 写法3：test -a（POSIX 已标记废弃，[[ ]] 还不支持，别用）
    if test "$num1" -lt "$num2" -a -n "$str1"; then echo "  写法3  test -a（已废弃） → $T"; fi
    # 写法4：嵌套 if（逻辑等价 AND，但啰嗦，仅作对比）
    if [ "$num1" -lt "$num2" ]; then
        if [ -n "$str1" ]; then echo "  写法4  嵌套 if           → $T"; fi
    fi
}


# =====================================================================
# 4. OR 的几种写法
# =====================================================================
demo_or()
{
    section "4. OR 的几种写法"
    note "目标：num1 > 100 或 str1 == hello"

    if [[ $num1 -gt 100 || $str1 == hello ]]; then echo "  写法1  [[ ... || ... ]]   → $T"; fi
    if [ "$num1" -gt 100 ] || [ "$str1" = hello ]; then echo "  写法2  [ ] || [ ]        → $T"; fi
    if test "$num1" -gt 100 -o "$str1" = hello; then echo "  写法3  test -o（已废弃） → $T"; fi

    note "case 也能表达 OR（模式匹配版）：str1 命中 hello|hi 之一"
    case "$str1" in
        hello|hi) echo "  写法4  case (hello|hi)   → $T" ;;
        *)        echo "  写法4  case             → $F" ;;
    esac
}


# =====================================================================
# 5. NOT 取反：两个位置
# =====================================================================
demo_not()
{
    section "5. NOT 取反：两个位置"
    note "! 可放在【命令前】(对退出码取反)，也可放在【括号里】(对表达式取反)"

    if ! [ -f "$nofile" ]; then echo "  位置A  ! [ -f 不存在 ]   （命令前取反）→ $T"; fi
    if   [ ! -f "$nofile" ]; then echo "  位置B  [ ! -f 不存在 ]  （括号内取反）→ $T"; fi
    # 对一整组条件取反：用 { } 分组后再 ! 取反
    if ! { [ -f "$nofile" ] || [ -d "$nofile" ]; }; then
        echo "  组合   ! { A || B }       （整体取反）→ $T"
    fi
}


# =====================================================================
# 6. 混合嵌套：优先级 / 分组 / 德摩根定律
# =====================================================================
demo_nesting()
{
    section "6. 混合嵌套：优先级 / 分组 / 德摩根定律"

    title "6.1 优先级：! > && > ||"
    note "! 绑定最紧： ! A && B  等价于  (!A) && B"
    # A=[不存在文件]=假, B=[/etc是目录]=真  →  (!假) && 真 = 真 && 真 = 真
    { ! [ -f "$nofile" ] && [ -d /etc ]; } && echo "  !假 && 真 → $T（! 先算）" || echo "  !假 && 真 → $F"

    title "6.2 用 { } 明确结合顺序"
    note "想表达 (A 或 B) 且 C，必须分组；否则 A || B && C 会被解析成 A || (B && C)"
    # (num1>100 或 str1==hello) 且 empty 非空  →  (假||真) && 假 = 真 && 假 = 假
    if { [ "$num1" -gt 100 ] || [ "$str1" = hello ]; } && [ -n "$empty" ]; then
        echo "  (A||B) && C → $T"
    else
        echo "  (A||B) && C → $F（empty 为空，C 为假）"
    fi

    title "6.3 德摩根定律：!(A && B) ≡ (!A) || (!B)"
    note "「不同时满足两个条件」=「至少有一个不满足」"
    # A=num1>100=假, B=empty非空=假  →  !(假&&假) = !假 = 真
    if ! { [ "$num1" -gt 100 ] && [ -n "$empty" ]; }; then
        echo "  !(A && B)    → $T"
    fi
    if ! [ "$num1" -gt 100 ] || [ -z "$empty" ]; then
        echo "  (!A) || (!B) → $T（与上式等价）"
    fi
}


# =====================================================================
# 7. 条件载体对比：[ ] vs [[ ]] vs (( )) vs case
# =====================================================================
demo_carriers()
{
    section "7. 条件载体对比：[ ] vs [[ ]] vs (( )) vs case"
    note "它们只是【产生退出码的方式】不同，选哪个看场景"
    local val=5
    [[ $val == 5 ]] && echo "  [[ ]]  字符串/模式，bash 推荐，支持 =~ 正则 → $T"
    [   "$val" = 5 ] && echo "  [ ]   POSIX 兼容，注意 = 两边和引号      → $T"
    ((  val == 5 )) && echo "  (( )) 数值比较专用，变量可不加 \$         → $T"
    case "$val" in 5) echo "  case  多分支/模式匹配，适合枚举判断     → $T";; esac

    note "正则匹配只有 [[ ]] 的 =~ 支持（右边不要加引号，加了会变字面量）"
    [[ "$str1" =~ ^h.+o$ ]] && echo "  str1 =~ ^h.+o\$ (hello 命中) → $T" || echo "  str1 =~ ^h.+o\$ → $F"
}


# =====================================================================
# 8. 裸命令直接做条件（不必套 [ ]）
# =====================================================================
demo_bare_command()
{
    section "8. 裸命令直接做条件（不必套 [ ]）"
    note "任何命令的退出码都能当条件，这是 if 最通用、却最被低估的用法"

    if grep -q ERROR "$tmpf"; then echo "  grep -q（日志含 ERROR）        → $T"; fi
    if command -v bash &> /dev/null; then echo "  command -v（bash 已安装）  → $T"; fi
    if ! command -v "$nocmd" &> /dev/null; then echo "  ! command -v（$nocmd 没装）→ $T"; fi
    # cd 成功（退出码 0）才进去操作
    if cd /tmp 2>/dev/null; then echo "  cd /tmp 成功                  → $T"; cd - >/dev/null; fi
}


# =====================================================================
# 9. 条件块素材：字符串 / 数值 / 文件测试速览
# =====================================================================
demo_cond_types()
{
    section "9. 条件块素材：字符串 / 数值 / 文件测试速览"

    title "9.1 字符串"
    [[ "$str1" == "$str2" ]] && echo "  == 相等        → $T" || echo "  == 相等        → $F"
    [[ "$str1" != "$str2" ]] && echo "  != 不等        → $T" || echo "  != 不等        → $F"
    [[ -z "$empty" ]]        && echo "  -z 为空        → $T" || echo "  -z 为空        → $F"
    [[ -n "$str1" ]]         && echo "  -n 非空        → $T" || echo "  -n 非空        → $F"
    [[ "$str1" < "$str2" ]]  && echo "  <  字典序在前  → $T" || echo "  <  字典序在前  → $F"

    title "9.2 数值（两种载体等价）"
    [[ $num1 -lt $num2 ]] && echo "  [[ -lt ]] 小于 → $T" || echo "  [[ -lt ]] 小于 → $F"
    ((  num1 < num2 ))    && echo "  (( < ))   小于 → $T" || echo "  (( < ))   小于 → $F"
    ((  num1 == 10 ))     && echo "  (( == ))  等于 → $T" || echo "  (( == ))  等于 → $F"

    title "9.3 文件测试"
    [[ -e "$file" ]] && echo "  -e 存在         → $T" || echo "  -e 存在         → $F"
    [[ -f "$file" ]] && echo "  -f 普通文件     → $T" || echo "  -f 普通文件     → $F"
    [[ -d "/etc" ]]  && echo "  -d 目录         → $T" || echo "  -d 目录         → $F"
    [[ -r "$file" ]] && echo "  -r 可读         → $T" || echo "  -r 可读         → $F"
    [[ -s "$file" ]] && echo "  -s 大小>0       → $T" || echo "  -s 大小>0       → $F"
}


# =====================================================================
# 10. 短路陷阱：cond && A || B
# =====================================================================
demo_trap()
{
    section "10. 短路陷阱：cond && A || B"
    note "它看起来像「成功走 A、失败走 B」，但【A 自己执行失败时，B 也会被触发】！"
    note "因为 A 失败后退出码非 0，|| 后的 B 就会接着执行 → 误走「失败分支」"

    # 安全演示：echo 不会失败，所以这里结果是对的
    grep -q NOPE "$tmpf" && echo "  含 NOPE：走 OK" || echo "  不含 NOPE：走 NG（结果正确，因为 echo 不会失败）"

    note "真正危险的是 A 是「可能失败的命令」时。规避方法："
    # 规避1（首选）：老老实实用 if，语义最清晰、无陷阱
    if grep -q NOPE "$tmpf"; then
        echo "  规避1 if 写法：含 NOPE"
    else
        echo "  规避1 if 写法：不含 NOPE"
    fi
    # 规避2：用 { } 把 then 分支收尾成「保证成功」，避免误触发 || 分支
    grep -q NOPE "$tmpf" && { echo "  规避2 { } 写法：含 NOPE"; true; } || { echo "  规避2 { } 写法：不含 NOPE"; true; }
}


# =====================================================================
# 11. 实战综合示例
# =====================================================================
demo_realworld()
{
    section "11. 实战综合示例"
    local score=85 maybe_empty=""

    title "11.1 复合 AND：满足全部条件才执行"
    note "场景：root 身份 + 文件可读 + 已装 gzip，三者都满足才允许解压"
    if [ "$(id -u)" -eq 0 ] && [ -r "$file" ] && command -v gzip &> /dev/null; then
        echo "  ✅ 所有条件满足（仅演示，不解压）"
    else
        echo "  ⚠️  条件不满足，跳过"
    fi

    title "11.2 elif 链：互斥多分支（成绩评级）"
    if   (( score >= 90 )); then echo "  score=$score → 优秀"
    elif (( score >= 80 )); then echo "  score=$score → 良好"
    elif (( score >= 60 )); then echo "  score=$score → 及格"
    else                          echo "  score=$score → 不及格"
    fi

    title "11.3 变量可能为空时的健壮判断"
    note "用 \${var:-默认} 提供兜底，既避免语法错，也不触发 set -u"
    if [ "${maybe_empty:-UNSET}" = "UNSET" ]; then
        echo "  maybe_empty 为空 → 命中默认分支（健壮写法）"
    fi
}


# =====================================================================
# 主流程：下面的调用列表就是【目录索引】
# 想跳过某节，注释掉对应行即可；想单独调试某节，也可直接调用该函数。
# =====================================================================
main()
{
    setup_fixtures       # 初始化测试数据（必须最先）
    demo_setup           # 0. 前置测试数据
    demo_exit_code       # 1. if 看退出码（核心概念）
    demo_operators       # 2. && / || / ! 三大运算符
    demo_and             # 3. AND 的几种写法
    demo_or              # 4. OR 的几种写法
    demo_not             # 5. NOT 取反的两个位置
    demo_nesting         # 6. 优先级 / 分组 / 德摩根
    demo_carriers        # 7. [ ] vs [[ ]] vs (( )) vs case
    demo_bare_command    # 8. 裸命令直接做条件
    demo_cond_types      # 9. 字符串 / 数值 / 文件测试
    demo_trap            # 10. cond && A || B 短路陷阱
    demo_realworld       # 11. 实战综合示例
    echo -e "\n${BOLD}${GREEN}脚本演示完毕。${NC}"
}

# 仅当【直接执行】时才跑 main；被 source 时不跑，方便单独调试某个 demo_xxx 函数。
# （BASH_SOURCE 的用法见 11.commands.md）
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]]; then
    main "$@"
fi
