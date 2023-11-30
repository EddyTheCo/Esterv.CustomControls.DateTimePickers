import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import QtQml
import MyDesigns


ColumnLayout
{
    id:control
    property date initDate: new Date();
    property date selDate;

    property int mode: DateTimePicker.Mode.DateTime

    enum Mode {
        DateOnly,
        TimeOnly,
        DateTime
    }

    RowLayout
    {
        id:selectorhead
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumHeight: 15
        property bool showcalendar:(control.mode===DateTimePicker.Mode.TimeOnly)?false:true
        onShowcalendarChanged:
        {
            if(selectorhead.showcalendar)
            {
                calendarshader.iTime=1.0;
                timeshader.iTime=0.0;
            }
            else
            {
                calendarshader.iTime=0.0;
                timeshader.iTime=1.0;
            }
        }


        Rectangle
        {
            color:"transparent"
            id:clendarbutton
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 50
            visible:(control.mode!==DateTimePicker.Mode.TimeOnly)
            ShaderEffect
            {
                id:calendarshader
                property var src:clendarbutton
                property color fcolor:(selectorhead.showcalendar)?CustomStyle.frontColor2:CustomStyle.frontColor1
                height:Math.min(clendarbutton.width,clendarbutton.height)*0.8
                width:height
                anchors.centerIn: clendarbutton
                property real iTime:1.0
                Behavior on iTime { SmoothedAnimation { velocity: 1.5} }
                property var pixelStep: Qt.vector2d(1/src.width, 1/src.height)
                fragmentShader: "qrc:/esterVtech.com/imports/DTPickers/frag/calendar.frag.qsb"
            }


            MouseArea
            {
                id:clendarbuttonarea
                anchors.fill: parent
                onClicked:{
                    selectorhead.showcalendar=true;
                }
            }
            Rectangle
            {
                id:calendarline
                width:parent.width*calendarshader.iTime
                height:parent.height*0.05
                anchors.verticalCenter:  parent.bottom
                anchors.right: parent.right
                color:CustomStyle.frontColor2
            }

        }
        Rectangle
        {
            color:"transparent"
            id:timebutton
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 50
            visible:(control.mode!==DateTimePicker.Mode.DateOnly)
            ShaderEffect
            {
                id:timeshader
                property var src:timebutton
                property color fcolor:(!selectorhead.showcalendar)?CustomStyle.frontColor2:CustomStyle.frontColor1
                height:Math.min(timebutton.width,timebutton.height)*0.8
                width:height
                anchors.centerIn: timebutton
                property real iTime:0.0
                Behavior on iTime { SmoothedAnimation { velocity: 1.5} }
                property var pixelStep: Qt.vector2d(1/src.width, 1/src.height)
                fragmentShader: "qrc:/esterVtech.com/imports/DTPickers/frag/clock.frag.qsb"
            }

            MouseArea
            {
                id:timebuttonarea
                anchors.fill: parent
                onClicked:{
                    selectorhead.showcalendar=false;
                }
            }
            Rectangle
            {
                id:timeline
                width:parent.width*timeshader.iTime
                height:parent.height*0.05
                anchors.verticalCenter:  parent.bottom
                anchors.left: parent.left
                color:CustomStyle.frontColor2
            }

        }
    }
    Rectangle
    {
        id:division
        Layout.fillWidth: true
        Layout.maximumHeight: calendarline.height*0.5
        Layout.minimumHeight: calendarline.height*0.4
        Layout.alignment: Qt.AlignTop
        opacity:0.5
        color:CustomStyle.midColor1
    }


    DatePicker
    {
        id:datePicker
        initDate:control.initDate
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumHeight: 125
        visible:selectorhead.showcalendar
        clip:true
        onSelDateChanged:
        {
            control.selDate.setFullYear(datePicker.selDate.getFullYear());
            control.selDate.setMonth(datePicker.selDate.getMonth());
            control.selDate.setDate(datePicker.selDate.getDate());
            selectorhead.showcalendar=false;
        }
    }
    TimePicker
    {
        id:timepicker
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumHeight: 125
        visible:!selectorhead.showcalendar
        onHourChanged:
        {
            control.selDate.setHours(timepicker.hour);

        }
        onMinuteChanged:
        {
            control.selDate.setMinutes(timepicker.minute);
        }
    }

}

