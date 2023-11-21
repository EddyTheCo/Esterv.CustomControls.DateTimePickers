import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import QtQml

ColumnLayout {
    id:root
    property alias initDate: monthview.sDate;
    property date selDate: new Date();

    signal dateSelected(date selDate);


    Component.onCompleted:
    {
        for (let i = 0; i < 200; i++) {
            yearmodel.append({"year":1900+i});
        }
    }


    RowLayout
    {
        Layout.fillWidth: true;
        Label
        {
            text:initDate.toLocaleDateString(Qt.locale(),"MMM yyyy");
            color: "steelblue"
        }
        Switch {
            id: yearChooser
        }
        Button
        {
            id:prevmonth
            Layout.alignment: Qt.AlignRight
            visible:!yearChooser.checked
            text:"prev"
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
        Button
        {
            id:nextmonth
            Layout.alignment: Qt.AlignRight
            text:"next"
            visible:!yearChooser.checked
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



    DayOfWeekRow {
        Layout.fillWidth: true
        visible:!yearChooser.checked
    }

    SwipeView {
        id: monthview

        property date sDate: new Date()
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible:!yearChooser.checked
        currentIndex: monthview.sDate.getMonth()
        interactive:false

        Repeater {
            model: 12
            MonthGrid {
                required property int index
                Layout.fillWidth: true
                Layout.fillHeight: true
                year:monthview.sDate.getFullYear()
                month: index
                onClicked: (date)=>
                           {
                               monthview.sDate=date;
                               root.selDate=monthview.sDate;
                               root.dateSelected(selDate);
                           }
            }

        }


    }


    GridView {
        id:yearSelector
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.maximumWidth: 400
        Component.onCompleted: positionViewAtIndex(monthview.sDate.getFullYear()-1900, GridView.Beginning)
        //currentIndex: monthview.sDate.getFullYear()-1900
        model:yearmodel
        visible:yearChooser.checked
        cellWidth:yearSelector.width*0.3333
        cellHeight:yearSelector.height*0.1666667

        clip:true
        ScrollBar.vertical: ScrollBar { }
        delegate:Button {
            text:year
            onClicked:{
                monthview.sDate.setFullYear(year);
            }
            highlighted:(year===monthview.sDate.getFullYear())
        }
        ListModel {
            id: yearmodel
        }


    }

}
