#!/usr/bin/env python
#########################################################################
# File Name: class.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:04:29 2024
#########################################################################

from abc import ABC, abstractmethod

# 定义一个抽象基类Animal，包含抽象方法make_sound
class Animal(ABC):
    def __init__(self, name):
        self.name = name

    @abstractmethod
    def make_sound(self):
        pass

    def __str__(self):
        return f"{self.name} makes a sound."

# Dog类继承自Animal类，并重写make_sound方法
class Dog(Animal):
    def make_sound(self):
        return "Woof!"

# Cat类继承自Animal类，并重写make_sound方法
class Cat(Animal):
    def make_sound(self):
        return "Meow!"

# 使用多态，定义一个让动物发声的函数
def make_it_sound(animal):
    print(f"{animal.name} says: {animal.make_sound()}")

# 定义一个农场类，包含多种动物
class Farm:
    def __init__(self):
        self.animals = []

    def add_animal(self, animal):
        self.animals.append(animal)

    def make_all_animals_sound(self):
        for animal in self.animals:
            make_it_sound(animal)

# 演示继承和多态
if __name__ == "__main__":
    dog = Dog("Buddy")
    cat = Cat("Whiskers")

    # 调用具体的make_sound方法，展示多态性
    print(dog.make_sound())  # 输出: Woof!
    print(cat.make_sound())  # 输出: Meow!

    # 使用make_it_sound函数，同样展示多态性
    make_it_sound(dog)  # 输出: Buddy says: Woof!
    make_it_sound(cat)  # 输出: Whiskers says: Meow!

    # 创建一个农场并添加动物
    farm = Farm()
    farm.add_animal(dog)
    farm.add_animal(cat)
    farm.make_all_animals_sound()  # 输出: Buddy says: Woof! 和 Whiskers says: Meow!

    # 尝试实例化Animal抽象基类（这会引发TypeError）
    # animal = Animal("Generic Animal")  # 注释掉，因为这会引发错误
