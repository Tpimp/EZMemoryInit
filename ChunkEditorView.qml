import QtQuick 2.4

Rectangle {
    id:chunkEditor
    anchors.fill: parent
    color:"gold"
    property real padLength:0
    Connections{
        target: MemoryFileEngine
        onCurrentChunkChanged:{
            if(current_chunk != null)
            {
                nameText.text = current_chunk.name
                chunkDataList.model = current_chunk.addresses
                padLength = current_chunk.endAddress.length
                chunkEditor.visible = true
            }
        }
    }
    Rectangle{
        anchors.top: parent.top
        anchors.topMargin:  parent.height *.01
        height: parent.height *.04
        anchors.horizontalCenter:  titleBar.horizontalCenter
        width: titleBar.width/3
        border.width: 2
        border.color: "black"
        Text{
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Back"
        }
        MouseArea{
            anchors.fill: parent
            onClicked:
            {
                MemoryFileEngine.setCurrentChunk(-1);
                chunkEditor.visible = false
            }
        }
    }

    Rectangle{
        id:titleBar
        anchors.top:parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height *.10
        anchors.leftMargin: parent.width *.05
        anchors.rightMargin: parent.width *.05
        anchors.topMargin: parent.height * .05
        border.color: "white"
        border.width: 2
        radius: 16
        color:"black"
        Text{
            id:nameText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:"white"
            font.pixelSize: width/text.length + 4 > parent.height * .75 ? (parent.height * .75):(width/text.length + 4)
            text:""
        }
    }
    Rectangle{
        id: dataContainer
        anchors.top: titleBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: titleBar.width
        anchors.bottom: parent.bottom
        anchors.margins: parent.height * .05
        color:"lightsteelblue"
        border.color: "black"
        border.width: 2
        Rectangle{
            id: listHeader
            color:"blue"
            width: chunkDataList.width
            height:chunkDataList.height /6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            Row{
                anchors.fill: parent
                Rectangle{
                    width:parent.width/4
                    height:parent.height
                    border.width: 2
                    border.color: "white"
                    color: "darkblue"
                    Text{
                        anchors.fill: parent
                        text:"Address"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize:  height *.7
                    }
                }
                Rectangle{
                    width:parent.width/4
                    height:parent.height
                    border.width: 2
                    border.color: "white"
                    color:"green"
                    Text{
                        anchors.fill: parent
                        color:"yellow"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text:"Value"
                        font.pixelSize:  height *.7
                    }
                }
                Rectangle{
                    width:parent.width/2
                    height:parent.height
                    border.width: 2
                    border.color: "black"
                    color:"black"
                    Text{
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text:"Comment"
                        color:"white"
                        font.pixelSize:  height *.7
                    }
                }
            }
        }
        ListView{
            id:chunkDataList
            clip:true
            width:parent.width
            anchors.top: listHeader.bottom
            anchors.bottom: parent.bottom
            delegate: ChunkDataDelegate{
                width: chunkDataList.width
                height:chunkDataList.height /6
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}

