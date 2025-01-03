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

-- Override these values
ENT.AmmoType = "Pistol"
ENT.AmmoAmount = 1
ENT.AmmoMax = 10
ENT.AmmoEntMax = 1
ENT.Model = "models/items/boxsrounds.mdl"

---
-- bw compat
-- @realm shared
function ENT:RealInit() end

---
-- Some subclasses want to do stuff before/after initing (eg. setting color)
-- Using self.BaseClass gave weird problems, so stuff has been moved into a fn
-- Subclasses can easily call this whenever they want to
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:AddSolidFlags(FSOLID_TRIGGER)

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    self:UseTriggerBounds(true, 24)

    self.tickRemoval = false
    self.AmmoEntMax = self.AmmoAmount
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

    -- need clipmax info and room for at least 1/4th
    if self.AmmoMax < ammo + math.ceil(self.AmmoAmount * 0.25) then
        return
    end

    local given = math.min(self.AmmoAmount, self.AmmoMax - ammo)

    ply:GiveAmmo(given, self.AmmoType)

    self.AmmoAmount = self.AmmoAmount - given

    if self.AmmoAmount > 0 and math.ceil(self.AmmoEntMax * 0.25) <= self.AmmoAmount then
        return
    end

    self.tickRemoval = true
    self:Remove()
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
