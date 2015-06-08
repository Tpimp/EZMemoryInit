import QtQuick 2.4
import "ColorPicker"
Dialog {
    id:addChunkDialog
    width: 100
    height: 62
    b1Text.text: "Add Chunk"
    b2Text.text: "Cancel"
    content:AddChunkDialogComponent{}
    onSetToAppend: {
        if(loadedContent != null)
        {
            loadedContent.startAddrText.text = MemoryFileEngine.getLastAddress()
            var start_address_num = Number(memoryList.startAddress)
            start_address_num = start_address_num + 1
            loadedContent.endAddrText.text = MemoryFileEngine.getAddressString(start_address_num,memoryList.endAddress.length)
            loadedContent.startAddrText.readOnly = true;
            loadedContent.endAddrText.readOnly = true;
        }
    }
    onSetToPrepend: {
        if(loadedContent != null)
        {
            loadedContent.startAddrText.text = MemoryFileEngine.getAddressString(0,memoryList.endAddress.length)
            loadedContent.endAddrText.text = MemoryFileEngine.getAddressString(1,memoryList.endAddress.length)
            loadedContent.endAddrText.readOnly = true;
            loadedContent.startAddrText.readOnly = true;
        }
    }
    onSetToInsert: {
        if(loadedContent != null)
        {
            loadedContent.startAddrText.text = memoryList.startAddress
            loadedContent.endAddrText.text = memoryList.endAddress
            loadedContent.startAddrText.readOnly = false;
            loadedContent.endAddrText.readOnly = false;
        }
    }
    onDialogOpen:{
        if(loadedContent != null)
        {

            loadedContent.startAddrText.text = memoryList.startAddress
            loadedContent.endAddrText.text = memoryList.endAddress
            loadedContent.purposeText.text = "Put Purpose here"
            loadedContent.chosenColor = "white"
            loadedContent.colorText.text = "white"
            setAppend()
        }
        AddressValidator.maxAddress = Number(memoryList.endAddress)
        AddressValidator.minAddress = Number(memoryList.startAddress)
    }
    b2Mouse.onClicked: {

        setAppend()
        visible = false
    }
    b1Mouse.onClicked: {
        MemoryFileEngine.addMemoryChunkAt(MemoryFileEngine.getAddressLong(loadedContent.startAddrText.text),
                                          MemoryFileEngine.getAddressLong(loadedContent.endAddrText.text),
                                          loadedContent.nameText.text,loadedContent.purposeText.text,
                                          loadedContent.colorText.text)
        setAppend()
        visible = false
    }

}
