pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    // ─── Raw screen list ─────────────────────────────────────
    readonly property var screens: Quickshell.screens

    // ─── Primary screen ───────────────────────────────────────
    readonly property ShellScreen primaryScreen: screens.find(s => s.primary) ?? screens[0] ?? null

    // ─── Per-screen derived data ──────────────────────────────
    function scaleFor(screen) {
        return screen ? screen.devicePixelRatio : 1
    }

    function logicalWidth(screen) {
        return screen ? screen.width / scaleFor(screen) : 0
    }
    function logicalHeight(screen) {
        return screen ? screen.height / scaleFor(screen) : 0
    }

    // ─── Aspect ratio helpers ─────────────────────────────────
    function aspectRatio(screen) {
        return screen && screen.height > 0 ? screen.width / screen.height : 0
    }

    // Simplified ratio like "16:9" or "21:9"
    function aspectRatioLabel(screen) {
        if (!screen || screen.height === 0) return ""
        function gcd(a, b) { return b === 0 ? a : gcd(b, a % b) }
        const d = gcd(screen.width, screen.height)
        return (screen.width / d) + ":" + (screen.height / d)
    }

    // Given a target width, what height keeps this screen's aspect ratio?
    function heightForWidth(screen, width) {
        const ratio = aspectRatio(screen)
        return ratio > 0 ? width / ratio : 0
    }
    // Given a target height, what width keeps this screen's aspect ratio?
    function widthForHeight(screen, height) {
        return height * aspectRatio(screen)
    }

    function isPortrait(screen) {
        return screen && screen.height > screen.width
    }
    function isUltrawide(screen) {
        return aspectRatio(screen) >= 2.0 // e.g. 21:9 ≈ 2.33
    }

    // ─── Virtual desktop bounds (all screens combined) ────────
    readonly property rect virtualGeometry: {
        if (screens.length === 0) return Qt.rect(0, 0, 0, 0)
        let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity
        for (const s of screens) {
            minX = Math.min(minX, s.x)
            minY = Math.min(minY, s.y)
            maxX = Math.max(maxX, s.x + s.width)
            maxY = Math.max(maxY, s.y + s.height)
        }
        return Qt.rect(minX, minY, maxX - minX, maxY - minY)
    }

    // ─── Lookup helpers ────────────────────────────────────────
    function screenAt(x, y) {
        return screens.find(s => x >= s.x && x < s.x + s.width && y >= s.y && y < s.y + s.height) ?? null
    }
    function screenByName(name) {
        return screens.find(s => s.name === name) ?? null
    }

    // ─── Lifecycle ─────────────────────────────────────────────
    onScreensChanged: {
        console.log("Screen config changed, now:", screens.map(s => s.name).join(", "))
    }
}
