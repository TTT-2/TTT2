SWEP.Base = "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.AdminSpawnable = true
SWEP.AllowDrop = false

SWEP.Kind = WEAPON_EXTRA

if SERVER then
	AddCSLuaFile()
else
	SWEP.PrintName = "Armor"
	
	
	SWEP.Icon = "vgui/ttt/icon_armor"
	SWEP.EquipMenuData = {
		type = "Weapon",
		desc = "ttt2_weapon_armor_desc"
	}
end

SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

function SWEP:Equip(buyer)
	if SERVER then
		buyer:IncreaseArmor(30)
		self:Remove()
	end
end

-- REGISTER STATUS ICONS
if CLIENT then
	hook.Add("Initialize", "ttt2_base_register_armor_status", function() 
		STATUS:RegisterStatus("ttt_weapon_armor", {
			hud = {
				Material("vgui/ttt/perks/hud_armor.png"),
				Material("vgui/ttt/perks/hud_armor_reinforced.png")
			},
			type = "good"
		})
	end)
end