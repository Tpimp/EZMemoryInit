#include "memorychunk.h"
#include "memoryinitfile.h"


MemoryChunk::MemoryChunk(QString name, long startaddr, long endaddress, QString purpose, QString color, QObject * parent)
    : QObject(parent), mName(name), mStartAddr(startaddr), mEndAddr(endaddress), mPurpose(purpose), mColor(color)
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

void MemoryChunk::deepCopyDataChunks(MemoryChunk *chunkToCopy)
{
    foreach(ChunkData * data, chunkToCopy->mData)
    {
        ChunkData * temp = new ChunkData(data->mAddress,data->mValue, data->mComment,this);
        this->mData.append(temp);
    }
}

QQmlListProperty<ChunkData> MemoryChunk::getNullList()
{
     QList<ChunkData*> null_list;
     return QQmlListProperty<ChunkData>(this,null_list);
}

void MemoryChunk::setColor(const QString &color)
{
    mColor = color;
}

void MemoryChunk::setEndAddress(long endaddress)
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

void MemoryChunk::setStartAddress(long startaddress)
{
    mStartAddr = startaddress;
}

bool MemoryChunk::removeValueAt(long address)
{
    ChunkData * ptr(nullptr);
    bool removed(false);
    int index(0);
    foreach(ChunkData * data, mData)
    {
        if(data->mAddress == address)
        {
            ptr = data;
            break;
        }
        index++;
    }
    if(ptr)
    {
        ptr = mData.takeAt(index);
        ptr->deleteLater();
        removed = true;
        while(index < mData.length())
        {
            ptr = mData.at(index);
            ptr->mAddress -= 1;
            index++;
        }
        if(mEndAddr != 0)
            mEndAddr -= 1;
        emit addressesChanged();
        emit endAddressChanged(mEndAddr);
    }
    else
    {
        qDebug() << "Did not find memory data for address: " << address;
    }
    return removed;
}

MemoryChunk::~MemoryChunk()
{
    while(!mData.isEmpty())
    {
       ChunkData * ptr(mData.takeFirst());
       delete ptr;
    }
    mData.clear();
}

