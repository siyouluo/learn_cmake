# cmake语法关键字--大/小写无关，一般用小写的cmake_minimum_required
# cmake的最低版本号，注意VERSION需要大写
cmake_minimum_required(VERSION 3.18)

# 设置一个工程名字
project(Demo1 
    VERSION 0.1.0 # 语义化版本 https://semver.org/lang/zh-CN/
    DESCRIPTION "demo project" # CMake>=3.9才可以使用DESCRIPTION
    LANGUAGES CXX
)

# 目标可执行程序demo， 需要编译main.cpp
add_executable(demo main.cpp)
