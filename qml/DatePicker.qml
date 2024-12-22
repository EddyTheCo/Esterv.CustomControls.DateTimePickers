pragma ComponentBehavior: Bound
import QtQuick.Controls
import QtQuick
import QtQml
import Esterv.Styles.Simple
import Esterv.CustomControls

Item {
    id: control
    property alias initDate: monthview.sDate
    property date selDate
    property alias chooseYear: yearChooser.checked

    Component.onCompleted: {
        for (let i = 0; i < 200; i++) {
            yearmodel.append({
                "year": 1900 + i
            });
        }
    }

    Item {
        id: calendarMenu
        height: control.height * 0.07
        width: control.width
        Rectangle {
            id: yearChooser
            color: "transparent"
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.1
            width: parent.width * 0.4
            height: parent.height
            property bool checked: false

            onCheckedChanged: {
                shaderyearChooser.iTime = (yearChooser.checked) ? 1.0 : 0.0;
            }

            Label {
                id: yearlabel
                text: control.initDate.toLocaleDateString(Qt.locale(), "MMM yyyy")
                color: Style.frontColor2
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                fontSizeMode: Text.Fit
                font.pixelSize: 80
                height: yearChooser.height
                width: yearChooser.width * 0.8
            }
            Item {
                id: yeartoogle
                anchors.left: yearlabel.right
                anchors.margins: 5
                anchors.verticalCenter: yearlabel.verticalCenter
                width: yearChooser.height
                height: yearChooser.width * 0.2

                ShaderEffect {
                    id: shaderyearChooser
                    property var src: yeartoogle
                    property color fcolor: Style.frontColor2
                    anchors.centerIn: yeartoogle
                    width: Math.min(parent.width, parent.height) * 0.5
                    height: width
                    property real iTime: 0.0
                    Behavior on iTime {
                        SmoothedAnimation {
                            velocity: 3.0
                        }
                    }
                    property var pixelStep: Qt.vector2d(1 / src.width, 1 / src.height)
                    fragmentShader: "qrc:/esterVtech.com/imports/Designs/frag/filledArrowHead.frag.qsb"
                }
            }
            MouseArea {
                anchors.fill: yearChooser
                onClicked: yearChooser.checked = !yearChooser.checked
            }
        }
        Rectangle {
            id: monthChooser
            width: parent.width * 0.3
            height: parent.height
            anchors.right: parent.right
            anchors.margins: parent.width * 0.1
            opacity: 1.0 - shaderyearChooser.iTime
            visible: shaderyearChooser.iTime < 0.8
            color: "transparent"
            PrevButton {
                id: prevmonth
                height: yearlabel.height
                width: height
                radius: height
                anchors.rightMargin: parent.width * 0.1
                anchors.right: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                flat: true
                onClicked: {
                    let m = (monthview.sDate.getMonth() + 11) % 12;
                    if (m === 11) {
                        monthview.sDate.setFullYear(monthview.sDate.getFullYear() - 1);
                        monthview.setCurrentIndex(11);
                    } else {
                        monthview.decrementCurrentIndex();
                    }
                    monthview.sDate.setMonth(m);
                }
            }

            NextButton {
                id: nextmonth
                anchors.leftMargin: parent.width * 0.1
                anchors.left: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: prevmonth.height
                width: height
                radius: height
                flat: true
                onClicked: {
                    let m = (monthview.sDate.getMonth() + 1) % 12;
                    if (m === 0) {
                        monthview.sDate.setFullYear(monthview.sDate.getFullYear() + 1);
                        monthview.setCurrentIndex(0);
                    } else {
                        monthview.incrementCurrentIndex();
                    }
                    monthview.sDate.setMonth(m);
                }
            }
        }
    }

    Item {
        id: calendar

        height: control.height * 0.93
        width: control.width
        opacity: 1.0 - shaderyearChooser.iTime
        visible: shaderyearChooser.iTime < 0.8
        anchors.top: calendarMenu.bottom

        DayOfWeekRow {
            id: dayOfWeek
            height: parent.height * 0.1
            width: parent.width
            delegate: Rectangle {
                color: "transparent"
                Label {
                    width: parent.width * 0.8
                    height: parent.height * 0.8
                    anchors.centerIn: parent
                    text: parent.shortName
                    fontSizeMode: Text.Fit
                    font.pixelSize: 80
                    color: Style.frontColor3
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                required property string shortName
            }
        }
        SwipeView {
            id: monthview
            height: parent.height - dayOfWeek.height
            width: parent.width
            anchors.top: dayOfWeek.bottom
            property date sDate: new Date()
            currentIndex: monthview.sDate.getMonth()
            interactive: false

            Repeater {
                model: 12
                MonthGrid {
                    id: monthGrid
                    required property int index
                    year: monthview.sDate.getFullYear()
                    month: index
                    delegate: Item {
                        id: dayrect
                        required property var model
                        opacity: model.month === monthGrid.month ? 1 : 0

                        RoundButton {
                            id: daybutton
                            anchors.centerIn: parent
                            width: Math.min(parent.width, parent.height)
                            height: width
                            radius: width
                            text: parent.model.day
                            flat: true
                            font.pixelSize: width * 0.35
                            highlighted: (parent.model.month === control.selDate.getMonth() && parent.model.year === control.selDate.getFullYear() && parent.model.day === control.selDate.getDate())
                            onClicked: {
                                monthview.sDate = dayrect.model.date;
                                control.selDate = dayrect.model.date;
                            }
                        }
                    }
                }
            }
        }
    }

    GridView {
        id: yearSelector
        height: control.height * 0.93
        width: control.width
        anchors.top: calendarMenu.bottom
        opacity: shaderyearChooser.iTime
        visible: shaderyearChooser.iTime > 0.8
        Component.onCompleted: positionViewAtIndex(monthview.sDate.getFullYear() - 1900, GridView.Beginning)

        model: yearmodel

        cellWidth: yearSelector.width * 0.3333
        cellHeight: yearSelector.height * 0.1666667

        clip: true
        ScrollBar.vertical: ScrollBar {}
        delegate: RoundButton {
            required property int year
            width: yearSelector.cellWidth * 0.6
            height: yearSelector.cellHeight * 0.9
            text: year
            flat: true
            highlighted: year === monthview.sDate.getFullYear()
            font.pixelSize: Math.min(height, width) * 0.35
            radius: Math.min(height, width) * 0.5
            onClicked: {
                monthview.sDate.setFullYear(year);
                yearChooser.checked = false;
            }
        }

        ListModel {
            id: yearmodel
        }
    }
}
