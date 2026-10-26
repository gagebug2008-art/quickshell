import QtQuick
import QtQuick.Controls

Item {
    id: circleContainer
    height: heightF
    width: widthF
    property int heightF: 80
    property int widthF: 80
    property real radius: 80

    /* onChildrenChanged: repositionChildren()
    onWidthChanged: repositionChildren()
    onHeightChanged: repositionChildren()
    onRadiusChanged: repositionChildren() */

    function repositionChildren() {
        var count = children.length
        for (var i = 0; i < count; i++) {
            var item = children[i]
            var angle = (2 * Math.PI / count) * i - Math.PI / 2
            item.x = circleContainer.width / 2 + circleContainer.radius * Math.cos(angle) - item.width / 2
            item.y = circleContainer.height / 2 + circleContainer.radius * Math.sin(angle) - item.height / 2
        }
    }

    onChildrenChanged: Qt.callLater(repositionChildren)
}