import QtQuick 2.4

Rectangle {
    id:container
    color:model.color
    radius:16
    border.width: 2
    border.color: "black"
    Rectangle{
        id:nameBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height:parent.height *.35
        anchors.margins: 2
        border.color: "black"
        border.width: 2
        radius:12
        color:"white"
        Text{
            text:model.name
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height *.75
            horizontalAlignment: Text.AlignHCenter
        }
    }
    Flow{
        anchors.top:nameBar.bottom
        anchors.left:parent.left
        anchors.right:editButton.left
        anchors.margins: 4
        spacing:2
        Rectangle{
            height: container.height *.28
            width:  startAddText.width
            radius:2
            border.width: 1
            border.color: "black"
            Text{
                id:startAddText
                anchors.fill: parent
                anchors.leftMargin: 4
                text:"Start Address: " + model.startAddress
                color:"black"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *.7
                width: (text.length * (font.pixelSize-1))
            }
        }
        Rectangle{
            height: container.height *.28
            width:  endAddText.width
            radius:2
            border.width: 1
            border.color: "black"
            Text{
                id:endAddText
                anchors.fill: parent
                anchors.leftMargin: 4
                text:"End Address: " + model.endAddress
                color:"black"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: height *.7
                width: (text.length * (font.pixelSize-1))
            }
        }
    }
    Rectangle{
        id:editButton
        width:container.width/6
        height:container.height - (nameBar.height +20)
        anchors.right: parent.right
        anchors.margins: 6
        anchors.top: nameBar.bottom
        radius:4
        color:"grey"
        border.color: "black"
        border.width: 2
        Text{
            anchors.fill: parent
            text:"Edit Data"
            color:"white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: width/text.length + 4
        }
        MouseArea{
            anchors.fill: parent
            onClicked:{
                MemoryFileEngine.setCurrentChunk(index);
            }
        }
    }
}

