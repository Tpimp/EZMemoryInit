#include "valuevalidator.h"
#include "math.h"
ValueValidator::ValueValidator(MemoryInitFile *memory_file, QObject *parent)
    :QValidator(parent),mFileEngine(memory_file),mMinValue(0),mMaxValue(65536)
{

}

void ValueValidator::setRegExpression(QRegExp &expression)
{
    mExpression = expression;
}

QValidator::State ValueValidator::validate(QString &input, int &pos) const
{
    if(mExpression.exactMatch(input))
    {
        if(input.isEmpty())
        {
            input = "0";
            return QValidator::Acceptable;
        }
        long width(mFileEngine->getWidth().toLong());
        long max_value = (1 << width);
        long value = mFileEngine->getValueLong(input);
        if(value <= max_value)
        {
            return QValidator::Acceptable;
        }
        else
        {
           return QValidator::Invalid;
        }
    }
    return QValidator::Invalid;
}
