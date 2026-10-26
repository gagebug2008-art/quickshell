
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    // Player selection
    property var preferredPlayer: null

    readonly property var players: Mpris.players.values.filter(
        p => p.trackTitle !== ""
    )

    readonly property var activePlayer: {
        if (preferredPlayer && players.includes(preferredPlayer))
            return preferredPlayer

        const playing = players.find(
            p => p.playbackState === MprisPlaybackState.Playing
        )
        if (playing) return playing

        const paused = players.find(
            p => p.playbackState === MprisPlaybackState.Paused
        )
        if (paused) return paused

        return players.length > 0 ? players[0] : null
    }

    function selectPlayer(player) {
        if (player && players.includes(player))
            preferredPlayer = player
    }

    function clearPreferredPlayer() {
        preferredPlayer = null
    }

    // Derived state
    readonly property bool hasPlayer: activePlayer !== null

    readonly property bool isStopped:
        !hasPlayer ||
        activePlayer.playbackState === MprisPlaybackState.Stopped

    readonly property bool hasMedia:
        hasPlayer && !isStopped && activePlayer.trackTitle !== ""

    readonly property bool isPlaying:
        hasPlayer &&
        activePlayer.playbackState === MprisPlaybackState.Playing

    readonly property bool isPaused:
        hasPlayer &&
        activePlayer.playbackState === MprisPlaybackState.Paused

    readonly property string trackTitle:
        activePlayer?.trackTitle || "Nothing playing"

    readonly property string trackArtist:
        activePlayer?.trackArtist ?? ""

    readonly property string trackAlbum:
        activePlayer?.trackAlbum ?? ""

    readonly property string trackArtUrl:
        activePlayer?.trackArtUrl ?? ""

    readonly property real length:
        activePlayer?.length ?? 0

    readonly property bool canSeek:
        activePlayer?.canSeek ?? false

    readonly property bool canControl:
        activePlayer?.canControl ?? false

    readonly property bool canGoNext:
        activePlayer?.canGoNext ?? false

    readonly property bool canGoPrevious:
        activePlayer?.canGoPrevious ?? false

    readonly property bool canTogglePlaying:
        activePlayer?.canTogglePlaying ?? false

    readonly property real volume:
        activePlayer?.volume ?? -1

    readonly property bool hasVolume: volume >= 0

    readonly property int loopState:
        activePlayer?.loopState ?? MprisLoopState.None

    readonly property bool shuffle:
        activePlayer?.shuffle ?? false

    readonly property bool canLoop:
        activePlayer?.canLoop ?? false

    readonly property bool canShuffle:
        activePlayer?.canShuffle ?? false

    // Playback position
    property real position: 0

    readonly property real progress:
        length > 0
            ? Math.max(0, Math.min(1, position / length))
            : 0

    function syncPosition() {
        const p = activePlayer

        if (!p) {
            position = 0
            return
        }

        const current = p.position
        position = Math.max(
            0,
            Math.min(length > 0 ? length : current, current)
        )
    }

    // Poll while playing to keep the slider moving.
    Timer {
        interval: 250
        repeat: true
        running: root.isPlaying
        onTriggered: root.syncPosition()
    }

    onActivePlayerChanged: syncPosition()

    Connections {
        target: root.activePlayer
        ignoreUnknownSignals: true

        function onPlaybackStateChanged() {
            root.syncPosition()
        }

        function onTrackTitleChanged() {
            root.syncPosition()
        }

        function onPostTrackChanged() {
            root.syncPosition()
        }
    }

    // Playback actions
    function togglePlaying() {
        if (canTogglePlaying)
            activePlayer.togglePlaying()
    }

    function play() {
        if (activePlayer?.canPlay)
            activePlayer.play()
    }

    function pause() {
        if (activePlayer?.canPause)
            activePlayer.pause()
    }

    function next() {
        if (canGoNext)
            activePlayer.next()
    }

    function previous() {
        if (canGoPrevious)
            activePlayer.previous()
    }

    // Seek to an absolute position in seconds.
    function seek(positionSeconds) {
    const p = activePlayer
    if (!p || !p.canSeek || length <= 0)
        return

    const target = Math.max(0, Math.min(positionSeconds, length))
    p.seek(target - p.position)
    position = target
}

    // Slider value is normalized from 0 to 1.
    function seekByRatio(ratio) {
        if (length <= 0)
            return

        seek(Math.max(0, Math.min(1, ratio)) * length)
    }

    // Volume
    function setVolume(v) {
        const p = activePlayer

        if (!p || !p.canControl || !p.volumeSupported)
            return

        p.volume = Math.max(0, Math.min(1, v))
    }

    // Shuffle
    function toggleShuffle() {
        const p = activePlayer

        if (p && p.canShuffle)
            p.shuffle = !p.shuffle
    }

    // Loop
    function cycleLoop() {
        const p = activePlayer

        if (!p || !p.canLoop)
            return

        switch (p.loopState) {
        case MprisLoopState.None:
            p.loopState = MprisLoopState.Track
            break

        case MprisLoopState.Track:
            p.loopState = MprisLoopState.Playlist
            break

        default:
            p.loopState = MprisLoopState.None
            break
        }
    }

    // Time formatting
    function formatTime(seconds) {
        if (!Number.isFinite(seconds) || seconds < 0)
            return "0:00"

        const total = Math.floor(seconds)
        const minutes = Math.floor(total / 60)
        const remaining = total % 60

        return minutes + ":" +
            (remaining < 10 ? "0" : "") + remaining
    }
}
