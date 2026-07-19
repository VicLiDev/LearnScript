/*************************************************************************
  > File Name: ../src/main.c
  > Author: LiHongjin
  > Mail: 872648180@qq.com 
  > Created Time: Sun 20 Sep 2020 04:45:44 PM CST
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include"config.h"
#include"git_version.h"
#include"version_info.h"

#ifndef USE_MYMATH
  #include<math.h>
#else
  #include "mathFunctions.h"
#endif

int main(int argc, char* argv[])
{
    double base;
    int exponent;

    /* method 1: 版本信息已由 src/version_info.c 持久化进 .rodata
       (仿 mpp/mpp_info.c: 宏落地为 static const 全局变量)。
       注意: 本文件不再直接引用 GIT_AUTHOR 等宏，但字符串仍一定存在于
       二进制中 —— 可用 `strings demo | grep VicLiDev` 验证。 */
    printf("git version method 1 (persisted in .rodata via version_info.c)\n");
    show_version();
    printf("(get_version() => %s)\n", get_version());
    printf("\n");
    /* method 2: config.h 的 VER_INFO (CMake ver2, configure_file) — 持久化 */
    printf("git version method 2 (persisted)\n");
    show_version_log();
    printf("\n");
    /* method 3: config.h 的 GIT_VER_HIST_0..9 (CMake ver3, configure_file @ONLY) — 持久化 */
    printf("git version method 3 (persisted)\n");
    show_version_history();
    printf("\n");

#ifdef MACRO_MAIN
    printf("have define macro: MACRO_MAIN in .cmake\n");
#else
    printf("not define macro: MACRO_MAIN in .cmake\n");
#endif

    if (argc < 3){
        // print version info
        printf("%s Version %d.%d\n", argv[0], Demo_VERSION_MAJOR, Demo_VERSION_MINOR);
        printf("Usage: %s base exponent \n", argv[0]);
        return 1;
    }
    base = atof(argv[1]);
    exponent = atoi(argv[2]);

#ifndef USE_MYMATH
    printf("Now we use the standard library. \n");
    double result = power(base, exponent);
#else
    printf("Now we use our own Math library. \n");
    double result = power(base, exponent);
#endif

    printf("%g ^ %d is %g\n", base, exponent, result);
    return 0;
}
