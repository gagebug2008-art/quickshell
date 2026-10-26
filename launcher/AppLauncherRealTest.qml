import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.reusables
import qs.config

Item {
   id: root
   width: noresult ? 370 : 420
   height: listWrap.height + searchBar.height + root.pad * (listWrap.height > 0 ? 3 : 2)

   property alias sb: searchBar
   required property var parCont
   readonly property int pad: 10

   property bool commandMode: searchBar.query.startsWith(":")
   property var activeModel: commandMode ? cm.commands : dk.filteredEntries
   property bool kirby: false
   property bool sbTop: false
   property bool enabledQ: false
   property bool noresult: commandMode ? false : dk.filteredEntries.length === 0
   property bool showTestBar: false
   property int iconSize: 38
   visible: opacity === 0 ? false : true
   enabled: enabledQ
   opacity: enabledQ ? 1 : 0

   onVisibleChanged: {
      if (visible && enabled)
         Qt.callLater(() => searchBar.forceActiveFocus());
   }

   Keys.onEscapePressed: Quickshell.execDetached(["qs", "ipc", "call", "bottom", "launcherToggle"])
   Keys.onUpPressed: listView.decrementCurrentIndex()
   Keys.onDownPressed: listView.incrementCurrentIndex()

   CommandModel { id: cm }
   DeskEntriesModel { id: dk; query: searchBar.query; searchBar: searchBar; launcher: root }

   function toggle() {
      Quickshell.execDetached(["qs", "ipc", "call", "bottom", "launcherToggle"]);
   }

   function executeObj(item) {
      if (!item) return

      if (commandMode)
         Quickshell.execDetached(item.cmd)
      else
         item.entry.execute()

      toggle()
   }

   SearchBar {
      id: searchBar

      property var entry: {
         const i = listView.currentIndex
         return (i >= 0 && i < activeModel.length) ? activeModel[i] : null
      }

      focus: true
      leftIcon: commandMode ? "command.svg" : "magnifying-glass.svg"
      anchors.top: root.sbTop ? parent.top : listWrap.bottom
      anchors.topMargin: root.pad
      anchors.horizontalCenter: parent.horizontalCenter
      width: root.width - root.pad * 2
      Behavior on width { NumberAnimation { duration: 120; easing: Easing.InOutCirc } }

      onSubmitted: executeObj(entry)
   }

   Item {
      id: error
      enabled: root.kirby
      anchors.top: root.sbTop ? searchBar.bottom : parent.top
      anchors.topMargin: root.pad
      anchors.horizontalCenter: parent.horizontalCenter
      width: root.width - root.pad * 2
      height: root.noresult ? 150 : 0
      visible: root.noresult && root.kirby

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

            Behavior on color { ColorAnimation { duration: 150 } }
         }
      }

      Timer {
         interval: 130
         running: root.noresult && root.enabledQ
         repeat: true
         onTriggered: {
            kirbForm.text = kirbForm.text === "<('-'<)" ? "(>'-')>" : "<('-'<)"
            kirbForm.color = Qt.hsla(Math.random(), 0.8, 0.7, 1)
         }
      }
   }

   Item {
      id: listWrap

      height: root.noresult && root.kirby
         ? 150
         : Math.min(root.activeModel.length * listView.itemH, (commandMode ? 300 : 400))

      Behavior on width { NumberAnimation { duration: 120; easing: Easing.InOutCirc } }

      opacity: root.noresult ? 0 : 1
      visible: opacity !== 0 && root.enabledQ
      width: root.width - root.pad * 2

      anchors.top: root.sbTop ? searchBar.bottom : parent.top
      anchors.topMargin: height > 0 ? root.pad : 0
      anchors.horizontalCenter: parent.horizontalCenter
      clip: true

      ListView {
         id: listView
         model: root.activeModel
         anchors.fill: parent
         readonly property int itemH: 40

         snapMode: ListView.SnapToItem
         keyNavigationEnabled: true
         
   highlightRangeMode: ListView.ApplyRange
   preferredHighlightBegin: Math.min(margin * itemH, (height - itemH) / 2)
   preferredHighlightEnd: Math.max(height - margin * itemH, (height + itemH) / 2)

   highlightMoveDuration: 120
   highlightMoveVelocity: -1
 
         header: Item {
            width: listView.width
            height: root.sbTop ? 0 : Math.max(0, listView.height - listView.count * listView.itemH)
         }
         
         highlight: Rectangle {
               color: Qt.alpha(Config.inversePrimary, 0.6)
               radius: 4
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

               Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
            }

            Rectangle {
               id: testBar

               visible: root.showTestBar
               opacity: delegate.ListView.isCurrentIndex ? 1 : hvrd.hovered ? 1 : 0
               height: 30
               width: 2
               radius: 1
               color: Config.primary

               anchors.left: parent.left
               anchors.leftMargin: 3
               anchors.verticalCenter: parent.verticalCenter

               Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
            }

            Row {
               id: row

               spacing: 6
               anchors.verticalCenter: parent.verticalCenter
               anchors.left: root.showTestBar ? testBar.right : parent.left
               anchors.leftMargin: 3

               Image {
                  height: root.iconSize
                  width: height
                  source: modelData.icon
                  anchors.verticalCenter: parent.verticalCenter

                  sourceSize: Qt.size(root.iconSize * 2, root.iconSize * 2)
                  fillMode: Image.PreserveAspectFit
                  smooth: true
                  mipmap: true
                  asynchronous: true
               }

               Column {
                  id: textCol

                  anchors.verticalCenter: parent.verticalCenter
                  width: delegate.width - root.iconSize - row.spacing - 6
                  spacing: 0

                  StyledText {
                     id: text

                     width: parent.width
                     elide: Text.ElideRight
                     font.pixelSize: 15
                     text: modelData.name
                     color: Config.backgroundText
                  }

                  StyledText {
                     id: text2

                     width: parent.width
                     elide: Text.ElideRight
                     font.pixelSize: 13
                     text: modelData.entry && modelData.entry.comment !== ""
                        ? modelData.entry.comment
                        : modelData.entry.genericName !== ""
                        ? modelData.entry.genericName : ""
                     visible: text2.text !== ""
                     enabled: visible
                     color: Qt.alpha(Config.backgroundText, 0.6)
                  }
               }
            }

            HoverHandler {
               id: hvrd
            }

            MouseArea {
               id: mouseArea
               anchors.fill: delegate

               onClicked: {
                  executeObj(modelData)
               }
            }
         }
      }
   }
}
