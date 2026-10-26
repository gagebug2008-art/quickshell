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
    id: rightbar
    readonly property int shadowOffset: 15

    anchors.right: parent.right
    anchors.top: parent.top
    clip: true

    implicitHeight: bar.implicitHeight - shadowOffset 
    implicitWidth: 80 

    height: 20
    ItemShadow {}

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: -1
            bottomLeftRadius: rightbar.implicitHeight
            color: Wal.Colors.color(0)
        }

    }
