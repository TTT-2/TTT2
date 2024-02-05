---
-- This is the <code>WEPS</code> module
-- @author BadKingUrgrain
-- @author Alf21
-- @author LeBroomer
-- @module WEPS

WEPS = {}

local pairs = pairs
local IsValid = IsValid
local wepGetList = weapons.GetList
local scriptedEntsGetList = scripted_ents.GetList

---
-- Get the type (<code>kind</code>) of a weapon class
-- @param string class weapon class
-- @return boolean weapon type (<code>kind</code>)
-- @realm shared
function WEPS.TypeForWeapon(class)
    local tbl = util.WeaponForClass(class)

    return tbl and tbl.Kind or WEAPON_NONE
end

---
-- Checks whether the table is a valid equipment (weapon)
-- @param table wep table that needs to be checked
-- @return boolean whether the table is a valid equipment (weapon)
-- @realm shared
function WEPS.IsEquipment(wep)
    return wep and wep.Kind and wep.Kind >= WEAPON_EQUIP
end

---
-- Get the class of the weapon
-- @param Weapon wep
-- @return nil|string weapon's class
-- @realm shared
function WEPS.GetClass(wep)
    if istable(wep) then
        return wep.ClassName or wep.Classname or wep.id or wep.name
    elseif IsValid(wep) then
        return wep:GetClass()
    end
end

---
-- Returns a table of weapons sorted by the available spawn types.
-- @return table A table with all weapons sorted by their spawn type
-- @return table An indexed table with all spawnable weapons including those with invalid spawn types
-- @realm shared
function WEPS.GetWeaponsForSpawnTypes()
    local wepsForSpawns = {}
    local wepsTable = {}
    local weps = wepGetList()

    for i = 1, #weps do
        local wep = weps[i]
        local spawnType = wep.spawnType

        if not wep.AutoSpawnable then
            continue
        end

        -- add these entities to the random weapon table even if they might
        -- not have a spawn type defined
        wepsTable[#wepsTable + 1] = wep

        if not spawnType then
            continue
        end

        wepsForSpawns[spawnType] = wepsForSpawns[spawnType] or {}
        wepsForSpawns[spawnType][#wepsForSpawns[spawnType] + 1] = wep
    end

    return wepsForSpawns, wepsTable
end

---
-- Returns a table of ammo sorted by the available spawn types.
-- @return table A table with all ammo sorted by their spawn type
-- @return table An indexed table with all spawnable ammo including those with invalid spawn types
-- @realm shared
function WEPS.GetAmmoForSpawnTypes()
    local ammoForSpawns = {}
    local ammoTable = {}

    local allEnts = scriptedEntsGetList()

    for _, entData in pairs(allEnts) do
        if entData.Base ~= "base_ammo_ttt" then
            continue
        end

        local ammo = entData.t
        local spawnType = ammo.spawnType

        if not ammo.AutoSpawnable then
            continue
        end

        -- add these entities to the random ammo table even if they might
        -- not have a spawn type defined
        ammoTable[#ammoTable + 1] = ammo

        if not spawnType then
            continue
        end

        ammoForSpawns[spawnType] = ammoForSpawns[spawnType] or {}
        ammoForSpawns[spawnType][#ammoForSpawns[spawnType] + 1] = ammo
    end

    return ammoForSpawns, ammoTable
end

---
-- Toggles the <code>disguised</code>
-- @param Player ply
-- @realm shared
function WEPS.DisguiseToggle(ply)
    if not IsValid(ply) or not ply:IsActive() then
        return
    end

    if not ply:GetNWBool("disguised", false) then
        RunConsoleCommand("ttt_set_disguise", "1")
    else
        RunConsoleCommand("ttt_set_disguise", "0")
    end
end
concommand.Add("ttt_toggle_disguise", WEPS.DisguiseToggle)
