#!/usr/bin/env bash
#########################################################################
# File Name: prjBuild.sh
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Tue 30 Jul 2024 11:14:19 AM CST
#########################################################################

DemoRoot=`pwd`

NDK="${HOME}/work/android/ndk/android-ndk-r10d"
TOOLCHAINS="toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin"

# Only choose one of these, depending on your device...
# export TARGET=aarch64-linux-android
export TARGET=armv7a-linux-androideabi
# export TARGET=i686-linux-android
# export TARGET=x86_64-linux-android


# Configure and build.

# 对于configure 工程，使用如下方法构建
cd ${DemoRoot}
export AR="${NDK}/${TOOLCHAINS}/arm-linux-androideabi-ar"
export LD="${NDK}/${TOOLCHAINS}/arm-linux-androideabi-ld"
export CC="${NDK}/${TOOLCHAINS}/arm-linux-androideabi-gcc"
export CXX="${NDK}/${TOOLCHAINS}/arm-linux-androideabi-g++"
export RANLIB="${NDK}/${TOOLCHAINS}/arm-linux-androideabi-ranlib"
export SYSROOT="${NDK}/platforms/android-19/arch-arm"

if [ ! -e jpegsrc.v9f.tar.gz ]; then wget https://www.ijg.org/files/jpegsrc.v9f.tar.gz; fi
if [ ! -e jpeg-9f ]; then tar -xvf jpegsrc.v9f.tar.gz; fi
cd jpeg-9f
if [ -e build ]; then rm -rf build; fi
mkdir build && cd build
# Android 5.0 之后只支持地址无关的可执行文件
# 可以export如下两个变量或者在configure和make时均加上相应的参数
# export CFLAGS="-fPIE -fPIC"
# export LDFLAGS="-pie"
CPPFLAGS="--sysroot=${NDKROOT}/${SYSROOT} -fPIE -fPIC" \
    CFLAGS="--sysroot=${NDKROOT}/${SYSROOT} -fPIE -fPIC" \
    LDFLAGS="-pie" \
    ../configure --host ${TARGET} \
    && CFLAGS="-fPIE -fPIC" LDFLAGS="-pie" make
# adb push rdjpgcom /data/
# 可以执行 ./rdjpgcom -h 测试运行情况


# 对于 Makefile 工程，使用如下方法构建
cd ${DemoRoot}
if [ ! -e bzip2 ]; then git clone git://sourceware.org/git/bzip2.git; fi
cd bzip2
make \
    CC=${NDK}/${TOOLCHAINS}/arm-linux-androideabi-gcc \
    AR=${NDK}/${TOOLCHAINS}/arm-linux-androideabi-ar \
    RANLIB=${NDK}/${TOOLCHAINS}/arm-linux-androideabi-ranlib \
    CPPFLAGS="--sysroot=${NDKROOT}/${SYSROOT} -fPIE -fPIC" \
    CFLAGS="--sysroot=${NDKROOT}/${SYSROOT} -fPIE -fPIC" \
    LDFLAGS="-pie" \
    bzip2
# adb push bzip2 /data/
# 可以执行 ./bzip2 -h 测试运行情况
