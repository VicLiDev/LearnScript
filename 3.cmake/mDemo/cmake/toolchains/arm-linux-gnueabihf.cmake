# ============================================================================
# ARM 32-bit 交叉编译工具链文件示例
# ============================================================================
# 使用方法：
#   cmake -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/arm-linux-gnueabihf.cmake ..
# 或：
#   cmake -DCMAKE_TOOLCHAIN_NAME=arm-linux-gnueabihf ..
#
# 注意：请根据实际工具链安装路径修改下面的配置
# ============================================================================

# 设置目标系统
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# 设置编译器（请根据实际路径修改）
# 方式一：使用系统安装的交叉编译器（如 apt install gcc-arm-linux-gnueabihf）
set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

# 方式二：使用自定义路径的工具链（取消注释并修改路径）
# set(TOOLCHAIN_ROOT "/opt/arm-toolchain")
# set(CMAKE_C_COMPILER ${TOOLCHAIN_ROOT}/bin/arm-linux-gnueabihf-gcc)
# set(CMAKE_CXX_COMPILER ${TOOLCHAIN_ROOT}/bin/arm-linux-gnueabihf-g++)

# 设置 sysroot（如果有的话）
# set(CMAKE_SYSROOT ${TOOLCHAIN_ROOT}/arm-linux-gnueabihf/libc)

# 设置查找路径
# set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_ROOT}/arm-linux-gnueabihf)

# 查找模式设置
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)   # 主机程序不交叉查找
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)    # 库只在 sysroot 中查找
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)    # 头文件只在 sysroot 中查找
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)    # 包只在 sysroot 中查找
