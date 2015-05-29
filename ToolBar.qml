import QtQuick 2.4
import QtQuick.Controls 1.2

Row{
    Rectangle{
        border.width: 2
        border.color: "black"
        radius: height/4
        color:"grey"
        width:parent.width - controlList.width
        height: parent.height
        Text{
            id:titleText
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height/3
            color: "white"
            font.pixelSize: height *.8
            text:"Output File"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Row{
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.top: titleText.bottom
            anchors.margins: 20
            spacing:8
            height:(parent.height - titleText.height) *.55
            Rectangle{
                color:"white"
                TextField{
                    id:writePath
                    anchors.fill: parent
                    anchors.margins: 4
                    text:"C:/Documents/Stuff"
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height* .8 > width/text.length ? width/text.length:height *.8
                }
                border.color: "black"
                border.width: 4
                width:parent.width *.75
                height:parent.height
            }
            Rectangle{
                color:"blue"
                border.color: "black"
                border.width: 2
                width:parent.width *.25
                height:parent.height
                Text{
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color:"white"
                    text:"Browse..."
                    font.pixelSize: height* .45 > width/text.length ? width/text.length:height *.45
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        MemoryFileEngine.writeFile(writePath.text)
                    }
                }
            }
        }
    }
    Rectangle{
        id: controlList
        border.width: 2
        border.color: "black"
        color: "white"
        radius: 2
        width: parent.width*.2
        height: parent.height
        Column{
            anchors.fill: parent
            anchors.margins: 4
            anchors.topMargin:8
            anchors.bottomMargin:8
            spacing:10
            Row{
                anchors.left: parent.left
                anchors.right:parent.right
                height:parent.height/8
                anchors.leftMargin: 6
                Text{
                    text:"Depth"
                    width: parent.width/2
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    font.pixelSize: width/text.length
                    color:"black"
                }
                Rectangle{
                    width:parent.width/2
                    height: parent.height
                    border.color: "black"
                    border.width: 1
                    TextField{
                        id: depthText
                        anchors.fill: parent
                        validator: IntValidator{bottom:1;top:99999;}
                        placeholderText: "32"
                        text:""
                        anchors.margins: 1
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        font.pixelSize: height *.75
                        onTextChanged: {
                            if(text.length > 0)
                            {
                                memoryDepth = text;
                            }
                            else
                            {
                                memoryDepth = placeholderText;
                            }
                        }
                    }
                }
            }
            Row{
                anchors.left: parent.left
                anchors.right:parent.right
                height:parent.height/8
                anchors.leftMargin:6
                Text{
                    text:"Width"
                    width: parent.width/2
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    font.pixelSize: width/text.length
                    color:"black"
                }
                Rectangle{
                    width:parent.width/2
                    height: parent.height
                    border.color: "black"
                    border.width: 1
                    TextField{
                        id:widthText
                        anchors.fill: parent
                        validator: IntValidator{bottom:1;top:999;}
                        placeholderText: "8"
                        text:""
                        anchors.margins: 1
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        font.pixelSize: height *.75
                        onTextChanged: {
                            if(text.length > 0)
                            {
                                memoryWidth = text;
                            }
                            else
                            {
                                memoryWidth = placeholderText;
                            }
                        }
                    }
                }
            }
            Row{
                anchors.left: parent.left
                anchors.right:parent.right
                height:parent.height/8
                anchors.leftMargin: 6
                Text{
                    text:"ADDRESS_RADIX"
                    width: parent.width/2
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: (width/text.length) + 4
                    color:"black"
                }
                Rectangle{
                    width:parent.width/2
                    height: parent.height
                    border.color: "black"
                    border.width: 1
                    ComboBox{
                        anchors.fill: parent
                        model:["HEX","DEC","OCT","BIN","UNS"]
                    }
                }
            }
            Row{
                anchors.left: parent.left
                anchors.right:parent.right
                height:parent.height/8
                anchors.leftMargin: 6
                Text{
                    text:"DATA_RADIX"
                    width: parent.width/2
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    font.pixelSize: (width/text.length) + 4
                    color:"black"
                }
                Rectangle{
                    width:parent.width/2
                    height: parent.height
                    border.color: "black"
                    border.width: 1
                    ComboBox{
                        anchors.fill: parent
                        model:["HEX","DEC","OCT","BIN","UNS"]

                    }
                }
            }
            Row{
                anchors.left: parent.left
                anchors.right:parent.right
                height:parent.height/8
                anchors.leftMargin: 6
                Text{
                    text:"Start Address"
                    width: parent.width/2
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    font.pixelSize: (width/text.length) + 4
                    color:"black"
                }
                Rectangle{
                    width:parent.width/2
                    height: parent.height
                    border.color: "black"
                    border.width: 1
                    TextField{
                        id:startAddressText
                        anchors.fill: parent
                        validator: IntValidator{bottom:1;top:999;}
                        placeholderText: "0x00"
                        text:""
                        anchors.margins: 1
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        font.pixelSize: height *.75
                        onTextChanged: {
                            if(text.length > 0)
                            {
                                startAddress = text;
                            }
                            else
                            {
                                startAddress = placeholderText;
                            }
                        }
                    }
                }
            }
            Row{
                anchors.left: parent.left
                anchors.right:parent.right
                height:parent.height/8
                anchors.leftMargin: 6
                Text{
                    text:"End Address"
                    width: parent.width/2
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    font.pixelSize: (width/text.length) + 4
                    color:"black"
                }
                Rectangle{
                    width:parent.width/2
                    height: parent.height
                    border.color: "black"
                    border.width: 1
                    TextField{
                        id:endAddressText
                        anchors.fill: parent
                        readOnly:true
                        placeholderText: "0x20"
                        text:""
                        anchors.margins: 1
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        font.pixelSize: height *.75
                        onTextChanged: {
                            if(text.length > 0)
                            {
                                startAddress = text;
                            }
                            else
                            {
                                startAddress = placeholderText;
                            }
                        }
                    }
                }
            }
        }
    }
    spacing:10
}
