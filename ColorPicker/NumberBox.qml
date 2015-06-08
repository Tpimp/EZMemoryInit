import QtQuick 2.4


Row
{
    property alias  inputBox: inputBox
    property alias  caption: captionBox.text
    property alias  value: inputBox.text
    property alias  min: numValidator.bottom
    property alias  max: numValidator.top

    width: 80;
    height: 15
    spacing: 4
    anchors.margins: 2
    Text
    {
        id: captionBox
        width: (parent.width-8)*.2; height: parent.height
        color: "#AAAAAA"
        font.pixelSize: height; font.bold: true
        horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignBottom
        anchors.bottomMargin: 3
    }
    Rectangle
    {
        height: parent.height
        width: (parent.width-8)*.8
        TextInput
        {
            id: inputBox
            anchors.leftMargin: 4; anchors.bottomMargin: 3; anchors.fill: parent
            horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignBottom
            color: "#AAAAAA"; selectionColor: "#FF7777AA"
            font.pixelSize: height
            maximumLength: 8
            selectByMouse: true
            validator: IntValidator
            {
                id: numValidator
                bottom: 0; top: 255;
            }
        }
    }
}
