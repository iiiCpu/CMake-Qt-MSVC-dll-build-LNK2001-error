#ifndef UTILS_H
#define UTILS_H

#include "QtCommonTools_global.h"

#include <QString>
#include <QByteArray>

namespace U {
QTCOMMONTOOLS_EXPORT bool exists(const QString &name);
QTCOMMONTOOLS_EXPORT bool exists_aged(QString name, uint64_t age_secs, bool autoremove = false);

QTCOMMONTOOLS_EXPORT QByteArray gzipCompress(QByteArray input, int level = -1);
QTCOMMONTOOLS_EXPORT QByteArray gzipDecompress(QByteArray input);

QTCOMMONTOOLS_EXPORT void wait(QObject * obj, const char *signal, int timeout = 30000);

};
#endif // UTILS_H
