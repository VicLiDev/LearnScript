# 1、采用add_definitions定义宏，对于无值宏：
#         add_definitions(-DMG_ENABLE_OPENSSL)
# 对应于C语言中的
#         #define MG_ENABLE_OPENSSL
# 而对于有值宏：
#         add_definitions(-DLIBEVENT_VERSION_NUMBER=0x02010800)
# 对应于C语言：
#         #define LIBEVENT_VERSION_NUMBER 0x02010800
#
# 2、add_compile_definitions定义宏，但是这个指令只要高版本的cmake支持，所以推荐使用第1种，比如：
#        add_compile_definitions(MG_ENABLE_OPENSSL=1)
# 对应于C语言中的
#        #define MG_ENABLE_OPENSSL 1

ADD_DEFINITIONS(-DMACRO_MAIN)


# 自定义函数
FUNCTION(my_custom_function VAR_NAME VALUE)
    set(${VAR_NAME} ${VALUE} PARENT_SCOPE)
ENDFUNCTION(my_custom_function)
