#!/usr/bin/env bash
#########################################################################
# File Name: prjBuild.sh
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Thu 22 Jan 2026 02:47:37 PM CST
#########################################################################

# ============================================================================
# 使用方法：./prjBuild.sh [method] [toolchain]
#
# method:
#   1 或 method1  - 方法一：命令行指定工具链文件
#   2 或 method2  - 方法二：CMakeLists.txt 中设置（需要手动修改）
#   3 或 method3  - 方法三：BUILD_TOOLCHAINS_PATH + CMAKE_TOOLCHAIN_NAME
#   4 或 method4  - 方法四：直接指定编译器
#   default       - 默认构建（本机编译）
#
# toolchain (仅 method1/3/4 需要):
#   arm           - ARM 32-bit (arm-linux-gnueabihf)
#   aarch64       - ARM 64-bit (aarch64-linux-gnu)
#   riscv64       - RISC-V 64-bit (riscv64-linux-gnu)
#   x86_64        - x86_64 (x86_64-linux-gnu)
#
# 示例：
#   ./prjBuild.sh                    # 默认本机构建
#   ./prjBuild.sh 1 arm              # 方法一 + ARM 工具链
#   ./prjBuild.sh method3 aarch64    # 方法三 + ARM64 工具链
#   ./prjBuild.sh 4 riscv64          # 方法四 + RISC-V 工具链
#   ./prjBuild.sh 1 x86_64           # 方法一 + x86_64 工具链
# ============================================================================

root_dir=$(pwd)
toolchains_dir=${root_dir}/cmake/toolchains
bd_dir="build"
cmd_method=${1:-"default"}
cmd_toolchain=${2:-"arm"}

# 清理并创建构建目录
[ -d ${bd_dir} ] && rm -rf ${bd_dir}
mkdir -p ${bd_dir} && cd ${bd_dir}

echo "============================================"
echo "Build Method: ${cmd_method}"
echo "============================================"

case ${cmd_method} in
    1|method1)
        # ====================================================================
        # 方法一：命令行指定工具链文件（推荐 ★★★★★）
        # ====================================================================
        # 直接指定工具链文件的完整路径
        # 优点：不需要修改 CMakeLists.txt，切换方便
        case ${cmd_toolchain} in
            arm)
                TOOLCHAIN_FILE="${toolchains_dir}/arm-linux-gnueabihf.cmake"
                ;;
            aarch64)
                TOOLCHAIN_FILE="${toolchains_dir}/aarch64-linux-gnu.cmake"
                ;;
            riscv64|x86_64|*)
                TOOLCHAIN_FILE="${toolchains_dir}/x86_64-linux-gnu.cmake"
                ;;
        esac
        echo "Toolchain file: ${TOOLCHAIN_FILE}"
        cmake -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE} ..
        ;;

    2|method2)
        # ====================================================================
        # 方法二：CMakeLists.txt 中设置（需要在 project() 之前）
        # ====================================================================
        # 这种方式需要在 CMakeLists.txt 中添加：
        #   set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/cmake/toolchains/xxx.cmake")
        # 然后再执行 project() 命令
        # 注意：每次切换工具链都需要修改 CMakeLists.txt，不够灵活
        echo "Method 2: Please modify CMakeLists.txt to set CMAKE_TOOLCHAIN_FILE"
        echo "Example: set(CMAKE_TOOLCHAIN_FILE \"\${CMAKE_SOURCE_DIR}/cmake/toolchains/arm-linux-gnueabihf.cmake\")"
        echo "Then run: cmake .."
        cmake ..
        ;;

    3|method3)
        # ====================================================================
        # 方法三：BUILD_TOOLCHAINS_PATH + CMAKE_TOOLCHAIN_NAME（推荐 ★★★★）
        # ====================================================================
        # 使用工具链路径 + 工具链名称的组合
        # 优点：集中管理，只需指定名称
        case ${cmd_toolchain} in
            arm)
                TOOLCHAIN_NAME="arm-linux-gnueabihf"
                ;;
            aarch64)
                TOOLCHAIN_NAME="aarch64-linux-gnu"
                ;;
            riscv64|x86_64|*)
                TOOLCHAIN_NAME="x86_64-linux-gnu"
                ;;
        esac
        echo "Toolchain name: ${TOOLCHAIN_NAME}"
        cmake -DCMAKE_TOOLCHAIN_NAME=${TOOLCHAIN_NAME} ..
        # 可以把工具链路径直接写在文件中，也可以指定自定义工具链路径：
        # 由于 compile.cmake 中已经指定了，所以这里不在命令行指定了
        # cmake -DBUILD_TOOLCHAINS_PATH=/custom/path/toolchains \
        #       -DCMAKE_TOOLCHAIN_NAME=${TOOLCHAIN_NAME} ..
        ;;

    4|method4)
        # ====================================================================
        # 方法四：直接指定编译器（简单场景 ★★★）
        # ====================================================================
        # 直接在命令行指定编译器
        # 缺点：不会设置 sysroot、查找路径等
        case ${cmd_toolchain} in
            arm)
                CC="arm-linux-gnueabihf-gcc"
                CXX="arm-linux-gnueabihf-g++"
                ;;
            aarch64)
                CC="aarch64-linux-gnu-gcc"
                CXX="aarch64-linux-gnu-g++"
                ;;
            riscv64)
                CC="riscv64-linux-gnu-gcc"
                CXX="riscv64-linux-gnu-g++"
                ;;
            x86_64|*)
                CC="x86_64-linux-gnu-gcc"
                CXX="x86_64-linux-gnu-g++"
                ;;
        esac
        echo "C Compiler: ${CC}"
        echo "C++ Compiler: ${CXX}"
        cmake -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} ..
        ;;

    default|*)
        # ====================================================================
        # 默认构建（本机编译）
        # ====================================================================
        echo "Building for native platform..."
        cmake ..
        ;;
esac

# 编译
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

echo "============================================"
echo "Build completed!"
echo "============================================"
