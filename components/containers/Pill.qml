// Pill.qml
import QtQuick
import Quickshell
import qs.wal as Wal
import qs.bar
Rectangle {
    id: pill

    property int hPadding: 16
    property int vPadding: 2

    anchors {
        centerIn: parent

    }

    z: -1

    radius: barChasis.radius 
    color: Wal.Colors.color(0)

    height: barChasis.implicitHeight
    implicitWidth: parent.width + hPadding * 2

}
