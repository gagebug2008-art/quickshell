import QtQuick
import qs.wal as Wal
import "Themes.js" as Themes

QtObject {
    id: root

    readonly property color color0:  Wal.Colors.color(0)
    readonly property color color1:  Wal.Colors.color(1)
    readonly property color color2:  Wal.Colors.color(2)
    readonly property color color3:  Wal.Colors.color(3)
    readonly property color color4:  Wal.Colors.color(4)
    readonly property color color5:  Wal.Colors.color(5)
    readonly property color color6:  Wal.Colors.color(6)
    readonly property color color7:  Wal.Colors.color(7)
    readonly property color color8:  Wal.Colors.color(8)
    readonly property color color9:  Wal.Colors.color(9)
    readonly property color color10: Wal.Colors.color(10)
    readonly property color color11: Wal.Colors.color(11)
    readonly property color color12: Wal.Colors.color(12)
    readonly property color color13: Wal.Colors.color(13)
    readonly property color color14: Wal.Colors.color(14)
    readonly property color color15: Wal.Colors.color(15)
    readonly property color ansiBackground: color0
    readonly property color ansiForeground: color15

    readonly property var _fit: Themes.fromAnsi16({
        color0: color0, color1: color1, color2: color2, color3: color3,
        color4: color4, color5: color5, color6: color6, color7: color7,
        color8: color8, color9: color9, color10: color10, color11: color11,
        color12: color12, color13: color13, color14: color14, color15: color15,
        background: ansiBackground, foreground: ansiForeground
    })

    readonly property color background:           _fit.background
    readonly property color backgroundText:        _fit.backgroundText
    readonly property color surface:               _fit.surface
    readonly property color surfaceText:           _fit.surfaceText
    readonly property color surfaceVariant:        _fit.surfaceVariant
    readonly property color surfaceVariantText:    _fit.surfaceVariantText

    readonly property color primary:               _fit.primary
    readonly property color primaryText:           _fit.primaryText
    readonly property color primaryContainer:      _fit.primaryContainer
    readonly property color primaryContainerText:  _fit.primaryContainerText

    readonly property color secondary:               _fit.secondary
    readonly property color secondaryText:           _fit.secondaryText
    readonly property color secondaryContainer:      _fit.secondaryContainer
    readonly property color secondaryContainerText:  _fit.secondaryContainerText

    readonly property color tertiary:               _fit.tertiary
    readonly property color tertiaryText:           _fit.tertiaryText
    readonly property color tertiaryContainer:      _fit.tertiaryContainer
    readonly property color tertiaryContainerText:  _fit.tertiaryContainerText

    readonly property color error:               _fit.error
    readonly property color errorText:           _fit.errorText
    readonly property color errorContainer:      _fit.errorContainer
    readonly property color errorContainerText:  _fit.errorContainerText

    readonly property color outline:         _fit.outline
    readonly property color outlineVariant:  _fit.outlineVariant
    readonly property color shadow:          _fit.shadow
    readonly property color scrim:           _fit.scrim

    readonly property color inverseSurface:      _fit.inverseSurface
    readonly property color inverseSurfaceText:  _fit.inverseSurfaceText
    readonly property color inversePrimary:      _fit.inversePrimary

    readonly property color surfaceDim:               _fit.surfaceDim
    readonly property color surfaceBright:            _fit.surfaceBright
    readonly property color surfaceContainerLowest:   _fit.surfaceContainerLowest
    readonly property color surfaceContainerLow:      _fit.surfaceContainerLow
    readonly property color surfaceContainer:         _fit.surfaceContainer
    readonly property color surfaceContainerHigh:     _fit.surfaceContainerHigh
    readonly property color surfaceContainerHighest:  _fit.surfaceContainerHighest

    readonly property color bg:      _fit.bg
    readonly property color fg:      _fit.fg
    readonly property color tt:      _fit.tt
    readonly property color t1:      _fit.t1
    readonly property color t2:      _fit.t2
    readonly property color button:  _fit.button
    readonly property color border:  _fit.border
}
