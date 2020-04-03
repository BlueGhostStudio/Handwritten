#ifndef BYTEARRAY_H
#define BYTEARRAY_H

#include <QObject>
#include <QJSValue>

class ByteArray : public QObject
{
    Q_OBJECT
public:
    explicit ByteArray(QObject *parent = nullptr);

    Q_INVOKABLE QJSValue atob(const QByteArray& input) const;
    Q_INVOKABLE QByteArray btoa(const QByteArray& input) const;


signals:

};

#endif // BYTEARRAY_H
