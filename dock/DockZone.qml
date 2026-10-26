import QtQuick
import Quickshell.Io

Item {
   id: zone

   required property RealDock dock

   property alias inputZone: inputZone 

   readonly property var d: realDock
   property real exclusiveHeight: d.exclusiveHeight 
   readonly property real shownHeight: d.height + 6

   IpcHandler {
      target: "dock"
      function toggle(): void { zone.d.barToggle(); }
      function toggleAuto(): void { zone.d.autoHide = !zone.d.autoHide; }
   }

   Item {
      id: inputZone
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      width: parent.width
      height: zone.d.barHide ? zone.d.triggerHeight : zone.shownHeight

      HoverHandler {
         onHoveredChanged: zone.d.setPointerNear(hovered)
      }
   }
}
