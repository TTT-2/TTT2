---
-- @section Inventory

net.Receive("TTT2CleanupInventory", function()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    client.refresh_inventory_cache = true
end)

net.Receive("TTT2AddWeaponToInventory", function()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    client.refresh_inventory_cache = true
end)

net.Receive("TTT2RemoveWeaponFromInventory", function()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    client.refresh_inventory_cache = true
end)
