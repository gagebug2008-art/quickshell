pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../themes/Themes.js" as ThemesJs

Singleton {
   id: config

   // "matugenTheme" | "pywal" | "dracula" | "nord" | "gruvbox" | "catppuccinMocha" | "tokyoNight" | "rosePine" | "everforest" | "solarizedDark" | "oneDark" | "kanagawa"
   property string themeName: "pywal"

   property var matugenTheme: ({})
   property var pywalComponent: Qt.createComponent("../themes/Pywal.qml")
   property var pywalTheme: pywalComponent.status === Component.Ready ? pywalComponent.createObject(config) : null

   // our name: name in the matugen file (everything else keeps its name)
   readonly property var matugenNames: ({
      backgroundText: "onBackground",
      surfaceText: "onSurface",
      surfaceVariantText: "onSurfaceVariant",
      primaryText: "onPrimary",
      primaryContainerText: "onPrimaryContainer",
      secondaryText: "onSecondary",
      secondaryContainerText: "onSecondaryContainer",
      tertiaryText: "onTertiary",
      tertiaryContainerText: "onTertiaryContainer",
      errorText: "onError",
      errorContainerText: "onErrorContainer",
      inverseSurfaceText: "inverseOnSurface"
   })

      FileView {
      path: Quickshell.env("HOME") + "/.config/matugen/colors/MatugenTheme.qml"
      watchChanges: true
      onFileChanged: reload()
      onLoadFailed: error => console.log("matugen load failed:", error, path)
      onLoaded: {
         var out = {}
         var re = /property\s+color\s+(\w+)\s*:\s*"(#[0-9a-fA-F]{6,8})"/g
         var m
         while ((m = re.exec(text())) !== null) out[m[1]] = m[2]
         for (var ours in config.matugenNames)
            out[ours] = out[config.matugenNames[ours]]
         config.matugenTheme = out
         console.log("matugen loaded:", Object.keys(out).length, "roles, primaryContainer =", out.primaryContainer)
      }
   }

   readonly property var currentTheme: {
      if (themeName === "matugenTheme") return matugenTheme
      if (themeName === "pywal") return pywalTheme
      return ThemesJs.get(themeName)
   }

   readonly property color background:             Qt.alpha(currentTheme.background, 1)
   readonly property color backgroundText:         currentTheme.backgroundText
   readonly property color surface:                currentTheme.surface
   readonly property color surfaceText:            currentTheme.surfaceText
   readonly property color surfaceVariant:         currentTheme.surfaceVariant
   readonly property color surfaceVariantText:     currentTheme.surfaceVariantText

   readonly property color primary:                currentTheme.primary
   readonly property color primaryText:            currentTheme.primaryText
   readonly property color primaryContainer:       currentTheme.primaryContainer
   readonly property color primaryContainerText:   currentTheme.primaryContainerText

   readonly property color secondary:              currentTheme.secondary
   readonly property color secondaryText:          currentTheme.secondaryText
   readonly property color secondaryContainer:     currentTheme.secondaryContainer
   readonly property color secondaryContainerText: currentTheme.secondaryContainerText

   readonly property color tertiary:               currentTheme.tertiary
   readonly property color tertiaryText:           currentTheme.tertiaryText
   readonly property color tertiaryContainer:      currentTheme.tertiaryContainer
   readonly property color tertiaryContainerText:  currentTheme.tertiaryContainerText

   readonly property color error:                  currentTheme.error
   readonly property color errorText:              currentTheme.errorText
   readonly property color errorContainer:         currentTheme.errorContainer
   readonly property color errorContainerText:     currentTheme.errorContainerText

   readonly property color outline:                currentTheme.outline
   readonly property color outlineVariant:         currentTheme.outlineVariant
   readonly property color shadow:                 currentTheme.shadow
   readonly property color scrim:                  currentTheme.scrim

   readonly property color inverseSurface:         currentTheme.inverseSurface
   readonly property color inverseSurfaceText:     currentTheme.inverseSurfaceText
   readonly property color inversePrimary:         currentTheme.inversePrimary

   readonly property color surfaceDim:              currentTheme.surfaceDim
   readonly property color surfaceBright:           currentTheme.surfaceBright
   readonly property color surfaceContainerLowest:  currentTheme.surfaceContainerLowest
   readonly property color surfaceContainerLow:     currentTheme.surfaceContainerLow
   readonly property color surfaceContainer:        currentTheme.surfaceContainer
   readonly property color surfaceContainerHigh:    currentTheme.surfaceContainerHigh
   readonly property color surfaceContainerHighest: currentTheme.surfaceContainerHighest

   readonly property color bg: background
   readonly property color fg: backgroundText
   readonly property color tt: primary
   readonly property color t1: surfaceText
   readonly property color t2: surfaceVariantText
   readonly property color button: primary
   readonly property color border: outline
   readonly property color border2: outline
   readonly property color borderSoft: outlineVariant

   readonly property color bgColor: background
   readonly property color bgText: backgroundText
   readonly property color panelColor: surface
   readonly property color panelText: surfaceText
   readonly property color panelAlt: surfaceVariant
   readonly property color panelAltText: surfaceVariantText
   readonly property color panelLowest: surfaceContainerLowest
   readonly property color panelLow: surfaceContainerLow
   readonly property color panel: surfaceContainer
   readonly property color panelHigh: surfaceContainerHigh
   readonly property color panelHighest: surfaceContainerHighest

   readonly property color accent: primary
   readonly property color accentText: primaryText
   readonly property color accentSoft: primaryContainer
   readonly property color accentSoftText: primaryContainerText
   readonly property color accent2: secondary
   readonly property color accent2Text: secondaryText
   readonly property color accent2Soft: secondaryContainer
   readonly property color accent2SoftText: secondaryContainerText
   readonly property color accent3: tertiary
   readonly property color accent3Text: tertiaryText
   readonly property color accent3Soft: tertiaryContainer
   readonly property color accent3SoftText: tertiaryContainerText
   readonly property color danger: error
   readonly property color dangerText: errorText
   readonly property color dangerSoft: errorContainer
   readonly property color dangerSoftText: errorContainerText

   property real scale: 1.0

   function sc(v) {
      return Math.round(v * scale)
   }

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

   readonly property int radius:        sc(radiusBase)
   readonly property int radiusSm:      sc(radiusSmBase)
   readonly property int radiusLg:      sc(radiusLgBase)
   readonly property int borderW:       Math.max(1, sc(borderWBase))
   readonly property int spacing:       sc(spacingBase)
   readonly property int spacingSm:     sc(spacingSmBase)
   readonly property int spacingLg:     sc(spacingLgBase)
   readonly property int margin:        sc(marginBase)
   readonly property int barHeight:     sc(barHeightBase)
   readonly property int exclusiveZone: sc(exclusiveZoneBase)
   readonly property int iconSize:      sc(iconSizeBase)
   readonly property int iconSizeSm:    sc(iconSizeSmBase)

   readonly property int textSizeXs: sc(textSizeXsBase)
   readonly property int textSizeSm: sc(textSizeSmBase)
   readonly property int textSize:   sc(textSizeBase)
   readonly property int textSizeMd: sc(textSizeMdBase)
   readonly property int textSizeLg: sc(textSizeLgBase)

   readonly property string iconDir: Quickshell.shellDir + "/imgs/"

   property bool barFloat: true 
   property bool barReact: barFloat

   function runMatugen(imagePath) {
      if (!imagePath) return
      Quickshell.execDetached(["matugen", "image", imagePath.replace(/^file:\/\//, "")])
   }

   function runPywal(imagePath) {
      if (!imagePath) return
      Quickshell.execDetached(["wal", "-i", imagePath.replace(/^file:\/\//, "")])
   }
}
