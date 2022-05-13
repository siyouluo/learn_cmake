# cmake语法关键字--大/小写无关，一般用小写的cmake_minimum_required
# cmake的最低版本号，注意VERSION需要大写
cmake_minimum_required(VERSION 3.18)

# 设置一个工程名字
project(Demo8 
    VERSION 0.1.0 # 语义化版本 https://semver.org/lang/zh-CN/
    DESCRIPTION "demo project" # CMake>=3.9才可以使用DESCRIPTION
    LANGUAGES CXX
)
# 查看程序版本是否设置正确
message(STATUS "${PROJECT_NAME}_VERSION=${${PROJECT_NAME}_VERSION}")
message(STATUS "${PROJECT_NAME}_VERSION_MAJOR=${${PROJECT_NAME}_VERSION_MAJOR}")
message(STATUS "${PROJECT_NAME}_VERSION_MINOR=${${PROJECT_NAME}_VERSION_MINOR}")
message(STATUS "${PROJECT_NAME}_VERSION_PATCH=${${PROJECT_NAME}_VERSION_PATCH}")

# install prefix
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/install)
message(STATUS "CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}")

# ================================ find packages ========================================================
# Find Packages
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")
find_package(mypower)
if(mypower_FOUND)
    message(STATUS "    mypower_INCLUDE_DIRS=${mypower_INCLUDE_DIRS}")
    message(STATUS "    mypower_LIBRARIES=${mypower_LIBRARIES}")
else()
    message(FATAL_ERROR "mypower library not found")
endif()
# ================================ demo ========================================================
# demo
add_executable(demo main.cpp)
target_link_libraries(demo ${mypower_LIBRARIES})
include_directories(${mypower_INCLUDE_DIRS})
#############
## Install ##
#############
# 指定demo.exe安装路径
install(TARGETS demo DESTINATION bin)

