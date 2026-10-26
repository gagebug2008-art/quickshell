// Bubble.qml
import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import qs.config as Cf

Rectangle {
   id: root

   //--------------- Properties ----------------------------------------------------------//

   // children land in the static container, not on the animating shell
   default property alias content: container.data

   property string hubId: ""

   signal clicked()

   property color bg: Cf.Config.bg
   property bool clipQ: true
   property bool postop: false
   property bool posbottom: false
   property bool posleft: false
   property bool posright: false

   property bool react: true
   property bool float: true
   property bool locked: false
   property bool globalRadi: true

   property int fallbackRad: Cf.Config.sc(20)
   property int transformDistance: Cf.Config.sc(3)

   component SmoothAnim: SpringAnimation {
      spring: 3.45
      damping: 0.29
      mass: 0.9
      epsilon: 0.25
   }
      component SmootherAnim: NumberAnimation {
         duration: 200
         easing: Easing.OutCirc
      }

   //--------------- Corner Radii --------------------------------------------------------//

   property real baseRad: globalRadi ? Cf.Config.radius : (parent.radius || fallbackRad)

   property real brRad: (float || postop || posleft) ? baseRad : 0
   property real trRad: (float || (!postop && (posleft || (!posright && posbottom)))) ? baseRad : 0
   property real blRad: (float || postop || (posright && !posleft)) ? baseRad : 0
   property real tlRad: (float || (!postop && !posleft && (posright || posbottom))) ? baseRad : 0

   //--------------- Lifecycle Initialization ---------------------------------------------//

   Component.onCompleted: {
      if (hubId !== "" && typeof StateHub !== "undefined") {
         StateHub.register(hubId, root)
      }
   }
   //-------------- Shader --------------------------------------------------------//

   MultiEffect {

   }

   Rectangle {
   
   }

   ShaderEffectSource {

   }







   //-------------- UI Structure --------------------------------------------------------//

   implicitWidth: 160
   implicitHeight: 32

   anchors {
      top: postop ? parent.top : undefined
      left: posleft ? parent.left : undefined
      right: posright ? parent.right : undefined
      bottom: posbottom ? parent.bottom : undefined
   }

   width: 160
   height: 32

   // the animating shell
   bottomRightRadius: brRad
   topRightRadius: trRad
   bottomLeftRadius: blRad
   topLeftRadius: tlRad
   radius: height / 2
   color: bg
   clip: clipQ

   Behavior on radius { SmootherAnim {} }

   Behavior on width {
      id: wAnim
      SmoothAnim {}
   }
   Behavior on height {
      id: hAnim
      SmoothAnim {}
   }

   // Target size, available on the first frame of an animation.
   readonly property real containerW: wAnim.targetValue !== 0 ? wAnim.targetValue : root.width
   readonly property real containerH: hAnim.targetValue !== 0 ? hAnim.targetValue : root.height

   // Shadow behind the bubble, same shape and size as the shell.
      // Shadow lives beside the bubble (not inside it) so root's clip can't cut it off.
   RectangularShadow {
      id: shadow
      parent: root.parent
      z: root.z - 1
      x: root.x
      y: root.y
      width: root.width
      height: root.height
      bottomRightRadius: root.brRad
      topRightRadius: root.trRad
      bottomLeftRadius: root.blRad
      topLeftRadius: root.tlRad
      color: Qt.rgba(0, 0, 0, 0.5)
      transform: Translate {
         x: root.nudgeX
         y: root.nudgeY
         Behavior on y { SmoothAnim {} }
         Behavior on x { SmoothAnim {} }
      }
   }

   // Static content holder: sized to the final size immediately, never interpolates.
   Item {
      id: container

      anchors {
         top: root.postop ? parent.top : undefined
         left: root.posleft ? parent.left : undefined
         right: root.posright ? parent.right : undefined
         bottom: root.posbottom ? parent.bottom : undefined
         horizontalCenter: (root.posright || root.posleft) ? undefined : parent.horizontalCenter
         verticalCenter: (root.posbottom || root.postop) ? undefined : parent.verticalCenter
      }

      width: root.containerW
      height: root.containerH
   }

   HoverHandler {
      id: leHover
   }

   MouseArea {
      anchors.fill: parent
      z: -1
      onClicked: root.clicked()
   }

   readonly property bool nudged: react && (root.state !== "" && root.state !== "normal" || (float && leHover.hovered))

   transform: Translate {
      y: root.nudged ? (postop ? root.transformDistance : (posbottom ? -root.transformDistance : 0)) : 0
      x: root.nudged ? (posleft ? root.transformDistance : (posright ? -root.transformDistance : 0)) : 0
      Behavior on y { SmoothAnim {} }
      Behavior on x { SmoothAnim {} }
   }
}
