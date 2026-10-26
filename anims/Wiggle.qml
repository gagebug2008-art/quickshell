import QtQuick

Item {
      id: appWiggle
      property Item item
      
      function play() {
      main.stop();
      if (item)
         item.rotation = 0;
      main.start();
   }
      SequentialAnimation {
      id: main
      NumberAnimation {
         target: item
         property: "rotation"
         to: 15
         duration: 70
      }
      NumberAnimation {
         target: item
         property: "rotation"
         to: 0
         duration: 80
      }
      NumberAnimation {
         target: item
         property: "rotation"
         to: -10
         duration: 90
      }
      NumberAnimation {
         target: item
         property: "rotation"
         to: 0
         duration: 80
         }
      }
   }
