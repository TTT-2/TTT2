---
-- @section weapon_manager

ttt_include("sh_weaponry") -- inits WEPS tbl

util.AddNetworkString("TTT2CleanupInventory")
util.AddNetworkString("TTT2AddWeaponToInventory")
util.AddNetworkString("TTT2RemoveWeaponFromInventory")
util.AddNetworkString("ttt2_switch_weapon_update_cache")

-- Weapon system, pickup limits, etc
local IsValid = IsValid
local table = table
local timer = timer
local hook = hook

local IsEquipment = WEPS.IsEquipment

---
-- @realm server
local cv_auto_pickup = CreateConVar("ttt_weapon_autopickup", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY })

---
-- @realm server
local cv_ttt_detective_hats =
    CreateConVar("ttt_detective_hats", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- Returns whether or not a @{Player} is allowed to pick up a @{Weapon}
-- @note Prevent @{Player}s from picking up multiple @{Weapon}s of the same type etc
-- @param Player ply The @{Player} attempting to pick up the @{Weapon}
-- @param Weapon wep The @{Weapon} entity in question
-- @param[opt] number dropBlockingWeapon should the weapon stored in the same slot be dropped
-- @param[opt] boolean isPickupProbe Set this to true to mark this hook run as probe
-- @return boolean Allowed pick up or not
-- @return number errorCode
-- 1 - Player is spectator
-- 2 - Player already has the same weapon
-- 3 - Player has no free slot available
-- 4 - Player disabled autopickup and it's not a forced weapon pickup
-- 5 - The weapon is a dropped equipment item and the Player didn't forced a pickup
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerCanPickupWeapon
-- @local
function GM:PlayerCanPickupWeapon(ply, wep, dropBlockingWeapon, isPickupProbe)
    if not IsValid(wep) or not IsValid(ply) then
        return
    end

    -- spectators are not allowed to pickup weapons
    if ply:IsSpec() and WEPS.GetClass(wep) ~= "weapon_ttt_spawneditor" then
        return false, 1
    end

    -- prevent picking up weapons of the same class a player already has (for ammo if auto-pickup is enabled)
    -- exception: this hook is called to check if a player can pick up weapon while dropping
    -- the current weapon
    if not dropBlockingWeapon and ply:HasWeapon(WEPS.GetClass(wep)) then
        return false, 2
    end

    -- block pickup when there is no slot free
    -- exception: this hook is called to check if a player can pick up weapon while dropping
    -- the current weapon
    if not dropBlockingWeapon and not InventorySlotFree(ply, wep.Kind) and not ply.forcedPickup then
        return false, 3
    end

    -- if the auto pickup convar is set to false, no weapons should be picked up automatically
    if not cv_auto_pickup:GetBool() and not ply.forcedPickup then
        return false, 4
    end

    -- if it is a dropped equipment item, it shouldn't be picked up automatically
    if IsEquipment(wep) and wep.IsDropped and not ply.forcedPickup then
        return false, 5
    end

    -- if the player has cached their inventory, weapons should not be picked up with the
    -- exception of weapons given by the ply:Give function
    if ply:HasCachedWeapons() and not ply.forcedGive then
        return false, 6
    end

    -- make sure that the weapon is moved to the player if it should be automatically picked
    -- up; this however should not happen for manual pickup and/or hook probing
    if cv_auto_pickup:GetBool() and not ply.forcedPickup and not isPickupProbe then
        local tr = util.TraceEntity({
            start = wep:GetPos(),
            endpos = ply:GetShootPos(),
            mask = MASK_SOLID,
        }, wep)

        if (tr.Fraction == 1.0 or tr.Entity == ply) and not tr.StartSolid then
            wep:SetPos(ply:GetShootPos())
        end
    end

    return true
end

-- Cache subrole -> default-weapons table
local loadout_weapons = {}

local function GetLoadoutWeapons(subrole)
    local tmpLoadoutWeps = loadout_weapons[subrole]

    if tmpLoadoutWeps then
        return tmpLoadoutWeps
    end

    tmpLoadoutWeps = {}

    local weps = weapons.GetList()

    for i = 1, #weps do
        local w = weps[i]

        if not istable(w.InLoadoutFor) or w.Duplicated then
            continue
        end

        local cls = WEPS.GetClass(w)

        if table.HasValue(w.InLoadoutFor, subrole) then
            if not table.HasValue(tmpLoadoutWeps, cls) then
                tmpLoadoutWeps[#tmpLoadoutWeps + 1] = cls
            end
        elseif table.HasValue(w.InLoadoutFor, ROLE_INNOCENT) then -- setup for new roles
            w.InLoadoutFor[#w.InLoadoutFor + 1] = subrole

            if not table.HasValue(tmpLoadoutWeps, cls) then
                tmpLoadoutWeps[#tmpLoadoutWeps + 1] = cls
            end
        end
    end

    -- default loadout, insert it at the end
    local default = {
        "weapon_zm_carry",
        "weapon_ttt_unarmed",
        "weapon_zm_improvised",
    }

    for i = 1, #default do
        local def = default[i]

        if table.HasValue(tmpLoadoutWeps, def) then
            continue
        end

        tmpLoadoutWeps[#tmpLoadoutWeps + 1] = def
    end

    loadout_weapons[subrole] = tmpLoadoutWeps

    ---
    -- @realm server
    hook.Run("TTT2ModifyDefaultLoadout", loadout_weapons, subrole)

    return loadout_weapons[subrole]
end

-- Give player loadout weapons he should have for his subrole that he does not have
-- yet
local function GiveLoadoutWeapon(ply, cls)
    if ply:HasWeapon(cls) or not ply:CanCarryType(WEPS.TypeForWeapon(cls)) then
        return
    end

    local wep = ply:Give(cls)

    ply.loadoutWeps = ply.loadoutWeps or {}

    if not table.HasValue(ply.loadoutWeps, cls) then
        ply.loadoutWeps[#ply.loadoutWeps + 1] = cls
    end

    return wep
end

local function GiveLoadoutWeapons(ply)
    local subrole = gameloop.GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetSubRole()
    local weps = GetLoadoutWeapons(subrole)

    if not weps then
        return
    end

    for i = 1, #weps do
        local cls = weps[i]

        if ply:HasWeapon(cls) or not ply:CanCarryType(WEPS.TypeForWeapon(cls)) then
            continue
        end

        GiveLoadoutWeapon(ply, cls)
    end
end

local function GetGiveLoadoutWeapons(ply)
    local subrole = gameloop.GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetSubRole()
    local weps = GetLoadoutWeapons(subrole)

    return table.Copy(weps)
end

local function GetResetLoadoutWeapons(ply)
    local tmp = {}

    ply.loadoutWeps = ply.loadoutWeps or {}

    local weps = ply:GetWeapons()

    for i = 1, #weps do
        local cls = WEPS.GetClass(weps[i])

        if table.HasValue(ply.loadoutWeps, cls) and cls ~= "weapon_ttt_unarmed" then
            tmp[#tmp + 1] = cls
        end
    end

    return tmp
end

local function HasLoadoutWeapons(ply)
    if ply:IsSpec() then
        return true
    end

    local subrole = gameloop.GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetSubRole()
    local weps = GetLoadoutWeapons(subrole)

    if not weps then
        return true
    end

    for i = 1, #weps do
        local cls = weps[i]

        if not ply:HasWeapon(cls) and ply:CanCarryType(WEPS.TypeForWeapon(cls)) then
            return false
        end
    end

    return true
end

-- Cache subrole -> default-items table
local loadout_items = {}

-- Get loadout items.
local function GetLoadoutItems(subrole)
    local tmpLoadoutItems = loadout_items[subrole]

    if tmpLoadoutItems then
        return tmpLoadoutItems
    end

    tmpLoadoutItems = {}

    local itms = items.GetList()

    for i = 1, #itms do
        local w = itms[i]

        if not istable(w.InLoadoutFor) or w.Duplicated then
            continue
        end

        local cls = w.id

        if table.HasValue(w.InLoadoutFor, subrole) then
            if not table.HasValue(tmpLoadoutItems, cls) then
                tmpLoadoutItems[#tmpLoadoutItems + 1] = cls
            end
        elseif table.HasValue(w.InLoadoutFor, ROLE_INNOCENT) then -- setup for new roles
            w.InLoadoutFor[#w.InLoadoutFor + 1] = subrole

            if not table.HasValue(tmpLoadoutItems, cls) then
                tmpLoadoutItems[#tmpLoadoutItems + 1] = cls
            end
        end
    end

    loadout_items[subrole] = tmpLoadoutItems

    ---
    -- @realm server
    hook.Run("TTT2ModifyDefaultLoadout", loadout_items, subrole)

    return loadout_items[subrole]
end

-- Give player loadout items he should have for his subrole that he does not have
-- yet
local function GiveLoadoutItem(ply, cls)
    if ply:HasEquipmentItem(cls) then
        return
    end

    local item = ply:GiveItem(cls)

    ply.loadoutItems = ply.loadoutItems or {}

    if not table.HasValue(ply.loadoutItems, cls) then
        ply.loadoutItems[#ply.loadoutItems + 1] = cls
    end

    return item
end

local function GiveLoadoutItems(ply)
    local subrole = gameloop.GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetSubRole()
    local itms = GetLoadoutItems(subrole)

    if not itms then
        return
    end

    for i = 1, #itms do
        local cls = itms[i]

        if ply:HasEquipmentItem(cls) then
            continue
        end

        GiveLoadoutItem(ply, cls)
    end
end

local function ResetLoadoutItems(ply)
    local itms = GetModifiedEquipment(ply, items.GetRoleItems(ply:GetSubRole()))
    if itms == nil then
        return
    end

    for i = 1, #itms do
        if not itms[i].loadout then
            continue
        end

        ply:RemoveItem(itms[i].id)
    end
end

---
-- Sometimes, in cramped map locations, giving players weapons fails. A timer
-- calling this function is used to get them the weapons anyway as soon as
-- possible.
local function LateLoadout(id)
    local ply = Entity(id)

    if not IsValid(ply) or not ply:IsPlayer() then
        timer.Remove("lateloadout" .. id)

        return
    end

    if not HasLoadoutWeapons(ply) then
        GiveLoadoutWeapons(ply)

        if HasLoadoutWeapons(ply) then
            timer.Remove("lateloadout" .. id)
        end
    else
        timer.Remove("lateloadout" .. id)
    end
end

---
-- Called to give @{Player}s the default set of @{Weapon}s.
-- @note This function may not work in your custom gamemode if you have overridden your
-- @{GM:PlayerSpawn} and you do not use self.BaseClass.PlayerSpawn or @{hook.Run}.
-- @param Player ply @{Player} to give @{Weapon}s to
-- @note Note that this is called both when a @{Player} spawns and when a round starts
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerLoadout
-- @local
function GM:PlayerLoadout(ply, isRespawn)
    if not IsValid(ply) or ply:IsSpec() then
        return
    end

    CleanupInventoryAndNotifyClient(ply)

    ResetLoadoutItems(ply)

    -- give default items
    GiveLoadoutItems(ply)

    -- reset default loadout
    local reset = GetResetLoadoutWeapons(ply)

    -- hand out weaponry
    local give = GetGiveLoadoutWeapons(ply)

    local tmp = {}

    -- check which weapon the player should get/loose
    for k = 1, #reset do
        local cls = reset[k]
        local has = false

        for k2 = 1, #give do
            if cls ~= give[k2] then
                continue
            end

            has = true

            table.remove(give, k2)

            break
        end

        if not has then
            tmp[#tmp + 1] = cls
        end
    end

    local loudoutWeps = ply.loadoutWeps

    for i = 1, #tmp do
        local cls = tmp[i]

        ply:StripWeapon(cls)

        for k = 1, #loudoutWeps do
            if cls ~= loudoutWeps[k] then
                continue
            end

            table.remove(loudoutWeps, k)

            break
        end
    end

    for i = 1, #give do
        GiveLoadoutWeapon(ply, give[i])
    end

    playermodels.RemovePlayerHat(ply)
    playermodels.ApplyPlayerHat(ply, function(p)
        local plyRoleData = ply:GetSubRoleData()

        return ply:IsActive()
            and plyRoleData.isPolicingRole
            and plyRoleData.isPublicRole
            and cv_ttt_detective_hats:GetBool()
            and playermodels.PlayerCanHaveHat(ply)
    end)

    if not HasLoadoutWeapons(ply) then
        Dev(1, "Could not spawn all loadout weapons for " .. ply:Nick() .. ", will retry.")

        local timerId = ply:EntIndex()

        timer.Create("lateloadout" .. timerId, 1, 0, function()
            LateLoadout(timerId)
        end)
    end
end

---
-- Called whenever all @{Player}s' loadout should update
-- @note this internally calls @{GM:PlayerLoadout} for every @{Player}
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerLoadout
function GM:UpdatePlayerLoadouts()
    local plys = player.GetAll()

    for i = 1, #plys do
        ---
        -- @realm server
        hook.Run("PlayerLoadout", plys[i], false)
    end
end

local function DropActiveWeapon(ply)
    if not IsValid(ply) then
        return
    end

    ply:SafeDropWeapon(ply:GetActiveWeapon(), false)
end
concommand.Add("ttt_dropweapon", DropActiveWeapon)
concommand.Add("ttt_dropammo", function(ply)
    if not IsValid(ply) then
        return
    end
    local wep = ply:GetActiveWeapon()
    ply:SafeDropAmmo(wep, false)
end)
concommand.Add("ttt_dropclip", function(ply)
    if not IsValid(ply) then
        return
    end

    ply:SafeDropAmmo(ply:GetActiveWeapon(), true)
end)

---
-- Called as a @{Weapon} entity is picked up by a @{Player}.<br />
-- See also @{GM:PlayerDroppedWeapon}
-- @note At the time when this hook is called @{Entity:GetOwner} will return NULL.
-- The owner is set on the next frame
-- @note This will not be called when picking up a @{Weapon} you already have as
-- the @{Weapon} will be removed and @{WEAPON:EquipAmmo} will be called instead
-- @note Protect against non-TTT @{Weapon}s that may break the HUD
-- @param Weapon wep The equipped @{Weapon}
-- @param Player ply The @{Player} that is picking up the @{Weapon}
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:WeaponEquip
-- @local
function GM:WeaponEquip(wep, ply)
    if not IsValid(ply) or not IsValid(wep) then
        return
    end

    if not wep.Kind then
        wep:Remove() -- only remove if they lack critical stuff

        ErrorNoHaltWithStack(
            "Equipped weapon " .. wep:GetClass() .. " is not compatible with TTT\n"
        )

        return
    end

    AddWeaponToInventoryAndNotifyClient(ply, wep)

    local function WeaponEquipNextFrame()
        if not IsValid(ply) or not IsValid(wep) then
            return
        end

        -- autoselect weapon when the new weapon has the same slot than the old one
        -- do not autoselect when ALT is pressed
        if wep.wpickup_autoSelect then
            wep.wpickup_autoSelect = nil

            ply:SelectWeapon(WEPS.GetClass(wep))
        end

        -- there is a glitch that picking up a weapon does not refresh the weapon cache on
        -- the client. Therefore the client has to be notified to updated its cache
        net.Start("ttt2_switch_weapon_update_cache")
        net.Send(ply)
    end

    -- handle all this stuff in the next frame since the owner is not yet valid
    timer.Simple(0, WeaponEquipNextFrame)
end

---
-- Called when a @{Weapon} is dropped by a @{Player} via @{Player:DropWeapon}.<br />
-- See also @{GM:WeaponEquip} for a hook when a @{Player} picks up a @{Weapon}.<br />
-- The @{Weapon}'s @{Entity:GetOwner} will be NULL at the time this hook is called.
-- @{Weapon:OnDrop} will be called before this hook is.
-- @param Player ply The @{Player} who owned this @{Weapon} before it was dropped
-- @param Weapon wep The @{Weapon} that was dropped
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerDroppedWeapon
-- @local
function GM:PlayerDroppedWeapon(ply, wep)
    if not IsValid(wep) or not IsValid(ply) or not wep.Kind then
        return
    end

    if wep.name_timer_pos then
        timer.Remove(wep.name_timer_pos)
    end

    if wep.name_timer_cancel then
        timer.Remove(wep.name_timer_cancel)
    end

    RemoveWeaponFromInventoryAndNotifyClient(ply, wep)

    -- there is a glitch that picking up a weapon does not refresh the weapon cache on
    -- the client. Therefore the client has to be notified to update its cache
    net.Start("ttt2_switch_weapon_update_cache")
    net.Send(ply)
end

---
-- Called right before the removal of an entity.
-- @param Entity ent @{Entity} being removed
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:EntityRemoved
-- @local
function GM:EntityRemoved(ent)
    if IsValid(ent) and IsValid(ent:GetOwner()) and ent:IsWeapon() and ent.Kind then
        RemoveWeaponFromInventoryAndNotifyClient(ent:GetOwner(), ent)
    end
end

---
-- @module WEPS

---
-- Called whenever a @{Player} drops a @{Weapon}, e.g. on death
-- @param Player ply The player whose weapon is about to be dropped
-- @param Weapon wep The weapon that is about to be dropped
-- @param boolean deathDrop Set to true if this is a drop on death
-- @param boolean keepSelection If set to true the current selection is kept if not dropped
-- @realm server
function WEPS.DropNotifiedWeapon(ply, wep, deathDrop, keepSelection)
    if not IsValid(ply) or not IsValid(wep) then
        return
    end

    -- Tag the weapon as having been dropped due to a player death so that
    -- we can prevent it from dropping if we want.
    wep.IsDroppedBecauseDeath = deathDrop

    -- Hack to tell the weapon it's about to be dropped and should do what it
    -- must right now
    if wep.PreDrop then
        wep:PreDrop(deathDrop)
    end

    -- PreDrop might destroy weapon
    if not IsValid(wep) then
        return
    end

    -- Tag this weapon as dropped, so that if it's a special weapon we do not
    -- auto-pickup when nearby.
    wep.IsDropped = true

    -- After dropping a weapon, always switch to holstered, so that traitors
    -- will never accidentally pull out a traitor weapon.
    --
    -- Perform this *before* the drop in order to abuse the fact that this
    -- holsters the weapon, which in turn aborts any reload that's in
    -- progress. We don't want a dropped weapon to be in a reloading state
    -- because the relevant timer is reset when picking it up, making the
    -- reload happen instantly. This allows one to dodge the delay by dropping
    -- during reload. All of this is a workaround for not having access to
    -- CBaseWeapon::AbortReload() (and that not being handled in
    -- CBaseWeapon::Drop in the first place).
    if not keepSelection then
        ply:SelectWeapon("weapon_ttt_unarmed")
    end

    if deathDrop and wep.overrideDropOnDeath == DROP_ON_DEATH_TYPE_DENY then
        wep:Remove()
        return
    end

    ply:DropWeapon(wep)

    wep:PhysWake()

    -- Unset this, because we can't use it after this point.
    wep.IsDroppedBecauseDeath = nil
end

---
-- Forces a @{Model} pre-cache for each @{Weapon}
-- @note non-cheat developer commands can reveal precaching the first time equipment
-- is bought, so trigger it at the start of a round instead
-- @realm server
function WEPS.ForcePrecache()
    local weps = weapons.GetList()

    for i = 1, #weps do
        local w = weps[i]

        if w.WorldModel then
            util.PrecacheModel(w.WorldModel)
        end

        if w.ViewModel then
            util.PrecacheModel(w.ViewModel)
        end
    end
end

---
-- @param string cls
-- @return boolean
-- @realm server
function WEPS.IsInstalled(cls)
    local weps = weapons.GetList()

    for i = 1, #weps do
        if weps[i].ClassName == cls then
            return true
        end
    end

    return false
end

---
-- Use this hook to modify the default loadout of a role.
-- @note It is recommended to use the function @{ROLE:GiveRoleLoadout} to give a role
-- the loadout if you are the creator of the role yourself.
-- @param table loadout A table with @{ITEM}s or @{WEAPON}s that can be modified
-- @param number role The role indentifier
-- @hook
-- @realm server
function GM:TTT2ModifyDefaultLoadout(loadout, role) end

---
-- Used to modifiy or block the amount of ammo dropped.
-- @param Player ply The player that tries to drop ammo
-- @param table amountTbl The table where the amount is stored, it can be modified
-- @return nil|boolean Return false to prevent the drop of the ammo
-- @hook
-- @realm server
function GM:TTT2DropAmmo(ply, amountTbl) end
