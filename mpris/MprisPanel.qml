import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import qs.config as Cf

Item {
    id: root

    // --- Theme bindings (all from Cf.Config) ---
    readonly property color titleColor: Cf.Config.panelText
    readonly property color subColor:   Qt.alpha(Cf.Config.panelText, Cf.Config.textOpacityMuted)
    readonly property color iconColor:  Cf.Config.accent

    property real imageAspectRatio: 1
    property int  padding: 0

    height: Cf.Config.sc(100)
    width: height * 2

    // Transparent: background and border belong to the background element.
    // Kept only to round the album art's corners.
    ClippingRectangle {
        id: card
        anchors.fill: parent
        radius: Cf.Config.radius
        color: "transparent"

        // --- Album art ---
        Image {
            id: art
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                margins: root.padding
            }
            width: height * root.imageAspectRatio
            source: Player.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            smooth: true
            mipmap: true
        }

        // --- Info + controls ---
        Item {
            anchors {
                left: art.right
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width - Cf.Config.margin
                spacing: Cf.Config.spacingSm

                component InfoText: Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    font.family: Cf.Config.ftFam
                }

                component ControlButton: Button {
                    property url iconSource
                    checkable: false
                    background: Item {}
                    icon {
                        source: iconSource
                        width: Cf.Config.iconSize
                        height: Cf.Config.iconSize
                        color: enabled
                            ? root.iconColor
                            : Qt.alpha(root.iconColor, Cf.Config.textOpacityDisabled)
                    }
                }

                InfoText {
                    text: Player.trackTitle
                    color: root.titleColor
                    font.pixelSize: Cf.Config.textSize
                    font.weight: Cf.Config.ftWtBold
                }

                InfoText {
                    text: Player.trackArtist
                    color: root.subColor
                    font.pixelSize: Cf.Config.textSizeMd - 2
                    font.weight: Cf.Config.ftWt
                }

                InfoText {
                    text: Player.trackAlbum
                    color: root.subColor
                    font.pixelSize: Cf.Config.textSizeSm
                    font.weight: Cf.Config.ftWt
                    visible: text !== ""
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Cf.Config.spacing - 2

                    ControlButton {
                        iconSource: Cf.Config.iconDir + "backward-solid-full.svg"
                        enabled: Player.canGoPrevious
                        onClicked: Player.previous()
                    }

                    ControlButton {
                        iconSource: Cf.Config.iconDir + (Player.isPlaying
                            ? "pause-solid-full.svg"
                            : "play-solid-full.svg")
                        enabled: Player.hasPlayer
                        onClicked: Player.togglePlaying()
                    }

                    ControlButton {
                        iconSource: Cf.Config.iconDir + "forward-solid-full.svg"
                        enabled: Player.canGoNext
                        onClicked: Player.next()
                    }
                }
            }
        }
    }
}
