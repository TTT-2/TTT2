---
-- This is the <code>huds</code> module
-- @author Alf21
-- @author saibotk
-- @module huds

huds = huds or {}

local baseclass = baseclass
local pairs = pairs

if SERVER then
    AddCSLuaFile()
end

local HUDList = {}

---
-- Copies any missing data from base table to the target table
-- @param table t target table
-- @param table base base (fallback) table
-- @return table t target table
-- @realm shared
local function TableInherit(t, base)
    for k, v in pairs(base) do
        if t[k] == nil then
            t[k] = v
        elseif k ~= "BaseClass" and istable(t[k]) and istable(v[k]) then
            TableInherit(t[k], v)
        end
    end

    return t
end

---
-- Checks if name is based on base
-- @param table name table to check
-- @param table base base (fallback) table
-- @return boolean returns whether name is based on base
-- @realm shared
function huds.IsBasedOn(name, base)
    local t = huds.GetStored(name)

    if not t then
        return false
    end

    if t.Base == name then
        return false
    end

    if t.Base == base then
        return true
    end

    return huds.IsBasedOn(t.Base, base)
end

---
-- Used to register your hud with the engine.<br />
-- <b>This is done automatically for all the files in the <code>gamemodes/terrortown/gamemode/shared/huds</code> folder</b>
-- @param table t hud table
-- @param string name hud name
-- @realm shared
function huds.Register(t, name)
    name = string.lower(name)

    t.ClassName = name
    t.id = name
    t.isAbstract = t.isAbstract or false

    HUDList[name] = t
end

---
-- All scripts have been loaded...
-- @local
-- @realm shared
function huds.OnLoaded()
    --
    -- Once all the scripts are loaded we can set up the baseclass
    -- - we have to wait until they're all setup because load order
    -- could cause some entities to load before their bases!
    --
    for k in pairs(HUDList) do
        local newTable = huds.Get(k)
        HUDList[k] = newTable

        baseclass.Set(k, newTable)
    end
end

---
-- Get an hud by name (a copy)
-- @param string name hud name
-- @param[opt] table retTbl this table will be modified and returned. If nil, a new table will be created.
-- @return table returns the modified retTbl or the new hud table
-- @realm shared
function huds.Get(name, retTbl)
    local Stored = huds.GetStored(name)
    if not Stored then
        return
    end

    -- Create/copy a new table
    local retval = retTbl or {}

    for k, v in pairs(Stored) do
        if istable(v) then
            retval[k] = table.Copy(v)
        else
            retval[k] = v
        end
    end

    retval.Base = retval.Base or "hud_base"

    -- If we're not derived from ourselves (a base HUD element)
    -- then derive from our 'Base' HUD element.
    if retval.Base ~= name then
        local base = huds.Get(retval.Base)

        if not base then
            ErrorNoHaltWithStack(
                "ERROR: Trying to derive HUD "
                    .. tostring(name)
                    .. " from non existant HUD "
                    .. tostring(retval.Base)
                    .. "!\n"
            )
        else
            retval = TableInherit(retval, base)
        end
    end

    return retval
end

---
-- Gets the real hud table (not a copy)
-- @param string name hud name
-- @return table returns the real hud table
-- @realm shared
function huds.GetStored(name)
    return HUDList[name]
end

---
-- Get a list (copy) of all registered huds, that can be displayed (no abstract HUDs).
-- @return table available huds
-- @realm shared
function huds.GetList()
    local result = {}

    for _, v in pairs(HUDList) do
        if not v.isAbstract then
            result[#result + 1] = v
        end
    end

    return result
end

---
-- Get a list (copy) of all the registered HUDs including abstract HUDs.
-- @return table all registered huds
-- @realm shared
function huds.GetRealList()
    local result = {}

    for _, v in pairs(HUDList) do
        result[#result + 1] = v
    end

    return result
end
