cmake_minimum_required(VERSION 3.16...3.21)

include(${LP_CMAKE}/common.cmake)

project(lpLogger 
  VERSION 1.1.4 
  DESCRIPTION "Just another homebrew library for everything"
  LANGUAGES C CXX
)   
set(LP_PRIVATE_DEFINE LPLOGGER_LIBRARY)

list(APPEND QT_DEPENDENCES Core)
list(APPEND LOCAL_LIBS)
list(APPEND LOCAL_PLUGINS)

set(HEADERS
    include/lpLogger/logger.h
    include/lpLogger/lpLogger_global.h
)
set(SOURCES
    src/logger.cpp 
)

lpp_make_library(STATIC)
# lpp_install_library()
