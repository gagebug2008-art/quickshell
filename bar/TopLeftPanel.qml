import Quickshell
import QtQuick
import qs.components.corners
import QtQuick.Effects
import qs.config as Cf
Item {
id: root

anchors {
top: parent.top
left: parent.left
}

width: 200
height: 40
RectangularShadow {
	anchors.fill: region
	bottomRightRadius: Cf.Config.radius
}
Rectangle {
id: region

color: Cf.Config.bg 
width: 180
height: 32
anchors {
top: parent.top
left: parent.left
  }
  bottomRightRadius: Cf.Config.radius
        RoundCorner {
            id:rightcorner
            anchors.left: parent.right; anchors.top: parent.top
            implicitSize: (11.5); color: Cf.Config.bg ; corner: RoundCorner.CornerEnum.TopLeft
            visible: barChasis.floating === false && barChasis.fullbar === false; opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 250 } }
        }
        RoundCorner {
            id:bottomcorner
            anchors.top: parent.bottom; anchors.left: parent.left 
            implicitSize: (11.5); color: Cf.Config.bg ; corner: RoundCorner.CornerEnum.TopLeft
            visible: barChasis.floating === false && barChasis.fullbar === false; opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 250 } }
        }
	}
}

