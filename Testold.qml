import QtQuick
import QtQuick.Controls
import Quickshell 
PanelWindow {
    width: 640; height: 480
    property bool expanded: false

    DropArea {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height / 2

        onEntered: {
            console.log("ENTERED")
            expanded = true
        }
        onExited: {
            console.log("EXITED")
            expanded = false
        }
        onDropped: (drop) => {
            console.log("DROPPED", drop.hasUrls)
            expanded = true
            drop.acceptProposedAction()
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 2
            border.color: expanded ? "lime" : "crimson"
        }
    }
}

