/*************************************************************************
    > File Name: main.c
    > Author: LiHongjin
    > Mail: 872648180@qq.com
    > Created Time: Wed 07 Jan 2026 04:34:48 PM CST
 ************************************************************************/

#include <stdio.h>

int dump_info();
int calc1(int a, int b);
int calc2(int a, int b);

int main(int argc, char *argv[])
{
    dump_info();

    printf("======> result: %d %d\n", calc1(3, 4), calc2(30, 40));
    
    return 0;
}
