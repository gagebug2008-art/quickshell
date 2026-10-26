import Quickshell
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
  id: root

  WlrLayershell.layer: WlrLayer.Background
  WlrLayershell.namespace: "quickshell-desktop"
  //exclusiveZone: 0

  color: "transparent"
  anchors { top: true; bottom: true; left: true; right: true }

  FolderListModel {
    id: folderModel
    
    folder: "file://" + Quickshell.env("HOME") + "/Desktop"
    nameFilters: ["*"]
    showDirs: true
    showDotAndDotDot: false
  }
  
}
