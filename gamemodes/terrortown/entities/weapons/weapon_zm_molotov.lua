---
-- @class SWEP
-- @section weapon_zm_molotov

if SERVER then
	AddCSLuaFile()
end

local flags = {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}

---
-- @realm server
CreateConVar("ttt2_firegrenade_proj_explosion_radius", "256", flags)

---
-- @realm server
CreateConVar("ttt2_firegrenade_proj_explosion_damage", "25", flags)

---
-- @realm server
CreateConVar("ttt2_firegrenade_proj_fire_num", "10", flags)

---
-- @realm server
CreateConVar("ttt2_firegrenade_proj_fire_lifetime", "20", flags)

SWEP.HoldType = "grenade"

if CLIENT then
	SWEP.PrintName = "grenade_fire"
	SWEP.Slot = 3

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54

	SWEP.Icon = "vgui/ttt/icon_firegrenade"
	SWEP.IconLetter = "P"
end

SWEP.Base = "weapon_tttbasegrenade"

SWEP.Kind = WEAPON_NADE
SWEP.WeaponID = AMMO_MOLOTOV
SWEP.builtin = true
SWEP.spawnType = WEAPON_TYPE_NADE

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"

SWEP.Weight = 5
SWEP.AutoSpawnable = true
SWEP.Spawnable = true

---
-- really the only difference between grenade weapons: the model and the thrown ent.
-- @return string
-- @realm shared
function SWEP:GetGrenadeName()
	return "ttt_firegrenade_proj"
end

---
-- @ignore
function SWEP:CreateGrenade(...)
	local grenade = self.BaseClass.CreateGrenade(self, ...)
	grenade:SetDmg(GetConVar("ttt2_firegrenade_proj_explosion_damage"):GetFloat() * (self.damageScaling or 1))
	return grenade
end

if CLIENT then
	---
	-- @param Panel parent
	-- @realm client
	function SWEP:AddToSettingsMenu(parent)
		self.BaseClass.AddToSettingsMenu(self, parent)

		local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

		form:MakeHelp({
			label = "help_ttt2_firegrenade_proj_explosion_radius",
		})
		form:MakeSlider({
			serverConvar = "ttt2_firegrenade_proj_explosion_radius",
			label = "label_ttt2_firegrenade_proj_explosion_radius",
			min = 0,
			max = 2048,
			decimal = 0,
		})

		form:MakeHelp({
			label = "help_ttt2_firegrenade_proj_explosion_damage",
		})
		form:MakeSlider({
			serverConvar = "ttt2_firegrenade_proj_explosion_damage",
			label = "label_ttt2_firegrenade_proj_explosion_damage",
			min = 0,
			max = 200,
			decimal = 0,
		})

		form:MakeHelp({
			label = "help_ttt2_firegrenade_proj_fire_num",
		})
		form:MakeSlider({
			serverConvar = "ttt2_firegrenade_proj_fire_num",
			label = "label_ttt2_firegrenade_proj_fire_num",
			min = 0,
			max = 32,
			decimal = 0,
		})

		form:MakeHelp({
			label = "help_ttt2_firegrenade_proj_fire_lifetime",
		})
		form:MakeSlider({
			serverConvar = "ttt2_firegrenade_proj_fire_lifetime",
			label = "label_ttt2_firegrenade_proj_fire_lifetime",
			min = 0,
			max = 300,
			decimal = 0,
		})
	end
end
