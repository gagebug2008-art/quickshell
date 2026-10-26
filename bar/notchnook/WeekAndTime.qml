import QtQuick
import Quickshell
import QtQuick.Controls

    Rectangle {    
    id: datetime

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    /* anchors.top: parent.top
    
    anchors.bottom:parent.bottom
 */
    color: "transparent"

    implicitHeight: parent.height
    implicitWidth: implicitHeight *2.4

    /*Text {
        id: month
    anchors.left: parent.left
    anchors.leftMargin: 0
    anchors.top: parent.top
    anchors.topMargin: 8
    text: Qt.formatDateTime(clock.date, 'MMM')
    color: 'white'
    font.pixelSize: 24
    font.bold: true
    font.family: "Noto Sans"
} */
    /* Rectangle {

    color: "transparent"
    border.color: "#101011"

    radius: height/6
    anchors {
    left: parent.left
    right: parent.right
    rightMargin: 12
    top: month.bottom
    topMargin: 6
    bottom: parent.bottom
    bottomMargin: 6
    }
    } */
    Text {
    text: ""
    color: "white"
    anchors.centerIn: parent
    anchors.verticalCenterOffset: 10
    }
    Row {
    id: uwu
    spacing:6
    anchors {
        centerIn: parent
        verticalCenterOffset: 10
        
    }
    Repeater {
    model: 5

    delegate: Rectangle {
    id: days 
    property bool isWeekend: cellDate.getDay() === 0 || cellDate.getDay() === 5
    property int offset: index - 2
    property date cellDate: {
        const d = new Date(clock.date)
        d.setDate(d.getDate() + offset)
        return d
    }

    
    height: 35
    width: 26
    z: 2
    color: "transparent"

    Text {
    id: weekname
    
    anchors.horizontalCenter: parent.horizontalCenter
    text: index === 2 ? Qt.formatDate(cellDate, "ddd") : Qt.formatDate(cellDate, "ddd").charAt(0)    
    color: isWeekend && index === 2 ? "#6589ff" : isWeekend ? "#7c504c" : '#2e2f2f' 
    font.pixelSize: 16 - Math.abs(index - 3)
    font.weight: 700
        Behavior on color {
        ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }

            }
    Text {
    id: weeknumber        
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: weekname.bottom
    anchors.topMargin: -2
    text: Qt.formatDate(cellDate, "dd") 
    font.pixelSize: index === 2 ? 20 : 16
    color: index === 2 ? '#6589ff' : isWeekend ? "#7c504c" : "#848484"
    font.weight: 600 
    z: 4

    Behavior on font.pixelSize {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutCubic
            }
        }
    Behavior on color {
        ColorAnimation { duration: 500; easing.type: Easing.OutCubic }
                    }
    
    property date lastDay: clock.date
        Behavior on opacity {
            SequentialAnimation {
                NumberAnimation { to: 0; duration: 500; easing.type: Easing.OutCubic }
                PropertyAction {}
                NumberAnimation { to: 1; duration: 500; easing.type: Easing.OutCubic }
            }
        }


    }
            }
        }
    }
}
