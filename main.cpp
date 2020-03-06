#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <bytearray.h>
#include <QTranslator>
#include <QDebug>

int main(int argc, char *argv[])
{
//    0668-6130611
//    translator.load(QString(":/HandWritten_") + QLocale::system().name() + ".qm");
//    translator.load(QString(":/HandWritten_zh_CN.qm"));
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);

    QGuiApplication app(argc, argv);
    QTranslator translator;
    translator.load(QString(":/HandWritten_") + QLocale::system().name() + ".qm");
    app.installTranslator(&translator);
    app.setOrganizationName("BlueGhost Studio");
    app.setOrganizationDomain("bgstudio.com");
    app.setApplicationName("Handwritten");

    QQmlApplicationEngine engine;
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
