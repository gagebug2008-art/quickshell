import QtQuick

Item {
	id: root
   width: 900
   height: 200
   property string query: "skull"
   WallpaperBackend { id: wlp; query: root.query }
   WallHavenApi { id: hvn; query: root.query }
   property bool wallhaven: true 
   property var currentModel: wallhaven ? hvn.thumbUrls : wlp.wallpapers
   ListView {
      anchors.fill: parent
      orientation: ListView.Horizontal
      spacing: 8
      model: root.currentModel

      delegate: Image {
         required property string modelData
         source: modelData
         height: ListView.view.height
         width: height * 1.71
         fillMode: Image.PreserveAspectCrop
         asynchronous: true
         sourceSize.height: height
      }
   }
}
