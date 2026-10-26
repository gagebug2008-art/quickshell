import QtQuick
import qs.config
import qs.reusables

Item {
   id: root

   required property var item
   required property bool focused
   required property int count
   required property var attach

   property int dotWidth: 6
   property int dotHeight: 3
   property int dotSpacing: 3

   anchors.bottom: attach.bottom
   anchors.bottomMargin: -4
   anchors.horizontalCenter: attach.horizontalCenter
   width: dots.width
   height: dots.height
   visible: count > 0

   Row {
      id: dots
      spacing: root.dotSpacing

      Repeater {
         model: root.count

         Rectangle {
            width: root.dotWidth
            height: root.dotHeight
            radius: root.dotHeight / 2
            color: "#ccffffff"
         }
      }
   }

   Rectangle {
      id: focusBar
      readonly property int dotsWidth: Math.max(0, root.count * root.dotWidth + (root.count - 1) * root.dotSpacing)

      visible: root.focused || width > dotsWidth
      width: root.focused ? root.attach.width * 0.45 : dotsWidth
      height: root.dotHeight
      radius: root.dotHeight / 2
      color: root.focused ? Config.secondary : "#ccffffff"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom

      Behavior on width { NumberAnimation { duration: 140 } }
      Behavior on color { ColorAnimation { duration: 140 } }
   }
}
