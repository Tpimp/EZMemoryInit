import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: qsTr("EZ Memory Init")
    width: 640
    height: 480
    visible: true
    Connections{
        target: MemoryFileEngine
        //onNewChunkAdded
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: {
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
       color: "#0051ff"

   }
   MemoryFileDialog{
       id:fileDialog
       onFileChosen: {
            MemoryFileEngine.loadFile(filepath)
       }
   }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }
}
