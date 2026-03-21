# CMakeLists.txt - NDK Android 交叉编译示例
# Author: LiHongjin
#
# 构建方式:
#   方式1: 通过 prjBuild.sh 脚本构建 (推荐)
#   方式2: 手动执行 cmake 命令
#
# 手动构建示例:
#   cmake -DCMAKE_TOOLCHAIN_FILE=$NDK_ROOT/build/cmake/android.toolchain.cmake \
#         -DANDROID_ABI=arm64-v8a \
#         -DANDROID_PLATFORM=android-21 \
#         -B build \
#         .
#   cmake --build build

cmake_minimum_required(VERSION 3.10)

# 项目信息
project(ndk_demo VERSION 1.0.0 LANGUAGES C CXX)

# 设置 C/C++ 标准
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Android 特定设置 (当使用 android.toolchain.cmake 时这些变量会自动设置)
# 以下变量可在命令行中指定:
#   - ANDROID_ABI: 目标 ABI (arm64-v8a, armeabi-v7a, x86, x86_64)
#   - ANDROID_PLATFORM: 目标 Android API 级别 (如 android-21)
#   - ANDROID_STL: STL 类型 (c++_static, c++_shared, system, none)

# 默认值 (可被命令行参数覆盖)
if(NOT ANDROID_ABI)
    set(ANDROID_ABI "arm64-v8a" CACHE STRING "Target ABI")
endif()
if(NOT ANDROID_PLATFORM)
    set(ANDROID_PLATFORM "android-21" CACHE STRING "Target platform")
endif()
if(NOT ANDROID_STL)
    set(ANDROID_STL "c++_static" CACHE STRING "STL type")
endif()

# 编译选项
if(ANDROID)
    # Android 平台特定编译选项
    add_compile_options(
        -Wall
        -Wextra
        -fPIC
    )

    # 输出 Android 构建信息
    message(STATUS "=== Android Build Configuration ===")
    message(STATUS "ANDROID_ABI: ${ANDROID_ABI}")
    message(STATUS "ANDROID_PLATFORM: ${ANDROID_PLATFORM}")
    message(STATUS "ANDROID_STL: ${ANDROID_STL}")
    message(STATUS "Android NDK: ${ANDROID_NDK}")
    message(STATUS "===================================")
endif()

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 可执行文件: C 版本
add_executable(demo_c main.c)

# 可执行文件: C++ 版本
add_executable(demo_cpp main.cpp)

# 如果需要链接额外库，可以在这里添加
# find_library(log-lib log)
# target_link_libraries(demo_cpp ${log-lib})

# 安装规则 (可选)
install(TARGETS demo_c demo_cpp
    RUNTIME DESTINATION bin
)
