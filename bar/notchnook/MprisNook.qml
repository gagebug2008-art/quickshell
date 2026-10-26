import Quickshell.Services.Mpris
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.wal as Wal
import QtQuick.Controls
import QtQuick.Effects

Rectangle { 
    id: root
    
    //enabled: player 
    //visible: player
    z: 2
    
    implicitWidth: implicitHeight * 2.1
    implicitHeight: parent.height 
    
    color: "transparent"
    readonly property string iconDir: Quickshell.shellDir + "/imgs/"
    property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    /* readonly property bool mprisPlayActive: player !== null && player.playbackState === MprisPlaybackState.Playing */
    /* readonly property int mprscl: mprisPlayActive ? 1 : 0 */
    property var playerDesktopEntry: {
    const entry = root.player?.desktopEntry
    if (!entry) return null
    let match = DesktopEntries.byId(entry)
    match = DesktopEntries.applications.values.find(
        e => e.id.toLowerCase().includes(entry.toLowerCase())
    )
    return match ?? null
}

        
    ClippingRectangle {
    id: thumbimage
    z:1
    anchors.left: parent.left
    anchors.leftMargin: 4
    anchors.verticalCenter: parent.verticalCenter
    height: parent.height -8
    width: height
    radius: height/6

    HoverHandler {
            id: thumbhover
        }    
        Image {
           id: thumbimgimg
        anchors.fill: parent
        source: root.player ? root.player.trackArtUrl : root.iconDir + "thumbnailplaceholder.png"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        antialiasing: true
        mipmap: true

            }
    MultiEffect {
    source: thumbimgimg
    anchors.fill: thumbimgimg
    
    blur: thumbhover.hovered ? 0.35 : 0.0
    blurMax: 16
    blurEnabled: thumbhover.hovered || blurtimer.running ? true : false 
    autoPaddingEnabled: true

    Behavior on blur { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
    
    Connections {
    target: thumbhover
    function onHoveredChanged() {
        blurtimer.restart()
                }
            }    
        }   
    RowLayout {
    id: mediacontrollstwo

    height: 13

    spacing: 3
    anchors.centerIn: parent
    opacity: thumbhover.hovered ? 1 : 0
    enabled: thumbhover.hovered

    
    Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
            Button {
    width: 13
    height: 13
    background: Rectangle { color: "transparent" }
    icon {
        source: root.player?.loopState === MprisLoopState.Track
            ? root.iconDir + "loop.svg"
            : root.iconDir + "repeat-solid-full.svg"
        height: 10
        width: 10
        color: !root.player
            ? "grey"
            : root.player.loopState === MprisLoopState.Track
                ? '#24e02a'
                : root.player.loopState === MprisLoopState.Playlist
                    ? '#24e02a'
                    : "#fbbf60"
                    Behavior on color {
        ColorAnimation { duration: 80 } }
    }
    checkable: true
    checked: root.player?.loopState !== undefined && root.player.loopState !== MprisLoopState.None
    enabled: root.player?.loopSupported ?? false
    onClicked: {
        if (!root.player || !root.player.canControl || !root.player.loopSupported) return

        if (root.player.loopState === MprisLoopState.None) {
            root.player.loopState = MprisLoopState.Playlist
        } else if (root.player.loopState === MprisLoopState.Playlist) {
            root.player.loopState = MprisLoopState.Track
        } else {
            root.player.loopState = MprisLoopState.None
            }
        }
    }   
            Button {
    width: 13
    height: 13
    
    background: Rectangle {
        color: "transparent"
    }
    icon {
        source: root.iconDir + "shuffle-solid-full.svg"
        height: 10
        width: 10
        color: root.player?.shuffleSupported ? root.player?.shuffle ? '#24e02a': "#fbbf60" : "grey"
        Behavior on color {
        ColorAnimation { duration: 80 } }
    }
    checkable: true
    checked: root.player?.shuffle ?? false
    
    enabled: root.player?.shuffleSupported ?? false
    onClicked: {
                    if (root.player && root.player.canControl && root.player.shuffleSupported) {
                        root.player.shuffle = !root.player.shuffle
                        checked = root.player.shuffle
                        }
                    }
                }
            }
        }
     Image {
    source: root.playerDesktopEntry?.icon ? Quickshell.iconPath(root.playerDesktopEntry.icon) : ""
    fillMode: Image.PreserveAspectFit
        
    z: 2

    smooth: true
    mipmap: true
    asynchronous: true
        
    anchors { 
    bottom: parent.bottom
    left: parent.left
    }   

    width: 18
    height: 18
    } 
    
    Timer {
    id: blurtimer
    interval: 250
    repeat: false
    }
    
    Rectangle {
    id: infoandbuttons
    color: "transparent"

    anchors {
        left: thumbimage.right
        right: parent.right
        verticalCenter: root.verticalCenter
        verticalCenterOffset: 2
    }
    implicitWidth: implicitHeight + 14
    implicitHeight: albumn.visible ? (title.height + albumn.height + artist.height + placids.height + 5) : (title.height + artist.height + placids.height + 5)  
    Text {
        id: title
        anchors.bottom: albumn.visible ? albumn.top : artist.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 6
        anchors.bottomMargin: 1
        anchors.topMargin: 1
        text: root.player.trackTitle 
        font.pixelSize: 15
        color: "white" /* '#fbbf60' */
        elide: Text.ElideRight
        font.bold: true
    }
    Text {
        id: artist
        anchors.bottom: mediacontrolls.top /* albumn.visible ? albumn.bottom : title.bottom */
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 6
        anchors.bottomMargin: -1
        anchors.topMargin: 1
        text: root.player.trackArtist
        font.pixelSize: 14
        color:  '#414141'
        elide: Text.ElideRight
        font.weight: 600
    }
    Text {
        id: albumn
        anchors.bottom: artist.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 6
        anchors.bottomMargin: 1
        anchors.topMargin: 1
        text: root.player.trackAlbum
        font.pixelSize: 14
        font.weight: 600
        color: '#848484'
        elide: Text.ElideRight
        visible: root.player?.trackAlbum !== "" 
        && root.player?.trackAlbum !== root.player?.trackTitle 
        && root.player?.trackAlbum !== root.player?.trackArtist
    }
    RowLayout {
        id:mediacontrolls
    spacing: 4
    anchors.left: parent.left
        anchors.leftMargin: 3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    Button {
    id: placids
    width: 20
    height:20
    checkable: false
    background: Rectangle {
        color: "transparent"
        /* opacity: 0.4
        radius: height/4 */
    }
    icon {
        source: root.iconDir + "backward-solid-full.svg"
        height: 15
        width: 15
        color: root.player?.canGoPrevious ? '#6589ff' : "grey"
        Behavior on color {
        ColorAnimation { duration: 80 } }
    }
    enabled: root.player?.canGoPrevious ?? false
    onClicked: {
        if (root.player && root.player.canGoPrevious) {
            root.player.previous()
                    }
                }
            }   
        
        Button {
            width: 20
            height: 20
            background: Rectangle {
        color: "transparent"
    }
            icon {
            source: (root.player?.playbackState === MprisPlaybackState.Playing) ? root.iconDir + "pause-solid-full.svg" : root.iconDir + "play-solid-full.svg"
            height: 16
            width: 16
            color: root.player ? "#6589ff" : "grey"
            Behavior on color {
        ColorAnimation { duration: 80 } }
    }
            checkable: false
            
            enabled: root.player ?? false
            onClicked: {
            if (!root.player) return
            if (root.player.playbackState === MprisPlaybackState.Playing) {
                    root.player.pause()
                } else {
            root.player.play()
                    }
                }
            }

        Button {
  
    width: 20
    height: 20
    checkable: false
    background: Rectangle {
        color: "transparent"
    }
    icon {
        source: root.iconDir + "forward-solid-full.svg"
        height: 15
        width: 15
        color: root.player?.canGoNext ? '#6589ff' : "grey"
        Behavior on color {
        ColorAnimation { duration: 80 } }
    }
    
    enabled: root.player?.canGoNext ?? false
    onClicked: {
        if (root.player && root.player.canGoNext) {
            root.player.next()
                    }
                }
            }   

        }
        
    }
    Component.onCompleted: {
    console.log("player:", root.player)
    console.log("desktopEntry string:", root.player?.desktopEntry)
    console.log("resolved entry:", root.playerDesktopEntry)
    console.log("icon name:", root.playerDesktopEntry?.icon)
    console.log("resolved path:", root.playerDesktopEntry?.icon ? Quickshell.iconPath(root.playerDesktopEntry.icon) : "empty")
}
}
