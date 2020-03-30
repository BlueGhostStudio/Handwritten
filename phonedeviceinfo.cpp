#include "phonedeviceinfo.h"
#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <jni.h>
#include <QtDebug>

PhoneDeviceInfo::PhoneDeviceInfo(QObject *parent) : QObject(parent)
{

}

bool PhoneDeviceInfo::initialInfo()
{
    QAndroidJniEnvironment env;
    jclass contextClass = env->FindClass("android/content/Context");
    if (!contextClass)
        return false;

    jfieldID fieldId = env->GetStaticFieldID(contextClass, "TELEPHONY_SERVICE", "Ljava/lang/String;");
    if (!fieldId)
        return false;

    jstring telephonyManagerType = (jstring) env->GetStaticObjectField(contextClass, fieldId);
    if (!telephonyManagerType)
        return false;

    jclass telephonyManagerClass = env->FindClass("android/telephony/TelephonyManager");
    if (!telephonyManagerClass)
        return false;


    jmethodID methodId = env->GetMethodID(contextClass, "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;");
    if (!methodId)
        return false;


    QAndroidJniObject qtActivityObj = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",  "activity", "()Landroid/app/Activity;");

    jobject telephonyManager = env->CallObjectMethod(qtActivityObj.object<jobject>(), methodId, telephonyManagerType);
    if (!telephonyManager)
        return false;

    auto fun = [&env](jstring & jstr, QString & result) {
        jsize len = env->GetStringUTFLength(jstr);
        char* buf_devid = new char[len];
        env->GetStringUTFRegion(jstr, 0, len, buf_devid);
        result = buf_devid;
        result.resize(len);
        delete []buf_devid;
    };
    methodId = env->GetMethodID(telephonyManagerClass, "getDeviceId", "()Ljava/lang/String;");
    if (methodId) {
        jstring jstr = (jstring) env->CallObjectMethod(telephonyManager, methodId);
        if (jstr)
            fun(jstr, mDeviceId);
        /*jsize len = env->GetStringUTFLength(jstr);
        char* buf_devid = new char[len];
        env->GetStringUTFRegion(jstr, 0, len, buf_devid);
        mDeviceId = buf_devid;
        mDeviceId.resize(len);
        delete []buf_devid;*/
    }

    methodId = env->GetMethodID(telephonyManagerClass, "getSimSerialNumber", "()Ljava/lang/String;");
    if (methodId) {
        jstring jstr = (jstring) env->CallObjectMethod(telephonyManager, methodId);
        if (jstr)
            fun(jstr, mSimSerialNumber);
    }

    methodId = env->GetMethodID(telephonyManagerClass, "getLine1Number", "()Ljava/lang/String;");
    if (methodId) {
        jstring jstr = (jstring) env->CallObjectMethod(telephonyManager, methodId);
        if (jstr)
            fun(jstr, mLine1Number);
    }

    methodId = env->GetMethodID(telephonyManagerClass, "getSubscriberId", "()Ljava/lang/String;");
    if (methodId) {
        jstring jstr = (jstring) env->CallObjectMethod(telephonyManager, methodId);
        if (jstr)
            fun(jstr, mSubscriberId);
    }

    jclass buildClass = env.findClass("android/os/Build");
    if (buildClass) {
        fieldId = env->GetStaticFieldID(buildClass, "MODEL", "Ljava/lang/String;");
        if (fieldId) {
            jstring jstr = (jstring) env->GetStaticObjectField(buildClass, fieldId);
            if (jstr)
                fun(jstr, mModel);
        }

        fieldId = env->GetStaticFieldID(buildClass, "MANUFACTURER", "Ljava/lang/String;");
        if (fieldId) {
            jstring jstr = (jstring) env->GetStaticObjectField(buildClass, fieldId);
            if (jstr)
                fun(jstr, mManufacturer);
        }

        fieldId = env->GetStaticFieldID(buildClass, "PRODUCT", "Ljava/lang/String;");
        if (fieldId) {
            jstring jstr = (jstring) env->GetStaticObjectField(buildClass, fieldId);
            if (jstr)
                fun(jstr, mProduct);
        }

        fieldId = env->GetStaticFieldID(buildClass, "BRAND", "Ljava/lang/String;");
        if (fieldId) {
            jstring jstr = (jstring) env->GetStaticObjectField(buildClass, fieldId);
            if (jstr)
                fun(jstr, mBrand);
        }

        fieldId = env->GetStaticFieldID(buildClass, "BOARD", "Ljava/lang/String;");
        if (fieldId) {
            jstring jstr = (jstring) env->GetStaticObjectField(buildClass, fieldId);
            if (jstr)
                fun(jstr, mBoard);
        }

        fieldId = env->GetStaticFieldID(buildClass, "BOARD", "Ljava/lang/String;");
        if (fieldId) {
            jstring jstr = (jstring) env->GetStaticObjectField(buildClass, fieldId);
            if (jstr)
                fun(jstr, mBoard);
        }

        fieldId = env->GetStaticFieldID(buildClass, "DEVICE", "Ljava/lang/String;");
        if (fieldId) {
            jstring jstr = (jstring) env->GetStaticObjectField(buildClass, fieldId);
            if (jstr)
                fun(jstr, mDevice);
        }

        fieldId = env->GetStaticFieldID(buildClass, "FINGERPRINT", "Ljava/lang/String;");
        if (fieldId) {
            jstring jstr = (jstring) env->GetStaticObjectField(buildClass, fieldId);
            if (jstr)
                fun(jstr, mFingerprint);
        }
    }


    deviceIdChanged();
    simSerialNumberChanged();
    line1NumberChanged();
    subscriberIdChanged();

    modelChanged();
    manufacturerChanged();
    productChanged();
    brandChanged();
    boardChanged();
    deviceChanged();
    fingerprintChanged();

    return true;
}

QString PhoneDeviceInfo::deviceId() const
{
    return mDeviceId;
}

QString PhoneDeviceInfo::simSerialNumber() const
{
    return mSimSerialNumber;
}

QString PhoneDeviceInfo::line1Number() const
{
    return mLine1Number;
}

QString PhoneDeviceInfo::subscriberId() const
{
    return mSubscriberId;
}

QString PhoneDeviceInfo::model() const
{
    return mModel;
}

QString PhoneDeviceInfo::manufacturer() const
{
    return mManufacturer;
}

QString PhoneDeviceInfo::product() const
{
    return mProduct;
}

QString PhoneDeviceInfo::brand() const
{
    return mBrand;
}

QString PhoneDeviceInfo::board() const
{
    return mBoard;
}

QString PhoneDeviceInfo::device() const
{
    return mDevice;
}

QString PhoneDeviceInfo::fingerprint() const
{
    return mFingerprint;
}
