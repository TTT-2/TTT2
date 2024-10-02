---
-- We need our own weapon switcher because the hl2 one skips empty weapons
-- @class WSWITCH

local pairs = pairs
local IsValid = IsValid

WSWITCH = {
    Show = false,
    Selected = -1,
    NextSwitch = -1,
    WeaponCache = {},

    cv = {
        ---
        -- @realm client
        hide = CreateConVar("ttt_weaponswitcher_hide", "1", FCVAR_ARCHIVE),

        ---
        -- @realm client
        fast = CreateConVar("ttt_weaponswitcher_fast", "0", FCVAR_ARCHIVE),

        ---
        -- @realm client
        display = CreateConVar("ttt_weaponswitcher_displayfast", "0", FCVAR_ARCHIVE),
    },
}

local delay = 0.03
local showtime = 3

local function InsertIfValid(dest, wep)
    if not IsValid(wep) then
        return
    end

    dest[#dest + 1] = wep
end

---
-- Updates the weapon cache
-- @realm client
function WSWITCH:UpdateWeaponCache()
    local client = LocalPlayer()

    if not IsValid(client) then
        return
    end

    self.WeaponCache = {}

    local inventory = client:GetInventory()

    for kind = 1, #ORDERED_SLOT_TABLE do
        for _, wep in pairs(inventory[kind]) do
            InsertIfValid(self.WeaponCache, wep)
        end
    end
end

---
-- Sets the current index of the weapon switch and updates the weapon cache
-- @note If you just wanna select a already carried @{Weapon}, you should
-- use @{WSWITCH:DoSelect} instead
-- @param number idx the new index
-- @realm client
-- @see WSWITCH:DoSelect
function WSWITCH:SetSelected(idx)
    self.Selected = idx

    self:UpdateWeaponCache()
end

---
-- Increases the current index of the weapon switch
-- @realm client
function WSWITCH:SelectNext()
    if self.NextSwitch > CurTime() then
        return
    end

    self:Enable()

    local s = self.Selected + 1

    if s > #self.WeaponCache then
        s = 1
    end

    self:DoSelect(s)

    self.NextSwitch = CurTime() + delay
end

---
-- Decreases the current index of the weapon switch
-- @realm client
function WSWITCH:SelectPrev()
    if self.NextSwitch > CurTime() then
        return
    end

    self:Enable()

    local s = self.Selected - 1
    if s < 1 then
        s = #self.WeaponCache
    end

    self:DoSelect(s)

    self.NextSwitch = CurTime() + delay
end

---
-- Set the current index of the weapon switch
-- @note If you wanna select a new picked up @{Weapon},
-- you should use @{WSWITCH:SetSelected} instead
-- @param number idx the new index
-- @realm client
-- @see WSWITCH:SetSelected
function WSWITCH:DoSelect(idx)
    self:SetSelected(idx)

    if self.cv.fast:GetBool() then
        -- immediately confirm if fastswitch is on
        self:ConfirmSelection(self.cv.display:GetBool())
    end
end

---
-- Select a specific slot. Numeric key access to direct slots.
-- @param number slot
-- @realm client
function WSWITCH:SelectSlot(slot)
    if not slot then
        return
    end

    self:Enable()
    self:UpdateWeaponCache()

    -- find which idx in the weapon table has the slot we want
    local toselect = self.Selected
    local activeWeapon = LocalPlayer():GetActiveWeapon()
    local cache = self.WeaponCache
    local cacheCount = #cache
    local activeSlot = 1

    -- if the current weapon is active
    -- and the current weapon is in the same slot as the requested slot
    if IsValid(activeWeapon) and MakeKindValid(activeWeapon.Kind) == slot then
        activeSlot = toselect + 1 -- start with index of the next weapon

        -- reset index if it's bigger than available weapons or the weapon at this index isn't at the same slot
        if activeSlot > cacheCount or MakeKindValid(cache[activeSlot].Kind) ~= slot then
            activeSlot = 1
        end
    end

    -- do the weapon switch to the selected slot
    for i = activeSlot, cacheCount do
        if MakeKindValid(cache[i].Kind) == slot then
            toselect = i

            break
        end
    end

    self:DoSelect(toselect)

    self.NextSwitch = CurTime() + delay
end

---
-- Show the weapon switcher
-- @realm client
function WSWITCH:Enable()
    if self.Show == false then
        self.Show = true

        local wep_active = LocalPlayer():GetActiveWeapon()

        self:UpdateWeaponCache()

        -- make our active weapon the initial selection
        local toselect = 1
        local cachedWeapons = self.WeaponCache

        for k = 1, #cachedWeapons do
            if cachedWeapons[k] == wep_active then
                toselect = k

                break
            end
        end

        self:SetSelected(toselect)
    end

    -- cache for speed, checked every Think
    self.Stay = not self.cv.hide:GetBool()
end

---
-- Hide the weapon switcher
-- @realm client
function WSWITCH:Disable()
    self.Show = false
end

---
-- Switch to the currently selected weapon
-- @param boolean noHide
-- @realm client
function WSWITCH:ConfirmSelection(noHide)
    if not noHide then
        self:Disable()
    end

    local cachedWeapons = self.WeaponCache

    for k = 1, #cachedWeapons do
        local w = cachedWeapons[k]

        if k == self.Selected and IsValid(w) then
            input.SelectWeapon(w)

            return
        end
    end
end

---
-- Allow for suppression of the attack command
-- @realm client
function WSWITCH:PreventAttack()
    return self.Show and not self.cv.fast:GetBool()
end

---
-- Updates the weapon switcher
-- @note This is called by @{GM:Tick}
-- @realm client
-- @internal
function WSWITCH:Think()
    if not self.Show or self.Stay then
        return
    end

    -- hide after period of inaction
    if self.NextSwitch < (CurTime() - showtime) then
        self:Disable()
    end
end

---
-- Instantly select a slot and switch to it, without spending time in menu
-- @param number slot
-- @realm client
function WSWITCH:SelectAndConfirm(slot)
    if not slot then
        return
    end

    self:SelectSlot(slot)
    self:ConfirmSelection()
end

local function QuickSlot(ply, cmd, args)
    if not IsValid(ply) or not args or #args ~= 1 then
        return
    end

    local slot = tonumber(args[1])
    if not slot then
        return
    end

    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then
        return
    end

    if MakeKindValid(wep.Kind) == slot then
        RunConsoleCommand("lastinv")
    else
        WSWITCH:SelectAndConfirm(slot)
    end
end
concommand.Add("ttt_quickslot", QuickSlot)

local function SwitchToEquipment(ply, cmd, args)
    RunConsoleCommand("ttt_quickslot", "7")
end
concommand.Add("ttt_equipswitch", SwitchToEquipment)
