#ifndef MEMORYINITFILE_H
#define MEMORYINITFILE_H

#include <QObject>
#include <QString>
#include "memorychunk.h"
#include <QQmlListProperty>
enum MEMORY_INIT_FILE_PARSE_STATE
{
    NAME,
    HEADER,
    CONTENT,
    CHUNK_HEADER,
    CHUNK_DATA
};


class MemoryInitFile : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<MemoryChunk> chunks READ chunks)
public:
    explicit MemoryInitFile(QObject *parent = 0);
    QQmlListProperty<MemoryChunk> chunks();
    ~MemoryInitFile();

signals:

public slots:
    void loadFile(QString filepath);
    void writeFile(QString filepath);
private:
    QString   mName;
    QString   mDepth;
    QString   mWidth;
    QString   mAddrRadix;
    QString   mDataRadix;
    QList<MemoryChunk*>   mChunks;
    // private methods
    void parseInputFile(QUrl &file);
    QString getAddressString(long addr);
    long getAddressLong(QString & addr);
    QString getValueString(long value);
    long getValueLong(QString & value);
    static void appendToList(QQmlListProperty<MemoryChunk > *list, MemoryChunk * chunk);
    static MemoryChunk * valueAt(QQmlListProperty<MemoryChunk > *list, int index);
    static int   chunkCount(QQmlListProperty<MemoryChunk > *list);
    static void  clearChunks(QQmlListProperty<MemoryChunk > *list);
};

#endif // MEMORYINITFILE_H
