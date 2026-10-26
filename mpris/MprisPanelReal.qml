import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs.reusables
import qs.config

Item {
   id: root
   height: 260
   width: 210

   property int controlsGap: 32

   readonly property bool lyricsVisible: Lyrics.hasLyrics

   // Visual right edge of the (scaled) art, in root coordinates
   readonly property real artRight: content.x + artHolder.x + artHolder.width / 2 + (trackart.width * trackart.scale) / 2

   Row {
      id: movementInfo
      anchors {
         bottom: parent.bottom
         left: parent.left
         margins: 4
      }

      property int infoiconsize: 14

      IconKirigami {
         id: infoShuffle
         icon: "shuffle.svg"
         implicitSize: movementInfo.infoiconsize
         color: Qt.darker(Config.backgroundText, 1.4)
         opacity: Player.shuffle ? 1.0 : 0.4
         TapHandler {
            onTapped: Player.activePlayer.shuffle = !Player.shuffle

         }
      }

      IconKirigami {
         id: infoLoop
         icon: Player.loopState === MprisLoopState.Track ? "repeat-once.svg" : "repeat.svg"
         implicitSize: movementInfo.infoiconsize
         color: Qt.darker(Config.backgroundText, 1.4)
         opacity: Player.loopState !== MprisLoopState.None ? 1.0 : 0.4

         TapHandler {
            onTapped: {
               const p = Player.activePlayer
               if (!p) return

               if (p.loopState === MprisLoopState.Track) {
                  p.loopState = MprisLoopState.None
               } else {
                  p.loopState = MprisLoopState.Track
               }
            }
         }
      }
   }

   Column {
      id: content
      width: 160
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.topMargin: 20

      Item {
         id: artHolder
         width: 160
         height: 160

         RectangularShadow {
            anchors.fill: trackart
            radius: 16
            blur: 30
            spread: 4
            color: Qt.alpha("black", 0.8)
            scale: trackart.scale
         }

         TrackArt {
            id: trackart
            height: 160
            width: height
            anchors.centerIn: parent

            scale: Player.isPlaying ? 1 : 0.8
            property real tiltY: 0
            Timer {
               id: tiltReset
               interval: 250
               onTriggered: trackart.tiltY = 0
            }
            transform: Rotation {
               id: artRotation
               origin.x: trackart.width / 2
               origin.y: trackart.height / 2
               axis.x: 0
               axis.y: 1
               axis.z: 0
               angle: trackart.tiltY
            }

            Behavior on tiltY {
               NumberAnimation {
                  duration: 250
                  easing.type: Easing.OutCubic
               }
            }            Behavior on scale {
               NumberAnimation {
                  duration: 250
                  easing.type: Easing.OutCubic
               }
            }

            HoverHandler {
               id: arthover
            }

            TapHandler {}

            MouseArea {
               id: artMouse
               width: Player.isPlaying ? parent.width * 0.8 : parent.width
               height: width
               anchors.centerIn: parent
               enabled: Player.canTogglePlaying
               onClicked: Player.togglePlaying()
            }

            MouseArea {
               id: artMouseBottomLeft
               width: parent.width * 0.2
               height: parent.height
               anchors.left: parent.left
               anchors.verticalCenter: parent.verticalCenter
               enabled: Player.canGoPrevious
               onClicked: {
               trackart.tiltY = -30
               tiltReset.restart()
               Player.previous()
            }
            }

            MouseArea {
               id: artMouseBottomRight
               width: parent.width * 0.2
               height: parent.height
               anchors.right: parent.right
               anchors.verticalCenter: parent.verticalCenter
               enabled: Player.canGoNext
                           onClicked: {
               trackart.tiltY = 30
               tiltReset.restart()
               Player.next()
            }
               }
         }
      }

      RowLayout {
         id: row
         width: 160
         height: 24
         spacing: 12

         Slider {
            id: seek

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            from: 0
            to: Math.max(1, Player.length)

            property bool dragging: false
            property real dragPosition: Player.position

            value: dragging ? dragPosition : Player.position

            enabled: Player.canSeek && Player.length > 0
            opacity: enabled ? 1 : 0.45

            onPressedChanged: {
               if (pressed) {
                  dragPosition = value
                  dragging = true
               } else if (dragging) {
                  Player.seek(dragPosition)
                  dragging = false
               }
            }

            onMoved: {
               if (pressed)
                  dragPosition = value
            } 
         
            background: Rectangle {
               x: seek.leftPadding
               y: seek.height / 2 - height / 2
               width: seek.availableWidth
               height: 5
               radius: 2
               color: Qt.alpha(Config.backgroundText, 0.25)

               Rectangle {
                  width: seek.position * parent.width
                  height: parent.height
                  radius: 2
                  color: Config.backgroundText
               }
            }

            handle: Item {
               implicitWidth: 18
               implicitHeight: 12

               x: seek.leftPadding
                  + seek.visualPosition * (seek.availableWidth - width)
               y: seek.height / 2 - height / 2

               Rectangle {
                  anchors.fill: parent
                  radius: 3
                  color: Config.background
               }

               Rectangle {
                  anchors.centerIn: parent
                  width: parent.width - 4
                  height: parent.height - 2
                  radius: 3
                  color: Config.backgroundText
               }
            }
         }
         StyledText {
            text: "-" + Player.formatTime(
               Player.length - (seek.pressed ? seek.value : Player.position)
            )
         }
      }

      Column {
         id: info
         width: parent.width

         StyledText {
            text: Player.trackTitle
            font.pixelSize: 15
            font.weight: 600
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
         }

         StyledText {
            text: Player.trackArtist
            font.pixelSize: 12
            font.weight: 500
            color: Qt.darker(Config.backgroundText, 1.3)
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
         }
      }
   }

   Rectangle {
      id: sourceBak
      property bool open: false

      width: open ? list.width : header.width
      height: open ? list.height : 20

      x: (chipHover.hovered || open) ? (root.artRight + 4) : (root.artRight - header.width * 0.85)
      anchors.top: parent.top
      anchors.topMargin: 40

      color: Config.backgroundText
      radius: 6
      clip: true
      z: -10

      Behavior on x {
         NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
         }
      }

      Behavior on width {
         NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
         }
      }

      Behavior on height {
         NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
         }
      }

      HoverHandler {
         id: chipHover
         enabled: !arthover.hovered
      }

      Column {
         id: list

         Item {
            id: header
            implicitWidth: headerText.implicitWidth + 16
            implicitHeight: 20

            Text {
               id: headerText
               anchors.centerIn: parent
               text: (Player.activePlayer?.identity ?? "No Player") + "  " + (sourceBak.open ? "▾" : "▴")
               color: Config.background
               font.pixelSize: 12
               font.weight: 700
            }

            TapHandler {
               enabled: !arthover.hovered
               onTapped: sourceBak.open = !sourceBak.open
            }
         }

         Repeater {
            model: Player.players.filter(p => p !== Player.activePlayer)

            delegate: Item {
               id: src
               required property var modelData

               implicitWidth: label.implicitWidth + 16
               implicitHeight: 22

               Text {
                  id: label
                  anchors.centerIn: parent
                  text: src.modelData.identity
                  color: Config.background
                  font.pixelSize: 12
                  font.weight: 500
                  opacity: 0.6
               }

               TapHandler {
                  onTapped: {
                     if (src.modelData) {
                        Player.selectPlayer(src.modelData)
                        sourceBak.open = false
                     }
                  }
               }
            }
         }
      }
   }

   RowLayout {
      id: movement
      visible: false

      anchors {
         bottom: parent.bottom
         horizontalCenter: parent.horizontalCenter
         bottomMargin: 10
      }

      Item {
         Layout.preferredWidth: 28
         Layout.preferredHeight: 38
         Layout.alignment: Qt.AlignVCenter

         IconKirigami {
            id: shuffle
            icon: "shuffle.svg"
            color: Player.shuffle ? Config.backgroundText : Config.primary
            anchors.centerIn: parent

            TapHandler {
               enabled: Player.hasPlayer
               onTapped: Player.activePlayer.shuffle = !Player.shuffle
            }
         }
      }

      Item {
         Layout.preferredWidth: 38
         Layout.preferredHeight: 38
         Layout.alignment: Qt.AlignVCenter

         IconKirigami {
            id: prev
            icon: "skip-back.svg"
            color: Config.backgroundText
            opacity: Player.canGoPrevious ? 1 : 0.45
            Layout.alignment: Qt.AlignVCenter
            implicitSize: 24
            anchors.centerIn: parent

            TapHandler {
               enabled: Player.canGoPrevious
               onTapped: Player.previous()
            }
         }
      }

      Rectangle {
         Layout.preferredWidth: 42
         Layout.preferredHeight: 42
         Layout.alignment: Qt.AlignVCenter
         color: Config.backgroundText
         radius: height / 2

         IconKirigami {
            id: play
            icon: Player.isPlaying ? "pause.svg" : "play.svg"
            color: Config.background
            anchors.centerIn: parent
            implicitSize: 24
         }

         TapHandler {
            enabled: Player.canTogglePlaying
            onTapped: Player.togglePlaying()
         }
      }

      Item {
         Layout.preferredWidth: 38
         Layout.preferredHeight: 38
         Layout.alignment: Qt.AlignVCenter

         IconKirigami {
            id: next
            icon: "skip-forward.svg"
            color: Config.backgroundText
            opacity: Player.canGoNext ? 1 : 0.45
            Layout.alignment: Qt.AlignVCenter
            implicitSize: 28
            anchors.centerIn: parent

            TapHandler {
               enabled: Player.canGoNext
               onTapped: Player.next()
            }
         }
      }

      Item {
         Layout.preferredWidth: 28
         Layout.preferredHeight: 38
         Layout.alignment: Qt.AlignVCenter

         IconKirigami {
            id: loop
            icon: Player.loopState === MprisLoopState.Track ? "repeat-once.svg" : "repeat.svg"
            color: Player.loopState !== MprisLoopState.None ? Config.backgroundText : Config.primary
            Layout.alignment: Qt.AlignVCenter

            Behavior on color {
               ColorAnimation {
                  duration: 80
               }
            }

            anchors.centerIn: parent

            TapHandler {
               onTapped: {
                  const p = Player.activePlayer
                  if (!p) return

                  if (p.loopState === MprisLoopState.None)
                     p.loopState = MprisLoopState.Playlist
                  else if (p.loopState === MprisLoopState.Playlist)
                     p.loopState = MprisLoopState.Track
                  else
                     p.loopState = MprisLoopState.None
               }
            }
         }
      }
   }
}
