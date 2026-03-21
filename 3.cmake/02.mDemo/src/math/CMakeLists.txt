MESSAGE(STATUS "-------- DIR: SRC/MATH --------")

# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_LIB_SRCS 变量
AUX_SOURCE_DIRECTORY(. DIR_LIB_SRCS_MATH)

# add_library(<name> [STATIC | SHARED | MODULE | INTERFACE | OBJECT] [source1 source2 ...])
#   <name> → 库的名字，生成之后名字会变成 lib<name>.<a/so>
#   [STATIC | SHARED | MODULE | INTERFACE | OBJECT] → 库类型
#   [source1 source2 ...] → 源文件列表（可为空）
# 如果没有指定类型，默认类型由 BUILD_SHARED_LIBS 决定：
#   ON → SHARED
#   OFF → STATIC
# 库类型详解
# | 类型      | 是否生成二进制  | 特点                                          | 典型用途                       |
# | --------- | --------------- | --------------------------------------------- | ------------------------------ |
# | STATIC    | .a/.lib         | 编译后打包进可执行文件                        | 常规静态库                     |
# | SHARED    | .so/.dll/.dylib | 运行时动态加载                                | 动态库/插件                    |
# | MODULE    | 生成二进制      | 不自动链接给其他 target                       | 插件/可加载模块                |
# | INTERFACE | 不生成二进制    | 只传递接口/头文件/宏/编译选项                 | Header-only 库，公共选项       |
# | OBJECT    | 不生成二进制    | 生成对象文件 `.o`，可组合到其他库或可执行文件 | 模块化源文件复用，减少重复编译 |
# 总结：
# STATIC 打包、SHARED 动态、MODULE 插件、INTERFACE 接口、OBJECT 供组合
# 注意：
# 在使用dyld的系统有效，如果不支持dyld，则被当作SHARD对待
# 如果希望输出的多个库名字一样，参考 SET_TARGET_PROPERTIES 指令的用法
ADD_LIBRARY(mathFunctions STATIC ${DIR_LIB_SRCS_MATH})
ADD_LIBRARY(mathFunctions2 SHARED ${DIR_LIB_SRCS_MATH})
ADD_LIBRARY(mathFunctions3 MODULE ${DIR_LIB_SRCS_MATH})
# object文件集合可以通过${<TARGET_OBJECT:name>}语法来作为其他target的输入
# 这是一个生成表达式可以用来给其他target提供OBJECT库：
ADD_LIBRARY (mathFunctions4 OBJECT ${DIR_LIB_SRCS_MATH})
# add_executable(demo $<TARGET_OBJECT:mathFunctions4> <其他的源文件>)
# TARGET_LINK_LIBRARIES (demo  $<TARGET_OBJECTS:mathFunctions4>)

MESSAGE(STATUS "-------- DIR: SRC/MATH END --------")
