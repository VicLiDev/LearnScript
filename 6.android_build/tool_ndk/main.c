/*************************************************************************
    > File Name: main.c
    > Author: LiHongjin
    > Mail: 872648180@qq.com
    > Created Time: Thu 30 May 2024 03:52:24 PM CST
    > Description: NDK 交叉编译 C 语言示例
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 获取编译时信息
static void print_build_info(void)
{
    printf("=== Build Information ===\n");
#ifdef __ANDROID__
    printf("Platform: Android\n");
#else
    printf("Platform: Native\n");
#endif

#ifdef __aarch64__
    printf("Architecture: ARM64 (aarch64)\n");
#elif defined(__arm__)
    printf("Architecture: ARM (32-bit)\n");
#elif defined(__x86_64__)
    printf("Architecture: x86_64\n");
#elif defined(__i386__)
    printf("Architecture: x86 (32-bit)\n");
#else
    printf("Architecture: Unknown\n");
#endif

#ifdef __clang__
    printf("Compiler: Clang %d.%d.%d\n",
           __clang_major__, __clang_minor__, __clang_patchlevel__);
#elif defined(__GNUC__)
    printf("Compiler: GCC %d.%d.%d\n",
           __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
#endif
    printf("=========================\n\n");
}

// 示例函数: 计算阶乘
static long factorial(int n)
{
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

// 示例函数: 斐波那契数列
static long fibonacci(int n)
{
    if (n <= 0) return 0;
    if (n == 1) return 1;

    long a = 0, b = 1, c;
    for (int i = 2; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    return b;
}

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    printf("Hello from NDK Demo (C version)!\n\n");

    // 打印构建信息
    print_build_info();

    // 示例计算
    printf("=== Calculation Examples ===\n");
    printf("Factorial(10) = %ld\n", factorial(10));
    printf("Fibonacci(20) = %ld\n", fibonacci(20));
    printf("============================\n");

    return 0;
}
