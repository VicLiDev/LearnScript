#!/usr/bin/env python

import sys
from pathlib import Path

root_dir = Path(__file__).parent.parent
sys.path.append(str(root_dir))

import unittest
import demo_pkg as mpkg
# 或者如下导入，调用的时候就不需要加mpkg前缀
# from demo_pkg import *

class TestDemoPkg(unittest.TestCase):

    def test_add(self):
        self.assertEqual(mpkg.add(2, 3), 5)

    def test_subtract(self):
        self.assertEqual(mpkg.subtract(10, 5), 5)

    def test_to_upper(self):
        self.assertEqual(mpkg.to_upper("hello"), "HELLO")

    def test_to_lower(self):
        self.assertEqual(mpkg.to_lower("WORLD"), "world")

if __name__ == '__main__':
    unittest.main()

