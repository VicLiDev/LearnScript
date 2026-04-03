#!/usr/bin/env python
#########################################################################
# File Name: using_sys.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:49:34 2024
#########################################################################

# 导入sys模块
import sys

# 示例：使用sys.argv处理命令行参数
# 假设这个脚本名为script.py，并且以python script.py arg1 arg2的形式运行
print("命令行参数：")
for i, arg in enumerate(sys.argv):
    print(f"参数 {i}: {arg}")

# 示例：使用sys.exit()退出程序
# 假设有一个条件检查，如果条件为真，则退出程序并返回状态码1
if len(sys.argv) < 2:
    print("缺少命令行参数，程序将退出。")
    sys.exit(1)  # 非零状态码表示错误或异常退出

# 示例：使用sys.path添加自定义模块路径
# 假设我们有一个自定义模块mymodule.py位于/path/to/my/modules目录下
sys.path.append('/path/to/my/modules')
try:
    import mymodule  # 尝试导入自定义模块
    print("自定义模块成功导入。")
except ImportError:
    print("自定义模块导入失败，请检查路径是否正确。")

# 示例：使用sys.stdout重定向输出
# 将标准输出重定向到一个文件
with open('output.txt', 'w') as f:
    original_stdout = sys.stdout  # 保存原始的标准输出
    sys.stdout = f  # 重定向标准输出到文件
    print("这条信息将被写入到output.txt文件中。")
    sys.stdout = original_stdout  # 恢复原始的标准输出

# 示例：使用sys.version获取Python版本信息
print("Python版本信息：", sys.version)

# 示例：使用sys.maxsize了解平台相关的最大整数大小
print("平台相关的最大整数大小：", sys.maxsize)

# 注意：在实际使用中，你可能需要根据具体情况调整/path/to/my/modules和脚本的其他部分。
# 此外，重定向标准输出到文件后，任何后续的print语句（在恢复标准输出之前）都将输出到文件，
# 而不是控制台或终端。
