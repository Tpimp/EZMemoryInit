#include "memoryinitfile.h"
#include <QDebug>
#include <QUrl>
#include <QFile>
#include <QStringList>

MemoryInitFile::MemoryInitFile(QObject *parent) : QObject(parent)
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

long MemoryInitFile::getAddressLong(QString & addr)
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

QString MemoryInitFile::getAddressString(long addr)
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
    return QString::number(addr,base);

}
long MemoryInitFile::getValueLong(QString & value)
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

MemoryChunk* MemoryInitFile::currentChunk()
{
    return mCurrentChunk;
}

QString MemoryInitFile::getValueString(long value)
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
    return QString::number(value,base);

}


void MemoryInitFile::parseInputFile(QUrl &file)
{
  QString file_path(file.toLocalFile());
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
  for(int index(0); index < lines_in_file.length(); index++)
  {
      QString current_line(lines_in_file.at(index));
      if(current_line.length() == 0) //empty line
          continue;
      switch(current_state)
      {
        case NAME:{
            mName = current_line.replace("--","");
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
                                got_depth = true;
                            }
                            else
                            {
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
                                got_dradix = true;
                            }
                            else
                            {
                                qDebug() << "Looking for  Header [DATA_RADIX] and found " << current_line;

                            }
                        }
                        else
                        {
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
                            got_width = true;
                        }
                        else
                        {
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
                            got_aradix = true;
                        }
                        else
                        {
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
                    current_chunk = new MemoryChunk();
                    current_chunk->setName(current_line.replace("%",""));
                }
                else
                {
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
                        current_chunk->setStartAddress(start_address);
                    }
                    else
                        qDebug() << "No Start Address. @ Line: " << index;
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
                        current_chunk->setEndAddress(end_address);
                    }
                    else
                        qDebug() << "No End Address. @ Line: " << index;
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
                        qDebug() << "No Purpose. @ Line: " << index;
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
                        qDebug() << "No Color. @ Line: " << index;
                    break;
                }
                default: qDebug() << "Invalid Chunk Header Item. @ Line: " << current_line;
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
            qDebug() << "Invalid line parsed " << current_line;
            break;
         }
      }

  }
  emit chunksChanged(chunks());
}

void MemoryInitFile::setCurrentChunk(int index)
{
    MemoryChunk * chunk(nullptr);
    if(mChunks.length()> index && index >= 0)
        chunk = mChunks.at(index);
    if(mCurrentChunk != chunk)
    {
        mCurrentChunk = chunk;
        emit currentChunkChanged(chunk);
    }
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
            long current_address(getAddressLong(chunk->mStartAddr));
            long end_address(getAddressLong(chunk->mEndAddr));
            int length_end_addr(chunk->mEndAddr.length());
            int index;
            while(current_address <= end_address)
            {
                buffer = "";

                if(chunk->containsAddress(current_address,index))
                {
                    ChunkData * data = chunk->mData.at(index);
                    long value(data->mValue);
                    QString comment(data->mComment);
                    QString addr_str(getAddressString(current_address));
                    int zeroes_to_add(length_end_addr-addr_str.length());
                    QString zeroes('0');
                    addr_str.prepend(zeroes.repeated(zeroes_to_add));
                    buffer.append(addr_str);
                    buffer.append(" : ");
                    QString value_str(getValueString(value));
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

