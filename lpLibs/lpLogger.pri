win32:CONFIG(debug, debug|release):LIBS += -llpLogger -L../lpLogger/debug
win32:CONFIG(release, debug|release):LIBS += -llpLogger -L../lpLogger/release
INCLUDEPATH += $$PWD/lpLogger/include
