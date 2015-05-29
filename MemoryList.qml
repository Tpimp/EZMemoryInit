import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import MemoryInitialization 1.0

Rectangle{
    anchors.centerIn: parent
    anchors.fill: parent
    color:"white"
    border.color: "black"
    border.width: 2
    property string startAddress:""
    property string endAddress: ""
    property real   memoryWidth: 0
    property real   memoryDepth: 32
    property alias  fileName:fileText.text
    Rectangle
    {
        id:fileNameBar
        anchors.top: parent.top
        width: parent.width * .8
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height * .1
        anchors.topMargin: parent.height *.02
        radius:8
        color:"yellow"
        border.color: "black"
        border.width: 2
        Text{
            id: fileText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height * .75
            text:"No File Selected"
            color:"black"
        }
    }

    Row
    {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:fileNameBar.bottom
        anchors.margins: 8
        width:parent.width*.9
        height: parent.height *.95 - fileNameBar.height
        Rectangle
        {

            id: listContainer
            border.width: 2
            border.color: "black"
            color:"lightsteelblue"
            clip:true
            width:parent.width/2
            height:parent.height
            radius: 16
            ListView{
                id:chunkList
                width: parent.width
                anchors.top:listHeader.bottom
                anchors.topMargin:4
                height: parent.height - listHeader.height
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: parent.height * .01
                model:MemoryFileEngine.chunks
                delegate:MemoryChunkDelegate{
                    height: 90
                    width:parent.width
                    anchors.margins: 10
                }
            }
            Rectangle{
                id:listHeader
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:parent.top
                color:"darkblue"
                border.color: "black"
                border.width:2
                height:chunkList.height/8
                width:chunkList.width
                radius:4
                Text{
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"Memory Chunks In File"
                    color:"white"
                    font.pixelSize: height*.65
                }

            }
        }
        Rectangle{
            id: controlList
            border.width: 2
            border.color: "black"
            color: "white"
            radius: 2
            width: parent.width * .45
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
                        id: comboBox1
                        ComboBox{
                            anchors.fill: parent
                            style:ComboBoxStyle {

                                background: Rectangle {
                                    id: rectCategory1
                                    radius: 5
                                    border.width: 2
                                    color: "#fff"
                                }
                                label: Text {
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: comboBox1.height * .8
                                    font.capitalization: Font.SmallCaps
                                    color: "black"
                                    text: control.currentText
                                }
                            }
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
                        id: comboBox
                        ComboBox{
                            anchors.fill: parent
                            style:ComboBoxStyle {

                                background: Rectangle {
                                    id: rectCategory
                                    radius: 5
                                    border.width: 2
                                    color: "#fff"
                                }
                                label: Text {
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: comboBox.height * .8
                                    color: "black"
                                    text: control.currentText
                                }
                            }
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
        spacing:parent.height*.05
    }

}
