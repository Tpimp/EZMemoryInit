#include "memoryinitfile.h"
#include <QDebug>
#include <QUrl>
#include <QFile>
#include <QStringList>

MemoryInitFile::MemoryInitFile(QObject *parent) : QObject(parent),
    mPadLength(2), mCurrentChunk(nullptr),mAddrRadix("HEX"),mDataRadix("HEX")
{

}

void MemoryInitFile::loadFile(QString filepath)
{
    qDebug()  << filepath;
    QUrl    file(filepath);
    if(file.isLocalFile())
    {
        qDebug() <<"Valid file found at " << file.path();
        parseInputFile(file);

    }
}

void MemoryInitFile::addChunkDataAt(long address, long value, QString comment)
{
    ChunkData *data(new ChunkData(address,value,comment,mCurrentChunk));
    if(address > mCurrentChunk->mEndAddr) // append
    {
        mCurrentChunk->mData.append(data);
        mCurrentChunk->mEndAddr += 1;
        emit mCurrentChunk->addressesChanged();
    }
    else
    {   // find chunk index
        int chunk_index(-1);
        for(int chunks_index(0); chunks_index < mChunks.length(); chunks_index++)
        {
            if(mChunks.at(chunks_index)->mStartAddr == mCurrentChunk->mStartAddr)
            {
                chunk_index = chunks_index;
                break;
            }
        }
        if(chunk_index != -1)
        {
            if(address == mCurrentChunk->mStartAddr) // prepend
            {
                mCurrentChunk->mData.prepend(data);
                rippleUpdateCurrent(0,chunk_index,1);
                emit mCurrentChunk->addressesChanged();
            }
            else // else insert
            {
                // find location to insert
                for(int index(0); index < mCurrentChunk->mData.length(); index++)
                {
                    ChunkData * data_at(mCurrentChunk->mData.at(index));
                    if(data_at->mAddress > address )
                    {
                       int insert_at (index-1);
                       mCurrentChunk->mData.insert(insert_at,data);
                       rippleUpdateCurrent(index,chunk_index, 1);
                       emit mCurrentChunk->addressesChanged();
                       break;
                    }
                }
            }

        }// else chunk not found
    }
}

QQmlListProperty<MemoryChunk> MemoryInitFile::chunks()
{
    return QQmlListProperty<MemoryChunk>(this, mChunks);
}




/*void MemoryInitFile::appendToList(QQmlListProperty<MemoryChunk> *list, MemoryChunk *chunk)
{
    MemoryInitFile *memoryFile = qobject_cast<MemoryInitFile*>(list->object);
    if(chunk)
        memoryFile->mChunks.append(chunk);
    else
        qDebug() <<"Attempted to append bad memory chunk";
}


void MemoryInitFile::clearChunks(QQmlListProperty<MemoryChunk> *list)
{
    MemoryInitFile *memoryFile = qobject_cast<MemoryInitFile*>(list->object);
    while(!memoryFile->mChunks.isEmpty())
        delete memoryFile->mChunks.takeFirst();
}

int MemoryInitFile::chunkCount(QQmlListProperty<MemoryChunk> *list)
{
    MemoryInitFile *memoryFile = qobject_cast<MemoryInitFile*>(list->object);
    return memoryFile->mChunks.count();
}

MemoryChunk* MemoryInitFile::valueAt(QQmlListProperty<MemoryChunk> *list, int index)
{
    MemoryInitFile *memoryFile = qobject_cast<MemoryInitFile*>(list->object);
    if(index > 0 && index < memoryFile->mChunks.length())
        return memoryFile->mChunks.at(index);
    else
        qDebug() <<"Attempted to fetch bad memory chunk index";
    return nullptr;
}

*/


void MemoryInitFile::chunkEndAddressChange(long new_end_address)
{
    if( mCurrentChunk->mEndAddr != new_end_address)
    {
        mCurrentChunk->mEndAddr = new_end_address;
        emit endAddressChanged(new_end_address);
    }

}


MemoryChunk* MemoryInitFile::currentChunk()
{
    return mCurrentChunk;
}

void MemoryInitFile::rippleUpdateCurrent(int start_index, int chunk_index, int value)
{
    if(chunk_index != 0)
        mCurrentChunk->setStartAddress(mCurrentChunk->mStartAddr + value);
    mCurrentChunk->setEndAddress(mCurrentChunk->mEndAddr + value);
    ChunkData *   current_data(nullptr);
    for(int index(start_index); index < mCurrentChunk->mData.length(); index++)
    {
        current_data = mCurrentChunk->mData.at(index);
        current_data->setAddress(current_data->mAddress + value);
    }
    emit endAddressChanged(mCurrentChunk->mEndAddr);
}

void MemoryInitFile::rippleUpdateAddresses(int start_index, int chunk_index, int value)
{
    if(chunk_index < mChunks.length())
    {
        MemoryChunk * current_chunk = mChunks.at(chunk_index);
        if(chunk_index != 0)
            current_chunk->setStartAddress(current_chunk->mStartAddr + value);
        current_chunk->setEndAddress(current_chunk->mEndAddr + value);
        ChunkData *   current_data(nullptr);
        for(int index(start_index); index < current_chunk->mData.length(); index++)
        {
            current_data = current_chunk->mData.at(index);
            current_data->setAddress(current_data->mAddress + value);
        }
        rippleUpdateAddresses(0, chunk_index+1,value);
    }
}

void MemoryInitFile::discardChangesToCurrentChunk()
{
    if(mCurrentChunk)
    {
        delete mCurrentChunk;
        mCurrentChunk = nullptr;
        emit currentChunkChanged(mCurrentChunk);
    }
}

long MemoryInitFile::getAddressLong(QString  addr)
{
    int base(10);
    switch(mAddrRadix.at(0).toLatin1())
    {
        case 'O':// octal
        {
            base = 7;
            break;
        }
        case 'D': // decimal
        {
            base = 10;
            break;
        }
        case 'B': // Binary
        {
            base = 2;
            break;
        }
        case 'H': // hex
        {
            base = 16;
            break;
        }
        default: break;
    }
    bool value_converted(false);
    long new_addr(addr.toLong(&value_converted,base));
    if(!value_converted)
        new_addr = -1;
    return new_addr;


}

QString MemoryInitFile::getAddressString(long addr, int pad_length)
{
    int base(10);
    switch(mAddrRadix.at(0).toLatin1())
    {
        case 'O':// octal
        {
            base = 7;
            break;
        }
        case 'D': // decimal
        {
            base = 10;
            break;
        }
        case 'B': // Binary
        {
            base = 2;
            break;
        }
        case 'H': // hex
        {
            base = 16;
            break;
        }
        default: break;
    }
    QString output_str(QString::number(addr,base));
    if(pad_length > 0)
        if(pad_length > output_str.length())
        {
            QString zero('0');
            output_str.prepend(zero.repeated(pad_length - output_str.length()));
        }
    return output_str;

}
long MemoryInitFile::getValueLong(QString  value)
{
    int base(10);
    switch(mDataRadix.at(0).toLatin1())
    {
        case 'O':// octal
        {
            base = 7;
            break;
        }
        case 'D': // decimal
        {
            base = 10;
            break;
        }
        case 'B': // Binary
        {
            base = 2;
            break;
        }
        case 'H': // hex
        {
            base = 16;
            break;
        }
        default: break;
    }
    bool value_converted(false);
    long new_addr(value.toLong(&value_converted,base));
    if(!value_converted)
        new_addr = -1;
    return new_addr;
}


QString MemoryInitFile::getValueString(long value, int pad_length)
{
    int base(10);
    switch(mDataRadix.at(0).toLatin1())
    {
        case 'O':// octal
        {
            base = 7;
            break;
        }
        case 'D': // decimal
        {
            base = 10;
            break;
        }
        case 'B': // Binary
        {
            base = 2;
            break;
        }
        case 'H': // hex
        {
            base = 16;
            break;
        }
        default: break;
    }
    QString output_str(QString::number(value,base));
    if(pad_length > 0)
        if(pad_length > output_str.length())
        {
            QString zero('0');
            output_str.prepend(zero.repeated(pad_length - output_str.length()));
        }
    return  output_str;

}



void MemoryInitFile::parseInputFile(QUrl &file)
{
  QString file_path(file.toLocalFile());
  file_path = QDir::toNativeSeparators(file_path);
  QFile input_file(file_path);
  input_file.open(QFile::ReadOnly | QFile::Text);
  QString inputBuffer(input_file.readAll());
  QStringList lines_in_file(inputBuffer.split("\n"));
  MEMORY_INIT_FILE_PARSE_STATE current_state(NAME);
  MemoryChunk * current_chunk;
  bool got_depth(false);
  bool got_width(false);
  bool got_aradix(false);
  bool got_dradix(false);
  bool looking_for_content(false);
  bool looking_for_begin(false);
  bool errored(false);
  for(int index(0); index < lines_in_file.length(); index++)
  {
      QString current_line(lines_in_file.at(index));
      if(current_line.length() == 0) //empty line
          continue;
      switch(current_state)
      {
        case NAME:{
            mName = current_line.replace("--","");
            emit fileNameChanged(mName);
            current_state = HEADER;
            break;
        }
        case HEADER:
        {
            if(!looking_for_content)
            {
                switch(current_line.at(0).toLatin1())
                {
                    case 'D':
                    {
                        if(current_line.at(1).toLatin1() == 'E')
                        {
                            QStringList depth_list(current_line.split('='));
                            if(depth_list.length() > 1 )
                            {
                                QString depth_value(depth_list.at(1));
                                depth_value = depth_value.replace(" ","");
                                depth_value = depth_value.split(";")[0];
                                mDepth = depth_value;
                                emit memoryDepthChanged(mDepth);
                                got_depth = true;
                            }
                            else
                            {
                                errored = true;
                                qDebug() << "Looking for Header [Depth] and found " << current_line;
                            }
                        }
                        else if(current_line.at(1).toLatin1() == 'A')
                        {

                            QStringList data_radix_list(current_line.split('='));
                            if(data_radix_list.length() > 1 )
                            {
                                QString d_radix_value(data_radix_list.at(1));
                                // pull comment out
                                d_radix_value = d_radix_value.replace(" ","");
                                d_radix_value = d_radix_value.split(";")[0];
                                mDataRadix = d_radix_value;
                                emit dataRadixChanged(mDataRadix);
                                got_dradix = true;
                            }
                            else
                            {
                                errored = true;
                                qDebug() << "Looking for  Header [DATA_RADIX] and found " << current_line;

                            }
                        }
                        else
                        {
                            errored = true;
                            qDebug() << "Looking for  Header [D] and found " << current_line;
                        }
                        break;
                    }
                    case 'W':
                    {
                        QStringList width_list(current_line.split('='));
                        if(width_list.length() > 1 )
                        {
                            QString width_value(width_list.at(1));
                            // pull comment out
                            width_value = width_value.replace(" ","");
                            width_value = width_value.split(";")[0];
                            mWidth = width_value;
                            emit memoryWidthChanged(mWidth);
                            got_width = true;
                        }
                        else
                        {
                            errored = true;
                            qDebug() << "Looking for  Header [WIDTH] and found " << current_line;
                        }
                        break;
                    }
                    case 'A':
                    {
                        QStringList addr_radix_list(current_line.split('='));
                        if(addr_radix_list.length() > 1 )
                        {
                            QString a_radix_value(addr_radix_list.at(1));
                            // pull comment out
                            a_radix_value = a_radix_value.replace(" ","");
                            a_radix_value = a_radix_value.split(";")[0];
                            mAddrRadix = a_radix_value;
                            emit addressRadixChanged(mAddrRadix);
                            got_aradix = true;
                        }
                        else
                        {
                            errored = true;
                            qDebug() << "Looking for  Header [ADDRESS_RADIX] and found " << current_line;
                        }
                        break;
                    }
                    case 'C':
                    {
                        if(current_line.compare("CONTENT")== 0)
                        {
                            qDebug() << "Error found CONTENT before received all HEADER info";
                            mName = "";
                            mWidth = "";
                            mDepth = "";
                            mDataRadix = "";
                            mAddrRadix = "";
                            return; // stop parsing before allocating any memory
                        }
                        break;
                    }
                    case 'B':
                    {
                        if(current_line.compare("BEGIN")== 0)
                        {
                            errored = true;
                            qDebug() << "Error found BEGIN before received all HEADER info, and before CONTENT found";
                            mName = "";
                            mWidth = "";
                            mDepth = "";
                            mDataRadix = "";
                            mAddrRadix = "";
                            return; // stop parsing before allocating any memory
                        }
                        break;
                    }
                    default:        break;
                }
            }
            if(got_depth && got_aradix && got_dradix && got_width)
            {
                if(!looking_for_begin)
                {
                    looking_for_content = true;
                    if(current_line.startsWith("CONTENT"))
                    {
                        looking_for_begin = true;
                    }
                }
                else // looking for begin to start content
                {
                    if(current_line.startsWith("BEGIN"))
                    {
                        current_state = CONTENT;
                    }
                    else // still looking for begin
                    {

                    }
                }

            }
            break;
         }
         case CONTENT: // looking for comment header blocks
         {
            if(current_line.compare("END;") == 0)
            {
                // Reached end
                index = lines_in_file.length();
                break;
            }
            else // Not reached end, look for next chunk
            {
                if(current_line.at(0).toLatin1() == '%')
                {
                    current_state = CHUNK_HEADER;
                    current_chunk = new MemoryChunk("",0,0,"","black",this);
                    current_chunk->setName(current_line.replace("%",""));
                }
                else
                {
                    errored = true;
                    qDebug() << "Looking for Chunk Header and found " << current_line;
                }
            }
            break;
         }
         case CHUNK_HEADER:
         {
            switch(current_line.at(0).toLower().toLatin1())
            {
                case '%': // reached end of Header block
                {
                    mChunks.append(current_chunk);
                    current_state = CHUNK_DATA;
                    break;
                }
                case 's':
                {
                    QStringList start_addr_list(current_line.split(':'));
                    if(start_addr_list.length() > 1)
                    {
                        QString start_address(start_addr_list.at(1));
                        start_address = start_address.section("\"",0,1);
                        start_address.replace("\"","");
                        current_chunk->setStartAddress(getAddressLong(start_address));
                    }
                    else
                    {
                        errored = true;
                        qDebug() << "No Start Address. @ Line: " << index;
                    }
                    break;
                }
                case 'e':
                {
                    QStringList end_addr_list(current_line.split(':'));
                    if(end_addr_list.length() > 1)
                    {

                        QString end_address(end_addr_list.at(1));
                        end_address = end_address.section("\"",0,1);
                        end_address.replace("\"","");
                        if(end_address.length() > mPadLength)
                            mPadLength = end_address.length();
                        current_chunk->setEndAddress(getAddressLong(end_address));
                    }
                    else
                    {
                        errored = true;
                        qDebug() << "No End Address. @ Line: " << index;
                    }
                    break;
                }
                case 'p':
                {
                    QStringList purpose_list(current_line.split(':'));
                    if(purpose_list.length() > 1)
                    {
                        QString purpose(purpose_list.at(1));
                        purpose = purpose.section("\"",0,1);
                        purpose.replace("\"","");
                        current_chunk->setPurpose(purpose);
                    }
                    else
                    {
                        errored = true;
                        qDebug() << "No Purpose. @ Line: " << index;
                    }
                    break;
                }
                case 'c':
                {
                    QStringList color_list(current_line.split(':'));
                    if(color_list.length() > 1)
                    {
                        QString color(color_list.at(1));
                        color = color.section("\"",0,1);
                        color.replace("\"","");
                        current_chunk->setColor(color);
                    }
                    else
                    {
                        errored = true;
                        qDebug() << "No Color. @ Line: " << index;
                    }
                    break;
                }
                default:
                errored = true; qDebug() << "Invalid Chunk Header Item. @ Line: " << current_line;
            }
            break;
         }
         case CHUNK_DATA:
         {
            if(current_line.at(0).toLatin1() != '-') // if not, then another Data value
            {
                QStringList mem_value_list(current_line.split(':'));
                if(mem_value_list.length() > 1)
                {
                    QStringList value_list(mem_value_list.at(1).split("--"));
                    if(value_list.length() > 1)
                    {
                        // first is value second is comment
                        QString address(mem_value_list.at(0));
                        address = address.replace(" ",""); // remove spaces
                        address = address.toLower();
                        // could test Address for validity of format (add in future versions)
                        QString value(value_list.at(0));
                        value = value.split(";")[0];
                        value = value.toLower();
                        QString comment(value_list.at(1));
                        current_chunk->addValueAt(getAddressLong(address),getValueLong(value),comment);
                    }
                    else // no comment (not an error)
                    {
                        // first is value second is comment
                        QString address(mem_value_list.at(0));
                        address = address.replace(" ",""); // remove spaces
                        // could test Address for validity of format (add in future versions)
                        QString value(value_list.at(0));
                        value = value.split(";")[0];
                        current_chunk->addValueAt(getAddressLong(address),getValueLong(value), "");
                    }
                }
                else
                {
                    errored = true;
                    qDebug() << "Bad Memory Value parsed @ Line: " << index;
                }
            }
            else // Reached END of current CHUNK_DATA
            {
                current_state  = CONTENT;
            }
            break;
         }
         default:
         {
            errored = true;
            qDebug() << "Invalid line parsed " << current_line;
            break;
         }
      }

  }
  if(!errored)
  {
      QString filename(file_path);
      int last_index(filename.lastIndexOf(QDir::separator()));
      filename.remove(0,last_index+1);
      emit fileLoadedSuccesfully(filename);
      emit chunksChanged();
  }
}


void MemoryInitFile::removeChunkAt(long address)
{
    mCurrentChunk->removeValueAt(address);
}

void MemoryInitFile::saveChangesToCurrentChunk(int index)
{
    if(mCurrentChunk) // replace old with current
    {
        MemoryChunk * chunk(nullptr);
        if(mChunks.length()> index && index >= 0)
        {
            chunk = mChunks.takeAt(index);
        }
        if(chunk)
        {
            mChunks.insert(index,mCurrentChunk);
            long address_difference(mCurrentChunk->mEndAddr - chunk->mEndAddr);
            rippleUpdateAddresses(0,index+1,int(address_difference));
            mCurrentChunk = nullptr;
            delete chunk;
            emit chunksChanged();
        }
        else
        {
            qDebug() << "Warning: Could not find existing chunk???";
            mChunks.insert(index,mCurrentChunk);
            emit chunksChanged();
        }
    }
}

void MemoryInitFile::setCurrentChunk(int index)
{
    MemoryChunk * chunk(nullptr);
    if(index < 0)
    {
        if(mCurrentChunk)
        {
            delete mCurrentChunk;
            mCurrentChunk = nullptr;
            emit currentChunkChanged(mCurrentChunk);
        }
    }
    else
    {
        if(mChunks.length()> index && index >= 0)
            chunk = mChunks.at(index);
        if(mCurrentChunk != chunk)
        {
            mCurrentChunk = new MemoryChunk(chunk->mName,chunk->mStartAddr,chunk->mEndAddr,chunk->mPurpose,chunk->mColor,this);
            mCurrentChunk->deepCopyDataChunks(chunk);
            //mCurrentChunk = chunk;
            emit currentChunkChanged(mCurrentChunk);
        }
    }
}


void MemoryInitFile::setCurrentChunkColor(QString color)
{
    mCurrentChunk->mColor = color;
}


void MemoryInitFile::setCurrentChunkName(QString name)
{
    mCurrentChunk->mName = name;
}

void MemoryInitFile::setCurrentChunkPurpose(QString purpose)
{
    mCurrentChunk->mPurpose = purpose;
}

void MemoryInitFile::writeFile(QString filepath)
{
    bool generate_file(false);
    QString converted_file_path = QDir::toNativeSeparators(filepath);
    if(QFile::exists(converted_file_path))
    {
        // file already exists pop overwrite notice?

    }
    else
    {
        // create it
        generate_file = true;
    }
    if(generate_file)
    {
        QFile  output_file(converted_file_path);
        output_file.setFileName(converted_file_path);
        qDebug() << "Set filename to " << output_file.fileName();
        if(!output_file.open(QIODevice::WriteOnly | QIODevice::Text))
            return;

        // convert to QByteArray
        QByteArray buffer("--");
        buffer.append(mName);
        buffer.append("\n\n");// write name
        output_file.write(buffer);
        buffer = "DEPTH = ";
        buffer.append(mDepth);
        buffer.append(";                 --The size of the memory in words\n");
        output_file.write(buffer);
        buffer = "WIDTH = ";
        buffer.append(mWidth);
        buffer.append(";                 --The size of data in bits\n");
        output_file.write(buffer);
        buffer = "ADDRESS_RADIX = ";
        buffer.append(mAddrRadix);
        buffer.append(";                 --The radix for address values\n");
        output_file.write(buffer);
        buffer = "DATA_RADIX = ";
        buffer.append(mDataRadix);
        buffer.append(";                 --The radix for data values\n");
        output_file.write(buffer);
        buffer = "CONTENT\nBEGIN\n";
        output_file.write(buffer);
        // write each object and their headers
        foreach(MemoryChunk * chunk, mChunks)
        {
            // write header
            buffer = "%";
            buffer.append(chunk->mName);
            buffer.append('\n');
            buffer.append("purpose:\"");
            buffer.append(chunk->mPurpose);
            buffer.append("\"\n");
            buffer.append("startAddress:\"");
            buffer.append(chunk->mStartAddr);
            buffer.append("\"\n");
            buffer.append("endAddress:\"");
            buffer.append(chunk->mEndAddr);
            buffer.append("\"\n%\n");
            // write header (buffered)
            output_file.write(buffer);
            // assume sequential block of data (or issues with data)
            long current_address(chunk->mStartAddr);
            long end_address(chunk->mEndAddr);
            QString end_addr_str(getAddressString(chunk->mEndAddr));
            int length_end_addr(end_addr_str.length());
            int index;
            while(current_address <= end_address)
            {
                buffer = "";

                if(chunk->containsAddress(current_address,index))
                {
                    ChunkData * data = chunk->mData.at(index);
                    long value(data->mValue);
                    QString comment(data->mComment);
                    QString addr_str(getAddressString(current_address, length_end_addr));
                    buffer.append(addr_str);
                    buffer.append(" : ");
                    QString value_str(getValueString(value,length_end_addr));
                    buffer.append(value_str);
                    buffer.append(";");
                    if(!comment.isEmpty())
                    {
                        buffer.append(" --");
                        buffer.append(comment);

                    }

                    buffer.append("\n");
                    output_file.write(buffer);
                }
                current_address += 1;
            }
            buffer = "--END ";
            buffer.append(chunk->mName);
            buffer.append("\n");
            output_file.write(buffer);
        }
        buffer = "END;";
        output_file.write(buffer);
        output_file.close();
    }
}


MemoryInitFile::~MemoryInitFile()
{
    while(!mChunks.isEmpty())
    {
        MemoryChunk * chunk(mChunks.takeFirst());
        delete chunk;
    }
}

