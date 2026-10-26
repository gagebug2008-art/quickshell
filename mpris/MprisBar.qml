import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.config as Cf

Item {
    id: root
    
    height: parent.height
    width: parent.width
    
    ClippingRectangle {
        anchors.fill: parent
        anchors.margins: 3
        radius: Cf.Config.radius - 3
        Image {
            id: img
            anchors.fill: parent
            source: Player.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            smooth: true
            mipmap: true
        }
    }
}
