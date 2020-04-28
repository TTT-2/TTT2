if SERVER then
	AddCSLuaFile()
end

ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_speedrun",
	desc = "item_speedrun_desc"
}
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
ITEM.limited = false

ITEM.material = "vgui/ttt/icon_speedrun"

if SERVER then
	function ITEM:Equip(buyer)
		buyer:GiveSpeedMultiplier(1.5)
	end

	function ITEM:Reset(buyer)
		buyer:RemoveSpeedMultiplier(1.5)
	end
end
