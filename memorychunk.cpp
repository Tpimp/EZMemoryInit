#include "memorychunk.h"
#include "memoryinitfile.h"


MemoryChunk::MemoryChunk(QString name, QString startaddr, QString endaddress, QString purpose, QString color)
    : QObject(nullptr), mName(name), mStartAddr(startaddr), mEndAddr(endaddress), mPurpose(purpose), mColor(color)
{

}

void MemoryChunk::addValueAt(long address, long value, QString comment)
{
    ChunkData* data(new ChunkData(address,value,comment,this));
    mData.append(data);

}




QQmlListProperty<ChunkData> MemoryChunk::addresses()
{
    return QQmlListProperty<ChunkData>(this,mData);
}

bool MemoryChunk::containsAddress(long address, int &index)
{
    bool found(false);
    for(index = 0; index < mData.length(); index++)
    {
        if(mData.at(index)->mAddress == address)
        {
            found = true;
            break;
        }
    }
    if(!found)
        index = -1;
    return found;
}
void MemoryChunk::setColor(const QString &color)
{
    mColor = color;
}

void MemoryChunk::setEndAddress(const QString &endaddress)
{
    mEndAddr = endaddress;
}

void MemoryChunk::setName(const QString &name)
{
    mName = name;
}
void MemoryChunk::setPurpose(const QString &purpose)
{
    mPurpose = purpose;
}

void MemoryChunk::setStartAddress(const QString &startaddress)
{
    mStartAddr = startaddress;
}

void MemoryChunk::removeValueAt(long address)
{
    ChunkData * ptr(nullptr);
    foreach(ChunkData * data, mData)
    {
        if(data->mAddress == address)
        {
            ptr = data;
            break;
        }
    }
    if(ptr)
    {
        mData.removeOne(ptr);
        delete ptr;
    }
    else
    {
        qDebug() << "Did not find memory data for address: " << address;
    }
}

MemoryChunk::~MemoryChunk()
{
    while(!mData.isEmpty())
    {
       ChunkData * ptr(mData.takeFirst());
       delete ptr;
    }
}

