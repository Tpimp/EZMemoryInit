import QtQuick 2.4

Component
{
    Column
    {
        anchors.fill: parent
        id:mainDataItem
        property alias addrText:addrText
        property alias valueText:valueText
        property alias commentText:commentText
        anchors.margins: 10
        spacing:10
        Row{
            width:parent.width
            height:parent.height/2
            spacing: width *.1
            Text{
                color:"yellow"
                text:"Address"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                width: parent.width *.45
                height: parent.height
                font.pixelSize: height *.75
            }
            Rectangle{
                color:"white"
                border.color: "black"
                border.width: 2
                width:parent.width *.45
                height:parent.height
                Rectangle{
                    id:addressContainer
                    anchors.fill: parent
                    color:"darkblue"
                    border.color: "yellow"
                    border.width: 2
                    Flickable{
                        id:flickableText2
                        anchors.fill: parent
                        contentHeight: height
                        contentWidth: addrText.width
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        pressDelay: 100
                        function ensureVisible(r)
                        {
                            if (contentX >= r.x)
                                contentX = r.x;
                            else if (contentX+width <= r.x+r.width)
                                contentX = r.x+r.width-width;
                        }
                        TextInput{
                            id:addrText
                            height: parent.height
                            font.pixelSize: addressContainer.height * .6
                            width:addressContainer.width >  (((font.pixelSize *.55) * (text.length)) + 4) ? addressContainer.width:(((font.pixelSize *.55) * (text.length)) + 4)
                            anchors.margins: 4
                            anchors.leftMargin: 4
                            anchors.left: parent.left
                            anchors.topMargin: 4
                            anchors.top: parent.top
                            text: ""
                            color:"white"
                            validator:AddressValidator
                            horizontalAlignment: TextInput.AlignLeft
                            verticalAlignment: TextInput.AlignVCenter
                            onCursorPositionChanged: flickableText2.ensureVisible(cursorRectangle)
                        }

                    }
                }
            }
        }
        Row{
            width:parent.width
            height:parent.height/2
            spacing: width *.1
            Text{
                color:"yellow"
                text:"Value"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                width: parent.width *.45
                height: parent.height
                font.pixelSize: height *.75
            }
            Rectangle{
                color:"blue"
                border.color: "black"
                border.width: 2
                width:parent.width *.45
                height:parent.height
                Rectangle{
                    id:valueContainer
                    anchors.fill: parent
                    color:"darkblue"
                    border.color: "yellow"
                    border.width: 2
                    Flickable{
                        id:flickableText1
                        anchors.fill: parent
                        contentHeight: height
                        contentWidth: valueText.width
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        pressDelay: 100
                        function ensureVisible(r)
                        {
                            if (contentX >= r.x)
                                contentX = r.x;
                            else if (contentX+width <= r.x+r.width)
                                contentX = r.x+r.width-width;
                        }
                        TextInput{
                            id:valueText
                            height: parent.height
                            font.pixelSize: valueContainer.height * .6
                            width:valueContainer.width >  (((font.pixelSize *.55) * (text.length)) + 4) ? valueContainer.width:(((font.pixelSize *.55) * (text.length)) + 4)
                            anchors.margins: 4
                            anchors.leftMargin: 4
                            anchors.left: parent.left
                            anchors.topMargin: 4
                            anchors.top: parent.top
                            text: ""
                            color:"white"
                            validator:ValueValidator
                            horizontalAlignment: TextInput.AlignLeft
                            verticalAlignment: TextInput.AlignVCenter
                            onCursorPositionChanged: flickableText1.ensureVisible(cursorRectangle)
                        }

                    }
                }
            }
        }
        Row{
            width:parent.width
            height:parent.height/2
            spacing: width *.1
            Text{
                color:"yellow"
                text:"Comment"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                width: parent.width *.45
                height: parent.height
                font.pixelSize: height *.75
            }
            Rectangle{
                color:"blue"
                border.color: "black"
                border.width: 2
                width:parent.width *.45
                height:parent.height
                Rectangle{
                    id:commentContainer
                    anchors.fill: parent
                    color:"darkblue"
                    border.color: "yellow"
                    border.width: 2
                    Flickable{
                        id:flickableText
                        anchors.fill: parent
                        contentHeight: height
                        contentWidth: commentText.width
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        pressDelay: 100
                        function ensureVisible(r)
                        {
                            if (contentX >= r.x)
                                contentX = r.x;
                            else if (contentX+width <= r.x+r.width)
                                contentX = r.x+r.width-width;
                        }
                        TextInput{
                            id:commentText
                            height: parent.height
                            font.pixelSize: commentContainer.height * .6
                            width:commentContainer.width >  (((font.pixelSize *.55) * (text.length)) + 4) ? commentContainer.width:(((font.pixelSize *.55) * (text.length)) + 4)
                            anchors.margins: 4
                            anchors.leftMargin: 4
                            anchors.left: parent.left
                            anchors.topMargin: 4
                            anchors.top: parent.top
                            text: ""
                            color:"white"
                            horizontalAlignment: TextInput.AlignLeft
                            verticalAlignment: TextInput.AlignVCenter
                            onCursorPositionChanged: flickableText.ensureVisible(cursorRectangle)
                        }

                    }
                }
            }
        }
    }

}
