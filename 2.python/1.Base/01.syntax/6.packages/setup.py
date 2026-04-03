
from setuptools import setup, find_packages

setup(
    name="demo_pkg",
    version="0.1",
    packages=find_packages(),
    description="A demo Python package with basic functionalities",
    author="Your Name",
    author_email="your.email@example.com",
    url="https://example.com/demo_pkg",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)
