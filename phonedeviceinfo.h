#ifndef PHONEDEVICEINFO_H
#define PHONEDEVICEINFO_H

#include <QObject>

class PhoneDeviceInfo : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString deviceId READ deviceId NOTIFY deviceIdChanged)
    Q_PROPERTY(QString simSerialNumber READ simSerialNumber NOTIFY simSerialNumberChanged)
    Q_PROPERTY(QString line1Number READ line1Number NOTIFY line1NumberChanged)
    Q_PROPERTY(QString subscriberId READ subscriberId NOTIFY subscriberIdChanged)

    Q_PROPERTY(QString model READ model NOTIFY modelChanged)
    Q_PROPERTY(QString manufacturer READ manufacturer NOTIFY manufacturerChanged)
    Q_PROPERTY(QString product READ product NOTIFY productChanged)
    Q_PROPERTY(QString brand READ brand NOTIFY brandChanged)
    Q_PROPERTY(QString board READ board NOTIFY boardChanged)
    Q_PROPERTY(QString device READ device NOTIFY deviceChanged)
    Q_PROPERTY(QString fingerprint READ fingerprint NOTIFY fingerprintChanged)

public:
    explicit PhoneDeviceInfo(QObject *parent = nullptr);

    bool initialInfo();

    QString deviceId() const;
    QString simSerialNumber() const;
    QString line1Number() const;
    QString subscriberId() const;

    QString model() const;
    QString manufacturer() const;
    QString product() const;
    QString brand() const;
    QString board() const;
    QString device() const;
    QString fingerprint() const;

signals:
    void deviceIdChanged();
    void simSerialNumberChanged();
    void line1NumberChanged();
    void subscriberIdChanged();

    void modelChanged();
    void manufacturerChanged();
    void productChanged();
    void brandChanged();
    void boardChanged();
    void deviceChanged();
    void fingerprintChanged();

private:
    QString mDeviceId;
    QString mSimSerialNumber;
    QString mLine1Number;
    QString mSubscriberId;

    QString mModel;
    QString mManufacturer;
    QString mProduct;
    QString mBrand;
    QString mBoard;
    QString mDevice;
    QString mFingerprint;
};

#endif // PHONEDEVICEINFO_H
