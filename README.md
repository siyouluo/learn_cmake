<!-- TOC -->

- [CMake学习笔记](#cmake学习笔记)
- [安装](#安装)
- [我的示例](#我的示例)
    - [通用编译流程](#通用编译流程)
    - [Demo1](#demo1)
    - [Demo2](#demo2)
        - [手动列出所有文件](#手动列出所有文件)
        - [自动列出目录下所有源文件](#自动列出目录下所有源文件)
        - [使用通配符设置文件列表](#使用通配符设置文件列表)
        - [文件模块化管理](#文件模块化管理)
    - [Demo3](#demo3)
- [参考](#参考)

<!-- /TOC -->
# CMake学习笔记
为了写出更加专业规范的工程项目，有必要学习一下CMake工具。这里主要参考`Modern CMake`,一般指CMake 3.4+ ，甚至是 CMake 3.21+.

本项目主要基于Windows平台进行讲解，并通过VS 2017来进行编译.

**环境:**  
- Windows 10
- Visual Studio Community 2017
- CMake 3.18.5

# 安装
- [Install cmake - Download binary](https://cmake.org/download/)

|预定义变量                   |含义                             |
|:---                       |:---                            |
|CMAKE_MAJOR_VERSION	    |cmake 主版本号                   |
|CMAKE_MINOR_VERSION        |cmake 次版本号                   |
|CMAKE_C_FLAGS	            |设置 C 编译选项                   |
|CMAKE_CXX_FLAGS            |设置 C++ 编译选项                 |
|PROJECT_SOURCE_DIR         |工程的根目录                      |
|PROJECT_BINARY_DIR         |运行 cmake 命令的目录              |
|CMAKE_CURRENT_SOURCE_DIR   |当前CMakeLists.txt 所在路径       |
|CMAKE_CURRENT_BINARY_DIR   |目标文件编译目录                   |
|EXECUTABLE_OUTPUT_PATH     |重新定义目标二进制可执行文件的存放位置 |
|LIBRARY_OUTPUT_PATH        |重新定义目标链接库文件的存放位置      |
|CMAKE_ROOT	                |cmake安装目录                     |


# 我的示例

## 通用编译流程
1. Configure & Generate
    ```ps
    > mkdir build
    > cd build
    > cmake ..
    ```

2. 在build目录下找到`${PROJECT_NAME}.sln`，双击打开，点击`生成解决方案`
3. 进入生成的`*.exe`文件目录下，执行
    ```ps
    > .\demo.exe 2 3
    2 ^ 3 is 8
    ```
4. 如果要删除编译生成的build文件夹，可在powershell执行: `Remove-Item -Path build -Recurse`

## Demo1
本项目仅包含一个`main.cpp`和一个`CMakeLists.txt`.  
其中`main.cpp`的功能是读入两个浮点数`a,b`，计算`a^b`并在终端输出.  
本项目中演示`CMakeLists.txt`的最基础版本，如下.  
```cmake
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

```

## Demo2
本项目包含三个代码文件`main.cpp my_power.cpp my_power.h`和一个`CMakeLists.txt`.   
相比于`Demo1`，这里需要修改的只有`add_executable`中添加源文件的方式，共有如下几种，选择任意一种即可.
### 手动列出所有文件
只需在编译目标后面列出所需的全部源文件和头文件即可.  
```cmake
add_executable(demo main.cpp my_power.cpp my_power.h)
```
请注意，这里添加头文件不是必须的，但是在用cmake配合IDE使用(例如通过cmake配置并生成visual studio解决方案)时，添加头文件列表可以显式地把自己的头文件放到一个`Header Files`分组内，如下是VS的`解决方案资源管理器`中显示的样子。如果`add_executable`没有添加头文件，那么用户自己的头文件`my_power.h`就会被放在`外部依赖项`里面。
```tree
解决方案'Demo2'(3个项目)
- ALL_BUILD
- demo
    - 引用
    - 外部依赖项
        - iostream
        - stdio.h
        - stdlib.h
        ...
    - Header Files
        - my_power.h
    - Source Files
        - main.cpp
        - my_power.cpp
    - CMakeLists.txt
- ZERO_CHECK
```

### 自动列出目录下所有源文件
使用`aux_source_directory(<dir> <variable>)`将指定路径下的'cpp/cc/c'源文件全部绑定到SRC_LIST，然后在添加目标时使用该变量.
```cmake
aux_source_directory(. SRC_LIST)
message(STATUS "SRC_LIST=${SRC_LIST}") # 在配置的时候打印输出变量SRC_LIST
add_executable(demo ${SRC_LIST})
```
注意这样不会添加头文件,配置时终端输出如下,其中SRC_LIST只有源文件，没有头文件.
```ps
build> cmake ..
-- Selecting Windows SDK version 10.0.17763.0 to target Windows 10.0.19044.
-- SRC_LIST=./main.cpp;./my_power.cpp
-- Configuring done
-- Generating done
```

### 使用通配符设置文件列表
通过`file(GLOB VAR "*.cpp")`来将所有`cpp`文件放到变量`VAR`中，然后在添加目标时使用该变量.
```cmake
file(GLOB ALL_SOURCES "*.cpp") # 查找指定目录下的所有.cpp, 并存放到指定变量名ALL_SOURCES中
file(GLOB ALL_INCLUDES "*.h") # 查找指定目录下的所有.cpp, 并存放到指定变量名ALL_INCLUDES中
# 将变量 ALL_SRCS 设置为 ALL_SOURCES + ALL_INCLUDES
set(ALL_SRCS 
    ${ALL_SOURCES}
    ${ALL_INCLUDES}
)
add_executable(demo ${ALL_SRCS})
```
在一条`file()`语句中可以添加多个匹配项，中间用空格隔开即可, 如: `file(GLOB VAR "*.cpp" "*.cc" "*.h" "./FOLDER/*.cpp")`

匹配方法：  
- `file(GLOB SRC_LIST "*.cpp")`只匹配当前路径下的所有cpp文件
- `file(GLOB_RECURSE SRC_LIST "*.cpp")`递归搜索所有路径下的所有cpp文件
- `file(GLOB SRC_COMMON_LIST RELATIVE "common" "*.cpp")`在common目录下搜索cpp文件

在[Modern CMake 行为准则](https://modern-cmake-cn.github.io/Modern-CMake-zh_CN/chapters/intro/dodonot.html)中提到应该避免使用这种方法，因为在执行`cmake ..`之后如果新添加了源文件，该文件不会被编译系统感知到，也就不会被编译，除非重新再执行一次`cmake ..`(虽然我觉得这不是件什么大不了的事).

### 文件模块化管理
一个良好的工程项目必然包含多个不同功能模块，同样在cmake中也可以将其按照功能的不同进行分组管理。
```cmake
file(GLOB MY_POWER_FILES "my_power.cpp" "my_power.h") # 将my_power模块的源文件和头文件, 设置到指定变量名MY_POWER_FILES中
# source_group(common/math FILES ${MY_POWER_FILES}) # 将my_power的源文件和头文件分组到common/math组里
# 将变量 ALL_SRCS 设置为 main.cpp + MY_POWER_FILES
set(ALL_SRCS 
    main.cpp
    ${MY_POWER_FILES}
)
add_executable(demo  ${ALL_SRCS})

```

如果希望在`解决方案资源管理器`也对文件按模块分组，那么可以添加`source_group`指令: `source_group(common/math FILES ${MY_POWER_FILES})`, 效果如下: 
```tree
解决方案'Demo2'(3个项目)
- ALL_BUILD
- demo
    - 引用
    - 外部依赖项
    - common
        - math
            - my_power.cpp
            - my_power.h
    - Source Files
        - main.cpp
    - CMakeLists.txt
- ZERO_CHECK
```
注意： 在添加source_group函数并重新执行`cmake ..`后，VS不会提示重新加载解决方案，需要关闭VS重新打开项目.

- [[CMake笔记] CMake向解决方案添加源文件兼头文件](https://www.cnblogs.com/dilex/p/11102152.html)
- [CMAKE（3）—— aux_source_directory包含目录下所有文件以及自动构建系统](https://blog.csdn.net/u012564117/article/details/95085360)
- [CMake » Documentation » cmake-commands(7) » aux_source_directory](https://cmake.org/cmake/help/v3.18/command/aux_source_directory.html)
- [初识CMake，如何编写一个CMake工程（上）](https://blog.csdn.net/weixin_39956356/article/details/115253373)
- [CMakeLists.txt 语法介绍与实例演练](https://blog.csdn.net/afei__/article/details/81201039)

## Demo3
本项目演示如何管理多个目录下的文件,文件结构如下:

```tree
Demo3
|   CMakeLists.txt
|   main.cpp
\---math
        CMakeLists.txt
        my_power.cpp
        my_power.h
        
```

事实上，如果仅仅是简单的将文件分目录存放，那么`Demo2`中的方法也够用了.  
本项目在子目录`math/`下也新建了一个`CMakeLists.txt`用来管理子目录下的文件，然后在上层目录下的`CMakeLists.txt`里面调用它. 注意：子路径下`CMakeLists.txt`中的变量名在上层`CMakeLists.txt`里面不再有效。

两个文件分别如下所示:
```cmake
# math/CMakeLists.txt
file(GLOB MY_POWER_FILES "my_power.cpp" "my_power.h") # 将my_power模块的源文件和头文件, 设置到指定变量名MY_POWER_FILES中
add_library(my_power ${MY_POWER_FILES}) # 将本目录下的文件编译成静态库

```

```cmake
# CMakeLists.txt
...

# 编译其他目录下的文件，如math
add_subdirectory(math)
# 编译当前目录下的文件
add_executable(demo main.cpp)
# 把其他目录下的静态、动态库链接进来
target_link_libraries(demo my_power)

```

注意子目录下的`CMakeLists.txt`不需要也不可以指定cmake的版本要求和工程名.  
子目录下的`CMakeLists.txt`将`my_power.cpp/.h`编译成静态链接库，然后再将其链接到目标`demo`上.由于是静态库，最后编译得到的目标`demo.exe`是可以单独运行的.

生成的VS解决方案资源管理器如下:  
```tree
解决方案'Demo3'(4个项目)
- ALL_BUILD
- demo
    - 引用
    - 外部依赖项
        - iostream
        - stdio.h
        - stdlib.h
        - my_power.h
        ...
    - Source Files
        - main.cpp
    - CMakeLists.txt
- my_power
    - 引用
    - 外部依赖项
    - Header Files
        - my_power.h
    - Source Files
        - my_power.cpp
    - CMakeLists.txt
- ZERO_CHECK
```

点击`生成解决方案`后得到如下编译输出:  
```tree
build
+---Debug
|       demo.exe
|       demo.ilk
|       demo.pdb
+---math
    \---Debug
            my_power.lib
            my_power.pdb
```



# 参考
- [Modern CMake 简体中文版](https://modern-cmake-cn.github.io/Modern-CMake-zh_CN/)
- [An Introduction to Modern CMake](https://cliutils.gitlab.io/modern-cmake/)
- [ CMake 3.18 Documentation  CMake Tutorial](https://cmake.org/cmake/help/v3.18/guide/tutorial/index.html)
- [CMake 入门实战](https://www.hahack.com/codes/cmake/)
- [ve2102388688/myCmakeDemos - Github](https://github.com/ve2102388688/myCmakeDemos)