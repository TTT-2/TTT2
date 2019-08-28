if SERVER then
	AddCSLuaFile()
end

ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_armor",
	desc = "item_armor_desc"
}

ITEM.material = "vgui/ttt/icon_armor"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
ITEM.oldId = EQUIP_ARMOR or 1
ITEM.limited = false

function ITEM:Equip(buyer)
	if SERVER then
		buyer:IncreaseArmor(GetConVar("ttt_armor_buy_value"):GetInt())
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