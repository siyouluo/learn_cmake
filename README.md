<!-- TOC -->

- [CMake学习笔记](#cmake学习笔记)
- [安装](#安装)
- [我的示例](#我的示例)
    - [通用编译流程](#通用编译流程)
    - [Demo1 - 基本框架](#demo1---基本框架)
    - [Demo2 - 多文件编译](#demo2---多文件编译)
        - [手动列出所有文件](#手动列出所有文件)
        - [自动列出目录下所有源文件](#自动列出目录下所有源文件)
        - [使用通配符设置文件列表](#使用通配符设置文件列表)
        - [文件模块化管理](#文件模块化管理)
    - [Demo3 - 多目录模块化编译](#demo3---多目录模块化编译)
    - [Demo4 - 自定义编译选项](#demo4---自定义编译选项)
    - [Demo5 - 安装和测试](#demo5---安装和测试)
        - [安装](#安装-1)
        - [测试](#测试)
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

## Demo1 - 基本框架
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

## Demo2 - 多文件编译
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

## Demo3 - 多目录模块化编译
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

## Demo4 - 自定义编译选项
在一个大工程中可能包含多个不同的模块，有时可能希望选择其中一些模块进行编译，而另一些模块不编译，也就是对工程进行裁剪。或者工程中的两个模块是可以相互替代的，我们希望能让用户自己选择使用哪一个模块。

要实现这种功能需要考虑两个方面: `CMakeLists.txt`和源代码.  
1. 在`CMakeLists.txt`中可以根据`option()`参数来决定是否执行某些cmake语句.  
```cmake
option(USE_MYMATH "use provided math implementation" ON) # 设置为ON或OFF，默认为OFF
message(STATUS "USE_MYMATH is ${USE_MYMATH}")
...
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

```

已定义option选项会缓存在CMakeCache.txt中, 除非在命令行通过`-D`参数显式地执行`cmake .. -DUSE_MYMATH=OFF/ON`, 或者删除缓存文件，否则配置一次后就不再改变(即便修改`CMakeLists.txt`). 

2. 当`USE_MYMATH`为`OFF`时，编译目标没有链接到`my_power`库，无法使用自己定义的函数，因此源码中必然需要进行相应的修改。为了更通用，cmake提供了`configure_file()`函数，可以在执行`cmake ..`时根据`option()`参数将一个`config.h.in`文件转换为头文件`config.h`.
```cmake
# CMakeLists.txt
...
# 加入一个配置头文件config.h.in，用于编译选项的设置，注意这个文件必须用户提前建立，否则编译错误--找不到该文件
configure_file(
    "${PROJECT_SOURCE_DIR}/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
)
include_directories("${PROJECT_BINARY_DIR}")
...
```

注意, `config.h.in`是自己编写的,如下   
```cpp
// 表示启用宏名USE_MYMATH，而且会在config.h中自动加入对应代码
#cmakedefine USE_MYMATH
```
而`build/config.h`是cmake自动生成的，根据`USE_MYMATH`取值不同而不同  
- 当`USE_MYMATH`为`ON`:  
```cpp
// 表示启用宏名USE_MYMATH，而且会在config.h中自动加入对应代码
#define USE_MYMATH
```
- 当`USE_MYMATH`为`OFF`:  
```cpp
// 表示启用宏名USE_MYMATH，而且会在config.h中自动加入对应代码
/* #undef USE_MYMATH */
```

因此可以在`main.cpp`中根据是否定义了`USE_MYMATH`宏，来使用不同的代码参与运算.  
注意在`main.cpp`中要`#include "config.h"`,因此需要让编译器知道该头文件的位置，在`CMakeLists.txt`中需要添加头文件路径`include_directories("${PROJECT_BINARY_DIR}")`.

```cpp
// main.cpp
#include "config.h"

#ifdef USE_MYMATH
    #include "math/my_power.h"
#else
    #include <math.h>
#endif

...

#ifdef USE_MYMATH
    printf("Now we use our own Math library. \n");
    double result = my_power(base, exponent);
#else
    printf("Now we use the standard library. \n");
    double result = pow(base, exponent);
#endif
```

- [CMake » Documentation » cmake-commands(7) » configure_file](https://cmake.org/cmake/help/v3.18/command/configure_file.html)

## Demo5 - 安装和测试
### 安装
1. 设置安装目录   
安装目录由`CMAKE_INSTALL_PREFIX`指定，windows下默认为  
`CMAKE_INSTALL_PREFIX=C:/Program Files (x86)/${PROJECT_NAME}`

要修改安装目录可以直接在`CMakeLists.txt`中通过`set()`指令实现:  
`set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/install)`  

后续所有`install()`指令安装的目标路径都是相对于`CMAKE_INSTALL_PREFIX`的.

2. 安装文件  
所谓`安装`实际上就是把编译生成的文件拷贝到安装目录中，整合成一个可以直接运行的软件包.
本例程文件结构如下:  

```tree
Demo5
|   CMakeLists.txt
|   main.cpp
\---math
        CMakeLists.txt
        my_power.cpp
        my_power.h
        
```

- 首先安装子目录下的库  
子目录`math/`中有头文件，并且在`CMakeLists.txt`中还设置了要生成库文件.这两部分需要被安装到指定目录中去.  
修改`math/CMakeLists.txt`  
```cmake
# math/CMakeLists.txt

...

# 指定 my_power 库的安装路径
install(TARGETS my_power DESTINATION bin)
install(FILES my_power.h DESTINATION include)
```

- 安装编译目标和相关头文件   
修改`CMakeLists.txt`
```cmake
# CMakeLists.txt

...

# 指定demo.exe安装路径
install(TARGETS demo DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/config.h"
         DESTINATION include)
```

执行`cmake ..`之后通过VS打开解决方案，可以看到解决方案资源管理器如下所示  
```tree
解决方案'Demo5'(5个项目)
- ALL_BUILD
- demo
    - 引用
    - 外部依赖项
        - config.h
        - my_power.h
        ...
    - Source Files
        - main.cpp
    - CMakeLists.txt
- INSTALL
    - 引用
    - 外部依赖项
    - CMake Rules
        - INSTALL_force.rule
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
其中`INSTALL`项目就是用于安装的,在直接点击`生成解决方案`时会被跳过，输出如下:  
```
...
5>------ 已跳过生成: 项目: INSTALL, 配置: Debug Win32 ------
5>没有为此解决方案配置选中要生成的项目 
========== 生成: 成功 4 个，失败 0 个，最新 0 个，跳过 1 个 ==========
```

此时如果要安装，需要选中`INSTALL`项目，右键，点击`生成`,输出如下,表示相关文件已经被拷贝到了对应的目录中了:  
```
1>------ 已启动生成: 项目: INSTALL, 配置: Debug Win32 ------
1>-- Install configuration: "Debug"
1>-- Installing: <path>/Demo5/install/bin/my_power.lib
1>-- Installing: <path>/Demo5/install/include/my_power.h
1>-- Installing: <path>/Demo5/install/bin/demo.exe
1>-- Installing: <path>/Demo5/install/include/config.h
========== 生成: 成功 1 个，失败 0 个，最新 4 个，跳过 0 个 ==========
```

可以查看`install`目录如下:  
```tree
Demo5\install
+---bin
|       demo.exe
|       my_power.lib
|
\---include
        config.h
        my_power.h
```

### 测试
为了验证代码正确性，可以事先给出几个样例，在生成目标后运行测试样例，判断其输出是否正确,从而判断程序是否正确.  
`CMake`提供了一个称为`CTest`的测试工具。我们要做的只是在项目根目录的`CMakeLists.txt`文件中调用一系列的`add_test()`命令.  

要添加测试，首先在`CMakeLists.txt`中添加: `enable_testing()`  
然后就可以通过`add_test(<name> <command> [<arg>...])`来添加测试.其中`<name>`可以随便，但不要重复；`<command>`是编译生成的目标文件,后面`<arg>`给出可执行文件需要的参数.  

- 测试程序是否可以运行: `add_test (test_run demo 5 2)`
- 测试帮助信息是否可以正常提示
    ```cmake
    add_test (test_usage demo) # 测试时不指定参数，main函数中会检查发现参数个数不对，然后输出帮助信息
    set_tests_properties (test_usage
    PROPERTIES PASS_REGULAR_EXPRESSION "Usage: .* base exponent") # 通过正则表达式检查程序输出是否正确
    ```
- 测试 5 的平方
    ```cmake
    add_test (test_5_2 demo 5 2) # 测试时指定参数 5 和 2，程序会计算 5^2,然后在终端输出
    set_tests_properties (test_5_2
    PROPERTIES PASS_REGULAR_EXPRESSION "is 25") # 通过正则表达式检查程序输出是否正确
    ```

如果要执行更多的测试样例，使用`add_test()`效率就太低了，可以通过编写宏来简化操作:  
```cmake 
# 定义一个宏，用来简化测试工作
macro (do_test arg1 arg2 result)
  add_test (test_${arg1}_${arg2} demo ${arg1} ${arg2})
  set_tests_properties (test_${arg1}_${arg2}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endmacro (do_test)
 
# 使用该宏进行一系列的数据测试
do_test (5 2 "is 25")
do_test (10 5 "is 100000")
do_test (2 10 "is 1024")
```


执行`cmake ..`之后通过VS打开解决方案，可以看到解决方案资源管理器如下所示  
```tree
解决方案'Demo5'(6个项目)
- ALL_BUILD
- demo
    ...
- INSTALL
    ...
- RUN_TESTS
    - 引用
    - 外部依赖项
    - CMake Rules
        - RUN_TESTS_force.rule
- my_power
    ...
- ZERO_CHECK
```
其中`RUN_TESTS`项目就是用于测试的,在直接点击`生成解决方案`时会被跳过，需要在生成解决方案之后单独生成一次，输出如下:  
```
1>------ 已启动生成: 项目: RUN_TESTS, 配置: Debug Win32 ------
1>Test project <path>/Demo5/build
1>    Start 1: test_run
1>1/8 Test #1: test_run .........................   Passed    0.02 sec
1>    Start 2: test_usage
1>2/8 Test #2: test_usage .......................   Passed    0.01 sec
1>    Start 3: test_5_2
1>3/8 Test #3: test_5_2 .........................   Passed    0.01 sec
1>    Start 4: test_10_5
1>4/8 Test #4: test_10_5 ........................   Passed    0.01 sec
1>    Start 5: test_2_10
1>5/8 Test #5: test_2_10 ........................   Passed    0.01 sec
1>    Start 6: test_5_3
1>6/8 Test #6: test_5_3 .........................   Passed    0.02 sec
1>    Start 7: test_10_2
1>7/8 Test #7: test_10_2 ........................   Passed    0.01 sec
1>    Start 8: test_2_5
1>8/8 Test #8: test_2_5 .........................   Passed    0.01 sec
1>
1>100% tests passed, 0 tests failed out of 8
1>
1>Total Test time (real) =   0.20 sec
========== 生成: 成功 1 个，失败 0 个，最新 1 个，跳过 0 个 ==========
```

- [CMake » Documentation » cmake-commands(7) » add_test](https://cmake.org/cmake/help/v3.18/command/add_test.html)



# 参考
- [Modern CMake 简体中文版](https://modern-cmake-cn.github.io/Modern-CMake-zh_CN/)
- [An Introduction to Modern CMake](https://cliutils.gitlab.io/modern-cmake/)
- [ CMake 3.18 Documentation  CMake Tutorial](https://cmake.org/cmake/help/v3.18/guide/tutorial/index.html)
- [CMake 入门实战](https://www.hahack.com/codes/cmake/)
- [ve2102388688/myCmakeDemos - Github](https://github.com/ve2102388688/myCmakeDemos)