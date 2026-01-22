CONFIG += QtCommonTools
include($$PWD/../lpLogger.pri)

DEFINES += QTCOMMONTOOLS_LIBRARY

TARGET = QtCommonTools
TEMPLATE = lib
CONFIG += shared dll

QT     += core
CONFIG += c++17

INCLUDEPATH += $$PWD/include

SOURCES +=                \
    src/utils.cpp

HEADERS +=                \
    include/QtCommonTools/QtCommonTools_global.h \
    include/QtCommonTools/utils.h               
