# cmake语法关键字--大/小写无关，一般用小写的cmake_minimum_required
# cmake的最低版本号，注意VERSION需要大写
cmake_minimum_required(VERSION 3.18)

# 设置一个工程名字
project(Demo5 
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


#############
## Install ##
#############
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/install)
message(STATUS "CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}")

# 指定demo.exe安装路径
install(TARGETS demo DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/config.h"
         DESTINATION include)



#############
## Testing ##
#############
# 启用测试
enable_testing()

# 测试程序是否成功运行
add_test (test_run demo 5 2)

# 测试帮助信息是否可以正常提示
add_test (test_usage demo)
set_tests_properties (test_usage
  PROPERTIES PASS_REGULAR_EXPRESSION "Usage: .* base exponent")

# 测试 5 的平方
add_test (test_5_2 demo 5 2)
set_tests_properties (test_5_2
 PROPERTIES PASS_REGULAR_EXPRESSION "is 25")

# 测试 10 的 5 次方
add_test (test_10_5 demo 10 5)
set_tests_properties (test_10_5
 PROPERTIES PASS_REGULAR_EXPRESSION "is 100000")

# 测试 2 的 10 次方
add_test (test_2_10 demo 2 10)
set_tests_properties (test_2_10
 PROPERTIES PASS_REGULAR_EXPRESSION "is 1024")

# 定义一个宏，用来简化测试工作
macro (do_test arg1 arg2 result)
  add_test (test_${arg1}_${arg2} demo ${arg1} ${arg2})
  set_tests_properties (test_${arg1}_${arg2}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endmacro (do_test)
 
# 使用该宏进行一系列的数据测试
do_test (5 3 "is 125")
do_test (10 2 "is 100")
do_test (2 5 "is 32")

