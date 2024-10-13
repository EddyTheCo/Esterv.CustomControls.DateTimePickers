import QtQuick
import QtQuick.Controls
import Esterv.CustomControls.DateTimePickers
import Esterv.Styles.Simple
import Esterv.CustomControls

ApplicationWindow {
    id: window
    visible: true

    background: Rectangle {
        color: Style.backColor1
    }
    ThemeSwitch {
        id: themeswitch
        width: 50
        height: 50
    }

    ShowDateTimePicker {
        height: parent.height - themeswitch.height
        width: parent.width
        anchors.top: themeswitch.bottom
        //initDate:new Date('December 10, 1990 04:25:00')
        //mode:DateTimePicker.Mode.DateOnly
    }
}
