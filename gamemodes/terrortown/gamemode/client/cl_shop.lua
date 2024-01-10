---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

shop = shop or {}

---
-- Buys the equipment with the corresponding Id
-- @param string equipmentId The name of the equipment to buy
-- @realm client
function shop.BuyEquipment(equipmentId)
	net.Start("TTT2OrderEquipment")
	net.WriteString(equipmentId)
	net.SendToServer()
end

---
-- Get available credits of the local player
-- @return number The number of credits available
-- @realm client
function shop.GetAvailableCredits()
	local client = LocalPlayer()

	return IsValid(client) and client.equipment_credits or -1
end
