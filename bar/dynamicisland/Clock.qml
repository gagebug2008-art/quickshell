import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.wal as Wal

Rectangle {
    id: root
    anchors.verticalCenterOffset: 0
    color: "transparent"
    
    height: row.height
    width: row.width
    //properties
    property var fontsize: 16
    property string fm: ""    
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    RowLayout {
        id: row
        anchors {
            centerIn: parent
        }
        spacing:-1
    /* Text {
        text: Qt.formatDateTime(clock.date, "d MMM")
        font.pixelSize: fontsize
        color: Wal.Colors.color(15)
        font.weight: 400
        antialiasing: true  
        font.family: fm

    } */
    Text {

        text: Qt.formatDateTime(clock.date, "HH")
        font.pixelSize: fontsize
        color: Wal.Colors.color(15)
        font.weight: 400
        antialiasing: true  
        font.family: fm
    }
       
    Text {
    id: blinkingSeperator
    text: ":"
    transform: Translate { x: 0; y: -1 }

        font.pixelSize: fontsize
        color: Wal.Colors.color(15)
        font.weight: 400
        antialiasing: true        
        font.family: fm 
        }
    Text {
        text: Qt.formatDateTime(clock.date, "mm")
        font.pixelSize: fontsize
        color: Wal.Colors.color(15)
        font.weight: 400
        antialiasing: true
        font.family:fm
    
    }
    Timer {
        id: blinkTimer
        interval: 500 // Time in milliseconds
        repeat: true
        running: true
        onTriggered: {
            blinkingSeperator.opacity = (blinkingSeperator.opacity === 1.0) ? 0.0 : 1.0; 
        }
    }
}}
