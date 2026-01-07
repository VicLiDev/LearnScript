MESSAGE(STATUS "-------- VARIABLE --------")
# ----------------------------------------------------------------------------
# 一、变量类型
# ----------------------------------------------------------------------------

# 1. 普通变量
# 最基本的变量类型，使用 `set()` 命令定义：
set(MY_VARIABLE "Hello World")

# 2. 缓存变量 (Cache Variables)
# 持久化存储在 CMakeCache.txt 文件中，跨多次运行保持：
set(MY_CACHE_VARIABLE "Cache Value" CACHE STRING "Description")

# 3. 环境变量
# 访问系统环境变量：
set(ENV{PATH} "$ENV{PATH}:/opt/local/bin")
message(STATUS "PATH is $ENV{PATH}")

# 4. 选项变量 (Option Variables)
# 特殊的缓存变量，用于布尔开关：
option(MY_OPTION "Enable my feature" ON)

# ----------------------------------------------------------------------------
# 二、变量作用域
# ----------------------------------------------------------------------------

# 1. 目录作用域 (Directory Scope)
# 在当前目录及子目录中有效

# 2. 函数作用域 (Function Scope)
# 在函数内部定义的变量只在函数内有效：
function(my_func)
    set(LOCAL_VAR "Local" PARENT_SCOPE)  # 需要PARENT_SCOPE才能影响外部
endfunction()

# 3. 持久缓存作用域 (Persistent Cache Scope)
# 缓存变量在整个构建过程中都有效

# ----------------------------------------------------------------------------
# 三、变量操作
# ----------------------------------------------------------------------------

# 1. 设置变量
set(VAR_NAME value1 value2 value3)  # 设置普通变量
set(VAR_NAME value CACHE TYPE "docstring" [FORCE])  # 设置缓存变量

# 2. 取消设置变量
unset(VAR_NAME)
unset(VAR_NAME CACHE)  # 取消缓存变量

# 3. 变量引用
# ${VAR_NAME}  # 引用变量
# $ENV{VAR_NAME}  # 引用环境变量
# $CACHE{VAR_NAME}  # 显式引用缓存变量(CMake 3.21+)

# 4. 列表操作
list(APPEND MY_LIST "new_item")  # 追加
list(REMOVE_ITEM MY_LIST "item") # 删除
list(LENGTH MY_LIST len)         # 长度
list(GET MY_LIST 0 first)        # 获取元素

# 5. 字符串操作
# `string` 命令的基本格式是：
# string(<operation> <input> <output_variable> [<args>...])
# 转换为大写  输出: ORIGINAL STRING
string(TOUPPER "original string" result)
message(STATUS "Uppercase: ${result}")
# 转换为小写   输出: original string
string(TOLOWER "Original String" result)
message(STATUS "Lowercase: ${result}")
# 字符串长度   输出: 5
string(LENGTH "Hello" len)
message(STATUS "Length: ${len}")
# 子字符串   输出: World
string(SUBSTRING "Hello World" 6 5 substr)
message(STATUS "Substring: ${substr}")
# 字符串查找   输出: 6
string(FIND "Hello World" "World" position)
message(STATUS "Found at: ${position}")
# 字符串替换   输出: Hello CMake
string(REPLACE "World" "CMake" result "Hello World")
message(STATUS "Replaced: ${result}")
# 正则表达式匹配   输出: abc
string(REGEX MATCH "[A-Za-z]+" match "123abc456")
message(STATUS "Match: ${match}")
# 字符串追加   输出: Hello World
set(str "Hello")
string(APPEND str " World")
message(STATUS "Appended: ${str}")
# 字符串去空格   输出: 'Hello'
string(STRIP "  Hello  " stripped)
message(STATUS "Stripped: '${stripped}'")
# 注意事项
# 1. **输出变量必须指定**：所有 `string` 命令操作都需要指定输出变量
# 2. **输入可以是变量或字面量**：`<input>` 可以是直接字符串或变量引用 `${var}`
# 3. **操作区分大小写**：如 `TOUPPER` 和 `TOLOWER` 必须全大写
# 4. **索引从0开始**：如 `SUBSTRING` 操作的起始位置

# ----------------------------------------------------------------------------
# 四、变量类型与验证
# ----------------------------------------------------------------------------

# 1. 缓存变量类型
# - `STRING`: 字符串
# - `FILEPATH`: 文件路径
# - `PATH`: 目录路径
# - `BOOL`: 布尔值(ON/OFF)
# - `INTERNAL`: 内部使用，不显示在GUI中

# 2. 类型检查
# if(DEFINED VAR_NAME)  # 检查变量是否定义
# if(VAR_NAME)         # 检查变量是否为真
# 在 CMake 的 `if()` 语句中使用变量时，**是否加 `${}` 取决于上下文**，具体规则如下：

# a. **基本规则：大多数情况需要 `${}`**
set(MY_FLAG ON)
if(${MY_FLAG})  # 正确：需要展开变量
    message("MY_FLAG is ON")
endif()

# b. **例外情况：直接使用变量名（不加 `${}`）**
# 以下场景中，CMake 会自动解析变量名，无需 `${}`：
# (1) **布尔变量直接判断**
option(ENABLE_FEATURE "Enable feature" ON)
if(ENABLE_FEATURE)  # 正确：option变量可直接使用名称
    message("Feature is enabled")
endif()
# (2) **变量名作为字符串比较**
set(MODE "DEBUG")
if(MODE STREQUAL "DEBUG")  # 正确：直接比较变量名和字符串
    message("Debug mode")
endif()
# (3) **存在歧义时需要 `${}`**
# set(TRUE_VAR "YES")
# if(TRUE_VAR)      # 错误：会检查变量名"TRUE_VAR"是否存在（始终为真）
# if(${TRUE_VAR})   # 正确：展开为 "YES" 再判断

# c. **关键区别**
# | 语法         | 行为                                                                 |
# |--------------|----------------------------------------------------------------------|
# | `if(VAR)`    | 检查变量 `VAR` 是否已定义且非假值（`OFF`/`NO`/`0`/`""`/`FALSE`/`N`） |
# | `if(${VAR})` | 先展开变量内容，再判断展开后的值                                     |

# d. **最佳实践建议**
# (1). **明确意图**：
#    - 如果想检查变量是否定义/为真 → `if(VAR)`
#    - 如果想使用变量的值 → `if(${VAR})`
#
# (2). **复杂表达式加 `${}`**：
#    if("${VAR1}_${VAR2}" STREQUAL "hello_world")
#
# (3). **避免歧义**：
#    set(HELLO "YES")
#    if(HELLO)          # 可能误判（实际检查变量名HELLO是否存在）
#    if(${HELLO})       # 明确检查值"YES"

# e. **官方文档参考**
# CMake 官方明确说明：
# > _"在 `if()` 中，变量引用可以用 `${VAR}` 或直接 `VAR` 形式，但含义不同。"_
#
# 建议在不确定时优先使用 `${}` 明确展开变量值。


# ----------------------------------------------------------------------------
# 五、特殊变量
# ----------------------------------------------------------------------------

# 1. 预定义变量
# - `CMAKE_SOURCE_DIR`: 顶级CMakeLists.txt所在目录
# - `CMAKE_BINARY_DIR`: 构建目录
# - `CMAKE_CURRENT_SOURCE_DIR`: 当前处理的CMakeLists.txt目录
# - `CMAKE_CURRENT_BINARY_DIR`: 当前构建目录
# - `PROJECT_NAME`: 项目名称
# - `CMAKE_BUILD_TYPE`: 构建类型(Debug/Release等)

# 2. 生成器表达式
# 生成器表达式是：在 generate 阶段 才求值的“条件表达式”，
# 用来根据配置 / target / 属性，动态生成构建规则。
# 语法特征：$<...>
# 核心要点：
#   不在 cmake ..（configure）阶段求值，在 生成构建系统（Makefile / Ninja）时才展开
#   最终求到的值都是文本，或者说是字符串
#   主要用于：
#       条件源文件
#       条件编译选项
#       条件链接
#       条件路径
# 表达式内部的两种基本形态
#   操作符表达式（Operator form）
#       $<OPERATOR:ARG1,ARG2,...>
#       其中：
#       OPERATOR：内建操作符（固定集合）
#       :：操作符与参数的分隔符
#       ,：参数分隔符
#       示例
#       $<CONFIG>
#       $<CONFIG:Debug>
#       $<BOOL:${ENABLE_LOG}>
#       $<TARGET_FILE:mylib>
#       $<TARGET_OBJECTS:objlib>
#   条件表达式（Conditional form）
#       $<CONDITION:RESULT>
#       注意：
#       这里的 CONDITION 本身仍然是一个生成器表达式
#       示例
#       $<$<CONFIG:Debug>:foo>
#       拆解：
#       $<
#         CONDITION : RESULT
#       >
#       所以：
#       CONDITION → "1" / "0"
#       CONDITION 为真 → 输出 RESULT
#       CONDITION 为假 → 输出空字符串 ""
# 冒号 : 的语法规则
#   规则1: 冒号永远分隔“左语义”和“右结果” (左边  :  右边)
#   规则2: 冒号的含义取决于上下文，但语法角色始终一样：分隔
#       上下文 $<OP:ARG>      含义 OP 的参数
#       上下文 $<COND:RESULT> 含义 条件 → 结果
#   规则3: 最外层只允许一个冒号
#       错误：$<A:B:C>
#       正确（嵌套）： $<A:$<B:C>>
# 因为在 generate 阶段展开，所以
#   if($<CONFIG:Debug>)                                                   # 错
#   target_compile_definitions(tgt PRIVATE $<$<CONFIG:Debug>:DEBUG_MODE>) # 正确
#
#
# 常用生成器表达式分类
#
# 配置相关（单 / 多配置）
#   $<CONFIG:Debug>           # 当前配置是否为 Debug，为Debug得到1，否则为0
#   $<CONFIG:Release>
#   $<CONFIG:RelWithDebInfo>
#   $<CONFIG>                 # 当前配置名（字符串）
#   用法示例：
#   target_compile_options(app PRIVATE
#       $<$<CONFIG:Debug>:-O0 -g>
#       $<$<CONFIG:Release>:-O3>
#   )
#
# 布尔 / 逻辑表达式
#   布尔转换(转换为bool值)
#   $<BOOL:expr>        # 非空 / 非 0 → 1，否则 0
#   $<NOT:expr>
#   逻辑运算
#   $<AND:expr1,expr2>
#   $<OR:expr1,expr2>
#   示例：
#   $<$<AND:$<CONFIG:Debug>,$<BOOL:${ENABLE_LOG}>>:ENABLE_LOG>
#
# 条件选择（最常用）
#   语法
#   $<$<condition>:value>
#   condition 为真 → 展开 value
#   否则 → 空
#   示例（条件源文件）：
#   target_sources(lib PRIVATE
#       $<$<BOOL:${HAVE_VDPU341}>:hal_h265d_rkv.c>
#   )
#   这是 HAL 场景最推荐的用法
#
# target / 文件路径相关（非常重要）
#   $<TARGET_FILE:tgt>        # 目标文件路径（.a / .so / exe）
#   $<TARGET_FILE_DIR:tgt>
#   $<TARGET_FILE_NAME:tgt>
#   $<TARGET_OBJECTS:tgt>     # OBJECT library 的 .o 列表
#   示例：
#   add_custom_command(
#       COMMAND cp $<TARGET_FILE:mylib> /tmp
#   )
#
# target 属性查询
#   $<TARGET_PROPERTY:tgt,PROPERTY>
#   $<TARGET_PROPERTY:PROPERTY>   # 当前 target
#   示例：
#   $<TARGET_PROPERTY:INTERFACE_INCLUDE_DIRECTORIES>
#
# 平台 / 编译器相关
#   $<PLATFORM_ID:Linux>
#   $<C_COMPILER_ID:GNU>
#   $<CXX_COMPILER_ID:Clang>
#   示例：
#   target_compile_options(app PRIVATE
#       $<$<C_COMPILER_ID:GNU>:-Wall>
#   )
#
# 语言相关
#   $<COMPILE_LANGUAGE:C>
#   $<COMPILE_LANGUAGE:CXX>
#   示例：
#   target_compile_definitions(lib PRIVATE
#       $<$<COMPILE_LANGUAGE:CXX>:USE_CPP>
#   )
#
# 字符串 / list 操作（高级）
#   $<JOIN:list,delimiter>
#   $<LOWER_CASE:expr>
#   $<UPPER_CASE:expr>
#   示例：
#   $<JOIN:$<TARGET_OBJECTS:objlib>,\n>

# ----------------------------------------------------------------------------
# 六、最佳实践
# ----------------------------------------------------------------------------

# 1. **命名约定**：
#    - 使用大写字母和下划线命名变量(MY_VARIABLE)
#    - 项目特定变量加项目前缀(PROJECTNAME_VAR)

# 2. **作用域控制**：
#    - 尽量限制变量作用域
#    - 使用函数参数而非全局变量传递数据

# 3. **缓存变量使用**：
#    - 为用户可配置选项使用缓存变量
#    - 提供有意义的描述文档

# 4. **变量保护**：
#    - 使用`if(DEFINED ...)`检查变量
#    - 避免覆盖重要变量

# 5. **调试变量**：
#    ```cmake
#    message(STATUS "Variable value: ${VAR_NAME}")
#    ```

# ----------------------------------------------------------------------------
# 七、高级主题
# ----------------------------------------------------------------------------

# 1. 变量继承
# ```cmake
# # 父目录变量自动对子目录可见
# # 使用PARENT_SCOPE修改父作用域变量
# ```

# 2. 变量转义
# ```cmake
# # 使用\${VAR}避免立即展开
# set(ESC "\${VAR}")
# ```

# 3. 变量属性
define_property(DIRECTORY PROPERTY MY_PROPERTY
    BRIEF_DOCS "Brief documentation"
    FULL_DOCS "Full documentation"
)

# 4. 策略设置
# cmake_policy(SET CMP0054 NEW)  # 控制变量引用的行为

MESSAGE(STATUS "-------- VARIABLE END --------")
