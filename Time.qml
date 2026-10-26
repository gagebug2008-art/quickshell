pragma Singleton

import Quickshell 
import QtQuick
import Quickshell.Io

    Singleton {
        id: root
        property string time
        
        Process {
            id: timefn
            
            command: ["date", "+%H:%M"]
            running: true

            stdout: StdioCollector {
                onStreamFinished: root.time = this.text
            }
        }
    Timer {
        interval: 1000
        running: true 
        repeat: true
        onTriggered: timefn.running = true 
    }
}
