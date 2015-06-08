#include "valuevalidator.h"
#include "math.h"
ValueValidator::ValueValidator(MemoryInitFile *memory_file, QObject *parent)
    :QValidator(parent),mFileEngine(memory_file),mMinValue(0),mMaxValue(65536)
{

}

void ValueValidator::setRegExpression(QRegExp &expression)
{
    mHexExpression = expression;
}

QValidator::State ValueValidator::validate(QString &input, int &pos) const
{
    QString format(mFileEngine->getValueRadix());
    switch(format.at(0).toLatin1())
    {
        case 'H': // HEX
        {
            if(mHexExpression.exactMatch(input))
            {
                if(input.isEmpty())
                {
                    input = "0";
                    return QValidator::Acceptable;
                }
                long width(mFileEngine->getWidth().toLong());
                long max_value = (1 << width)-1;
                long value = mFileEngine->getValueLong(input);
                if(value < max_value)
                {
                    return QValidator::Acceptable;
                }
                else
                {
                   return QValidator::Invalid;
                }
            }
            break;
        }
        case 'D': // Decimal
        {
            if(mHexExpression.exactMatch(input))
            {
                if(input.isEmpty())
                {
                    input = "0";
                    return QValidator::Acceptable;
                }
                long width(mFileEngine->getWidth().toLong());
                long max_value = (1 << width)-1;
                long value = mFileEngine->getValueLong(input);
                if(value < max_value)
                {
                    return QValidator::Acceptable;
                }
                else
                {
                   return QValidator::Invalid;
                }
            }
            break;
        }
        case 'U': // Decimal
        {
            if(mHexExpression.exactMatch(input))
            {
                if(input.isEmpty())
                {
                    input = "0";
                    return QValidator::Acceptable;
                }
                long width(mFileEngine->getWidth().toLong());
                long max_value = (1 << width)-1;
                long value = mFileEngine->getValueLong(input);
                if(value < max_value)
                {
                    return QValidator::Acceptable;
                }
                else
                {
                   return QValidator::Invalid;
                }
            }
            break;
        }
        case 'O': // Decimal
        {
            if(mHexExpression.exactMatch(input))
            {
                if(input.isEmpty())
                {
                    input = "0";
                    return QValidator::Acceptable;
                }
                long width(mFileEngine->getWidth().toLong());
                long max_value = (1 << width)-1;
                long value = mFileEngine->getValueLong(input);
                if(value < max_value)
                {
                    return QValidator::Acceptable;
                }
                else
                {
                   return QValidator::Invalid;
                }
            }
            break;
        }
        default: break;
    }
    return QValidator::Invalid;
}
