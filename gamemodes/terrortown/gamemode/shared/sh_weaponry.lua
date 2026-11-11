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

local ammoTypes
local ammoTypeLookup
local ammoEntityLookup

-- Reserve limits belong to ammo types, not to individual box entities.
local defaultAmmoReserveMax = {
    ["357"] = 20,
    alyxgun = 36,
    buckshot = 24,
    pistol = 60,
    smg1 = 60,
}

local function GetAmmoIdentifier(name)
    return string.gsub(string.lower(name), "[^%w_]", "_")
end

---
-- Returns the convar name for an ammo box setting.
-- @param string class Ammo entity class
-- @param string setting Setting suffix
-- @return string
-- @realm shared
function WEPS.GetAmmoSettingsConVarName(class, setting)
    return "ttt2_ammo_" .. GetAmmoIdentifier(class) .. "_" .. setting
end

---
-- Returns the convar name for the shared reserve limit of an ammo type.
-- @param string ammoType Ammo type name
-- @return string
-- @realm shared
function WEPS.GetAmmoReserveConVarName(ammoType)
    return "ttt2_ammo_type_" .. GetAmmoIdentifier(ammoType) .. "_reserve_max"
end

local function BuildAmmoSettings()
    ammoTypes = {}
    ammoTypeLookup = {}
    ammoEntityLookup = {}

    for class in pairs(scriptedEntsGetList()) do
        if class == "base_ammo_ttt" or not scripted_ents.IsBasedOn(class, "base_ammo_ttt") then
            continue
        end

        local ammo = scripted_ents.Get(class)
        local ammoType = ammo.AmmoType or "Pistol"
        local identifier = string.lower(ammoType)
        local typeData = ammoTypeLookup[identifier]

        if not typeData then
            typeData = {
                ammoType = ammoType,
                name = "ammo_" .. identifier,
                reserveMax = defaultAmmoReserveMax[identifier] or 0,
                entities = {},
            }

            ammoTypes[#ammoTypes + 1] = typeData
            ammoTypeLookup[identifier] = typeData
        end

        -- Import legacy defaults once when building the registry. Pick the highest
        -- default when several boxes share a type; pickups only consult the convar.
        typeData.reserveMax = math.max(
            typeData.reserveMax,
            math.max(0, ammo.AmmoMax or defaultAmmoReserveMax[identifier] or 10)
        )

        local entityData = {
            class = class,
            boxAmount = math.max(1, ammo.AmmoAmount or 1),
        }

        typeData.entities[#typeData.entities + 1] = entityData
        ammoEntityLookup[class] = entityData
    end

    table.SortByMember(ammoTypes, "ammoType", true)

    for i = 1, #ammoTypes do
        local typeData = ammoTypes[i]
        table.SortByMember(typeData.entities, "class", true)

        if SERVER then
            -- @realm server
            typeData.reserveConVar = CreateConVar(
                WEPS.GetAmmoReserveConVarName(typeData.ammoType),
                tostring(typeData.reserveMax),
                { FCVAR_NOTIFY, FCVAR_ARCHIVE },
                "",
                0
            )

            for j = 1, #typeData.entities do
                local entityData = typeData.entities[j]
                -- @realm server
                entityData.enabledConVar = CreateConVar(
                    WEPS.GetAmmoSettingsConVarName(entityData.class, "enabled"),
                    "1",
                    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
                    "",
                    0,
                    1
                )
                -- @realm server
                entityData.boxAmountConVar = CreateConVar(
                    WEPS.GetAmmoSettingsConVarName(entityData.class, "box_amount"),
                    tostring(entityData.boxAmount),
                    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
                    "",
                    1
                )
            end
        end
    end
end

---
-- Returns ammo types with their default reserve limits and individual box classes.
-- @return table An indexed list of ammo types, each with an entities list
-- @realm shared
function WEPS.GetAmmoTypes()
    if not ammoTypes then
        BuildAmmoSettings()
    end

    return ammoTypes
end

---
-- Returns the shared pickup reserve limit for an ammo type.
-- Legacy AmmoMax values only seed its initial default, never the pickup limit.
-- @param string ammoType Ammo type name
-- @return number
-- @realm shared
function WEPS.GetAmmoReserveMax(ammoType)
    WEPS.GetAmmoTypes()

    local typeData = ammoTypeLookup[string.lower(ammoType)]

    if not typeData then
        return 0
    end

    return SERVER and math.max(0, typeData.reserveConVar:GetInt()) or typeData.reserveMax
end

---
-- Returns the configured starting ammo amount for a box class.
-- @param string class Ammo entity class
-- @param[default=1] number fallback Amount for an unregistered class
-- @return number
-- @realm shared
function WEPS.GetAmmoBoxAmount(class, fallback)
    WEPS.GetAmmoTypes()

    local entityData = ammoEntityLookup[class]

    if not entityData then
        return math.max(1, fallback or 1)
    end

    return SERVER and math.max(1, entityData.boxAmountConVar:GetInt()) or entityData.boxAmount
end

---
-- Returns whether an ammo box class is enabled for map spawns.
-- @param string class Ammo entity class
-- @return boolean
-- @realm shared
function WEPS.IsAmmoEnabled(class)
    WEPS.GetAmmoTypes()

    local entityData = ammoEntityLookup[class]

    return not SERVER or not entityData or entityData.enabledConVar:GetBool()
end

hook.Add("InitPostEntity", "TTT2RegisterAmmoSettings", function()
    WEPS.GetAmmoTypes()
end)

hook.Add("OnReloaded", "TTT2ReloadAmmoSettings", function()
    -- Preserve archived convar values while discovering reloaded or new box classes.
    ammoTypes = nil
end)

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

    for class in pairs(allEnts) do
        if class == "base_ammo_ttt" or not scripted_ents.IsBasedOn(class, "base_ammo_ttt") then
            continue
        end

        local ammo = scripted_ents.Get(class)
        local spawnType = ammo.spawnType

        if not ammo.AutoSpawnable or not WEPS.IsAmmoEnabled(class) then
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
