pragma Singleton

import QtQuick
import Quickshell
import "../themes" as Themes
import "../themes/Themes.js" as ThemesJs

Singleton {
    id: themeConfig

    // Theme Selector
    // Options: "matugen" | "pywal" | "dracula" | "nord" | "gruvbox" | "catppuccinMocha" | "tokyoNight" | "rosePine" | "everforest" | "solarizedDark" | "oneDark" | "kanagawa"
    property string activeTheme: "pywal"

    // ── Safe Dynamic Loaders ──
    property var matugenComponent: Qt.createComponent("../themes/Matugen.qml")
    property var pywalComponent:   Qt.createComponent("../themes/Pywal.qml")

    property var matugenTheme: matugenComponent.status === Component.Ready ? matugenComponent.createObject(themeConfig) : null
    property var pywalTheme:   pywalComponent.status   === Component.Ready ? pywalComponent.createObject(themeConfig)   : null

    // Active Theme Resolver
    readonly property var currentTheme: {
        if (activeTheme === "matugen" && matugenTheme) return matugenTheme;
        if (activeTheme === "pywal"   && pywalTheme)   return pywalTheme;
        
        var t = ThemesJs.get(activeTheme);
        if (t) return t;

        if (pywalTheme) return pywalTheme;
        if (matugenTheme) return matugenTheme;
        return ThemesJs.get("dracula");
    }

    // ── Material 3 Color Roles ──
    readonly property color background:           currentTheme.background           ?? "#000000"
    readonly property color backgroundText:       currentTheme.backgroundText       ?? "#ffffff"
    readonly property color surface:              currentTheme.surface              ?? "#121212"
    readonly property color surfaceText:          currentTheme.surfaceText          ?? "#ffffff"
    readonly property color surfaceVariant:       currentTheme.surfaceVariant       ?? "#272727"
    readonly property color surfaceVariantText:   currentTheme.surfaceVariantText   ?? "#ffffff"

    readonly property color primary:              currentTheme.primary              ?? "#bb86fc"
    readonly property color primaryText:          currentTheme.primaryText          ?? "#000000"
    readonly property color primaryContainer:     currentTheme.primaryContainer     ?? "#3700b3"
    readonly property color primaryContainerText: currentTheme.primaryContainerText ?? "#ffffff"

    readonly property color secondary:             currentTheme.secondary             ?? "#03dac6"
    readonly property color secondaryText:         currentTheme.secondaryText         ?? "#000000"
    readonly property color secondaryContainer:    currentTheme.secondaryContainer    ?? "#018786"
    readonly property color secondaryContainerText: currentTheme.secondaryContainerText ?? "#ffffff"

    readonly property color tertiary:              currentTheme.tertiary              ?? "#03dac6"
    readonly property color tertiaryText:          currentTheme.tertiaryText          ?? "#000000"
    readonly property color tertiaryContainer:     currentTheme.tertiaryContainer     ?? "#018786"
    readonly property color tertiaryContainerText: currentTheme.tertiaryContainerText ?? "#ffffff"

    readonly property color error:               currentTheme.error               ?? "#cf6679"
    readonly property color errorText:           currentTheme.errorText           ?? "#000000"
    readonly property color errorContainer:      currentTheme.errorContainer      ?? "#b00020"
    readonly property color errorContainerText:  currentTheme.errorContainerText  ?? "#ffffff"

    readonly property color outline:         currentTheme.outline        ?? "#ffffff"
    readonly property color outlineVariant:  currentTheme.outlineVariant ?? "#888888"
    readonly property color shadow:          currentTheme.shadow         ?? "#000000"
    readonly property color scrim:           currentTheme.scrim          ?? "#000000"

    readonly property color inverseSurface:     currentTheme.inverseSurface     ?? "#ffffff"
    readonly property color inverseSurfaceText: currentTheme.inverseSurfaceText ?? "#000000"
    readonly property color inversePrimary:     currentTheme.inversePrimary     ?? "#3700b3"

    readonly property color surfaceDim:              currentTheme.surfaceDim              ?? "#111111"
    readonly property color surfaceBright:           currentTheme.surfaceBright           ?? "#333333"
    readonly property color surfaceContainerLowest:  currentTheme.surfaceContainerLowest  ?? "#0f0f0f"
    readonly property color surfaceContainerLow:     currentTheme.surfaceContainerLow     ?? "#1a1a1a"
    readonly property color surfaceContainer:        currentTheme.surfaceContainer        ?? "#222222"
    readonly property color surfaceContainerHigh:    currentTheme.surfaceContainerHigh    ?? "#2a2a2a"
    readonly property color surfaceContainerHighest: currentTheme.surfaceContainerHighest ?? "#343434"

    // ── Aliases ──
    readonly property color bg:     background
    readonly property color fg:     backgroundText
    readonly property color tt:     primary
    readonly property color t1:     surfaceText
    readonly property color t2:     surfaceVariantText
    readonly property color button: primary
    readonly property color border: outline

    readonly property color bgColor:        background
    readonly property color bgText:         backgroundText
    readonly property color panelColor:     surface
    readonly property color panelText:      surfaceText
    readonly property color panelAlt:       surfaceVariant
    readonly property color panelAltText:   surfaceVariantText

    readonly property color accent:         primary
    readonly property color accentText:     primaryText
    readonly property color accentSoft:     primaryContainer
    readonly property color accentSoftText: primaryContainerText

    readonly property color accent2:         secondary
    readonly property color accent2Text:     secondaryText
    readonly property color accent2Soft:     secondaryContainer
    readonly property color accent2SoftText: secondaryContainerText

    readonly property color accent3:         tertiary
    readonly property color accent3Text:     tertiaryText
    readonly property color accent3Soft:     tertiaryContainer
    readonly property color accent3SoftText: tertiaryContainerText

    readonly property color danger:         error
    readonly property color dangerText:     errorText
    readonly property color dangerSoft:     errorContainer
    readonly property color dangerSoftText: errorContainerText

    readonly property color border2:    outline
    readonly property color borderSoft: outlineVariant

    readonly property color panelLowest:  surfaceContainerLowest
    readonly property color panelLow:     surfaceContainerLow
    readonly property color panel:        surfaceContainer
    readonly property color panelHigh:    surfaceContainerHigh
    readonly property color panelHighest: surfaceContainerHighest
}
