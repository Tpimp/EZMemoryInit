import QtQuick 2.4

Rectangle {
    width: 100
    height: 62
    border.color: "black"
    color: "lightsteelblue"
    Row{
        anchors.fill: parent
        spacing:parent.width/12
        anchors.leftMargin: spacing
        Rectangle{
            border.color: "black"
            border.width: 2
            width: parent.width/4
            height: parent.height
            radius:12
            color: "white"
            Text{
                text:"Save Changes"
                color: "darkgreen"
                anchors.fill: parent
                font.pixelSize: height * .40
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    chunkEditorView.saveChanges()
                }
            }
        }

        Rectangle{
            border.color: "black"
            width: parent.width/4
            height: parent.height
            radius:12
            color: "white"
            Text{
                text:"Discard Changes"
                color: "darkred"
                anchors.fill: parent
                font.pixelSize: height * .40
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    chunkEditorView.discardChanges()
                }
            }
        }
        Rectangle{
            border.color: "black"
            width: parent.width/4
            height: parent.height
            radius:12
            color: "white"
            Text{
                text:"Add Value"
                color: "black"
                anchors.fill: parent
                font.pixelSize: height * .45
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    chunkEditorView.openAddDialog()
                }
            }
        }
    }
}

