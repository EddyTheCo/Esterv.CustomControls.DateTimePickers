import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import QtQml
import MyDesigns

Item
{
    id:control
    property date selDate: new Date();
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
        id:watchface
        anchors.centerIn: parent
        width:Math.min(parent.width,parent.height)*0.8
        height:width
        radius:width
        property bool isHourSelection:true
        property real selAngleHour:0
        property real selAngleMinute:0
        property real selAngle:(isHourSelection)?selAngleHour:selAngleMinute
        Behavior on selAngle { SmoothedAnimation { velocity: 180.0} }
        Rectangle
        {
            id:centerDot
            color:CustomStyle.frontColor2
            width:watchface.width*0.05
            height:width
            radius:width
            anchors.centerIn: watchface
        }
        Rectangle
        {
            id:arm
            color:CustomStyle.frontColor2
            width:watchface.width*0.02
            height:watchface.width*0.5
            transform: Rotation { origin.x: arm.width*0.5; origin.y: arm.height; angle: watchface.selAngle}
            anchors.left: centerDot.Center
            anchors.horizontalCenter:  watchface.horizontalCenter
            antialiasing: true
        }
        Rectangle
        {
            id:armEnd
            color:CustomStyle.frontColor2
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
            delegate: Rectangle
            {
                id:timelabel
                required property int index
                color:"transparent"
                width:Math.tan(0.261799388)*watchface.width*0.5/(1.0+Math.tan(0.261799388))
                height:width
                //radius:width
                x:(watchface.width-width)*(1.0+Math.sin(index*Math.PI/6.0))*0.5
                y:(watchface.width-width)*(1.0-Math.cos(index*Math.PI/6.0))*0.5
                Label {
                    color:CustomStyle.frontColor1
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width:parent.width*0.8
                    height:parent.height*0.8
                    anchors.centerIn: parent
                    text: (watchface.isHourSelection)?((index===0)?12:index):index*5
                    font.family: rFont.font.family
                    font.weight: rFont.font.weight
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
                                   control.selDate.setHours(Math.round(12.0*watchface.selAngleHour/360.0));
                                   watchface.isHourSelection=false;
                               }
                               else
                               {
                                   watchface.selAngleMinute=90+180*(Math.atan((mouse.y-watchface.width*0.5)/(mouse.x-watchface.width*0.5))/Math.PI)+
                                   ((mouse.x-watchface.width*0.5<0)?180:0);
                                   control.selDate.setMinutes(Math.round(60.0*watchface.selAngleMinute/360.0)%60);
                               }


                           }
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
        Rectangle
        {
            id:prev
            height:hourOrMinute.height*0.6
            width:height
            radius:width
            color:prevarea.containsMouse?CustomStyle.midColor1:"transparent"
            anchors.rightMargin:  parent.width*0.1
            anchors.right:   parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            ShaderEffect
            {
                id:prevshader
                property var src:prev
                property color fcolor:(watchface.isHourSelection)?CustomStyle.midColor1:CustomStyle.frontColor1
                height:parent.height*0.7
                width:height
                anchors.verticalCenter:  parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.height*0.2
                property real iTime:0.5;
                property var pixelStep: Qt.vector2d(1/src.width, 1/src.height)
                fragmentShader: "qrc:/esterVtech.com/imports/MyDesigns/frag/hollowArrowHead.frag.qsb"
            }
            MouseArea
            {
                id:prevarea
                anchors.fill: parent
                hoverEnabled : true
                enabled:!watchface.isHourSelection
                onClicked:
                {
                    watchface.isHourSelection=true;

                }
            }


        }
        Rectangle
        {
            id:next
            anchors.leftMargin:  parent.width*0.1
            anchors.left:  parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height:prev.height
            width:height
            radius:width
            color:nextarea.containsMouse?CustomStyle.midColor1:"transparent"
            ShaderEffect
            {
                id:nextshader
                property var src:next
                property color fcolor:(watchface.isHourSelection)?CustomStyle.frontColor1:CustomStyle.midColor1
                height:parent.height*0.7
                width:height
                anchors.verticalCenter:  parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: parent.height*0.2
                property real iTime:1.5;
                property var pixelStep: Qt.vector2d(1/src.width, 1/src.height)
                fragmentShader: "qrc:/esterVtech.com/imports/MyDesigns/frag/hollowArrowHead.frag.qsb"
            }
            MouseArea
            {
                id:nextarea
                anchors.fill: parent
                hoverEnabled : true
                enabled:watchface.isHourSelection
                onClicked:
                {
                    watchface.isHourSelection=false;
                }
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
        Rectangle
        {
            id:ammask
            anchors.rightMargin:  parent.width*0.05
            anchors.right:   parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width:am.contentWidth
            height:am.contentHeight
            radius:Math.min(width,height)*0.1
            color:control.selDate.getHours()>=12&&amarea.containsMouse?CustomStyle.midColor1:"transparent"
            MouseArea
            {
                id:amarea
                anchors.fill: parent
                hoverEnabled : true
                enabled:control.selDate.getHours()>=12
                onClicked:
                {
                    control.selDate.setHours(control.selDate.getHours()-12);
                }
            }
        }

        Label
        {
            id:am
            height:amOrPm.height*0.6
            width:amOrPm.width*0.5
            color:control.selDate.getHours()<12||amarea.containsMouse?CustomStyle.frontColor1:CustomStyle.midColor1

            anchors.rightMargin:  parent.width*0.05
            anchors.right:   parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            fontSizeMode:Text.Fit
            font.pixelSize: 80
            font.family: (control.selDate.getHours()<12)?rFont.font.family:lFont.font.family
            font.weight: (control.selDate.getHours()<12)?rFont.font.weight:lFont.font.weight
            text:new Date('December 17, 1995 03:24:00').toLocaleTimeString(Qt.locale(),"a");



        }



        Rectangle
        {
            id:pmmask
            anchors.leftMargin:  parent.width*0.05
            anchors.left:   parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width:pm.contentWidth
            height:pm.contentHeight
            radius:Math.min(width,height)*0.1
            color:control.selDate.getHours()<12&&pmarea.containsMouse?CustomStyle.midColor1:"transparent"
            MouseArea
            {
                id:pmarea
                anchors.fill: parent
                hoverEnabled : true
                enabled:control.selDate.getHours()<12
                onClicked:
                {
                    control.selDate.setHours(control.selDate.getHours()+12);
                }
            }

        }

        Label
        {
            id:pm
            height:amOrPm.height*0.6
            width:amOrPm.width*0.5
            color:control.selDate.getHours()>=12||pmarea.containsMouse?CustomStyle.frontColor1:CustomStyle.midColor1
            text: new Date('December 17, 1995 18:24:00').toLocaleTimeString(Qt.locale(),"a");
            anchors.leftMargin:  parent.width*0.05
            anchors.left:   parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            fontSizeMode:Text.Fit
            font.pixelSize: 80
            font.family: (control.selDate.getHours()>=12)?rFont.font.family:lFont.font.family
            font.weight: (control.selDate.getHours()>=12)?rFont.font.weight:lFont.font.weight



        }
    }
}
