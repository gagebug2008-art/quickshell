import QtQuick
import Quickshell
import Quickshell.Io

Scope {
   id: root
   property list<DesktopEntry> entries: DesktopEntries.applications.values
   property list<DesktopEntry> sortedEntries: entries.slice().sort((a, b) => a.name.localeCompare(b.name))

   // plain objects: name, generic name, description, resolved icon path, and the original entry for launching
   
property var items: sortedEntries.map(e => {
   const cats = Array.from(e.categories ?? [])
   const keys = Array.from(e.keywords ?? [])
   return {
      name: e.name,
      genericName: e.genericName || "",
      comment: e.comment || "",
      icon: Quickshell.iconPath(e.icon, "application-x-executable"),
      entry: e,
      haystack: [e.name, e.genericName, ...cats, ...keys].join(" ").toLowerCase()
   }
})


   property var query: searchBar.query
   required property var launcher
   required property var searchBar

   property var filteredEntries: {
   const q = root.query.trim().toLowerCase()
   if (q === "")
      return root.items
   return root.items.filter(i => i.haystack.includes(q))
}
   IpcHandler {
      target: "bottom"

      function launcherToggle() {
         launcher.enabledQ = !launcher.enabledQ
         searchBar.text = ""
      }
   }
}
