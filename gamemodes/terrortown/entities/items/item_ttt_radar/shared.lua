if SERVER then
	AddCSLuaFile()
end

ITEM.Icon = "vgui/ttt/icon_radar"
ITEM.EquipMenuData = {
	type = "item_active",
	name = "item_radar",
	desc = "item_radar_desc"
}
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
