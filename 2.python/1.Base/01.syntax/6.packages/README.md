
# Demo Package

This is a simple demo Python package.

## Installation

You can install the package by running:
```
pip install .
```
And remove the package by running:
```
pip uninstall demo_pkg
```
default instal localte:
```
${HOME}/miniforge3/lib/python3.10/site-packages/demo_pkg-0.1.dist-info/*
${HOME}/miniforge3/lib/python3.10/site-packages/demo_pkg/*
```

## Usage

Here are some examples of how to use the package:
```python
from demo_pkg import add, subtract, to_upper, to_lower

print(add(5, 3))        # Output: 8
print(subtract(10, 4))  # Output: 6
print(to_upper("hello"))  # Output: HELLO
print(to_lower("WORLD"))  # Output: world
```
# setup.py

setup.py是Python包的构建脚本，它告诉setuptools如何安装你的包。它通常包含以下信息：
* 包名
* 版本号
* 依赖项
* 描述
* 作者信息
* 入口点（如命令行工具或脚本）
* 包含的包和模块

使用setup.py，你可以通过以下命令来安装包：
```
pip install .
```
或者，如果你想要构建源代码分发或wheel包，可以使用：
```
python setup.py sdist bdist_wheel
````
