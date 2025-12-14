MESSAGE(STATUS "-------- DIR: SRC/MATH --------")

# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_LIB_SRCS 变量
AUX_SOURCE_DIRECTORY(. DIR_LIB_SRCS_MATH)

# 生成链接库 通过add_library指定库的名字，生成之后名字会变成 lib<name>.<a/so>
# STATIC/SHARED/MODULE  静态库/共享库/在使用dyld的系统有效，如果不支持dyld，则被当作SHARD对待
# 如果希望输出的多个库名字一样，参考 SET_TARGET_PROPERTIES 指令的用法
ADD_LIBRARY(mathFunctions STATIC ${DIR_LIB_SRCS_MATH})
ADD_LIBRARY(mathFunctions2 SHARED ${DIR_LIB_SRCS_MATH})
ADD_LIBRARY(mathFunctions3 MODULE ${DIR_LIB_SRCS_MATH})
# 另外还可以是 OBJECT 类型，一个OBJECT库类型定义了一系列从源码编译得来的object文件，
# object文件集合可以通过$<TARGET_OBJECT:name>语法来作为其他target的输入
# 这是一个生成表达式可以用来给其他target提供OBJECT库：
ADD_LIBRARY (mathFunctions4 OBJECT ${DIR_LIB_SRCS_MATH})
# add_executable(demo $<TARGET_OBJECT:mathFunctions4> <其他的源文件>)
# TARGET_LINK_LIBRARIES (demo  $<TARGET_OBJECTS:mathFunctions4>)

MESSAGE(STATUS "-------- DIR: SRC/MATH END --------")
