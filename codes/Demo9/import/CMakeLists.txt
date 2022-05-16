# cmake语法关键字--大/小写无关，一般用小写的cmake_minimum_required
# cmake的最低版本号，注意VERSION需要大写
cmake_minimum_required(VERSION 3.18)

# 设置一个工程名字
project(ImportMyMath 
    VERSION 0.1.0 # 语义化版本 https://semver.org/lang/zh-CN/
    DESCRIPTION "import mymath library" # CMake>=3.9才可以使用DESCRIPTION
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

if (MSVC)
    # 设置 msvc 代码编码格式为 utf-8
    set(CMAKE_C_FLAGS "/source-charset:utf-8 ${CMAKE_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "/source-charset:utf-8 ${CMAKE_CXX_FLAGS}")
    message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
    message(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
endif()


########################################################################################
# Find MyMath, you may need to set MyMath_DIR variable
# to the absolute path to the directory containing MyMathConfig.cmake file
# via the command line or GUI
set(MyMath_DIR D:/Research/MachineVision/Code/learn_cmake/codes/Demo9/export/install/cmake)
find_package(MyMath)
# If the package has been found, several variables will
# be set, you can find the full list with descriptions
# in the MyMathConfig.cmake file.
# Print some message showing some of them
message(STATUS "MyMath library status:")
message(STATUS "    version: ${MyMath_VERSION}")
set(MyMath_LIBS "mypower" "myplus")
########################################################################################
## mypower
add_executable(test_mypower "${PROJECT_SOURCE_DIR}/samples/mypower/test_mypower.cpp")
target_link_libraries(test_mypower ${MyMath_LIBS})
install(TARGETS test_mypower DESTINATION bin)
########################################################################################
## myplus
add_executable(test_myplus "${PROJECT_SOURCE_DIR}/samples/myplus/test_myplus.cpp")
target_link_libraries(test_myplus ${MyMath_LIBS})
install(TARGETS test_myplus DESTINATION bin)
