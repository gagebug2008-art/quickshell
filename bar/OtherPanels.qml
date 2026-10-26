pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell

import qs.wal as Wal

PanelWindow {
  id: root
  
  property int thickness: 2
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  mask: Region {}

  anchors {
    left: true
    top: true
    right: true
    bottom: true
  }

  Rectangle {
    id: left
    implicitWidth: thickness
    implicitHeight: QsWindow.window.height
    color: "green"
  }
  Rectangle {
    id: top
    implicitWidth: QsWindow.window.width
    implicitHeight: thickness
    color: "green"
  }
  Rectangle {
    id: right
    implicitWidth: thickness
    implicitHeight: QsWindow.window.height
    color: "green"
    anchors.right: parent.right
  }
  Rectangle {
    id: bottom
    implicitWidth: QsWindow.window.width
    implicitHeight: thickness
    color: "green"
    anchors.bottom: parent.bottom
  }  

  Scope {
    PanelWindow {
      anchors.left: true
      implicitWidth: left.implicitWidth
      implicitHeight: 0
      color: "green"
    }

    PanelWindow {
      anchors.top: true
      implicitWidth: 0
      implicitHeight: top.implicitHeight
      color: "green"
    }

    PanelWindow {
      anchors.right: true
      implicitWidth: right.implicitWidth
      implicitHeight: 0
      color: "green"
    }

    PanelWindow {
      anchors.bottom: true
      implicitWidth: 0
      implicitHeight: bottom.implicitHeight
      color: "green"
    }
  }
  
}
