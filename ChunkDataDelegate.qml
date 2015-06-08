import QtQuick 2.4

Rectangle {
    property alias addressText:addrText
    property alias valueText: valueText
    property alias commentText:commText
    color: "green"

    Row{
        width:parent.width
        height:parent.height
        anchors.fill: parent
        Rectangle{
            id:addressContainer
            width:parent.width/4
            height:parent.height
            color:"darkblue"
            border.color: "white"
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
                    anchors.margins: 2
                    anchors.leftMargin: 4
                    anchors.left: parent.left
                    anchors.topMargin: 4
                    anchors.top: parent.top
                    text: MemoryFileEngine.getAddressString(model.address, MemoryFileEngine.padLength)
                    color:"white"
                    readOnly:true
                    validator:AddressValidator
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    onCursorPositionChanged: flickableText2.ensureVisible(cursorRectangle)
                }

            }
        }
        Rectangle{
            id:valueContainer
            width:parent.width/4
            height:parent.height
            color:"darkgreen"
            border.color: "white"
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
                    id: valueText
                    height: parent.height
                    font.pixelSize: valueContainer.height * .6
                    width:valueContainer.width >  (((font.pixelSize *.55) * (text.length)) + 4) ? valueContainer.width:(((font.pixelSize *.55) * (text.length)) + 4)
                    anchors.margins: 2
                    anchors.leftMargin: 4
                    anchors.left: parent.left
                    anchors.topMargin: 4
                    anchors.top: parent.top
                    text: MemoryFileEngine.getValueString(model.value, MemoryFileEngine.padLength)
                    color:"yellow"
                    validator:ValueValidator

                    horizontalAlignment:  TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    onCursorPositionChanged: flickableText1.ensureVisible(cursorRectangle)
                    onTextChanged: {
                            currentChunk.updateValueAt(model.address,text,model.comment)
                    }
                }
            }
        }
        Rectangle{
            id:commentContainer
            width:parent.width *.5 - parent.height
            height:parent.height
            color:"black"
            border.color: "white"
            border.width: 2
            Flickable{
                id:flickableText
                anchors.fill: parent
                contentHeight: height
                contentWidth: commText.width
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
                    id:commText
                    height: parent.height
                    font.pixelSize: commentContainer.height * .6
                    width: commentContainer.width >  (((font.pixelSize *.55) * (text.length)) + 4) ? commentContainer.width:(((font.pixelSize *.55) * (text.length)) + 4)
                    anchors.margins: 2
                    anchors.leftMargin: 4
                    anchors.left: parent.left
                    anchors.topMargin: 4
                    anchors.top: parent.top
                    text:model.comment
                    color:"white"
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    onCursorPositionChanged: flickableText.ensureVisible(cursorRectangle)
                    onTextChanged: {
                            currentChunk.updateValueAt(model.address,model.value,text)
                    }
                }
            }

        }
        Rectangle{
            id:remove
            width:parent.height
            height:parent.height
            color:"black"
            border.color: "white"
            border.width: 2
            Rectangle{
                anchors.fill: parent
                color:"red"
                anchors.margins: parent.width * .1
                radius: width/4
                Image{
                    anchors.fill: parent
                    anchors.margins: parent.radius*.5
                    source:"remove.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    MemoryFileEngine.removeChunkAt(model.address)
                }
            }
        }
    }
}

