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
find_package(MyMath)
if(MyMath_FOUND)
    message(STATUS "    MyMath_INCLUDE_DIRS=${MyMath_INCLUDE_DIRS}")
    message(STATUS "    MyMath_LIBRARIES=${MyMath_LIBRARIES}")
else()
    message(FATAL_ERROR "MyMath library not found")
endif()

# ================================ use packages ========================================================
## mypower
add_executable(test_mypower "${PROJECT_SOURCE_DIR}/samples/mypower/test_mypower.cpp")
target_link_libraries(test_mypower ${MyMath_LIBRARIES})
target_include_directories(test_mypower PRIVATE ${MyMath_INCLUDE_DIRS})
install(TARGETS test_mypower DESTINATION bin)
## myplus
add_executable(test_myplus "${PROJECT_SOURCE_DIR}/samples/myplus/test_myplus.cpp")
target_link_libraries(test_myplus ${MyMath_LIBRARIES})
target_include_directories(test_myplus PRIVATE ${MyMath_INCLUDE_DIRS})
install(TARGETS test_myplus DESTINATION bin)
