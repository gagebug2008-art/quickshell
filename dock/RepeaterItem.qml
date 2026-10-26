import QtQuick
import Quickshell


Repeater {
            model: ScriptModel {
               values: uniqueApps
               objectProp: "appId"
            }

            delegate: Row {
               id: cell

               required property var modelData
               required property int index

               readonly property var desktopEntry: DesktopEntries.heuristicLookup(modelData.appId)
               readonly property string iconName: desktopEntry?.icon || modelData.appId
               readonly property bool isFocused: ToplevelManager.activeToplevel?.appId === modelData.appId
               readonly property int dot: 3
               readonly property int count: cell.modelData.windows.length


               spacing: root.itemSp

               Wiggle { id: wiggle; item: img }

               // pinned / unpinned separator (disabled).
               // To enable, set visible to:
               // cell.index > 0 && !cell.modelData.pinned && root.uniqueApps[cell.index - 1].pinned
               Rectangle {
                  visible: false
                  width: 2
                  height: root.iconSize - 8
                  y: (root.iconSize - height) / 2
                  radius: 1
                  color: "#66ffffff"
               }
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
                  /*
                  Row {
                     visible: !focusBar.visible
                     spacing: cell.dot
                     anchors.bottom: parent.bottom
                     anchors.bottomMargin: -2
                     anchors.horizontalCenter: parent.horizontalCenter

                     Repeater {
                        model: focusBar.n

                        Rectangle {
                           width: cell.dot * 2
                           height: cell.dot
                           radius: cell.dot / 2
                           color: "#ccffffff"
                        }
                     }
                  }
                  */

                 /*
                  Rectangle {
                     id: focusBar

                     readonly property int dotsWidth: Math.max(0, n * cell.dot * 2 + (n - 1) * cell.dot)

                     visible: cell.isFocused || width > dotsWidth
                     width: cell.isFocused ? root.iconSize * 0.45 : dotsWidth
                     height: cell.dot
                     radius: cell.dot / 2
                     color: cell.isFocused ? Config.secondary : "#ccffffff"
                     anchors.horizontalCenter: parent.horizontalCenter
                     anchors.bottom: parent.bottom
                     anchors.bottomMargin: -2

                     Behavior on width { NumberAnimation { duration: 140 } }
                     Behavior on color { ColorAnimation { duration: 140 } }
                  }
                  */
                  FocusIndicator {
                  id: focus
                  item: modelData
                  count: cell.count
                  

                  }
                  MouseArea {
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
                        } else if (cell.modelData.windows.length > 0) {
                           cell.modelData.windows[0].activate();
                        } else {
                           cell.desktopEntry?.execute();
                        }
                        wiggle.play();
                     }
                  }
               }
            }
         }
