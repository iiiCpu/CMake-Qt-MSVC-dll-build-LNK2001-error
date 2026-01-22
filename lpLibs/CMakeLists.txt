# The real minimum version will be checked by the qtbase project.
# 3.16 is the absolute minimum though.
cmake_minimum_required(VERSION 3.16...3.21)

message(STATUS "---=== lpLibs ===---")

set(CMAKE_INSTALL_BINDIR "${CMAKE_INSTALL_PREFIX}/bin")
set(CMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_PREFIX}/lib")

add_subdirectory(lpLogger)
add_subdirectory(QtCommonTools)


# add_subdirectory(lpCipherSqlitePlugin)