import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.reusables
import qs.config
import qs.anims

Item {
   id: root

   readonly property int pad: 8
   readonly property int iconSize: 29
   property int itemSp: 6
   property int dotCount: 1
   property real scrollSensitivity: 1
   property bool floatingIcon: true
   property int dotsHeight: 1
   width: modelrow.width + pad * 2
   height: iconSize + pad * 2 + dotsHeight

   property bool autoHide: false
   property bool manualHide: false
   property bool pointerNear: false
   property int exclusiveHeight: autoHide ? 0 : height + 5

   property int openCount: 0
   readonly property bool anyOpen: openCount > 0

   readonly property bool barHide: autoHide ? !pointerNear : manualHide

   readonly property real hideOffset: 70
   readonly property int triggerHeight: 4

   component Divider: Rectangle {
      width: 2
      height: parent.height - 4
      color: "#0cffffff"
   }

   function barToggle() {
      if (!autoHide)
         manualHide = !manualHide;
   }

   function setPointerNear(near) {
      if (near) {
         hideTimer.stop();
         pointerNear = true;
      } else {
         hideTimer.restart();
      }
   }

   Timer {
      id: hideTimer
      interval: 150
      onTriggered: root.pointerNear = false
   }

   AppsBackend { id: aps }

   property var pinnedApps: aps.pinnedApps
   property var uniqueApps: aps.uniqueApps

   Wiggle { id: wiggle2; item: pinBox }

   /*
   Rectangle {
      id: pinBox
      width: root.floatingIcon ? root.iconSize - 6 : root.iconSize - 1
      height: root.iconSize - 1
      anchors.verticalCenter: parent.verticalCenter
      anchors.verticalCenterOffset: -1
      color: root.floatingIcon ? "transparent" : Config.primaryContainer
      radius: 7

      IconKirigami {
         id: pin
         anchors.centerIn: parent
         implicitSize: root.iconSize - 7
         icon: "pinned.svg"
         color: root.floatingIcon ? Config.primaryContainer : Config.primaryText
         opacity: !root.autoHide ? 1 : 0
         visible: opacity !== 0

         Behavior on opacity {
            NumberAnimation { duration: 80; easing: Easing.InOutCirc }
         }
      }

      IconKirigami {
         id: notpin
         anchors.centerIn: parent
         implicitSize: root.iconSize - 7
         icon: "not-pinned.svg"
         color: root.floatingIcon ? Config.primaryContainer : Config.primaryText
         opacity: root.autoHide ? 1 : 0
         visible: opacity !== 0

         Behavior on opacity {
            NumberAnimation { duration: 80; easing: Easing.InOutCirc }
         }
      }

      MouseArea {
         anchors.fill: parent
         cursorShape: Qt.PointingHandCursor
         onClicked: {
            root.autoHide = !root.autoHide;
            wiggle2.play();
         }
      }
   }

   Divider {}
   */

   Row {
      id: modelrow
      anchors.centerIn: parent
      spacing: root.itemSp

      Repeater {
         model: ScriptModel {
            values: uniqueApps
            objectProp: "appId"
         }

         delegate: Item {
            id: cell

            required property var modelData
            required property int index

            readonly property var desktopEntry: DesktopEntries.heuristicLookup(modelData.appId)
            readonly property string iconName: desktopEntry?.icon || modelData.appId
            readonly property bool isFocused: ToplevelManager.activeToplevel?.appId === modelData.appId
            readonly property int dot: 3
            readonly property int count: Math.min(root.dotCount, cell.modelData.windows.length)
            readonly property int countRaw: cell.modelData.windows.length

                        width: root.iconSize
            height: width

            Wiggle { id: wiggle; item: img }

            HoverHandler { id: cellHover }
            /*
            TestView {
               id: winMen
               item: modelData
               count: countRaw
               focused: isFocused
               attach: parent
               toggled: cellHover.hovered 
               enabled: countRaw > 0
               visible: enabled
            }
            */
            Item {
               width: root.iconSize
               height: root.iconSize

               Image {
                  id: img
                  width: root.iconSize
                  height: root.iconSize
                  sourceSize: Qt.size(root.iconSize, root.iconSize)
                  source: cell.iconName.startsWith("/")
                     ? "file://" + cell.iconName
                     : Quickshell.iconPath(cell.iconName, "application-x-executable")
               }
            }

            FocusIndicator2 {
            id: indicator
            item: modelData
            count: cell.count
            focused: cell.isFocused
            attach: parent
            } 

                        MouseArea {
               id: cellMouse
               anchors.fill: parent
               acceptedButtons: Qt.LeftButton | Qt.RightButton
               cursorShape: Qt.PointingHandCursor
               property real wheelAccum: 0

               function cycle(dir) {
                  const wins = cell.modelData.windows;
                  if (wins.length === 0)
                     return;

                  const cur = wins.indexOf(ToplevelManager.activeToplevel);
                  const next = cur === -1 ? 0 : (cur + dir + wins.length) % wins.length;
                  wins[next].activate();
               }

               onWheel: wheel => {
                  if (wheelAccum !== 0 && Math.sign(wheel.angleDelta.y) !== Math.sign(wheelAccum))
                     wheelAccum = 0;

                  wheelAccum += wheel.angleDelta.y;

                  if (Math.abs(wheelAccum) >= 120 / Math.max(0.1, root.scrollSensitivity)) {
                     cycle(wheelAccum > 0 ? -1 : 1);
                     wheelAccum = 0;
                  }
               }

               onClicked: mouse => {
                  if (mouse.button === Qt.RightButton) {
                     aps.pinToggle(cell.modelData.appId);
                     wiggle.play();
                  } else if (cell.modelData.windows.length > 0) {
                     cell.modelData.windows[0].activate();
                     wiggle.play();
                  } else {
                     cell.desktopEntry?.execute();
                     wiggle.play();
                  }
               }
            }
         }
      }

      /*
      Divider {}

      Rectangle {
         width: root.iconSize - 4
         height: root.iconSize - 4
         anchors.verticalCenter: parent.verticalCenter
         anchors.verticalCenterOffset: -1
         color: root.floatingIcon ? "transparent" : Config.primaryContainer
         radius: 7

         IconKirigami {
            id: launcherButton
            anchors.centerIn: parent
            implicitSize: root.iconSize - 2
            icon: "launcher(leg).svg"
            color: root.floatingIcon ? Config.primaryContainer : Config.primaryText
         }

         MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.execDetached(["qs", "ipc", "call", "bottom", "launcherToggle"])
         }
      }
      */
   }
}
