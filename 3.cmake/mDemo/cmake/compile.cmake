MESSAGE(STATUS "-------- COMPILE OPTIONS BEG --------")

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
# CMAKE_CXX_FLAGS_DEBUG：
# 编译Debug版本的时候会采用的编译选项，默认只有一个-g选项，包含调试信息；
# CMAKE_CXX_FLAGS_RELEASE：
# 编译Release版本的时候采用的编译选项，默认包-O3选项，该选项表示优化等级；
# CMAKE_CXX_FLAGS_MINSIZEREL：
# 主要减小目标文件大小，选项-Os就是这个作用；
# CMAKE_CXX_FLAGS_RELWITHDEBINFO：
# 包含调试信息的Release版本，-O2和-g，优化的同时也包含了调试信息；
# CMAKE_CXX_FLAGS：
# 这个选项没有默认值；
#
# 公共的选项，不管是Release还是Debug都需要设置。这种情况还可以把公共的设置
# 放在CMAKE_CXX_FLAGS变量里面

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
# ============================================================================
# 指定工具链的四种方法
# ============================================================================
#
# +----------+-------------------------------------------+--------+----------+
# | 方法     | 命令示例                                  | 类型   | 需要代码 |
# +----------+-------------------------------------------+--------+----------+
# | 方法一   | cmake -DCMAKE_TOOLCHAIN_FILE=xxx.cmake .. | 原生   | 不需要   |
# | 方法二   | 在 CMakeLists.txt 中 set(...)             | 原生   | 不需要   |
# | 方法三   | cmake -DCMAKE_TOOLCHAIN_NAME=arm ..       | 自定义 | 需要     |
# | 方法四   | cmake -DCMAKE_C_COMPILER=arm-gcc ..       | 原生   | 不需要   |
# +----------+-------------------------------------------+--------+----------+
#
# 方法一：命令行指定工具链文件（推荐 ★★★★★）【原生】
# -------------------------------------------------
# cmake -DCMAKE_TOOLCHAIN_FILE=/path/to/toolchain.cmake ..
#
# 说明：
#   - CMake 内置功能，命令行传入后自动在 project() 前加载工具链文件
#   - 无需在 CMake 中编写任何代码
# 优点：
#   - 不需要修改 CMakeLists.txt
#   - 切换工具链方便
#   - CI/CD 中易于配置
# 示例：
#   cmake -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/arm-linux-gnueabihf.cmake ..
#
#
# 方法二：CMakeLists.txt 中设置（必须在 project() 之前）【原生】
# -------------------------------------------------------------
# set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/cmake/toolchains/arm-linux-gnueabihf.cmake")
# project(MyProject C)
#
# 说明：
#   - 同样使用 CMake 内置的 CMAKE_TOOLCHAIN_FILE 变量
#   - 只是在 CMakeLists.txt 中设置而非命令行
# 缺点：
#   - 不够灵活，每次切换工具链都需要修改 CMakeLists.txt
#
#
# 方法三：BUILD_TOOLCHAINS_PATH + CMAKE_TOOLCHAIN_NAME 组合（推荐 ★★★★）【自定义】
# -------------------------------------------------------------------------------
# cmake -DBUILD_TOOLCHAINS_PATH=/path/to/toolchains \
#       -DCMAKE_TOOLCHAIN_NAME=arm-linux-gnueabihf ..
#
# 说明：
#   - 自定义封装，需要 CMake 代码将工具链名称转换为完整路径
#   - 代码逻辑：CMAKE_TOOLCHAIN_FILE = ${BUILD_TOOLCHAINS_PATH}/${CMAKE_TOOLCHAIN_NAME}.cmake
# 优点：
#   - 集中管理所有工具链文件
#   - 只需指定工具链名称，无需完整路径
#   - 可移植性好
#
# 目录结构：
#   project/
#   ├── cmake/
#   │   └── toolchains/                        # BUILD_TOOLCHAINS_PATH 指向这里
#   │       ├── arm-linux-gnueabihf.cmake      # ARM 32-bit
#   │       ├── aarch64-linux-gnu.cmake        # ARM 64-bit
#   │       ├── riscv64-linux-gnu.cmake        # RISC-V
#   │       └── mingw-w64-x86_64.cmake         # Windows 交叉编译
#   └── CMakeLists.txt
#
#
# 方法四：直接指定编译器（简单场景 ★★★）【原生】
# ---------------------------------------------
# cmake -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \
#       -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++ ..
#
# 或在 CMakeLists.txt 中：
#   set(CMAKE_C_COMPILER "/usr/bin/arm-linux-gnueabihf-gcc")
#   set(CMAKE_CXX_COMPILER "/usr/bin/arm-linux-gnueabihf-g++")
#
# 说明：
#   - CMake 内置变量，直接指定编译器路径
#   - 不通过工具链文件，而是直接设置编译器
# 缺点：
#   - 不会设置 sysroot、查找路径等
#   - find_package() 可能找不到正确的库
#   - 仅适用于简单场景
#
# ============================================================================
# CMAKE_TOOLCHAIN_FILE 变量说明
# ============================================================================
# CMAKE_TOOLCHAIN_FILE 是一个 CMake 变量，用于指定一个包含交叉编译环境配置的 .cmake
# 脚本文件。该文件可以包含交叉编译环境中的各种库和头文件路径、编译器和链接器的路径
# 等信息，使得 CMake 能够在交叉编译环境中正确地配置和构建工程。
#
# 工具链文件（.cmake 脚本）通常包含以下内容：
# 1. 编译器设置：指定 C/C++ 编译器路径
#    set(CMAKE_C_COMPILER "<path_to_c_compiler>")
#    set(CMAKE_CXX_COMPILER "<path_to_cxx_compiler>")
#
# 2. 库和头文件路径：设置库文件和头文件的搜索路径
#    使用 CMAKE_PREFIX_PATH、CMAKE_FIND_ROOT_PATH 等变量来指定
#
# 3. 系统名称和处理器架构：设置目标系统的名称和处理器架构
#    set(CMAKE_SYSTEM_NAME Linux)
#    set(CMAKE_SYSTEM_PROCESSOR arm)
#
# ============================================================================
# BUILD_TOOLCHAINS_PATH 配置（方法三的实现）
# ============================================================================
# 设置工具链文件存放路径，支持命令行覆盖
if(NOT DEFINED BUILD_TOOLCHAINS_PATH)
    set(BUILD_TOOLCHAINS_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchains")
endif()
message(STATUS "    BUILD_TOOLCHAINS_PATH: ${BUILD_TOOLCHAINS_PATH}")

# 根据工具链名称自动构建完整路径
if(DEFINED CMAKE_TOOLCHAIN_NAME AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "${BUILD_TOOLCHAINS_PATH}/${CMAKE_TOOLCHAIN_NAME}.cmake")
    if(NOT EXISTS "${CMAKE_TOOLCHAIN_FILE}")
        message(WARNING "Toolchain file not found: ${CMAKE_TOOLCHAIN_FILE}")
        # 列出可用的工具链
        file(GLOB _available_toolchains "${BUILD_TOOLCHAINS_PATH}/*.cmake")
        if(_available_toolchains)
            message(STATUS "Available toolchains:")
            foreach(_tc ${_available_toolchains})
                get_filename_component(_tc_name ${_tc} NAME_WE)
                message(STATUS "  - ${_tc_name}")
            endforeach()
        else()
            message(STATUS "No toolchain files found in ${BUILD_TOOLCHAINS_PATH}")
        endif()
    else()
        message(STATUS "Using toolchain: ${CMAKE_TOOLCHAIN_FILE}")
    endif()
endif()

# 如果设置了工具链文件，显示当前使用的工具链信息
if(DEFINED CMAKE_TOOLCHAIN_FILE AND EXISTS "${CMAKE_TOOLCHAIN_FILE}")
    message(STATUS "CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")
endif()
#
# ============================================================================
# 工具链文件示例内容
# ============================================================================
# # arm-linux-gnueabihf.cmake 示例
# # 设置目标系统
# set(CMAKE_SYSTEM_NAME Linux)
# set(CMAKE_SYSTEM_PROCESSOR arm)
#
# # 设置编译器
# set(CMAKE_C_COMPILER /opt/arm-toolchain/bin/arm-linux-gnueabihf-gcc)
# set(CMAKE_CXX_COMPILER /opt/arm-toolchain/bin/arm-linux-gnueabihf-g++)
#
# # 设置 sysroot 和查找路径
# set(CMAKE_FIND_ROOT_PATH /opt/arm-toolchain/arm-linux-gnueabihf)
# set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)   # 主机程序不交叉查找
# set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)    # 库只在 sysroot 中查找
# set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)    # 头文件只在 sysroot 中查找
# set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)    # 包只在 sysroot 中查找

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


MESSAGE(STATUS "-------- COMPILE OPTIONS END --------")
