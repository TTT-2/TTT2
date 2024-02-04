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
	local equipmentName = net.ReadString()

	shop.SetEquipmentTeamBought(LocalPlayer(), equipmentName)
end
net.Receive("TTT2ReceiveTBEq", ReceiveTeambuyEquipment)

local function ReceiveGlobalbuyEquipment()
	local equipmentName = net.ReadString()

	shop.SetEquipmentGlobalBought(equipmentName)
end
net.Receive("TTT2ReceiveGBEq", ReceiveGlobalbuyEquipment)
