# cmake语法关键字--大/小写无关，一般用小写的cmake_minimum_required
# cmake的最低版本号，注意VERSION需要大写
cmake_minimum_required(VERSION 3.18)

# 设置一个工程名字
project(MyMath 
    VERSION 0.1.0 # 语义化版本 https://semver.org/lang/zh-CN/
    DESCRIPTION "my math project" # CMake>=3.9才可以使用DESCRIPTION
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

#################################################################################
## mypower
message(STATUS "\n############## mypowe ###################r")
set(mypower_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/mymath/mypower")
file(GLOB mypower_SRCS "${PROJECT_SOURCE_DIR}/mymath/mypower/*")
message(STATUS "mypower_SRCS=${mypower_SRCS}") # 在配置的时候打印输出变量mypower_SRCS
add_library(mypower STATIC ${mypower_SRCS}) # 生成静态库
set(mypower_LIBS mypower)
target_include_directories(mypower
                           INTERFACE
                            $<BUILD_INTERFACE:${mypower_INCLUDE_DIRS}>
                            $<INSTALL_INTERFACE:include>
                           )

add_executable(devel_mypower "${PROJECT_SOURCE_DIR}/samples/mypower/test_mypower.cpp" ${mypower_SRCS})
target_include_directories(devel_mypower PRIVATE ${mypower_INCLUDE_DIRS})

add_executable(test_mypower "${PROJECT_SOURCE_DIR}/samples/mypower/test_mypower.cpp")
target_link_libraries(test_mypower ${mypower_LIBS})
# install & export
install(TARGETS test_mypower DESTINATION bin)
install(FILES "${PROJECT_SOURCE_DIR}/mymath/mypower/mypower.h" DESTINATION include)
install(TARGETS ${mypower_LIBS} 
        EXPORT mypowerTargets
        DESTINATION lib)
install(EXPORT mypowerTargets
        FILE mypowerTargets.cmake
        DESTINATION cmake)

export(EXPORT mypowerTargets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/mypowerTargets.cmake"
)

#################################################################################
## myplus
message(STATUS "\n############## myplus ###################")
set(myplus_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/mymath/myplus")
file(GLOB myplus_SRCS "${PROJECT_SOURCE_DIR}/mymath/myplus/*")
message(STATUS "myplus_SRCS=${myplus_SRCS}") # 在配置的时候打印输出变量myplus_SRCS
add_library(myplus STATIC ${myplus_SRCS}) # 生成静态库
set(myplus_LIBS myplus)
target_include_directories(myplus
                           INTERFACE
                            $<BUILD_INTERFACE:${myplus_INCLUDE_DIRS}>
                            $<INSTALL_INTERFACE:include>
                           )

add_executable(devel_myplus "${PROJECT_SOURCE_DIR}/samples/myplus/test_myplus.cpp" ${myplus_SRCS})
target_include_directories(devel_myplus PRIVATE ${myplus_INCLUDE_DIRS})

add_executable(test_myplus "${PROJECT_SOURCE_DIR}/samples/myplus/test_myplus.cpp")
target_link_libraries(test_myplus ${myplus_LIBS})
# install & export
install(TARGETS test_myplus DESTINATION bin)
install(FILES "${PROJECT_SOURCE_DIR}/mymath/myplus/myplus.h" DESTINATION include)
install(TARGETS ${myplus_LIBS} 
        EXPORT myplusTargets
        DESTINATION lib)
install(EXPORT myplusTargets
        FILE myplusTargets.cmake
        DESTINATION cmake)

export(EXPORT myplusTargets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/myplusTargets.cmake"
)

############################################################################################
## Export Configuration
include(CMakePackageConfigHelpers)
# generate the config file that is includes the exports
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/MyMathConfig.cmake"
  INSTALL_DESTINATION "cmake"
  NO_SET_AND_CHECK_MACRO
  NO_CHECK_REQUIRED_COMPONENTS_MACRO)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/MyMathConfigVersion.cmake"
    VERSION "${${PROJECT_NAME}_VERSION}"
    COMPATIBILITY SameMajorVersion)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/MyMathConfig.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/MyMathConfigVersion.cmake
  DESTINATION cmake)

