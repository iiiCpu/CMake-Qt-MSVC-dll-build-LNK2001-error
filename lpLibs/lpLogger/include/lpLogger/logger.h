#ifndef LOGGER_H
#define LOGGER_H

#include <lpLogger/lpLogger_global.h>

#include <QObject>

class LPLOGGER_EXPORT Logger_test : public QObject
{
    Q_OBJECT
public:
    explicit Logger_test(QObject * parent = nullptr);
    virtual ~Logger_test();
};

#endif // LOGGER_H
