---
-- This is the <code>WEPS</code> module
-- @module WEPS
-- @author BadKingUrgrain
-- @author Alf21
-- @author LeBroomer
WEPS = {}

local IsValid = IsValid

---
-- Get the type (<code>kind</code>) of a weapon class
-- @param string class weapon class
-- @return boolean weapon type (<code>kind</code>)
function WEPS.TypeForWeapon(class)
	local tbl = util.WeaponForClass(class)

	return tbl and tbl.Kind or WEAPON_NONE
end

---
-- Checks whether the table is a valid equipment (weapon)
-- @param table wep table that needs to be checked
-- @return boolean whether the table is a valid equipment (weapon)
function WEPS.IsEquipment(wep)
	return wep and wep.Kind and wep.Kind >= WEAPON_EQUIP
end

---
-- Get the class of the weapon
-- @param Weapon wep
-- @return nil|string weapon's class
function WEPS.GetClass(wep)
	if istable(wep) then
		return wep.ClassName or wep.Classname or wep.id or wep.name
	elseif IsValid(wep) then
		return wep:GetClass()
	end
end

---
-- Toggles the <code>disguised</code>
-- @param Player ply
function WEPS.DisguiseToggle(ply)
	if not IsValid(ply) or not ply:IsActiveTraitor() then return end

	if not ply:GetNWBool("disguised", false) then
		RunConsoleCommand("ttt_set_disguise", "1")
	else
		RunConsoleCommand("ttt_set_disguise", "0")
	end
end
concommand.Add("ttt_toggle_disguise", WEPS.DisguiseToggle)
