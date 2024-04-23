import Esterv.CustomControls.DateTimePickers
import Esterv.Styles.Simple
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window
    visible: true

    background: Rectangle {
        color: Style.backColor1
    }
    TimePicker {
        anchors.fill: parent
    }
}
