#ifndef SENDSMS_H
#define SENDSMS_H

#include <QObject>

class SendSMS : public QObject
{
    Q_OBJECT
public:
    explicit SendSMS(QObject *parent = nullptr);

    Q_INVOKABLE void sendSMS(const QString& phoneNumber, const QString& message) const;

signals:
};

#endif // SENDSMS_H
