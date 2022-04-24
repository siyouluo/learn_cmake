file(GLOB MY_POWER_FILES "my_power.cpp" "my_power.h") # 将my_power模块的源文件和头文件, 设置到指定变量名MY_POWER_FILES中
add_library(my_power ${MY_POWER_FILES}) # 将本目录下的文件编译成静态库

# 指定 my_power 库的安装路径
install(TARGETS my_power DESTINATION bin)
install(FILES my_power.h DESTINATION include)
