import QtQuick
import Quickshell
import Quickshell.Io

Scope {
   id: root

      // --- API ---
   property string apiKey: ""
   property string url: apiKey === "" ? "https://wallhaven.cc/api/v1/search" : "https://wallhaven.cc/api/v1/search?apikey=" + apiKey

   // --- Results ---
   property var raws: []

   // --- Filters ---
   property string query: "animals"
   property string ratio: "16x9"
   property string minRes: "2560x1440"
   // 100/101/111* /etc (general/anime/people) must include '*' at the end
   property string category: "111"
   // 000 would turn off (sfw|sketchy|nsfw) must include '*' at the end
   property string purity: "100"

   // --- Sorting and paging ---
   // sort must include '*' at the end (date_added, relevance, random, views, favorites, toplist)
   property string sort: "toplist"
   // desc*, asc
   property string order: "desc"
   // 1d, 3d, 1w, 1M*, 3M, 6M, 1y
   property string topRange: "6M"
   property string activePage: "1"

   // --- Command ---
   property var activeCommand: [
      "curl",  "-G", url,
      "--data-urlencode", "q=" + query,
      "--data-urlencode", "ratios=" + ratio,
      "--data-urlencode", "atleast=" + minRes,
      "--data-urlencode", "categories=" + category,
      "--data-urlencode", "purity=" + purity,
      //"--data-urlencode", "sorting=" + sort,
      "--data-urlencode", "order=" + order,
      "--data-urlencode", "topRange=" + topRange,
      "--data-urlencode", "page=" + activePage
   ]
   // --- seperated vals --- 

   property var procUrls: []
   property var thumbUrls: []

   // --- functions ---
   function urlSplitter() {
      root.procUrls = root.raws.map(item => item.path);
          console.log(procUrls);
       }
   function thumbSplitter() {
      root.thumbUrls = root.raws.map(item => item.thumbs.large);
          console.log(thumbUrls);
   }
   // --- Curl Process ---
   Process {
      id: wallhavenApiAccess
      running: true
      command: root.activeCommand
      onCommandChanged: wallhavenApiAccess.running = true
      stdout: StdioCollector {
         id: stdio
         onStreamFinished: {
         root.raws = JSON.parse(stdio.text).data
	      console.log(JSON.stringify(root.raws))
         urlSplitter()
         thumbSplitter()
         }
      }
   }
}
