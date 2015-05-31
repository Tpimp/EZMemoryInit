import QtQuick 2.4

Rectangle {
    property alias addressText:addrText
    property alias valueText: valueText
    property alias commentText:commText
    color: "green"
    Row{
        width:parent.width
        height:parent.height
        Rectangle{
            width:parent.width/4
            height:parent.height
            color:"darkblue"
            border.color: "white"
            border.width: 2
            TextInput{
                id:addrText
                font.pixelSize: parent.height * .65
                anchors.fill: parent
                anchors.margins: 2
                text: MemoryFileEngine.getAddressString(model.address, chunkEditorView.padLength)
                color:"white"
                readOnly:true
                horizontalAlignment: TextInput.AlignRight
                verticalAlignment: TextInput.AlignBottom
            }
        }
        Rectangle{
            width:parent.width/4
            height:parent.height
            color:"darkgreen"
            border.color: "white"
            border.width: 2
            TextInput{
                id: valueText
                font.pixelSize: parent.height * .65
                anchors.fill: parent
                anchors.margins: 2
                anchors.rightMargin: 4
                text: MemoryFileEngine.getValueString(model.value, chunkEditorView.padLength)
                color:"yellow"
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignBottom
            }
        }
        Rectangle{
            width:parent.width/2
            height:parent.height
            color:"black"
            border.color: "white"
            border.width: 2
            TextInput{
                id:commText
                anchors.fill: parent
                font.pixelSize: parent.height * .65
                anchors.margins: 2
                anchors.leftMargin: 4
                text:model.comment
                color:"white"
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignBottom
            }
        }
    }
}

