import Esterv.CustomControls.DateTimePickers
import Esterv.Styles.Simple
import QtQuick
import QtQuick.Controls


ApplicationWindow {
    visible: true
    id:window

    background:Rectangle
    {
        color:Style.backColor1
    }
    TimePicker
    {
        anchors.fill:parent
    }



}
