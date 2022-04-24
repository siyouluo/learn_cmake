# cmake语法关键字--大/小写无关，一般用小写的cmake_minimum_required
# cmake的最低版本号，注意VERSION需要大写
cmake_minimum_required(VERSION 3.18)

# 设置一个工程名字
project(Demo2 
    VERSION 0.1.0 # 语义化版本 https://semver.org/lang/zh-CN/
    DESCRIPTION "demo project" # CMake>=3.9才可以使用DESCRIPTION
    LANGUAGES CXX
)

# 目标可执行程序demo， 需要编译 main.cpp, my_power.cpp, my_power.h
# # method 1
# # 将所有的源文件依次列出来
add_executable(demo main.cpp my_power.cpp my_power.h)

# # method 2
# # 使用aux_source_directory将指定路径下的'cpp/cc/c'源文件全部绑定到SRC_LIST，这样编译直接用这个宏就好
# aux_source_directory(. SRC_LIST)
# message(STATUS "SRC_LIST=${SRC_LIST}") # 在配置的时候打印输出变量SRC_LIST
# add_executable(demo ${SRC_LIST})

# # method 3
# file(GLOB ALL_SOURCES "*.cpp") # 查找指定目录下的所有.cpp, 并存放到指定变量名ALL_SOURCES中
# file(GLOB ALL_INCLUDES "*.h") # 查找指定目录下的所有.cpp, 并存放到指定变量名ALL_INCLUDES中
# # 将变量 ALL_SRCS 设置为 ALL_SOURCES + ALL_INCLUDES
# set(ALL_SRCS 
#     ${ALL_SOURCES}
#     ${ALL_INCLUDES}
# )
# add_executable(demo ${ALL_SRCS})

# # method 4
# file(GLOB MY_POWER_FILES "my_power.cpp" "my_power.h") # 将my_power模块的源文件和头文件, 设置到指定变量名MY_POWER_FILES中
# # source_group(common/math FILES ${MY_POWER_FILES}) # 将my_power的源文件和头文件分组到common/math组里
# # 将变量 ALL_SRCS 设置为 main.cpp + MY_POWER_FILES
# set(ALL_SRCS 
#     main.cpp
#     ${MY_POWER_FILES}
# )
# add_executable(demo  ${ALL_SRCS})
