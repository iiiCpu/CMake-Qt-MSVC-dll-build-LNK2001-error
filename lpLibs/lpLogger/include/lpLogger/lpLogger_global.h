#ifndef LPLOGGER_GLOBAL
#define LPLOGGER_GLOBAL

#include <qglobal.h>

#if defined(LPLOGGER_LIBRARY)
#  define LPLOGGER_EXPORT Q_DECL_EXPORT
#else
#  define LPLOGGER_EXPORT Q_DECL_IMPORT
#endif

#endif // LPLOGGER_GLOBAL
