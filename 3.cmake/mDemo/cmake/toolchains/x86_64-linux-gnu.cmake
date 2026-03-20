# ============================================================================
# x86_64 交叉编译/本机编译工具链文件
# ============================================================================
# 使用方法：
#   cmake -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/x86_64-linux-gnu.cmake ..
# 或：
#   cmake -DCMAKE_TOOLCHAIN_NAME=x86_64-linux-gnu ..
#
# 注意：本机x86_64编译时，通常直接使用default方式即可
#       此文件主要用于交叉编译场景（如在ARM主机上编译x86程序）
# ============================================================================

# 设置目标系统
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# 设置编译器（请根据实际路径修改）
# 方式一：使用系统安装的交叉编译器（如 apt install gcc-x86_64-linux-gnu）
set(CMAKE_C_COMPILER x86_64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER x86_64-linux-gnu-g++)

# 方式二：使用本机编译器（如果在x86_64主机上编译）
# set(CMAKE_C_COMPILER gcc)
# set(CMAKE_CXX_COMPILER g++)

# 方式三：使用自定义路径的工具链（取消注释并修改路径）
# set(TOOLCHAIN_ROOT "/opt/x86_64-toolchain")
# set(CMAKE_C_COMPILER ${TOOLCHAIN_ROOT}/bin/x86_64-linux-gnu-gcc)
# set(CMAKE_CXX_COMPILER ${TOOLCHAIN_ROOT}/bin/x86_64-linux-gnu-g++)

# 设置 sysroot（如果有的话）
# set(CMAKE_SYSROOT ${TOOLCHAIN_ROOT}/x86_64-linux-gnu/libc)

# 设置查找路径
# set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_ROOT}/x86_64-linux-gnu)

# 查找模式设置
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)   # 主机程序不交叉查找
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)    # 库只在 sysroot 中查找
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)    # 头文件只在 sysroot 中查找
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)    # 包只在 sysroot 中查找
