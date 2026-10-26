import QtQuick

Item {
   id: root

   required property Item item
   property real radius: 0
   property real strokeWidth: 1.5
   property real padding: 3
   property bool showRing: true
   property color ringColor: "#3b82f6"
   property color dotColor: "#ccffffff"
   property int pathCount: 20
   property real dotSize: 3
   property real dotSpacing: 6   // px between dot centers

   width: item.width + padding * 2
   height: item.height + padding * 2
   anchors.centerIn: item
   z: 1

   readonly property real _i: strokeWidth / 2
   readonly property real _r: Math.max(0, Math.min(radius - _i, (width - strokeWidth) / 2, (height - strokeWidth) / 2))
   readonly property real _len: Math.max(0.01, Math.min((pathCount - 1) * dotSpacing, width - strokeWidth - 2 * _r))
   readonly property real _cx: width / 2
   readonly property real _bottom: height - _i

   

   PathView {
      id: pathView
      anchors.fill: parent

      model: root.pathCount
      pathItemCount: Math.max(1, root.pathCount)
      interactive: false
      highlightRangeMode: PathView.NoHighlightRange
      snapMode: PathView.NoSnap

      path: Path {
         // 1. cluster segment: items land here, evenly spaced, centered on the bottom
         startX: root._cx - root._len / 2
         startY: root._bottom
         PathLine { x: root._cx + root._len / 2; y: root._bottom }
         PathPercent { value: root.pathCount > 1 ? (root.pathCount - 1) / root.pathCount : 0 }

         // 2. rest of the ring, counterclockwise on screen, back to the start
         PathLine { x: root.width - root._i - root._r; y: root._bottom }
         PathArc {
            x: root.width - root._i; y: root._bottom - root._r
            radiusX: root._r; radiusY: root._r
            direction: PathArc.Counterclockwise
         }
         PathLine { x: root.width - root._i; y: root._i + root._r }
         PathArc {
            x: root.width - root._i - root._r; y: root._i
            radiusX: root._r; radiusY: root._r
            direction: PathArc.Counterclockwise
         }
         PathLine { x: root._i + root._r; y: root._i }
         PathArc {
            x: root._i; y: root._i + root._r
            radiusX: root._r; radiusY: root._r
            direction: PathArc.Counterclockwise
         }
         PathLine { x: root._i; y: root._bottom - root._r }
         PathArc {
            x: root._i + root._r; y: root._bottom
            radiusX: root._r; radiusY: root._r
            direction: PathArc.Counterclockwise
         }
         PathLine { x: root._cx - root._len / 2; y: root._bottom }
         PathPercent { value: 1 }
      }

      delegate: Rectangle {
         width: root.dotSize
         height: root.dotSize
         radius: width / 2
         color: root.dotColor
      }
   }
}
