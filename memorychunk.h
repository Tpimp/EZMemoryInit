#ifndef MEMORYCHUNK_H
#define MEMORYCHUNK_H

#include <QObject>
#include <QHash>
#include <QPair>
#include <QtQml>
          // Data Value, USER Comment
//Q_DECLARE_METATYPE(MEMVALUE)
class MemoryInitFile;


class ChunkData :public QObject
{

    Q_OBJECT // Define QObject Property Bag
    Q_PROPERTY(long address MEMBER mAddress NOTIFY addressChanged)
    Q_PROPERTY(long value MEMBER mValue NOTIFY valueChanged)
    Q_PROPERTY(QString comment MEMBER mComment NOTIFY commentChanged)

public:
    long mAddress;
    long mValue;
    QString mComment;
    long address()
    {
        return mAddress;
    }
    long value()
    {
        return mValue;
    }
    QString comment()
    {
        return mComment;
    }

    ChunkData(long address = -1, long value = 0,
              QString comment = "",QObject * parent = nullptr)
        :QObject(parent), mAddress(address),mValue(value),
         mComment(comment){}


signals:
    void addressChanged(long address);
    void valueChanged(long value);
    void commentChanged(QString comment);

public slots:
    void setAddress(long address)
    {
        if(mAddress != address)
        {
            mAddress = address;
            emit addressChanged(address);
        }
    }
    void setValue(long value)
    {
        if(mValue != value)
        {
            mValue = value;
            emit valueChanged(value);
        }
    }

    void setComment(QString comment)
    {
        if(mComment != comment)
        {
            mComment = comment;
            emit commentChanged(comment);
        }
    }


};


class MemoryChunk : public QObject
{
    Q_OBJECT
    // declare properties to expose to Qt MOC system
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(long startAddress MEMBER mStartAddr NOTIFY startAddressChanged)
    Q_PROPERTY(long endAddress MEMBER mEndAddr NOTIFY endAddressChanged)
    Q_PROPERTY(QString purpose READ purpose WRITE setPurpose NOTIFY purposeChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QQmlListProperty<ChunkData> addresses READ addresses NOTIFY addressesChanged)
    friend class MemoryInitFile;

public:
    explicit MemoryChunk(QString name = "", long startaddr = 0, long endaddress = 0, QString purpose = "",
                         QString color = "black", QObject *parent = nullptr);

    QString name()
    {
        return mName;
    }

    QString purpose()
    {
        return mPurpose;
    }
    QString color()
    {
        return mColor;
    }
    long endAddress()
    {
        return mEndAddr;
    }
    long startAddress()
    {
        return mStartAddr;
    }

    bool containsAddress(long address, int & index);
    QQmlListProperty<ChunkData> addresses();
    Q_INVOKABLE QQmlListProperty<ChunkData> getNullList();
    ~MemoryChunk();

signals:
    void nameChanged(QString name);
    void startAddressChanged(long startaddress);
    void endAddressChanged(long endAddress);
    void purposeChanged(QString purpose);
    void colorChanged(QString color);
    void addressValueAdded(long address, long value, QString comment);
    void addressValueRemoved(long address);

    void addressesChanged();

public slots:
    void setName(const QString & name);
    void setStartAddress(long  startaddress);
    void setEndAddress(long endaddress);
    void setPurpose(const QString & purpose);
    void setColor(const QString & color);
    void addValueAt(long address, long value, QString comment);
    bool removeValueAt(long address);
    void updateValueAt(long address, long value, QString comment);
private:
    // Header information
    QString   mName;
    long      mStartAddr;
    long      mEndAddr;
    QString   mPurpose;
    QString   mColor;
    // Data <ADDRESS, <DATA,COMMENT>>
    QList<ChunkData *>    mData;
    void deepCopyDataChunks(MemoryChunk * chunkToCopy);

};


#endif // MEMORYCHUNK_H
