#!/usr/bin/env bash
#########################################################################
# File Name: prjBuild.sh
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Thu 22 Jan 2026 02:47:37 PM CST
#########################################################################

bd_dir="build"
[ -e ${bd_dir}] && rm ${bd_dir}
cd ${bd_dir} && cmake .. && make -j
