# 生成可执行文件

Python 生成可执行文件（.exe、嵌入式固件里的可执行二进制）最常用的方法是借助打包
工具，把 `.py` 脚本和解释器、依赖打包到一个单文件或目录结构中。

---

## PyInstaller

### Windows 平台（生成 .exe）

最常用的是 **PyInstaller**。

#### 安装

```bash
pip install pyinstaller
```

#### 打包单个脚本

```bash
pyinstaller --onefile your_script.py
```

* 生成的可执行文件在 `dist/your_script.exe`
* `--onefile`：打包成一个单文件
* `--noconsole`：GUI 程序时不弹出黑色控制台窗口（Windows）

#### 带图标

```bash
pyinstaller --onefile --icon=myicon.ico your_script.py
```

---

### Linux 平台（生成可执行 ELF）

PyInstaller 同样适用：

```bash
pip install pyinstaller
pyinstaller --onefile your_script.py
```

生成的 `dist/your_script` 是 ELF 格式，可以直接运行：

```bash
./dist/your_script
```

> 注意：在系统上打包的可执行文件，通常只能在**相同或兼容的 Linux 发行版**上运行。

---

### 跨平台打包

* **不能直接在 Windows 上打包 Linux 版本，反之亦然**，除非用交叉编译环境（如 Docker、虚拟机）。
* 如果需要一份源码打多个平台的可执行文件，可以：
  * 在对应系统上运行 PyInstaller
  * 或者用 [PyOxidizer](https://pyoxidizer.readthedocs.io/)、[Nuitka](https://nuitka.net/)
    （更偏向编译成 C/C++ 再构建）

---

### 更小的可执行文件

PyInstaller 打出来的文件可能几十 MB，如果需要更小：

* 用 `--onefile` 再配合 **UPX** 压缩：
```bash
# 安装 UPX（Linux）
sudo apt install upx
# 压缩打包
pyinstaller --onefile --upx-dir /path/to/upx your_script.py
```

* 或考虑 **Nuitka**，会将 Python 编译成 C，再编译成二进制，运行速度也更快：
```bash
pip install nuitka
python -m nuitka --onefile your_script.py
```

---
### 遇到问题

#### 现象

打包 matplotlib 的demo，打包完之后，执行遇到如下问题：
```
Traceback (most recent call last):
  File "PIL/ImageTk.py", line 65, in _pyimagingtkcall
_tkinter.TclError: invalid command name "PyImagingPhoto"

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "tableDemo.py", line 6, in <module>
    fig, ax = plt.subplots(1, 2)
  File "matplotlib/pyplot.py", line 1759, in subplots
  File "matplotlib/pyplot.py", line 1027, in figure
  File "matplotlib/pyplot.py", line 550, in new_figure_manager
  File "matplotlib/backend_bases.py", line 3507, in new_figure_manager
  File "matplotlib/backend_bases.py", line 3512, in new_figure_manager_given_figure
  File "matplotlib/backend_bases.py", line 1797, in new_manager
  File "matplotlib/backends/_backend_tk.py", line 494, in create_with_canvas
  File "PIL/ImageTk.py", line 129, in __init__
  File "PIL/ImageTk.py", line 183, in paste
  File "PIL/ImageTk.py", line 69, in _pyimagingtkcall
ModuleNotFoundError: No module named 'PIL._tkinter_finder'
[PYI-566050:ERROR] Failed to execute script 'tableDemo' due to unhandled exception!
```

#### 原因

这个报错是 **PyInstaller 打包带 Tkinter + Pillow（ImageTk） + Matplotlib** 时的一个常见坑，
根本原因是：
* Pillow 的 `ImageTk` 模块依赖 Tkinter 的 **tcl/tk 运行时** 和 `_tkinter_finder` 模块，
  而 PyInstaller 默认不会把它们完全收进去。
* 打包后运行找不到 `PIL._tkinter_finder`，就会出现
  `invalid command name "PyImagingPhoto"` / `ModuleNotFoundError: No module named 'PIL._tkinter_finder'`。

### 解决方案

1. 确保系统有 Tkinter

在 Python 运行环境里能运行：
```python
import tkinter
import PIL.ImageTk
```

如果这一步报错，先安装 Tkinter：
* **Ubuntu/Debian**
```bash
sudo apt install python3-tk
```
* **Windows**
  官方 Python 安装包一般自带 Tkinter。


2. PyInstaller 手动加上缺失模块

PyInstaller 有时候没自动识别 `PIL._tkinter_finder`，需要显式指定：
```bash
pyinstaller --onefile \
    --hidden-import PIL._tkinter_finder \
    tableDemo.py
```

如果你的程序还依赖 `matplotlib` 的 TkAgg 后端，也要加：
```bash
pyinstaller --onefile \
    --hidden-import PIL._tkinter_finder \
    --hidden-import matplotlib.backends.backend_tkagg \
    tableDemo.py
```

3. 确保打包时包含 tcl/tk 运行库

Tkinter 需要 `tcl` 和 `tk` 动态库，以及 `tcl` 脚本目录（如 `tcl8.6/`、`tk8.6/`）。
PyInstaller 通常会自动从你的 Python 安装目录复制它们，但有时候需要手动指定：
```bash
pyinstaller --onefile \
    --hidden-import PIL._tkinter_finder \
    --add-data "C:/Path/To/Python/tcl/tcl8.6;./tcl/tcl8.6" \
    --add-data "C:/Path/To/Python/tcl/tk8.6;./tcl/tk8.6" \
    tableDemo.py
```

Linux 下的形式：
```bash
--add-data "/usr/share/tcltk/tcl8.6:./tcl/tcl8.6" \
--add-data "/usr/share/tcltk/tk8.6:./tcl/tk8.6"
```

4. 修改 matplotlib 后端（可选）

如果不需要交互式 GUI 显示，可以改成非 Tkinter 后端，这样打包就不依赖 Tk：
```python
import matplotlib
matplotlib.use('Agg')  # 无GUI绘图
```

这样就避免了 `PIL.ImageTk`、TkAgg 的依赖，打包后不会有这个错误。

**推荐的最简修复命令**

如果就是要用 TkAgg 显示图形，直接这样打：
```bash
pyinstaller --onefile \
    --hidden-import PIL._tkinter_finder \
    --hidden-import matplotlib.backends.backend_tkagg \
    tableDemo.py
```
一般就能解决。

### 工程打包

PyInstaller 打包工程非常简单，只要指定**入口文件**（main.py），它会自动分析依赖，
把所有 `.py`、包、资源文件打进去。

假设目录结构：
```
my_project/
│── main.py
│── utils.py
│── data/
│   ├── config.yaml
│── package/
│   ├── __init__.py
│   ├── module1.py
```

打包命令
```bash
cd my_project
pyinstaller --onefile main.py
```

如果有资源文件（图片、配置等）
```bash
pyinstaller --onefile \
    --add-data "data/config.yaml:data" \
    main.py
```

> `--add-data "源路径:目标路径"`
> Windows 下分隔符用 `;`，Linux 下用 `:`

✅ **特点**：入口文件清晰、自动递归依赖、对多文件项目支持好。

---

## PyOxidizer

### 原理

* 用 Rust 构建工具，把 **Python 解释器** + **代码** + **依赖库**打包到一个可执行文件中。
* 源码和 `.pyc` 会被打进二进制的内存段中，运行时直接从内存加载，而不是解压到磁盘。
* 启动快，产物体积比 PyInstaller 小，但配置相对复杂。

### 安装
```bash
# 安装 Rust（如果还没有）
curl https://sh.rustup.rs -sSf | sh
# 安装 PyOxidizer
cargo install pyoxidizer
```

### 初始化项目
```bash
pyoxidizer init-project my_app
cd my_app
```

### 修改构建脚本 `pyoxidizer.bzl`

假设主文件是 `main.py`：
```python
def make_exe():
    return default_python_executable(
        name="my_app",
        python_resource("app", "main.py"),
    )
```

### 构建

```bash
pyoxidizer build
```

输出位置：
```
build/<target-triple>/release/install/my_app(.exe)
```

✅ **适合**：CLI 工具、嵌入式部署、对启动速度有要求的应用。
⚠️ **注意**：有些动态加载的 C 扩展（尤其 Tkinter、Pillow 这种）需要额外配置。

### 工程打包

PyOxidizer 需要手动配置工程路径，否则它只会打包单个脚本。

假设结构如下：
```
my_project/
│── main.py
│── utils.py
│── package/
│   ├── __init__.py
│   ├── module1.py
```

初始化工程
```bash
pyoxidizer init-project my_project_build
cd my_project_build
```

修改 `pyoxidizer.bzl`
```python
def make_exe():
    exe = default_python_executable(
        name="my_project",
        # 把整个工程目录打包进去
        python_resources_from_directory("app", "../my_project"),
    )
    return exe
```

然后：
```bash
pyoxidizer build
```

生成的可执行文件会包含 `my_project` 下的所有 `.py` 文件和依赖。

✅ **特点**：
* 适合打包整个目录为内存资源
* 需要在构建脚本中手动添加资源
* 资源文件（yaml、图片）也要用 `resource()` 添加，否则不会打进二进制

---

## Nuitka

### 原理

* 把 `.py` 文件**编译成 C 代码**，再用 C 编译器（如 gcc、clang、MSVC）编译成二进制。
* 对 CPU 密集型代码可能有一点性能提升。
* 打包结果是 ELF/EXE，运行时依然需要 Python 标准库动态链接（除非用 `--standalone`）。

### 安装

```bash
pip install nuitka
```

### 最简单打包

```bash
python -m nuitka your_script.py
```

会生成：

```
your_script.exe   # Windows
your_script       # Linux
```

### 生成完全独立可执行文件（无外部依赖）

```bash
python -m nuitka --standalone --onefile your_script.py
```

* `--standalone`：包含运行所需的所有依赖
* `--onefile`：压缩成单个文件（启动稍慢）

✅ **适合**：需要性能优化的 Python 程序、长期运行的服务、跨平台打包。
⚠️ **注意**：编译时间较长，某些第三方包的编译需要系统开发库（如 `libffi-dev`）。

---

### 工程打包

Nuitka 会编译 Python 源码为 C，再编译成二进制。如果是多文件项目，可以直接指定入口
文件，它会编译依赖模块。
```bash
python -m nuitka --standalone --onefile main.py
```

如果依赖的模块不在同级目录，需要显式添加路径：
```bash
python -m nuitka --standalone --onefile \
    --include-data-dir=data=data \
    --include-module=package.module1 \
    main.py
```

* `--include-data-dir` 用于整个资源目录
* `--include-module` 用于手动指定要编译的模块（避免遗漏）

✅ **特点**：
* 会把整个项目编译成二进制（源码不可见）
* 性能可能有提升
* 有些动态导入模块（`importlib.import_module`）需要手动 `--include-module`

---

## 对比表

| 特性         | PyInstaller                 | PyOxidizer                  | Nuitka                     |
| ------------ | --------------------------- | --------------------------- | -------------------------- |
| 打包方式     | 解释器 + pyc 解压到临时目录 | 解释器 + pyc 嵌入内存       | Python → C → 二进制        |
| 启动速度     | 中等                        | 快                          | 中等（取决于是否 onefile） |
| 文件体积     | 大                          | 相对小                      | 视情况（standalone 较大）  |
| 动态加载支持 | 强                          | 中（需配置）                | 中（需配置）               |
| 性能优化     | 无                          | 无                          | 有（C 编译优化）           |
| 配置复杂度   | 低                          | 高                          | 中                         |
| 跨平台打包   | 否（需目标平台构建）        | 否（需目标平台构建）        | 否（需目标平台构建）       |
| 适合场景     | 常规桌面应用、快速打包      | 嵌入式、命令行工具、启动快  | 性能敏感程序、长期运行服务 |


多文件项目对比

| 工具        | 配置复杂度 | 多文件自动打包 | 资源文件处理         | 动态导入支持                |
| ----------- | ---------- | -------------- | -------------------- | --------------------------- |
| PyInstaller | 低         | 自动递归       | `--add-data`         | 强（hooks 支持好）          |
| PyOxidizer  | 高         | 需手动添加目录 | 需 `resource()` 声明 | 中（需配置）                |
| Nuitka      | 中         | 自动递归       | `--include-data-dir` | 中（需 `--include-module`） |

---

建议：
* **快速打包多文件项目** → 用 **PyInstaller**
* **追求启动速度 / 嵌入式部署** → 用 **PyOxidizer**
* **想保护源码 & 可能优化性能** → 用 **Nuitka**
