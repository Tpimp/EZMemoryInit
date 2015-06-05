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
    Q_PROPERTY(MemoryChunk * currentChunk READ currentChunk NOTIFY currentChunkChanged)
    Q_PROPERTY(int padLength MEMBER mPadLength NOTIFY padLengthChanged)

public:
    explicit MemoryInitFile(QObject *parent = 0);
    QQmlListProperty<MemoryChunk> chunks();
    MemoryChunk * currentChunk();
    QString getWidth()
    {
        return mWidth;
    }
    QString getDepth()
    {
        return mDepth;
    }

    ~MemoryInitFile();

signals:
    void nameChanged(long address, QString name);
    void startAddressChanged(long startaddress);
    void endAddressChanged(long endAddress);
    void purposeChanged(long address, QString purpose);
    void colorChanged(long address, QString color);
    void addressValueAdded(long address, long value, QString comment);
    void addressValueRemoved(long address);
    void newChunkAdded(QString name, QString startAddr, QString endAddr, QString purpose);
    void chunksChanged();
    void currentChunkChanged(MemoryChunk * current_chunk);
    void fileLoadedSuccesfully(QString filename);
    void fileNameChanged(QString name);
    void memoryDepthChanged(QString depth);
    void memoryWidthChanged(QString width);
    void addressRadixChanged(QString radix);
    void dataRadixChanged(QString radix);
    void padLengthChanged(int pad_length);

public slots:
    void loadFile(QString filepath);
    void writeFile(QString filepath);
    void setCurrentChunk(int index);
    QString getAddressString(long addr, int pad_length = -1);
    long getAddressLong(QString addr);
    QString getValueString(long value, int pad_length = -1);
    long getValueLong(QString value);
    void removeChunkAt(long address);
    void addChunkDataAt(long address, long value, QString comment);
    void chunkEndAddressChange(long new_end_address);
    void saveChangesToCurrentChunk(int index);
    void discardChangesToCurrentChunk();
    void setCurrentChunkPurpose(QString purpose);
    void setCurrentChunkName(QString name);
    void setCurrentChunkColor(QString color);
private:
    QString   mName;
    QString   mDepth;
    QString   mWidth;
    QString   mAddrRadix;
    QString   mDataRadix;
    int       mPadLength;
    MemoryChunk * mCurrentChunk;
    QList<MemoryChunk*>   mChunks;
    // private methods
    void parseInputFile(QUrl &file);
    void rippleUpdateAddresses(int start_index, int chunk_index, int value);
    void rippleUpdateCurrent(int start_index, int chunk_index, int value);

    /*static void appendToList(QQmlListProperty<MemoryChunk > *list, MemoryChunk * chunk);
    static MemoryChunk * valueAt(QQmlListProperty<MemoryChunk > *list, int index);
    static int   chunkCount(QQmlListProperty<MemoryChunk > *list);
    static void  clearChunks(QQmlListProperty<MemoryChunk > *list);*/
};

Q_DECLARE_METATYPE(QQmlListProperty<MemoryChunk>)


#endif // MEMORYINITFILE_H
