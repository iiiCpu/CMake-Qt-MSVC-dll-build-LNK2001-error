#include <QtCommonTools/utils.h>

#include <QCoreApplication>
#include <QFile>
#include <QDir>


#include <QDebug>
#include <QEventLoop>
#include <QTimer>
#include <QBuffer>

#include <QtZlib/zlib.h>

#include <lpLogger/logger.h>


namespace U {


bool exists(const QString &name)
{
    Logger_test lt;
    return QFile::exists(name) || QFile::exists(QDir(QCoreApplication::applicationDirPath()).absoluteFilePath(name));
}
bool exists_aged(QString name, uint64_t age_secs, bool autoremove)
{
    if (!QFile::exists(name)) {
        name = QDir(QCoreApplication::applicationDirPath()).absoluteFilePath(name);
    }
    if (!QFile::exists(name)) {
        return false;
    }
    QFileInfo fi(name);
    if (abs(fi.lastModified().secsTo(QDateTime::currentDateTime())) >= age_secs) {
        if (autoremove) {
            QFile::remove(name);
        }
        return false;
    }
    return true;
}


void wait(QObject *obj, const char *signal, int timeout)
{
    QEventLoop loop;
    QTimer timer;
    timer.setInterval(timeout);
    auto connection = QObject::connect(obj, signal, &loop, SLOT(quit()));
    if (!connection) {
        return;
    }
    QObject::connect(&timer, &QTimer::timeout, &loop, &QEventLoop::quit);
    timer.start();
    loop.exec();
}


#define GZIP_WINDOWS_BIT (15 + 16)
#define GZIP_CHUNK_SIZE (32 * 1024)

QByteArray gzipCompress(QByteArray input, int level)
{
    QByteArray ret;
    if(input.length())
    {
        int flush = 0;

        z_stream strm;
        strm.zalloc = Z_NULL;
        strm.zfree = Z_NULL;
        strm.opaque = Z_NULL;
        strm.avail_in = 0;
        strm.next_in = Z_NULL;

        int ret2 = deflateInit2(&strm, qMax(-1, qMin(9, level)), Z_DEFLATED, GZIP_WINDOWS_BIT, 8, Z_DEFAULT_STRATEGY);

        if (Z_OK != ret2) {
            return ret = {"deflateInit2 error"};
        }

        char *input_data = input.data();
        int input_data_left = input.length();

        do {
            int chunk_size = qMin(GZIP_CHUNK_SIZE, input_data_left);

            strm.next_in = (unsigned char*)input_data;
            strm.avail_in = chunk_size;

            input_data += chunk_size;
            input_data_left -= chunk_size;

            flush = (input_data_left <= 0 ? Z_FINISH : Z_NO_FLUSH);

            do {
                char out[GZIP_CHUNK_SIZE];

                strm.next_out = (unsigned char*)out; //-V507
                strm.avail_out = GZIP_CHUNK_SIZE;

                ret2 = deflate(&strm, flush);

                if(Z_STREAM_ERROR == ret2)
                {
                    deflateEnd(&strm);
                    return QByteArray();
                }

                int have = (GZIP_CHUNK_SIZE - strm.avail_out);

                if(have > 0) {
                    ret.append((char*)out, have);
                }

            } while (0 == strm.avail_out);

        } while (Z_FINISH != flush);

        (void)deflateEnd(&strm);
    }
    return ret;
}

QByteArray gzipDecompress(QByteArray input)
{
    QByteArray ret;
    if(input.length() > 0)
    {
        z_stream strm;
        strm.zalloc = Z_NULL;
        strm.zfree = Z_NULL;
        strm.opaque = Z_NULL;
        strm.avail_in = 0;
        strm.next_in = Z_NULL;

        int ret2 = inflateInit2(&strm, GZIP_WINDOWS_BIT);

        if (Z_OK != ret2) {
            return ret = "inflateInit2 error";
        }

        char *input_data = input.data();
        int input_data_left = input.length();

        do {
            int chunk_size = qMin(GZIP_CHUNK_SIZE, input_data_left);
            if (chunk_size <= 0) {
                break;
            }

            strm.next_in = (unsigned char*)input_data;
            strm.avail_in = chunk_size;

            input_data += chunk_size;
            input_data_left -= chunk_size;

            do {
                char out[GZIP_CHUNK_SIZE];

                strm.next_out = (unsigned char*)out; //-V507
                strm.avail_out = GZIP_CHUNK_SIZE;

                ret2 = inflate(&strm, Z_NO_FLUSH);

                switch (ret2) {
                case Z_NEED_DICT:
                    ret2 = Z_DATA_ERROR;
                case Z_DATA_ERROR:
                case Z_MEM_ERROR:
                case Z_STREAM_ERROR:
                    inflateEnd(&strm);
                    return ret = "inflate error";
                }

                int have = (GZIP_CHUNK_SIZE - strm.avail_out);

                if(have > 0) {
                    ret.append((char*)out, have);
                }

            } while (0 == strm.avail_out);

        } while (Z_STREAM_END != ret2);

        inflateEnd(&strm);
    }
    return ret;
}

};