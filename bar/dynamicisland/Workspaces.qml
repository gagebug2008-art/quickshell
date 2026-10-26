import QtQuick
import Quickshell

Rectangle {
    id: root

    property int buttonwsspacing: 3
    property int buttonwsheight: 3
    property int buttonwsradius: buttonwsheight / 2

    property int buttonwswidthInactive: 7
    property int buttonwswidthActive: 20

    color: "transparent"

    property var visibleTags: []
    property int rowContentWidth: 0

    function computeRowWidth(tags) {
        var count = tags.length
        if (count <= 0)
            return 0

        var sum = 0
        for (var i = 0; i < count; i++) {
            var t = tags[i]
            sum += (t.focused ? root.buttonwswidthActive : root.buttonwswidthInactive)
        }
        sum += (count - 1) * root.buttonwsspacing
        return sum
    }

    function rebuildVisibleTags() {
        var result = []
        for (var i = 0; i < CompositorData.tags.count; i++) {
            var t = CompositorData.tags.get(i)
            if (t.hasWindows || t.focused)
                result.push(t)
        }
        visibleTags = result
        rowContentWidth = computeRowWidth(result) // <-- force width update after tags change
    }

    Connections {
        target: CompositorData.tags
        function onCountChanged() { root.rebuildVisibleTags() }
        function onDataChanged() { root.rebuildVisibleTags() }
    }

    Component.onCompleted: rebuildVisibleTags()

    width: rowContentWidth
    height: buttonwsheight

    Row {
        id: row
        anchors.centerIn: parent
        spacing: root.buttonwsspacing
        // width will come from root.width, so the row can't “spill” past it
        width: root.width

        Repeater {
            id: rpt
            model: root.visibleTags

            delegate: Rectangle {
                required property var modelData
                required property int index
                
                anchors.verticalCenter: parent.verticalCenter
                width: modelData.focused ? root.buttonwswidthActive : root.buttonwswidthInactive
                height: root.buttonwsheight
                radius: root.buttonwsradius

                color: modelData.focused ? "#e0a048" : "#8a8a8a"
                opacity: modelData.focused ? 1.0 : 0.7

                Behavior on width {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }
        }
    }
}
