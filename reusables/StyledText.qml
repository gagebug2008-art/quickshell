import QtQuick
import qs.config

Text {
    id: root

    property string surfaceRole: "default"
    property bool muted: false

    // Iterates up the parent tree safely to find the inherited surfaceRole
    readonly property string role: {
        if (surfaceRole !== "") return surfaceRole
        let p = parent
        while (p) {
            if (p.surfaceRole !== undefined && p.surfaceRole !== "") {
                return p.surfaceRole
            }
            p = p.parent
        }
        return "surface"
    }

    // Direct property lookups enable full reactive bindings with Config
    readonly property color base: {
        switch (role) {
            case "background":         return Config.backgroundText
            case "surfaceVariant":     return Config.surfaceVariantText
            case "primary":            return Config.primaryText
            case "primaryContainer":   return Config.primaryContainerText
            case "secondary":          return Config.secondaryText
            case "secondaryContainer": return Config.secondaryContainerText
            case "tertiary":           return Config.tertiaryText
            case "tertiaryContainer":  return Config.tertiaryContainerText
            case "error":              return Config.errorText
            case "errorContainer":     return Config.errorContainerText
            case "inverse":            return Config.inverseSurfaceText
            default:                   return Config.surfaceText
        }
    }

    color: muted ? Qt.alpha(base, Config.textOpacityMuted) : base
    antialiasing: true
    renderType: Text.NativeRendering

    font {
        kerning: true
        pixelSize: Config.textSize
        family: Config.ftFam
        weight: Config.ftWt
    }
}
