import QtQuick

Item {
    id: root

    property Component sourceComponent: null
    property bool active: true
    property int duration: 180
    property int easingType: Easing.InOutQuad

    // exposes the live item, same as Loader.item, for anchors/centerIn usage
    readonly property Item item: currentLoader.item

    implicitWidth: currentLoader.item ? currentLoader.item.implicitWidth : 0
    implicitHeight: currentLoader.item ? currentLoader.item.implicitHeight : 0

    // current = the one fading in / visible
    Loader {
        id: currentLoader
        anchors.fill: parent
        asynchronous: false
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: root.duration; easing.type: root.easingType }
        }

        onLoaded: opacity = 1
    }

    // outgoing = a snapshot kept alive just long enough to fade out
    Loader {
        id: outgoingLoader
        anchors.fill: parent
        asynchronous: false
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: root.duration; easing.type: root.easingType }
        }

        onOpacityChanged: {
            if (opacity === 0 && sourceComponent !== null)
                sourceComponent = null   // release once fully faded
        }
    }

    function _swap(newComp) {
        // move whatever's currently showing into the outgoing slot, faded out
        if (currentLoader.item && currentLoader.sourceComponent !== null) {
            outgoingLoader.sourceComponent = currentLoader.sourceComponent
            outgoingLoader.opacity = 1
            outgoingLoader.opacity = 0   // triggers Behavior -> fades out -> unloads
        }
        currentLoader.opacity = 0
        currentLoader.sourceComponent = newComp
    }

    onSourceComponentChanged: {
        if (!active) return
        _swap(sourceComponent)
    }

    onActiveChanged: {
        _swap(active ? sourceComponent : null)
    }

    Component.onCompleted: {
        if (active && sourceComponent)
            currentLoader.sourceComponent = sourceComponent
    }
}
