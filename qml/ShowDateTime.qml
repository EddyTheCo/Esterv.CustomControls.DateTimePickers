import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import QtQml
import MyDesigns

GridLayout {
    id:control
    property date initDate: new Date()
    property alias selDate: datetimepicker.selDate

    property bool islandscape:control.width>control.height+100

    columns: control.islandscape ? 2 : 1
    rows : control.islandscape ? 1 : 2

    FontLoader {
        id: lFont
        source: "qrc:/esterVtech.com/imports/DTPickers/fonts/Roboto/Roboto-Light.ttf"
    }
    FontLoader {
        id: rFont
        source: "qrc:/esterVtech.com/imports/DTPickers/fonts/Roboto/Roboto-Regular.ttf"
    }
    Rectangle
    {
        color:"transparent"
        id:showdatetime

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.minimumWidth: 50
        Layout.minimumHeight: 50

        GridLayout
        {
            anchors.fill: parent
            columns: control.columns===1 ? 2 : 1
            rows : control.columns===1 ? 1 : 2

            Label
            {
                id:showdate
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumWidth: 30
                Layout.minimumHeight: 30
                text:(isNaN(control.selDate))?"---- \n -- -- ":control.selDate.toLocaleDateString(Qt.locale(),"yyyy\n MMM dd ");
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight
                fontSizeMode:Text.Fit
                font.pixelSize: 80
                font.family: lFont.font.family
                font.weight: lFont.font.weight
                color: CustomStyle.frontColor1

            }


            Label
            {
                id:showtime
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumWidth: 40
                Layout.minimumHeight: 30
                text:(isNaN(control.selDate))?"--:--_":control.selDate.toLocaleTimeString(Qt.locale(),"h:mm a");
                verticalAlignment: control.islandscape?Text.AlignTop:Text.AlignBottom
                horizontalAlignment: control.islandscape?Text.AlignRight:Text.AlignLeft
                fontSizeMode:Text.Fit
                font.pixelSize: 80
                font.family: lFont.font.family
                font.weight: lFont.font.weight
                color: CustomStyle.frontColor1
                MouseArea
                {
                    id:hourarea
                    anchors.fill: parent
                }
            }



        }
    }
    DateTimePicker
    {
        id:datetimepicker
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.minimumWidth: 100
        Layout.minimumHeight: 150
        initDate:control.initDate
    }

}
