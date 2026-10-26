import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    width: 320
    height: 400

    property string tempDir: "/tmp/clip-previews"

    ListModel {
        id: clipboardHistoryModel
    }

    // --- Fetch history ---
    Process {
        id: listProc
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                clipboardHistoryModel.clear()
                const lines = text.split("\n").filter(l => l.length > 0)

                for (const line of lines) {
                    const tabIndex = line.indexOf("\t")
                    if (tabIndex === -1) continue

                    const id = line.substring(0, tabIndex)
                    const preview = line.substring(tabIndex + 1)

                    // crude heuristic until we confirm real image-line format
                    const looksLikeImage = /binary data|\ufffd|[\x00-\x08\x0E-\x1F]/.test(preview)

                    clipboardHistoryModel.append({
                        entryId: id,
                        raw: preview,
                        isImage: looksLikeImage,
                        decodedPath: ""
                    })
                }
            }
        }
    }

    function refresh() {
        listProc.running = true
    }

    Component.onCompleted: refresh()

    // --- Decode a specific image entry to a temp file for preview ---
    function decodeImage(entryId, index) {
        const decodeProc = decodeComponent.createObject(root, { entryId: entryId, targetIndex: index })
        decodeProc.running = true
    }

    Component {
        id: decodeComponent
        Process {
            property string entryId: ""
            property int targetIndex: -1
            command: ["bash", "-c",
                `mkdir -p ${root.tempDir} && cliphist decode ${entryId} > ${root.tempDir}/${entryId}.png`]
            onExited: (exitCode) => {
                if (exitCode === 0 && targetIndex >= 0 && targetIndex < clipboardHistoryModel.count) {
                    clipboardHistoryModel.setProperty(targetIndex, "decodedPath", `${root.tempDir}/${entryId}.png`)
                }
                destroy()
            }
        }
    }

    // --- Restore an entry to the clipboard ---
    Process {
        id: restoreProc
    }

    function restoreEntry(entryId, isImage) {
    const typeFlag = isImage ? "--type image/png" : ""
    restoreProc.command = ["bash", "-c", `cliphist decode ${entryId} | wl-copy ${typeFlag}`]
    restoreProc.running = true
    }

    // --- Delete an entry from history ---
    function deleteEntry(entryId, index) {
        const delProc = deleteComponent.createObject(root, { entryId: entryId })
        delProc.running = true
        clipboardHistoryModel.remove(index)
    }

    Component {
        id: deleteComponent
        Process {
            property string entryId: ""
            command: ["bash", "-c", `cliphist delete-query "${entryId}"`]
            onExited: destroy()
        }
    }
}