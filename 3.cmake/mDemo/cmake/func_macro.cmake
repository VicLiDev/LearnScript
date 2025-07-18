MESSAGE(STATUS "-------- FUNC_MACRO --------")
# ----------------------------------------------------------------------------
# FUNCTION
# ----------------------------------------------------------------------------
# CMake 中自定义函数的基本语法
#   function(<name> [arg1 [arg2 ...]])
#       # 函数体
#       # 这里可以访问参数，使用 ${arg1}, ${arg2} 等
#   endfunction()
# <name>：函数名字
# [arg1 arg2 ...]：函数参数列表，调用时按顺序传入
# 函数体内通过 ${arg} 访问参数
#
# 总体概念（适用于函数和宏）
# 变量     含义
# ARGC     参数总数（不包括定义时的命名参数）
# ARGV     所有参数（分号分隔的列表）
# ARGV<n>  第 n 个参数，例如 ARGV0 是第一个参数
# ARGN     “未命名参数”列表：即调用时传入，但没有在定义中声明的部分
#
# 示例
#   function(print_message message)
#       message(STATUS "自定义函数打印: ${message}")
#   endfunction()
#   print_message("Hello from custom function!")
# 调用 print_message("Hello from custom function!")，会输出：
#   -- 自定义函数打印: Hello from custom function!
#
# 复杂一点的示例：带多个参数和循环
function(print_all_args)
    message(STATUS "print all paras:")
    foreach(arg IN LISTS ARGN)
        message(STATUS "  - ${arg}")
    endforeach()
endfunction()
print_all_args("arg1" "arg2" "arg3")
# 说明：
#   ARGN 是函数接收的未命名参数的列表
#   foreach 遍历参数列表
#
# 函数和宏的区别
#   函数有自己的作用域，修改变量不会影响外部作用域
#   宏直接展开到调用处，修改变量会影响外部


# ----------------------------------------------------------------------------
# MACRO
# ----------------------------------------------------------------------------
# CMake 中的 宏（macro） 和函数（function）有类似的语法，但作用域行为不同。宏更像
# 是 C/C++ 中的“文本替换”机制，它是在调用处直接展开代码，因此会继承和影响调用者的
# 作用域。
#
# 基本语法
#   macro(<name> [arg1 [arg2 ...]])
#       # 宏体
#   endmacro()
# 使用时：
#   <name>(param1 param2 ...)
# 简单示例
macro(print_macro message)
    message(STATUS "this a macro: ${message}")
endmacro()

print_macro("Hello from macro!")
# 输出：
# -- this a macro: Hello from macro!
#
# 和函数一样，宏中可以使用：
#   ARGN：未命名参数（除了宏头部列出的）
#   ARGV0、ARGV1...：第 n 个参数
#   ARGC：参数个数
# 例：
macro(dump_args)
    message(STATUS "paras count: ${ARGC}")
    message(STATUS "all paras: ${ARGV}")
    message(STATUS "extra paras (ARGN): ${ARGN}")

    # 遍历所有参数
    message(STATUS "Iterating through all arguments:")
    foreach(arg ${ARGV})
        message(STATUS "arg: ${arg}")
    endforeach()

    # 只遍历额外参数 (ARGN)
    message(STATUS "Iterating through ARGN:")
    foreach(arg ${ARGN})
        message(STATUS "argn: ${arg}")
    endforeach()
endmacro()

dump_args(A B C D)
MESSAGE(STATUS "-------- FUNC_MACRO END --------")
