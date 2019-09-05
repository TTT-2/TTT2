---
-- @section Inventory

net.Receive("TTT2CleanupInventory", function()
	local client = LocalPlayer()

	if IsValid(client) then
		client.refresh_inventory_cache = true
	end
end)

net.Receive("TTT2AddWeaponToInventory", function()
	local client = LocalPlayer()

	if IsValid(client) then
		client.refresh_inventory_cache = true
	end
end)

net.Receive("TTT2RemoveWeaponFromInventory", function()
	local client = LocalPlayer()

	if IsValid(client) then
		client.refresh_inventory_cache = true
	end
end)
