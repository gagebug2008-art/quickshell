import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    enum PamState {
        None,
        Error,
        MaxTries,
        Failed
    }

    required property WlSessionLock lock

    readonly property alias passwd: passwd
    readonly property alias fprint: fprint
    readonly property alias howdy: howdy

    property string lockMessage
    property int state
    property string buffer

    signal flashMsg








}
