# cmake语法关键字--大/小写无关，一般用小写的cmake_minimum_required
# cmake的最低版本号，注意VERSION需要大写
cmake_minimum_required(VERSION 3.18)

# 设置一个工程名字
project(Demo4 
    VERSION 0.1.0 # 语义化版本 https://semver.org/lang/zh-CN/
    DESCRIPTION "demo project" # CMake>=3.9才可以使用DESCRIPTION
    LANGUAGES CXX
)

######################### 写一个宏名USE_MYMATH来启用使用my_power
# 设置编译宏名USE_MYMATH，注解，默认值ON
# 如果设置OFF，在config.h.in不管怎么改，都不会调用
option(USE_MYMATH "use provided math implementation" ON)
message(STATUS "USE_MYMATH is ${USE_MYMATH}")

# 加入一个配置头文件config.h.in，用于编译选项的设置，注意这个文件必须用户提前建立，否则编译错误--找不到该文件
configure_file(
    "${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
)
include_directories("${PROJECT_BINARY_DIR}")
# 是否加入math目录下的模块
if (USE_MYMATH)
    # include_directories("${PROJECT_SOURCE_DIR}/math")
    add_subdirectory(math)  # 编译其他文件夹的源代码
    set(EXTRA_LIBS ${EXTRA_LIBS} my_power)
endif(USE_MYMATH)

# 编译当前目录下的文件
add_executable(demo main.cpp)
# 把其他目录下的静态、动态库链接进来
target_link_libraries(demo ${EXTRA_LIBS})
