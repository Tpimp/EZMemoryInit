import QtQuick 2.4
import QtQuick.Controls 1.3
import MemoryInitialization 1.0

Rectangle{
     anchors.centerIn: parent
     anchors.fill: parent
     color:"white"
     border.color: "black"
     border.width: 2
     property string startAddress:""
     property string endAddress: ""
     property real   memoryWidth: 0
     property real   memoryDepth: 32

    Rectangle
    {
        anchors.centerIn: parent
        anchors.margins: 4
        width:parent.width*.9
        height: parent.height *.75
        id: listContainer
        border.width: 2
        border.color: "black"
        color:"lightsteelblue"
        clip:true
        radius: 16

        ListView{
            anchors.fill: parent
            model:MemoryFileEngine.chunks
            delegate:MemoryChunkDelegate{
                height: 90
                width:parent.width
                anchors.margins: 10
            }
        }
    }

}
