import QtQuick 2.4

//Color Picker
Rectangle
{
    property alias pickedColor: colorPreveiw.color
    property alias colorText:colorTextInput.text
    id: colorPicker
    width: parent.width
    height: parent.height
    color:"#403939"

    Row
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12
        //veiwer / text boxes
        Column
        {
            id: colorInfo
            width: parent.width * .2
            height: parent.height
            spacing: 4
            anchors.verticalCenter: colorPicker.verticalCenter
            Rectangle
            {
                width: parent.width *.92
                height: parent.height/5.5
                anchors.horizontalCenter: colorPicker.horizontalCenter
                CheckerBoard {cellSide: 6}
                Rectangle
                {
                    id: colorPreveiw
                    anchors.fill: parent
                    border.width: 1; border.color: "black"
                    color: hsba(hueSlider.value, sbPicker.saturation, sbPicker.value, 255)
                }
            }
            PanelBorder
            {
                id: colorEditBox
                height: parent.height/16; width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                TextInput
                {
                    id:colorTextInput
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    color: "#AAAAAA"
                    selectionColor: "#FF7777AA"
                    font.pixelSize: height *.9
                    maximumLength: 9
                    text: colorPreveiw.color
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                }
            }
            NumberBox
            {
                id: hueBox
                width: parent.width; height: parent.height/16
                anchors.horizontalCenter: parent.horizontalCenter
                caption: "H:"; value: Math.ceil(hueSlider.value *360)
                max: 360
                Connections
                {
                    target: hueBox.inputBox
                    onAccepted:
                    {
                        hueSlider.cursory = hueSlider.height * (1 - hueBox.value/360)
                    }
                }
            }
            NumberBox
            {
                id: satBox
                width: parent.width; height: parent.height/16
                anchors.horizontalCenter: parent.horizontalCenter
                caption: "S:"; value: Math.ceil(sbPicker.saturation*255)
                Connections
                {
                    target: satBox.inputBox
                    onAccepted:
                    {
                        sbPicker.cursorx = sbPicker.width * (satBox.value/255)
                    }
                }
            }
            NumberBox
            {
                id: brightBox
                width: parent.width; height: parent.height/16
                anchors.horizontalCenter: parent.horizontalCenter
                caption: "B:"; value: Math.ceil(sbPicker.value*255)
                Connections
                {
                    target: brightBox.inputBox
                    onAccepted:
                    {
                        sbPicker.cursory = sbPicker.height * (1 - brightBox.value/255)
                    }
                }
            }


            NumberBox
            {
                id:redBox
                width: parent.width; height: parent.height/16
                anchors.horizontalCenter: parent.horizontalCenter
                caption: "R:"; value: getChannelStr(colorPreveiw.color, 0)
                min: 0; max: 255
                Connections
                {
                    target: redBox.inputBox
                    onAccepted:
                    {
                        var red = redBox.value/255;
                        var green = greenBox.value/255;
                        var blue = blueBox.value/255
                        hueSlider.cursory = hueSlider.height * (1 - calculateHue(red, green, blue)/360)
                        sbPicker.cursorx  = sbPicker.width   * (calculateSat(red, green, blue))
                        sbPicker.cursory  = sbPicker.height  * (1 - calculateVal(red, green, blue))
                    }
                }
            }
            NumberBox
            {
                id:greenBox
                width: parent.width; height: parent.height/16
                anchors.horizontalCenter: parent.horizontalCenter
                caption: "G:"; value: getChannelStr(colorPreveiw.color, 1)
                min: 0; max: 255
                Connections
                {
                    target: greenBox.inputBox
                    onAccepted:
                    {
                        var red = redBox.value/255;
                        var green = greenBox.value/255;
                        var blue = blueBox.value/255
                        hueSlider.cursory = hueSlider.height * (1 - calculateHue(red, green, blue)/360)
                        sbPicker.cursorx  = sbPicker.width   * (calculateSat(red, green, blue))
                        sbPicker.cursory  = sbPicker.height  * (1 - calculateVal(red, green, blue))
                    }
                }
            }
            NumberBox
            {
                id:blueBox
                width: parent.width; height: parent.height/16
                anchors.horizontalCenter: parent.horizontalCenter
                caption: "B:"; value: getChannelStr(colorPreveiw.color, 2)
                min: 0; max: 255
                Connections
                {
                    target: blueBox.inputBox
                    onAccepted:
                    {
                        var red = redBox.value/255;
                        var green = greenBox.value/255;
                        var blue = blueBox.value/255
                        hueSlider.cursory = hueSlider.height * (1 - calculateHue(red, green, blue)/360)
                        sbPicker.cursorx  = sbPicker.width   * (calculateSat(red, green, blue))
                        sbPicker.cursory  = sbPicker.height  * (1 - calculateVal(red, green, blue))
                    }
                }
            }
        }


        //Gradient veiwer
        SBPicker
        {
            id:sbPicker
            height: parent.height*.96
            anchors.verticalCenter: parent.verticalCenter
            width:  height
            hueColor: hsba(hueSlider.value, 1.0, 1.0, 1.0)
            cursorx: width
        }
        //hue Picker
        Rectangle
        {
            width: parent.width *.25
            height: sbPicker.height *.96
            anchors.verticalCenter: parent.verticalCenter
            border.color: "black"
            border.width: 2
            gradient: Gradient
            {
                GradientStop { position: 1.0;  color: "#FF0000" }
                GradientStop { position: 0.85; color: "#FFFF00" }
                GradientStop { position: 0.76; color: "#00FF00" }
                GradientStop { position: 0.5;  color: "#00FFFF" }
                GradientStop { position: 0.33; color: "#0000FF" }
                GradientStop { position: 0.16; color: "#FF00FF" }
                GradientStop { position: 0.0;  color: "#FF0000" }
            }
            ColorSlider { id:hueSlider; width: parent.width}
        }



    }
    function getChannelStr(clr, channelIdx)
    {
        return parseInt(clr.toString().substr(channelIdx*2 + 1, 2), 16);
    }

    function hsba(h, s, b, a)
    {
        var lightness = (2 - s)*b;
        var satHSL = s*b/((lightness <= 1) ? lightness : 2 - lightness);
        lightness /= 2;
        return Qt.hsla(h, satHSL, lightness, a);
    }

    function calculateHue(R, G, B)
    {
        var min = R < G ? (R < B ? R : B): (G < B ? G : B);
        var hue;


        if (R == G && G == B)
        {
            hue = 0;
        }
        else if ( B >= R && B >= G)
        {
            hue = ((Math.abs(R-G)/(B-min)) + 4);
        }
        else if ( G > R && G >= B)
        {
            hue = ((Math.abs(B-R)/(G-min)) + 2);
        }
        else
        {
            hue = ((Math.abs(G-B)/(R-min)) % 6);
        }



        return (hue*60)
    }

    function calculateSat(R, G, B)
    {
        var min = R < G ? (R < B ? R : B): (G < B ? G : B);
        var sat;

        if ( R >= G && R >= B && R != 0)
        {
            sat = ((R-min)/R);
        }
        else if ( G > R && G >= B && B != 0)
        {
            sat = ((G-min)/G);
        }
        else if (B != 0)
        {
            sat = ((B-min)/B);
        }
        else
        {
            sat = 0;
        }

        return sat;
    }

    function calculateVal(R, G, B)
    {
        var max

        if ( R >= G && R >= B)
        {
            max = R;
        }
        else if ( G > R && G >= B)
        {
            max = G;
        }
        else
        {
            max = B;
        }

        return max;
    }
}

