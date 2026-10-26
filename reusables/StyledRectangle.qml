import QtQuick
import qs.config as Cf

Rectangle {
    id: root

    radius: Cf.Config.radius ?? 0
    color: Cf.Config.bg
    border.color: Cf.Config.border
    border.width: Cf.Config.borderW
}
