import QtQuick
import Quickshell
import qs.bar.dynamicisland
import qs.components.corners

Item {
id: root

implicitWidth: panel.width
implicitHeight: panel.height



RoundCorner {
        anchors.left: panel.right; anchors.bottom: panel.bottom
        implicitSize: (panel.implicitHeight/2); color: "black"; corner: RoundCorner.CornerEnum.BottomLeft     
        }
        RoundCorner {
        anchors.right: panel.left; anchors.bottom: panel.bottom
        implicitSize: (panel.implicitHeight/2); color: "black"; corner: RoundCorner.CornerEnum.BottomRight
                }



DMpris {
id: panel

width: 120
height: 32
posbottom: true
react: false
float: false
states: [
        State {
            name: "normal" 
                PropertyChanges {}
                           },
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
            name: "expanded"
            PropertyChanges {
                barChasis.height: 118
                barChasis.width: 700
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
            }        
        ]
    }
}
