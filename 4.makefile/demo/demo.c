/*************************************************************************
    > File Name: demo.c
    > Author: LiHongjin
    > Mail: 872648180@qq.com 
    > Created Time: Fri May  5 18:20:53 2023
 ************************************************************************/

#include <stdio.h>
#include "mfunc.h"

#ifndef MCRO_DEMO2
#define MCRO_DEMO2 "no define"
#endif

int main()
{
    printf("hello world!\n");

    printf("==> demo: %s\n", __FILE__);
    mfunc();
    mfunc2();

#ifdef MCRO_DEMO
    printf("have define %s\n", "MCRO_DEMO");
#endif
    printf("MCRO_DEMO2 val:%s\n", MCRO_DEMO2);

    return 0;
}
