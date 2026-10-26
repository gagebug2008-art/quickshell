import QtQuick
import Qt.labs.folderlistmodel
import Quickshell

Scope {
	id: root

    property var    wallpapers:   []
    property string wallpaperDir: Quickshell.env("HOME") + "/Pictures/wallpapers"
    property var exts: ["png", "jpg", "jpeg"]
    
    required property string query 
    
    function reBuild() {
    if (folderModel.status === FolderListModel.Ready) return 
            const list = [];
            
           
            for (let i = 0; i < folderModel.count; i++)
               list.push(folderModel.get(i, "filePath")) 
               root.wallpapers = list 
          
            console.log(root.wallpapers)
    }
	property FolderListModel folderModel: FolderListModel {
        folder: "file://" + root.wallpaperDir
        nameFilters: root.exts.map(exts => "*" + root.query + "*." + exts)
        showDirs: false
        showFiles: true
        sortField: FolderListModel.Name

        //onStatusChanged: root.reBuild()
        onCountChanged: root.reBuild()
    }
}
