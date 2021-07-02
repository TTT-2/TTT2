---
-- This is the <code>WEPS</code> module
-- @author BadKingUrgrain
-- @author Alf21
-- @author LeBroomer
-- @module WEPS

WEPS = {}

local IsValid = IsValid
local wepGetList = weapons.GetList

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

function WEPS.GetWeaponsForSpawnTypes()
	local wepsForSpawns = {}
	local wepsTable = {}
	local weps = wepGetList()

	for i = 1, #weps do
		local wep = weps[i]
		local spawnType = wep.spawnType

		if not wep.AutoSpawnable or not spawnType then continue end

		wepsForSpawns[spawnType] = wepsForSpawns[spawnType] or {}

		wepsForSpawns[spawnType][#wepsForSpawns[spawnType] + 1] = wep
		wepsTable[#wepsTable + 1] = wep
	end

	return wepsForSpawns, wepsTable
end

---
-- Toggles the <code>disguised</code>
-- @param Player ply
-- @realm shared
function WEPS.DisguiseToggle(ply)
	if not IsValid(ply) or not ply:IsActiveTraitor() then return end

	if not ply:GetNWBool("disguised", false) then
		RunConsoleCommand("ttt_set_disguise", "1")
	else
		RunConsoleCommand("ttt_set_disguise", "0")
	end
end
concommand.Add("ttt_toggle_disguise", WEPS.DisguiseToggle)
