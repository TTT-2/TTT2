---
-- @class SWEP
-- @section weapon_ttt_smokegrenade

if SERVER then
	AddCSLuaFile()
end

local flags = {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}

---
-- @realm server
CreateConVar("ttt2_smokegrenade_proj_smoke_life_time", "60", flags)


SWEP.HoldType = "grenade"

if CLIENT then
	SWEP.PrintName = "grenade_smoke"
	SWEP.Slot = 3

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54

	SWEP.Icon = "vgui/ttt/icon_smokegrenade"
	SWEP.IconLetter = "Q"
end

SWEP.Base = "weapon_tttbasegrenade"

SWEP.WeaponID = AMMO_SMOKE
SWEP.builtin = true
SWEP.Kind = WEAPON_NADE
SWEP.spawnType = WEAPON_TYPE_NADE

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_eq_smokegrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Weight = 5
SWEP.AutoSpawnable = true
SWEP.Spawnable = true

---
-- really the only difference between grenade weapons: the model and the thrown ent.
-- @return string
-- @realm shared
function SWEP:GetGrenadeName()
	return "ttt_smokegrenade_proj"
end

if CLIENT then
	---
	-- @param Panel parent
	-- @realm client
	function SWEP:AddToSettingsMenu(parent)
		self.BaseClass.AddToSettingsMenu(self, parent)

		local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

		form:MakeHelp({
			label = "help_ttt2_smokegrenade_proj_smoke_life_time",
		})
		form:MakeSlider({
			serverConvar = "ttt2_smokegrenade_proj_smoke_life_time",
			label = "label_ttt2_smokegrenade_proj_smoke_life_time",
			min = 0,
			max = 300,
			decimal = 0,
		})
	end
end
