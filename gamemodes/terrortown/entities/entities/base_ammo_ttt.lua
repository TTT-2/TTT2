---
-- @class ENT
-- @desc Ammo override base
-- @section BaseAmmo

if SERVER then
    AddCSLuaFile()
end

local util = util
local hook = hook

ENT.Type = "anim"

if CLIENT then
    local cvAmmoEntityScaling = CreateConVar("ttt2_ammo_entity_scaling", "1", FCVAR_ARCHIVE)
    local cvAmmoEntityScalingMin = CreateConVar("ttt2_ammo_entity_scaling_min", "0.25", FCVAR_ARCHIVE)
    local cvAmmoTargetID = CreateConVar("ttt2_ammo_targetid", "1", FCVAR_ARCHIVE)
    local Material = Material
    local ParT = LANG.GetParamTranslation
    local TryT = LANG.TryTranslation

    local materialAmmoIconFallback = Material("vgui/ttt/pickup/icon_ammo.png")
    local ammoTargetIDIcons = {
        ["357"] = Material("vgui/ttt/ammo/box_357"),
        ["alyxgun"] = Material("vgui/ttt/ammo/box_alyxgun"),
        ["buckshot"] = Material("vgui/ttt/ammo/box_buckshot"),
        ["pistol"] = Material("vgui/ttt/ammo/box_pistol"),
        ["smg1"] = Material("vgui/ttt/ammo/box_smg1"),
    }

    local function GetAmmoTargetIDTitle(ammoType)
        local titleKey = WEPS.GetAmmoTypeLangIdentifier(ammoType)
        local title = TryT(titleKey)

        if title == titleKey then
            return ammoType
        end

        return title
    end

    function ENT:GetVisualScale()
        if not cvAmmoEntityScaling:GetBool() then
            return 1
        end

        local ammoEntMax = self:GetMaxStoredAmmo()

        if ammoEntMax <= 0 then
            return 1
        end

        local ammoAmount = self:GetStoredAmmo()
        local minScale = math.Clamp(cvAmmoEntityScalingMin:GetFloat(), 0.25, 1)

        return (ammoAmount / ammoEntMax) * (1 - minScale) + minScale
    end

    function ENT:UpdateVisualScale()
        local scale = self:GetVisualScale()

        if self.lastVisualScale == scale then
            return
        end

        local matrix = Matrix()
        matrix:Scale(Vector(scale, scale, scale))

        self:EnableMatrix("RenderMultiply", matrix)

        self.lastVisualScale = scale
    end

    function ENT:Draw()
        self:UpdateVisualScale()
        self:DrawModel()
    end

    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDAmmoBoxes", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not IsValid(client)
            or not client:IsTerror()
            or not client:Alive()
            or not IsValid(ent)
            or not cvAmmoTargetID:GetBool()
            or tData:GetEntityDistance() > 100
        then
            return
        end

        local ammoSettings = WEPS.GetAmmoSettings(ent:GetClass())

        if not ammoSettings then
            return
        end

        local ammoType = ammoSettings.ammoType or ent.AmmoType or ent:GetClass()
        local ammoTypeIdentifier = string.lower(ammoType or "")

        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(GetAmmoTargetIDTitle(ammoType))
        tData:SetSubtitle(TryT("ttt2_wstat_ammo_walk_over"))
        tData:AddIcon(ammoTargetIDIcons[ammoTypeIdentifier] or materialAmmoIconFallback)
        tData:AddDescriptionLine(ParT("target_ammo_box_amount", {
            curAmmo = ent:GetStoredAmmo(),
            maxAmmo = ent:GetMaxStoredAmmo(),
        }))
    end)
end

-- Override these values
ENT.AmmoType = "Pistol"
ENT.AmmoAmount = 1
-- Legacy fallback for custom ammo entities without a central reserve default.
ENT.AmmoMax = 10
ENT.AmmoEntMax = 1
ENT.Model = "models/items/boxsrounds.mdl"

---
-- @return string
-- @realm shared
function ENT:GetPrintName()
    if self.PrintName and self.PrintName ~= "" then
        return self.PrintName
    end

    return WEPS.GetAmmoTypeLangIdentifier(self.AmmoType)
end

---
-- @return number
-- @realm shared
function ENT:GetConfiguredBoxAmount()
    return WEPS.GetAmmoBoxAmount(self:GetClass(), self.AmmoAmount)
end

---
-- @return number
-- @realm shared
function ENT:GetConfiguredReserveMax()
    return WEPS.GetAmmoReserveMax(self.AmmoType or self:GetClass()) or math.max(0, self.AmmoMax or 0)
end

---
-- @return number
-- @realm shared
function ENT:GetMaxStoredAmmo()
    local defaultMaxAmmo = self.AmmoEntMax or self:GetConfiguredBoxAmount() or self.AmmoAmount or 1

    return math.max(1, self:GetNW2Int("ttt2_ammo_ent_max", defaultMaxAmmo))
end

---
-- @return number
-- @realm shared
function ENT:GetStoredAmmo()
    local maxAmmo = self:GetMaxStoredAmmo()

    return math.Clamp(self:GetNW2Int("ttt2_ammo_amount", maxAmmo), 0, maxAmmo)
end

---
-- @realm shared
function ENT:SyncAmmoState()
    if not SERVER then
        return
    end

    self:SetNW2Int("ttt2_ammo_amount", self.AmmoAmount)
    self:SetNW2Int("ttt2_ammo_ent_max", self.AmmoEntMax)
end

---
-- Some subclasses want to do stuff before/after initing (eg. setting color)
-- Using self.BaseClass gave weird problems, so stuff has been moved into a fn
-- Subclasses can easily call this whenever they want to
-- @realm shared
function ENT:Initialize()
    if SERVER and not WEPS.IsAmmoEnabled(self:GetClass()) then
        if entspawn and isfunction(entspawn.SpawnRandomAmmo) then
            entspawn.SpawnRandomAmmo(self)
        end

        self:Remove()

        return
    end

    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:AddSolidFlags(FSOLID_TRIGGER)

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    self:UseTriggerBounds(true, 24)

    self.tickRemoval = false
    self.AmmoAmount = self:GetConfiguredBoxAmount()
    self.AmmoEntMax = self.AmmoAmount

    self:SyncAmmoState()

    if CLIENT then
        self:UpdateVisualScale()
    end
end

---
-- Pseudo-clone of SDK's UTIL_ItemCanBeTouchedByPlayer
-- aims to prevent picking stuff up through fences and stuff
-- @param Player ply
-- @return boolean
-- @realm shared
function ENT:PlayerCanPickup(ply)
    if ply == self:GetOwner() then
        return false
    end

    ---
    -- @realm shared
    local result = hook.Run("TTTCanPickupAmmo", ply, self)
    if result then
        return result
    end

    local phys = self:GetPhysicsObject()
    local spos = phys:IsValid() and phys:GetPos() or self:OBBCenter()
    local epos = ply:GetShootPos() -- equiv to EyePos in SDK

    local tr = util.TraceLine({
        start = spos,
        endpos = epos,
        filter = { ply, self },
        mask = MASK_SOLID,
    })

    -- can pickup if trace was not stopped
    return tr.Fraction == 1.0
end

---
-- @param Player ply
-- @return boolean
-- @realm shared
function ENT:CheckForWeapon(ply)
    if not self.CachedWeapons then
        -- create a cache of what weapon classes use this ammo
        local tbl = {}
        local weps = weapons.GetList()
        local cls = self:GetClass()

        local WEPSGetClass = WEPS.GetClass

        for i = 1, #weps do
            local v = weps[i]

            if v.AmmoEnt == cls then
                tbl[#tbl + 1] = WEPSGetClass(v)
            end
        end

        self.CachedWeapons = tbl
    end

    local plyHasWeapon = ply.HasWeapon
    local cached = self.CachedWeapons

    -- Check if player has a weapon that we know needs us. This is called in
    -- Touch, which is called many a time, so we use the cache here to avoid
    -- looping through every weapon the player has to check their AmmoEnt.
    for i = 1, #cached do
        if plyHasWeapon(ply, cached[i]) then
            return true
        end
    end

    return false
end

---
-- This entity function is called once another entity toruches it.
-- @param Entity ply The touching entity that is probably a player
-- @realm shared
function ENT:Touch(ply)
    if
        CLIENT
        or self.tickRemoval
        or not ply:IsValid()
        or not ply:IsPlayer()
        or not self:CheckForWeapon(ply)
        or not self:PlayerCanPickup(ply)
    then
        return
    end

    local ammo = ply:GetAmmoCount(self.AmmoType)
    local ammoMax = self:GetConfiguredReserveMax()

    -- need clipmax info and room for at least 1/4th
    if ammoMax <= ammo then
        return
    end

    local given = math.min(self.AmmoAmount, ammoMax - ammo)

    ply:GiveAmmo(given, self.AmmoType)

    self:AdjustAmmo(self.AmmoAmount - given)
end

---
-- This entity function is called when the stored ammo is changed.
-- @param number amr The new stored ammo amount
-- @realm shared
function ENT:AdjustAmmo(amr)
    if amr <= 0 then
        self.tickRemoval = true
        self:Remove()
        return
    end

    self.AmmoAmount = amr
    self:SyncAmmoState()
end

if SERVER then
    ---
    -- This Think hook is used as a hack to force ammo to physwake, because it can't be done
    -- in init. If it is done in init, the entities will fall through the world on the client
    -- but not on the server. This leads to inconsistencies between server and client.
    -- @realm server
    function ENT:Think()
        if self.firstThinkDone then
            return
        end

        self:PhysWake()

        self.firstThinkDone = true

        -- Immediately unhook the Think to save cycles. The firstThinkDone thing is
        -- just there in case it still Thinks somehow in the future.
        self.Think = nil
    end

    ---
    -- Hook that is called when an ammo entity is about to be picked up. With this hook
    -- the pickup can be canceled. It is called after all previous checks have passed.
    -- @param Player ply The player that attempts to pick up the entity
    -- @param Entity ent The ammo entity that is about to be picked up
    -- @return boolean Return false to cancel the pickup event
    -- @hook
    -- @realm server
    function GAMEMODE:TTTCanPickupAmmo(ply, ent) end
end
