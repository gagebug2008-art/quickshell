
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
        onNotification: n => {
            console.log("got:", n.summary, "---", n.body)
            n.tracked = true
            console.log("tracked count now:", server.trackedNotifications.count)
        }
    }

    PanelWindow {
        id: panel
        anchors {
            top: true
            right: true
            /* topMargin: 4 */
           /*  rightMargin: 4 */
        }
        margins {
            top: 4
            right: 4
        }
        implicitWidth: 220
        implicitHeight: screen.height

        mask: Region {
    item: column
}
        color:"transparent"
       
        exclusionMode: ExclusionMode.Ignore
        /* anchors.fill: parent */

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

                property real progress: 1.0


                radius: 50/8
                color: "green"
                width: 80


                Layout.preferredHeight: cont1.height + cont2.height + rws.spacing + notiContent.anchors.margins * 2

                Layout.fillWidth: true

                NumberAnimation on progress {
                    running: card.modelData.urgency !== NotificationUrgency.Critical
                    from: 1.0
                    to: 0.0
                    duration: 5000
                    easing.type: Easing.Linear

                    onStopped: card.modelData.dismiss()
                }

                Timer {
                    running: card.modelData.urgency !== NotificationUrgency.Critical || card.modelData.index < 1
                    interval: 5000

                    onTriggered: card.modelData.dismiss()
                }

                
                Rectangle {
                    id: littlebar
                    height: parent.height
                    width: 3

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        margins: 6
                    }

                    radius: height/2
                    color: "white"
                }

                Rectangle {
                    id: progress

                    height: littlebar.height * card.progress
                    width: 3.5

                    anchors {
                        left: littlebar.left
                        leftMargin: -0.25
                        top: littlebar.top
                        topMargin: -0.25
                    }

                    color: "teal"
                    radius: height/2
                }
               

                RowLayout {
                    id: notiContent

                    anchors {
                        margins: 8
                        left: littlebar.left
                        top: parent.top
                        right: parent.right
                        
                    }

                    spacing: 1

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        Image {
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30
                            Layout.alignment: Qt.AlignCenter
                            fillMode: Image.PreserveAspectFit

                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            id: rws

                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                id: cont1

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
                                id: cont2

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
                }

                MouseArea {
                    z: 4
                    anchors.fill: parent

                    onClicked: card.modelData.dismiss()
                }
            }
        }
    }
    }
}
