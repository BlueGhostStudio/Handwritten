#include "bytearray.h"
#include <QJSEngine>
#include <QDebug>

ByteArray::ByteArray(QObject *parent) : QObject(parent)
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
