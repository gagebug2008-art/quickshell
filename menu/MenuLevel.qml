import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.reusables
import qs.components.corners
Item {
   id: root

   required property QsMenuHandle handle
   property var openEntry: null
   
   implicitWidth: containerOne.implicitWidth
   implicitHeight: containerOne.implicitHeight

   QsMenuOpener {
      id: opener
      menu: root.handle
   }
property real topLeftRadius: Config.radius
property real bottomLeftRadius: Config.radius
property real topRightRadius: Config.radius
property real bottomRightRadius: Config.radius

Rectangle {
   id: background
   anchors.centerIn: containerOne
   width:containerOne.width + 4
   height:containerOne.height + 4
   color: Config.background
   radius: Config.radius
   topLeftRadius: root.topLeftRadius
   bottomLeftRadius: root.bottomLeftRadius
   topRightRadius: root.topRightRadius
   bottomRightRadius: root.bottomRightRadius
}
   ColumnLayout {
      id: containerOne
      spacing: 0
      
      Repeater {
         model: opener.children

         delegate: Item {
            id: delegate

            required property QsMenuEntry modelData
            readonly property bool openS: root.openEntry === delegate
            property var submenu: null
            readonly property bool overhangs: submenu !== null
   && y + submenu.height > root.height
            Layout.fillWidth: true
            implicitWidth: item.implicitWidth + 4
            implicitHeight: delegate.modelData.isSeparator ? 9 : item.implicitHeight
            RoundCorner {
   corner: RoundCorner.CornerEnum.BottomLeft
   color: Config.background
   x: delegate.width + 2
   y: -size - 2 
   visible: delegate.submenu !== null 
   size: Config.radius
}

RoundCorner {
   corner: RoundCorner.CornerEnum.TopLeft
   color: Config.background
   x: delegate.width + 2
y: delegate.submenu ? delegate.submenu.height + 2: 0
visible: delegate.submenu !== null && !delegate.overhangs
   size: Config.radius
} 
            Binding {
               target: delegate.submenu
               property: "x"
               value: root.width + 4
               when: delegate.submenu !== null
            }

            function openSub() {
               const comp = Qt.createComponent("MenuLevel.qml")

               if (comp.status !== Component.Ready) {
                  console.log(comp.errorString())
                  return
               }

submenu = comp.createObject(delegate, {
   handle: modelData,
   topLeftRadius: 0,
   bottomLeftRadius: 0
})
            }

            function closeSub() {
               if (submenu) {
                  submenu.destroy()
                  submenu = null
               }
            }

            onOpenSChanged: openS ? openSub() : closeSub()
            Component.onDestruction: closeSub()

            Row {
               id: item
               anchors.left: parent.left
               anchors.right: parent.right
               anchors.margins: 4
               StyledText {
                  id: label
                  text: delegate.modelData.text
               }

               IconKirigami {
                  id: subMenuIcon
                  icon: "caret-right.svg"
                  visible: delegate.modelData.hasChildren
               }
            }

            MouseArea {
               anchors.fill: parent
               enabled: !delegate.modelData.isSeparator

               onClicked: {
                  if (delegate.modelData.hasChildren)
                  root.openEntry = (root.openEntry === delegate) ? null : delegate                  
                  else
                     delegate.modelData.triggered()
               }
            }
         }
      }
   }
}
