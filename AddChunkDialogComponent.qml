import QtQuick 2.4
Component{
    Column
    {
        id:mainDataItem
        anchors.margins: 10
        property alias startAddrText:startAddrText
        property alias endAddrText:endAddrText
        property alias nameText:nameText
        property alias purposeText:purposeText
        property alias chosenColor:colorContainer.color
        property alias colorText:colorText
        anchors.fill: parent
        spacing:10
        Row{
            width:parent.width
            height:parent.height/2
            spacing: width *.1
            Text{
                color:"yellow"
                text:"Name"
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
                    id:nameContainer
                    anchors.fill: parent
                    color:"darkblue"
                    border.color: "yellow"
                    border.width: 2
                    Flickable{
                        id:flickableText3
                        anchors.fill: parent
                        contentHeight: height
                        contentWidth: nameText.width
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
                            id:nameText
                            height: parent.height
                            font.pixelSize: nameContainer.height * .6
                            width:nameContainer.width >  (((font.pixelSize *.55) * (text.length)) + 4) ? nameContainer.width:(((font.pixelSize *.55) * (text.length)) + 4)
                            anchors.margins: 4
                            anchors.leftMargin: 4
                            anchors.left: parent.left
                            anchors.topMargin: 4
                            anchors.top: parent.top
                            text: ""
                            color:"white"
                            horizontalAlignment: TextInput.AlignLeft
                            verticalAlignment: TextInput.AlignVCenter
                            onCursorPositionChanged: flickableText3.ensureVisible(cursorRectangle)
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
                text:"Start Address"
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
                        contentWidth: startAddrText.width
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
                            id:startAddrText
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
                text:"End Address"
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
                    id:endAddrContainer
                    anchors.fill: parent
                    color:"darkblue"
                    border.color: "yellow"
                    border.width: 2
                    Flickable{
                        id:flickableText1
                        anchors.fill: parent
                        contentHeight: height
                        contentWidth: endAddrText.width
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
                            id:endAddrText
                            height: parent.height
                            font.pixelSize: endAddrContainer.height * .6
                            width:endAddrContainer.width >  (((font.pixelSize *.55) * (text.length)) + 4) ? endAddrContainer.width:(((font.pixelSize *.55) * (text.length)) + 4)
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
                text:"Purpose"
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
                    id:purposeContainer
                    anchors.fill: parent
                    color:"darkblue"
                    border.color: "yellow"
                    border.width: 2
                    Flickable{
                        id:flickableText
                        anchors.fill: parent
                        contentHeight: height
                        contentWidth: purposeText.width
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
                            id:purposeText
                            height: parent.height
                            font.pixelSize: purposeContainer.height * .6
                            width:purposeContainer.width >  (((font.pixelSize *.55) * (text.length)) + 4) ? purposeContainer.width:(((font.pixelSize *.55) * (text.length)) + 4)
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
        Row{
            width:parent.width
            height:parent.height/2
            spacing: width *.1
            Text{
                color:"yellow"
                text:"Color"
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
                    id:colorContainer
                    anchors.fill: parent
                    border.color: "yellow"
                    border.width: 2
                    color:"darkblue"
                 Text{
                     id:colorText
                     anchors.fill: parent
                     font.pixelSize: height *.75
                     color:"white"
                     text:""
                     verticalAlignment: Text.AlignBottom
                 }

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        colorPickerContainer.openColorPicker(colorContainer,colorText)
                    }
                }
            }
        }
    }
}
