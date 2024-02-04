---
-- This is the <code>hudelements</code> module
-- @author Alf21
-- @author saibotk
-- @module hudelements

hudelements = hudelements or {}

local baseclass = baseclass
local pairs = pairs

if SERVER then
    AddCSLuaFile()
end

local HUDElementList = {}

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
function hudelements.IsBasedOn(name, base)
    local t = hudelements.GetStored(name)

    if not t then
        return false
    end

    if t.Base == name then
        return false
    end

    if t.Base == base then
        return true
    end

    return hudelements.IsBasedOn(t.Base, base)
end

---
-- Used to register your hud element with the engine.<br />
-- <b>This is done automatically for all the files in the <code>gamemodes/terrortown/gamemode/shared/hudelements</code> folder</b>
-- @param table t hud element table
-- @param string name hud element name
-- @realm shared
function hudelements.Register(t, name)
    name = string.lower(name)

    t.ClassName = name
    t.id = name

    HUDElementList[name] = t
end

---
-- All scripts have been loaded...
-- @local
-- @realm shared
function hudelements.OnLoaded()
    --
    -- Once all the scripts are loaded we can set up the baseclass
    -- - we have to wait until they're all setup because load order
    -- could cause some entities to load before their bases!
    --
    for k in pairs(HUDElementList) do
        local newTable = hudelements.Get(k)
        HUDElementList[k] = newTable

        baseclass.Set(k, newTable)
    end

    if CLIENT then
        -- Call PreInitialize on all hudelements
        for _, v in pairs(HUDElementList) do
            v:PreInitialize()
        end
    end
end

---
-- Get an hud element by name (a copy)
-- @param string name hud element name
-- @param[opt] table retTbl this table will be modified and returned. If nil, a new table will be created.
-- @return table returns the modified retTbl or the new hud element table
-- @realm shared
function hudelements.Get(name, retTbl)
    local Stored = hudelements.GetStored(name)
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

    retval.Base = retval.Base or "hud_element_base"

    -- If we're not derived from ourselves (a base HUD element)
    -- then derive from our 'Base' HUD element.
    if retval.Base ~= name then
        local base = hudelements.Get(retval.Base)

        if not base then
            ErrorNoHaltWithStack(
                "ERROR: Trying to derive HUD Element "
                    .. tostring(name)
                    .. " from non existant HUD Element "
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
-- Gets the real hud element table (not a copy)
-- @param string name hud element name
-- @return table returns the real hud element table
-- @realm shared
function hudelements.GetStored(name)
    return HUDElementList[name]
end

---
-- Get a list (copy) of all registered hud elements
-- @return table registered hud elements
-- @realm shared
function hudelements.GetList()
    local result = {}

    for _, v in pairs(HUDElementList) do
        result[#result + 1] = v
    end

    return result
end

---
-- Get a list of all the registered hud element types
-- @return table returns a list of all the registered hud element types
-- @realm shared
function hudelements.GetElementTypes()
    local typetbl = {}

    for _, v in pairs(HUDElementList) do
        if v.type and not table.HasValue(typetbl, v.type) then
            table.insert(typetbl, v.type)
        end
    end

    return typetbl
end

---
-- Gets the first element matching the type of all the registered hud elements
-- @param string type the hud element's type name
-- @return nil|table returns the first element matching the type of all the registered hud elements
-- @realm shared
function hudelements.GetTypeElement(type)
    for _, v in pairs(HUDElementList) do
        if v.type and v.type == type then
            return v
        end
    end
end

---
-- Gets all hud elements matching the type of all the registered hud elements
-- @param string type the hud element's type name
-- @return table returns all hud elements matching the type of all the registered hud elements
-- @realm shared
function hudelements.GetAllTypeElements(type)
    local retTbl = {}

    for _, v in pairs(HUDElementList) do
        if v.type and v.type == type then
            retTbl[#retTbl + 1] = v
        end
    end

    return retTbl
end

---
-- <p>Sets the child relation on all objects that have to be informed / are involved.</p>
-- <p>This can either be a single parent <-> child relation or a parents <-> child relation,
-- if the parent is a type. This function then will register the childid as a child to all elements with that type.</p>
-- <p>A parent element is responsible for calling PerformLayout on its child elements!</p>
-- @note This should be called in the <code>PreInitialize</code> method!
-- @todo link PreInitialize method
--
-- @param number childid child hud element name
-- @param number parentid parent hud element name
-- @param boolean parent_is_type whether the parent is a type
-- @todo example / usage
-- @realm shared
function hudelements.RegisterChildRelation(childid, parentid, parent_is_type)
    local child = hudelements.GetStored(childid)
    if not child then
        ErrorNoHaltWithStack(
            "Error: Cannot add child "
                .. childid
                .. " to "
                .. parentid
                .. ". child element instance was not found or registered yet!"
        )

        return
    end

    if not parent_is_type then
        local parent = hudelements.GetStored(parentid)
        if not parent then
            ErrorNoHaltWithStack(
                "Error: Cannot add child "
                    .. childid
                    .. " to "
                    .. parentid
                    .. ". parent element was not found or registered yet!"
            )

            return
        end

        parent:AddChild(childid)
    else
        local elems = hudelements.GetAllTypeElements(parentid)

        for i = 1, #elems do
            elems[i]:AddChild(childid)
        end
    end

    child:SetParentRelation(parentid, parent_is_type)
end
