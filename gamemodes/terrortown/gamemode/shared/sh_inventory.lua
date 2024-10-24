---
-- @section Inventory

if SERVER then
    ---
    -- @realm server
    local maxMeleeSlots = CreateConVar(
        "ttt2_max_melee_slots",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Maximum amount of melee weapons, a player can carry (-1 = infinite)"
    )

    ---
    -- @realm server
    local maxSecondarySlots = CreateConVar(
        "ttt2_max_secondary_slots",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Maximum amount of secondary weapons, a player can carry (-1 = infinite)"
    )

    ---
    -- @realm server
    local maxPrimarySlots = CreateConVar(
        "ttt2_max_primary_slots",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Maximum amount of primary weapons, a player can carry (-1 = infinite)"
    )

    ---
    -- @realm server
    local maxNadeSlots = CreateConVar(
        "ttt2_max_nade_slots",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Maximum amount of grenades, a player can carry (-1 = infinite)"
    )

    ---
    -- @realm server
    local maxCarrySlots = CreateConVar(
        "ttt2_max_carry_slots",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Maximum amount of carry tools, a player can carry (-1 = infinite)"
    )

    ---
    -- @realm server
    local maxUnarmedSlots = CreateConVar(
        "ttt2_max_unarmed_slots",
        "1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Maximum amount of unarmed slots, a player can have (-1 = infinite)"
    )

    ---
    -- @realm server
    local maxSpecialSlots = CreateConVar(
        "ttt2_max_special_slots",
        "2",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Maximum amount of special weapons, a player can carry (-1 = infinite)"
    )

    ---
    -- @realm server
    local maxExtraSlots = CreateConVar(
        "ttt2_max_extra_slots",
        "-1",
        { FCVAR_NOTIFY, FCVAR_ARCHIVE },
        "Maximum amount of extra weapons, a player can carry (-1 = infinite)"
    )

    hook.Add("TTT2SyncGlobals", "AddInventoryGlobals", function()
        SetGlobalInt(maxMeleeSlots:GetName(), maxMeleeSlots:GetInt())
        SetGlobalInt(maxSecondarySlots:GetName(), maxSecondarySlots:GetInt())
        SetGlobalInt(maxPrimarySlots:GetName(), maxPrimarySlots:GetInt())
        SetGlobalInt(maxNadeSlots:GetName(), maxNadeSlots:GetInt())
        SetGlobalInt(maxCarrySlots:GetName(), maxCarrySlots:GetInt())
        SetGlobalInt(maxUnarmedSlots:GetName(), maxUnarmedSlots:GetInt())
        SetGlobalInt(maxSpecialSlots:GetName(), maxSpecialSlots:GetInt())
        SetGlobalInt(maxExtraSlots:GetName(), maxExtraSlots:GetInt())
        SetGlobalInt("ttt2_max_class_slots", -1)
    end)

    cvars.AddChangeCallback(maxMeleeSlots:GetName(), function(name, old, new)
        SetGlobalInt(name, tonumber(new))
    end, "TTT2MaxMeleeSlotsChange")

    cvars.AddChangeCallback(maxSecondarySlots:GetName(), function(name, old, new)
        SetGlobalInt(name, tonumber(new))
    end, "TTT2MaxSecondarySlotsChange")

    cvars.AddChangeCallback(maxPrimarySlots:GetName(), function(name, old, new)
        SetGlobalInt(name, tonumber(new))
    end, "TTT2MaxPrimarySlotsChange")

    cvars.AddChangeCallback(maxNadeSlots:GetName(), function(name, old, new)
        SetGlobalInt(name, tonumber(new))
    end, "TTT2MaxNadeSlotsChange")

    cvars.AddChangeCallback(maxCarrySlots:GetName(), function(name, old, new)
        SetGlobalInt(name, tonumber(new))
    end, "TTT2MaxCarrySlotsChange")

    cvars.AddChangeCallback(maxUnarmedSlots:GetName(), function(name, old, new)
        SetGlobalInt(name, tonumber(new))
    end, "TTT2MaxUnarmedSlotsChange")

    cvars.AddChangeCallback(maxSpecialSlots:GetName(), function(name, old, new)
        SetGlobalInt(name, tonumber(new))
    end, "TTT2MaxSpecialSlotsChange")

    cvars.AddChangeCallback(maxExtraSlots:GetName(), function(name, old, new)
        SetGlobalInt(name, tonumber(new))
    end, "TTT2MaxExtraSlotsChange")
end

ORDERED_SLOT_TABLE = {
    [WEAPON_MELEE] = "ttt2_max_melee_slots",
    [WEAPON_PISTOL] = "ttt2_max_secondary_slots",
    [WEAPON_HEAVY] = "ttt2_max_primary_slots",
    [WEAPON_NADE] = "ttt2_max_nade_slots",
    [WEAPON_CARRY] = "ttt2_max_carry_slots",
    [WEAPON_UNARMED] = "ttt2_max_unarmed_slots",
    [WEAPON_SPECIAL] = "ttt2_max_special_slots",
    [WEAPON_EXTRA] = "ttt2_max_extra_slots",
    [WEAPON_CLASS] = "ttt2_max_class_slots",
}

---
-- Returns a valid kind
-- @param number kind
-- @return number valid kind
-- @realm shared
function MakeKindValid(kind)
    if not kind or kind > WEAPON_CLASS or kind < WEAPON_MELEE then
        return WEAPON_EXTRA
    else
        return kind
    end
end

---
-- Cleans the Inventory if it's dirty
-- @note we appeareantly need to have that, because added and removed entities are sometimes broken on client side and need to get updated later
-- additionally spawn can be called when a player is alive in which case he doesn't loose weapons beforehand
-- @param Player ply
-- @realm shared
function CleanupInventoryIfDirty(ply)
    if ply.inventory and not ply.refresh_inventory_cache then
        return
    end

    CleanupInventory(ply)
end

---
-- Cleans the Inventory
-- @param Player ply
-- @realm shared
function CleanupInventory(ply)
    if not IsValid(ply) then
        return
    end

    ply.refresh_inventory_cache = false
    ply.inventory = {}

    for k in pairs(ORDERED_SLOT_TABLE) do
        ply.inventory[k] = {}
    end

    -- add weapons which are already in inventory
    local weaponsInInventory = 0
    local weps = ply:GetWeapons()

    for i = 1, #weps do
        if not weps[i].Kind then
            continue
        end

        AddWeaponToInventory(ply, weps[i])

        weaponsInInventory = weaponsInInventory + 1
    end

    -- no valid weapons found (try again)
    if weaponsInInventory == 0 then
        ply.refresh_inventory_cache = true
    end
end

---
-- Returns whether an inventory slot is free
-- @param Player ply
-- @param number kind
-- @return boolean
-- @realm shared
function InventorySlotFree(ply, kind)
    if not IsValid(ply) then
        return false
    end

    CleanupInventoryIfDirty(ply)

    local invSlot = MakeKindValid(kind)
    local slotCount = GetGlobalInt(ORDERED_SLOT_TABLE[invSlot])

    return slotCount < 0 or #ply.inventory[invSlot] < slotCount
end

SWITCHMODE_PICKUP = 0
SWITCHMODE_SWITCH = 1
SWITCHMODE_FULLINV = 2
SWITCHMODE_NOSPACE = 3

---
-- A simple handler to get the weapon blocking a new weapon from beeing picked up
-- @param Player ply The player that should receive the newly added weapon (in the inventory)
-- @param Weapon wep The new weapon that should be added to the player inventory
-- @return Weapon The blocking weapon
-- @return boolean Is the thrown weapon the currently active weapon
-- @return boolean The switchmode
-- @realm shared
function GetBlockingWeapon(ply, wep)
    -- start the drop weapon check by checking the active weapon
    local activeWeapon = ply:GetActiveWeapon()
    local throwWeapon, switchMode

    local tr = util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 32, ply)

    -- if there is no room to drop the weapon, the pickup should be prohibited
    if tr.HitWorld then
        throwWeapon = nil
        switchMode = SWITCHMODE_NOSPACE

    -- if the player already has this weapon class, the weapon has to be dropped
    elseif ply:HasWeapon(WEPS.GetClass(wep)) then
        throwWeapon = ply:GetWeapon(WEPS.GetClass(wep))
        switchMode = SWITCHMODE_SWITCH

    -- if the player has a slot free while also not yet having this weapon class
    elseif InventorySlotFree(ply, wep.Kind) then
        throwWeapon = nil
        switchMode = SWITCHMODE_PICKUP

    -- if the player has already a weapon with the same class selected - drop this one
    elseif IsValid(activeWeapon) and activeWeapon.AllowDrop and activeWeapon.Kind == wep.Kind then
        throwWeapon = activeWeapon
        switchMode = SWITCHMODE_SWITCH

    -- try to find a dropable weapon in the selected slot
    else
        local weps = ply.inventory[MakeKindValid(wep.Kind)]
        switchMode = SWITCHMODE_FULLINV

        -- get droppable weapon from given slot
        for i = 1, #weps do
            local wep_iter = weps[i]

            -- found a weapon that is allowed to be dropped
            if IsValid(wep_iter) and wep_iter.AllowDrop then
                throwWeapon = wep_iter
                switchMode = SWITCHMODE_SWITCH

                break
            end
        end
    end

    -- now make sure the selected weapon is valid and dropable
    if IsValid(throwWeapon) and not throwWeapon.AllowDrop then
        throwWeapon = nil
        switchMode = SWITCHMODE_FULLINV
    end

    return throwWeapon, throwWeapon == activeWeapon, switchMode
end

---
-- Adds a @{Weapon} into the Inventory
-- @param Player ply
-- @param Weapon wep
-- @return boolean whether it was successful
-- @realm shared
function AddWeaponToInventory(ply, wep)
    if not IsValid(ply) then
        return false
    end

    CleanupInventoryIfDirty(ply)

    local invSlot = MakeKindValid(wep.Kind)

    ply.inventory[invSlot][#ply.inventory[invSlot] + 1] = wep

    return true
end

---
-- Removes a @{Weapon} from the Inventory
-- @param Player ply
-- @param Weapon wep
-- @return boolean whether it was successful
-- @realm shared
function RemoveWeaponFromInventory(ply, wep)
    if not IsValid(ply) then
        return false
    end

    CleanupInventoryIfDirty(ply)

    local invSlot = MakeKindValid(wep.Kind)

    table.RemoveByValue(ply.inventory[invSlot], wep)

    return true
end
