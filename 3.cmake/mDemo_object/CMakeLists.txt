cmake_minimum_required(VERSION 3.15)

# 关于 target 的理解，可以参考 mDemo 顶层 CMakeLists.txt 依赖关系 部分

project(object_demo C)

# OBJECT libraries
add_library(calc1 OBJECT calc1.c)
add_library(calc2 OBJECT calc2.c)

#==============================================================================

set(deps calc1 calc2)
set(obj_v merged_obj_v)
set(merged_o "${CMAKE_CURRENT_BINARY_DIR}/${obj_v}.o")
set(rsp_file "${CMAKE_CURRENT_BINARY_DIR}/${obj_v}.rsp")

# Generate rsp file with real .o paths
# $<TARGET_OBJECTS:...>指的是 OBJECT library 生成的“所有 .o 文件的完整路径列表
# 在生成阶段（generate time）展开
# 如果想查看他的值，不能直接打印，可以 生成 rsp 文件（推荐，如下） 或者 查看生成的 Makefile（进阶）
# $<JOIN:...> 的作用
#   输入：一个 列表  输出：一个 字符串
#   行为：用 delimiter 把 list 的每一项连起来
#   非常重要：JOIN 的结果 永远是字符串（不是列表）
#   连接符(delimiter)：";"
#   以下命令中有两个参数
#   一个是list：$<TARGET_OBJECTS:calc1>;$<TARGET_OBJECTS:calc2>
#   另一个是：\n
#   他们用 "," 分隔
file(GENERATE OUTPUT "${rsp_file}"
    CONTENT "$<JOIN:$<TARGET_OBJECTS:calc1>;$<TARGET_OBJECTS:calc2>,\n>"
)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# # merged_o 不能作为一个target 去检查 depends 是否有更新
# # 所以这个 curtom command 只能执行一次，只要 ${merged_o} 文件存在了，就不会再执行了
# add_custom_command(
#     OUTPUT  "${merged_o}"
#     COMMAND ${CMAKE_LINKER} -r -o "${merged_o}" "@${rsp_file}"
#     DEPENDS ${deps} "${rsp_file}"
#     COMMENT "Merging OBJECT libs into ${out_obj}.o"
# )
#
# # 创建一个虚拟的 object(object 类型的target 没有link interface)，并建立和具体文件的连接
# add_library("${obj_v}" OBJECT IMPORTED)
# set_target_properties("${obj_v}" PROPERTIES IMPORTED_OBJECTS "${merged_o}")
#
# # 保证先编译好${merged_o}，这里依赖 ${merged_o} 也是触发 custom command 的原因
# add_custom_target("${obj_v}_gen" DEPENDS "${merged_o}")
# add_dependencies("${obj_v}" "${obj_v}_gen")
# 
# add_library(mlib STATIC info.c)
# # 以下二选一就可以了，${obj_v} 是个target，${merged_o} 是文件
# # ${boj_v} 通过 set_target_properties 建立了连接
# # 所以以下只要二选一即可
# target_link_libraries(mlib ${obj_v})
# # target_sources(mlib PRIVATE "${merged_o}")

#------------------------------------------------------------------------------

# ustom_target 永远是“过期的”
#   add_custom_target() 默认 没有生成文件的规则
#   即使你写了 BYPRODUCTS，Make 仍然无法准确判断 merged.o 是否更新
#   Make 会认为 target 每次都需要 build
#   结果：mlib 的依赖 merged_obj_v 也每次触发重新链接
add_custom_target(${obj_v}
    COMMAND ${CMAKE_LINKER} -r -o "${merged_o}" "@${rsp_file}"
    DEPENDS ${deps} "${rsp_file}"
    BYPRODUCTS "${merged_o}"
)

add_library(mlib STATIC info.c)
# 这里依赖了 ${obj_v}，所以就会触发 ${obj_v} 这个 target
add_dependencies(mlib ${obj_v})
target_sources(mlib PRIVATE "${merged_o}")

#------------------------------------------------------------------------------

# add_library(mlib STATIC info.c)
# # target_sources 可以接受的文件类型
# #   源文件（最常见、最安全），C / C++ / ASM 等
# #   头文件（逻辑允许，但不参与编译）
# #   OBJECT 文件（.o / .obj）
# #   生成的文件（custom_command / file(GENERATE)）
# #   生成器表达式（结果必须是“文件”）
# #   不能是target
# target_sources(mlib PRIVATE
#     $<TARGET_OBJECTS:calc1>
#     $<TARGET_OBJECTS:calc2>
# )

#==============================================================================


# 创建可执行文件
add_executable(app main.c)
target_link_libraries(app PRIVATE mlib)
