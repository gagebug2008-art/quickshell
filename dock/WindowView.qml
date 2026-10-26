import QtQuick
import Quickshell
import qs.config
Item {
   id: root

   required property var item
   required property var attach
   required property bool focused
   required property int count
   required property bool toggled

   property int bannerRise: toggled ? attach.height * 1.2 : 0
   readonly property real rise: toggled ? 80 : 0

   property int bannerWide: toggled ? attach.width * 0.8 : attach.width * 0.4

   anchors.centerIn: toggled ? undefined : attach 
   width: attach.width 
   height: attach.height 
   z: -1

   Behavior on height {
      NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
   }
   Behavior on width {
      NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
   }
   Rectangle {

   } 
}
