CMake-Demo
=====
对应根目录下的Demo0~8
[CMake 入门实战](http://hahack.com/codes/cmake) 的源代码。
github代码: https://github.com/wzpan/cmake-demo

学习资料：
https://www.bookstack.cn/read/CMake-Cookbook/README.md
https://github.com/dev-cafe/cmake-cookbook
https://github.com/PacktPublishing/CMake-Cookbook

02.mDemo         一个相对完整的cmake文件
03.mDemo_object  一个针对 object 处理的 demo

## 交叉编译工具链安装

### Ubuntu/Debian 系统

#### ARM 32-bit (arm-linux-gnueabihf)
```bash
sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
```

#### ARM 64-bit (aarch64-linux-gnu)
```bash
sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
```

#### RISC-V 64-bit (riscv64-linux-gnu)
```bash
sudo apt-get install gcc-riscv64-linux-gnu g++-riscv64-linux-gnu
```

#### MIPS (mips-linux-gnu)
```bash
sudo apt-get install gcc-mips-linux-gnu g++-mips-linux-gnu
```

#### MIPS Little Endian (mipsel-linux-gnu)
```bash
sudo apt-get install gcc-mipsel-linux-gnu g++-mipsel-linux-gnu
```

### 一次性安装所有常用工具链
```bash
sudo apt-get install \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
    gcc-riscv64-linux-gnu g++-riscv64-linux-gnu
```

### 验证安装
```bash
# ARM 32-bit
arm-linux-gnueabihf-gcc --version

# ARM 64-bit
aarch64-linux-gnu-gcc --version

# RISC-V 64-bit
riscv64-linux-gnu-gcc --version
```

### 使用方法

参考 mDemo 项目中的交叉编译配置：

```bash
# 方法一：直接指定工具链文件（推荐）
cmake -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-gnu.cmake ..

# 方法三：指定工具链名称
cmake -DCMAKE_TOOLCHAIN_NAME=aarch64-linux-gnu ..

# 方法四：直接指定编译器
cmake -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc \
      -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ ..
```
