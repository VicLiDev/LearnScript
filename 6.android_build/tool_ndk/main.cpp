/*************************************************************************
    > File Name: main.cpp
    > Author: LiHongjin
    > Mail: 872648180@qq.com
    > Created Time: Thu 30 May 2024 04:38:11 PM CST
    > Description: NDK 交叉编译 C++ 语言示例
 ************************************************************************/

#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>
#include <string>

// 获取编译时信息
void printBuildInfo()
{
    std::cout << "=== Build Information ===" << std::endl;
#if defined(__ANDROID__)
    std::cout << "Platform: Android" << std::endl;
#else
    std::cout << "Platform: Native" << std::endl;
#endif

#if defined(__aarch64__)
    std::cout << "Architecture: ARM64 (aarch64)" << std::endl;
#elif defined(__arm__)
    std::cout << "Architecture: ARM (32-bit)" << std::endl;
#elif defined(__x86_64__)
    std::cout << "Architecture: x86_64" << std::endl;
#elif defined(__i386__)
    std::cout << "Architecture: x86 (32-bit)" << std::endl;
#else
    std::cout << "Architecture: Unknown" << std::endl;
#endif

#if defined(__clang__)
    std::cout << "Compiler: Clang " << __clang_major__ << "."
              << __clang_minor__ << "." << __clang_patchlevel__ << std::endl;
#elif defined(__GNUC__)
    std::cout << "Compiler: GCC " << __GNUC__ << "."
              << __GNUC_MINOR__ << "." << __GNUC_PATCHLEVEL__ << std::endl;
#endif

    std::cout << "C++ Standard: " << __cplusplus << std::endl;
    std::cout << "=========================" << std::endl << std::endl;
}

// 模板函数: 计算阶乘
template<typename T>
T factorial(T n)
{
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

// 使用 STL 的示例
void stlExample()
{
    std::cout << "=== STL Examples ===" << std::endl;

    // Vector 示例
    std::vector<int> nums = {5, 2, 8, 1, 9, 3, 7, 4, 6};

    std::cout << "Original vector: ";
    for (int n : nums) std::cout << n << " ";
    std::cout << std::endl;

    // 排序
    std::sort(nums.begin(), nums.end());
    std::cout << "Sorted vector: ";
    for (int n : nums) std::cout << n << " ";
    std::cout << std::endl;

    // 求和
    int sum = std::accumulate(nums.begin(), nums.end(), 0);
    std::cout << "Sum: " << sum << std::endl;

    // 查找
    auto it = std::find(nums.begin(), nums.end(), 5);
    if (it != nums.end()) {
        std::cout << "Found 5 at position: " << std::distance(nums.begin(), it) << std::endl;
    }

    std::cout << "====================" << std::endl;
}

int main()
{
    std::cout << "Hello from NDK Demo (C++ version)!" << std::endl << std::endl;

    // 打印构建信息
    printBuildInfo();

    // 示例计算
    std::cout << "=== Calculation Examples ===" << std::endl;
    std::cout << "Factorial(10) = " << factorial(10L) << std::endl;
    std::cout << "Factorial(15) = " << factorial(15L) << std::endl;
    std::cout << "============================" << std::endl << std::endl;

    // STL 示例
    stlExample();

    return 0;
}
