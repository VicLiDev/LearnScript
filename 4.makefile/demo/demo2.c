/*************************************************************************
    > File Name: demo2.c
    > Author: LiHongjin
    > Mail: 872648180@qq.com 
    > Created Time: Wed Dec  6 14:57:16 2023
 ************************************************************************/

#include <stdio.h>
#include "mfunc.h"

int main()
{
    printf("hello world!\n");

    printf("==> demo: %s\n", __FILE__);
    mfunc();
    mfunc2();

    return 0;
}
