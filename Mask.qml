import QtQuick
import QtQuick.Controls
import QtQuick.Effects

ApplicationWindow {
    visible: true
    width: 480
    height: 480
    color: '#000000'

    Item {
        id: stage
        anchors.centerIn: parent
        width: 280
        height: 280

        Item {
            id: maskWrapper
            anchors.fill: parent
            layer.enabled: true
            visible: false

            Rectangle {
                anchors.fill: parent
                color: "white"
                NumberAnimation on rotation { from: 0; to: 360; duration: 600; loops: Animation.Infinite }
            }
        }

        Image {
            id: art
            anchors.fill: parent
            source: "https://cdn.discordapp.com/avatars/238129566386749440/040f3d22609779b02698e9df4ddc4184.png"
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        MultiEffect {
            anchors.fill: parent
            source: art
            maskEnabled: true
            maskSource: maskWrapper
            maskThresholdMin: 0.5
            maskSpreadAtMin: 0.5
        }
    }
}
