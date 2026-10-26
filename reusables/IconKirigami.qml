import org.kde.kirigami as Kirigami
import QtQuick
import qs.config

Kirigami.Icon {
  id: root

  required property string icon
  property bool filled: false
  property alias monochrome: root.isMask

  property int implicitSize: 20

  implicitWidth: implicitSize
  implicitHeight: implicitSize

  readonly property string name: icon.replace(/\.svg$/, "")

  source: icon === "" ? "" : `${Config.iconDir}${name}${filled ? "-filled" : ""}.svg`
  fallback: name
  roundToIconSize: false
  color: Config.panelText
  isMask: true
  animated: false
}
