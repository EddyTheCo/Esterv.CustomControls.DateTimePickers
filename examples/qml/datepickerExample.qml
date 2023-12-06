import QtQuick
import QtQuick.Controls
import Esterv.CustomControls.DateTimePickers
import Esterv.Styles.Simple
ApplicationWindow {
    visible: true
    id:window

    background:Rectangle
    {
        color:Style.backColor1
    }

    DatePicker
    {
        anchors.fill:parent
    }



}
