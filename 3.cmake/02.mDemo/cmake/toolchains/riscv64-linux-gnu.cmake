# ============================================================================
# RISC-V 64-bit 交叉编译工具链文件示例
# ============================================================================
# 使用方法：
#   cmake -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/riscv64-linux-gnu.cmake ..
# 或：
#   cmake -DCMAKE_TOOLCHAIN_NAME=riscv64-linux-gnu ..
#
# 注意：请根据实际工具链安装路径修改下面的配置
# ============================================================================

# 设置目标系统
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR riscv64)

# 设置编译器（请根据实际路径修改）
# 方式一：使用系统安装的交叉编译器（如 apt install gcc-riscv64-linux-gnu）
set(CMAKE_C_COMPILER riscv64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER riscv64-linux-gnu-g++)

# 方式二：使用自定义路径的工具链（取消注释并修改路径）
# set(TOOLCHAIN_ROOT "/opt/riscv-toolchain")
# set(CMAKE_C_COMPILER ${TOOLCHAIN_ROOT}/bin/riscv64-linux-gnu-gcc)
# set(CMAKE_CXX_COMPILER ${TOOLCHAIN_ROOT}/bin/riscv64-linux-gnu-g++)

# 设置 sysroot（如果有的话）
# set(CMAKE_SYSROOT ${TOOLCHAIN_ROOT}/riscv64-linux-gnu/libc)

# 设置查找路径
# set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_ROOT}/riscv64-linux-gnu)

# 查找模式设置
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
