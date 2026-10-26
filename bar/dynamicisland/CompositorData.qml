pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
    id: root
    property int windowCount: 0
    property alias tags: tagsModel

    signal activeTagChanged()

    ListModel {
        id: tagsModel
    }

    Process {
        id: shellProcess
        command: ["mmsg", "watch", "all-tags"]
        running: true
        stdout: SplitParser {
            onRead: function(line) {
                var trimmed = line.trim()
                if (trimmed === "") return

                var data
                try {
                    data = JSON.parse(trimmed)
                } catch (err) {
                    console.log("CompositorData: failed to parse line:", err, trimmed)
                    return
                }

                if (!data.all_tags || !data.all_tags[0] || !data.all_tags[0].tags) return
                var tags = data.all_tags[0].tags

                for (var i = 0; i < tags.length; i++) {
                    var tag = tags[i]
                    var index = tag.index - 1
                    if (index < 0) continue

                    var focused = tag.is_active
                    var hasWindows = tag.client_count > 0
                    var urgent = tag.is_urgent

                    while (tagsModel.count <= index) {
                        tagsModel.append({ focused: false, hasWindows: false, urgent: false })
                    }

                    var existing = tagsModel.get(index)
                    var focusChanged = existing.focused !== focused

                    if (focusChanged) tagsModel.setProperty(index, "focused", focused)
                    if (existing.hasWindows !== hasWindows) tagsModel.setProperty(index, "hasWindows", hasWindows)
                    if (existing.urgent !== urgent) tagsModel.setProperty(index, "urgent", urgent)

                    if (focused) {
                        root.windowCount = tag.client_count
                        if (focusChanged) root.activeTagChanged()
                    }
                }
            }
        }
    }
}