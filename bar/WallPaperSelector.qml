import QtQuick
import Qt.labs.folderlistmodel
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Controls

import qs.config as Cf

Item {
    id: root

    width: 700
    height: 140
    property string query: "" 
    property string currentIndex: ListView.currentIndex
    readonly property var exts: ["png", "jpg", "jpeg", "webp"]
    property bool lightMode: false
    property string theme: lightMode ? "-l" : null
    // Instantly forward keyboard focus to the ListView when this component gains focus
    onActiveFocusChanged: {
        if (activeFocus) {
            listView.forceActiveFocus()
        }
    }
    
    FolderListModel {
        id: wallpapers

        folder: "file:///home/gage_miller/Pictures/wallpapers"
        showDirs: false
        showFiles: true
        nameFilters: root.exts.map(exts => "*" + root.query + "*." + exts)
        sortField: FolderListModel.Name
    }

    Process {
        id: currentWallpaperProc

        command: ["awww", "query"]

        property string currentPath: ""

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim()
                const match = output.match(
                    /currently displaying:\s*image:\s*(.+)$/
                )

                currentWallpaperProc.currentPath =
                    match ? match[1].trim() : ""
            }
        }

        onCurrentPathChanged: {
            for (let i = 0; i < wallpapers.count; i++) {
                if (wallpapers.get(i, "filePath") === currentPath) {
                    listView.currentIndex = i
                    break
                }
            }
        }
    }

    ClippingRectangle {
        id: back

        width: listView.width
        height: listView.height
        anchors.centerIn: parent
        radius: Cf.Config.radius
        color: Cf.Config.bg
        clip: true
        anchors.margins: 4
        

        ListView {
            id: listView

            anchors.centerIn: parent
            cacheBuffer: 2000         
            reuseItems: true

            width: 701
            height:140

            model: wallpapers
            orientation: ListView.Horizontal
            spacing: 4

            focus: true
            activeFocusOnTab: true

            currentIndex: wallpapers.count > 0 ? 0 : -1

            property int currentItemWidth: height * 16/9

            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 180
            preferredHighlightBegin: (width - currentItemWidth) / 2
            preferredHighlightEnd: (width + currentItemWidth) / 2

            function applyCurrentWallpaper() {
                if (!currentItem)
                    return

                Quickshell.execDetached([
                    "awww",
                    "img",
                    currentItem.path,
                    "--transition-type",
                    "wave",
                    "--transition-duration",
                    "2.5",
                    "--transition-fps",
                    "165"
                ])
                Quickshell.execDetached([
                    "matugen",
                    "image",
                    currentItem.path,
                    "--prefer",
                    "darkness"
                ])
                Quickshell.execDetached([
                    "wal",
                    "-i",
                    currentItem.path, 
                ])

                Quickshell.execDetached([
                    "pkill",
                    "-f",
                    "display -back"
                ])
            }

            Keys.onPressed: function(event) {
   if (event.key === Qt.Key_Left) {
      listView.decrementCurrentIndex()
      event.accepted = true
   } else if (event.key === Qt.Key_Right) {
      listView.incrementCurrentIndex()
      event.accepted = true
   } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
      applyCurrentWallpaper()
      event.accepted = true
   }
}
            Keys.onEnterPressed: function(event) {
                applyCurrentWallpaper()
                event.accepted = true
            }

            delegate: Item {
                id: wallpaperDelegate

                height: listView.height

                width:height * 16/9
                /*{
                    const distance = Math.abs(index - listView.currentIndex)

                    if (distance === 0) {
                        return height * (16 / 9)
                    } else if (distance === 1) {
                        return height
                    } else {
                        return height * 9 / 16
                    }
                }
                */
                property string path: filePath
                property bool isCurrent: ListView.isCurrentItem

                anchors.verticalCenter: parent.verticalCenter

                ClippingRectangle {
                    id: imageClip

                    anchors.fill: parent

                    radius: Cf.Config.radius
                    clip: true

                    Image {
                        anchors.fill: parent

                        source: wallpaperDelegate.path
                        sourceSize.width: 400
                        asynchronous: true
                        smooth: true
                        mipmap: true
                        cache: true
                    }

                    Rectangle {
                        id: textBackground

                        height: 22
                        width: Math.min(fileNameText.contentWidth + 12, parent.width - 10)
                        z: 10

                        color: Qt.alpha(Cf.Config.bg, 0.85)
                        radius: Cf.Config.radius

                        anchors.left: parent.left
                        anchors.leftMargin: 5

                        y: wallpaperDelegate.isCurrent ? 5 : -40

                        Behavior on y {
                            NumberAnimation {
                                duration: 180
                            }
                        }

                        Text {
                            id: fileNameText

                            anchors.fill: parent
                            anchors.leftMargin: 6
                            anchors.rightMargin: 6

                            color: "white"
                            font.pixelSize: 12
                            text: model.fileName ? model.fileName : ""
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter

                            opacity: wallpaperDelegate.isCurrent ? 1 : 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 180
                                }
                            }
                        }
                    }
                }

                TapHandler {
                    onTapped: {
                        listView.forceActiveFocus()
                        listView.currentIndex = index
                        listView.applyCurrentWallpaper()
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 180
                        easing: easingInOutQuart
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        currentWallpaperProc.running = true

        if (wallpapers.count > 0) {
            listView.currentIndex = 0
        }

        // Force focus directly on instantiation
        listView.forceActiveFocus()
    }
}
