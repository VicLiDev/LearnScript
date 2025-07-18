MESSAGE(STATUS "-------- EXEC CUSTOM CMD --------")

# ----------------------------------------------------------------------------
# ADD_CUSTOM_COMMAND
# ----------------------------------------------------------------------------
# 通过显式执行，可以看到这里的效果:
# make my_custom_target
# make generate_file
#
# 使用 ALL 关键字意味着这个自定义目标将作为默认构建目标的一部分被执行
# 如果只想在显式请求时才运行这个目标，可以省略 ALL
# 显式执行的方法为：执行cmake之后，显式执行：make my_custom_target
ADD_CUSTOM_TARGET(my_custom_target ALL
    # 当这个目标被构建时，会执行下面的 COMMAND
    COMMAND ${CMAKE_COMMAND} -E echo "My custom target is running!"
    # 这是一个可选的 COMMENT，它将在构建时显示在控制台中
    COMMENT "Running a custom target"
    # VERBATIM 选项告诉 CMake 不要对 COMMAND 进行任何解释或转义
    VERBATIM
)
# 如果想要让这个自定义目标成为默认构建目标（即，当只运行 'make' 或 'cmake --build .' 时），
# 可以添加一个 ALL 依赖。但注意，这通常不是推荐的做法，除非自定义目标是项目构建流程
# 的核心部分。

# ADD_CUSTOM_COMMAND 在 CMake 中有两种主要用法，其中一种需要 TARGET 参数，而另一种
# 不需要。
#
# --> OUTPUT
# add_custom_command() 定义一个命令，在满足某些条件时运行，比如：
#   生成某个输出文件（例如 .ko）
#   在依赖文件变更时重新执行
#
# 常用语法结构（针对构建文件）：
# add_custom_command(
#   OUTPUT output_file1 [output_file2 ...]
#   COMMAND some_command [args...]
#   [DEPENDS dep1 dep2 ...]
#   声明命令执行过程中会生成哪些“副产品文件”，以便 CMake 正确地处理依赖关系、
#   增量构建和并行构建。
#   [BYPRODUCTS <file1> [<file2> ...]]
#   [WORKING_DIRECTORY dir]
#   [COMMENT "message"]
#   [VERBATIM]  # 防止 CMake 自动转义参数
# )
#
# 用法解释：
# 关键字            含义
# OUTPUT            指定命令生成的文件（构建目标）
# COMMAND           实际执行的命令（可以有多个 COMMAND）
# DEPENDS           指定依赖的输入文件，如果这些文件有变化就会重新执行命令
# WORKING_DIRECTORY 执行命令时的当前工作目录
# COMMENT           构建时显示的提示信息
# VERBATIM          确保命令参数按字面意思处理，推荐使用
#
# 示例（编译内核模块）：
# add_custom_command(
#   OUTPUT my_module.ko
#   COMMAND make -C /lib/modules/$(uname -r)/build M=${CMAKE_CURRENT_SOURCE_DIR} modules
#   DEPENDS my_module.c
#   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
#   COMMENT "Building kernel module"
# )
#
# --> TARGET
# 还有一种 附加命令到已有目标（如 add_executable() 或 add_custom_target() 创建的目标）
# 的方式，通常用于：
#   编译完成后执行某些命令（例如打包、安装、拷贝）
#   构建过程中添加自定义钩子（如 post-build step）
#
# 语法形式：
# add_custom_command(TARGET <target>
#                    POST_BUILD | PRE_BUILD | PRE_LINK
#                    COMMAND <cmd> [args...]
#                    [COMMENT "text"]
#                    [WORKING_DIRECTORY <dir>]
#                    [VERBATIM])
#
# 参数说明：
# | 参数                | 说明                                                               |
# | ------------------- | ------------------------------------------------------------------ |
# | `TARGET`            | 要附加命令的目标名（已经通过 `add_executable()` 或类似方式定义过） |
# | `POST_BUILD`        | 在目标构建完成之后执行（最常用 ✅）                                |
# | `PRE_BUILD`         | 在构建目标之前执行（仅限 Visual Studio）                           |
# | `PRE_LINK`          | 在链接目标之前执行（仅限部分平台）                                 |
# | `COMMAND`           | 要执行的命令及参数                                                 |
# | `COMMENT`           | 构建输出中显示的信息                                               |
# | `WORKING_DIRECTORY` | 指定命令执行目录                                                   |
# | `VERBATIM`          | 按字面意义处理命令参数（推荐）                                     |
#
# 示例：构建后复制一个文件
#   add_executable(myapp main.cpp)
#   add_custom_command(TARGET myapp POST_BUILD
#       COMMAND ${CMAKE_COMMAND} -E copy
#               ${CMAKE_CURRENT_BINARY_DIR}/myapp
#               ${CMAKE_CURRENT_SOURCE_DIR}/bin/
#       COMMENT "Copying binary to bin/ folder"
#   )
# 这个例子会在 myapp 编译完成后，将它复制到 bin/ 目录下。
#
# 应用场景
#   编译完可执行文件后自动打包成 zip
#   编译完内核模块后自动 strip/签名/拷贝到某个目录
#   编译完自动运行测试脚本
#   在 Windows 下安装 DLL、注册 COM 组件等
#
# 示例：构建内核模块后拷贝 .ko 文件
#   add_custom_target(my_module
#     DEPENDS ${CMAKE_BINARY_DIR}/my_module.ko
#   )
#   add_custom_command(TARGET my_module POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy
#             ${CMAKE_BINARY_DIR}/my_module.ko
#             ${CMAKE_CURRENT_SOURCE_DIR}/output/
#     COMMENT "Copying my_module.ko to output directory"
#   )
#
# TARGET 和 OUTPUT 的对比：
# | 特点         | `add_custom_command(OUTPUT ...)`              | `add_custom_command(TARGET ...)`       |
# | ------------ | --------------------------------------------- | -------------------------------------- |
# | 是否生成文件 | ✅ 生成文件（用于构建目标）                   | ❌ 不生成文件，只是附加命令            |
# | 是否创建目标 | ❌ 不创建目标，需要配合 `add_custom_target()` | ❌ 不创建目标，作用于已有目标          |
# | 用途         | 生成 .ko、.h、.cpp 等文件                     | 构建后动作，如 copy、strip、packaging  |
# | 依赖自动处理 | ✅ 可设置 `DEPENDS`                           | ❌ 不涉及依赖管理                      |
# | 使用范围     | 通用构建生成（中间目标）                      | 主要用于最终目标后的处理（post-build） |
#
# 在 add_custom_command 的使用中，不能同时指定 TARGET 和 OUTPUT ，除非它们是在
# add_custom_command 的不同参数中使用的。在 add_custom_command 的上下文中，TARGET
# 参数通常用于将自定义命令与现有的目标（如可执行文件或库）关联起来，而 OUTPUT 参数
# 则用于指定自定义命令生成的输出文件。
# 如果这个自定义命令是某个目标的一部分，你需要将它添加到该目标的依赖中
# 例如，你可以使用 add_dependencies() 来添加一个依赖
ADD_CUSTOM_COMMAND(
    # 将此自定义命令与 generate_header 目标关联起来
    TARGET my_custom_target POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "My custom command(TARGET) is running!"
    COMMENT "Running a custom command(TARGET)"
    VERBATIM
)

SET(M_CUSTOM_FILE ${CMAKE_CURRENT_BINARY_DIR}/custom_command.h)
# FILE(WRITE ${M_CUSTOM_FILE} "")
ADD_CUSTOM_COMMAND(
    OUTPUT ${M_CUSTOM_FILE}
    COMMAND ${CMAKE_COMMAND} -E echo "My custom command(OUTPUT) is running!" # > ${M_CUSTOM_FILE}
    COMMENT "Running a custom command(OUTPUT)"
    VERBATIM
)


# ----------------------------------------------------------------------------
# ADD_CUSTOM_TARGET
# ----------------------------------------------------------------------------
# add_custom_target() 定义一个伪目标（并不会自动生成一个实际文件），通常用于封装
# 执行 add_custom_command() 定义的命令结果，或者执行一些脚本/命令。
# 语法结构：
# add_custom_target(target_name
#   [ALL]  # 可选：添加到默认构建目标
#   [COMMAND cmd1 args1...]
#   [DEPENDS dep1 dep2 ...]
#   [WORKING_DIRECTORY dir]
#   [COMMENT "message"]
# )
# 或者（常见组合用法）：
# add_custom_target(my_target ALL
#   DEPENDS my_module.ko
# )
# 这里不写 COMMAND，而是说：这个目标依赖于前面定义的 add_custom_command() 的输出文件。
#
# 二者结合使用：典型用法
# 组合方式如下：
#   add_custom_command(
#     OUTPUT ${CMAKE_BINARY_DIR}/my_module.ko
#     COMMAND make -C /lib/modules/$(uname -r)/build M=${CMAKE_CURRENT_SOURCE_DIR} modules
#     DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/my_module.c
#     WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
#   )
#   add_custom_target(my_module ALL
#     DEPENDS ${CMAKE_BINARY_DIR}/my_module.ko
#   )
# 当你运行 make 时，CMake 会自动：
#   检查 .ko 文件是否存在或是否过期
#   如果需要，就运行 make -C ... 命令来生成 .ko
#   把这个目标绑定到 my_module 上
#   如果加了 ALL，那么会在你执行 make（默认目标）时一并构建
#
# 常见用法场景总结：
# 用法场景                            用法推荐
# 调用外部构建工具（如内核 make）     add_custom_command() + add_custom_target()
# 自动生成代码（如 protobuf、thrift） add_custom_command(OUTPUT)
# 执行打包、拷贝、清理等任务          add_custom_target(COMMAND ...)
# 构建副产品不参与默认目标            不加 ALL 参数
#
# 创建一个自定义目标，该目标依赖于add_custom_command生成的文件
ADD_CUSTOM_TARGET(generate_file ALL DEPENDS ${M_CUSTOM_FILE})
# 显式执行：make generate_file


# ----------------------------------------------------------------------------
# ADD_DEPENDENCIES
# ----------------------------------------------------------------------------
# add_dependencies() 是 CMake 中用于设置 目标之间的构建依赖关系 的函数，是组织构建
# 顺序的核心工具之一，尤其在你使用自定义构建步骤（如 add_custom_command()、
# add_custom_target()）时非常有用。
#
# 基本语法
#   add_dependencies(<target> <dependency1> <dependency2> ...)
# 这意味着：
#   “在构建 <target> 之前，先构建 <dependency1>, <dependency2> 等等。”
# 它告诉 CMake：
#   哪些目标 必须先构建
#   哪些构建顺序要被强制同步
#   不会影响链接关系（那是 target_link_libraries() 干的事）
#
# 示例 1：确保模块先构建
#   add_custom_target(my_module ALL
#       DEPENDS ${CMAKE_BINARY_DIR}/my_module.ko
#   )
#   add_custom_target(run_tests
#       COMMAND ./run_tests.sh
#   )
#   确保 my_module 在 run_tests 之前构建完成
#   add_dependencies(run_tests my_module)
# 含义是：运行 run_tests 目标之前，必须先构建 my_module 目标。
#
# 示例 2：生成文件前必须执行某脚本
#   add_custom_target(generate_version_file
#       COMMAND ./gen_version.sh > ${CMAKE_BINARY_DIR}/version.h
#   )
#
#   add_executable(myapp main.cpp)
#
#   # main.cpp 包含了 version.h，所以需要先生成 version.h
#   add_dependencies(myapp generate_version_file)


# ----------------------------------------------------------------------------
# SET_TARGET_PROPERTIES
# ----------------------------------------------------------------------------
# set_target_properties() 是 CMake 中用于设置构建目标（如 executable、library、
# custom_target）属性的命令。它是一个非常强大和灵活的函数，可以配置目标的各种行为
# 和元信息，例如输出文件名、编译规则、是否导出符号等。
#
# 基本语法
#   set_target_properties(<target1> [<target2> ...]
#       PROPERTIES <prop1> <value1> [<prop2> <value2> ...])
# 可以对一个或多个目标一次性设置多个属性
# 所有属性名和值都是 字符串
#
# 常用属性（精选）
# | 属性名                         | 用途                               | 示例                               |
# | ------------------------------ | ---------------------------------- | ---------------------------------- |
# | `OUTPUT_NAME`                  | 更改最终生成的文件名（不含扩展名） | 把 `myapp` 改成 `custom_app`       |
# | `ARCHIVE_OUTPUT_DIRECTORY`     | `.a` 静态库输出路径                | 指定静态库输出目录                 |
# | `LIBRARY_OUTPUT_DIRECTORY`     | `.so` 动态库输出路径               | 指定共享库输出目录                 |
# | `RUNTIME_OUTPUT_DIRECTORY`     | 可执行文件输出路径                 | 指定可执行文件输出目录             |
# | `CXX_STANDARD` / `C_STANDARD`  | 指定 C/C++ 标准                    | 如 `CXX_STANDARD 17`               |
# | `POSITION_INDEPENDENT_CODE`    | 打开 `-fPIC`（例如为 `.so`）       | `ON`                               |
# | `LINK_FLAGS`                   | 添加链接器参数                     | `-static` 或 `-Wl,--wrap=xxx`      |
# | `INTERPROCEDURAL_OPTIMIZATION` | 开启 LTO 链接时优化                | `ON`                               |
# | `SKIP_BUILD_RPATH`             | 是否跳过 RPATH                     | `ON`                               |
# | `SUFFIX`                       | 修改生成文件的后缀名               | `SUFFIX .ko`（可用于构建内核模块） |
#
# 可以随意给目标添加自己定义的属性，用于存储额外的元信息（metadata）
# 这些属性不会被 CMake 自动使用或识别，但你可以在自己的 CMake 构建脚本中通过：
#   get_target_property(VAR_NAME <target> <property_name>)
# 来读取这些属性，以实现某些构建逻辑的复用或组织。例如：
#   get_target_property(objs ${MODULE_NAME} MODULE_OBJS)
#
# 示例 1：设置输出文件名和目录
#   add_executable(myapp main.cpp)
#   set_target_properties(myapp PROPERTIES
#       OUTPUT_NAME "custom_name"
#       RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
#   )
# 构建后文件名变成了 bin/custom_name 而不是默认的 myapp
#
# 示例 2：为库设置输出目录
#   add_library(mylib STATIC lib.cpp)
#   set_target_properties(mylib PROPERTIES
#       ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
#   )
# 生成的 .a 会放到 build/lib 目录下。
#
# 示例 3：为内核模块设置 .ko 后缀名（不常见用法）
#   add_library(my_module MODULE my_module.c)
#   set_target_properties(my_module PROPERTIES
#       SUFFIX ".ko"
#       PREFIX ""  # 去掉 lib 前缀
#   )
# 生成 my_module.ko 而不是默认的 libmy_module.so
#
# 实战建议
#   想控制生成路径 → *_OUTPUT_DIRECTORY 系列
#   想控制文件名或后缀 → OUTPUT_NAME, SUFFIX, PREFIX
#   控制是否使用 -fPIC → POSITION_INDEPENDENT_CODE
#   控制编译标准 → CXX_STANDARD, C_STANDARD

MESSAGE(STATUS "-------- EXEC CUSTOM CMD END --------")
