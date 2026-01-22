# The real minimum version will be checked by the qtbase project.
# 3.16 is the absolute minimum though.
cmake_minimum_required(VERSION 3.16...3.21)

project(Proj  
  VERSION 0.0.1 
)      


find_package(QT NAMES Qt6 Qt5 COMPONENTS Core)                  
if (Qt5_FOUND OR Qt6_FOUND)                                                              
  set(LP_QT_VERSION "Qt-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}")
endif()
 
if("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
    set(lp_Platform "x86")
else()
    set(lp_Platform "x64")
endif()

set(LP_INSTALL_PREFIX "${CMAKE_SYSTEM_NAME}/${lp_Platform}/${CMAKE_CXX_COMPILER_ID}-${CMAKE_CXX_COMPILER_VERSION}/${LP_QT_VERSION}")


set(CMAKE_AUTOMOC ON) 
set(CMAKE_AUTORCC ON) 
set(CMAKE_AUTOUIC ON) 

cmake_path(ABSOLUTE_PATH PROJECT_SOURCE_DIR OUTPUT_VARIABLE _LP_ROOT_PATH)


message(STATUS "Project path: ${_LP_ROOT_PATH}")
         
set(LP_ROOT_PATH          "${_LP_ROOT_PATH}"          CACHE PATH "Project root path")
set(LP_ROOT_PREFIX        ""                          CACHE PATH "Root prefix")
set(LP_SOURCE_PATH        "${_LP_ROOT_PATH}"          CACHE PATH "Path to source files")
set(LP_INSTALL_PATH       "${_LP_ROOT_PATH}/.install/${LP_INSTALL_PREFIX}" CACHE PATH "Install path")
set(LP_INSTALL_LIST       "${LP_INSTALL_PATH}"        CACHE PATH "List of install paths")
set(LP_SOURCE_LIST        "${CMAKE_SOURCE_DIR}"       CACHE PATH "Path to cmake files")
set(LP_THIRD_PARTY_PREFIX "${_LP_ROOT_PATH}/3rdParty" CACHE PATH "Path to 3rdParty libraries")
set(LP_CMAKE              "${_LP_ROOT_PATH}/cmake"    CACHE PATH "Path to cmake files")

# add_subdirectory(include)

set(CMAKE_INSTALL_PREFIX ${_LP_ROOT_PATH}/.install/${LP_INSTALL_PREFIX})
set(LP_INSTALL_PATH ${_LP_ROOT_PATH}/.install/${LP_INSTALL_PREFIX})
list(APPEND CMAKE_INCLUDE_PATH ${LP_INSTALL_PATH}/include)

message(STATUS "  LP_CMAKE: ${LP_CMAKE}")
message(STATUS "  LP_ROOT_PATH: ${LP_ROOT_PATH}")
message(STATUS "  LP_ROOT_PREFIX: ${LP_ROOT_PREFIX}")
message(STATUS "  LP_SOURCE_PATH: ${LP_SOURCE_PATH}")
message(STATUS "  LP_INSTALL_PREFIX: ${LP_INSTALL_PREFIX}")
message(STATUS "  LP_INSTALL_PATH: ${LP_INSTALL_PATH}")
message(STATUS "  LP_INSTALL_LIST: ${LP_INSTALL_LIST}")
message(STATUS "  LP_SOURCE_LIST: ${LP_SOURCE_LIST}")
message(STATUS "  LP_THIRD_PARTY_PREFIX: ${LP_THIRD_PARTY_PREFIX}")

message(STATUS "  CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")

add_subdirectory(lpLibs)

 
install()