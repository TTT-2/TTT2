if SERVER then
	AddCSLuaFile()
end

ITEM.hud = Material("vgui/ttt/perks/hud_radar.png")
ITEM.EquipMenuData = {
	type = "item_active",
	name = "item_radar",
	desc = "item_radar_desc"
}
ITEM.material = "vgui/ttt/icon_radar"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
ITEM.oldId = EQUIP_RADAR or 2

function ITEM:Equip(buyer)
	if SERVER then
		RADAR.Init(buyer)
	end
end

function ITEM:Reset(buyer)
	if SERVER then
		RADAR.Deinit(buyer)
	end

	buyer.radar_charge = 0
end
