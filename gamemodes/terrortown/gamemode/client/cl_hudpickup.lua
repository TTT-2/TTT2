---
-- @module PICKUP

local TryTranslation = LANG.TryTranslation
local IsValid = IsValid

PICKUP = {}
PICKUP.items = {}
PICKUP.last = 0

PICKUP_WEAPON = 0
PICKUP_ITEM = 1
PICKUP_AMMO = 2

local function InsertNewPickupItem()
    local pickup = {}
    pickup.time = CurTime()
    pickup.holdtime = 5
    pickup.fadein = 0.04
    pickup.fadeout = 0.3

    if PICKUP.last >= pickup.time then
        pickup.time = PICKUP.last + 0.05
    end

    PICKUP.items[#PICKUP.items + 1] = pickup

    PICKUP.last = pickup.time

    return pickup
end

---
-- Called when a  @{Weapon} has been picked up. Override to disable the default @{HUD} notification.
-- @param Weapon wep The picked up @{Weapon}
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:HUDWeaponPickedUp
-- @local
function GM:HUDWeaponPickedUp(wep)
    if not IsValid(wep) or wep.silentPickup then
        return
    end

    local client = LocalPlayer()

    if not IsValid(client) or not client:Alive() then
        return
    end

    local name = GetEquipmentTranslation(
        wep:GetClass(),
        (wep.GetPrintName and wep:GetPrintName()) or wep:GetClass()
    )

    local pickup = InsertNewPickupItem()
    pickup.name = string.upper(name)
    pickup.type = PICKUP_WEAPON
    pickup.kind = MakeKindValid(wep.Kind)
end

---
-- Called when an item has been picked up. Override to disable the default HUD notification.
-- @param string itemName Name of the picked up item
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:HUDItemPickedUp
-- @local
function GM:HUDItemPickedUp(itemName)
    local client = LocalPlayer()

    if not IsValid(client) or not client:Alive() then
        return
    end

    local pickup = InsertNewPickupItem()
    pickup.name = "#" .. itemName
    pickup.type = PICKUP_ITEM
end

---
-- Called when the client has picked up ammo. Override to disable default HUD notification.
-- @param string itemName Name of the item (ammo) picked up
-- @param number amount Amount of the item (ammo) picked up
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:HUDAmmoPickedUp
-- @local
function GM:HUDAmmoPickedUp(itemName, amount)
    local client = LocalPlayer()

    if not IsValid(client) or not client:Alive() then
        return
    end

    local itemname_trans = TryTranslation(string.lower("ammo_" .. itemName))

    local cachedPickups = PICKUP.items
    if cachedPickups then
        local localized_name = string.upper(itemname_trans)

        for k = 1, #cachedPickups do
            local v = cachedPickups[k]

            if v.name == localized_name and CurTime() - v.firstTime < 0.5 then
                v.amount = tostring(tonumber(v.amount) + amount)
                v.time = CurTime() - v.fadein

                return
            end
        end
    end

    local pickup = InsertNewPickupItem()
    pickup.firstTime = CurTime()
    pickup.name = string.upper(itemname_trans)
    pickup.amount = tostring(amount)
    pickup.type = PICKUP_AMMO
end

---
-- Removes outdated values from the PICKUP list
-- @realm client
-- @internal
function PICKUP.RemoveOutdatedValues()
    local cachedPickups = PICKUP.items
    local itemCount = #cachedPickups
    local j = 1

    for i = 1, itemCount do
        if not cachedPickups[i].remove then
            if i ~= j then
                -- Keep i's value, move it to j's pos.
                cachedPickups[j] = cachedPickups[i]
                cachedPickups[i] = nil
            end

            j = j + 1
        else
            cachedPickups[i] = nil
        end
    end
end
