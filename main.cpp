#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlListProperty>
#include "memoryinitfile.h"
#include <QRegExp>
#include "addressvalidator.h"
#include "valuevalidator.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<MemoryInitFile>("MemoryInitialization",1,0,"MemoryInitFile");
    qmlRegisterType<MemoryChunk>("MemoryInitialization", 1, 0, "MemoryChunk");
    qmlRegisterType<ChunkData>("MemoryInitialization", 1, 0, "ChunkData");
    QQmlApplicationEngine engine;

    MemoryInitFile  active_file(&app);
    QRegExp   regexp("[0-9abcdef]*");
    QRegExp   regexp2("[0-9]*");
    AddressValidator valid(&active_file,&app);
    ValueValidator   valid2(&active_file, &app);
    valid.setRegExpression(regexp);
    valid2.setRegExpression(regexp2);
    engine.rootContext()->setContextProperty("MemoryFileEngine",&active_file);
    engine.rootContext()->setContextProperty("AddressValidator",&valid);
    engine.rootContext()->setContextProperty("ValueValidator",&valid2);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
