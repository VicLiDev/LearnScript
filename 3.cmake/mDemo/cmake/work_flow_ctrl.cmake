MESSAGE(STATUS "-------- WORK FLOW CTRL --------")

# ----------------------------------------------------------------------------
# `if` 条件判断
# ----------------------------------------------------------------------------
# 基本语法：
#   if(<condition>)
#     # 真时执行
#   elseif(<condition2>)
#     # 第二个条件为真时执行
#   else()
#     # 都不满足时执行
#   endif()
#
# 支持的条件表达式包括：
# 布尔值：`TRUE`、`FALSE`（大小写不敏感）
# 变量比较：
#   if(VAR)                  # VAR 变量存在且不为空
#   if(NOT VAR)              # 取反
#   if(VAR1 STREQUAL VAR2)   # 字符串相等
#   if(VAR1 EQUAL VAR2)      # 数值相等
#   if(VAR1 LESS VAR2)       # 小于
#   if(VAR1 GREATER VAR2)    # 大于
# 文件和路径判断：
#   if(EXISTS path/to/file)
#   if(IS_DIRECTORY path/to/dir)
#
# 常见的 if() 评估规则：
#   如果内容是 ON, YES, TRUE, Y 或非零数字 → 视为真
#   如果内容是 OFF, NO, FALSE, N, IGNORE, NOTFOUND, 空字符串或以 -NOTFOUND 结尾 → 视为假
#   如果内容是变量名且该变量已定义 → 视为真
#   如果内容是存在的文件路径 → 视为真
#
# 示例：
# set(MY_FLAG ON)
# 
# if(MY_FLAG)
#   message("Flag is set")
# else()
#   message("Flag is not set")
# endif()

# 关于 if(${VAR})
# 执行流程是：先把 ${VAR} 展开，然后再进行if判断
# if(${VAR}) 几乎只有一种合法场景：明确知道 VAR 里存的是一个完整 if 表达式
# 例如（高级玩法，不推荐给普通工程）：
#   set(EXPR "A AND B")
#   if(${EXPR})
#   这属于 元编程，99% 项目不该这么干。
# 通常情况下这样使用是危险的：
#
# 情况1: VAR 为空
#   unset(VAR)
#   if(VAR)       # 安全 → false
#   if(${VAR})    # ❌ 语法错误：if()
#   展开后：if()，直接 CMake error
# 情况2: VAR 是字符串（极其危险）
#   set(VAR foo)
#   if(VAR)       # true（非空）
#   if(${VAR})    # if(foo)
#   这等价于：
#   if(foo)
#   CMake 会尝试：
#     把 foo 当变量
#     把 foo 当命令
#     或当表达式的一部分
#     结果是：不可预测
# 情况3: VAR 是 0 / 1 / ON / OFF（看似“能用”）
#   set(VAR OFF)
#   if(VAR)       # false
#   if(${VAR})    # if(OFF)
#   这次刚好没炸，
#   于是就形成了“它好像也能用”的错觉
#   但这只是偶然安全

# ----------------------------------------------------------------------------
# `foreach` 循环
# ----------------------------------------------------------------------------
#
# 用于遍历列表、字符串、范围等。
#
# 基本语法：
#   foreach(var IN LISTS my_list)
#     message("${var}")
#   endforeach()
#
# 常见用法：
#
# 遍历变量值列表：
#   foreach(item IN ITEMS apple banana orange)
#     message("Fruit: ${item}")
#   endforeach()
#
# 遍历已有的 list 变量：
#   set(mylist a b c)
#   foreach(i IN LISTS mylist)
#     message("Item: ${i}")
#   endforeach()
#
# 使用数值范围：
#   foreach(i RANGE 1 3)  # 1 到 3
#     message("i = ${i}")
#   endforeach()
#
# ----------------------------------------------------------------------------
# `while` 循环
# ----------------------------------------------------------------------------
# 语法：
# set(count 0)
# while(count LESS 5)
#   message("count = ${count}")
#   math(EXPR count "${count} + 1")
# endwhile()
# **注意**：`while` 循环容易引发死循环，必须手动更新循环条件。
#
#
# ----------------------------------------------------------------------------
# `break` 和 `continue`
# ----------------------------------------------------------------------------
#
# 在 `foreach` 和 `while` 中使用：
#   foreach(i RANGE 1 5)
#     if(i EQUAL 3)
#       continue()  # 跳过 i == 3
#     endif()
#     if(i GREATER 4)
#       break()     # i > 4 时跳出循环
#     endif()
#     message("i = ${i}")
#   endforeach()


# ----------------------------------------------------------------------------
# Demo
# ----------------------------------------------------------------------------

# 1. 平台判断
if(WIN32)
  message("You're on Windows")
elseif(APPLE)
  message("You're on macOS")
elseif(UNIX)
  message("You're on Linux")
else()
  message("Unknown platform")
endif()

# 2. 遍历文件扩展名（foreach IN ITEMS）
set(EXTS cpp hpp c h)
message("== File Extensions ==")
foreach(ext IN ITEMS ${EXTS})
  message("Extension: .${ext}")
endforeach()

# 3. 创建一个列表变量，然后遍历（foreach IN LISTS）
set(SRC_FILES main.cpp utils.cpp helper.cpp)

message("== Source Files ==")
foreach(file IN LISTS SRC_FILES)
  message("Source file: ${file}")
endforeach()

# 4. 数值循环 + 条件控制
message("== Range Loop with Condition ==")
foreach(i RANGE 0 5)
  if(i EQUAL 3)
    message("Skipping 3")
    continue()
  endif()

  if(i GREATER 4)
    message("Breaking at 5")
    break()
  endif()

  message("Number: ${i}")
endforeach()

# 5. 检查某些文件是否存在
message("== Checking file existence ==")
set(FILES_TO_CHECK CMakeLists.txt not_exist.txt)

foreach(f IN LISTS FILES_TO_CHECK)
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${f})
    message("Found: ${f}")
  else()
    message("Not found: ${f}")
  endif()
endforeach()

# 6. 使用 while 实现简单计数器
message("== While Loop Example ==")
set(counter 0)
while(counter LESS 3)
  message("Counter is ${counter}")
  math(EXPR counter "${counter} + 1")
endwhile()

# 7. 创建源文件列表并根据平台添加额外的源文件
message("== Platform-Specific Sources ==")
set(PLATFORM_SRC)

if(WIN32)
  list(APPEND PLATFORM_SRC win_utils.cpp)
elseif(APPLE)
  list(APPEND PLATFORM_SRC mac_utils.mm)
elseif(UNIX)
  list(APPEND PLATFORM_SRC linux_utils.cpp)
endif()

foreach(src IN LISTS PLATFORM_SRC)
  message("Platform-specific file: ${src}")
endforeach()

# 8. 自定义函数，使用if和foreach内部控制
function(print_valid_files filelist)
  foreach(file IN LISTS filelist)
    if(file MATCHES ".*\\.cpp$")
      message("Valid source file: ${file}")
    else()
      message("Skipping non-cpp file: ${file}")
    endif()
  endforeach()
endfunction()

# 调用函数
set(MYFILES main.cpp readme.md utils.cpp)
print_valid_files("${MYFILES}")

# 9. 总结信息
message("CMake version: ${CMAKE_VERSION}")

MESSAGE(STATUS "-------- WORK FLOW CTRL END --------")
