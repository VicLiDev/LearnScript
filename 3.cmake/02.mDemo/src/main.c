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

#ifndef USE_MYMATH
  #include<math.h>
#else
  #include "mathFunctions.h"
#endif

#define DUMP_GIT_VER \
    do { \
        printf("%s\n", GIT_VER_HIST_0); \
        printf("%s\n", GIT_VER_HIST_1); \
        printf("%s\n", GIT_VER_HIST_2); \
        printf("%s\n", GIT_VER_HIST_3); \
        printf("%s\n", GIT_VER_HIST_4); \
        printf("%s\n", GIT_VER_HIST_5); \
        printf("%s\n", GIT_VER_HIST_6); \
        printf("%s\n", GIT_VER_HIST_7); \
        printf("%s\n", GIT_VER_HIST_8); \
        printf("%s\n", GIT_VER_HIST_9); \
    } while (0);

int main(int argc, char* argv[])
{
    double base;
    int exponent;

    printf("git version method 1\n");
    printf("version: %s\n", GIT_VERSION);
    printf("author:  %s\n", GIT_AUTHOR);
    printf("date:    %s\n", GIT_DATE);
    printf("hash:    %s\n", GIT_HASH);
    printf("\n");
    printf("git version method 2\n");
    printf("ver_log: %s\n", VER_INFO);
    printf("\n");
    printf("git version method 3\n");
    DUMP_GIT_VER;
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
