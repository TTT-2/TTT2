---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

SHOP = SHOP or {}

---
-- Buys the equipment with the corresponding Id
-- @param string equipmentId The name of the equipment to buy
-- @realm client
function SHOP.BuyEquipment(equipmentId)
	net.Start("TTT2OrderEquipment")
	net.WriteString(equipmentId)
	net.SendToServer()
end

---
-- Get available credits of the local player
-- @realm client
function SHOP.GetAvailableCredits()
	local ply = LocalPlayer()

	return IsValid(ply) and ply.equipment_credits or -1
end
