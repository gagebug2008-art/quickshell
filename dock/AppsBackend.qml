import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
   id: root

   property var pinnedApps: []
readonly property var toplevels: ToplevelManager.toplevels.values
   function pinToggle(id) {
      pinnedApps = pinnedApps.includes(id)
         ? pinnedApps.filter(a => a !== id)
         : [...pinnedApps, id];

      store.setText(JSON.stringify(pinnedApps));
   }

   FileView {
      id: store
      path: Quickshell.statePath("pinned-apps.json")

      onLoaded: {
         try {
            root.pinnedApps = JSON.parse(text());
         } catch (e) {
            root.pinnedApps = [];
         }
      }

      onLoadFailed: error => {
         if (error === FileViewError.FileNotFound)
            setText("[]");
      }
   }

   readonly property var uniqueApps: {
      const seen = {};
      const result = [];

      const entryFor = (id, pinned) => {
         if (!seen[id]) {
            seen[id] = { appId: id, windows: [], pinned: pinned };
            result.push(seen[id]);
         }
         return seen[id];
      };

      for (const id of pinnedApps)
         entryFor(id, true);

      const wins = ToplevelManager.toplevels.values;
      for (let i = 0; i < wins.length; i++) {
         if (wins[i]?.appId)
            entryFor(wins[i].appId, false).windows.push(wins[i]);
      }
      return result;
   }
}
