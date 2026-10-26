import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import qs.wal as Wal
import qs.config
import qs.components.shadows
import qs.components.containers
import qs.bar
Item {
    id: centerbar
    height: parent.height
    width: row.width

    Row {
        id: row
        anchors.centerIn: parent
        height: barChasis.implicitHeight
        spacing: 10

        //Workspaces {anchors.verticalCenter: parent.verticalCenter}
       // Seperator {anchors.verticalCenter: parent.verticalCenter}
        Clock {anchors.verticalCenter: parent.verticalCenter}
        Seperator {anchors.verticalCenter: parent.verticalCenter} 
        Tray {anchors.verticalCenter: parent.verticalCenter}


         //DMpris {anchors.verticalCenter: parent.verticalCenter} 
    }
}
