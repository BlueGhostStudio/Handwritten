#include "sendsms.h"

#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <jni.h>
#include <QtDebug>

SendSMS::SendSMS(QObject *parent) : QObject(parent)
{

}

void SendSMS::sendSMS(const QString& phoneNumber, const QString& message) const
{
    QtAndroid::runOnAndroidThread([phoneNumber, message]() {
        QAndroidJniObject activity = QtAndroid::androidActivity();
        if (activity.isValid()) {
            QAndroidJniObject smsManager = QAndroidJniObject::callStaticObjectMethod("android/telephony/SmsManager",
                                                                                     "getDefault",
                                                                                     "()Landroid/telephony/SmsManager;");
            QAndroidJniObject jPhoneNumber = QAndroidJniObject::fromString(phoneNumber);
            QAndroidJniObject jMessage = QAndroidJniObject::fromString(message);
            smsManager.callMethod<void>("sendTextMessage",
                                        "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/app/PendingIntent;Landroid/app/PendingIntent;)V",
                                        jPhoneNumber.object<jstring>(),
                                        NULL, jMessage.object<jstring>(),
                                        NULL, NULL);
        } else
            qDebug() << "error";
    });
}
