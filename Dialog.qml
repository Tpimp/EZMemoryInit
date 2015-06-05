import QtQuick 2.4

Rectangle {
    id: dialog
    border.color: "white"
    border.width: 4
    radius: parent.width/64
    color:"blue"
    property alias b1Text: button1Text
    property alias b2Text: button2Text
    property alias b1Mouse: button1MouseArea
    property alias b2Mouse: button2MouseArea
    property alias button1:button1
    property alias button2:button2
    property bool isGameEndMenu: false
    property int address: 200
    property int value:0
    property string comment:""
    property string maxAddress:""
    property string minAddress:""

    property Gradient unselectedGrad:Gradient {
                                    GradientStop {
                                        position: 0.00;
                                        color: "#939390";
                                    }
                                    GradientStop {
                                        position: 1.00;
                                        color: "#717171";
                                    }
                                }
    property Gradient selectedGrad:Gradient {
                                    GradientStop {
                                        position: 0.00;
                                        color: "#404040";
                                    }
                                    GradientStop {
                                        position: 1.00;
                                        color: "#000000";
                                    }
                                }

    function setPrepend()
    {
        prependContainer.gradient = selectedGrad
        appendContainer.gradient = unselectedGrad
        insertContainer.gradient = unselectedGrad
        prependContainer.isSelected = true
        insertContainer.isSelected = false
        appendContainer.isSelected = false
        addrText.text = MemoryFileEngine.getAddressString(chunkEditorView.currentChunk.startAddress, MemoryFileEngine.padLength)
        addrText.readOnly = true;
    }
    function setAppend()
    {
        prependContainer.gradient = unselectedGrad
        appendContainer.gradient = selectedGrad
        insertContainer.gradient = unselectedGrad
        prependContainer.isSelected = false
        insertContainer.isSelected = false
        appendContainer.isSelected = true
        minAddress = MemoryFileEngine.getAddressString(chunkEditorView.currentChunk.startAddress, MemoryFileEngine.padLength)
        var end_address = Number(chunkEditorView.currentChunk.endAddress)
        end_address += 1;
        maxAddress = MemoryFileEngine.getAddressString(end_address, MemoryFileEngine.padLength)
        addrText.text = MemoryFileEngine.getAddressString(end_address, MemoryFileEngine.padLength)
        addrText.readOnly = true;
    }
    function setInsert()
    {

        prependContainer.gradient = unselectedGrad
        appendContainer.gradient = unselectedGrad
        insertContainer.gradient = selectedGrad
        prependContainer.isSelected = false
        insertContainer.isSelected = true
        appendContainer.isSelected = false
        addrText.readOnly = false;
    }
    function openDialog(address_in,value_in,comment_in)
    {
        address = address_in;
        value = value_in
        comment = comment_in
        AddressValidator.maxAddress = chunkEditorView.currentChunk.endAddress
        AddressValidator.minAddress =chunkEditorView.currentChunk.startAddress
        setAppend()
        visible = true
    }

    // The idea here is to provide base styling
    Rectangle{
        id:actionContainer
        anchors.top: parent.top
        anchors.topMargin: parent.height/20
        anchors.leftMargin: parent.width/10
        anchors.rightMargin: parent.width/10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width *.8
        color:"black"
        border.color: "orange"
        border.width: 2
        radius: width/6
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#597dfd";
            }
            GradientStop {
                position: 1.00;
                color: "#00027a";
            }
        }


        height:parent.height/6
        Row{
            anchors.fill: parent
            anchors.margins: 4
            spacing:parent.width * .02
            Rectangle{
                id:prependContainer
                border.width: 2
                property bool isSelected:false
                width:parent.width * .32
                height: parent.height
                radius: width/4
                clip:true
                border.color: "black"
                gradient:unselectedGrad
                Text{
                    id:prependText
                    anchors.leftMargin: 4
                    anchors.left:prependContainer.left
                    width:parent.width-indicatorP.width
                    height:parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter
                    color: prependContainer.isSelected ? "yellow":"white"
                    text: "Prepend"
                    font.pixelSize: height * .3
                }
                Rectangle{
                    id:indicatorP
                    height:parent.height/6
                    width:height
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: parent.width/20
                    radius:height
                    color: prependContainer.isSelected ? "green":"darkred"
                    border.width: 2
                    border.color: prependContainer.isSelected ? "orange":"black"

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:
                    {
                        setPrepend()
                    }
                }
            }
            Rectangle{
                id:insertContainer
                border.width: 2
                property bool isSelected:true
                width:parent.width * .32
                height: parent.height
                radius: width/4
                clip:true
                border.color: "black"
                gradient:selectedGrad
                Text{
                    id:insertText
                    anchors.leftMargin: 4
                    anchors.left:insertContainer.left
                    width:parent.width-indicatorP.width
                    height:parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter
                    color: insertContainer.isSelected ? "yellow":"white"
                    text: "Insert"
                    font.pixelSize: height * .3
                }
                Rectangle{
                    height:parent.height/6
                    width:height
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: parent.width/20
                    radius:height
                    color: insertContainer.isSelected ? "green":"darkred"
                    border.width: 2
                    border.color: insertContainer.isSelected ? "orange":"black"

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:
                    {
                        setInsert()
                    }
                }
            }
            Rectangle{
                id:appendContainer
                border.width: 2
                property bool isSelected:false
                width:parent.width * .32
                height: parent.height
                radius: width/4
                clip:true
                border.color: "black"
                gradient:unselectedGrad
                Text{
                    id:appendText
                    anchors.leftMargin: 4
                    anchors.left:appendContainer.left
                    height:parent.height
                    width:parent.width-indicatorP.width
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter
                    color: appendContainer.isSelected ? "yellow":"white"
                    text: "Append"
                    font.pixelSize: height * .3
                }
                Rectangle{
                    height:parent.height/6
                    width:height
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: parent.width/20
                    radius:height
                    color: appendContainer.isSelected ? "green":"darkred"
                    border.width: 2
                    border.color: appendContainer.isSelected ? "orange":"black"

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:
                    {
                        setAppend()
                    }
                }
            }
        }
    }
    Rectangle{
        anchors.top: actionContainer.bottom
        width: actionContainer.width
        height: actionContainer.height
        anchors.horizontalCenter: parent.horizontalCenter
        color:"transparent"
        Column
        {
            anchors.fill: parent
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

    Rectangle{
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/20
        width:dialog.width * .7
        color: "transparent"
        height: actionContainer.height * .6
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id: button1
            anchors.left: parent.left
            border.color: "white"
            border.width: 2
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width:parent.width * .44
            color:"black"
            radius: width/2
            visible: button1Text.text != ""
            Text{
                id:button1Text
                text: ""
                visible: text != ""
                color: "white"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height *.45
            }
            MouseArea{
                id:button1MouseArea
                anchors.fill: parent
                onClicked: {
                    MemoryFileEngine.addChunkDataAt(MemoryFileEngine.getAddressLong(addrText.text), MemoryFileEngine.getValueLong(valueText.text),commentText.text)
                    dialog.visible = false
                    setAppend()
                }

            }
        }
        Rectangle{
            id:button2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width:parent.width * .44
            color:"black"
            border.width: 2
            border.color: "white"
            visible: button2Text.text != ""
            radius:width/2
            Text{
                id:button2Text
                text: ""
                color:  "white"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height *.45
            }
            MouseArea{
                id:button2MouseArea
                anchors.fill: parent
                onClicked: {
                    dialog.visible = false
                    setAppend()
                }
            }
        }
    }

}

