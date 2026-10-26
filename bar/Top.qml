import QtQuick
import Quickshell
import QtQuick.Effects
import Quickshell.Wayland
import Quickshell.Io

import qs.reusables
import qs.bar.notchnook
import qs.mpris
import qs.components.corners
import qs.config as Cf
import qs.clocks
import qs.mpris as M

PanelWindow {
    id: root
WlrLayershell.namespace: "qs-bar"

    anchors {
        top: true
        left: true 
        right: true 
    }
    //BackgroundEffect.blurRegion: Region {
        //Region { item: topMiddle }
        //Region { item: test }}
    mask: Region {
        Region { item: topMiddle }
        Region { item: topLeftPanel }
        Region { item: test }
        Region { item: test2 }
        Region { item: topRight }
    }

    implicitHeight: 300
    color: "transparent"

    
    WlrLayershell.keyboardFocus: (topMiddle.state === "powermenu" || topMiddle.state === "walselector") ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    exclusiveZone: 36
    //SearchBar {id:test2; anchors.centerIn:parent}

    Rectangle {
        id: smallBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 4
        color: Cf.Config.bg
        z: 10
    }

    RectangularShadow {
        z: -4
        anchors.fill: smallBar
    }

    Item {
        id: container
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: smallBar.bottom

        Bubble {
    id: topMiddle
    hubId: "topMiddle"

    postop: true
    float: Cf.Config.barFloat
    react: Cf.Config.barReact
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: Cf.Config.barFloat ? 5 : 0

    width: 160
    height: 32

    focus: true
    state: "normal"

    // Property to control auto-collapse behavior externally
    readonly property bool autoCollapse: state !== "walselector"

    states: [
        State {
            name: "normal"
            PropertyChanges { target: topMiddle; width: 160; height: 34 }
        },
        State {
            name: "nook"
         PropertyChanges { target: topMiddle; width: 210; height: 260 }
        },
        State {
            name: "powermenu"
            PropertyChanges { target: topMiddle; width: 426; height: 80 }
        },
        State {
            name: "walselector"
            PropertyChanges { target: topMiddle; width: 706; height: 180 }
        }
    ]

    Keys.onEscapePressed: (event) => {
        if (state !== "normal") {
            state = "normal"
            event.accepted = true
        }
    }

    onStateChanged: {

        if (state === "powermenu") {
            forceActiveFocus()
            powerMenuTimer.restart()
        } else {
            powerMenuTimer.stop()
        }
    }

    onClicked: {
        state = (state === "normal" ? "nook" : "normal")
    }

    Timer {
        id: powerMenuTimer

        interval: 4000
        repeat: false

        onTriggered: {
            if (topMiddle.state === "powermenu")
                topMiddle.state = "normal"
        }
    }

    IpcHandler {
        target: "bar"

        function powermenu() {
            console.log("Opening power menu")
            topMiddle.state = "powermenu"
        }

        function walselector() {
            topMiddle.state = "walselector"
        }
    }
    Item {
        id: genCont

        anchors.left:parent.left
        anchors.top:stateSwitcher.active ? stateSwitcher.bottom : parent.top
        anchors.bottom: searchBar.active ? searchBar.top : parent.bottom
        anchors.right: parent.right
    Loader {
        id: powerMenuLoader

        anchors.fill: parent
        active: topMiddle.state === "powermenu"

        sourceComponent: PowerMenu {
            anchors.centerIn: parent
        }

        onLoaded: item.forceActiveFocus()
    }

    Loader {
        anchors.fill: parent
        active: topMiddle.state === "nook"

        sourceComponent: MprisPanelReal {
            anchors.centerIn: parent
        }
    }

    Loader {
        active: topMiddle.state === "normal"
        anchors.centerIn: parent

        sourceComponent: Clock1 {}
    }

    Loader {
        id: walSelectorLoader

                active: topMiddle.state === "walselector"

        sourceComponent: WallPaperSelector {
            query: searchBar.item ? searchBar.item.query : ""
        }

        onLoaded: {
            if (item) {
                item.forceActiveFocus()
                }
            }
        }
    }
    Loader {
        id: searchBar

        
        anchors.margins: 4
        active: topMiddle.state === "walselector"
        anchors.horizontalCenter: parent.horizontalCenter

        sourceComponent: SearchBar {}
    }

    Loader {
        id: stateSwitcher

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        active: false//topMiddle.state !== "normal"
        sourceComponent: GeneralStateSwitcher{}
    }
}      RoundCorner {
            anchors.left: topMiddle.right
            anchors.top: topMiddle.top
            implicitSize: topMiddle.height / 2
            color: topMiddle.bg
            corner: RoundCorner.CornerEnum.TopLeft
            visible: !Cf.Config.barFloat
        }

        RoundCorner {
            anchors.right: topMiddle.left
            anchors.top: topMiddle.top
            implicitSize: topMiddle.height / 2
            color: topMiddle.bg
            corner: RoundCorner.CornerEnum.TopRight
            visible: !Cf.Config.barFloat
        }

        Bubble {
    id: test
    hubId: "test"

    anchors.right: topMiddle.left
    anchors.rightMargin: 10
    anchors.top: parent.top
    anchors.topMargin: 5
    clipQ: false
    posright: true
    postop: true

    readonly property real baseSize: Cf.Config.barFloat ? 32 : 27

    width: 34
    height: 34

    state: "normal"

    states: [
        State {
            name: "normal"
            PropertyChanges {
             target: test
               width: 34
    height: 34 
            }
        },
        State {
            name: "expanded"
            PropertyChanges {
                target: test
                width: 210
                height: 260
            }
        }
    ]

    onClicked: {
        test.state = (test.state === "normal" ? "expanded" : "normal")
    }

    Loader {
        anchors.fill: parent
        active: test.state !== "normal"
        sourceComponent: MprisPanelReal {}
    }

    Loader {
        anchors.fill: parent
        active: test.state === "normal"
        sourceComponent: MprisBar {}
    }
}
    }
}
