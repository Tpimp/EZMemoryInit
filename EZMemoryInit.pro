TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    memorychunk.cpp \
    memoryinitfile.cpp


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

RESOURCES += \
    qml.qrc

DISTFILES += \
    MemoryFileDialog.qml \
    MemoryChunkDelegate.qml

HEADERS += \
    memorychunk.h \
    memoryinitfile.h

CONFIG += c++11
