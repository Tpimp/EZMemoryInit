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

    spacing:10
}
