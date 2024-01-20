pragma ComponentBehavior: Bound
import QtQuick.Controls
import QtQuick
import QtQml
import Esterv.Styles.Simple
import Esterv.CustomControls

Item
{
    id:control
    property int hour:0;
    property int minute:0;
    property alias chooseHour:watchface.isHourSelection
    signal selected();

    Item
    {
        id:watchface
        anchors.centerIn: parent
        width:Math.min(parent.width,parent.height)*0.8
        height:width
        property bool isHourSelection:true
        property real selAngleHour:360*(control.hour%12)/12.0
        property real selAngleMinute:360*(control.minute%60)/60.0
        property real selAngle:(isHourSelection)?selAngleHour:selAngleMinute
        Behavior on selAngle { SmoothedAnimation { velocity: 180.0} }
        Rectangle
        {
            id:centerDot
            color:Style.backColor3
            width:watchface.width*0.05
            height:width
            radius:width
            anchors.centerIn: watchface
        }
        Rectangle
        {
            id:arm
            color:centerDot.color
            width:watchface.width*0.02
            height:watchface.width*0.5
            radius:width
            transform: Rotation { origin.x: arm.width*0.5; origin.y: arm.height; angle: watchface.selAngle}
            anchors.horizontalCenter:  watchface.horizontalCenter
            antialiasing: true
        }
        Rectangle
        {
            id:armEnd
            color:centerDot.color
            width:Math.tan(0.35)*watchface.width*0.5/(1.0+Math.tan(0.35))
            height:width
            radius:width
            x:(watchface.width-armEnd.width)*(1.0+Math.sin(watchface.selAngle*Math.PI/180.0))*0.5
            y:(watchface.width-armEnd.width)*(1.0-Math.cos(watchface.selAngle*Math.PI/180.0))*0.5
        }

        Repeater
        {
            id:timeLabels
            model:12
            anchors.centerIn: watchface
            delegate: Item
            {
                id:timelabel
                required property int index
                width:Math.tan(0.261799388)*watchface.width*0.5/(1.0+Math.tan(0.261799388))
                height:width
                x:(watchface.width-width)*(1.0+Math.sin(index*Math.PI/6.0))*0.5
                y:(watchface.width-width)*(1.0-Math.cos(index*Math.PI/6.0))*0.5
                Label {
                    color:Style.frontColor1
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width:parent.width*0.8
                    height:parent.height*0.8
                    anchors.centerIn: parent
                    text: (watchface.isHourSelection)?((parent.index===0)?12:parent.index):parent.index*5
                    fontSizeMode:Text.Fit
                    font.pixelSize: 80
                }

            }
        }
        MouseArea
        {
            anchors.fill: watchface
            onClicked: (mouse) =>
                       {

                           if(Math.pow(mouse.x-watchface.width*0.5,2.0)+Math.pow(mouse.y-watchface.width*0.5,2.0)<Math.pow(watchface.width*0.5,2.0))
                           {

                               if(watchface.isHourSelection)
                               {
                                   watchface.selAngleHour=90+180*(Math.atan((mouse.y-watchface.width*0.5)/(mouse.x-watchface.width*0.5))/Math.PI)+
                                   ((mouse.x-watchface.width*0.5<0)?180:0);
                                   control.hour=Math.round(12.0*watchface.selAngleHour/360.0)%12;

                                   watchface.isHourSelection=false;

                               }
                               else
                               {
                                   watchface.selAngleMinute=90+180*(Math.atan((mouse.y-watchface.width*0.5)/(mouse.x-watchface.width*0.5))/Math.PI)+
                                   ((mouse.x-watchface.width*0.5<0)?180:0);
                                   control.minute=Math.round(60.0*watchface.selAngleMinute/360.0)%60;
                               }

                           }
                       control.selected();
                       }
        }

    }

    Rectangle
    {
        id: hourOrMinute

        width:Math.min(parent.width,parent.height)*0.2
        height:width*0.5

        anchors.bottom:watchface.top
        anchors.right: watchface.right
        color:"transparent"
        PrevButton
        {
            id:prev
            height:hourOrMinute.height
            width:height
            radius:width
            flat:true
            enabled: !watchface.isHourSelection
            anchors.rightMargin:  parent.width*0.1
            anchors.right:   parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                watchface.isHourSelection=true;

            }
        }
        NextButton
        {
            id:next
            anchors.leftMargin:  parent.width*0.1
            anchors.left:  parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height:prev.height
            width:height
            radius:width
            enabled: watchface.isHourSelection
            flat:true
            onClicked:
            {
                watchface.isHourSelection=false;
            }
        }
    }
    Rectangle
    {
        id: amOrPm

        width:parent.width
        height:Math.min(parent.height,parent.width)*0.1
        anchors.top:watchface.bottom
        color:"transparent"
        Button
        {
            id:ambutt
            anchors.right:   parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width:amOrPm.width*0.5
            height:amOrPm.height
            font.pixelSize: Math.min(width,height)*0.5
            enabled:control.hour>=12
            flat:true
            text: Qt.locale().amText
            onClicked:
            {
                control.hour-=12;
                control.selected();
            }
        }
        Button
        {
            id:pmbutt
            anchors.left:   parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width:amOrPm.width*0.5
            height:amOrPm.height
            font.pixelSize: Math.min(width,height)*0.5
            enabled:control.hour<12
            flat:true
            text: Qt.locale().pmText
            onClicked:
            {
                control.hour+=12;
                control.selected();
            }
        }

    }

}
