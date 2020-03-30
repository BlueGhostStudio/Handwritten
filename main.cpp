#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <bytearray.h>
#include <QTranslator>
#include <QDebug>
#include <QSettings>

#ifdef Q_OS_ANDROID
#include "phonedeviceinfo.h"
#include "sendsms.h"
#else
#include "desktopdeviceinfo.h"
#endif
int main(int argc, char *argv[])
{
//    0668-6130611
//    translator.load(QString(":/HandWritten_") + QLocale::system().name() + ".qm");
//    translator.load(QString(":/HandWritten_zh_CN.qm"));
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
//    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);

    QSettings settings("BlueGhost Studio", "Handwritten");
    bool ehds = settings.value("mis/enableHighDpiScaling", true).toBool();
    qDebug() << ehds;
    if (ehds)
        QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QTranslator translator;
    translator.load(QString(":/HandWritten_") + QLocale::system().name() + ".qm");
    app.installTranslator(&translator);
    app.setOrganizationName("BlueGhost Studio");
    app.setOrganizationDomain("bgstudio.com");
    app.setApplicationName("Handwritten");

    QQmlApplicationEngine engine;

#ifdef Q_OS_ANDROID
    PhoneDeviceInfo* devInfo = new PhoneDeviceInfo;
    devInfo->initialInfo();
    engine.rootContext()->setContextProperty("DeviceInfo", devInfo);
    engine.rootContext()->setContextProperty("SMS", new SendSMS);
#else
    DesktopDeviceInfo* devInfo = new DesktopDeviceInfo;
    devInfo->initialInfo();
    engine.rootContext()->setContextProperty("DeviceInfo", devInfo);
#endif

    engine.rootContext()->setContextProperty("byteArray", new ByteArray());

    engine.addImportPath("qrc:/Components");
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
    &app, [url](QObject * obj, const QUrl & objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

//    qDebug() << "local" << QString(":/HandWritten_") + QLocale::system().name() + ".qm" << QLocale::system().name();


//    qDebug() << "Locale" << QLocale::system().name();

    return app.exec();
}
