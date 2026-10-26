import QtQuick
import Quickshell
import qs.config
import qs.reusables

Item {
    id: root
    width: row.width
    height: row.height

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
        
        Item {
    width: text.width
    height: text.height

    StyledText {
        id: text
        text: Qt.formatDateTime(clock.date, "ddd")
        color: Config.backgroundText
        opacity: 0.7
        font.family: Config.ftFam
        font.weight: Font.Medium
        //font.pixelSize: Config.textSize
    }
}
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 3
            height: 3
            radius: 1.5
            color: Config.outline
        }
        Item {
            width: text2.width
        height: text2.height

            StyledText {
                id: text2
            text: Qt.formatDateTime(clock.date, "h:mm:ss")
            color: Config.backgroundText
            font.family: Config.ftFam
            font.weight: Font.DemiBold
            font.pixelSize: Config.textSize
            }
        }
    }
}
