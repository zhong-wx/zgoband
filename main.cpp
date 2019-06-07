#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "recvclient.h"
#include "RPC/_loginandreg.h"
#include "rpc/_gamehall.h"
#include "rpc/_gameoperator.h"

QObject* rootObject = nullptr;
#ifndef IN_DEBUG
int main(int argc, char *argv[])
{
    qputenv("QML2_IMPORT_PATH", "D:\\qt works\\zgoband");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    //engine.load(QUrl(QStringLiteral("qrc:/gameComponent/TimerRect.qml")));

    LoginAndReg loginAndReg;
    GameHall gameHall;
    GameOperator gameOperator;
    engine.rootContext()->setContextProperty("LoginAndReg", &loginAndReg);
    engine.rootContext()->setContextProperty("GameHallRPC", &gameHall);
    engine.rootContext()->setContextProperty("GameOperatorRPC", &gameOperator);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    rootObject = engine.rootObjects().first();

    return app.exec();
}
#endif
