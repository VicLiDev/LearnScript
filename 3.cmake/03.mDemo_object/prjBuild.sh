#!/usr/bin/env bash
#########################################################################
# File Name: .prjBuild.sh
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Wed 07 Jan 2026 05:32:28 PM CST
#########################################################################

[ ! -e build ] && mkdir build
cd build

# rm -rf ./*
cmake .. && make -j && ./app
