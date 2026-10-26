import QtQuick
import QtQuick.Controls

Item {
    id: root
    height: 75
    width: 26

    Button {
        id: but1
        width: 33
        height: 33
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 4

        icon {
            source: "/home/gage_miller/.config/quickshell/imgs/lamp-desk.svg"
            height: 18
            width: 18
            color: "white"
        }
        background: Rectangle { color: "transparent" }

        onClicked: {
            barChasis.hoverTargetState = "notchnookclone"
        }
    }

    Button {
        id: but2
        width: 33
        height: 33
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4

        icon {
            source: barChasis.hoverTargetState === "notchtray"
                    ? "/home/gage_miller/.config/quickshell/imgs/folder-open.svg"
                    : "/home/gage_miller/.config/quickshell/imgs/folder-closed.svg"
    height: 20
            width: 20
            color: "white"
        }
        background: Rectangle { color: "transparent" }

        onClicked: {
            barChasis.hoverTargetState = "notchtray"
        }
    }

    Rectangle {
        id: littlebackground
        width: 22
        height: 38
        radius: height / 2
z: -1
        color: '#353535'
        opacity: 0.4

        anchors.horizontalCenter: parent.horizontalCenter

        y: (barChasis.hoverTargetState === "notchtray")
           ? but2.y + (but2.height - height) / 2
           : but1.y + (but1.height - height) / 2

        Behavior on y {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
    }
}
