---
-- @section Inventory

ttt_include("sh_inventory")

---
-- Cleans the Inventory and sends a message to a @{Player}
-- @param Player ply
-- @realm server
function CleanupInventoryAndNotifyClient(ply)
    CleanupInventory(ply)

    net.Start("TTT2CleanupInventory")
    net.Send(ply)
end

---
-- Adds a @{Weapon} into the Inventory of a @{Player} and sends a message
-- @param Player ply
-- @param Weapon wep
-- @realm server
function AddWeaponToInventoryAndNotifyClient(ply, wep)
    AddWeaponToInventory(ply, wep)

    net.Start("TTT2AddWeaponToInventory")
    net.Send(ply)
end

-- Removes a @{Weapon} from the Inventory of a @{Player} and sends a message
-- @param Player ply
-- @param Weapon wep
-- @realm server
function RemoveWeaponFromInventoryAndNotifyClient(ply, wep)
    RemoveWeaponFromInventory(ply, wep)

    net.Start("TTT2RemoveWeaponFromInventory")
    net.Send(ply)
end
