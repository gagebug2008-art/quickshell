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

   // full stage: pointer is on the raised area but no longer on the icon
   property bool toggledQ: hvrd.hovered && !toggled

   property real restHeight: attach.height   // resting banner height

   property int bannerRise: toggledQ ? attach.height * 1.2
                          : toggled ? attach.height * 0.25
                          : attach.height + attach.height / 7 - restHeight
   readonly property real rise: toggledQ ? 80 : toggled ? 18 : attach.height / 7

   property int bannerWide: toggledQ ? attach.width * 0.8
                          : toggled ? attach.width * 0.55
                          : attach.width * 0.4

   anchors.horizontalCenter: attach.horizontalCenter
   anchors.bottom: attach.bottom
   width: attach.width
   height: attach.height + rise
   z: -1

   Behavior on height {
      NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
   }

   HoverHandler { id: hvrd }

   Rectangle {
      id: banner
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: bannerRise
      anchors.top: parent.top
      width: bannerWide
      color: Config.backgroundText
      radius: width / 6
      Behavior on width {
         NumberAnimation { duration: 100;  }
      }
      Behavior on anchors.bottomMargin {
         NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
      }
   }
}
