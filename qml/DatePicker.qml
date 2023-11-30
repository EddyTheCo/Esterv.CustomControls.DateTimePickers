import QtQuick.Controls
import QtQuick
import QtQml
import MyDesigns

Item {
    id:control
    property alias initDate: monthview.sDate;
    property date selDate;
    property alias chooseYear:yearChooser.checked


    FontLoader {
        id: lFont
        source: "qrc:/esterVtech.com/imports/DTPickers/fonts/Roboto/Roboto-Light.ttf"
    }
    FontLoader {
        id: rFont
        source: "qrc:/esterVtech.com/imports/DTPickers/fonts/Roboto/Roboto-Regular.ttf"
    }
    Component.onCompleted:
    {
        for (let i = 0; i < 200; i++) {
            yearmodel.append({"year":1900+i});
        }
    }

    Item
    {
        id:calendarMenu
        height:  control.height*0.07
        width:control.width
        Rectangle
        {
            id: yearChooser
            color:"transparent"
            anchors.left: parent.left
            anchors.leftMargin: parent.width*0.1
            width:parent.width*0.4
            height:parent.height
            property bool checked:false

            onCheckedChanged:
            {
                shaderyearChooser.iTime=(yearChooser.checked)?1.0:0.0;
            }

            Label
            {
                id:yearlabel
                text:initDate.toLocaleDateString(Qt.locale(),"MMM yyyy");
                color: CustomStyle.frontColor1
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                fontSizeMode:Text.Fit
                font.pixelSize: 80
                font.family: rFont.font.family
                font.weight: rFont.font.weight
                height:yearChooser.height
                width:yearChooser.width*0.8
            }
            Item {
                id:yeartoogle
                anchors.left:yearlabel.right
                anchors.margins: 5
                anchors.verticalCenter:  yearlabel.verticalCenter
                width: yearChooser.height
                height: yearChooser.width*0.2

                ShaderEffect
                {
                    id:shaderyearChooser
                    property var src:yeartoogle
                    property color fcolor: CustomStyle.frontColor1
                    anchors.centerIn:  yeartoogle;
                    width:Math.min(parent.width,parent.height)*0.5
                    height:width
                    property real iTime:0.0;
                    Behavior on iTime { SmoothedAnimation { velocity: 3.0} }
                    property var pixelStep: Qt.vector2d(1/src.width, 1/src.height)
                    fragmentShader: "qrc:/esterVtech.com/imports/MyDesigns/frag/filledArrowHead.frag.qsb"
                }

            }
            MouseArea
            {
                anchors.fill: yearChooser
                onClicked:yearChooser.checked=!yearChooser.checked
            }

        }
        Rectangle
        {
            id: monthChooser
            width:parent.width*0.3
            height:parent.height
            anchors.right:parent.right
            anchors.margins: parent.width*0.1
            opacity:1.0-shaderyearChooser.iTime
            visible: shaderyearChooser.iTime<0.8
            color:"transparent"
            Rectangle
            {
                id:prevmonth
                height:yearlabel.height*0.6
                width:height
                radius:width
                color:prevarea.containsMouse?CustomStyle.midColor1:"transparent"
                anchors.rightMargin:  parent.width*0.1
                anchors.right:   parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                ShaderEffect
                {
                    id:prevshader
                    property var src:prevmonth
                    property color fcolor:CustomStyle.frontColor1
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
                    onClicked:
                    {
                        let m=(monthview.sDate.getMonth()+11)%12;
                        if(m===11)
                        {
                            monthview.sDate.setFullYear(monthview.sDate.getFullYear()-1);
                            monthview.setCurrentIndex(11);

                        }
                        else
                        {
                            monthview.decrementCurrentIndex();
                        }
                        monthview.sDate.setMonth(m);

                    }
                }


            }
            Rectangle
            {
                id:nextmonth
                anchors.leftMargin:  parent.width*0.1
                anchors.left:  parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height:prevmonth.height
                width:height
                radius:width
                color:nextarea.containsMouse?CustomStyle.midColor1:"transparent"
                ShaderEffect
                {
                    id:nextshader
                    property var src:nextmonth
                    property color fcolor:CustomStyle.frontColor1
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
                    onClicked:
                    {
                        let m=(monthview.sDate.getMonth()+1)%12;
                        if(m===0)
                        {
                            monthview.sDate.setFullYear(monthview.sDate.getFullYear()+1);
                            monthview.setCurrentIndex(0);
                        }
                        else
                        {
                            monthview.incrementCurrentIndex();
                        }
                        monthview.sDate.setMonth(m);
                    }
                }
            }
        }

    }


    Item
    {
        id:calendar

        height:control.height*0.93
        width:control.width
        opacity:1.0 - shaderyearChooser.iTime
        visible: shaderyearChooser.iTime<0.8
        anchors.top: calendarMenu.bottom

        DayOfWeekRow {
            id:dayOfWeek
            height:parent.height*0.1
            width:parent.width
            delegate: Rectangle {
                color:"transparent"
                Label
                {
                    anchors.fill: parent
                    text: shortName
                    fontSizeMode:Text.Fit
                    font.pixelSize: 80
                    font.family: lFont.font.family
                    font.weight: lFont.font.weight
                    color: CustomStyle.midColor1
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                required property string shortName
            }
        }
        SwipeView {
            id: monthview
            height:parent.height-dayOfWeek.height
            width:parent.width
            anchors.top: dayOfWeek.bottom
            property date sDate: new Date()
            currentIndex: monthview.sDate.getMonth()
            interactive:false

            Repeater {
                model: 12
                MonthGrid {
                    id:monthGrid
                    required property int index
                    year:monthview.sDate.getFullYear()
                    month: index

                    delegate: Item {
                        id:dayrect
                        required property var model
                        opacity: model.month === monthGrid.month ? 1 : 0
                        Rectangle
                        {
                            anchors.centerIn: parent
                            width:Math.min(parent.width,parent.height)
                            height:width
                            radius: width
                            color: (model.month===control.selDate.getMonth()&&model.year===control.selDate.getFullYear()&&model.day===control.selDate.getDate())?CustomStyle.frontColor2:(dayarea.containsMouse?CustomStyle.midColor1:"transparent")

                            Text{
                                id:daytext
                                text:model.day
                                color:CustomStyle.frontColor1
                                anchors.centerIn: parent
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                fontSizeMode:Text.Fit
                                font.pixelSize: Math.min(parent.width,parent.height)*0.4
                            }
                            MouseArea
                            {
                                id:dayarea
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: ()=>
                                           {
                                               monthview.sDate=dayrect.model.date;
                                               control.selDate=dayrect.model.date;
                                           }
                            }
                        }
                    }
                }

            }


        }
    }


    GridView {
        id:yearSelector
        height:   control.height*0.93
        width: control.width
        anchors.top: calendarMenu.bottom
        opacity: shaderyearChooser.iTime
        visible: shaderyearChooser.iTime>0.8
        Component.onCompleted: positionViewAtIndex(monthview.sDate.getFullYear()-1900, GridView.Beginning)

        model:yearmodel

        cellWidth:yearSelector.width*0.3333
        cellHeight:yearSelector.height*0.1666667

        clip:true
        ScrollBar.vertical: ScrollBar { }
        delegate: Rectangle {
            width:yearSelector.cellWidth*0.6
            height:yearSelector.cellHeight*0.9
            radius:height*0.5
            color: (year===monthview.sDate.getFullYear())?CustomStyle.frontColor2:(yeararea.containsMouse)?CustomStyle.midColor1:"transparent"
            Text{
                id:yeartext
                text:year
                color:CustomStyle.frontColor1
                anchors.centerIn: parent
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode:Text.Fit
                font.pixelSize: parent.height*0.5
                font.family: lFont.font.family
                font.weight: lFont.font.weight
            }


            MouseArea
            {
                id:yeararea
                anchors.fill: parent
                hoverEnabled: true
                onClicked:{
                    monthview.sDate.setFullYear(year);
                    yearChooser.checked=false;
                }
            }
        }
        ListModel {
            id: yearmodel
        }


    }

}
