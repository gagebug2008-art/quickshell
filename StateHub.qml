pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    // Core Data Structures
    property var list: []
    property var _idMap: ({})          // id -> entry (O(1) lookup)
    property var _itemMap: ({})        // item -> entry (O(1) lookup)
    
    property int version: 0
    property int _activeCount: 0
    property int _anonCounter: 0

    readonly property bool hasOpenPopup: _activeCount > 0
    readonly property var activeStack: {
        version
        var active = []
        for (var i = 0; i < list.length; i++) {
            var e = list[i]
            if (e && e.item && e.item.state !== "" && e.item.state !== "normal" && e.item.state !== e.defaultState) {
                active.push(e.item)
            }
        }
        return active
    }

    // ------------------------------------------------------------------
    // 1. AUTOMATIC REGISTRATION
    // ------------------------------------------------------------------

    function register(id, item, input, sortKey) {
        if (id && typeof id === "object") {
            sortKey = input
            input = item
            item = id
            id = undefined
        }

        if (!item) return null

        // Priority: explicit id -> item.hubId -> objectName -> auto counter
        if (!id) {
            id = item.hubId || item.objectName || ("_anon_" + (++_anonCounter))
        }

        if (_idMap[id]) unregister(id)

        const entry = {
            id: id,
            item: item,
            input: input,
            sortKey: sortKey ?? "order",
            names: [],
            nameMap: ({}),
            defaultState: "",
            n: -1
        }

        build(entry)

        var slotIdx = list.findIndex(e => !e || !e.item)
        if (slotIdx >= 0) list[slotIdx] = entry
        else list.push(entry)

        _idMap[id] = entry
        _itemMap[item] = entry

        // Initial state sync
        if ((item.state === undefined || item.state === "") && entry.names.length > 0) {
            item.state = entry.names[0]
        }

        // Automatic re-registration if hubId updates dynamically
        if (item.hubIdChanged) {
            item.hubIdChanged.connect(function() {
                if (item.hubId && item.hubId !== id) {
                    root.register(item.hubId, item)
                }
            })
        }

        if (item.stateChanged) {
            item.stateChanged.connect(function() { root._updateActiveCount(); version++; })
        }

        if (item.Component && item.Component.onDestroyed) {
            item.Component.onDestroyed.connect(function() { root.unregister(id); })
        }

        _updateActiveCount()
        version++
        return id
    }

    function unregister(ref) {
        const entry = resolve(ref)
        if (!entry) return

        delete _idMap[entry.id]
        if (entry.item) delete _itemMap[entry.item]

        const idx = list.indexOf(entry)
        if (idx !== -1) list[idx] = null

        _updateActiveCount()
        version++
    }

    // ------------------------------------------------------------------
    // 2. MUTATORS & NAVIGATION
    // ------------------------------------------------------------------

    function goTo(path) {
        const t = target(path)
        if (!t) {
            console.warn("StateHub: path not found -> " + path)
            return false
        }
        t.entry.item.state = t.state
        return true
    }

    function toggle(ref, stateA, stateB) {
        const entry = resolve(ref)
        if (!entry || entry.names.length < 2) return false

        const inactiveState = stateA ?? entry.defaultState
        const activeState = stateB ?? entry.names[1]

        entry.item.state = (entry.item.state === activeState) ? inactiveState : activeState
        return true
    }

    function exclusive(ref, targetState) {
        const entry = resolve(ref)
        if (!entry) return false

        const parentGroup = entry.item.parent
        if (parentGroup && parentGroup.children) {
            const kids = parentGroup.children
            for (var i = 0; i < kids.length; i++) {
                const child = kids[i]
                if (child !== entry.item) {
                    const childEntry = _itemMap[child]
                    if (childEntry && childEntry.names.length > 0) {
                        childEntry.item.state = childEntry.defaultState
                    }
                }
            }
        }

        entry.item.state = targetState ?? (entry.names[1] ?? entry.defaultState)
        return true
    }

    // ------------------------------------------------------------------
    // 3. READERS & RESOLUTION
    // ------------------------------------------------------------------

    function active(ref) {
        const entry = resolve(ref)
        if (!entry) return false
        return entry.item.state !== "" && entry.item.state !== "normal" && entry.item.state !== entry.defaultState
    }

    function current(ref) { return resolve(ref)?.item.state ?? "" }

    function resolve(ref) {
        if (ref === undefined || ref === null) return null
        if (typeof ref === "object") return _itemMap[ref] ?? (_itemMap[ref] = register(ref))
        if (typeof ref === "number") return list[ref] ?? null
        return _idMap[ref] ?? null
    }

    function target(path) {
        if (!path) return null
        const s = String(path).trim()
        const openIdx = s.indexOf("[")

        if (openIdx === -1) {
            const entry = resolve(s)
            if (entry) return { entry: entry, state: entry.item.state }

            for (var i = 0; i < list.length; i++) {
                const e = list[i]
                if (e && e.item && e.nameMap[s] !== undefined) return { entry: e, state: s }
            }
            return null
        }

        const closeIdx = s.indexOf("]", openIdx)
        if (closeIdx === -1) return null

        const idPart = s.slice(0, openIdx).trim()
        const keyPart = s.slice(openIdx + 1, closeIdx).trim().replace(/^["']|["']$/g, "")

        const entry = resolve(idPart)
        if (!entry) return null

        var state = entry.nameMap[keyPart] !== undefined ? keyPart : entry.names[Number(keyPart)]
        return state === undefined ? null : { entry: entry, state: state }
    }

    function build(entry) {
        const rawInput = entry.input ?? entry.item.states ?? []
        const len = rawInput.length

        var names = new Array(len)
        var nameMap = ({})

        for (var k = 0; k < len; k++) {
            var item = rawInput[k]
            var stateName = (typeof item === "string") ? item : (item?.name ?? ("state" + k))
            names[k] = stateName
            nameMap[stateName] = k
        }

        entry.names = names
        entry.nameMap = nameMap
        entry.defaultState = names[0] ?? ""
        entry.n = len
    }

    function _updateActiveCount() {
        var count = 0
        for (var i = 0; i < list.length; i++) {
            var e = list[i]
            if (e && e.item && e.item.state !== "" && e.item.state !== "normal" && e.item.state !== e.defaultState) {
                count++
            }
        }
        _activeCount = count
    }
}
