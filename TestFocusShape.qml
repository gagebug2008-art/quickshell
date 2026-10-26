import QtQuick
import Quickshell
import qs.reusables

PanelWindow {
    id: root
    
    // Give the window dimensions so it renders on screen
    width: 200
    height: 200
    color: "transparent"
    mask: Region {}

Item {
   width: 400; height: 300
   anchors.centerIn: parent
   Rectangle {
      id: target
      anchors.centerIn: parent
      width: 100; height: 100
      radius: 40
      color: "#333"
   }

   FocusRing { item: target; strokeWidth: 3 }
}}
