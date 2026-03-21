MESSAGE(STATUS "-------- FILE OPT --------")
# ----------------------------------------------------------------------------
# GET_FILENAME_COMPONENT() —— 获取路径组成部分
# ----------------------------------------------------------------------------
# GET_FILENAME_COMPONENT(<out_var> <path> <component> [CACHE])
# 常用 <component> 类型汇总：
# | 组件名               | 描述                            | 示例（路径：`/path/to/file.cpp`）              |
# | -------------------- | ------------------------------- | ---------------------------------------------- |
# | `NAME`               | 文件名（含扩展名）              | `file.cpp`                                     |
# | `NAME_WE`            | 文件名（不含扩展名）            | `file`                                         |
# | `EXT`                | 文件扩展名（带点 `.cpp`）       | `.cpp`                                         |
# | `DIRECTORY` / `PATH` | 文件所在目录                    | `/path/to`                                     |
# | `ABSOLUTE`           | 转换为绝对路径（不解析符号链接）| `/path/to/file.cpp`                            |
# | `REALPATH`           | 解析符号链接后得到的绝对路径    | `/actual/path/to/file.cpp`                     |
# | `PROGRAM`            | 查找可执行文件路径              | `get_filename_component(mygcc gcc PROGRAM)`    |
# | `CACHE`              | 把结果写入 CMake 缓存           | `GET_FILENAME_COMPONENT(x foo.txt NAME CACHE)` |
#
#
# ----------------------------------------------------------------------------
# FILE() —— 文件和路径操作函数集
# ----------------------------------------------------------------------------
# FILE(<operation> [args...])
# 常用操作分类如下：
# 1. 文件内容相关
#   | 操作名         | 描述                         | 备注                                   |
#   | -------------- | ---------------------------- | -------------------------------------- |
#   | `READ`         | 读取文件内容到变量           | `file(READ filename var)`              |
#   | `WRITE`        | 覆盖写入文件内容             | `file(WRITE filename "content")`       |
#   | `APPEND`       | 追加内容到文件末尾           | `file(APPEND filename "more content")` |
#   | `READ_SYMLINK` | 获取符号链接目标路径         | 返回链接指向的实际路径                 |
#   | `STRINGS`      | 从文件中读取文本行到列表变量 | 可指定正则过滤匹配行                   |
#
# 2. 路径 / 文件系统操作
#   | 操作名           | 描述                                              | 备注                                            |
#   | ---------------- | ------------------------------------------------- | ----------------------------------------------- |
#   | `GLOB`           | 匹配当前目录的文件（不递归）                      | `file(GLOB var "*.c")`                          |
#   | `GLOB_RECURSE`   | 递归匹配子目录文件                                | `file(GLOB_RECURSE var "*.cpp")`                |
#   | `MAKE_DIRECTORY` | 创建目录                                          | 可创建多级目录                                  |
#   | `REMOVE`         | 删除文件                                          | `file(REMOVE file1 file2)`                      |
#   | `REMOVE_RECURSE` | 删除文件或目录（递归）                            | 注意：危险操作                                  |
#   | `RENAME`         | 重命名或移动文件                                  | `file(RENAME old new)`                          |
#   | `COPY`           | 复制文件或目录                                    | 可使用 `DIRECTORY` 或 `FILES` 参数              |
#   | `INSTALL`        | 安装文件到目标目录（更常用于 `install()` 函数中） | 配合 `DESTINATION` 使用                         |
#   | `CREATE_LINK`    | 创建符号链接                                      | `file(CREATE_LINK target link_name [SYMBOLIC])` |
#   | `TOUCH`          | 更新文件的时间戳或创建空文件                      | 类似 Unix `touch`                               |
#
# 3. 路径检查和比较
#   | 操作名           | 描述                    | 备注                                     |
#   | ---------------- | ----------------------- | ---------------------------------------- |
#   | `TO_CMAKE_PATH`  | 转换路径为统一 `/` 格式 | 跨平台统一路径分隔符                     |
#   | `TO_NATIVE_PATH` | 转换路径为平台本地格式  | Windows 用 `\`，Linux/macOS 用 `/`       |
#   | `RELATIVE_PATH`  | 计算相对路径            | `file(RELATIVE_PATH result base target)` |
#   | `IS_ABSOLUTE`    | 检查路径是否为绝对路径  | 返回 0/1 或字符串                        |
#   | `MAKE_DIRECTORY` | 创建目录                | 可递归创建                               |
#
# 4. 文件属性 / 信息查询
#   | 操作名                     | 描述                      | 备注                                  |
#   | -------------------------- | ------------------------- | ------------------------------------- |
#   | `WRITE_TIMESTAMP`          | 修改文件的时间戳          | `file(WRITE_TIMESTAMP file)`          |
#   | `TIMESTAMP`                | 获取文件最后修改时间      | 可输出到变量                          |
#   | `MD5` / `SHA1`             | 计算文件的 hash 值        | 安全校验或版本控制                    |
#   | `IS_DIRECTORY`             | 检查路径是否为目录        | 返回布尔                              |
#   | `IS_SYMLINK`               | 检查路径是否是符号链接    | 返回布尔                              |
#   | `GET_RUNTIME_DEPENDENCIES` | 获取可执行文件 / 库的依赖 | 主要在高级 CMake / packaging 场景使用 |
#
# 5. 高级 / generate 阶段相关
#   | 操作名              | 描述                                             | 备注                        |
#   | ------------------- | ------------------------------------------------ | --------------------------- |
#   | `GENERATE`          | 生成文件，可以使用 generator expression `$<...>` | `file(GENERATE OUTPUT ...)` |
#   | `COPY_IF_DIFFERENT` | 只有当源文件与目标不同才复制                     | 减少无谓重新构建            |

cmake_minimum_required(VERSION 3.15)
project(Demo_Get_File)

set(MY_FILE "src/main.cpp")

# 创建文件夹和测试文件（适用于 CMake 运行目录）
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src)
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${MY_FILE} "int main() { return 0; }")

# 生成绝对路径
get_filename_component(ABS_PATH ${CMAKE_CURRENT_BINARY_DIR}/${MY_FILE} ABSOLUTE)
message("ABS_PATH: ${ABS_PATH}")

# 提取文件名、无扩展名、扩展名
get_filename_component(NAME ${ABS_PATH} NAME)
get_filename_component(NAME_WE ${ABS_PATH} NAME_WE)
get_filename_component(EXT ${ABS_PATH} EXT)
get_filename_component(DIR ${ABS_PATH} DIRECTORY)

message("NAME: ${NAME}")
message("NAME_WE: ${NAME_WE}")
message("EXT: ${EXT}")
message("DIR: ${DIR}")

# GLOB 所有 .cpp 文件
file(GLOB CPP_FILES "${CMAKE_CURRENT_BINARY_DIR}/src/*.cpp")
message("Matched .cpp files: ${CPP_FILES}")

# 拷贝文件
file(COPY ${ABS_PATH} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/backup)

# 追加内容
file(APPEND ${ABS_PATH} "\n// Appended comment")

# 读取内容
file(READ ${ABS_PATH} CONTENTS)
message("Contents:\n${CONTENTS}")

# 相对路径
file(RELATIVE_PATH REL_PATH ${CMAKE_CURRENT_BINARY_DIR} ${ABS_PATH})
message("Relative path from binary dir: ${REL_PATH}")


# 创建一个目录
FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/my_directory)
FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/my_directory/file_opt.txt "write to file\n")
FILE(READ ${CMAKE_CURRENT_BINARY_DIR}/my_directory/file_opt.txt READ_MSG)
MESSAGE(STATUS "READ FROM FILE: ${READ_MSG}")
# FILE(APPEND filename "String to append")
# FILE(COPY source destination)
# FILE(RENAME source destination)
# FILE(REMOVE [file1 ...])
# FILE(REMOVE_RECURSE [dir1 ...])
# # 执行系统命令
# FILE(EXPR output variable operation)
# # 获取文件大小
# FILE(SIZE filename variable)
# # 获取文件权限
# FILE(GET_RUNTIME_DEPENDENCIES variable dependencies)
# # 遍历目录
# FILE(GLOB variable [RELATIVE path] [globbing expressions]...)
# FILE(GLOB_RECURSE variable [RELATIVE path] [globbing expressions]...)
# # 创建列表文件
# FILE(CONFIGURE OUTPUT output_file CONTENT content)

MESSAGE(STATUS "-------- FILE OPT END --------")


MESSAGE(STATUS "-------- DIRPROPERTY --------")
# GET_DIRECTORY_PROPERTY 获取的常见目录属性：
#   COMPILE_DEFINITIONS：获取当前目录下定义的编译器宏，这些宏会添加到编译命令中。
#   COMPILE_OPTIONS：获取当前目录下添加的编译器选项。
#   INCLUDE_DIRECTORIES：获取当前目录下设置的包含目录，用于头文件的搜索。
#   LINK_DIRECTORIES：获取当前目录下设置的链接目录，用于库文件的搜索。
#   DEFINITIONS：获取当前目录下定义的宏，包括编译器和链接器宏。
#   LINK_LIBRARIES：获取当前目录下链接的库列表。
#   DEFINED_VARIABLES：获取当前目录下定义的 CMake 变量列表。
#   ADDITIONAL_MAKE_CLEAN_FILES：获取当前目录下指定的额外清理文件。
#   SOURCE_FILES：获取当前目录下的源文件列表。
#   HEADER_FILES：获取当前目录下的头文件列表。
#   BINARY_DIR：获取当前目录的构建目录（通常是 CMakeFiles 目录）。
#   DIRECTORY：获取当前目录的路径。
#   CMAKE_INCLUDE_CURRENT_DIR：检查是否为当前目录设置了 INCLUDE_DIRECTORIES。
#   CMAKE_MSVCIDE_RUN_PATH：获取 MSVC IDE 使用的运行路径。
#
# 属性来源分类（通用）
# | 来源方式                      | 说明                                                  | 是否作用于 `COMPILE_DEFINITIONS`  |
# | ----------------------------- | ----------------------------------------------------- | --------------------------------- |
# | `add_definitions(-D...)`      | 设置目录级宏（影响 `COMPILE_DEFINITIONS`）            | ✅                                |
# | `set_directory_properties()`  | 显式设置目录属性                                      | ✅                                |
# | `set_property(DIRECTORY ...)` | 设置某目录的属性                                      | ✅                                |
# | `add_compile_options(...)`    | 设置编译器选项（影响 `COMPILE_OPTIONS`）              | ❌（不影响 `COMPILE_DEFINITIONS`）|
# | `target_*()` 系列命令         | 设置 target 的属性，如 `target_compile_definitions()` | ❌（作用于目标，不影响目录）      |
# | `CMAKE_*` 变量                | 全局变量，如 `CMAKE_C_FLAGS` 等                       | ❌（间接作用）                    |
#
# 属性继承行为（是否被子目录继承）
# 继承行为是属性特性决定的，不是所有属性都自动继承。
# | 属性名                              | 子目录是否继承 | 说明                                |
# | ----------------------------------- | -------------- | ----------------------------------- |
# | `COMPILE_DEFINITIONS`               | ✅             | 可通过 `add_definitions()` 传递     |
# | `INCLUDE_DIRECTORIES`               | ✅             | 可通过 `include_directories()` 设置 |
# | `COMPILE_OPTIONS`                   | ✅             | 通过 `add_compile_options()`        |
# | `LINK_DIRECTORIES`                  | ✅             | 可影响链接库搜索路径                |
# | `POSITION_INDEPENDENT_CODE`         | ✅             | 用于控制是否启用 PIC                |
# | `CMAKE_C_FLAGS` / `CMAKE_CXX_FLAGS` | ✅             | 编译器标志（变量形式）              |
# | `CMAKE_INSTALL_PREFIX`              | ✅             | 安装路径变量，子目录可读取          |
# | `CMAKE_CURRENT_SOURCE_DIR`          | ❌             | 局部只读变量，子目录自动更新        |
# | `COMPILE_FEATURES`                  | ❌             | 只适用于 target 级                  |
#
# 如何查看属性支持哪些行为？
#   CMake 提供官方命令：
#   get_property(_props GLOBAL PROPERTY DIRECTORY_PROPERTIES)
#   message("Directory properties: ${_props}")
#   或者查阅官方文档。
#
#
# 针对COMPILE_DEFINITIONS 的来源
# 主要来源如下：
# add_definitions() 设置的宏定义
#   这条指令会向当前目录添加宏定义，实际上会设置 COMPILE_DEFINITIONS 属性。
# set_directory_properties() 显式设置
#   显式地设置这个属性，例如：
#   set_directory_properties(PROPERTIES COMPILE_DEFINITIONS "FOO;BAR")
#   或追加：
#   set_property(DIRECTORY APPEND PROPERTY COMPILE_DEFINITIONS MY_DEFINE)
#   这些会在当前目录范围（非 target）生效。
# 子目录继承父目录的属性（除非另设）
#   子目录继承的目录属性（默认会继承）
#   比如这些常用属性会自动继承：
#   属性名                          含义                 说明
#   COMPILE_DEFINITIONS             预处理宏定义         通过 add_definitions() 或 set_property(DIRECTORY ...) 设置
#   INCLUDE_DIRECTORIES             头文件路径           通常通过 include_directories() 设置
#   COMPILE_OPTIONS                 编译器选项           如 -Wall，可由 add_compile_options() 设置
#   LINK_DIRECTORIES                链接库路径           使用 link_directories() 设置
#   CMAKE_C_FLAGS, CMAKE_CXX_FLAGS  全局编译选项         会影响子目录
#   CMAKE_POSITION_INDEPENDENT_CODE 是否使用 PIC 编译    可用于构建共享库等
#   CMAKE_RUNTIME_OUTPUT_DIRECTORY  可执行文件输出目录   子目录默认继承，除非覆盖
#   -- 这些属性的继承在你调用 add_subdirectory() 时会自动生效。
#
#   子目录不会继承的内容或行为（除非显式设置）
#   类型               示例                           说明
#   Target 属性        target_compile_definitions()   target 是独立作用域，定义不会“自动传递”
#   缓存变量的本地修改 set(VAR value)（非 CACHE）     非 CACHE 变量作用域仅限当前文件
#   非继承的目录属性   有些 directory properties 不能继承，比如 INCLUDE_DIRECTORIES_BEFORE
#   局部路径设置       CMAKE_CURRENT_SOURCE_DIR 是局部的
# 某些模块或工具链文件设置的全局定义
#   有时工具链、平台配置、外部包等也可能使用 add_definitions() 或目录属性方式设置
#   一些宏定义，比如：
#   FindBoost 添加了 BOOST_ALL_DYN_LINK
#   Android/iOS 工具链设置 ABI 宏
#   IDE 插件或自定义 CMake 模块设置一些标志
ADD_DEFINITIONS(-DMY_MACRO=1)
GET_DIRECTORY_PROPERTY(CMP_DEFS COMPILE_DEFINITIONS)
MESSAGE(STATUS "CMP_DEFS: " ${CMP_DEFS})

GET_DIRECTORY_PROPERTY(M_BINARY_DIR BINARY_DIR)
MESSAGE(STATUS "M_BINARY_DIR: " ${M_BINARY_DIR})
MESSAGE(STATUS "-------- DIRPROPERTY END --------")


MESSAGE(STATUS "-------- GET_PROPERTY --------")

# get_property() 是 CMake 中非常强大、灵活的命令，用于获取某个作用域内的
# 属性（property）值，帮助查询 CMake 的元信息，例如变量、目标、目录、缓存、
# 全局等各种实体的状态。
#
# 基本语法
# get_property(<result_var>
#              [GLOBAL | DIRECTORY [dir] | TARGET tgt | SOURCE src | INSTALL | TEST tst | CACHE entry]
#              PROPERTY <name>
#              [SET])
#
# 参数详解
# | 参数              | 说明                                                   |
# | ----------------- | ------------------------------------------------------ |
# | `<result_var>`    | 存放结果的变量名                                       |
# | `GLOBAL`          | 获取全局属性                                           |
# | `DIRECTORY [dir]` | 获取指定目录的属性（默认为当前）                       |
# | `TARGET tgt`      | 获取目标（如 add_library/add_executable）属性          |
# | `SOURCE src`      | 获取源文件属性                                         |
# | `TEST tst`        | 获取测试用例属性（add\_test）                          |
# | `CACHE entry`     | 获取缓存变量的属性                                     |
# | `PROPERTY <name>` | 指定要获取的属性名称，（可自定义）                     |
# | `SET`（可选）     | 若属性已设置，`<result_var>` 为 `TRUE`，否则为 `FALSE` |
#
#
# CMake 中的 PROPERTY 是用来描述目标、变量、目录、文件等元素的元数据。不同作用域
# 下可用的 property 是不同的，常用的有 以下几大类：
# 一、目标（Target）属性
#   用于 `add_library()` / `add_executable()` 创建的目标。
#   🔧 常用目标属性（部分）：
#   | 属性名                          | 说明                                                        |
#   | ------------------------------- | ----------------------------------------------------------- |
#   | `TYPE`                          | 目标类型，如 STATIC\_LIBRARY、EXECUTABLE                    |
#   | `OUTPUT_NAME`                   | 目标输出文件名（无扩展名）                                  |
#   | `PREFIX`, `SUFFIX`              | 修改输出文件的前缀/后缀                                     |
#   | `SOURCES`                       | 源文件列表（只读）                                          |
#   | `INCLUDE_DIRECTORIES`           | 头文件搜索路径（旧方式）                                    |
#   | `INTERFACE_INCLUDE_DIRECTORIES` | 公开头文件路径（用于 `target_link_libraries` 的 consumers） |
#   | `COMPILE_DEFINITIONS`           | 编译宏（旧方式）                                            |
#   | `INTERFACE_COMPILE_DEFINITIONS` | 公开编译宏（用于接口库）                                    |
#   | `COMPILE_OPTIONS`               | 编译选项                                                    |
#   | `LINK_LIBRARIES`                | 链接的库（不推荐直接使用）                                  |
#   | `INTERFACE_LINK_LIBRARIES`      | 对消费者可见的链接库                                        |
#   | `LOCATION`                      | 构建产物路径（已弃用，危险），建议用 TARGET_FILE 代替       |
#   | `IMPORTED_LOCATION`             | 引入的 IMPORTED target 的文件路径                           |
#   | `ALIASED_TARGET`                | 如果是 `add_library(alias ALIAS ...)`，会返回原始目标名     |
#   | `FOLDER`                        | 目标所在的 IDE 文件夹（如 VS 结构）                         |
#   | `ARCHIVE_OUTPUT_DIRECTORY`      | 静态库输出目录                                              |
#   | `LIBRARY_OUTPUT_DIRECTORY`      | 共享库输出目录                                              |
#   | `RUNTIME_OUTPUT_DIRECTORY`      | 可执行文件输出目录                                          |
#
# 二、目录（Directory）属性
#   使用 `GET_DIRECTORY_PROPERTY()` 或 `set_directory_properties()` 访问。
#   | 属性名                | 说明                                |
#   | --------------------- | ----------------------------------- |
#   | `COMPILE_DEFINITIONS` | 当前目录设置的编译宏（旧方式）      |
#   | `INCLUDE_DIRECTORIES` | 当前目录设置的包含路径              |
#   | `LINK_DIRECTORIES`    | 链接库搜索路径                      |
#   | `COMPILE_OPTIONS`     | 编译选项                            |
#   | `DEFINITIONS`         | `add_definitions()` 添加的宏        |
#   | `VARIABLES`           | 当前目录中定义的所有变量（仅可读）  |
#
# 三、源文件（Source File）属性
#   可通过 `set_source_files_properties()` 设置，用于细粒度控制。
#   | 属性名                    | 说明                     |
#   | ------------------------- | ------------------------ |
#   | `COMPILE_FLAGS`           | 单独源文件的编译选项     |
#   | `COMPILE_DEFINITIONS`     | 单独源文件的编译宏       |
#   | `LANGUAGE`                | 显式指定语言，如 CXX     |
#   | `OBJECT_OUTPUTS`          | 源文件生成的目标文件路径 |
#   | `SKIP_PRECOMPILE_HEADERS` | 跳过 PCH                 |
# 四、缓存变量属性（Cache Entry）
#   使用 `get_property(... CACHE ...)`。
#   | 属性名       | 说明                                     |
#   | ------------ | ---------------------------------------- |
#   | `HELPSTRING` | `CACHE` 变量的帮助描述                   |
#   | `TYPE`       | 类型（BOOL、FILEPATH、STRING、INTERNAL） |
#   | `ADVANCED`   | 是否为高级变量                           |
#   | `MODIFIED`   | 变量是否被修改过                         |
#   | `STRINGS`    | 候选值列表（用于 GUI 下拉框）            |
#
# 五、全局（Global）属性
#   使用 `get_property(... GLOBAL ...)`。
#   | 属性名              | 说明                           |
#   | ------------------- | ------------------------------ |
#   | `USE_FOLDERS`       | VS/Xcode 是否使用虚拟目录      |
#   | `TARGETS`           | 当前所有目标的列表             |
#   | `ENABLED_LANGUAGES` | 启用的语言（C、CXX 等）        |
#   | `COMMANDS`          | 所有命令名列表                 |
#   | `VARIABLES`         | 所有变量名列表                 |
#   | `MACROS`            | 所有宏命令名                   |
#   | `IN_TRY_COMPILE`    | 当前是否在 try\_compile 测试中 |
# 六、测试（Test）属性
#   用于 `add_test()` 添加的测试。
#   | 属性名              | 说明               |
#   | ------------------- | ------------------ |
#   | `COMMAND`           | 测试执行命令       |
#   | `WORKING_DIRECTORY` | 测试工作目录       |
#   | `ENVIRONMENT`       | 环境变量设置       |
#   | `TIMEOUT`           | 测试超时时间（秒） |
# 七、安装（Install）相关属性
#   用于控制安装路径、组件等：
#   | 属性名             | 说明             |
#   | ------------------ | ---------------- |
#   | `EXPORT_NAME`      | 安装时导出的名字 |
#   | `DESTINATION`      | 安装路径         |
#   | `COMPONENT`        | 安装所属组件     |
#   | `EXCLUDE_FROM_ALL` | 是否默认安装     |
# 八、导入（IMPORTED）目标属性
#   用于 `add_library(... IMPORTED)` 的目标：
#   | 属性名                              | 说明                            |
#   | ----------------------------------- | ------------------------------- |
#   | `IMPORTED_LOCATION`                 | 文件路径                        |
#   | `IMPORTED_CONFIGURATIONS`           | 可用的构建配置（DEBUG/RELEASE） |
#   | `IMPORTED_LINK_INTERFACE_LIBRARIES` | 链接库                          |
# 怎么查看全部属性？可以通过以下方式获取所有属性：
#   cmake --help-property-list
# 或者单独查看某个属性说明：
#   cmake --help-property <PROPERTY_NAME>
# 例如：
#   cmake --help-property LOCATION
#   cmake --help-property INTERFACE_INCLUDE_DIRECTORIES
#
#
# 示例
# 1. 获取目标属性（TARGET）
#   get_property(result TARGET mylib PROPERTY LINK_LIBRARIES)
#   message("Libraries that mylib depends on: ${result}")
# 2. 获取当前目录的属性（DIRECTORY）
#   get_property(defs DIRECTORY PROPERTY COMPILE_DEFINITIONS)
#   message("Compile macros for the current directory: ${defs}")
# 3. 获取缓存项属性（CACHE）
#   get_property(helptext CACHE CMAKE_INSTALL_PREFIX PROPERTY HELPSTRING)
#   message("Help information for CMAKE_INSTALL_PREFIX: ${helptext}")
# 4. 获取源文件属性（SOURCE）
#   get_property(lang SOURCE src/foo.cpp PROPERTY LANGUAGE)
#   message("The language of foo.cpp is: ${lang}")
# 5. 判断属性是否设置（SET）
#   get_property(hasDefs DIRECTORY PROPERTY COMPILE_DEFINITIONS SET)
#   if(hasDefs)
#     message("This directory has compiled macros defined")
#   else()
#     message("This directory does not define compile macros ")
#   endif()
# 6. 获取全局属性（GLOBAL）
#   set_property(GLOBAL PROPERTY USE_FOLDERS ON)
#   get_property(val GLOBAL PROPERTY USE_FOLDERS)
#   message("global USE_FOLDERS set as: ${val}")
# 搭配 set_property 和 define_property
# get_property 是和 set_property() 配对使用的，另外也可以用 define_property() 自定义属性。
#   set_property(TARGET mylib PROPERTY FOO "bar")
#   get_property(val TARGET mylib PROPERTY FOO)
#   message("FOO property is: ${val}")
#
# 常见误区
#   get_property(... VARIABLE ...) ❌
#     不支持普通变量！只能获取“属性”
#   get_property(... PROPERTY LOCATION) ❌
#     LOCATION 是只读/废弃属性，建议用 TARGET_FILE 代替
#
# 和 get_target_property() 的区别
# get_property()
#   通用，支持多种对象（TARGET、DIRECTORY、SOURCE 等）
# get_target_property()
#   专门获取目标属性（语法更简单）
# 等价写法：
#   get_target_property(foo_link mylib LINK_LIBRARIES)
#   get_property(foo_link TARGET mylib PROPERTY LINK_LIBRARIES)
#
#
# DEMO 示例：获取每个子目录的编译宏
#
# 根目录 CMakeLists.txt
# project(demo)
# add_subdirectory(lib)
# add_subdirectory(app)
#
# lib/CMakeLists.txt
# add_library(lib STATIC lib.cpp)
# add_definitions(-DLIB_MODE)
# get_property(defs DIRECTORY PROPERTY COMPILE_DEFINITIONS)
# message("lib Compile Macros: ${defs}")
#
# app/CMakeLists.txt
# add_executable(app main.cpp)
# add_definitions(-DAPP_MODE)
# get_property(defs DIRECTORY PROPERTY COMPILE_DEFINITIONS)
# message("app Compile Macros: ${defs}")

# 自定义属性：给某个目标设置一个自定义属性
set_property(GLOBAL PROPERTY MY_CUSTOM_PROPERTY "Hello, CMake")
# 获取这个自定义属性
get_property(my_value GLOBAL PROPERTY MY_CUSTOM_PROPERTY)
# 打印出来
message(STATUS "My custom property is: ${my_value}")


MESSAGE(STATUS "-------- GET_PROPERTY END --------")
