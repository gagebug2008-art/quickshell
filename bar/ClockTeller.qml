import QtQuick
import Quickshell
import qs.wal as Wal
import qs.config as Cf
Item {
   width: row.height
   height: row.width
   
   

SystemClock {
    id: clock
    precision: SystemClock.Seconds
}

Row {
    id: row
    spacing: 4

    Text {
        id: dayText
        anchors.verticalCenter: parent.verticalCenter
        color: Cf.Config.button
        font.pixelSize: 13
        font.family: "JetBrainsMono Nerd Font"
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferFullHinting
        text: Qt.formatDateTime(clock.date, "ddd")
    }

    Text {
        id: hourText
        anchors.verticalCenter: parent.verticalCenter
        color: Cf.Config.fg
        font.pixelSize: 17
        font.family: "JetBrainsMono Nerd Font"
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferFullHinting
        text: Qt.formatDateTime(clock.date, "HH")
    }

    Text {
        id: colonText1
        anchors.verticalCenter: parent.verticalCenter
        color: Cf.Config.fg
        font.pixelSize: 17
        font.family: "JetBrainsMono Nerd Font"
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferFullHinting
        text: ":"
    }

    Text {
        id: minuteText
        anchors.verticalCenter: parent.verticalCenter
        color: Cf.Config.fg
        font.pixelSize: 17
        font.family: "JetBrainsMono Nerd Font"
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferFullHinting
        text: Qt.formatDateTime(clock.date, "mm")
    }

    Text {
        id: colonText2
        anchors.verticalCenter: parent.verticalCenter
        color: Cf.Config.fg
        font.pixelSize: 17
        font.family: "JetBrainsMono Nerd Font"
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferFullHinting
        text: ":"
    }

    Text {
        id: secondText
        anchors.verticalCenter: parent.verticalCenter
        color: Cf.Config.fg
        font.pixelSize: 17
        font.family: "JetBrainsMono Nerd Font"
        renderType: Text.NativeRendering
        font.hintingPreference: Font.PreferFullHinting
        text: Qt.formatDateTime(clock.date, "ss")
    }
 }}
