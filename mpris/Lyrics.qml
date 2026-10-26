// Lyrics.qml
pragma Singleton
import Quickshell
import QtQuick

Singleton {
   id: root

   property var lines: []          // [{ time: seconds, text: "..." }]
   property int index: -1
   property bool loading: false
   readonly property bool hasLyrics: lines.length > 0
   readonly property string currentLine: index >= 0 ? lines[index].text : ""

   property int requestId: 0

   // title, artist and length often update at slightly different moments,
   // so wait a beat before fetching
   readonly property string trackKey: Player.hasPlayer
      ? Player.trackTitle + "|" + Player.trackArtist + "|" + Math.round(Player.length)
      : ""
   onTrackKeyChanged: debounce.restart()

   Timer {
      id: debounce
      interval: 400
      onTriggered: root.fetchLyrics()
   }

   function fetchLyrics() {
      lines = []
      index = -1
      if (!Player.hasPlayer || Player.trackArtist === "" || Player.trackTitle === "")
         return

      const id = ++requestId
      loading = true

      const url = "https://lrclib.net/api/search"
         + "?track_name=" + encodeURIComponent(Player.trackTitle)
         + "&artist_name=" + encodeURIComponent(Player.trackArtist)

      const xhr = new XMLHttpRequest()
      xhr.onreadystatechange = function() {
         if (xhr.readyState !== XMLHttpRequest.DONE) return
         if (id !== root.requestId) return   // a newer track replaced this request
         root.loading = false
         if (xhr.status !== 200) return

         try {
            root.applyResults(JSON.parse(xhr.responseText))
         } catch (e) {
            console.log("lrclib parse error:", e)
         }
      }
      xhr.open("GET", url)
      xhr.send()
   }

   function applyResults(results) {
      // keep results that have synced lyrics, then pick the closest duration match
      let best = null
      let bestDiff = Infinity
      for (const r of results) {
         if (!r.syncedLyrics) continue
         const diff = Math.abs((r.duration ?? 0) - Player.length)
         if (diff < bestDiff) {
            best = r
            bestDiff = diff
         }
      }
      if (best) {
         lines = parseLrc(best.syncedLyrics)
         updateIndex()
      }
   }

   function parseLrc(text) {
      const out = []
      for (const raw of text.split("\n")) {
         const m = raw.match(/^\[(\d+):(\d+(?:\.\d+)?)\]\s*(.*)$/)
         if (!m) continue
         out.push({ time: parseInt(m[1]) * 60 + parseFloat(m[2]), text: m[3] })
      }
      return out
   }

   function updateIndex() {
      if (lines.length === 0) { index = -1; return }
      const pos = Player.position
      let i = -1
      for (let n = 0; n < lines.length; n++) {
         if (lines[n].time <= pos) i = n
         else break
      }
      if (i !== index) index = i
   }

   Connections {
      target: Player
      function onPositionChanged() { root.updateIndex() }
   }
}
