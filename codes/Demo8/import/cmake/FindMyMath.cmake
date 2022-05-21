# FindMyMath
# --------
#
# Find the MyMath libraries
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# The following variables will be defined:
#
# ``MyMath_FOUND`` True if MyMath found on the local system
#
# ``MyMath_VERSION`` Version of MyMath found
#
# ``MyMath_INCLUDE_DIRS`` Location of MyMath header files
#
# ``MyMath_LIBRARIES`` List of the MyMath libraries found
#


find_package(PkgConfig)

# ======================= define XXX_ROOT_DIR =======================
set(MyMath_ROOT_DIR D:/Research/MachineVision/Code/learn_cmake/codes/Demo8/export/3rdParty/MyMath)
# ======================= find header files =======================
# define macro func to find headers
macro(MyMath_FIND_INCLUDE varname foldername headername)
    if(NOT MyMath_${foldername}_INCLUDE_DIR)
        find_path(MyMath_${foldername}_INCLUDE_DIR
            NAMES ${foldername}/${headername}
            PATHS ${MyMath_ROOT_DIR}/include)
        list(APPEND MyMath_INCLUDE_DIR ${MyMath_${foldername}_INCLUDE_DIR})
        list(REMOVE_DUPLICATES MyMath_INCLUDE_DIR)
    endif()
endmacro(MyMath_FIND_INCLUDE)

# call macro func to find headers
MyMath_FIND_INCLUDE(mypower_INCLUDE_DIR "."  mypower.h)
MyMath_FIND_INCLUDE(myplus_INCLUDE_DIR  "."  myplus.h)

# ---------------- find library files----------------
## define function to find libs(debug)
macro(MyMath_FIND_LIBRARY libname)
    if(NOT MyMath_${libname}_LIBRARY_DEBUG)
        find_library(MyMath_${libname}_LIBRARY_DEBUG 
            NAMES ${libname} 
            PATHS ${MyMath_ROOT_DIR}/lib/debug)
        list(APPEND MyMath_LIBRARY_DEBUG ${MyMath_${libname}_LIBRARY_DEBUG})
    endif()
    if(NOT MyMath_${libname}_LIBRARY_RELEASE)
        find_library(MyMath_${libname}_LIBRARY_RELEASE 
            NAMES ${libname} 
            PATHS ${MyMath_ROOT_DIR}/lib/release)
        list(APPEND MyMath_LIBRARY_RELEASE ${MyMath_${libname}_LIBRARY_RELEASE})
    endif()
endmacro(MyMath_FIND_LIBRARY)

# call macro func to find libs
MyMath_FIND_LIBRARY(mypower.lib)
MyMath_FIND_LIBRARY(myplus.lib)

include(SelectLibraryConfigurations)
select_library_configurations(MyMath)

# message(STATUS "MyMath_INCLUDE_DIR: ${MyMath_INCLUDE_DIR}")
# message(STATUS "MyMath_LIBRARY_DEBUG: ${MyMath_LIBRARY_DEBUG}")
# message(STATUS "MyMath_LIBRARY_RELEASE: ${MyMath_LIBRARY_RELEASE}")
# message(STATUS "MyMath_LIBRARY: ${MyMath_LIBRARY}")
# ======================= verify dependencies =======================
if (MyMath_INCLUDE_DIR AND MyMath_LIBRARY)
    set(MyMath_FOUND TRUR CACHE BOOL "")
    set(MyMath_VERSION "0.1.0" CACHE STRING "")
    set(MyMath_INCLUDE_DIRS ${MyMath_INCLUDE_DIR} CACHE STRING "")
    set(MyMath_LIBRARIES ${MyMath_LIBRARY} CACHE STRING "")

    find_package_handle_standard_args(MyMath
        REQUIRED_VARS MyMath_INCLUDE_DIRS MyMath_LIBRARIES
        VERSION_VAR MyMath_VERSION)
    mark_as_advanced(MyMath_INCLUDE_DIRS MyMath_LIBRARIES)
endif()
