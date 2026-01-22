CONFIG += lpLogger

DEFINES += LPLOGGER_LIBRARY

TARGET = lpLogger
TEMPLATE = lib
CONFIG += shared dll

QT     += core
CONFIG += c++17

INCLUDEPATH += $$PWD/include

SOURCES +=                \
    src/logger.cpp

HEADERS +=                \
    include/lpLogger/lpLogger_global.h \
    include/lpLogger/logger.h               
