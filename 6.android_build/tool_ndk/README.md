# NDK CMake 交叉编译示例

本示例演示如何使用 CMake 和 Android NDK 进行交叉编译，生成可在 Android 平台运行的可执行程序。

## 目录结构

```
tool_ndk/
├── CMakeLists.txt   # CMake 配置文件
├── prjBuild.sh      # 构建脚本
├── main.c           # C 语言示例代码
├── main.cpp         # C++ 语言示例代码
└── README.md        # 说明文档
```

## 前置要求

1. **Android NDK** - 需要安装 Android NDK
   - 推荐版本: r21+ (示例使用 r25c)
   - 下载地址: https://developer.android.com/ndk/downloads

2. **CMake** - 版本 3.10+
   ```bash
   cmake --version
   ```

3. **Ninja** (可选，推荐) - 更快的构建工具
   ```bash
   ninja --version
   ```

## 环境配置

设置 NDK 路径环境变量:

```bash
export NDK_ROOT=/path/to/android-ndk-r25c
```

或者修改 `prjBuild.sh` 脚本中的 `NDK_ROOT` 变量。

## 构建方式

### 方式1: 使用构建脚本 (推荐)

```bash
# 赋予执行权限
chmod +x prjBuild.sh

# 构建 arm64-v8a (默认)
./prjBuild.sh

# 构建 armeabi-v7a
./prjBuild.sh armeabi-v7a

# 构建所有 ABI
./prjBuild.sh all

# 清理构建目录
./prjBuild.sh clean

# 显示帮助
./prjBuild.sh help
```

### 方式2: 手动执行 CMake

```bash
# 创建构建目录
mkdir build && cd build

# 配置项目
cmake -DCMAKE_TOOLCHAIN_FILE=$NDK_ROOT/build/cmake/android.toolchain.cmake \
      -DANDROID_ABI=arm64-v8a \
      -DANDROID_PLATFORM=android-21 \
      -DANDROID_STL=c++_static \
      -G Ninja \
      ..

# 构建
cmake --build .
```

## 支持的 ABI

| ABI | 描述 | 适用设备 |
|-----|------|---------|
| arm64-v8a | 64位 ARM | 现代 Android 设备 (推荐) |
| armeabi-v7a | 32位 ARM | 旧设备 |
| x86_64 | 64位 x86 | 模拟器 |
| x86 | 32位 x86 | 旧模拟器 |

## 关键参数说明

### ANDROID_ABI
目标 CPU 架构，常用值:
- `arm64-v8a` - 64位 ARM (推荐)
- `armeabi-v7a` - 32位 ARM
- `x86_64` - 64位 Intel
- `x86` - 32位 Intel

### ANDROID_PLATFORM
目标 Android API 级别，格式: `android-<level>`
- `android-21` - Android 5.0 (Lollipop)
- `android-24` - Android 7.0 (Nougat)
- `android-28` - Android 9.0 (Pie)
- `android-30` - Android 11.0

### ANDROID_STL
C++ 标准库类型:
- `c++_static` - 静态链接 libc++ (推荐)
- `c++_shared` - 动态链接 libc++
- `system` - 系统 STL (仅 C)
- `none` - 无 STL 支持

## 在设备上运行

构建完成后，使用 adb 推送到设备并运行:

```bash
# 推送到设备
adb push build_arm64-v8a/bin/demo_c /data/local/tmp/
adb push build_arm64-v8a/bin/demo_cpp /data/local/tmp/

# 添加执行权限
adb shell chmod +x /data/local/tmp/demo_c
adb shell chmod +x /data/local/tmp/demo_cpp

# 运行
adb shell /data/local/tmp/demo_c
adb shell /data/local/tmp/demo_cpp
```

## CMakeLists.txt 核心要点

```cmake
# 1. 指定 toolchain 文件 (最重要)
cmake -DCMAKE_TOOLCHAIN_FILE=$NDK_ROOT/build/cmake/android.toolchain.cmake ...

# 2. 设置目标 ABI
-DANDROID_ABI=arm64-v8a

# 3. 设置目标平台
-DANDROID_PLATFORM=android-21

# 4. 设置 STL 类型
-DANDROID_STL=c++_static
```

## 常见问题

### 1. NDK 路径找不到
确保 `NDK_ROOT` 环境变量正确设置，或修改脚本中的路径。

### 2. 架构不匹配
如果目标设备是 64 位 ARM，使用 `arm64-v8a`；如果是 32 位，使用 `armeabi-v7a`。

### 3. 链接错误
检查 `ANDROID_STL` 设置，C++ 程序推荐使用 `c++_static`。

## 参考资料

- [Android NDK 官方文档](https://developer.android.com/ndk/guides)
- [CMake Android 交叉编译](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-android)
- [NDK 工具链](https://developer.android.com/ndk/guides/other_build_systems)
