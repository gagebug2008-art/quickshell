import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 6

    Repeater {
        model: [
            { id: "normal",      icon: "media-playback-start" },
            { id: "nook",        icon: "dashboard" },
            { id: "powermenu",   icon: "system-shutdown" },
            { id: "walselector", icon: "preferences-desktop-wallpaper" }
        ]

        delegate: Rectangle {
            id: btn

            // Correctly query state via StateHub string key
            readonly property bool isActive: StateHub.current("topMiddle") === modelData.id

            implicitWidth: isActive ? 38 : 30
            implicitHeight: 30
            radius: 8

            color: isActive ? "#3d4b68" : "transparent"

            Behavior on implicitWidth { NumberAnimation { duration: 150 } }
            Behavior on color { ColorAnimation { duration: 150 } }

            Image {
                anchors.centerIn: parent
                sourceSize: Qt.size(16, 16)
                source: "image://icon/" + modelData.icon
                opacity: btn.isActive ? 1.0 : 0.6
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("Button clicked:", modelData.id)
                    
                    // 1. Try StateHub path navigation
                    let navigated = StateHub.goTo("topMiddle[" + modelData.id + "]")
                    
                    // 2. Direct fallback to topMiddle if StateHub lookup returned false
                    if (!navigated && typeof topMiddle !== "undefined") {
                        topMiddle.state = modelData.id
                    }
                }
            }
        }
    }
}
