import QtQuick
import Quickshell.Wayland
import qs.config

Item {
   id: root

   property int size: 4
   property real bakSize: size * 1.5

   required property var item   
   readonly property bool open: (item?.windows?.length ?? 0) > 0
   readonly property bool focused: open && ToplevelManager.activeToplevel?.appId === item.appId
   property int count: item.count

   implicitWidth: bakSize
   implicitHeight: bakSize

   opacity: open ? 1 : 0
   visible: opacity > 0

   Behavior on opacity {
      NumberAnimation { duration: 120 }
   }

   Rectangle {
      id: bak
      anchors.centerIn: main
      
width: root.focused ? root.bakSize * 3 : root.bakSize

height: root.bakSize


      radius: height / 2
      color: Config.background

      Behavior on width {
         NumberAnimation { duration: 220; easing: Easing.OutBack }
      }
   }

   Rectangle {
      id: main
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      width: root.focused ? root.size * 4 : root.size
      height: root.size
      radius: height / 2
      color: root.focused ? Config.secondary : "#ccffffff"

      Behavior on width {
         NumberAnimation { duration: 220; easing: Easing.OutBack }
      }
      Behavior on color {
         ColorAnimation { duration: 80 }
      }
   }

   Item {
      id: container
     
   }
}
