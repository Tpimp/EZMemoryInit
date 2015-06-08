import QtQuick 2.4

Dialog {
    id:addDataDialog
    width: 100
    height: 62
    // TODO: add property item point to content after loaded
    // change internal dialog to creating object and calling on Dialog Open appropriately
    // add checks in onX* methods to see if item pointer is null before attempting access
    content: AddDataDialogComponent{}

    onSetToAppend: {
        minAddress = MemoryFileEngine.getAddressString(chunkEditorView.currentChunk.startAddress, MemoryFileEngine.padLength)
        var end_address = Number(chunkEditorView.currentChunk.endAddress)
        end_address += 1;
        maxAddress = MemoryFileEngine.getAddressString(end_address, MemoryFileEngine.padLength)
        if(loadedContent != null)
        {
            loadedContent.addrText.text = MemoryFileEngine.getAddressString(end_address, MemoryFileEngine.padLength)
            loadedContent.addrText.readOnly = true;
        }
    }
    onSetToPrepend: {
        if(loadedContent != null)
        {
            loadedContent.addrText.text = MemoryFileEngine.getAddressString(chunkEditorView.currentChunk.startAddress, MemoryFileEngine.padLength)
            loadedContent.addrText.readOnly = true;
        }
    }
    onSetToInsert: {
        if(loadedContent != null)
        {
            loadedContent.addrText.readOnly = false;
        }
    }
    onDialogOpen:{
        if(loadedContent != null)
        {
            loadedContent.addrText.text = MemoryFileEngine.getAddressString(chunkEditorView.currentChunk.startAddress, MemoryFileEngine.padLength)
            loadedContent.valueText.text = MemoryFileEngine.getAddressString(0, MemoryFileEngine.padLength)
            loadedContent.commentText.text = "Put Comment Here"
            loadedContent.addrText.readOnly = false;
        }
        AddressValidator.maxAddress = chunkEditorView.currentChunk.endAddress
        AddressValidator.minAddress =chunkEditorView.currentChunk.startAddress
    }
    b2Mouse.onClicked: {
        setAppend()
        addDataDialog.visible = false
    }
    b1Mouse.onClicked: {

        MemoryFileEngine.addChunkDataAt(
                    MemoryFileEngine.getAddressLong(loadedContent.addrText.text),
                    MemoryFileEngine.getValueLong(loadedContent.valueText.text),
                    loadedContent.commentText.text)
        setAppend()
        addDataDialog.visible = false
    }
}

