import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
   id: root

   readonly property int size: 56
   readonly property int gap: 8
   readonly property int edge: 16

   // id -> { w, h, slot, expanded, since }
   property var states: ({})
   // floating windows currently shown as bubbles: [{ id, appId, slot }]
   property var bubbles: []

   function niri(args) {
      Quickshell.execDetached(["niri", "msg", "action"].concat(args));
   }

   function slotY(slot) {
      return edge + 100 + slot * (size + gap);
   }

   function collapse(id, slot) {
      niri(["set-window-width", "--id", String(id), String(size)]);
      niri(["set-window-height", "--id", String(id), String(size)]);
      niri(["move-floating-window", "--id", String(id),
            "-x", String(edge), "-y", String(slotY(slot))]);
   }

   function expand(id) {
      let s = states[id];
      if (!s) return;
      let screenH = Quickshell.screens[0].height;
      let y = Math.max(edge, Math.min(slotY(s.slot), screenH - s.h - edge));

      niri(["set-window-width", "--id", String(id), String(s.w)]);
      niri(["set-window-height", "--id", String(id), String(s.h)]);
      niri(["move-floating-window", "--id", String(id),
            "-x", String(edge + size + gap), "-y", String(Math.round(y))]);
      niri(["focus-window", "--id", String(id)]);

      s.expanded = true;
      s.since = Date.now();
      sync(lastWins);
   }

   property var lastWins: []

   function freeSlot() {
      let used = Object.values(states).map(s => s.slot);
      let n = 0;
      while (used.indexOf(n) !== -1) n++;
      return n;
   }

   function sync(wins) {
      lastWins = wins;
      let floating = wins.filter(w => w.is_floating);
      let alive = {};
      for (let w of floating) alive[w.id] = true;

      // drop windows that closed or went back to tiling
      for (let id in states)
         if (!alive[id]) delete states[id];

      let list = [];
      for (let w of floating) {
         let s = states[w.id];

         if (!s) {
            // new floating window: remember its size, shrink it
            s = {
               w: w.layout.window_size[0],
               h: w.layout.window_size[1],
               slot: freeSlot(),
               expanded: false,
               since: 0
            };
            states[w.id] = s;
            collapse(w.id, s.slot);
         } else if (s.expanded && !w.is_focused && Date.now() - s.since > 600) {
            // lost focus: back into a bubble
            s.expanded = false;
            collapse(w.id, s.slot);
         }

         if (!s.expanded)
            list.push({ id: w.id, appId: w.app_id, slot: s.slot });
      }
      bubbles = list;
   }

   Process {
      id: query
      command: ["niri", "msg", "--json", "windows"]
      stdout: StdioCollector {
         onStreamFinished: {
            try {
               root.sync(JSON.parse(text));
            } catch (e) {
               console.log("bubbles: bad windows json", e);
            }
         }
      }
   }

   Timer {
      id: debounce
      interval: 80
      onTriggered: query.running = true
   }

   // refresh whenever niri reports any change
   Process {
      running: true
      command: ["niri", "msg", "--json", "event-stream"]
      stdout: SplitParser {
         onRead: debounce.restart()
      }
   }

   Variants {
      model: root.bubbles

      PanelWindow {
         id: bubble
         required property var modelData

         readonly property var entry: DesktopEntries.heuristicLookup(modelData.appId)
         readonly property string iconName: entry && entry.icon ? entry.icon : modelData.appId

         implicitWidth: root.size
         implicitHeight: root.size
         color: "transparent"
         exclusionMode: ExclusionMode.Ignore
         WlrLayershell.layer: WlrLayer.Overlay
         anchors.left: true
         anchors.top: true
         margins.left: root.edge
         margins.top: root.slotY(modelData.slot)

         Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "#e61e1e2e"
            border.color: "#66ffffff"

            Image {
               anchors.centerIn: parent
               width: 32
               height: 32
               sourceSize: Qt.size(32, 32)
               source: bubble.iconName.startsWith("/")
                       ? "file://" + bubble.iconName
                       : Quickshell.iconPath(bubble.iconName, "application-x-executable")
            }
         }

         MouseArea {
            anchors.fill: parent
            onClicked: root.expand(bubble.modelData.id)
         }
      }
   }
}
