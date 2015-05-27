import QtQuick 2.4
import QtQuick.Dialogs 1.2

FileDialog {
    id:fDialog
    signal fileChosen(string filepath)
    signal fildDialogClosed()
    title: "Choose the MIF to load"
    selectMultiple: false
    selectFolder: false
    nameFilters: ["mif files(*.mif)"]
    onAccepted:{
        fileChosen(fDialog.fileUrl)
    }
    onRejected:{
        fileDialogClosed()
    }
}

