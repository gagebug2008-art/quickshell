import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.reusables
import qs.config

Item  {
   id: root
   width:  filteredEntries.length === 0 ? 370 : 420
   height: listWrap.height + searchBar.height + 14 + root.pad

   property alias sb: searchBar
   required property var parCont
   readonly property int pad: 10

   property bool sbTop: false
   property bool enabledQ: false

   property list<DesktopEntry> entries: DesktopEntries.applications.values
   property list<DesktopEntry> sortedEntries: entries.slice().sort((a, b) => a.name.localeCompare(b.name))

   property var query: searchBar.query
   property var filteredEntries: {
      const q = root.query.trim().toLowerCase()
      if (q === "")
         return root.sortedEntries
      return root.sortedEntries.filter(e => e.name.toLowerCase().includes(q))
   }
   
   visible: opacity === 0 ? false : true
   enabled: enabledQ
   opacity: enabledQ ? 1 : 0

   Keys.onEscapePressed: Quickshell.execDetached(["qs", "ipc", "call", "bottom", "launcherToggle"])

   IpcHandler {
      target: "bottom"

      function launcherToggle() {
         root.enabledQ = !root.enabledQ
         searchBar.text = ""
      }
   }

   SearchBar {
      id: searchBar

      property var entry: root.sbTop
         ? root.filteredEntries[0]
         : root.filteredEntries[root.filteredEntries.length - 1]

      focus: true

      //anchors.left: filteredEntries.length !== 0 ? listWrap.left : parent.left
      //anchors.right: filteredEntries.length !== 0 ? listWrap.right : parent.right
      anchors.top: root.sbTop ? parent.top : listWrap.bottom
      anchors.topMargin: 8
      anchors.horizontalCenter: parent.horizontalCenter
      width: root.width - root.pad * 2
      Behavior on width {NumberAnimation{duration: 120; easing: Easing.InOutCirc}}
      onSubmitted: {
         if (entry)
            entry.execute()
         Quickshell.execDetached(["qs", "ipc", "call", "bottom", "launcherToggle"])
      }
      Keys.onUpPressed: listView.decrementCurrentIndex()
      Keys.onDownPressed: listView.incrementCurrentIndex()
   }
   Item {
   id: error
   anchors.top: root.sbTop ? searchBar.bottom : parent.top
   anchors.topMargin: 6
   anchors.horizontalCenter: parent.horizontalCenter
      width: root.width - root.pad * 2
   height: root.filteredEntries.length === 0 ? 200 : 0
   visible: root.filteredEntries.length === 0

   Column {
      anchors.centerIn: parent
      spacing: 8

      StyledText {
         anchors.horizontalCenter: parent.horizontalCenter
         text: "The birds have left"
         font.pixelSize: 14
      }

      StyledText {
   id: kirbForm
   anchors.horizontalCenter: parent.horizontalCenter
   textFormat: Text.PlainText
   text: "<('-'<)"
   font.pixelSize: 18
   color: Qt.hsla(Math.random(), 0.8, 0.7, 1)

}   }

   Timer {
      interval: 130
      running: filteredEntries.length === 0 
      repeat: true
      onTriggered: {
         kirbForm.text = kirbForm.text === "<('-'<)" ? "(>'-')>" : "<('-'<)"
               kirbForm.color = Qt.hsla(Math.random(), 0.8, 0.7, 1)

      }
   }
}
   Item {
      id: listWrap
      
height: root.filteredEntries.length === 0
         ? 200
         : Math.min(root.filteredEntries.length * listView.itemH, 400)
      opacity: filteredEntries.length !== 0 ? 1 : 0
      visible: opacity !== 0 && enabledQ 
      width: root.width - root.pad * 2
      Behavior on width {NumberAnimation{duration: 120; easing: Easing.InOutCirc}}
      
      Behavior on opacity { NumberAnimation {}}
      anchors.top: root.sbTop ? searchBar.bottom : parent.top
      anchors.topMargin: 6
      anchors.horizontalCenter: parent.horizontalCenter
      clip: true

      ListView {
         id: listView
         model: root.filteredEntries
         anchors.fill: parent

         readonly property int itemH: 40

         snapMode: ListView.SnapToItem
         keyNavigationEnabled: true
         
         

         focus: true
         // sbTop: normal list. Otherwise items sit at the bottom, next to the bar.
         header: Item {
            width: listView.width
            height: root.sbTop ? 0 : Math.max(0, listView.height - listView.count * listView.itemH)
         }

         onCountChanged: {
            currentIndex = 0
            positionViewAtBeginning()
         }

         delegate: Item {
            id: delegate
            readonly property var entry: DesktopEntries.heuristicLookup(modelData.id)

            width: parent.width
            height: listView.itemH

            Rectangle {
               id: hvrdBack

               anchors.fill: parent
               opacity: delegate.ListView.isCurrentIndex ? 1 : hvrd.hovered ? 1 : 0
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
