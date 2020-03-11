#include <QGuiApplication>
#include <QCoreApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "network.h"
#include "packet.h"
#include "httpdownload.h"
#include "logged.h"
#include "dbosettings.h"
#include "registration.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName("DBORevelations Launcher");
    QCoreApplication::setAttribute(Qt::AA_DisableHighDpiScaling); //Qt::AA_DisableHighDpiScaling //Qt::AA_EnableHighDpiScaling
	QCoreApplication::setAttribute(Qt::AA_X11InitThreads);
    //QCoreApplication::setAttribute(Qt::AA_UseDesktopOpenGL); //Qt::AA_UseDesktopOpenGL //Qt::AA_UseOpenGLES //Qt::AA_UseSoftwareOpenGL
    QQuickStyle::setStyle("Fusion");
    qmlRegisterType<Network>("io.dbour.Network", 1, 0, "Network");
    qmlRegisterType<Registration>("io.dbour.Registration", 1, 0, "Registration");
    qmlRegisterType<HttpDownload>("io.dbour.HttpDownloader", 1,0, "HttpDownloader");
    qmlRegisterType<Logged>("io.dbour.Logged", 1, 0, "Logged");
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    DboSettings settings;
    engine.rootContext()->setContextProperty("DboSettings", &settings);

    //connect(app, SIGNAL(quit()), qApp, SLOT(quit()));
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
