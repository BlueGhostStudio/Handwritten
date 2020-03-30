#include "desktopdeviceinfo.h"
#include <QSysInfo>
#include <QDebug>

DesktopDeviceInfo::DesktopDeviceInfo(QObject *parent) : QObject(parent)
{
    //qDebug() << QSysInfo::kernelType() << QSysInfo::kernelVersion() << QSysInfo::prettyProductName() << QSysInfo::productType() << QSysInfo::productVersion();
}

void DesktopDeviceInfo::initialInfo()
{
    mDeviceID = QSysInfo::machineUniqueId();
    mKernelType = QSysInfo::kernelType();
    mKernelVersion = QSysInfo::kernelVersion();
    mProductName = QSysInfo::prettyProductName();
    mProductType = QSysInfo::productType();
    mProductVersion = QSysInfo::productVersion();

    deviceIDChanged();
    kernelTypeChanged();
    kernelVersionChanged();
    productNameChanged();
    productVersionChanged();
    productTypeChanged();

    qDebug() << mDeviceID;
}

QString DesktopDeviceInfo::deviceId() const
{
    return mDeviceID;
}
QString DesktopDeviceInfo::kernelType() const
{
    return mKernelType;
}
QString DesktopDeviceInfo::kernelVersion() const
{
    return mKernelVersion;
}
QString DesktopDeviceInfo::productName() const
{
    return mProductName;
}
QString DesktopDeviceInfo::productVersion() const
{
    return mProductVersion;
}
QString DesktopDeviceInfo::productType() const
{
    return mProductType;
}
