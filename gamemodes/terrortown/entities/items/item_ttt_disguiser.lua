if SERVER then
	AddCSLuaFile()
end

ITEM.Base = "item_base"

ITEM.Icon = "vgui/ttt/icon_disguise"
ITEM.EquipMenuData = {
	type = "item_active",
	name = "item_disg",
	desc = "item_disg_desc"
}
ITEM.CanBuy = {ROLE_TRAITOR}
