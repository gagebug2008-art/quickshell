import QtQuick
import Quickshell
import qs.reusables

Item {
   id: root
   
   property var pinAction: ""

   height: parent.height
   width: height

   IconKirigami {
      id: icon
      implicitSize: root.height/2
      icon: "not-pinned.svg"
      anchors.centerIn: parent

   }
   MouseArea {
      anchors.fill: parent
      onClicked: pinAction
   }
}
