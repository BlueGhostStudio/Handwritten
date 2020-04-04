#include "bytearray.h"
#include <QJSEngine>
#include <QDebug>
#include <QStandardPaths>

ByteArray::ByteArray(QObject *parent)
    : QObject(parent), PackageFile(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/notebook.hwnb")
{

}

QJSValue ByteArray::atob(const QByteArray &input) const
{
    QJSValue array = qjsEngine(this)->newArray();

    QByteArray bin = QByteArray::fromBase64(input);

    for (int i = 0; i < bin.length(); i++) {
        array.setProperty(i, QJSValue((uint8_t)bin[i]));
    }

    return array;
}

QByteArray ByteArray::btoa(const QByteArray& input) const
{
    return input.toBase64();
}

QByteArray ByteArray::strokeDataFragment(const QByteArray& data, int fl) const
{
    QByteArray array;
    int b = 0;
    int dl = data.length();
//    qDebug() << "begin:" << b << "data length:" << dl;
    do {
        int toEnd = dl - b;
        int l;
        if (toEnd >= fl) {
            array.append((uint8_t)0XFF);
            l = fl;
        } else {
            char c[2];
            c[0] = toEnd >> 8;
            c[1] = toEnd & 0XFF;
            array.append(QByteArray::fromRawData(c, 2));
            l = toEnd;
        }

        qDebug() << l << b << dl;

        if (l > 0) {
            array.append(data.mid(b, l));
            b += l;
        } else
            break;
    } while (b < dl);
    qDebug() << "end";
    array.append((uint8_t)0X80);

    return array;
}

QByteArray ByteArray::strokeDataMergeFragment(const QByteArray& data, int fl, int& i) const
{
    QByteArray array;

    while (i < data.length()) {
        uint8_t flag = (uint8_t)data[i];
        if (flag == 0XFF) {
            array.append(data.mid(i + 1, fl));
            i += fl + 1;
        } else if (flag != 0X80) {
            uint l = data[i] << 8 | data[i + 1];
            array.append(data.mid(i + 2, l));
            i += l + 2;
        } else {
            i++;
            break;
        }
    }

    return array;
}

QByteArray ByteArray::packageNotebook_header(const QByteArray& _pkg, const QByteArray& header) const
{

    QByteArray data;
    uint16_t hl = header.length();
    char f[2];
    f[0] = hl >> 8;
    f[1] = hl & 0XFF;
    data.append(QByteArray::fromRawData(f, 2));
    data.append(header);

    return _pkg + data;
}

QByteArray ByteArray::packageNotebook_page(const QByteArray& _pkg, int page, const QByteArray& data, int fl) const
{
    QByteArray pkg;
    char f[2];
    f[0] = page >> 8;
    f[1] = page & 0XFF;
    pkg.append(QByteArray::fromRawData(f, 2));
    f[0] = fl >> 8;
    f[1] = fl & 0XFF;
    pkg.append(QByteArray::fromRawData(f, 2));
    pkg.append(strokeDataFragment(data, fl));

    return _pkg + pkg;
}

QByteArray ByteArray::packageNotebook_notebookEnd(const QByteArray& _pkg) const
{
    QByteArray pkg;
    pkg[0] = (uint8_t)0X80;

    return _pkg + pkg;
}

QJSValue ByteArray::unpackageNotebook_header(const QByteArray& package, int i) const
{
    QByteArray header;
    uint16_t hl = (uint8_t)package[i] << 8 | (uint8_t)package[i + 1];
    header.append(package.mid(i + 2, hl));

    QJSValue result = qjsEngine(this)->newObject();
    result.setProperty("i", i + 2 + hl);
    result.setProperty("data", qjsEngine(this)->toScriptValue(header));
    return result;
}

QJSValue ByteArray::unpackageNotebook_page(const QByteArray& package, int i) const
{
    QJSValue result = qjsEngine(this)->newObject();
    if ((uint8_t)package[i] == 0x80) {
        i++;
        result.setProperty("i", i);
        result.setProperty("NBEnd", true);
        if (i >= package.length())
            result.setProperty("PkgEnd", true);
    } else {
        int p = (uint8_t)package[i] << 8 | (uint8_t)package[i + 1];
        int fl = (uint8_t)package[i + 2] << 8 | (uint8_t)package[i + 3];
        i += 4;
        QByteArray data = strokeDataMergeFragment(package, fl, i);
        QString _data_ = QString::fromUtf8(data.constData(), data.length());

        result.setProperty("i", i);
        result.setProperty("p", p);
        result.setProperty("data", _data_);
    }

    return result;
}

bool ByteArray::savePackage(const QByteArray& package)
{
    if (PackageFile.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        PackageFile.write(package);
        PackageFile.close();
        return true;
    } else
        return false;
}

QByteArray ByteArray::readPackage()
{
    if (PackageFile.open(QIODevice::ReadOnly))
        return PackageFile.readAll();
    else
        return QByteArray();
}

