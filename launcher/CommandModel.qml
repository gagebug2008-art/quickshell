import QtQuick
import Quickshell
import qs.reusables

Scope {
   id: root

   property var commands: [
      {name: "qs reset", cmd: ["sh", "-c", "pkill qs && qs"], icon: "off" },
      {name: "cliphist", cmd: [], icon: ""},
      {name: "notifhist", cmd: [], icon: ""},
      {name: "screenshot", cmd: ["niri", "msg", "action", "screenshot-screen"], icon: ""},
      {name: "screenshot region", cmd: ["niri", "msg", "action", "screenshot"], icon: ""},
      {name: "screenshot window", cmd: ["niri", "msg", "action", "screenshot-window"], icon: ""},
      {name: "togglefloating", cmd: ["sh", "-c", "~/.config/quickshell/scripts/floatall"], icon: ""},
      {name: "colorpicker", cmd: ["hyprpicker", "-a"], icon: ""},
      {name: "overview", cmd: [""], icon: ""},
      {name: "lock", cmd: ["hyprlock"], icon: ""},
      {name: "suspend", cmd: ["systemctl", "suspend"], icon: ""},
      {name: "logout", cmd: ["niri", "msg", "action", "quit"], icon: ""},
      {name: "reboot", cmd: ["systemctl", "reboot"], icon: ""},
      {name: "poweroff", cmd: ["systemctl", "poweroff"], icon: ""}
   ] 
}
