cmake_minimum_required(VERSION 3.16...3.21)


include(${LP_CMAKE}/common.cmake)

project(QtCommonTools 
  VERSION 1.1.4 
  DESCRIPTION "Just another homebrew library for everything"
  LANGUAGES C CXX
)   
set(PRIVATE_DEFINE QTCOMMONTOOLS_LIBRARY)
#set(GLOBAL_ALIAS lpLibs::QtCommonTools)

list(APPEND QT_DEPENDENCES Core Network)
list(APPEND LOCAL_LIBS lpLogger)
list(APPEND LOCAL_PLUGINS)

set(HEADERS
    include/QtCommonTools/QtCommonTools_global.h
    include/QtCommonTools/utils.h
)
set(SOURCES
    src/utils.cpp 
)

lpp_make_library(STATIC)
# lpp_install_library()
