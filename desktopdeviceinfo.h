#ifndef DESKTOPDEVICEINFO_H
#define DESKTOPDEVICEINFO_H

#include <QObject>

class DesktopDeviceInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString deviceId READ deviceId NOTIFY deviceIDChanged)
    Q_PROPERTY(QString kernelType READ kernelType NOTIFY kernelTypeChanged)
    Q_PROPERTY(QString kernelVersion READ kernelVersion NOTIFY kernelVersionChanged)
    Q_PROPERTY(QString productName READ productName NOTIFY productNameChanged)
    Q_PROPERTY(QString productVersion READ productVersion NOTIFY productVersionChanged)
    Q_PROPERTY(QString productType READ productType NOTIFY productTypeChanged)

public:
    explicit DesktopDeviceInfo(QObject *parent = nullptr);

    void initialInfo();

    QString deviceId() const;
    QString kernelType() const;
    QString kernelVersion() const;
    QString productName() const;
    QString productVersion() const;
    QString productType() const;

signals:
    void deviceIDChanged();
    void kernelTypeChanged();
    void kernelVersionChanged();
    void productNameChanged();
    void productVersionChanged();
    void productTypeChanged();

private:
    QString mDeviceID;
    QString mKernelType;
    QString mKernelVersion;
    QString mProductName;
    QString mProductVersion;
    QString mProductType;
};

#endif // DESKTOPDEVICEINFO_H
