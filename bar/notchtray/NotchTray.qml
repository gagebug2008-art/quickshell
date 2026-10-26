import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.bar


ClippingRectangle {
    id: root
    anchors.fill: parent
    radius: 0
    color: "transparent"



    ClipHistory {}








    /* RowLayout {
        id: row
        anchors.fill: parent
        spacing: 6
        anchors.margins: 4
    } */
/* Seperator{anchors.centerIn: parent} */
/* Canvas {
    id: gridBackground
    anchors.fill: parent
    
    property color lineColor: Qt.rgba(1, 1, 1, 0.06)
    property int boxcount: 5 
     property int cubeside: height / boxcount

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
    var ctx = getContext("2d");
    ctx.reset()
    ctx.lineWidth = 1
    ctx.strokeStyle  = lineColor

    for ( var x = 0; x <= width; x += Math.round(cubeside)) {
    ctx.beginPath()
    ctx.moveTo(x, 0)
    ctx.lineTo(x, height)
    ctx.stroke()
    }

    for ( var y = 0; y <= height; y += Math.round(cubeside)) {
    ctx.beginPath()
    ctx.moveTo(0, y + 0.5)
    ctx.lineTo(width, y + 0.5)
    ctx.stroke()
    }

        }
    } */
    /* Canvas {
    id: dotBackground
    anchors.fill: parent

    property color dotColor: Qt.rgba(1, 1, 1, 0.13)
    property real dotRadius: 1
    property int columns: 15
    property int rows: 5

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        ctx.fillStyle = dotColor

        var gapX = width / (columns + 1)
        var gapY = height / (rows + 1)

        for (var i = 1; i <= columns; i++) {
            for (var j = 1; j <= rows; j++) {
                var x = Math.round(i * gapX)
                var y = Math.round(j * gapY)

                ctx.beginPath()
                ctx.arc(x, y, dotRadius, 0, Math.PI * 2)
                ctx.fill()
            }
        }
    }
} */
}
