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
    property string maxAddress:""
    property string minAddress:""
    signal  setToPrepend
    signal  setToAppend
    signal  setToInsert
    signal  dialogOpen
    property alias  content: contentRegion.containedItem
    property Item   loadedContent: null
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
        dialog.setToPrepend()
    }
    function setAppend()
    {
        prependContainer.gradient = unselectedGrad
        appendContainer.gradient = selectedGrad
        insertContainer.gradient = unselectedGrad
        prependContainer.isSelected = false
        insertContainer.isSelected = false
        appendContainer.isSelected = true
        dialog.setToAppend()
    }
    function setInsert()
    {

        prependContainer.gradient = unselectedGrad
        appendContainer.gradient = unselectedGrad
        insertContainer.gradient = selectedGrad
        prependContainer.isSelected = false
        insertContainer.isSelected = true
        appendContainer.isSelected = false
        dialog.setToInsert()
    }
    function openDialog()
    {
        if(!visible)
        {
            visible = true
            dialog.dialogOpen();
            setAppend()

        }
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
        id:contentRegion
        anchors.top: actionContainer.bottom
        width: actionContainer.width
        height: actionContainer.height
        anchors.horizontalCenter: parent.horizontalCenter
        color:"transparent"
        property Component containedItem: null
        Loader{
            id:contentLoader
            anchors.fill: parent
            sourceComponent: contentRegion.containedItem
            active:dialog.visible
            onLoaded:
            {
                dialog.loadedContent = item
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

