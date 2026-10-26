//@ pragma UseQApplication
//@ pragma IconTheme Colloid-Purple
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.bar
import qs.services
import qs.config
import qs.dock
import qs.launcher
import qs.bottom
import qs.wallpaper
import qs.menu
ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        Top {}
    }
        //Test {}
    
        //WallpaperBackend {}
    Notifications {}
    //RealDock {}
    ColorsSomething {}
    //FloatBubbels {}
    Bottom {}
    //WallHavenApi {id:hvn}
    //TestFocusShape{}
    //Mask {}
}
