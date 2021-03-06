import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import MemoryInitialization 1.0

Rectangle{
    id:memList
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
    property QtObject chunkList:null
    function openFileList()
    {
        chunkListLoader.active = true;
        chunkList.model = MemoryFileEngine.chunks
    }
    function closeFileList()
    {
        chunkListLoader.active = false;
    }

    Connections{
        target:MemoryFileEngine
        onEndAddressChanged:{
            closeFileList()
            openFileList()
        }
        onChunksChanged:{
            closeFileList()
            openFileList()
        }
        onAddressRadixChanged: {
        }
        onDataRadixChanged:{

        }
        onFileNameChanged:{
            fileText.text = name
        }
        onMemoryDepthChanged:{
            depthText.text = depth
        }
        onMemoryWidthChanged:{
            widthText.text = width
        }

    }

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
            Rectangle{
                id:listHeader
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:parent.top
                color:"darkblue"
                border.color: "black"
                border.width:2
                height:chunkListLoader.height/8
                width:chunkListLoader.width
                radius:4
                Text{
                    height: parent.height
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"Memory Chunks In File"
                    color:"white"
                    font.pixelSize: height*.65
                }

            }
            Loader{
                id: chunkListLoader
                width: parent.width
                anchors.top:listHeader.bottom
                anchors.topMargin:4
                height: parent.height - listHeader.height
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent:chunkListComponent
                onLoaded:{
                    chunkList = item
                    chunkListLoader.visible = true
                }
                onActiveChanged: {
                    chunkListLoader.visible = active
                    if(!active)
                        chunkList = null
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
                            validator: IntValidator{bottom:1;top:65536;}
                            placeholderText: "32"
                            text:""
                            anchors.margins: 1
                            horizontalAlignment: TextInput.AlignHCenter
                            verticalAlignment: TextInput.AlignVCenter
                            font.pixelSize: height *.75
                            onTextChanged: {
                                if(text.length > 0)
                                {
                                    memoryDepth = Number(text);
                                }
                                else
                                {
                                    memoryDepth = Number(placeholderText);
                                }
                                MemoryFileEngine.memoryDepth = memoryDepth
                                AddressValidator.maxAddress = (memoryDepth-1)
                                endAddressText.text = MemoryFileEngine.getAddressString(AddressValidator.maxAddress, MemoryFileEngine.padLength)
                                memList.endAddress = MemoryFileEngine.getAddressString(AddressValidator.maxAddress, MemoryFileEngine.padLength)
                                MemoryFileEngine.lastAddress = memList.endAddress
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
                            validator: IntValidator{bottom:1;top:32;}
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
                                MemoryFileEngine.memoryWidth = memoryWidth
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
                            onCurrentTextChanged: {
                                MemoryFileEngine.addressRadix = currentText
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
                            onCurrentTextChanged: {
                                MemoryFileEngine.dataRadix = currentText
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
                            validator:AddressValidator
                            placeholderText: "00"
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
                            anchors.centerIn: parent
                            height:parent.height
                            width: parent.width
                            readOnly:true
                            placeholderText: "20"
                            text:""
                            validator:AddressValidator
                            anchors.margins: 1
                            horizontalAlignment: TextInput.AlignHCenter
                            verticalAlignment: TextInput.AlignVCenter
                            font.pixelSize: height *.75
                            onTextChanged: {
                                if(text.length > 0)
                                {
                                    endAddress = text;
                                }
                                else
                                {
                                    endAddress = placeholderText;
                                }
                            }
                        }
                    }
                }
                Row{
                    anchors.left: parent.left
                    anchors.right:parent.right
                    height:parent.height/10
                    anchors.leftMargin: 6

                    Rectangle{
                        width:parent.width
                        height: parent.height
                        border.color: "black"
                        border.width: 1
                        Text{
                            id: textBox
                            text:"Insert Chunk"
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            height: parent.height
                            font.pixelSize: (width/text.length) + 4
                            color:"black"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                chunkDialog.openDialog()
                            }
                        }
                    }
                }
            }
        }
        spacing:parent.height*.05
    }
    Component{
        id:chunkListComponent
        ListView{
            anchors.fill:parent
            spacing: parent.height * .01
            delegate:MemoryChunkDelegate{
                height: 90
                width:parent.width
                anchors.margins: 10
            }
        }
    }

}
