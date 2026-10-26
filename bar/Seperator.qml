import QtQuick

    Rectangle {
    id: seperatorbody
    
    anchors {
        verticalCenter: parent.verticalCenter
        top: parent.top
        bottom: parent.bottom
        margins: 4
    }

    height: parent.height * 0.85
    width: 1
    radius: width/2

    opacity: 2

    color: '#111311'
    }
