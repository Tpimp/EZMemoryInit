#ifndef MEMORYCHUNK_H
#define MEMORYCHUNK_H

#include <QObject>
#include <QHash>
#include <QPair>
#include <QtQml>
          // Data Value, USER Comment
typedef   QPair<QString,QString> MEMVALUE;

Q_DECLARE_METATYPE(MEMVALUE)
class MemoryInitFile;

class MemoryChunk : public QObject
{
    Q_OBJECT
    // declare properties to expose to Qt MOC system
    Q_PROPERTY(QString Name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString StartAddr READ startAddress WRITE setStartAddress NOTIFY startAddressChanged)
    Q_PROPERTY(QString EndAddr READ endAddress WRITE setEndAddress NOTIFY endAddressChanged)
    Q_PROPERTY(QString Purpose READ purpose WRITE setPurpose NOTIFY purposeChanged)
    Q_PROPERTY(QString Color READ color WRITE setColor NOTIFY colorChanged)
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
    void addressValueAdded(QString address, QString value, QString comment);
    void addressValueRemoved(QString address);

public slots:
    void setName(const QString & name);
    void setStartAddress(const QString & startaddress);
    void setEndAddress(const QString & endaddress);
    void setPurpose(const QString & purpose);
    void setColor(const QString & color);
    void addValueAt(QString address, QString value, QString comment);
    void removeValueAt(QString address);

private:
    // Header information
    QString   mName;
    QString   mStartAddr;
    QString   mEndAddr;
    QString   mPurpose;
    QString   mColor;

    // Data <ADDRESS, <DATA,COMMENT>>
    QHash<QString,MEMVALUE>    mData;

};
//Q_DECLARE_METATYPE(MemoryChunk)
//qmlRegisterType<MemoryChunk>("com.memoryinit.memorychunk", 1, 0, "MemoryChunkData");


#endif // MEMORYCHUNK_H
