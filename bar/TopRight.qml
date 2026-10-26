import Quickshell
import QtQuick
import qs.components.corners
import QtQuick.Effects
import qs.bar.dynamicisland
import qs.config as Cf
Item {
id: root

anchors {
top: parent.top
right: parent.right

}

width: 190
height: 40
RectangularShadow {
anchors.fill: region
bottomLeftRadius: region.bottomLeftRadius
}

RoundCorner {
id:rightcorner
anchors.right: region.left; anchors.top: region.top
implicitSize: (11.5); color: Cf.Config.bg ; corner: RoundCorner.CornerEnum.TopRight
visible: barChasis.floating === false && barChasis.fullbar === false; opacity: visible ? 1 : 0
Behavior on opacity { NumberAnimation { duration: 250 } }
}

RoundCorner {
id:bottomcorner
anchors.top: region.bottom; anchors.right: region.right 
implicitSize: (11.5); color: Cf.Config.bg ; corner: RoundCorner.CornerEnum.TopRight
visible: barChasis.floating === false && barChasis.fullbar === false; opacity: visible ? 1 : 0
Behavior on opacity { NumberAnimation { duration: 250 } }
}

Rectangle {
id: region

color: Cf.Config.bg 
width: root.width
height: 32
anchors {
top: parent.top
right: parent.right
  }
bottomLeftRadius: Cf.Config.radius
}
CenterBar {
anchors.right: parent.right
anchors.verticalCenter: parent.verticalCenter
anchors.verticalCenterOffset: -4
anchors.rightMargin: 16
visible: true
}

}

