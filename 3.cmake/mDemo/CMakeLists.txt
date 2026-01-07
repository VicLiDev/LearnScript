###############################################
# base options
###############################################

# CMake 的工作严格分成三段，完整三阶段时间线：
#   1. configure 阶段   → cmake ..
#       主要做的事：
#           解析 CMakeLists.txt
#           set() / option() / if()
#           检测编译器
#           查找库（find_package）
#           决定 target 结构
#           这时不会生成 Makefile / build.ninja
#   2. generate 阶段    → cmake ..（同一次命令里）
#       主要做的事：
#           把 configure 阶段得到的 target graph
#           转换成：
#               Makefile
#               build.ninja
#               VS 工程文件
#               展开 generator expression（$<...>）
#           执行：
#               file(GENERATE)
#               $<TARGET_OBJECTS:...>
#               $<CONFIG:Debug>
#               这是 generator expression 唯一生效的阶段
#   3. build 阶段       → make / ninja / make -j
#       主要做的事：
#           编译 .c → .o
#           执行 add_custom_command
#           链接 .o → .a / .so / ELF
#           这一阶段不会再解析 CMake 逻辑

#指定运行此配置文件所需的 CMake 的最低版本
CMAKE_MINIMUM_REQUIRED(VERSION 3.5)

# 项目名称
# 基本语法
#   project(<PROJECT-NAME>
#           [VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
#           [DESCRIPTION <project-description-string>]
#           [HOMEPAGE_URL <url-string>]
#           [LANGUAGES <language-name>...])
#
# 参数说明
# 1. PROJECT-NAME (必需):
#   指定项目名称
#   名称会被存储在变量PROJECT_NAME和CMAKE_PROJECT_NAME中
# 2. VERSION (可选):
#   指定项目版本号，格式为major.minor.patch.tweak
#   会设置以下变量:
#     PROJECT_VERSION, PROJECT_VERSION_MAJOR, PROJECT_VERSION_MINOR,
#     PROJECT_VERSION_PATCH, PROJECT_VERSION_TWEAK
#   以及对应的<PROJECT-NAME>_VERSION系列变量
# 3. DESCRIPTION (可选):
#   项目的简短描述
#   存储在PROJECT_DESCRIPTION变量中
# 4. HOMEPAGE_URL (可选):
#   项目主页URL
#   存储在PROJECT_HOMEPAGE_URL变量中
# 5. LANGUAGES (可选):
#   指定项目使用的编程语言，如C, CXX, Fortran等
#   默认包含C和CXX
#   如果指定此参数，则只启用指定的语言
#
# 重要变量
#   PROJECT命令会设置以下变量:
#   PROJECT_NAME: 当前项目名称
#   PROJECT_SOURCE_DIR: 项目源目录
#   PROJECT_BINARY_DIR: 项目构建目录
#   PROJECT_VERSION系列变量(如果指定了VERSION)
#   CMAKE_PROJECT_NAME: 顶层项目名称
#   <PROJECT-NAME>_SOURCE_DIR和<PROJECT-NAME>_BINARY_DIR

PROJECT(mDemoPrj C)

SET (Demo_VERSION_MAJOR 3)
SET (Demo_VERSION_MINOR 6)

STRING(TIMESTAMP current_year "%Y" UTC)
STRING(TIMESTAMP current_time "%Y-%m-%d %H:%M:%S")
MESSAGE(STATUS "current time: ${current_time}")

# 可选的<mode>关键字确定消息的类型，这会影响消息的处理方式：
# FATAL_ERROR:        CMake错误，停止处理和生成。
# SEND_ERROR:         CMake错误，继续处理，但跳过生成。
# WARNING:            CMake警告，继续处理。
# AUTHOR_WARNING:     CMake警告（dev），继续处理。
# DEPRECATION:        如果分别启用了变量CMAKE_ERROR_DEPRECATED 或 
#                     CMAKE_WARN_DEPRECATED，则CMake弃用错误或警告，否则没有消息。
# (none) or NOTICE:   打印到stderr的重要消息以吸引用户的注意。
# STATUS:             项目用户可能会感兴趣的主要有趣消息。理想情况下，这些消息
#                     应该简洁明了，不超过一行，但仍能提供信息。
# VERBOSE:            适用于项目用户的详细参考消息。这些消息应提供在大多数情况下
#                     不会引起关注的其他详细信息，但对于希望更深入地了解正在发生
#                     的事情的项目开发人员来说可能很有用。
# DEBUG:              详细的信息性消息旨在提供给在项目本身上进行开发的开发人员，
#                     而不是只想构建该项目的用户。这些消息通常对构建项目的其他
#                     用户不感兴趣，并且通常与内部实现细节密切相关。
# TRACE:              具有非常低级的实现细节的细粒度消息。使用此日志级别的消息
#                     通常仅是临时的，并且有望在发布项目，打包文件等之前被删除。

# CMake命令行工具在stdout上显示STATUS 到 TRACE 的消息，该消息前面带有两个连字符
# 和一个空格。所有其他消息类型都发送到stderr，并且不带连字符前缀。
MESSAGE(STATUS "-------- MAIN CMAKELISTS MSG --------")

# --> 项目级目录变量（全局作用域） <--
# CMAKE_SOURCE_DIR
#   含义：顶层 CMake 项目的源代码目录
#   是否依赖project()： ❌ 不依赖
#   常见使用场景：整体构建系统中使用
# CMAKE_BINARY_DIR
#   含义：顶层构建输出目录
#   是否依赖project()： ❌ 不依赖
#   常见使用场景：设置全局构建输出
# PROJECT_SOURCE_DIR
#   含义：项目的源代码根目录（顶层 CMakeLists.txt 所在目录）
#         当前调用 project() 的目录（源）
#         无论在哪个CmakeList.txt里全局一致
#   是否依赖project()： ✅ 依赖
#   常见使用场景：适用于子项目
#   示例用途：添加全局头文件搜索路径、资源路径等
# <projectname>_SOURCE_DIR
#   含义：与 PROJECT_SOURCE_DIR 相同，<projectname> 为 project() 中定义的名称
#         无论在哪个CmakeList.txt里全局一致
#   示例用途：多项目工程中区分各子项目的源目录
# PROJECT_BINARY_DIR
#   含义：构建输出的根目录（即你执行 cmake 命令时指定的 build 目录）
#          当前调用 project() 的构建目录
#         无论在哪个CmakeList.txt里全局一致
#   是否依赖project()： ✅ 依赖
#   常见使用场景：子项目的构建根目录
#   示例用途：配置输出路径、生成中间文件等
# <projectname>_BINARY_DIR
#   含义：与 PROJECT_BINARY_DIR 类似，带有项目名前缀
#         无论在哪个CmakeList.txt里全局一致
#   示例用途：用于区分多项目的构建目录
#
# --> 当前 CMakeLists.txt 所在目录变量（局部作用域） <--
# CMAKE_CURRENT_SOURCE_DIR
#   含义：当前正在处理的 CMakeLists.txt 所在的源代码路径
#   说明：每次进入 add_subdirectory() 都会变化
# CMAKE_CURRENT_BINARY_DIR
#   含义：当前 CMakeLists.txt 的对应构建目录
#         如果是 in-source 编译，它跟 CMAKE_CURRENT_SOURCE_DIR一致
#         如果是 out-of-source编译，他指的是 target 编译目录
#   说明：in-source 构建时与 CMAKE_CURRENT_SOURCE_DIR 一致，out-of-source 时不同
# CMAKE_CURRENT_* 变量是 相对于每一个 CMakeLists.txt 文件而言的，适合模块化项目结构。
#
# --> 辅助调试相关变量 <--
# CMAKE_CURRENT_LIST_FILE
#   含义：当前被执行的 CMakeLists.txt 文件的完整路径（含文件名）
# CMAKE_CURRENT_LIST_LINE
#   含义：当前正在处理的这一行所在的行号
#
# --> 自定义模块搜索路径 <--
# CMAKE_MODULE_PATH
#   含义：设置 CMake 查找 .cmake 模块文件的路径列表，例如 find_package() 时的搜索路径
#   例如：list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
#         include(MyTools)

# 需要通过 SET 指令，将自己的 cmake 模块路径设置一下。注意，CMAKE_MODULE_PATH 有
# 高优先级，当需要重写标准Find<package>.cmake文件时可能很有用。
MESSAGE(STATUS "    CMAKE_SOURCE_DIR:    " ${CMAKE_SOURCE_DIR})
MESSAGE(STATUS "    CMAKE_BINARY_DIR:    " ${CMAKE_BINARY_DIR})
MESSAGE(STATUS "    PROJECT_SOURCE_DIR:  " ${PROJECT_SOURCE_DIR})
MESSAGE(STATUS "    mDemoPrj_SOURCE_DIR: " ${mDemoPrj_SOURCE_DIR})
MESSAGE(STATUS "    PROJECT_BINARY_DIR:  " ${PROJECT_BINARY_DIR})
MESSAGE(STATUS "    mDemoPrj_BINARY_DIR: " ${mDemoPrj_BINARY_DIR})
MESSAGE(STATUS "    CMAKE_ROOTR: " ${CMAKE_ROOT})
MESSAGE(STATUS "    CMAKE_CURRENT_LIST_FILE: " ${CMAKE_CURRENT_LIST_FILE})
MESSAGE(STATUS "    CMAKE_CURRENT_LIST_LINE: " ${CMAKE_CURRENT_LIST_LINE})
MESSAGE(STATUS "    CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR})
MESSAGE(STATUS "    CMAKE_CURRENT_SOURCE_DIR: " ${CMAKE_CURRENT_SOURCE_DIR})

MESSAGE(STATUS "-------- SET/GET ENV --------")
MESSAGE(STATUS "    HOME dir: $ENV{HOME}")
SET(ENV{HOME} "new home name")
MESSAGE(STATUS "    after set, HOME dir: $ENV{HOME}")
MESSAGE(STATUS "-------- SET/GET ENV END --------")

INCLUDE("${CMAKE_CURRENT_SOURCE_DIR}/cmake/variable.cmake")
INCLUDE("${CMAKE_CURRENT_SOURCE_DIR}/cmake/work_flow_ctrl.cmake")
INCLUDE("${CMAKE_CURRENT_SOURCE_DIR}/cmake/func_macro.cmake")
INCLUDE("${CMAKE_CURRENT_SOURCE_DIR}/cmake/custom.cmake")
INCLUDE("${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils.cmake")

###############################################
# base options end
###############################################

###############################################
# compile options
###############################################

# 编译选项相关的CMake 变量如下：
# CMAKE_C_FLAGS =
# CMAKE_C_FLAGS_DEBUG = -g
# CMAKE_C_FLAGS_MINSIZEREL = -Os -DNDEBUG
# CMAKE_C_FLAGS_RELEASE = -O3 -DNDEBUG
# CMAKE_C_FLAGS_RELWITHDEBINFO = -O2 -g -DNDEBUG
# 
# CMAKE_CXX_FLAGS =
# CMAKE_CXX_FLAGS_DEBUG = -g
# CMAKE_CXX_FLAGS_MINSIZEREL = -Os -DNDEBUG
# CMAKE_CXX_FLAGS_RELEASE = -O3 -DNDEBUG
# CMAKE_CXX_FLAGS_RELWITHDEBINFO = -O2 -g -DNDEBUG
# 等号右边是通过在CMakeLists.txt中打印对应变量得到的默认值。
# 对于C语言设置CMAKE_C_FLAGS相关参数，C++语言设置CMAKE_CXX_FLAGS相关参数。
# 并且分为DEBUG，RELEASE，MINSIZEREL和RELWITHDEBINFO四种类型。
#
# 以C++语言编译选项为例：
# CMAKE_CXX_FLAGS_DEBUG：编译Debug版本的时候会采用的编译选项，默认只有一个-g选项，包含调试信息；
# CMAKE_CXX_FLAGS_RELEASE：编译Release版本的时候采用的编译选项，默认包-O3选项，该选项表示优化等级；
# CMAKE_CXX_FLAGS_MINSIZEREL：主要减小目标文件大小，选项-Os就是这个作用；
# CMAKE_CXX_FLAGS_RELWITHDEBINFO：包含调试信息的Release版本，-O2和-g，优化的同时也包含了调试信息；
# CMAKE_CXX_FLAGS：这个选项没有默认值；
# 公共的选项，不管是Release还是Debug都需要设置。这种情况还可以把公共的设置放在CMAKE_CXX_FLAGS变量里面

# 让 CMake 支持 gdb 只需要指定 Debug 模式下开启 -g 选项:
# 如果以变量作为 if 的判断条件，只要非空就是有效
# 可以通过-DCMAKE_BUILD_TYPE=Release 或者 -D CMAKE_BUILD_TYPE=Release 参数在编译时修改
if(NOT CMAKE_BUILD_TYPE)
    SET(CMAKE_BUILD_TYPE "Debug")
endif(NOT CMAKE_BUILD_TYPE)
MESSAGE(STATUS "    -- enter CMAKE_BUILD_TYPE " ${CMAKE_BUILD_TYPE})
# 以下参数同样可以在使用cmake 时通过 -D 参数修改
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra") # debug 和 release 都会使用的公用flag
SET(CMAKE_C_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -g -ggdb")
SET(CMAKE_C_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
SET(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -g -ggdb")
SET(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3")
# add_compile_options 不区分编译器
# add_compile_options("-Wall")
# add_compile_options("-Wextra")

# 编译工具/交叉编译相关
#
# CMAKE_TOOLCHAIN_FILE 变量：
# CMAKE_TOOLCHAIN_FILE 是一个 CMake 变量，用于指定一个包含交叉编译环境配置的 .cmake
# 脚本文件。该文件可以包含交叉编译环境中的各种库和头文件路径、编译器和链接器的路径
# 等信息，使得 CMake 能够在交叉编译环境中正确地配置和构建工程。
# 使用方法：
# 1. 设置变量：CMakeLists.txt 文件中，set(CMAKE_TOOLCHAIN_FILE "<file.cmake>")
# 2. 命令行参数：通过 -DCMAKE_TOOLCHAIN_FILE=<file.cmake> 指定
#
# 注意：
# 设置位置：在 CMakeLists.txt 文件中，通常需要将 set(CMAKE_TOOLCHAIN_FILE ...)
#           放在 project() 命令之前，以确保在 CMake 配置项目之前加载工具链文件。
#
# 工具链文件（.cmake 脚本）通常包含以下内容：
# 1. 编译器设置：指定 C/C++ 编译器路径，set(CMAKE_C_COMPILER "<path_to_c_compiler>")、
#       set(CMAKE_CXX_COMPILER "<path_to_cxx_compiler>")。
# 2. 库和头文件路径：设置库文件和头文件的搜索路径，以便 CMake 在构建过程中能够找到
#       它们。这可以通过 include_directories() 和 link_directories() 等命令来实现，
#       更常见的是在工具链文件中使用 CMAKE_PREFIX_PATH、CMAKE_FIND_ROOT_PATH 等变量
#       来指定。
# 3. 系统名称和处理器架构：设置目标系统的名称（如 Linux、Windows）和处理器架构
#       （如 ARM、x86），以便 CMake 能够正确地配置交叉编译环境。
#
# 示例：
# # 设置目标系统名称和处理器架构
# set(CMAKE_SYSTEM_NAME Linux)
# set(CMAKE_SYSTEM_PROCESSOR arm)
#
# # 设置编译器
# set(CMAKE_C_COMPILER /opt/arm-toolchain/bin/arm-linux-gnueabihf-gcc)
# set(CMAKE_CXX_COMPILER /opt/arm-toolchain/bin/arm-linux-gnueabihf-g++)
#
# # 设置库和头文件搜索路径
# set(CMAKE_FIND_ROOT_PATH /opt/arm-toolchain/arm-linux-gnueabihf)
# set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
# set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
#
# 更为简单的方法，也可以直接在cmake中指定编译器
# SET(CMAKE_C_COMPILER "/usr/bin/arm-linux-gnueabihf-gcc")
# SET(CMAKE_CXX_COMPILER "/usr/.....")

# 变量 CMAKE_INCLUDE_CURRENT_DIR 的作用:
# 自动添加 CMAKE_CURRENT_BINARY_DIR 和 CMAKE_CURRENT_SOURCE_DIR 到当前处理的
# CMakeLists.txt。相当于在每个 CMakeLists.txt 加入:
#   INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
SET(CMAKE_INCLUDE_CURRENT_DIR ON)  # 不知道为什么失灵
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

# 指定生成链接链接库的存放路径,不指定的话默认是存放在跟当前 CMakeLists.txt 一样的路径
# 该设置也可以跟随 ADD_LIBRARY 指令，放在该指令之前，这样控制更精确
MESSAGE(STATUS "    Before set LIBRARY_OUTPUT_PATH: " ${LIBRARY_OUTPUT_PATH})
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
MESSAGE(STATUS "    After set LIBRARY_OUTPUT_PATH: " ${LIBRARY_OUTPUT_PATH})

# 指定生成可执行文件后的存放路径
# 该设置也可以跟随 ADD_EXECUTABLE 指令，放在该指令之前，这样控制更精确
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

###############################################
# compile options end
###############################################

###############################################
# 依赖关系
###############################################

# CMake 不会自动理解代码逻辑依赖，它只认识三类东西：
# 1. 目标（target）
#    add_library
#    add_executable
# 2. 目标之间的依赖
#    target_link_libraries
#    add_dependencies
# 3. 目标的输入文件
#    .cpp / .c / .h / generated files
# 只要某个源文件不属于某个 target：
# 无论怎么改，它都不会触发该 target 的重编译或重新链接
#
# CMake 的构建单位是「target」，不是文件
# CMake 的核心不是“文件列表”，而是 target graph（目标依赖图）。
# 每个 target 包含：
#   target
#    ├── sources (*.c/*.cpp)
#    ├── compile options
#    ├── include dirs
#    └── link dependencies (依赖的其他 target)
# 构建系统只关心：这个 target 的输入是否发生变化


# target_link_libraries：核心依赖机制
# 基本用法（依赖建模）
#   add_library(core ...)
#   add_library(utils ...)
#   add_library(mylib ...)
#
#   target_link_libraries(mylib
#       PRIVATE utils
#       PUBLIC  core
#   )
# | 关键字    | 含义                             |
# | --------- | -------------------------------- |
# | PRIVATE   | 只在 mylib 内部使用              |
# | PUBLIC    | mylib 使用，mylib 的使用者也使用 |
# | INTERFACE | mylib 不用，只传播给使用者       |
# 这套规则 同时适用于：
#   target_link_libraries
#   target_include_directories
#   target_compile_options
#   target_sources
#
# 什么时候需要 add_dependencies？
# 几乎不需要
# 只有在以下情况才用：
#   自定义命令生成文件
#   非 link 的构建顺序
#       add_custom_target(gen_code ...)
#       add_library(mylib a.cpp generated.cpp)
#       add_dependencies(mylib gen_code)
#   不要用 add_dependencies 代替 target_link_libraries


# 常见问题：第一次能进 ELF，后续修改不生效，看起来没有重新 link
# 这说明一件事：CMake/构建系统认为“没有任何会影响最终 ELF 的输入发生变化”
# 这通常意味着：
#   文件没在 target 里
#   target 的依赖关系断了
#   link 输入没有变化


# target_sources：向 target 注入源文件
# 给“已经存在的 target”动态追加源文件，并把这些文件正式纳入
#   target_sources(my_target PRIVATE a.c b.c)
#   等价于：
#   add_library(my_target a.c b.c)
#   但前者更灵活
#
# target_sources 的高级用法
# 条件源文件（推荐方式）
#   target_sources(hal_h265d_api
#       PRIVATE
#           $<$<BOOL:${HAVE_VDPU341}>:hal_h265d_rkv.c>
#           $<$<BOOL:${HAVE_VDPU34X}>:hal_h265d_vdpu34x.c>
#   )
#   优势（非常关键）
#       条件在 generate 阶段生效
#       不需要重新 cmake
#       修改宏定义 → 自动触发重建
# 分模块向同一个 target 注入源码
#   # module A
#   target_sources(core PRIVATE a1.c a2.c)
#   # module B
#   target_sources(core PRIVATE b1.c)
#   这是大型工程（LLVM、Qt、Linux toolchain）的常用模式


# OBJECT library：只编译、不链接
# OBJECT library 是：
# 一组“只负责编译、不参与链接”的 target
# 它的产物是：
#   .o / .obj
#   不是 .a
#   不是 .so
#   不会 自动进 ELF
# 这是设计如此，不是 bug
#
# 为什么 CMake 要设计 OBJECT library
# 传统模型的问题: .c → .o → libxxx.a → ELF
#   .a 是物理文件
#   一个 .a 只能被“整体使用”
#   同一份 .o 很难被多个目标共享
# OBJECT library 的目标: .c → .o   （到此为止）
#   然后：
#   .o → ELF_A
#   .o → ELF_B
#   一份 object，可以被多个 ELF 使用
#   不用生成中间的 .a
#   在 HAL / codec / driver 这种工程里非常有价值
#
# OBJECT library 在 CMake 里的真实形态
#   add_library(hal_h265d_api OBJECT a.c b.c)
# CMake 内部做了什么？
#   创建 target：hal_h265d_api
#   该 target 的 唯一职责：
#   把 a.c b.c 编译成 .o
#   没有链接步骤
#   到这里 ELF 完全不知道它的存在
#
# 那 ELF 是怎么“拿到”这些 .o 的
#   通过 target_sources
#       target_sources(app PRIVATE
#           $<TARGET_OBJECTS:hal_h265d_api>
#       )
#   这句的真实含义
#       “把 hal_h265d_api 这个 target 产生的 所有 .o 文件
#       当作源文件，加入到 app 的链接过程中”
#   注意：
#       不是 link
#       不是依赖
#       是 直接把 .o 丢给 linker
#
# 为什么不能用 target_link_libraries
# 如：target_link_libraries(app PRIVATE hal_h265d_api)
# 这是无效的，因为：
#   OBJECT library 没有 link interface
#   没有 .a / .so
#   linker 根本不知道怎么“link”它
#   CMake 甚至会直接报错或忽略
#
# OBJECT library + target_sources = 完整链路
#   正确的数据流是这样的：
#   add_library(hal_h265d_api OBJECT a.c b.c)
#               ↓
#           编译生成 .o
#               ↓
#   target_sources(app PRIVATE $<TARGET_OBJECTS:hal_h265d_api>)
#               ↓
#           linker 直接吃 .o
#               ↓
#             ELF


# target_link_libraries() 面对不同“target 类型 / 链接实体”时，
# CMake 内部到底做了什么不同的事？
#
# target_link_libraries(A B) 的真正含义是：
# A 依赖 B 的 link interface
# 关键点是 link interface，不是“文件”。
#
# 不同 target 类型，在 link interface 上的区别
# | 类型                   | 有 `.o` | 有 link step | 有 link interface | 能被 link |
# | ---------------------- | ------- | ------------ | ----------------- | --------- |
# | OBJECT library         | ✔       | ❌           | ❌                | ❌        |
# | STATIC library (`.a`)  | ✔       | ✔            | ✔                 | ✔         |
# | SHARED library (`.so`) | ✔       | ✔            | ✔                 | ✔         |
# | INTERFACE library      | ❌      | ❌           | ✔                 | ✔（逻辑） |
# 是否能作为 target_link_libraries 的 RHS，取决于：有没有 link interface
#
# OBJECT library：为什么不能 link？
#   add_library(objlib OBJECT a.c b.c)
#   target_link_libraries(app PRIVATE objlib)  # ❌
# CMake 内部视角
#   objlib 只有：.o
#   没有 .a / .so
#   linker 没有输入文件可以吃
# 所以：
#   target_link_libraries 对 OBJECT library 是无效的
#   正确方式只能是：
#       target_sources(app PRIVATE
#           $<TARGET_OBJECTS:objlib>
#       )
#
# STATIC library（.a）：最标准的 link 行为
#   add_library(mylib STATIC a.c)
#   target_link_libraries(app PRIVATE mylib)
# CMake 做了什么？
#   1. 编译 a.c → a.o
#   2. ar 打包 → libmylib.a
#   3. linker 阶段：app → libmylib.a
# 关键特性
#   按需提取 .o
#   没用到的符号不会进 ELF
#   link interface 里包含：
#       include dirs
#       link flags
#       依赖的其他库
#
# SHARED library（.so）：运行时参与
#   add_library(mylib SHARED a.c)
#   target_link_libraries(app PRIVATE mylib)
# 链接阶段
#   linker 不把 .o 拷进 ELF
#   只记录：
#       NEEDED libmylib.so
#       符号引用
# 运行时
#   动态加载 .so
#   支持升级、替换
# 但在 CMake 眼里：
#   .a 和 .so 在 target_link_libraries 里几乎一样
#
# INTERFACE library：没有文件，但能“被 link”
#   add_library(flags INTERFACE)
#   target_link_libraries(app PRIVATE flags)
# CMake 的处理
#   没有任何文件参与 link
#   只传播：
#       编译选项
#       include 路径
#       link flags
#       其他依赖
# 这是 CMake 最抽象但最强大的类型
#
# target_link_libraries 在不同情况下的真实行为总结
# | RHS 是            | 实际效果                     |
# | ----------------- | ---------------------------- |
# | OBJECT library    | ❌ 无效（无 link interface） |
# | STATIC library    | link `.a`                    |
# | SHARED library    | link `.so`                   |
# | INTERFACE library | 只传播属性                   |


###############################################
# 依赖关系 end
###############################################

###############################################
# work flow control
###############################################

# 在 CMake 中，进行条件判断的方法主要有以下几种：
# 1. 数字比较：
#     EQUAL：判断两个数字是否相等。
#     LESS：判断左边的数字是否小于右边的数字。
#     GREATER：判断左边的数字是否大于右边的数字。
#     LESS_EQUAL：判断左边的数字是否小于或等于右边的数字。
#     GREATER_EQUAL：判断左边的数字是否大于或等于右边的数字。
# 2. 字符串比较：
#     STREQUAL：判断两个字符串是否相等。
#     STRLESS：判断左边的字符串是否小于右边的字符串。
#     STRGREATER：判断左边的字符串是否大于右边的字符串。
#     STRLESS_EQUAL：判断左边的字符串是否小于或等于右边的字符串。
#     STRGREATER_EQUAL：判断左边的字符串是否大于或等于右边的字符串。
#     MATCHES：判断字符串是否匹配正则表达式。
# 3. 布尔值判断：
#     TRUE：判断条件是否为真。
#     FALSE：判断条件是否为假。
# 4. 文件系统判断：
#     EXISTS：判断文件或目录是否存在。
#     IS_DIRECTORY：判断给定路径是否是目录。
#     IS_SYMLINK：判断给定路径是否是符号链接。
#     IS_ABSOLUTE：判断路径是否是绝对路径。
# 5. 变量存在性判断：
#     DEFINED：判断变量是否已定义。
# 6. 复合条件：
#     AND：逻辑与操作。
#     OR：逻辑或操作。
#     NOT：逻辑非操作。
# 7. 版本号比较：
#     VERSION_LESS：判断版本号是否小于。
#     VERSION_GREATER：判断版本号是否大于。
#     VERSION_EQUAL：判断版本号是否等于。
#     VERSION_LESS_EQUAL：判断版本号是否小于或等于。
#     VERSION_GREATER_EQUAL：判断版本号是否大于或等于。
# 8. 变量内容判断：
#     IN_LIST：判断变量是否在列表中。

# 设置一个变量用于测试
SET(TEST_VARIABLE "Hello")

# if-else 条件语句示例
IF(TEST_VARIABLE STREQUAL "Hello")
    MESSAGE(STATUS "The variable is 'Hello'.")
ELSEIF(TEST_VARIABLE STREQUAL "Hi")
    MESSAGE(STATUS "The variable is 'Hi'.")
ELSE()
    MESSAGE(STATUS "The variable is not 'Hello' or 'Hi'.")
ENDIF()

# FOREACH中的条件书写规则：(variableName IN [LISTS | ITEMS] list)
# 其中：ist 是要遍历的列表。关键字 LISTS 指示 list 是一个列表变量，而 ITEMS 指示
#       list 是一个由空格或分号分隔的元素列表。如果省略 LISTS 或 ITEMS，CMake 会
#       根据list 的内容自动选择。
#
# FOREACH中也可以是哟给你RANGE创建的数字序列：variableName RANGE [start] stop [step]
# 其中：start 是范围的起始数字，stop 是范围的结束数字（包括在内），step 是可选的步长，
#       默认为 1。如果指定了 step，则 variableName 将按照指定的步长增加。
#       如果没有start，只有stop，这是数值遍历范围为0-stop

# foreach 循环示例
# SET(M_LIST 1 2 3 4 5)
# FOREACH(ITEM IN LISTS M_LIST)
FOREACH(ITEM RANGE 0 5)
    IF(ITEM EQUAL 3)
        MESSAGE(STATUS "Skipping item ${ITEM}.")
        CONTINUE() # 跳过当前迭代
    ENDIF()
    IF(ITEM GREATER 4)
        MESSAGE(STATUS "Breaking out of loop item ${ITEM}.")
        BREAK() # 提前退出循环
    ENDIF()
    MESSAGE(STATUS "Processing item ${ITEM}.")
ENDFOREACH()


# while 循环示例
SET(I 0)
WHILE(I LESS 5)
    MESSAGE(STATUS "I is ${I}")
    MATH(EXPR I "${I} + 1") # 增加 I 的值
ENDWHILE()


###############################################
# work flow control end
###############################################

###############################################
# 表达式
###############################################

# 参考博客：https://zhuanlan.zhihu.com/p/437404485
# 生成器表达式的格式形如$<...>，可以嵌套，可以用在很多构建目标的属性设置和特定的CMake命令中。
# 值得强调的是，生成表达式被展开是在生成构建系统的时候，所以不能通过解析配置CMakeLists.txt阶段的message命令打印
# 具体细节可以到博客中查看

###############################################
# 表达式 end
###############################################

###############################################
# custome compile options
###############################################

# configure_file(<input> <output> [COPYONLY] [ESCAPE_QUOTES] [@ONLY] [NEWLINE_STYLE [UNIX|DOS|WIN32|LF|CRLF] ])
# configure_file 主要实现如下两个功能:
#     1. 将 <input> 文件里面的内容全部复制到 <output> 文件中；
#     2. 根据参数规则，替换 @VAR@ 或 ${VAR} 变量；
# 参数解析
#     COPYONLY        仅拷贝 <input> 文件里面的内容到 <output> 文件， 不进行变量的替换；
#     ESCAPE_QUOTES   使用反斜杠（C语言风格）来进行转义；
#     @ONLY           限制替换， 仅仅替换 @VAR@ 变量， 不替换 ${VAR} 变量
#     NEWLINE_STYLE   指定输入文件的新行格式， 例如：Unix 中使用的是 \n, windows 中使用的 \r\n
# **注意: ** COPYONLY 和 NEWLINE_STYLE 是冲突的，不能同时使用；
#         CONFIGURE_FILE可以调用一次，也可以调用多次，多次调用的时候，如果变量有修改，会使用
#         最后调用 CONFIGURE_FILE 时的变量，也可以理解为，只有最后一次调用 CONFIGURE_FILE 是
#         有效的。
#
# 加入一个配置头文件，用于处理 CMake 对源码的设置
# configure_file 命令用于加入一个配置头文件 config.h ，这个文件由 CMake 从 config.h.in 生成，
#                通过这样的机制，将可以通过预定义一些参数和变量来控制代码的生成。
# configure.h.in 中的 #cmakedefin USE_MYMATH 可以对应到 CMakeLists.txt 中的宏
CONFIGURE_FILE (
    "${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
    )

# option(<option_variable> "help string describing option" [initial value])
# 提供一个选项供用户选择为ON或OFF。 如果未提供初始值，则使用OFF。该选则可以在调用CMAKE时使用形如
#     cmake -D USE_MYMATH=OFF ..
#     或 cmake -DUSE_MYMATH=OFF ..
# 的方式来设定，通过cmake指令设定的优先级要高于 option 的默认值
# 是否使用自己的 MathFunctions 库
# option 命令添加了一个 USE_MYMATH 选项，并且默认值为 ON 。
OPTION(USE_MYMATH "Use provided math implementation" ON)
MESSAGE(STATUS "    USE_MYMATH is: " ${USE_MYMATH})

# 是否加入 MathFunctions 库
if (USE_MYMATH)
    MESSAGE(STATUS "    USE_MYMATH is valid")
    # 这里关闭是因为在 config.h.in 中有定义，正常添加宏定义是需要打开的
    # ADD_DEFINITIONS(-DUSE_MYMATH)  
    INCLUDE_DIRECTORIES ("${PROJECT_SOURCE_DIR}/src/math")
    ADD_SUBDIRECTORY (src/math)
    SET (EXTRA_LIBS ${EXTRA_LIBS} mathFunctions)
endif (USE_MYMATH)

###############################################
# custome compile options end
###############################################

###############################################
# add git info
###############################################

# EXECUTE_PROCESS(
#     COMMAND <shell_command> # 替换为你的 shell 指令
#     WORKING_DIRECTORY <working_directory> # 可选，指定工作目录
#     TIMEOUT <timeout> # 可选，指定超时时间
#     RESULT_VARIABLE result # 可选，获取执行结果的状态码
#     OUTPUT_VARIABLE output # 可选，获取标准输出
#     ERROR_VARIABLE error # 可选，获取错误输出
#     OUTPUT_STRIP_TRAILING_WHITESPACE # 可选，去除标准输出的尾部空格
#     ERROR_STRIP_TRAILING_WHITESPACE # 可选，去除错误输出的尾部空格
# )

#-- ver 1 直接由CMake写文件
FIND_PACKAGE(Git)
# 生成版本描述字符串类似 TAG-X-gHASH
EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} describe --abbrev=6 --dirty --always --tags
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE  GIT_REPO_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# 获取最新提交作者
EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} log -1 --format=%an
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE  GIT_REPO_AUTHOR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
# 获取最新 commit 日期，YYYY-MM-DD
EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} log -1 --format=%cd --date=short
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE  GIT_REPO_DATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
# 获取最新 commit Hash
EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} log -1 --format=%H
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE  GIT_REPO_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
# 写入头文件宏定义的版本字符串，日期和 Hash
FILE(WRITE ${PROJECT_BINARY_DIR}/git_version.h
    "#define GIT_VER \"${GIT_REPO_VERSION}\"\n#define GIT_AUTHOR \"${GIT_REPO_AUTHOR}\"\n#define GIT_DATE \"${GIT_REPO_DATE}\"\n#define GIT_HASH \"${GIT_REPO_HASH}\"\n"
)
# 包含引用目录，源文件可以直接用 #include "git_version.h" 包含
INCLUDE_DIRECTORIES(${PROJECT_BINARY_DIR})


#-- ver 2 借助config

SET(GIT_LOG_FORMAT "%h author: %<|(30)%an %cd %s %d")

EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} log -1 --oneline --date=short --pretty=format:${GIT_LOG_FORMAT}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    OUTPUT_VARIABLE EXEC_OUT
    ERROR_VARIABLE EXEC_ERROR
    RESULT_VARIABLE EXEC_RET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_STRIP_TRAILING_WHITESPACE)

if (NOT EXEC_RET)
    SET(VERSION_LOG ${EXEC_OUT})
    STRING(REPLACE "\"" "\\\"" VERSION_LOG ${VERSION_LOG})
    MESSAGE(STATUS "git version: " ${VERSION_LOG})
    SET(VERSION_HISTORY "\"${VERSION_LOG}\"")
endif()

# 从新生成 config.h 以包含版本信息
CONFIGURE_FILE (
    "${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
    )



#-- ver 3 借助config 生成多条log
SET(VERSION_CNT         0)
SET(VERSION_MAX_CNT     9)
SET(VERSION_INFO        "\"unknown mpp version for missing VCS info\"")
FOREACH(CNT RANGE ${VERSION_MAX_CNT})
    SET(VERSION_HISTORY_${CNT} "NULL")
ENDFOREACH(CNT)

IF(EXISTS "${PROJECT_SOURCE_DIR}/../../.git")
    find_package(Git)
    IF(GIT_FOUND)
        # get current version info
        SET(GIT_LOG_FORMAT "%h author: %<|(30)%an %cd %s")

        EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} log -1 --oneline --date=short --pretty=format:${GIT_LOG_FORMAT}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            OUTPUT_VARIABLE EXEC_OUT
            ERROR_VARIABLE EXEC_ERROR
            RESULT_VARIABLE EXEC_RET
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_STRIP_TRAILING_WHITESPACE)

        IF(NOT EXEC_RET)
            SET(VERSION_INFO ${EXEC_OUT})
            MESSAGE(STATUS "current version:")
            MESSAGE(STATUS "${VERSION_INFO}")
            STRING(REPLACE "\"" "\\\"" VERSION_INFO ${VERSION_INFO})
            SET(VERSION_INFO "\"${VERSION_INFO}\"")
        ELSE(NOT EXEC_RET)
            MESSAGE(STATUS "git ret ${EXEC_RET}")
            MESSAGE(STATUS "${EXEC_ERROR}")
        ENDIF(NOT EXEC_RET)

        SET(GIT_LOG_FORMAT "%h author: %<|(30)%an %cd %s %d")

        # get history version information
        # setup logs
        MESSAGE(STATUS "git version history:")
        FOREACH(CNT RANGE ${VERSION_MAX_CNT})
            EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} log HEAD~${CNT} -1 --oneline --date=short --pretty=format:${GIT_LOG_FORMAT}
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                OUTPUT_VARIABLE EXEC_OUT
                ERROR_VARIABLE EXEC_ERROR
                RESULT_VARIABLE EXEC_RET
                OUTPUT_STRIP_TRAILING_WHITESPACE
                ERROR_STRIP_TRAILING_WHITESPACE)

            IF(NOT EXEC_RET)
                SET(VERSION_LOG ${EXEC_OUT})
                STRING(REPLACE "\"" "\\\"" VERSION_LOG ${VERSION_LOG})
                MESSAGE(STATUS ${VERSION_LOG})
                SET(VERSION_HISTORY_${CNT} "\"${VERSION_LOG}\"")
                math(EXPR VERSION_CNT "${VERSION_CNT}+1")
            ENDIF(NOT EXEC_RET)
        ENDFOREACH(CNT)
        MESSAGE(STATUS "total ${VERSION_CNT} git version recorded")
    ENDIF(GIT_FOUND)
ENDIF(EXISTS "${PROJECT_SOURCE_DIR}/../../.git")

CONFIGURE_FILE(
    "${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
    @ONLY
)
###############################################
# add git info end
###############################################

###############################################
# cmake 脚本
###############################################

# include 指令用法：
# include(<file|module> [OPTIONAL] [RESULT_VARIABLE <VAR>] [NO_POLICY_SCOPE])
# 可知 include 指令用来载入并运行来自于文件或模块的 CMake 代码。

# (1)  cmake文件里面通常包含的信息:
#     - '.cmake文件'里包含了一些"公共(复用)"的'cmake命令'和一些'宏|函数'
#     - 当CMakeLists.txt'包含该.cmake文件'时,当'编译'运行时,该.cmake里的一些命令就会
#       在该'包含处'得到加载'执行',在'后续'能够'调用该.cmake里'的一些宏和函数
#     - .cmake文件是一个'模块(module)文件',可以被'include'到CMakeLists.txt中
# 注意：cmake'脚本'不要包含'工程之类'的信息 -->例如:add_subdirectory()、CMAKE_CURRENT_之类的
#       cmake'不要'调用CMakeLists.txt
#
# (2) .cmake模块文件被加载的时机是在CMakeLists.txt 中
#     - include(module_name|file)
#     - find_package(module_name)
# 注意：这两种加载方式是有区别的,或者说find_package中'.cmake全文件名'有一定的要求。
#       另外如果加载的是文件(file)，则需要在命令中添加 .cmake 后缀，如果是模块，则不需要
#       .cmake 后缀，例如：
#           include(OpenCV)
#           include(my_file.cmake)

# 普通文件(file)
# 1）相对路径: 是相对include指令所在的CMakeLists.txt的路径
# 2）绝对路径(建议): 一般我们会将'cmake'文件放到cmake目录下,所以前缀一般是：
#    CMAKE_CURRENT_SOURCE_DIR/cmake/file
# 注意：这里的'file'文件,必须以'.cmake'结尾
#
# 模块文件(module)
# 1）首先搜索'Cmake builtin module directory' -->'cmake 内置的module目录'-->'centos7 /usr/share/cmake/MOdules/'
# 2）找不到'再搜索'-->'CMAKE_MODULE_PATH'
# 3）再找不到,则'报错'-->'NOTFOUND'
# 注意：include 命令中非'.cmake'结尾的文件表示是'module'-->会自动查找'内建-->CMAKE_MODULE_PATH'路径下的"module_name.cmake"文件
#       另外这里的搜索路径是 include 的搜索路径，可能与 find_packet 会有区分
#
# include(src/CMakeLists.txt) -->cmake也可以这样做,但是相对'add_subdirectory(src)',我们'不推荐'前者
# 原因： include破坏了'Build Tree'的机制-->不能将'Source Tree'在'build'下'映射'成'Build Tree'

# 同样需要加在 ADD_SUBDIRECTORY 之前才能传递到子目录
INCLUDE("src/main.cmake")

# 自定义函数
my_custom_function(MY_VARIABLE "Hello, CMake! This my custom function")
message(STATUS "MY_VARIABLE: ${MY_VARIABLE}")

###############################################
# cmake 脚本 end
###############################################

###############################################
# 其他
###############################################

# 指定生成目标
# ADD_EXECUTABLE(Demo ${DIR_SRCS})
# TARGET_LINK_LIBRARIES (Demo [PRIVATE|PUBLIC|INTERFACE] ${EXTRA_LIBS})
# PRIVATE / PUBLIC / INTERFACE 是“依赖的可见性（传递性）”，非常重要但也很容易混淆。
# 不写 PRIVATE/PUBLIC/INTERFACE 时，默认为 PUBLIC，建议不要省略
# 一句话总结：
#   它决定了：
#   这个库 自己要不要用
#   依赖它的目标要不要“继承”这个库
# PRIVATE
#   ex: target_link_libraries(A PRIVATE B)
#   含义：
#     A 自己在编译/链接时需要 B
#     依赖 A 的目标不需要也看不到 B
#   不向外传播
#   典型场景：
#     实现细节
#     内部使用的库
#     .cpp 里用到，但 .h 里没暴露
# PUBLIC
#   ex: target_link_libraries(A PUBLIC B)
#   含义：
#     A 自己需要 B
#     依赖 A 的目标也需要 B
#   向外传播
#   典型场景：
#     B 的类型、接口出现在 A 的头文件里
#     继承关系、参数类型、返回值
# INTERFACE
#   ex: target_link_libraries(A INTERFACE B)
#   含义：
#     A 自己 不使用 B
#     依赖 A 的目标需要 B
#   只传播，不自己用
#   典型场景：
#     Header-only 库
#     纯接口库
#     编译选项/宏集合
#
# 用表格理解（非常重要）
# | 关键字    | A 自己用 | 依赖 A 的目标用 |
# | --------- | -------- | --------------- |
# | PRIVATE   | ✅       | ❌              |
# | PUBLIC    | ✅       | ✅              |
# | INTERFACE | ❌       | ✅              |
# 举例：
#   find_package(Threads REQUIRED)
#
#   target_link_libraries(mpp_eventfd_test PRIVATE Threads::Threads)
#   target_link_libraries(mpp_thread_test  PRIVATE Threads::Threads)
#   target_link_libraries(mpp_runtime_test PRIVATE Threads::Threads)
#   # Threads::Threads 会自动在 ARM 交叉编译下选择正确的 -pthread


# 关于 Threads::Threads
# Threads::Threads 是 CMake 提供的一个 IMPORTED INTERFACE target
# 它不是一个真实的库文件，而是：
#   一组编译选项
#   一组链接选项
#   一组平台差异的抽象
#
# pthread 在不同平台根本不一样，这是 Threads::Threads 存在的根本原因。
#   Linux（glibc）
#     -pthread        # 不是 -lpthread
#   Linux（某些 toolchain）
#     -lpthread
#   musl
#     -pthread
#   macOS
#     # 什么都不用
#   Windows
#     Win32 threads
#   如果写死 -lpthread，跨平台必炸
# CMake 早期是怎么做的（老方式）
#   find_package(Threads)
#   target_link_libraries(foo ${CMAKE_THREAD_LIBS_INIT})
#   问题：
#     ${CMAKE_THREAD_LIBS_INIT} 是字符串
#     可能是：
#       -pthread
#       -lpthread
#       空
#     不会自动传播
#     不参与 target 依赖图
#     OBJECT / INTERFACE / PRIVATE / PUBLIC 全废
# Threads::Threads 是什么（本质）
#   当写： find_package(Threads REQUIRED)
#   CMake 在内部做了三件事：
#   ① 探测系统线程模型
#     能不能用 -pthread
#     要不要 -lpthread
#     是否需要额外 flags
#   ② 创建一个 imported target
#     Threads::Threads
#     它是：
#       IMPORTED
#       INTERFACE
#     没有源码
#     没有 .a / .so
#     只有“属性”
#   ③ 往 target 里塞属性
#     类似这样（概念化）：
#       set_target_properties(Threads::Threads PROPERTIES
#           INTERFACE_COMPILE_OPTIONS "-pthread"
#           INTERFACE_LINK_OPTIONS    "-pthread"
#       )
#     或在某些平台：
#       INTERFACE_LINK_LIBRARIES pthread
# 为什么用 target，而不是变量？
#   这是现代 CMake 的核心思想。
#   变量（旧世界）
#     set(CMAKE_C_FLAGS "-pthread")
#     全局污染
#     顺序敏感
#     无法传播
#     OBJECT library 无效
#     PRIVATE / PUBLIC 无效
#   target（新世界）
#     target_link_libraries(osal PUBLIC Threads::Threads)
#     意味着：
#       “任何链接 osal 的 target
#       都必须继承 pthread 的完整编译+链接语义”
#     ✔ 自动传播
#     ✔ 可组合
#     ✔ 可推导
#     ✔ 可裁剪

# 关于 CMAKE_THREAD_LIBS_INIT
# 它是 CMake 早期的线程支持机制（老写法）
# 当调用：find_package(Threads)
# CMake 会自动设置一些变量，其中最重要的是：
#   CMAKE_THREAD_LIBS_INIT
#   CMAKE_HAVE_THREADS_LIBRARY
#   CMAKE_USE_PTHREADS_INIT
# CMAKE_THREAD_LIBS_INIT 包含 链接 pthread 所需的选项：
#   可能是 -lpthread
#   或 -pthread
#   具体取决于平台和工具链
# 这个变量是 字符串，不是 target，所以它不能传播依赖。
#
# 基本用法（老写法）
#   find_package(Threads REQUIRED)
#   add_executable(myapp main.c)
#   # 链接 pthread
#   target_link_libraries(myapp ${CMAKE_THREAD_LIBS_INIT})
# 在 Linux 上，${CMAKE_THREAD_LIBS_INIT} 通常展开成 -pthread
# 在 Windows 上可能为空（因为 Windows API 自带线程）
#
# 和现代 CMake Threads::Threads 的区别
# | 特性                | CMAKE_THREAD_LIBS_INIT     | Threads::Threads                 |
# | ------------------- | -------------------------- | -------------------------------- |
# | 类型                | 字符串                     | IMPORTED INTERFACE target        |
# | 可传播性            | ❌ 需要手动传给每个 target | ✅ PUBLIC / INTERFACE 会自动传播 |
# | 平台适配            | ⚠️ 需要自己保证             | ✅ CMake 内部处理                |
# | OBJECT library 支持 | ❌ 无法自动                | ✅ 可以通过 INTERFACE 传播       |
# | 推荐程度            | 不推荐                     | ✅ 推荐（现代 CMake）            |
#
# 老写法的注意点
# 如果用 ${CMAKE_THREAD_LIBS_INIT}，每个 target 都要手动 link，否则可能出现链接错误：
#   target_link_libraries(utils ${CMAKE_THREAD_LIBS_INIT})
#   # 如果 utils 是 OBJECT library，这条 link 是无效的
# 对 OBJECT library 无效，因为它没有链接阶段
# 对 PRIVATE / PUBLIC 依赖 也不能传播


# SET(<VAR> -) 主调用CMakeLists.txt文件通过SET设置的变量可以传递到子目录的CMakeLists.txt中，
# 但反过来不行,无论在 ADD_SUBDIRECTORY 之前还是之后

# 主调CMakeLists.txt向子目录中的CMakeLists.txt中传递变量时需要将变量的设置放在
# ADD_SUBDIRECTORY 指令之前，否则传不下去
SET(MAINVAL "this is main CMakeLists VAL")

# 如果工程存在多个目录，需要确保每个要管理的目录存在一个CMakeLists.txt

# 无论CMakeLists.txt文件在根目录还是子目录中，也无论一个工程有一个还是多个CMakeList文件，
# 文件里的路径起点均为文件当前位置。

# 该指令可以指定中间二进制和目标二进制文件的存放位置，可以使用类似 ADD_SUBDIRECTORY(src bin) 的形式，
# 这项当于在编译的时候把 src 的名字改成bin。
ADD_SUBDIRECTORY(src)

###############################################
# 其他 end
###############################################

###############################################
# cmake 常用架构方式
###############################################
# 1. 类似当前demo，添加各个子文件夹，在子文件夹中各自编译
# 2. 子文件夹中只负责将相应文件收集到变量中，最终变量在顶层cmake中处理
# 3. 使用target_sources 命令，可以理解是子文件夹主动提交必要的目标文件，而不是顶层cmake向下查询
###############################################
# cmake 常用架构方式 end
###############################################

###############################################
# install and test
###############################################
# install用于指定在安装时运行的规则。它可以用来安装很多内容，可以包括目标二进制、
# 动态库、静态库以及文件、目录、脚本等：
#     install(TARGETS <target>... [...])          目标文件：通过ADD_EXECUTABLE或者ADD_LIBRARY定义的目标文件，
#                                                           即可执行二进制、动态库、静态库
#     install({FILES | PROGRAMS} <file>... [...]) 普通文件/脚本之类：用于安装一般文件
#     install(DIRECTORY <dir>... [...])           目录：安装目录
#     install(SCRIPT <file> [...])                cmake脚本
#     install(CODE <code> [...])
#     install(EXPORT <export-name> [...])

# 参数 DESTINATION 用于指定安装目录，该指定是以 CMAKE_INSTALL_PREFIX 变量指向的路径开始，
# 例如 DESTINATION bin 表示 ${CMAKE_INSTALL_PREFIX}/bin，但是如果 bin 以 / 开头就表示绝对路径，
# 变量 CMAKE_INSTALL_PREFIX 就不起作用了

# 变量 CMAKE_INSTALL_PREFIX 可以在编译的时候进行控制，例如: cmake -DCMAKE_INSTALL_PREFIX=. .. 
# 或 cmake -DCMAKE_INSTALL_PREFIX=$PWD ..
MESSAGE(STATUS "    CMAKE_INSTALL_PREFIX: " ${CMAKE_INSTALL_PREFIX})
# 指定 mathFunctions 库的安装路径
if (USE_MYMATH)
    INSTALL(TARGETS mathFunctions DESTINATION bin)
    INSTALL(FILES src/math/mathFunctions.h DESTINATION include)  # 安装文件时注意以当前 CMakeListas.txt 文件为路径的起点
endif (USE_MYMATH)
INSTALL(TARGETS demo DESTINATION bin)
INSTALL(FILES "${PROJECT_BINARY_DIR}/config.h" DESTINATION include)

###############################################
# install and test end
###############################################


###############################################
# 使用外部库
###############################################
# 原始方法
# 使用外部库最基础的写法是需要以下三个部分
#     1. INCLUDE_DIRECTORIES  对应 gcc/g++ 的 -I 参数，写在顶层主调 CMakeLists.txt 中就可以，
#        可以传递到子文件夹中，作用于全局
#        也可以使用 target_include_directories，功能类似 INCLUDE_DIRECTORIES，
#        作用于单个 target，可控性更高
#        target_include_directories(<target> <INTERFACE|PUBLIC|PRIVATE> <dirs...>)
#        <target>：目标名称（例如你的可执行文件或库名）
#        <dirs...>：头文件路径列表
#        <INTERFACE|PUBLIC|PRIVATE>：可选，控制访问权限
#        例如： target_include_directories(demo PRIVATE ${CMAKE_SOURCE_DIR}/include)
#     2. LINK_DIRECTORIES 对应 gcc/g++ 的 -L 参数,指定库文件的路径
#     3. TARGET_LINK_LIBRARIES 对应 gcc/g++ 的 -l 参数，为了方便使用可以在第2步之后
#        使用一个变量保存用到的库 (SET(......))

# 使用查找包的方式
# FIND_PACKAGE 用来调用预定义在 CMAKE_MODULE_PATH 下的 Find<name>.cmake模块
# FIND_PACKAGE 执行后会赋值的变量:
#     <name>_FOUND
#     <name>_INCLUDE_DIRS 或 <name>_INCLUDES
#     <name>_LIBRARIES 或 <name>_LIBS
#     <name>_DEFINITIONS


# find_packet()的用法:
# find_packet()有两种模式，Module模式和Config模式，其中Module模式是基础用法，Config模式较为复杂。
# Module模式下，如果按照用户指定的配置找不到包，主会自动进入Config模式
# 
# - Module模式:
# find_package(<PackageName> [version] [EXACT] [QUIET] [MODULE] [REQUIRED]
#              [[COMPONENTS] [components...]] [OPTIONAL_COMPONENTS components...]
#              [NO_POLICY_SCOPE])
# 其中：
#   version 如果指定就必须检查找到的包的版本是否与version兼容
#   EXACT 与version配合使用，如果指定version的同时又指定EXACT，必须检查找到的包的版本是否与version匹配
#   QUIET 如果查找失败，不会在屏幕上输出（如果指定了REQUIRED，则QUIET失效）
#   MODULE 只在Module模式下查找
#   REQUIRED 表示一定要找到包，如果失败则停止cmake
#   COMPONENTS components 表示一定要找到组件，如果失败则停止cmake
#   OPTIONAL_COMPONENTS components 表示找不到组件，也继续执行cmake
# 
# 查找顺序：Module 模式下查找名为 Find<PackageName>.cmake 的文件，
#     先在 CMAKE_MODULE_PATH 变量对应的路径下查找，如果路径为空或者查找失败，
#     则在 cmake 安装时的module目录下查找，如：/usr/lib/x86_64-linux-gnu/cmake
#
# - Config模式：
# find_package(<PackageName> [version] [EXACT] [QUIET] [REQUIRED] [[COMPONENTS] [components...]]
#              [CONFIG|NO_MODULE] [NO_POLICY_SCOPE] [NAMES name1 [name2 ...]]
#              [CONFIGS config1 [config2 ...]] [HINTS path1 [path2 ... ]] [PATHS path1 [path2 ... ]]
#              [PATH_SUFFIXES suffix1 [suffix2 ...]] [NO_DEFAULT_PATH] [NO_PACKAGE_ROOT_PATH]
#              [NO_CMAKE_PATH] [NO_CMAKE_ENVIRONMENT_PATH] [NO_SYSTEM_ENVIRONMENT_PATH]
#              [NO_CMAKE_PACKAGE_REGISTRY] [NO_CMAKE_BUILDS_PATH] # Deprecated; does nothing.
#              [NO_CMAKE_SYSTEM_PATH] [NO_CMAKE_SYSTEM_PACKAGE_REGISTRY]
#              [CMAKE_FIND_ROOT_PATH_BOTH | ONLY_CMAKE_FIND_ROOT_PATH | NO_CMAKE_FIND_ROOT_PATH])
# 查找顺序：Config模式下查找名为 <PackageName>.Config.cmake 或 <lower-case-package-name>-config.cmake 的文件
# 查找顺序如下：
#   1. <PackageName>_ROOT 的cmake变量或者环境变量
#      注意：如果指定了 <PackageName>_DIR cmake变量，那么 <PackageName>_ROOT 将不起作用
#   2. cmake特定的缓存变量
#      CMAKE_PREFIX_PATH
#      CMAKE_FRAMEWORK_PATH
#      CMAKE_APPBUNDLE_PATH
#      可以通过设定NO_CMAKE_PATH来关闭这一查找顺序
#   3. cmake待定的环境变量
#      <PackageName>_DIR
#      CMAKE_PREFIX_PATH
#      CMAKE_FRAMEWORK_PATH
#      CMAKE_APPBUNDLE_PATH
#      可以通过NO_CMAKE_ENVIRONMENT_PATH来跳过
#   4. HINT字段指定的路径
#   5. 系统环境变量PATH
#      其中如果是以/bin或者/sbin结尾的，会自动转化为其父目录
#      通过指定NO_SYSTEM_ENVIRONMENT_PATH来跳过
#   6. 存储在cmake的"User Package Registry"(用户包注册表)中的路径。
#      通过设定NO_CMAKE_PACKAGE_REGISTRY，或者：设定CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY为true来避开
#   7. 设定为当前系统定义的cmake变量：
#      CMAKE_SYSTEM_PREFIX_PATH
#      CMAKE_SYSTEM_FRAMEWORK_PATH
#      CMAKE_SYSTEM_APPBUNDLE_PATH
#      通过设定NO_CMAKE_SYSTEM_PATH来跳过
#   8. 在cmake的"System Package Registry"(系统包注册表）中查找。
#      通过设定NO_CMAKE_SYSTEM_PACKAGE_REGISTRY跳过。或者通过设定
#      CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY为true
#   9. 从PATHS字段指定的路径中查找


message(STATUS "    CMAKE_MODULE_PATH: " ${CMAKE_MODULE_PATH})
FIND_PACKAGE(OpenCV REQUIRED)
IF(NOT OpenCV_FOUND)
    MESSAGE(FATAL_ERROR "OpenCV Not Found!")
ENDIF(NOT OpenCV_FOUND)
message(STATUS "OpenCV library status:")
message(STATUS "    config: ${OpenCV_DIR}")
message(STATUS "    version: ${OpenCV_VERSION}")
message(STATUS "    libraries: ${OpenCV_LIBS}")
message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")

###############################################
# 使用外部库  end
###############################################

###############################################
# add test
###############################################
# CMake 提供了一个称为 CTest 的测试工具。
#
# 生成ctest测试：
# 在项目根目录的 CMakeLists 文件中调用一系列的 add_test 命令
#
# 运行ctest测试：
# ctest [-C <Release/Debug> -VV] 直接执行ctest或者添加相应参数
# 其中:
#     -C指定了配置类型（Debug/Release）
#     -VV选项提供了详细的输出，可以看到测试的执行情况

# 启用测试
ENABLE_TESTING()

# 测试程序是否成功运行
ADD_TEST(test_run ${PROJECT_BINARY_DIR}/bin/demo 5 2)

# 测试帮助信息是否可以正常提示
add_test (test_usage ${PROJECT_BINARY_DIR}/bin/demo)
set_tests_properties (test_usage
    PROPERTIES PASS_REGULAR_EXPRESSION "Usage: .* base exponent")

# 测试 5 的平方
add_test (test_5_2 ${PROJECT_BINARY_DIR}/bin/demo 5 2)

set_tests_properties (test_5_2
    PROPERTIES PASS_REGULAR_EXPRESSION "is 25")

# 测试 10 的 5 次方
add_test (test_10_5 ${PROJECT_BINARY_DIR}/bin/demo 10 5)

set_tests_properties (test_10_5
    PROPERTIES PASS_REGULAR_EXPRESSION "is 100000")

# 测试 2 的 10 次方
add_test (test_2_10 ${PROJECT_BINARY_DIR}/bin/demo 2 10)

set_tests_properties (test_2_10
    PROPERTIES PASS_REGULAR_EXPRESSION "is 1024")

# 上面的代码包含了四个测试。第一个测试 test_run 用来测试程序是否成功运行并返回 0 值。
# 剩下的三个测试分别用来测试 5 的 平方、10 的 5 次方、2 的 10 次方是否都能得到正确的结果。
# 其中 PASS_REGULAR_EXPRESSION 用来测试输出是否包含后面跟着的字符串。

# 如果要测试更多的输入数据，像上面那样一个个写测试用例未免太繁琐。这时可以通过编写宏来实现：
# 定义一个宏，用来简化测试工作
# macro (do_test arg1 arg2 result)
#     add_test (test_${arg1}_${arg2} ${PROJECT_BINARY_DIR}/bin/demo ${arg1} ${arg2})
#     set_tests_properties (test_${arg1}_${arg2}
#         PROPERTIES PASS_REGULAR_EXPRESSION ${result})
# endmacro (do_test)
 
# 使用该宏进行一系列的数据测试
# do_test (5 2 "is 25")
# do_test (10 5 "is 100000")
# do_test (2 10 "is 1024")
###############################################
# add test end
###############################################

###############################################
# CPack 包
###############################################
# 构建一个 CPack 安装包
# include(<file|module> [OPTIONAL] [RESULT_VARIABLE <var>] [NO_POLICY_SCOPE])
# Loads and runs CMake code from the file given. Variable reads and writes access the scope of the 
# caller (dynamic scoping). If OPTIONAL is present, then no error is raised if the file does not exist. 
# If RESULT_VARIABLE is given the variable <var> will be set to the full filename which has been 
# included or NOTFOUND if it failed.

# If a module is specified instead of a file, the file with name <modulename>.cmake is searched first in 
# CMAKE_MODULE_PATH, then in the CMake module directory. There is one exception to this: if the file which 
# calls include() is located itself in the CMake builtin module directory, then first the CMake builtin 
# module directory is searched and CMAKE_MODULE_PATH afterwards. See also policy CMP0017.

# See the cmake_policy() command documentation for discussion of the NO_POLICY_SCOPE option.

include (InstallRequiredSystemLibraries)
set (CPACK_RESOURCE_FILE_LICENSE
  "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set (CPACK_PACKAGE_VERSION_MAJOR "${Demo_VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR "${Demo_VERSION_MINOR}")
include (CPack)

# 上面的代码做了以下几个工作：
#     1. 导入 InstallRequiredSystemLibraries 模块，以便之后导入 CPack 模块；
#     2. 设置一些 CPack 相关变量，包括版权信息和版本信息，其中版本信息用了上一节定义的版本号；
#     3. 导入 CPack 模块。
# 接下来的工作是像往常一样构建工程，并执行 cpack 命令。
# 生成二进制安装包：
#     cpack -C CPackConfig.cmake
# 生成源码安装包
#     cpack -C CPackSourceConfig.cmake

###############################################
# CPack 包 end
###############################################

MESSAGE(STATUS "-------- MAIN CMAKELISTS MSG END --------")
