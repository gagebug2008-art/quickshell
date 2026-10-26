import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.config

ClippingRectangle {
   id: root
   height: 300
   width: 500
   radius: 5
   Image {
      anchors.fill: parent
      source: Player.hasPlayer && Player.trackArtUrl !== ""
         ? Player.trackArtUrl
         : Config.iconDir + "thumbnailplaceholder.png"
      fillMode: Image.PreserveAspectCrop
      asynchronous: true
      smooth: true
      mipmap: true
   }
}
