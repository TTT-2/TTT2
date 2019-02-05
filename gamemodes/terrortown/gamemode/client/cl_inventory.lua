net.Receive("TTT2CleanupInventory", function()
	CleanupInventory(LocalPlayer())
end)

net.Receive("TTT2AddWeaponToInventory", function()
	local wep = net.ReadEntity()
	
	if IsValid(wep) and wep.Kind then
		AddWeaponToInventory(LocalPlayer(), wep)
	elseif IsValid(LocalPlayer()) then
		LocalPlayer().refresh_inventory_cache = true
	end
end)

net.Receive("TTT2RemoveWeaponFromInventory", function()
	local wep = net.ReadEntity()
	
	if IsValid(wep) and wep.Kind then
		RemoveWeaponFromInventory(LocalPlayer(), wep)
	elseif IsValid(LocalPlayer()) then
		LocalPlayer().refresh_inventory_cache = true
	end
end)