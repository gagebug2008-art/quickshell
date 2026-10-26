import Quickshell 
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.wal as Wal
import qs

Scope {
    id: root 
    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => { console.log("got:", n.summary, "---", n.body) 
            n.tracked = true
    console.log("tracked count now:", server.trackedNotifications.count)
        }
    }
    PanelWindow {
        id: notifPanel

        anchors {
            top: true 
            right: true
        }
        margins {
            top: 4
            right: 4
        }

        color: "transparent"

        implicitWidth: 230
        implicitHeight: 200
        exclusionMode: ExclusionMode.Ignore
        Rectangle {
    id: countBadge

        required property int count

    anchors {
        right: card.left
        left: parent.left
        leftMargin: 5
    }
    height: 22
    width: 22
    radius: height / 2

    color: server.trackedNotifications.count >= 1 ? "black" : "transparent"

    Text {
        anchors.centerIn: parent
        text: server.trackedNotifications.count
        color: "white"
    }
}
        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10
            Repeater {
                model: server.trackedNotifications
                delegate: Rectangle {
                    id: card
                    required property var modelData
                    required property int index

                    radius: height/8
                    color: "black"
                    width: 200 
                    height: 50
                    anchors.right: parent.right
                    Layout.fillWidth: true
/*                     Layout.preferredWidth: column.implicitWidth + 20
 */
                    x: 0
                    z: 0 - index
                    
                    border.width: 1
                    border.color: "wheat"

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.critical
                        interval: 5000
                        onTriggered: card.modelData.dismiss()
                    }

            RowLayout {
                id: notiContent

                anchors.fill: parent
                anchors.leftMargin: 5
                spacing: 10

                Image {
                    Layout.preferredHeight: card.height - 4
                    Layout.preferredWidth: height
                    Layout.alignment: Qt.AlignCenter
                    fillMode: Image.PreserveAspectFit
                    visible: source.toString() !== ""
                    source: card.modelData.image || card.modelData.appIcon || ""
                        }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2 

                        Text {
                            Layout.fillWidth: true
                            text: card.modelData.summary
                            color: Wal.Colors.color(14)
                            font.pixelSize: 12
                            font.hintingPreference: Font.PreferNoHinting
                            font.bold: true
                            antialiasing: true
                            elide: Text.ElideRight
                        }
                        Text {
                            Layout.fillWidth: true
                            text: card.modelData.body
                            color: Wal.Colors.color(15)
                            font.pixelSize: 11
                            font.hintingPreference: Font.PreferNoHinting
                            font.bold: false
                            antialiasing: true
                            wrapMode: Text.WordWrap
                            }
                        }
                    }
                MouseArea {
                    anchors.fill: parent
                    onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }
}