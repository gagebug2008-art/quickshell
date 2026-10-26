import QtQuick
import QtQuick.Controls
import qs.config
import QtQuick.Layouts

FocusScope {
   id: root
   implicitWidth: 400
   implicitHeight: 25

   property string placeholderText: "Search..."
   readonly property string query: mainSearch.text.replace(/[*?\[\]]/g, "")
   property alias text: mainSearch.text
   property alias field: mainSearch
   signal submitted()
   property string leftIcon: "magnifying-glass.svg"
   property string rightIcon: "squares-four-fill.svg"
   property string rightIconAction: ""
   property var leftIconAction: ""
   RowLayout {
      anchors.fill: parent
      spacing: 4

      IconKirigami {
         id: icon
         Layout.alignment: Qt.AlignVCenter
         Layout.preferredWidth: 25
         Layout.preferredHeight: 25
         source: Config.iconDir + root.leftIcon
         TapHandler {
            onTapped:  leftIconAction
         }
      }

      TextField {
         id: mainSearch
         Layout.fillWidth: true
         Layout.alignment: Qt.AlignVCenter
         focus: true
         selectByMouse: true
         verticalAlignment: TextInput.AlignVCenter
         topPadding: 0
         bottomPadding: 0
         background: null

         placeholderText: root.placeholderText
         placeholderTextColor: Qt.alpha(Config.backgroundText, 0.5)
         color: Config.backgroundText

         font {
            kerning: true
            pixelSize: Config.textSize + 2
            family: Config.ftFam
            weight: Config.ftWt
         }

         onAccepted: root.submitted()
      }

      IconKirigami {
         id: icon2
         visible: root.leftIcon !== ""
         Layout.alignment: Qt.AlignVCenter
         Layout.preferredWidth: 25
         Layout.preferredHeight: 25
         source: Config.iconDir + root.rightIcon
         TapHandler {
            onTapped:  rightIconAction
         }
      }
   }
}
