#include "addressvalidator.h"

AddressValidator::AddressValidator(MemoryInitFile *memory_file, QObject *parent):
    QValidator(parent), mFileEngine(memory_file)
{

}

void AddressValidator::setRegExpression(QRegExp &expression)
{
    mExpression = expression;
}

QValidator::State AddressValidator::validate(QString &input, int&pos) const
{
    if(mExpression.exactMatch(input))
    {
        if(mFileEngine->currentChunk())
        {
            long address(mFileEngine->getAddressLong(input));
            if(input.isEmpty())
            {
                input = "0";
                return QValidator::Acceptable;
            }
            if(pos == mFileEngine->getAddressString(mFileEngine->currentChunk()->endAddress()).length())
            {
                if((mFileEngine->currentChunk()->endAddress()+1) >= address &&
                   mFileEngine->currentChunk()->startAddress() <= address)
                {
                    return QValidator::Acceptable;
                }
                else
                {
                    return QValidator::Invalid;
                }
            }
            else
            {
                if((mFileEngine->currentChunk()->endAddress()+1) >= address &&
                   0 <= address)
                {
                    return QValidator::Acceptable;
                }
                else
                {
                    return QValidator::Invalid;
                }
            }
        }
        else
        {
           return QValidator::Acceptable;
        }
    }
    return QValidator::Invalid;
}
