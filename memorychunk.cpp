#include "memorychunk.h"



MemoryChunk::MemoryChunk(QString name, QString startaddr, QString endaddress, QString purpose, QString color)
    : QObject(nullptr), mName(name), mStartAddr(startaddr), mEndAddr(endaddress), mPurpose(purpose), mColor(color)
{

}

void MemoryChunk::addValueAt(QString address, QString value, QString comment)
{
    mData.insert(address,QPair<QString,QString>(value,comment));
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

void MemoryChunk::removeValueAt(QString address)
{
    mData.remove(address);
}

MemoryChunk::~MemoryChunk()
{

}
