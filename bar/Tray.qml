import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Quickshell.Wayland

Row {
  spacing: 2

  Repeater {
    model: SystemTray.items

    delegate: IconImage {
      id: itemDelegate

      required property SystemTrayItem modelData

      source: modelData ? modelData.icon : ""
      implicitSize: 16
		
    MouseArea {
        id: trayMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
            if (event.button === Qt.LeftButton) 
                itemDelegate.modelData.activate();
             else if (event.button === Qt.RightButton && itemDelegate.modelData.hasMenu)
                // Reset to root menu before showing
                menuWin.visible = !menuWin.visible;
            
        }
    }
    	
	
    PopupWindow {
        id: menuWin

        anchor.item:itemDelegate

        grabFocus: true
        visible: false
        color: "white"

        width: menuColumn.implicitWidth
        height: menuColumn.implicitHeight

        QsMenuOpener {
            id: menuProc
            menu: itemDelegate.modelData ? itemDelegate.modelData.menu : null
                }

            Column {
                id:menuColumn       
                spacing: 0
                property real maxTextWidth: 1
                Repeater {
                    model:menuProc.children

                    delegate: Rectangle {
                        id:menuItem

                        required property QsMenuEntry modelData
                      

                        width: 220 
                        height: menuItem.modelData.isSeparator ? 8 : 24

                        color: "green"

                        Text {
                            text: menuItem.modelData.text 
                            anchors.centerIn:parent
                        }

                        Rectangle {
                            visible: menuItem.modelData.isSeparator ? true : false
                            color: " grey"
                            width: parent.width * 0.8
                            height: 1
                            anchors.centerIn: parent
                            }
                        }
                    Component.onCompleted: {
                        if (width > menuColumn.maxTextWidth)
                            menuColumn.maxTextWidth = implicitWidth
                        }
                    }
                }
            }
	    }
    }
}

