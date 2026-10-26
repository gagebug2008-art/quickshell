import QtQuick
import Quickshell
import Quickshell.Io
import qs.wal as Wal

    Item {
    id:root
    property string themeChangerPath: ""

    Process {
      id: walProc
      command: ["/home/gage_miller/.config/quickshell/scripts/wal_stream.py"]
      stdout: SplitParser {
        property var lines: []
        property var colorMap: ({})

        onRead: function(line) {
          var trimmed = line.trim()
          if (trimmed === "") return

          // Check if this is a color definition
          if (trimmed.startsWith("color")) {
            var parts = trimmed.split("=")
            if (parts.length === 2) {
              var colorIndex = parts[0]
              var colorValue = parts[1]
              colorMap[colorIndex] = colorValue
            }
          }
          // Check if this is the theme changer path
          else if (trimmed.startsWith("themeChangerPath=")) {
            var pathParts = trimmed.split("=")
            if (pathParts.length === 2) {
              var path = pathParts[1]
              console.log("Found themeChangerPath:", path)
              root.themeChangerPath = path
            }
          }

          // Count how many color entries we have (color0 through color15)
          var colorCount = 0
          for (var i = 0; i <= 15; i++) {
            if (colorMap["color" + i] !== undefined) {
              colorCount++
            }
          }

          // When we have all 16 colors, update the Colors singleton
          if (colorCount === 16) {
            // Convert color map to array in order color0..color15
            var colorArray = []
            for (var i = 0; i <= 15; i++) {
              colorArray.push(colorMap["color" + i])
            }
            Wal.Colors.colorList = colorArray
            colorMap = {} // reset for next update
          }
        }
      }
      Component.onCompleted: running = true
    }
    }
