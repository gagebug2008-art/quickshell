pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: styleConfig

    // ── Scale & Math ───────────────────────────────────────────
    property real scale: 1.0

    function sc(v) {
        return Math.round(v * scale)
    }

    // ── Base Layout Metrics (Unscaled) ─────────────────────────
    property int radiusBase: 9
    property int radiusSmBase: 4
    property int radiusLgBase: 10
    property int borderWBase: 1
    property int spacingBase: 6
    property int spacingSmBase: 3
    property int spacingLgBase: 12
    property int marginBase: 8
    property int barHeightBase: 32
    property int exclusiveZoneBase: 34
    property int iconSizeBase: 16
    property int iconSizeSmBase: 12

    // ── Scaled Layout Metrics ──────────────────────────────────
    readonly property int radius:        sc(radiusBase)
    readonly property int radiusSm:      sc(radiusSmBase)
    readonly property int radiusLg:      sc(radiusLgBase)
    readonly property int borderW:       Math.max(1, sc(borderWBase))
    readonly property int spacing:      sc(spacingBase)
    readonly property int spacingSm:    sc(spacingSmBase)
    readonly property int spacingLg:    sc(spacingLgBase)
    readonly property int margin:       sc(marginBase)
    readonly property int barHeight:    sc(barHeightBase)
    readonly property int exclusiveZone: sc(exclusiveZoneBase)
    readonly property int iconSize:     sc(iconSizeBase)
    readonly property int iconSizeSm:   sc(iconSizeSmBase)

    // ── Typography ─────────────────────────────────────────────
    property string ftFam: "JetBrainsMono Nerd Font"

    property int ftWt: 400
    property int ftWtMedium: 500
    property int ftWtDemiBold: 600
    property int ftWtBold: 700

    property int textSizeXsBase: 10
    property int textSizeSmBase: 11
    property int textSizeBase: 13
    property int textSizeMdBase: 14
    property int textSizeLgBase: 16

    property real textOpacityMuted: 0.7
    property real textOpacityDisabled: 0.4

    // Scaled Font Sizes
    readonly property int textSizeXs: sc(textSizeXsBase)
    readonly property int textSizeSm: sc(textSizeSmBase)
    readonly property int textSize:   sc(textSizeBase)
    readonly property int textSizeMd: sc(textSizeMdBase)
    readonly property int textSizeLg: sc(textSizeLgBase)

    // ── Paths & Shell States ───────────────────────────────────
    readonly property string iconDir: Quickshell.shellDir + "/imgs/"
    property bool barFloat: true
    property bool barReact: barFloat
}
