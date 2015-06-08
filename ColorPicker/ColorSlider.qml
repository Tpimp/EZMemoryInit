import QtQuick 2.4

Item
{
    property alias cursory: pickerCursor.y
    property real value: (1 - pickerCursor.y/height)
    width: parent.width; height: parent.height
    Item
    {
        id: pickerCursor
        width: parent.width
        Rectangle
        {
            x: -3; y: -height*0.5
            width: parent.width + 4; height: 20
            border.color: "black"; border.width: 1
            color: "transparent"
            Rectangle
            {
                anchors.fill: parent; anchors.margins: 2
                border.color: "white"; border.width: 1
                color: "transparent"
            }
        }
    }
    MouseArea
    {
        id:mouseInput
        anchors.fill: parent
        function handleMouse(mouse)
        {
            pickerCursor.y = Math.max(0, Math.min(height, mouse.y))
        }
        onPositionChanged: handleMouse(mouse)
        onPressed: handleMouse(mouse)
    }
}
