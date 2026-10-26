import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import qs.wal as Wal
import qs.config
import qs.components.shadows

Item {
    id: leftbar
    readonly property int shadowOffset: 15

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin:-4

    clip: true
    implicitHeight: bar.implicitHeight - shadowOffset + 1
    implicitWidth: 88 
    
    ItemShadow {}
    Rectangle {
            id:rectleft
            anchors.fill: parent
            anchors.centerIn: parent.centerIn
            bottomRightRadius: leftbar.implicitHeight
            color: Wal.Colors.color(0)
            anchors.topMargin: -1
            
        Workspaces {anchors.centerIn: parent}
    }
    
}

