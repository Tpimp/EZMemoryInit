#ifndef VALUEVALIDATOR_H
#define VALUEVALIDATOR_H

#include <QObject>
#include <QValidator>
#include "memoryinitfile.h"

class ValueValidator : public QValidator
{

signals:
    void minValueChanged(long min_value);
    void maxValueChanged(long max_value);

public:
    explicit ValueValidator(MemoryInitFile * memory_file,QObject * parent = 0);
    QValidator::State validate(QString &input, int &pos) const;
    void setRegExpression(QRegExp & expression);

private:
    MemoryInitFile * mFileEngine;
    QRegExp     mExpression;
    long mMaxValue;
    long mMinValue;

};

#endif // VALUEVALIDATOR_H
