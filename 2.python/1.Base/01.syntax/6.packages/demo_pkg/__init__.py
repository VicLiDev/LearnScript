
"""
Demo Package for Python
=======================
This is a simple demo package for Python with basic functionalities.
"""

# 外部以 package 的形式进行 import 时，只能访问到这里import过的内容
# 外部如果以 module 的形式进行 import 时，这里不受影响

# 相对导入
from .math_operations import add, subtract
# 绝对导入
from demo_pkg.string_operations import to_upper, to_lower
