#ifndef MEMORYCHUNK_H
#define MEMORYCHUNK_H

#include <QObject>
#include <QHash>
#include <QPair>
#include <QtQml>
          // Data Value, USER Comment
typedef   QPair<long,QString> MEMVALUE;

Q_DECLARE_METATYPE(MEMVALUE)
class MemoryInitFile;

class MemoryChunk : public QObject
{
    Q_OBJECT
    // declare properties to expose to Qt MOC system
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString startAddress READ startAddress WRITE setStartAddress NOTIFY startAddressChanged)
    Q_PROPERTY(QString endAddress READ endAddress WRITE setEndAddress NOTIFY endAddressChanged)
    Q_PROPERTY(QString purpose READ purpose WRITE setPurpose NOTIFY purposeChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    friend class MemoryInitFile;

public:
    explicit MemoryChunk(QString name = "",QString startaddr = "", QString endaddress = "", QString purpose = "",
                         QString color = "black");

    QString name()
    {
        return mName;
    }
    QString startAddress()
    {
        return mStartAddr;
    }
    QString endAddress()
    {
        return mEndAddr;
    }
    QString purpose()
    {
        return mPurpose;
    }
    QString color()
    {
        return mColor;
    }

    ~MemoryChunk();

signals:
    void nameChanged(QString name);
    void startAddressChanged(QString startaddress);
    void endAddressChanged(QString  endAddress);
    void purposeChanged(QString purpose);
    void colorChanged(QString color);
    void addressValueAdded(long address, long value, QString comment);
    void addressValueRemoved(long address);

public slots:
    void setName(const QString & name);
    void setStartAddress(const QString & startaddress);
    void setEndAddress(const QString & endaddress);
    void setPurpose(const QString & purpose);
    void setColor(const QString & color);
    void addValueAt(long address, long value, QString comment);
    void removeValueAt(long address);

private:
    // Header information
    QString   mName;
    QString   mStartAddr;
    QString   mEndAddr;
    QString   mPurpose;
    QString   mColor;

    // Data <ADDRESS, <DATA,COMMENT>>
    QHash<long,MEMVALUE>    mData;

};


#endif // MEMORYCHUNK_H
