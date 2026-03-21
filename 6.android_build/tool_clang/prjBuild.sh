#!/usr/bin/env bash
#########################################################################
# File Name: prjBuild.sh
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Tue 30 Jul 2024 11:14:19 AM CST
#########################################################################

# reference: https://developer.android.com/ndk/guides/other_build_systems?hl=zh-cn

DemoRoot=`pwd`

NDK="${HOME}/work/android/ndk/android-ndk-r25c"
TOOLCHAINS="${NDK}/toolchains/llvm/prebuilt/linux-x86_64"

# Only choose one of these, depending on your device...
# export TARGET=aarch64-linux-android
export TARGET=armv7a-linux-androideabi
# export TARGET=i686-linux-android
# export TARGET=x86_64-linux-android

# Set this to your minSdkVersion.
export API=21


# Configure and build.

# 对于configure 工程，使用如下方法构建
cd ${DemoRoot}
export AR=${TOOLCHAINS}/bin/llvm-ar
export CC=${TOOLCHAINS}/bin/${TARGET}${API}-clang
export AS=${CC}
export CXX=${TOOLCHAINS}/bin/${TARGET}${API}-clang++
export LD=${TOOLCHAINS}/bin/ld
export RANLIB=${TOOLCHAINS}/bin/llvm-ranlib
export STRIP=${TOOLCHAINS}/bin/llvm-strip

if [ ! -e jpegsrc.v9f.tar.gz ]; then wget https://www.ijg.org/files/jpegsrc.v9f.tar.gz; fi
if [ ! -e jpeg-9f ]; then tar -xvf jpegsrc.v9f.tar.gz; fi
cd jpeg-9f
if [ -e build ]; then rm -rf build; fi
mkdir build && cd build
../configure --host ${TARGET} && make
# adb push rdjpgcom /data/
# 可以执行 ./rdjpgcom -h 测试运行情况


# 对于 Makefile 工程，使用如下方法构建
cd ${DemoRoot}
if [ ! -e bzip2 ]; then git clone git://sourceware.org/git/bzip2.git; fi
cd bzip2
make \
    CC=${TOOLCHAINS}/bin/${TARGET}${API}-clang \
    AR=${TOOLCHAINS}/bin/llvm-ar \
    RANLIB=${TOOLCHAINS}/bin/llvm-ranlib \
    bzip2
# adb push bzip2 /data/
# 可以执行 ./bzip2 -h 测试运行情况
