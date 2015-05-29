#ifndef MEMORYINITFILE_H
#define MEMORYINITFILE_H

#include <QObject>
#include <QString>
#include "memorychunk.h"
#include <QQmlListProperty>
typedef QQmlListProperty<MemoryChunk> MemoryChunkData;
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
    Q_PROPERTY(QQmlListProperty<MemoryChunk> chunks READ chunks NOTIFY chunksChanged)
public:
    explicit MemoryInitFile(QObject *parent = 0);
    QQmlListProperty<MemoryChunk> chunks();
    ~MemoryInitFile();

signals:
    void nameChanged(long address, QString name);
    void startAddressChanged(long address, QString startaddress);
    void endAddressChanged(long address, QString  endAddress);
    void purposeChanged(long address, QString purpose);
    void colorChanged(long address, QString color);
    void addressValueAdded(long address, long value, QString comment);
    void addressValueRemoved(long address);
    void newChunkAdded(QString name, QString startAddr, QString endAddr, QString purpose);
    void chunksChanged(QQmlListProperty<MemoryChunk> list);

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
    /*static void appendToList(QQmlListProperty<MemoryChunk > *list, MemoryChunk * chunk);
    static MemoryChunk * valueAt(QQmlListProperty<MemoryChunk > *list, int index);
    static int   chunkCount(QQmlListProperty<MemoryChunk > *list);
    static void  clearChunks(QQmlListProperty<MemoryChunk > *list);*/
};

Q_DECLARE_METATYPE(QQmlListProperty<MemoryChunk>)


#endif // MEMORYINITFILE_H
