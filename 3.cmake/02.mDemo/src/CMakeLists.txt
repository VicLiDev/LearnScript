MESSAGE(STATUS "-------- DIR: SRC --------")
MESSAGE(STATUS "    PROJECT_SOURCE_DIR: " ${PROJECT_SOURCE_DIR})
MESSAGE(STATUS "    mDemoPrj_SOURCE_DIR: " ${mDemoPrj_SOURCE_DIR})
MESSAGE(STATUS "    PROJECT_BINARY_DIR: " ${PROJECT_BINARY_DIR})
MESSAGE(STATUS "    mDemoPrj_BINARY_DIR: " ${mDemoPrj_BINARY_DIR})
MESSAGE(STATUS "    VAL FROM MAIN CMAKELISTS: " ${MAINVAL})

# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
AUX_SOURCE_DIRECTORY(. DIR_SRCS)

# 指定生成目标
# ADD_EXECUTABLE(demo ${DIR_SRCS})

###### target_sources ######
# 摘自： https://cmake.org/cmake/help/latest/command/target_sources.html
# New in version 3.1.
# 向目标添加源
# target_sources(<target>
#   <INTERFACE|PUBLIC|PRIVATE> [items1...]
#   [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])
# 指定在构建目标和/或其依赖项时要使用的源。命名的 <target> 必须由诸如
# add_executable() 或 add_library() 或 add_custom_target() 之类的命令创建，
# 并且不能是 ALIAS 目标。 <items> 可以使用生成器表达式。
# 3.20 新版功能：<target> 可以是自定义目标。

# 需要 INTERFACE、PUBLIC 和 PRIVATE 关键字来指定它们后面的源文件路径 (<items>) 的范围。
# PRIVATE 和 PUBLIC 项将填充 <target> 的 SOURCES 属性，这些属性在构建目标本身时使用。 
# PUBLIC 和 INTERFACE 项将填充 <target> 的 INTERFACE_SOURCES 属性，在构建依赖项时使用。 
# 由 add_custom_target() 创建的目标只能具有 PRIVATE 范围。

# 摘自：https://blog.csdn.net/guaaaaaaa/article/details/125601766
# PRIVATE 和 PUBLIC 关键字指出这些对应的源应在何处被使用。
# PRIVATE 表示这些源只应添加到 当前目标，
# PUBLIC 表示这些源应添加到 当前目标 和任何链接到当前目标的对象中。
# INTERFACE 用于不应添加到 当前目标 但应添加到任何链接到 myLib 的对象的源。
# 实际上，源几乎总是 PRIVATE 的，因为它们通常不应该被添加到任何链接到该目标的相关内容中。
# 仅由头构成的接口库 (Header-only interface libraries) 是一个例外，因为源只能通过 INTERFACE 关键字添加到接口库中。
# 不要将 PRIVATE, PUBLIC 和 INTERFACE 关键字与头是否是库的公共API的一部分混淆，在这里这些关键字专门用于控制将源添加到哪些目标。
# 还有一些不太常见的情况，一些文件（例如资源、图像、数据文件）可能需要直接编译成链接到库的目标，以便在运行时找到它们。
# 将这样的源用 PUBLIC 或 INTERFACE 关键字列出可以帮助解决此类情况。请注意，安装 (install) 非私有源可能会有一些问题。
ADD_EXECUTABLE(demo "")
TARGET_SOURCES(demo PRIVATE ${DIR_SRCS})

TARGET_LINK_LIBRARIES(demo  ${EXTRA_LIBS})
# TARGET_LINK_LIBRARIES (demo  $<TARGET_OBJECTS:mathFunctions4>)

MESSAGE(STATUS "    CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR})
MESSAGE(STATUS "    CMAKE_CURRENT_SOURCE_DIR: " ${CMAKE_CURRENT_SOURCE_DIR})


MESSAGE(STATUS "-------- DIR: SRC END --------")
