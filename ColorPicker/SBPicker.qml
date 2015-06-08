import QtQuick 2.4

Item
{
    id: root
    property color hueColor : "blue"
    property alias cursorx: pickerCursor.x
    property alias cursory: pickerCursor.y
    property real saturation : pickerCursor.x/width
    property real value : 1 - pickerCursor.y/height
    width: parent.width; height: parent.height
    clip: true

    Rectangle
    {
        anchors.fill: parent;
        rotation: -90
        gradient: Gradient
        {
            GradientStop { position: 0.0; color: "#FFFFFF" }
            GradientStop { position: 1.0; color: root.hueColor }
        }
    }
    Rectangle
    {
        anchors.fill: parent
        gradient: Gradient
        {
            GradientStop { position: 1.0; color: "#FF000000" }
            GradientStop { position: 0.0; color: "#00000000" }
        }
    }
    Item
    {
        id: pickerCursor
        property int r : 10
        Rectangle
        {
            x: -parent.r; y: -parent.r
            width: parent.r*2; height: parent.r*2
            radius: parent.r
            border.color: "black"; border.width: 2
            anchors.margins: 8
            color: "transparent"
            Rectangle
            {
                anchors.fill: parent; anchors.margins: 2;
                border.color: "white"; border.width: 2
                radius: width/2
                color: "transparent"
            }
        }
    }
    MouseArea
    {
        anchors.fill: parent
        function handleMouse(mouse)
        {
            if (mouse.buttons & Qt.LeftButton)
            {
                pickerCursor.x = Math.max(0, Math.min(width,  mouse.x));
                pickerCursor.y = Math.max(0, Math.min(height, mouse.y));
            }
        }
        onPositionChanged: handleMouse(mouse)
        onPressed: handleMouse(mouse)
    }
}
