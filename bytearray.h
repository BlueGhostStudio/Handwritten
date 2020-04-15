#ifndef BYTEARRAY_H
#define BYTEARRAY_H

#include <QObject>
#include <QJSValue>
#include <QFile>

class ByteArray : public QObject
{
    Q_OBJECT
public:
    explicit ByteArray(QObject *parent = nullptr);

    Q_INVOKABLE QJSValue atob(const QByteArray& input) const;
    Q_INVOKABLE QString btoa(const QByteArray& input) const;

    Q_INVOKABLE QByteArray strokeDataFragment(const QByteArray& data, int fl = 0X7) const;
    Q_INVOKABLE QByteArray strokeDataMergeFragment(const QByteArray& data, int fl, int& i) const;

    Q_INVOKABLE QByteArray packageNotebook_header(const QByteArray& _pkg, const QByteArray& header) const;
    Q_INVOKABLE QByteArray packageNotebook_page(const QByteArray& _pkg, int page, const QByteArray& data, int fl = 0X7F) const;
    Q_INVOKABLE QByteArray packageNotebook_notebookEnd(const QByteArray& _pkg) const;

    Q_INVOKABLE QJSValue unpackageNotebook_header(const QByteArray& package, int i) const;
    Q_INVOKABLE QJSValue unpackageNotebook_page(const QByteArray& package, int i) const;

    Q_INVOKABLE bool savePackage(const QByteArray& package);
    Q_INVOKABLE QByteArray readPackage();

signals:

private:
    QFile PackageFile;
};

#endif // BYTEARRAY_H
