import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Wayland
import qs.wal as Wal
import qs.bar.dynamicisland
import qs.bar.notchnook
import qs.bar.notchtray
import qs.components.corners
import qs.services 

import "config.js" as Config
import qs.config as Cf
    Item {
        id: root
        property alias barChasis: barChasis
        property int radi: Cf.Config.radius
        property bool globalRadi: true
        anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
        }
        implicitHeight: barChasis.height
        implicitWidth: barChasis.width
    
            
        RectangularShadow {
        id: barShadow
        anchors.fill: barbackground
        bottomLeftRadius: globalRadi ? root.radi : barChasis.bottomLeftRadius
            bottomRightRadius: globalRadi ? root.radi : barChasis.bottomRightRadius
            topLeftRadius: globalRadi ? root.radi :  barChasis.topLeftRadius
            topRightRadius:globalRadi ? root.radi :  barChasis.topRightRadius

        }
        Rectangle {
            id: barbackground
            width: barChasis.width
            height: barChasis.height
            anchors.top: parent.top
            anchors.topMargin: barChasis.floating === true ? barMargin : ""
            anchors.horizontalCenter: parent.horizontalCenter
            Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }
            Behavior on width  { NumberAnimation { duration: 180; easing.type: Easing.InOutQuad } }
            color: Cf.Config.bg
            clip: true 
            bottomLeftRadius:globalRadi ? root.radi :  barChasis.bottomLeftRadius
            bottomRightRadius:globalRadi ? root.radi :  barChasis.bottomRightRadius
            topLeftRadius: floating ? globalRadi ? root.radi :  barChasis.topLeftRadius : 0
            topRightRadius:floating ? globalRadi ? root.radi :  barChasis.topRightRadius : 0

             
    
        Rectangle { 
            id:barChasis
            //properties
            readonly property int barMargin: 0
            property bool floating: false
            property bool fullbar: false
            property bool compact: false
            color: "transparent"
            
            anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            }

            implicitHeight: 32
            implicitWidth: 130

            bottomLeftRadius: barChasis.height / 2 
            bottomRightRadius: barChasis.height / 2
            topLeftRadius:  barChasis.floating === true ? barChasis.height / 2 : ""
            topRightRadius: barChasis.floating === true ? barChasis.height / 2 : ""

       
        Timer {
            id: notchpause
            running: true 
            interval: 750
            repeat: barHover.hovered ? true : false
        }

       
        property bool pinned: false
        property string manualState: ""
        property string hoverTargetState: "notchnookclone"
        property string currentState: {
                if (pinned || notchpause.running)
                return hoverTargetState;
            
                if (manualState === "powermenu" || manualState === "Notifications")
                return manualState;

                return "defaultDynamicIsland"
            }
            onCurrentStateChanged: {
        if (currentState === "defaultDynamicIsland")
        hoverTargetState = "notchnookclone" ;

      
        }
        state: currentState
        states: [
        State {
            name: "defaultDynamicIsland" // default dynamic island
                PropertyChanges {
                barChasis.height: barChasis.implicitHeight
                barChasis.width: (centerBar.width + 26) > 200 ?  (centerBar.width + 26) : 200
                barHover.enabled: true
                                    }
                           },
        /* State {
            name: "Notifications"
                PropertyChanges {
                barChasis.height: notifications.height
                barChasis.width: 200
                barChasis.bottomLeftRadius: 12
                barChasis.bottomRightRadius: 12
                barChasis.topLeftRadius:  barChasis.floating === true ? 12 : ""
                barChasis.topRightRadius:  barChasis.floating === true ? 12 : ""
                }
            }, */
        State {
            name: "powermenu"
                PropertyChanges {
                target: barChasis
                height: powermenu.height + 12
                width: powermenu.width + 13
                bottomLeftRadius: 6
                bottomRightRadius: 6
                topLeftRadius:  barChasis.floating === true ? 6 : ""
                topRightRadius:  barChasis.floating === true ? 6 : ""
                }
                PropertyChanges {
                barHover.enabled:false
                }
            }, 
        State {
            name: "notchnookclone"
            PropertyChanges {
                barChasis.height: 118
                barChasis.width: 320
                barChasis.bottomLeftRadius: barChasis.fullbar === false ? 89 / 4 : ""
                barChasis.bottomRightRadius: barChasis.fullbar === false ? 89 / 4 : ""
                barChasis.topLeftRadius:  barChasis.floating === true ? 89 / 4 : ""
                barChasis.topRightRadius:  barChasis.floating === true ? 89 / 4 : ""
                barHover.enabled:true
                }
            },
        State {
            name: "notchtray"
            
        PropertyChanges {
                barChasis.height: 118
                barChasis.width: 530
                barChasis.bottomLeftRadius: 89 / 4
                barChasis.bottomRightRadius: 89 / 4
                barChasis.topLeftRadius:  barChasis.floating === true ? 89 / 4 : ""
                barChasis.topRightRadius:  barChasis.floating === true ? 89 / 4 : ""
                barHover.enabled:true
                }
            }/* ,
        State {
            name: "applauncher"
            PropertyChanges {
                target: barChasis
                height: 300
                width: 450
                bottomLeftRadius: 8
                bottomRightRadius: 8
                topLeftRadius:  8
                topRightRadius:  8
                anchors.topMargin: ""
                anchors.horizontalCenter: parent.horizontalCenter
                y: screen.height /2 - barChasis.height /2
                }
            PropertyChanges {
                leftcorner.visible: false
                rightcorner.visible: false
            }
            AnchorChanges {
                target: barChasis
                
                anchors.top: ""
                
            }
            } */
        ]
        CenterBar {
        id: centerBar
        anchors {
            top: parent 
            horizontalCenter: parent.horizontalCenter
        }

        opacity: barChasis.state !== "defaultDynamicIsland" ? 0 : 1
        //scale: barChasis.state !== "defaultDynamicIsland" ? 0 : 1
        enabled: barChasis.state !== "defaultDynamicIsland" ? false : true
        visible: false
        Behavior on opacity { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }
        }


        NotchNook {
            id: notchnook
        anchors {
            horizontalCenter: parent.horizontalCenter 
        }

        opacity: barChasis.state !== "notchnookclone" ? 0 : 1
        //scale: barChasis.state !== "notchnookclone" ? 0 : 1 
        enabled: barChasis.state !== "notchnookclone" ? false : true

        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }
        }

        NotchTray {
            id: notchtray
        anchors {
            centerIn: parent 
        }

        opacity: barChasis.state !== "notchtray" ? 0 : 1
        //scale: barChasis.state !== "notchtray" ? 0 : 1
        enabled: barChasis.state !== "notchtray" ? false : true

        Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
        }

        ExpandedStateSwitch {
        id: notchswitch
        anchors {
        right: parent.right
        rightMargin: 4
        verticalCenter: parent.verticalCenter
        }
        opacity: barChasis.currentState === "notchnookclone" || barChasis.currentState === "notchtray" ? 1 : 0
         visible: false //barChasis.state !== "powermenu" ? false : true 

        Behavior on opacity { NumberAnimation { duration: 80; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
        }
        HoverHandler {
        id: barHover
        onHoveredChanged: {
                    if (barHover.hovered == true && barChasis.currentState === barChasis.hoverTargetState)
                        notchpause.start()
                        
                    }
                }
        TapHandler {
    id: barTap
    onTapped: {
        notchpause.start()
            }
}
PowerMenu {
    id: powermenu
    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        topMargin: 6
    }
    //scale: barChasis.state !== "powermenu" ? 0 : 1
    opacity: barChasis.state !== "powermenu" ? 0 : 1
    enabled: barChasis.state !== "powermenu" ? false : true
    

    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.InOutQuad } }
    Behavior on opacity { NumberAnimation { duration: 20; easing.type: Easing.InOutQuad } }
}
                IpcHandler { 
            target: "bar"
            function powermenu() {
            barChasis.manualState = "powermenu"
            notchpause.stop()
            }
        }       
        
                /* Behavior on y { NumberAnimation { duration: 50; easing.type: Easing.InOutQuad } } */
        Behavior on radius { SmoothedAnimation { easing.type: Easing.InOutQuad; duration: 175} }
        Behavior on color  { ColorAnimation { duration: 300; easing.type: Easing.InOutQuad } }
        
        }
            DropArea {
        
        anchors.fill: barChasis

        onEntered: {
            barChasis.hoverTargetState = "notchtray"
            barChasis.pinned = true
        }
        onExited: {
            barChasis.pinned = false
        }
        onDropped: (drop) => {
            console.log("DROPPED", drop.hasUrls)
            barChasis.pinned = false
            drop.acceptProposedAction()
             if (!drop.hasUrls) return
    const path = drop.urls[0].toString().replace("file://", "")

    sendProcess.command = ["foot", "localsend-cli", "send", path]
    sendProcess.running = true

    drop.accepted = true
            }
        }
    }

    RoundCorner {
            id:leftcorner
            anchors.right: barbackground.left; anchors.top: barbackground.top
            implicitSize: (11.5); color: Cf.Config.bg ; corner: RoundCorner.CornerEnum.TopRight
            visible: barChasis.floating === false && barChasis.fullbar === false; opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 250 } }
        }

        RoundCorner {
            id:rightcorner
            anchors.left: barbackground.right; anchors.top: barbackground.top
            implicitSize: (11.5); color: Cf.Config.bg ; corner: RoundCorner.CornerEnum.TopLeft
            visible: barChasis.floating === false && barChasis.fullbar === false; opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 250 } }
        }

}
