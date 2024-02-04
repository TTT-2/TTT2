---
-- Outsourced the decal releavant stuff to its own file
-- @author Mineotopia
-- @section Decal

---
-- Here comes some special decal handling. GMOD does not allow you to remove
-- specific decals, this is changed in this hacky implementation
-- This works mostly good, however only for decals added with LUA. Decals added
-- internally are not handled by these functions and therefore vanish when another
-- decal is removed. This might be improved in the future.

if CLIENT then
    -- Cache original decal function, but make sure that no infinite recursion (stack overflow)
    local utilDecal = util.OverwriteFunction("util.Decal")

    -- table of all added decals
    local decals = {}

    ---
    -- @module util

    ---
    -- Adds a new decal with an unique id that can be removed with this id
    -- @param number id The unique id of this specific decal
    -- @param string name The name of this decal type to be rendered
    -- @param Vector startpos The start of the trace
    -- @param Vector endpos The end of the trace
    -- @param[opt] Entity filter If set, the decal will not be able to be placed on given entity. Can also be a table of entities
    -- @return string The unique id of the decal
    -- @realm client
    function util.DecalRemovable(id, name, startpos, endpos, filter)
        -- make sure each name is unique
        if decals[id] then
            return util.DecalRemovable(id .. "_", name, startpos, endpos, filter)
        end

        -- cache added decal
        decals[id] = {
            name = name,
            startpos = startpos,
            endpos = endpos,
            filter = filter,
        }

        -- run vanilla decal function
        utilDecal(name, startpos, endpos, filter)
    end

    ---
    -- Removed one specific decal by its id
    -- @param string id The unique id of the decal that should be removed
    -- @realm client
    function util.RemoveDecal(id)
        decals[id] = nil

        RunConsoleCommand("r_cleardecals")

        -- strangely enough, running the console command seems to be asynchronus
        -- therefore the decals should be readded after a short amount of time
        timer.Simple(0.1, function()
            for did, decal in pairs(decals) do
                utilDecal(decal.name, decal.startpos, decal.endpos, decal.filter)
            end
        end)
    end

    ---
    -- Clears all existing decals on the map
    -- @realm client
    function util.ClearDecals()
        decals = {}

        RunConsoleCommand("r_cleardecals")
    end

    -- mirror the function calls from the server to the client
    net.Receive("TTT2RegDecal", function()
        game.AddDecal(net.ReadString(), net.ReadTable())
    end)

    net.Receive("TTT2AddDecal", function()
        util.DecalRemovable(
            net.ReadString(),
            net.ReadString(),
            net.ReadVector(),
            net.ReadVector(),
            net.ReadTable()
        )
    end)

    net.Receive("TTT2RemoveDecal", function()
        util.RemoveDecal(net.ReadString())
    end)

    net.Receive("TTT2ClearDecals", function()
        util.ClearDecals()
    end)
end

if SERVER then
    util.AddNetworkString("TTT2AddDecal")
    util.AddNetworkString("TTT2RemoveDecal")
    util.AddNetworkString("TTT2ClearDecals")
    util.AddNetworkString("TTT2RegDecal")

    -- cache original game.AddDecal
    local gameAddDecal = util.OverwriteFunction("game.AddDecal")

    ---
    -- @module game

    ---
    -- Registers a new decal. When called on the server, the decal is registered on both client and server.
    -- @warning This functions has to be either run on both server and client, or inside a hook that is called
    -- after all files are loaded, e.g. @{GM:Initialize}
    -- @param string decalName The name of the decal
    -- @param string materialName The material to be used for the decal. May also be a list of material names,
    -- in which case a random material from that list will be chosen every time the decal is placed.
    -- @realm server
    function game.AddDecal(decalName, materialName)
        materialName = istable(materialName) and materialName or { materialName }

        gameAddDecal(decalName, materialName)

        net.Start("TTT2RegDecal")
        net.WriteString(decalName)
        net.WriteTable(materialName)
        net.Broadcast()
    end

    ---
    -- @module util

    ---
    -- Adds a new decal with an unique id that can be removed with this id
    -- @param number id The unique id of this specific decal
    -- @param string name The name of this decal type to be rendered
    -- @param Vector startpos The start of the trace
    -- @param Vector endpos The end of the trace
    -- @param[opt] Entity filter If set, the decal will not be able to be placed on given entity. Warning: Must be a table on the server
    -- @param[opt] Entity playerlist If set, it defines which player will see the decal; visible to all players if not set
    -- @realm server
    function util.DecalRemovable(id, name, startpos, endpos, filter, playerlist)
        if isfunction(filter) then
            filter = nil

            ErrorNoHaltWithStack(
                "Warning: Do not set the filter to a function if used on a server."
            )
        end

        filter = istable(filter) and filter or { filter }

        net.Start("TTT2AddDecal")
        net.WriteString(id)
        net.WriteString(name)
        net.WriteVector(startpos)
        net.WriteVector(endpos)
        net.WriteTable(filter)

        if playerlist then
            net.Send(playerlist)
        else
            net.Broadcast()
        end
    end

    ---
    -- Removed one specific decal by its id
    -- @param string id The unique id of the decal that should be removed
    -- @param[opt] Entity playerlist If set, it defines which player will see the decal removal; visible to all players if not set
    -- @realm server
    function util.RemoveDecal(id, playerlist)
        net.Start("TTT2RemoveDecal")
        net.WriteString(id)

        if playerlist then
            net.Send(playerlist)
        else
            net.Broadcast()
        end
    end

    ---
    -- Clears all existing decals on the map
    -- @param[opt] Entity playerlist If set, it defines which player will see the decal removal; visible to all players if not set
    -- @realm server
    function util.ClearDecals(playerlist)
        net.Start("TTT2ClearDecals")

        if playerlist then
            net.Send(playerlist)
        else
            net.Broadcast()
        end
    end
end

---
-- Adds a new decal that can be removed with the autogenerated unique id
-- @param string name The name of this decal type to be rendered
-- @param Vector startpos The start of the trace
-- @param Vector endpos The end of the trace
-- @param[opt] Entity filter If set, the decal will not be able to be placed on given entity. Warning: Must be a table on the server
-- @param table playerlist A list of @{Player}s that should receive the decals
-- @return string The unique id of the decal
-- @realm shared
function util.Decal(name, startpos, endpos, filter, playerlist)
    -- call the removable decal function, unique name is handled on the client
    util.DecalRemovable(name, name, startpos, endpos, filter, playerlist)
end

---
-- Paints an decal effect on the floor while also automatically calculating the colliding surface and position.
-- It searches for a target up to 256 away. This function also only traces a line to the bottom, not in a sphere.
-- @param Vector start The starting position of the trace
-- @param string effname The decal effect name
-- @param[opt] Entity ignore If set, the decal will not be able to be placed on given entity. Warning: Must be a table on the
-- server and functions here are very slow in general.
-- @realm shared
function util.PaintDown(start, effname, ignore)
    local btr = util.TraceLine({
        start = start,
        endpos = start + Vector(0, 0, -256),
        filter = ignore,
        mask = MASK_SOLID,
    })

    util.Decal(effname, btr.HitPos + btr.HitNormal, btr.HitPos - btr.HitNormal, ignore)
end

---
-- Paints an decal effect on the floor while also automatically calculating the colliding surface and position.
-- It searches for a target up to 256 away. This function also only traces a line to the bottom, not in a sphere.
-- The decal effect can be removed again with the passed unique id.
-- @param number id The unique id of this specific decal
-- @param Vector start The starting position of the trace
-- @param string effname The decal effect name
-- @param[opt] Entity ignore If set, the decal will not be able to be placed on given entity. Warning: Must be a table on the
-- server and functions here are very slow in general.
-- @realm shared
function util.PaintDownRemovable(id, start, effname, ignore)
    local btr = util.TraceLine({
        start = start,
        endpos = start + Vector(0, 0, -256),
        filter = ignore,
        mask = MASK_SOLID,
    })

    util.DecalRemovable(id, effname, btr.HitPos + btr.HitNormal, btr.HitPos - btr.HitNormal, ignore)
end
