import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Scope {
   id: root

   FloatingWindow {
      visible: true // CRUCIAL: Makes the window actually show up
      implicitWidth: 300
      implicitHeight: 500
      color: "#222222"

      RowLayout { // Changed to ColumnLayout to stack items vertically
         anchors.fill: parent
         anchors.margins: 8
         spacing: 12

         // Debug info: shows if Quickshell detects any tray items at all
                 Repeater {
            model: SystemTray.items

            delegate: ColumnLayout {
               required property SystemTrayItem modelData

               spacing: 2

               Text {
                  text: modelData.title ? modelData.title : "Untitled Tray App"
                  color: "white"
                  font.bold: true
               }

               Loader {
                  active: modelData.hasMenu

                  sourceComponent: MenuLevel {
                     handle: modelData.menu
                  }
               }
            }
         }
      }
   }
}
