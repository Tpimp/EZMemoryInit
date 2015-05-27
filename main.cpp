#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "memoryinitfile.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    MemoryInitFile  active_file;

    engine.rootContext()->setContextProperty("MemoryFileEngine",&active_file);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
