---
-- Server and client both need this for scoring event logs
-- @section Scoring

local pairs = pairs
local IsValid = IsValid

-- Weapon AMMO_ enum stuff, used only in score.lua/cl_score.lua these days

-- Not actually ammo identifiers anymore, but still weapon identifiers. Used
-- only in round report (score.lua) to save bandwidth because we can't use
-- pooled strings there. Custom SWEPs are sent as classname string and don't
-- need to bother with these.
AMMO_DEAGLE = 2
AMMO_PISTOL = 3
AMMO_MAC10 = 4
AMMO_RIFLE = 5
AMMO_SHOTGUN = 7

-- Following are custom, intentionally out of ammo enum range
AMMO_CROWBAR = 50
AMMO_SIPISTOL = 51
AMMO_C4 = 52
AMMO_FLARE = 53
AMMO_KNIFE = 54
AMMO_M249 = 55
AMMO_M16 = 56
AMMO_DISCOMB = 57
AMMO_POLTER = 58
AMMO_TELEPORT = 59
AMMO_RADIO = 60
AMMO_DEFUSER = 61
AMMO_WTESTER = 62
AMMO_BEACON = 63
AMMO_HEALTHSTATION = 64
AMMO_MOLOTOV = 65
AMMO_SMOKE = 66
AMMO_BINOCULARS = 67
AMMO_PUSH = 68
AMMO_STUN = 69
AMMO_CSE = 70
AMMO_DECOY = 71
AMMO_GLOCK = 72

local WeaponNames

---
-- Returns a list of @{Weapon} names
-- @return table
-- @realm shared
function GetWeaponClassNames()
    if WeaponNames then
        return WeaponNames
    end

    local tbl = {}
    local weps = weapons.GetList()

    for i = 1, #weps do
        local v = weps[i]

        if v == nil or v.WeaponID == nil then
            continue
        end

        tbl[v.WeaponID] = WEPS.GetClass(v)
    end

    for _, v in pairs(scripted_ents.GetList()) do
        local id = istable(v) and (v.WeaponID or (v.t and v.t.WeaponID)) or nil
        if id == nil then
            continue
        end

        tbl[id] = WEPS.GetClass(v)
    end

    WeaponNames = tbl

    return WeaponNames
end

---
-- Reverse lookup from enum to SWEP table.
-- Returns a @{Weapon} based on the given ammo
-- @param number ammo
-- @return Weapon
-- @realm shared
function EnumToSWEP(ammo)
    local e2w = GetWeaponClassNames() or {}

    if e2w[ammo] then
        return util.WeaponForClass(e2w[ammo])
    else
        return
    end
end

---
-- Returns a @{Weapon}'s key based on the given ammo
-- @param number ammo
-- @param string key
-- @return any
-- @realm shared
function EnumToSWEPKey(ammo, key)
    local swep = EnumToSWEP(ammo)

    return swep and swep[key]
end

---
-- Something the client can display
-- This used to be done with a big table of AMMO_ ids to names, now we just use
-- the weapon PrintNames. This means it is no longer usable from the server (not
-- used there anyway), and means capitalization is slightly less pretty.
-- @param number ammo
-- @return any same as @{EnumToSWEPKey}
-- @realm shared
-- @see EnumToSWEPKey
function EnumToWep(ammo)
    return EnumToSWEPKey(ammo, "PrintName")
end

---
-- something cheap to send over the network
-- @param Weapon wep
-- @return string the @{Weapon} id
-- @realm shared
function WepToEnum(wep)
    if not IsValid(wep) then
        return
    end

    return wep.WeaponID
end
