---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

SHOP = SHOP or {}

function SHOP.BuyEquipment(equipmentId)
	net.Start("TTT2OrderEquipment")
	net.WriteString(equipmentId)
	net.SendToServer()
end

function SHOP.GetAvailableCredits()
	local ply = LocalPlayer()

	return IsValid(ply) and ply.equipment_credits or -1
end
