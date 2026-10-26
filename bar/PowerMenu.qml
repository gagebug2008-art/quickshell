import QtQuick
import Quickshell
import QtQuick.Controls
import qs.config
import qs.reusables

Item {
   id: root

   readonly property int btnHeight: 70
   property int btnWidth: 100

   readonly property string keys: "QWERT"

   width: row.implicitWidth + Config.spacing * 2
   height: parent.height

   readonly property var actions: [
      { icon: "locked.svg", cmd: ["hyprlock"], txt: "Lock" },
      { icon: "logout.svg", cmd: ["mmsg", "-d", "quit"], txt: "Logout" },
      { icon: "reboot.svg", cmd: ["systemctl", "reboot"], txt: "Reboot", danger: true },
      { icon: "off.svg", cmd: ["systemctl", "poweroff"], txt: "Terminate", danger: true }
   ]

   Row {
      id: row
      anchors.centerIn: parent
      spacing: 5

      Repeater {
         model: root.actions

         Rectangle {
            id: btn

            width: root.btnWidth
            height: root.btnHeight

            color: Config.primaryContainer
            radius: 3

            MouseArea {
               anchors.fill: parent
               onClicked: Quickshell.execDetached(modelData.cmd)
            }

            Column {
               anchors.centerIn: parent
               spacing: 4

               IconKirigami {
                  anchors.horizontalCenter: parent.horizontalCenter
                  icon: modelData.icon
                  implicitSize: 24
                  color: Config.onPrimaryContainer
               }

               StyledText {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: modelData.txt
                  color: Config.onPrimaryContainer
               }
            }
         }
      }
   }
}
