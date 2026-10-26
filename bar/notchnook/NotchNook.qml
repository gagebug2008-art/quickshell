import QtQuick
import QtQuick.Layouts
import qs.bar

Rectangle {
    id: root
    anchors {
        right: parent.right
        left: parent.left
    }
    height: parent.height
    width: parent.width
    color: "transparent"
    /* Text {
        text: row.width
        color: 'white'
    } */
    WeekAndTime { anchors.centerIn: parent  }
       
}
