import QtQuick

Text {
    id: root

    // File path or URL feed
    property string source: ""

    // Select which view/property to render as the main `text` output
    // Options: "baseName", "fileName", "formattedTitle", "extension"
    property string displayMode: "formattedTitle"

    // Raw filename with extension (e.g., "mountain_landscape.png")
    readonly property string fileName: {
        if (!source) return ""
        const cleanPath = source.replace(/\\/g, "/")
        const lastSlash = cleanPath.lastIndexOf("/")
        return lastSlash !== -1 ? cleanPath.substring(lastSlash + 1) : cleanPath
    }

    // Base filename without extension (e.g., "mountain_landscape")
    readonly property string baseName: {
        if (!fileName) return ""
        const lastDot = fileName.lastIndexOf(".")
        return (lastDot > 0) ? fileName.substring(0, lastDot) : fileName
    }

    // File extension in lowercase (e.g., "png")
    readonly property string extension: {
        if (!fileName) return ""
        const lastDot = fileName.lastIndexOf(".")
        return (lastDot > 0 && lastDot < fileName.length - 1)
            ? fileName.substring(lastDot + 1).toLowerCase()
            : ""
    }

    // Cleaned up, formatted title (e.g., "mountain_landscape" -> "Mountain Landscape")
    readonly property string formattedTitle: {
        if (!baseName) return ""
        const spaced = baseName.replace(/[-_]/g, " ")
        return spaced.replace(/\b\w/g, char => char.toUpperCase())
    }

    // Bind rendered text output directly based on displayMode
    text: {
        switch (displayMode) {
            case "fileName":       return fileName
            case "baseName":       return baseName
            case "extension":      return extension
            case "formattedTitle": 
            default:               return formattedTitle
        }
    }

    // Default styling (can be overridden easily anywhere)
    color: "white"
    font.pixelSize: 12
    elide: Text.ElideRight
}
