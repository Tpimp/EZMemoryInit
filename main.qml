import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import "ColorPicker"

ApplicationWindow {
    id: mainWindow
    title: qsTr("EZ Memory Init")
    width: 640
    height: 480
    visible: true
    Connections{
        target: MemoryFileEngine
        onFileLoadedSuccesfully:{
            memoryList.fileName = filename
            saveAction.enabled = true
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: {
                    fileDialog.isLoad = true
                    fileDialog.setSelectExisting(true)
                    fileDialog.open()
                }
            }
            MenuItem {
                id:saveAction
                text: qsTr("&Save")
                enabled:false
                onTriggered: {
                    console.log("Attempting to save file at ", MemoryFileEngine.filePath )
                    MemoryFileEngine.writeFile(MemoryFileEngine.filePath)
                }
            }
            MenuItem {
                id:saveAsAction
                text: qsTr("&Save As")
                onTriggered: {
                    //console.log("Attempting to save file at ", MemoryFileEngine.filePath )
                    //MemoryFileEngine.writeFile(MemoryFileEngine.filePath)
                    fileDialog.isLoad = false
                    fileDialog.setSelectExisting(false)
                    fileDialog.open()
                }
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }
    ToolBar{
        id:toolBar
        anchors.top: parent.top
        height:parent.height *.25
        width: parent.width
    }

   MemoryList{
       id:memoryList
       color: "#0051ff"

   }
   ChunkEditorView
   {
       id:chunkEditorView
       visible: false
   }



   AddChunkDialog{
       id:chunkDialog
       height:parent.height/2
       width:parent.width/2
       anchors.bottom: memoryList.bottom
       anchors.right: memoryList.right
       anchors.margins: 40
       visible:false
   }
   Rectangle{
       id:colorPickerContainer
       anchors.fill:parent
       radius: 16
       anchors.topMargin: parent.height *.1
       anchors.bottomMargin: parent.height *.1
       anchors.leftMargin: parent.width *.1
       anchors.rightMargin: parent.width *.1
       property var color_item_reference:null
       property var color_text_reference:null
       function openColorPicker(color_item,color_text)
       {
           color_item_reference = color_item
           color_text_reference = color_text
           colorPickerContainer.visible = true
       }

       function chooseColor()
       {
           color_item_reference.color = colorPicker.pickedColor
           color_text_reference.text = colorPicker.colorText
           colorPickerContainer.visible = false
       }

       border.width: 2
       clip: true
       color:"black"
       border.color: "yellow"
       ColorPicker{
           id:colorPicker
           height:parent.height *.66
           width: parent.width *.88
           anchors.top: parent.top
           anchors.topMargin:12
           anchors.horizontalCenter: parent.horizontalCenter
           property color chosenColor: Qt.rgba(0,0,0,255)
           border.width: 2
           border.color: "white"
       }
       Rectangle{
            anchors.left:parent.left
            anchors.right:parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            height:parent.height*.15
            radius:16
            color:"black"
            Rectangle{
                id: button1
                anchors.left: parent.left
                border.color: "white"
                border.width: 2
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                width:parent.width * .44
                color:"darkblue"
                radius: width/2
                Text{
                    id:button1Text
                    text: "Choose Color"
                    visible: text != ""
                    color: "yellow"
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: parent.height *.4
                }
                MouseArea{
                    id:button1MouseArea
                    anchors.fill: parent
                    onClicked:{
                        colorPickerContainer.chooseColor()
                    }

                }
            }
            Rectangle{
                id:button2
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                width:parent.width * .44
                color:"darkblue"
                border.width: 2
                border.color: "white"
                radius:width/2
                Text{
                    id:button2Text
                    text: "Cancel"
                    color:  "yellow"
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: parent.height *.4
                }
                MouseArea{
                    id:button2MouseArea
                    anchors.fill: parent
                    onClicked: {
                        colorPickerContainer.visible = false
                    }
                }
            }
       }

       z: parent.z+100
       visible: false
   }
   MemoryFileDialog{
       id:fileDialog
       property bool isLoad:true
       selectMultiple: false
       onFileChosen: {
           if(isLoad)
           {
               MemoryFileEngine.loadFile(filepath)
           }
       }
       onFileUrlChanged:
       {
           if(!isLoad)
                MemoryFileEngine.writeFile(fileUrl)
       }
   }

    /*MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }*/
}
