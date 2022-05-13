# FindMyPower
# --------
#
# Find the mypower libraries
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# The following variables will be defined:
#
# ``mypower_FOUND`` True if mypower found on the local system
#
# ``mypower_VERSION`` Version of mypower found
#
# ``mypower_INCLUDE_DIRS`` Location of mypower header files
#
# ``mypower_LIBRARIES`` List of the mypower libraries found
#


find_package(PkgConfig)

# ======================= define XXX_ROOT_DIR =======================
set(mypower_ROOT_DIR D:/Research/MachineVision/Code/learn_cmake/codes/Demo8/3rdParty/my_power)
# ======================= find header files =======================
find_path(mypower_INCLUDE_DIR
    NAMES my_power.h
    PATHS ${mypower_ROOT_DIR}/include)

# ======================= find library files =======================
find_library(mypower_LIBRARY_DEBUG
    NAMES my_power.lib
    PATHS ${mypower_ROOT_DIR}/lib/debug)

find_library(mypower_LIBRARY_RELEASE
    NAMES my_power.lib
    PATHS ${mypower_ROOT_DIR}/lib/release)

include(SelectLibraryConfigurations)
select_library_configurations(mypower)

# ======================= verify dependencies =======================
if (mypower_INCLUDE_DIR AND mypower_LIBRARY)
    set(mypower_FOUND TRUR CACHE BOOL "")
    set(mypower_VERSION "0.1.0" CACHE STRING "")

    set(mypower_INCLUDE_DIRS ${mypower_INCLUDE_DIR} CACHE STRING "")
    set(mypower_LIBRARIES ${mypower_LIBRARY} CACHE STRING "")

    find_package_handle_standard_args(mypower
        REQUIRED_VARS mypower_INCLUDE_DIRS mypower_LIBRARIES
        VERSION_VAR mypower_VERSION)
    mark_as_advanced(mypower_INCLUDE_DIRS mypower_LIBRARIES)
endif()
