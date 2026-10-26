import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.reusables
import qs.config

PanelWindow {
   id: temp
   color: " transparent"
   width: 420
   height: 450 
   WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
   visible: false
   Item {
      id: root
      
      property list<DesktopEntry> entries: DesktopEntries.applications.values

      property list<DesktopEntry> sortedEntries: entries.slice().sort((a, b) => a.name.localeCompare(b.name))
      anchors.fill: parent
      property var query: searchBar.query

      property var filteredEntries: {
         const q = root.query.trim().toLowerCase()
         if (q === "")
            return root.sortedEntries
         return root.sortedEntries.filter(e => e.name.toLowerCase().includes(q))
      }
 
      Bubble { anchors.fill: parent; anchors.margins: 0 } 
      
      IpcHandler {
         id: ipc
         target: "temp"
      function launcherToggle() {
         temp.visible = !temp.visible;
         searchBar.text = '' 
      }
      }
     
      SearchBar {
         id: searchBar

         property var entry: root.filteredEntries[0]
         focus: true 

         anchors.left: listWrap.left
         anchors.right: listWrap.right
         anchors.top: parent.top
         anchors.topMargin: 8 
         onSubmitted: {
            entry.execute()
            ipc.launcherToggle()           

         }
         Keys.onEscapePressed: ipc.launcherToggle()           
      }
      Item {
      anchors.top: searchBar.bottom
      }
      Item {
         id: listWrap
         height: 400
         width: 400
         anchors.top: searchBar.bottom
         anchors.topMargin: 6
         anchors.horizontalCenter: parent.horizontalCenter
         clip: true

         ListView {
            id: listView
            model: root.filteredEntries
            anchors.fill: parent
            required property var modelData

            snapMode: ListView.SnapToItem
            keyNavigationEnabled: true

            delegate: Item {
               id: delegate
               readonly property var entry: DesktopEntries.heuristicLookup(modelData.id)

               width: parent.width
               height: 40

               
                  Rectangle {
                     id: hvrdBack

                     anchors.fill: parent
                     opacity: ListView.isCurrentIndex ? 1 : hvrd.hovered ? 1 : 0
                     color: Qt.alpha(Config.inversePrimary, 0.6)
                     radius: 4

                     Behavior on opacity { NumberAnimation { duration: 80 } }
                  }

               Row {
                  spacing: 6
                  anchors.verticalCenter: parent.verticalCenter
                  anchors.left: parent.left
                  anchors.leftMargin: 2
                  Image {
                     height: 36
                     width: height
                     source: Quickshell.iconPath(modelData.icon, "application-x-executable")
                     anchors.verticalCenter: parent.verticalCenter

                  }
                  
                  StyledText {
                     id: text
                     font.pixelSize: 17
                     anchors.verticalCenter: parent.verticalCenter
                     text: modelData.name
                     color: Config.backgroundText
                  
                  }
               }
               
               HoverHandler {
                     id: hvrd
                  }

               MouseArea {
                  id: mouseArea
                  anchors.fill: delegate

                  onClicked: {
                     delegate.entry.execute()
                  }
               }
            }
         }
      }
   }
}
