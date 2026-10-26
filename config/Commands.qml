pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: commands

    // Helper process to execute CLI commands asynchronously
    Process {
        id: runner
    }

    function exec(cmd) {
        runner.command = ["sh", "-c", cmd]
        runner.running = true
    }

    // ── Matugen Generator ──
    function runMatugen(imagePath) {
        if (!imagePath) return;
        exec("matugen image \"" + imagePath + "\" && quickshell ipc reload")
    }

    // ── Pywal Generator ──
    function runPywal(imagePath) {
        if (!imagePath) return;
        exec("wal -i \"" + imagePath + "\" -n -q && quickshell ipc reload")
    } 
}
