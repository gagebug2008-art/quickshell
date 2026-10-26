pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.config 


PanelWindow {
  id: root
width: 300
  Rectangle {
    id: dockPanel

    anchors.fill: dockItems
    
    radius: Config.radius
    color: Qt.alpha("black", 1)
    border.width: 2
    border.color: "white"
    // color: "transparent"
    visible: true
  }

  Row {
    id: dockItems
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 20
    anchors.horizontalCenter: parent.horizontalCenter

    spacing: 5
    height: 30
    Repeater {
      model: ["thunar", "dev.vencord.Vesktop", "steam", "firefox", "thunderbird"]
      delegate: Item {
        id: appDelegate

        property int size: parent.height
        implicitWidth: size
        implicitHeight: size

        required property string modelData

        IconImage {
          id: appIcon
          anchors.fill: parent
          anchors.margins: -3
          // anchors.bottomMargin: 10
          mipmap: true
          asynchronous: true

          source: Quickshell.iconPath(modelData, "application-x-executable")
          layer.enabled: true
                  }
      }
    }

    Item {
      implicitWidth: 0.1
      implicitHeight: parent.height
    }

    
  }
}
