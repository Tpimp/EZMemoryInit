#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "memoryinitfile.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<MemoryInitFile>("MemoryInitialization",1,0,"MemoryInitFile");
    qmlRegisterType<MemoryChunk>("MemoryInitialization", 1, 0, "MemoryChunk");
    qmlRegisterType<ChunkData>("MemoryInitialization", 1, 0, "ChunkData");

    QQmlApplicationEngine engine;

    MemoryInitFile  active_file;

    engine.rootContext()->setContextProperty("MemoryFileEngine",&active_file);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
