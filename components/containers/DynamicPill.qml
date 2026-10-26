import QtQuick
import Quickshell

Item {
id: root 

width: 100
height: 32

Rectangle {
id: background
width: parent.width
height: parent.height
anchors.fill: parent
Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }
Behavior on width  { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }
color: "black"
clip: true 
bottomLeftRadius: parent.bottomLeftRadius
bottomRightRadius: parent.bottomRightRadius
topLeftRadius: parent.topLeftRadius
topRightRadius: parent.topRightRadius

radius: parent.radius
Item {
id: container


}
}


} 
