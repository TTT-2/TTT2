ttt_include("sh_inventory")

function CleanupInventoryAndNotifyClient(ply)
	CleanupInventory(ply)
	net.Start("TTT2CleanupInventory")
	net.Send(ply)
end

function AddWeaponToInventoryAndNotifyClient(ply, wep)
	AddWeaponToInventory(ply, wep)
	net.Start("TTT2AddWeaponToInventory")
	net.WriteEntity(wep)
	net.Send(ply)
end

function RemoveWeaponFromInventoryAndNotifyClient(ply, wep)
	RemoveWeaponFromInventory(ply, wep)
	net.Start("TTT2RemoveWeaponFromInventory")
	net.WriteEntity(wep)
	net.Send(ply)
end