import QtQuick 2.4

//Grid
Rectangle
{
    id: root
    property int cellSide: 10
    width: parent.width; height: parent.height
    color: 'white'
    //rows: height/cellSide; columns: width/cellSide
    /*Repeater
    {
        model: root.columns*root.rows
        Rectangle
        {
            width: root.cellSide; height: root.cellSide
            color: ((index%2  == 0) ? "gray" : "white")
        }
    }*/
}
