import QtQuick
import Quickshell 
import QtQuick.Controls
import qs.wal as Wal
import qs.config

Rectangle {
    width: 500
    height: 500
    color: "transparent"
    Rectangle {
    id: calendar
    
    //properties

    property date today: new Date()

    color: Wal.Colors.color(0)
    anchors {
        centerIn: parent
    }
    implicitHeight: 200
    implicitWidth: 200

    Text {
    text: calendar.today.toLocaleDateString(Qt.locale(), "MMMM")
        color: Wal.Colors.color(15)
        anchors {
            bottom: monthGrid.top
            horizontalCenter: monthGrid.horizontalCenter
        }
    }
        MonthGrid {
        id: monthGrid
        
        anchors {
            centerIn: parent
        }

        font.family: config.fontFamily
        year: today.getFullYear()
        month: today.getMonth()
        delegate: Item {
        implicitWidth: 20
        implicitHeight: 20

                FloatingWindow {
        id: popup
        visible: false
        width: 200
        height: 200
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Wal.Colors.color(1)
        }
    }

    MouseArea {
        id: cellHover
        hoverEnabled: true
        anchors.fill: parent
        onClicked: popup.visible = !popup.visible
    }


            Text {
        anchors.centerIn: parent
        text: model.day
        font.family: "Liberation Mono"
        color: cellHover.containsMouse ? Wal.Colors.color(5) : model.month !== monthGrid.month ? Qt.darker(Wal.Colors.color(15), 1.5) : model.today ? Wal.Colors.color(3) : Wal.Colors.color(15)

        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }
            }
        }
    }

