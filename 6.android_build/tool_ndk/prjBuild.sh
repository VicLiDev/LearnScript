#!/bin/bash
#########################################################################
# File Name: prjBuild.sh
# Author: LiHongjin
# Mail: 872648180@qq.com
# Created Time: Thu 30 May 2024 03:55:52 PM CST
#########################################################################
#
# NDK Android 交叉编译构建脚本
#
# 用法:
#   ./prjBuild.sh                    # 默认构建 arm64-v8a
#   ./prjBuild.sh armeabi-v7a        # 构建 armeabi-v7a
#   ./prjBuild.sh all                # 构建所有 ABI
#   ./prjBuild.sh clean              # 清理构建目录
#   ./prjBuild.sh help               # 显示帮助信息
#
# 环境变量:
#   NDK_ROOT: Android NDK 路径 (必须设置或修改下方默认值)
#
#########################################################################

set -e

# ============== 配置区域 ==============
# NDK 路径 (请根据实际情况修改)
NDK_ROOT=${NDK_ROOT:-/home/lhj/work/android/ndk/android-ndk-r25c}

# 支持的 ABI 列表
SUPPORTED_ABIS=("arm64-v8a" "armeabi-v7a" "x86_64" "x86")

# 默认 ABI
DEFAULT_ABI="arm64-v8a"

# Android API 级别
ANDROID_API="21"

# 构建类型
BUILD_TYPE="Release"

# 构建工具 (ninja 或 make)
BUILD_TOOL="ninja"
# =====================================

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# 显示帮助信息
show_help()
{
    echo "NDK Android Cross-Compile Build Script"
    echo ""
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  <abi>       Build specified ABI (arm64-v8a, armeabi-v7a, x86_64, x86)"
    echo "  all         Build all supported ABIs"
    echo "  clean       Clean build directories"
    echo "  help        Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  NDK_ROOT    Android NDK path (current: ${NDK_ROOT})"
    echo ""
    echo "Examples:"
    echo "  $0                    # Build arm64-v8a (default)"
    echo "  $0 armeabi-v7a        # Build armeabi-v7a"
    echo "  $0 all                # Build all ABIs"
    echo "  $0 clean              # Clean build directories"
    echo ""
    echo "Supported ABIs: ${SUPPORTED_ABIS[*]}"
}

# 检查 NDK 路径
check_ndk()
{
    if [ ! -d "${NDK_ROOT}" ]; then
        print_error "NDK path not found: ${NDK_ROOT}"
        print_info "Please set NDK_ROOT environment variable or modify NDK_ROOT in this script"
        exit 1
    fi

    TOOLCHAIN_FILE="${NDK_ROOT}/build/cmake/android.toolchain.cmake"
    if [ ! -f "${TOOLCHAIN_FILE}" ]; then
        print_error "Android toolchain file not found: ${TOOLCHAIN_FILE}"
        exit 1
    fi

    print_info "NDK path: ${NDK_ROOT}"
}

# 检查构建工具
check_build_tool()
{
    if [ "${BUILD_TOOL}" = "ninja" ]; then
        if ! command -v ninja &> /dev/null; then
            print_warning "ninja not found, switching to make"
            BUILD_TOOL="make"
        fi
    fi

    if [ "${BUILD_TOOL}" = "make" ]; then
        if ! command -v make &> /dev/null; then
            print_error "make command not found"
            exit 1
        fi
    fi

    print_info "Build tool: ${BUILD_TOOL}"
}

# 构建指定 ABI
build_abi()
{
    local ABI=$1
    local BUILD_DIR="build_${ABI}"

    print_info "Building ABI: ${ABI}"
    print_info "Build directory: ${BUILD_DIR}"

    # 创建构建目录
    mkdir -p "${BUILD_DIR}"

    # CMake 配置参数
    local CMAKE_ARGS=(
        -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}"
        -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"
        -DANDROID_ABI="${ABI}"
        -DANDROID_PLATFORM="android-${ANDROID_API}"
        -DANDROID_STL=c++_static
    )

    # 选择生成器
    if [ "${BUILD_TOOL}" = "ninja" ]; then
        CMAKE_ARGS+=(-G Ninja)
    fi

    # 执行 CMake 配置
    print_info "Running CMake configuration..."
    cmake "${CMAKE_ARGS[@]}" -B "${BUILD_DIR}" .

    # 执行构建
    print_info "Building..."
    if [ "${BUILD_TOOL}" = "ninja" ]; then
        cmake --build "${BUILD_DIR}"
    else
        cmake --build "${BUILD_DIR}" -- -j$(nproc)
    fi

    print_success "Build completed: ${ABI}"
    print_info "Output directory: ${BUILD_DIR}/bin/"
    echo ""
}

# 构建所有 ABI
build_all()
{
    for ABI in "${SUPPORTED_ABIS[@]}"; do
        build_abi "${ABI}"
    done
}

# 清理构建目录
clean()
{
    print_info "Cleaning build directories..."
    rm -rf build_*
    print_success "Clean completed"
}

# 验证 ABI
validate_abi()
{
    local ABI=$1
    for SUPPORTED in "${SUPPORTED_ABIS[@]}"; do
        [ "${ABI}" = "${SUPPORTED}" ] && return 0
    done
    return 1
}

# 主函数
main()
{
    local ACTION=${1:-${DEFAULT_ABI}}

    case "${ACTION}" in
        help|-h|--help)
            show_help
            exit 0
            ;;
        clean)
            clean
            exit 0
            ;;
        all)
            check_ndk
            check_build_tool
            build_all
            ;;
        *)
            if validate_abi "${ACTION}"; then
                check_ndk
                check_build_tool
                build_abi "${ACTION}"
            else
                print_error "Unsupported ABI: ${ACTION}"
                print_info "Supported ABIs: ${SUPPORTED_ABIS[*]}"
                echo ""
                show_help
                exit 1
            fi
            ;;
    esac

    print_success "All build tasks completed!"
}

# 执行主函数
main "$@"
