import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.dock
import qs.reusables
import qs.launcher
import qs.wallpaper
import qs.config

PanelWindow {
   id: root

   WlrLayershell.namespace: "qs-bar"

   anchors {
      bottom: true
      left: true
      right: true
   }

   implicitHeight: 800
   exclusiveZone: dockZone.exclusiveHeight
   exclusionMode: ExclusionMode.Ignore
   color: "transparent"

   Behavior on exclusiveZone {
      NumberAnimation { duration: 140 }
   }

   WlrLayershell.keyboardFocus: launcher.enabledQ ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand

   mask: Region {
      Region { item: dockBubble }
      //Region { item: dockZone.inputZone }
   }

   Bubble {
      id: dockBubble

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 6

      posbottom: true
      width: realDock.width
      height: realDock.height

      state: launcher.enabledQ ? "launcher" : "dock"

      states: [
         State {
            name: "dock"
            PropertyChanges {
               target: dockBubble
               width: row.width
               height: realDock.height
            }
         },
         State {
            name: "launcher"
            PropertyChanges {
               target: dockBubble
               width: launcher.width
               height: launcher.height
            }
            PropertyChanges {
               target: tran
               y: -5
            }
         }
      ]

      clipQ: true 

      transform: Translate {
         id: tran
         y: realDock.barHide ? realDock.hideOffset : 0

         Behavior on y {
            NumberAnimation { duration: 160 }
         }
      }

      Row {
          id: row
          anchors.centerIn: parent
          opacity: dockBubble.state === "dock" ? 1 : 0
            visible: opacity > 0
            enabled: dockBubble.state === "dock"
        PinItem {
           pinAction: Quickshell.execDetached(["qs", "ipc", "call", ]) 
            visible: false
        }
         RealDock {
            id: realDock
            Behavior on opacity {
               NumberAnimation { duration: 220; easing: Easing.InOutCirc }
            }
         }
      }

      AppLauncherRealTest {
         id: launcher
         parCont: dockBubble
         focus: true

         Behavior on opacity {
            NumberAnimation { duration: 260; easing: Easing.InOutCirc }
         }
      }
   }

   MultiEffect {
      anchors.centerIn: dockBubble
      source: dockBubble
      z: -1

      autoPaddingEnabled: true
      shadowEnabled: true
      shadowColor: "black"
      shadowOpacity: 0.5
      shadowBlur: 1.0
      shadowVerticalOffset: Cf.Config.sc(4)
   }

   DockZone {
      id: dockZone
      anchors.fill: parent
      z: -5
      dock: realDock
   }
}
