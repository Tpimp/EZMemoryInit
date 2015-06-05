import QtQuick 2.4
import MemoryInitialization 1.0
Rectangle {
    id:chunkEditor
    anchors.fill: parent
    color: "gold"
    property var  currentChunk:null
    property real currentIndex: -1
    property QtObject chunkDataList:null

    function openViewer(){
        chunkEditor.visible = true
        chunkDataListLoader.active = true
    }
    function closeViewer(){

        chunkEditor.visible = false
        chunkDataListLoader.active = false
    }
    function saveChanges()
    {
        chunkEditorView.closeViewer()
        MemoryFileEngine.saveChangesToCurrentChunk(currentIndex)
        currentIndex = -1
        MemoryFileEngine.setCurrentChunk(currentIndex)
    }
    function discardChanges()
    {
        chunkEditorView.closeViewer()
        MemoryFileEngine.discardChangesToCurrentChunk()
        currentIndex = -1
        MemoryFileEngine.setCurrentChunk(currentIndex)
    }

    function removeChunkData( index )
    {
        console.log("removed item at ", index)
    }
    function openAddDialog()
    {
        if(!addDialog.visible)
        {
            addDialog.openDialog(currentChunk.startAddress,0, "Put Comment Here")
        }
    }

    Connections{
        target: MemoryFileEngine
        onCurrentChunkChanged:{
            if(current_chunk != null)
            {
                currentChunk = current_chunk
                nameText.text = current_chunk.name
                chunkConnections.target = current_chunk
                chunkDataList.model = current_chunk.addresses
                chunkEditor.color = currentChunk.color
                purposeText.text = currentChunk.purpose
                chunkEditor.visible = true
            }
            else
            {
                chunkConnections.target = null
                currentChunk = null
            }
        }
    }
    Connections{
        id:chunkConnections
        onAddressesChanged:{
            chunkDataList.model = currentChunk.addresses
        }
        onEndAddressChanged:{
          //  var current_item =  chunkList.currentItem
         //   current_item.endAddress = MemoryFileEngine.getAddressString(endAddress)

        }
    }

    Rectangle{
        anchors.top: parent.top
        anchors.topMargin:  parent.height *.01
        height: parent.height *.04
        anchors.horizontalCenter:  titleBar.horizontalCenter
        width: titleBar.width/3
        border.width: 2
        border.color: "black"
        Text{
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Name"
        }
    }

    Rectangle{
        id:titleBar
        anchors.top:parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height *.06
        anchors.leftMargin: parent.width *.05
        anchors.rightMargin: parent.width *.05
        anchors.topMargin: parent.height * .05
        border.color: "white"
        border.width: 2
        radius: 16
        color:"black"
        TextInput{
            id:nameText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:"white"
            font.pixelSize: width/text.length + 4 > parent.height * .75 ? (parent.height * .75):(width/text.length + 4)
            text:""
            onTextChanged: {
                     MemoryFileEngine.setCurrentChunkName(text);
                 }
        }
    }
    Rectangle{
        width: purposeBar.width/3
        height: purposeBar.height/2
        anchors.horizontalCenter: purposeBar.horizontalCenter
        anchors.bottom: purposeBar.top
        anchors.bottomMargin: 2
        border.width: 1
        border.color: "black"
        color:"gold"
        Text{
            id:purposeTitle
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:"black"
            font.pixelSize: width/text.length + 4 > parent.height * .75 ? (parent.height * .75):(width/text.length + 4)
            text:"Purpose"
        }
    }

    Rectangle{
        id:purposeBar
        anchors.top:titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height *.06
        anchors.leftMargin: parent.width *.05
        anchors.rightMargin: parent.width *.05
        anchors.topMargin: parent.height * .05
        border.color: "white"
        border.width: 2
        radius: 4
        color:"black"
        Flickable{
            id:flickablePurpose
            anchors.fill: parent
            contentHeight: height
            contentWidth: width
            anchors.leftMargin:6
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
                font.pixelSize: purposeBar.height * .6
                width: parent.width
                anchors.fill: parent
                color:"white"
                text:"this is the text"
                horizontalAlignment: TextInput.AlignLeft
                verticalAlignment: TextInput.AlignVCenter
                onCursorPositionChanged: flickablePurpose.ensureVisible(cursorRectangle)
                onTextChanged: {
                    MemoryFileEngine.setCurrentChunkPurpose(text);
                }
            }
        }
    }
    Rectangle{
        id: dataContainer
        anchors.top: purposeBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.verticalCenter
        anchors.topMargin: parent.height * .0125
        anchors.bottomMargin: parent.height * -0.38
        color:"lightsteelblue"
        border.color: "black"
        border.width: 2
        Rectangle{
            id: listHeader
            color:"blue"
            width: chunkDataListLoader.width
            height:chunkDataListLoader.height /6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            Row{
                anchors.fill: parent
                Rectangle{
                    width:parent.width/4
                    height:parent.height
                    border.width: 2
                    border.color: "orange"
                    color: "darkblue"
                    Text{
                        anchors.fill: parent
                        text:"Address"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize:  height *.7
                    }
                }
                Rectangle{
                    width:parent.width/4
                    height:parent.height
                    border.width: 2
                    border.color: "orange"
                    color:"green"
                    Text{
                        anchors.fill: parent
                        color:"yellow"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text:"Value"
                        font.pixelSize:  height *.7
                    }
                }
                Rectangle{
                    width:parent.width/2
                    height:parent.height
                    border.width: 2
                    border.color: "orange"
                    color:"black"
                    Text{
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text:"Comment"
                        color:"white"
                        font.pixelSize:  height *.7
                    }
                }
            }
        }
        Loader{
            id:chunkDataListLoader
            sourceComponent: dataListComponent
            active:false
            clip:true
            width:parent.width
            anchors.top: listHeader.bottom
            anchors.bottom: parent.bottom
            onLoaded: {
                chunkDataList = item
            }
        }

    }
    ChunkEditBar{
        id:actionBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: dataContainer.bottom
        anchors.margins: border.width
        width:parent.width
    }
    Component{
        id:dataListComponent
        ListView{
            anchors.fill: parent
            delegate: ChunkDataDelegate{
                width: chunkDataList.width
                height:chunkDataList.height /6
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
    Dialog{
        id:addDialog
        visible:false
        height:parent.height/2
        width:parent.width/2
        anchors.right:parent.right
        anchors.bottom:actionBar.top
        b1Text.text: "Insert"
        b2Text.text:"Cancel"
    }

}
