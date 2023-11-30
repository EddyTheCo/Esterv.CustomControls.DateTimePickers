import DTPickers
import QtQuick
import QtQuick.Controls


ApplicationWindow {
    visible: true
    id:window

   ShowDateTime
   {
       anchors.fill:parent
       initDate:new Date('December 10, 1990 04:25:00')
   }



}
