#ifndef ADDRESSVALIDATOR_H
#define ADDRESSVALIDATOR_H

#include <QObject>
#include <QValidator>
#include <QRegExp>
#include "memoryinitfile.h"
class AddressValidator : public QValidator
{
    Q_OBJECT
    Q_PROPERTY(long minAddress MEMBER mMinAddress NOTIFY minAddressChanged)
    Q_PROPERTY(long maxAddress MEMBER mMaxAddress NOTIFY maxAddressChanged)

signals:
    void minAddressChanged(long min_address);
    void maxAddressChanged(long max_address);
public:
    explicit AddressValidator(MemoryInitFile * memory_file,QObject * parent = 0);
    QValidator::State validate(QString &input, int &pos) const;
    void setRegExpression(QRegExp & expression);

private:
    MemoryInitFile * mFileEngine;
    QRegExp     mExpression;
    long mMaxAddress;
    long mMinAddress;

};

#endif // ADDRESSVALIDATOR_H
