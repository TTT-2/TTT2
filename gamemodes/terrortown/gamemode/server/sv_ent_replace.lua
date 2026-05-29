---
-- Replaces old and boring ents with new and shiny SENTs
-- @module ents.TTT

ents.TTT = {}

local string = string
local file = file
local IsValid = IsValid
local Vector = Vector
local Angle = Angle
local tonum = tonumber
local stringMatch = string.match

---
-- Remove ZM ragdolls that don't work, AND old player ragdolls.
-- Exposed because it's also done at BeginRound
-- @param boolean player_only
-- @realm server
function ents.TTT.RemoveRagdolls(player_only)
    local ragdolls = ents.FindByClass("prop_ragdoll")
    local stringfind = string.find

    for i = 1, #ragdolls do
        local ent = ragdolls[i]

        if not player_only and stringfind(ent:GetModel(), "zm_", 6, true) then
            ent:Remove()
        elseif ent.player_ragdoll then
            ent:Remove() -- cleanup ought to catch these but you know
        end
    end
end

-- GMod's game.CleanUpMap destroys rope entities that are parented. This is an
-- experimental fix where the rope is unparented, the map cleaned, and then the
-- rope reparented.
-- Same happens for func_brush.
local broken_parenting_ents = {
    "move_rope",
    "keyframe_rope",
    "info_target",
    "func_brush",
}

---
-- Fixes parenting bug of broken @{Entity}, before the cleanup
-- @realm server
-- @internal
function ents.TTT.FixParentedPreCleanup()
    local entsFindByClass = ents.FindByClass

    for i = 1, #broken_parenting_ents do
        local entits = entsFindByClass(broken_parenting_ents[i])

        for k = 1, #entits do
            local v = entits[k]

            if v.GetParent == nil or not IsValid(v:GetParent()) then
                continue
            end

            v.CachedParentName = v:GetParent():GetName()

            v:SetParent(nil)

            v.OrigPos = v.OrigPos or v:GetPos()
        end
    end
end

---
-- Fixes parenting bug of broken @{Entity}, after the cleanup
-- @realm server
-- @internal
function ents.TTT.FixParentedPostCleanup()
    local entsFindByClass = ents.FindByClass
    local entsFindByName = ents.FindByName

    for i = 1, #broken_parenting_ents do
        local entits = entsFindByClass(broken_parenting_ents[i])

        for k = 1, #entits do
            local v = entits[k]

            if v.CachedParentName == nil then
                continue
            end

            if v.OrigPos then
                v:SetPos(v.OrigPos)
            end

            local parents = entsFindByName(v.CachedParentName)
            if #parents == 1 then
                local parent = parents[1]

                v:SetParent(parent)
            end
        end
    end
end

---
-- Triggers the round state output for every map setting @{Entity}
-- @param number r round state
-- @param any param the data that is assigned to the new event / @{function}
-- @realm server
-- @internal
function ents.TTT.TriggerRoundStateOutputs(r, param)
    r = r or gameloop.GetRoundState()

    local entMapSettings = ents.FindByClass("ttt_map_settings")

    for i = 1, #entMapSettings do
        entMapSettings[i]:RoundStateTrigger(r, param)
    end
end

---
-- Checks whether the given map is able to import @{Entity} based on the map's data
-- @param string map
-- @return[default=nil] string The rearm script's file path
-- @realm server
-- @internal
function ents.TTT.CanImportEntities(map)
    local fname = "maps/" .. map .. "_ttt.txt"
    if file.Exists(fname, "GAME") then
        return fname
    end

    -- Allows workshop addons to pack rearm scripts
    fname = "data_static/" .. map .. "_ttt.txt"
    if file.Exists(fname, "GAME") then
        return fname
    end
end

local classremap = {
    ttt_playerspawn = "info_player_deathmatch",
}

---
-- Imports spawns from old TTT-style map spawn scrips.
-- @param string map The map name
-- @deprecated Use the TTT2 ent spawn system instead
-- @return table A table of spawns
-- @return table A table of settings
-- @internal
-- @realm server
function ents.TTT.ImportEntities(map)
    local fname = ents.TTT.CanImportEntities(map)
    local buf = file.Read(fname, "GAME")
    local lines = string.Explode("\n", buf)

    local settings = {}
    local spawns = {}

    for k = 1, #lines do
        local line = lines[k]

        -- ignore the line if empty or comment
        if stringMatch(line, "^#") or line == "" or string.byte(line) == 0 then
            continue
        end

        -- attempt to find settings in the file
        local key, val = stringMatch(line, "^setting:\t(%w*) ([0-9]*)")

        if key and val then
            val = tonumber(val)

            settings[key] = val

            continue
        end

        -- if it is no settings line, it probably is a spawn line
        local data = string.Explode("\t", line)

        local newSpawn = {}

        if data[2] and data[3] then
            -- some dummy ents remap to different, real entity names
            newSpawn.class = classremap[data[1]] or data[1]

            local posraw = string.Explode(" ", data[2])
            newSpawn.pos = Vector(tonum(posraw[1]), tonum(posraw[2]), tonum(posraw[3]))

            local angraw = string.Explode(" ", data[3])
            newSpawn.ang = Angle(tonum(angraw[1]), tonum(angraw[2]), tonum(angraw[3]))

            -- random weapons have a useful keyval
            if data[4] then
                local kvraw = string.Explode(" ", data[4])
                local kvKey = kvraw[1]
                local kvVal = tonum(kvraw[2])

                if kvKey and kvVal and kvKey == "auto_ammo" then
                    newSpawn.ammo = kvVal
                end
            end
        end

        spawns[#spawns + 1] = newSpawn
    end

    return spawns, settings
end
