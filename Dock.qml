
import Quickshell
import QtQuick
import QtQuick.Effects
import Quickshell.Wayland
PanelWindow {
  id: root

  color: "transparent"
  anchors {
    bottom: true
  }
  margins {
    bottom: 8
  }
  width: 600
  height: 45
  readonly property var uniqueApps: {
        let rawList = ToplevelManager.toplevels.values;
        let seen = {};
        let result = [];
               for (let i = 0; i < rawList.length; i++) {
            let win = rawList[i];
            if (!win || !win.appId) continue; 
            if (!seen[win.appId]) {
                seen[win.appId] = true;
                result.push({
                    appId: win.appId,
                    windows: [] 
            });
          }
        }
         return result;
    }
   RectangularShadow {
   id: dockShadow
   anchors.fill: dock
   radius: dock.radius
     }  
     Rectangle {
         id:dock
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
  height: dockRow.height + 5
  width: dockRow.width + 20
  radius: height/6
  color: "#202230"
  border {
  width: 1
  }
    Row {
  id: dockRow
  spacing: 5
  anchors.bottom: parent.bottom
  anchors.horizontalCenter: parent.horizontalCenter
  Repeater {
  model: root.uniqueApps 
  delegate: Item {
    required property var modelData
    width: 25
    height: 35
    readonly property bool isAppActive: ToplevelManager.toplevels.values.some(w => w && w.appId === modelData.appId)
    readonly property bool isAppFocused: ToplevelManager.toplevels.values.some(w => w && w.appId === modelData.appId && w.activated)
        Image {
        id: img
        width: parent.width
        height: width
        source: Quickshell.iconPath(modelData.appId, "application-x-executable")
        } 
      Rectangle {
      id: indicator
      width: isAppFocused ? 12 : 4
      enabled: isAppActive
      height: 4
      radius: 4
      anchors.horizontalCenter: img.horizontalCenter 
      anchors.top: img.bottom
      anchors.topMargin: 3
        Behavior on width {
        NumberAnimation { duration: 50; easing.type: Easing.OutCubic }
            }         
          }
        MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                ;
              }
            }
          }
        ListView {
        id: showWindowsOfGivenUniqueApp
          model: uniqueApps.windows
          delegate: Image {
            }
          }
        }
      }
    }
  }
}

