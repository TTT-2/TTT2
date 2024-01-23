---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

shop = shop or {}

local function ResetTeambuyEquipment()
	local team = net.ReadString()

	shop.ResetTeamBuy(LocalPlayer(), team)
end
net.Receive("TTT2ResetTBEq", ResetTeambuyEquipment)

local function ReceiveTeambuyEquipment()
	local equipmentId = net.ReadString()

	shop.SetEquipmentTeamBought(LocalPlayer(), equipmentId)
end
net.Receive("TTT2ReceiveTBEq", ReceiveTeambuyEquipment)

local function ReceiveGlobalbuyEquipment()
	local equipmentId = net.ReadString()

	shop.SetEquipmentGlobalBought(equipmentId)
end
net.Receive("TTT2ReceiveGBEq", ReceiveGlobalbuyEquipment)
