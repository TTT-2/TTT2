net.Receive("TTT2CleanupInventory", function()
	CleanupInventory(LocalPlayer())
end)

net.Receive("TTT2AddWeaponToInventory", function()
	if IsValid(LocalPlayer()) then
		LocalPlayer().refresh_inventory_cache = true
	end
end)

net.Receive("TTT2RemoveWeaponFromInventory", function()
	if IsValid(LocalPlayer()) then
		LocalPlayer().refresh_inventory_cache = true
	end
end)