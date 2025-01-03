---
-- @class SWEP
-- @section weapon_zm_carry

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

local player = player
local IsValid = IsValid
local CurTime = CurTime

-- not customizable via convars as some objects rely on not being carryable for
-- gameplay purposes
CARRY_WEIGHT_LIMIT = 45

local down = Vector(0, 0, -1)
local color_cached = Color(50, 250, 50, 240)

SWEP.HoldType = "pistol"

if CLIENT then
    SWEP.PrintName = "magnet_name"
    SWEP.Slot = 4

    SWEP.Icon = "vgui/ttt/icon_magneto_stick"

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54
end

SWEP.Base = "weapon_tttbase"

SWEP.AutoSpawnable = false

SWEP.notBuyable = true

SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/c_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.1

SWEP.Kind = WEAPON_CARRY

SWEP.AllowDelete = false
SWEP.AllowDrop = false
SWEP.overrideDropOnDeath = DROP_ON_DEATH_TYPE_DENY
SWEP.NoSights = true

SWEP.CarryHack = nil
SWEP.Constr = nil
SWEP.PrevOwner = nil

SWEP.builtin = true

-- constants
SWEP.pickupRangeRagdoll = 75
SWEP.pickupRangeMisc = 100
SWEP.moveForce = 6000
SWEP.carryDistance = 70
SWEP.standCheckFrequency = 0.1
SWEP.entDiffDistanceThreshold = 40000
SWEP.entDiffCheckFrequency = 1
SWEP.pinBoneAttachFactor = 0.9
SWEP.pinBoneLengthFactor = 0.1
SWEP.pinRopeWidth = 1
SWEP.pinMaterial = "cable/rope"
SWEP.pinnedHealth = 999999
SWEP.constraintType = "Rope"
SWEP.dropWakeForce = 500
SWEP.dropAngleThreshold = 0.75
SWEP.carryMinDamping = 0
SWEP.carryMaxDamping = 1000
SWEP.carryMass = 200
SWEP.carryHealth = 999
SWEP.carryPushDelay = 0.03
SWEP.carryPickupDelay = 0.5
SWEP.carryPickupRagdollDelay = 0.8
SWEP.carryPickupReleaseDelay = 0.3
SWEP.moveObjectLightObjectMass = 50
SWEP.moveObjectLightObjectAdditionalMass = 0.5
SWEP.moveObjectLightObjectMassScale = 0.02
SWEP.moveObjectRagdollForceMultiplier = 2
SWEP.moveObjectRemapSpeedInMin = 0
SWEP.moveObjectRemapSpeedInMax = 125
SWEP.moveObjectRemapSpeedOutMin = 1
SWEP.pinRagRange = 90

local flags = { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }

---
-- @realm shared
local cvAllowRagCarry = CreateConVar("ttt_ragdoll_carrying", "1", flags)

---
-- @realm server
local cvPropForce = CreateConVar("ttt_prop_carrying_force", "60000", flags)
---
-- @realm shared
local cvPropThrow = CreateConVar("ttt_prop_throwing", "1", flags)

---
-- @note Allowing weapon pickups can allow players to cause a crash in the physics
-- system (ie. not fixable). Tuning the range seems to make this more
-- difficult. Not sure why. It's that kind of crash.
-- @realm server
local cvAllowWepCarry = CreateConVar("ttt_weapon_carrying", "0", flags)

---
-- @note Allowing weapon pickups can allow players to cause a crash in the physics
-- system (ie. not fixable). Tuning the range seems to make this more
-- difficult. Not sure why. It's that kind of crash.
-- @realm server
local cvWepCarryRange = CreateConVar("ttt_weapon_carrying_range", "50", flags)

CARRY_TYPE_NONE = 0
CARRY_TYPE_PROP = 1
CARRY_TYPE_WEAPON = 2
CARRY_TYPE_RAGDOLL = 3

---
-- @param Entity ent The entity whose carryability will be assessed
-- @return number CARRY_TYPE_* enum
-- @realm shared
function DetermineCarryType(ent)
    if IsValid(ent) then
        if ent.IsWeapon and ent:IsWeapon() then
            return CARRY_TYPE_WEAPON
        elseif ent:IsPlayerRagdoll() then
            return CARRY_TYPE_RAGDOLL
        else
            return CARRY_TYPE_PROP
        end
    else
        return CARRY_TYPE_NONE
    end
end

---
-- @return number CARRY_TYPE_* enum
-- @realm shared
function SWEP:GetCarryType()
    return DetermineCarryType(self:GetCarryTarget())
end

local function SetSubPhysMotionEnabled(ent, enable)
    if not IsValid(ent) then
        return
    end

    for i = 0, ent:GetPhysicsObjectCount() - 1 do
        local subphys = ent:GetPhysicsObjectNum(i)

        if not IsValid(subphys) then
            continue
        end

        subphys:EnableMotion(enable)

        if not enable then
            continue
        end

        subphys:Wake()
    end
end

local function KillVelocity(ent)
    ent:SetVelocity(vector_origin)

    -- The only truly effective way to prevent all kinds of velocity and
    -- inertia is motion disabling the entire ragdoll for a tick
    -- for non-ragdolls this will do the same for their single physobj
    SetSubPhysMotionEnabled(ent, false)

    timer.Simple(0, function()
        if not IsValid(ent) then
            return
        end

        SetSubPhysMotionEnabled(ent, true)
    end)
end

local ragdollPinCvs = {}

---
-- @realm shared
function SWEP:CanRagPin()
    local subRoleData = self:GetOwner():GetSubRoleData()

    local convar = ragdollPinCvs[subRoleData.id]
    if not convar then
        convar = GetConVar("ttt2_ragdoll_pinning_" .. subRoleData.name)

        ragdollPinCvs[subRoleData.id] = convar
    end

    return convar:GetBool()
end

---
-- @param boolean keep_velocity
-- @realm shared
function SWEP:Reset(keep_velocity)
    if IsValid(self.CarryHack) then
        self.CarryHack:Remove()
    end

    if IsValid(self.Constr) then
        self.Constr:Remove()
    end

    local ctarget = self:GetCarryTarget()
    local ctype = DetermineCarryType(ctarget)

    if IsValid(ctarget) then
        -- it is possible for weapons to be already equipped at this point
        -- changing the owner in such a case would cause problems
        if ctype ~= CARRY_TYPE_WEAPON then
            if not IsValid(self.PrevOwner) then
                ctarget:SetOwner(nil)
            else
                ctarget:SetOwner(self.PrevOwner)
            end
        end

        -- the below ought to be unified with self:Drop()
        local phys = ctarget:GetPhysicsObject()

        if IsValid(phys) then
            phys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
            phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
            phys:EnableCollisions(true)
            phys:EnableGravity(true)
            phys:EnableDrag(true)
            phys:EnableMotion(true)
        end

        if not keep_velocity then
            KillVelocity(ctarget)
        end
    end

    self:SetCarryTarget(NULL)
    self.CarryHack = nil
    self.Constr = nil
end

SWEP.reset = SWEP.Reset

---
-- @return boolean
-- @realm shared
function SWEP:CheckValidity()
    local ctarget = self:GetCarryTarget()
    if
        (ctarget and not IsValid(ctarget))
        or (self.Constr and not IsValid(self.Constr))
        or (self.CarryHack and not IsValid(self.CarryHack))
    then
        self:Reset()

        return false
    else
        return true
    end
end

local function PlayerStandsOn(ent)
    local plys = player.GetAll()

    for i = 1, #plys do
        local ply = plys[i]

        if ply:GetGroundEntity() == ent and ply:IsTerror() then
            return true
        end
    end

    return false
end

---
-- @ignore
function SWEP:PrimaryAttack()
    self:DoAttack(false)
end

---
-- @ignore
function SWEP:SecondaryAttack()
    self:DoAttack(true)
end

---
-- @param PhysObj phys
-- @param Vector pdir
-- @param number maxforce
-- @param boolean is_ragdoll
-- @realm shared
function SWEP:MoveObject(phys, pdir, maxforce, is_ragdoll)
    if not IsValid(phys) then
        return
    end

    local speed = phys:GetVelocity():Length()

    -- we're scaling down our desired force (maxforce) by the difference in the object's existing speed from self.moveObjectRemapSpeedInMax
    -- effectively clamping the amount of force we can add to an object every tick
    local force = math.Remap(
        speed,
        self.moveObjectRemapSpeedInMin,
        self.moveObjectRemapSpeedInMax,
        maxforce,
        self.moveObjectRemapSpeedOutMin
    )

    if is_ragdoll then
        force = force * self.moveObjectRagdollForceMultiplier
    end

    pdir = pdir * force

    local mass = phys:GetMass()

    -- scale more for light objects
    if mass < self.moveObjectLightObjectMass then
        pdir = pdir
            * (mass + self.moveObjectLightObjectAdditionalMass)
            * self.moveObjectLightObjectMassScale
    end

    phys:ApplyForceCenter(pdir)
end

---
-- @param Entity target
-- @realm shared
function SWEP:GetRange(target)
    local ctype = DetermineCarryType(target)

    if IsValid(target) then
        if ctype == CARRY_TYPE_WEAPON and cvAllowWepCarry:GetBool() then
            return cvWepCarryRange:GetInt()
        elseif ctype == CARRY_TYPE_RAGDOLL then
            return self.pickupRangeRagdoll
        end
    end

    return self.pickupRangeMisc
end

---
-- @param Entity target
-- @realm shared
function SWEP:AllowPickup(target)
    local phys = target:GetPhysicsObject()
    local ply = self:GetOwner()
    local ctype = DetermineCarryType(target)

    return IsValid(phys)
        and IsValid(ply)
        and not phys:HasGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
        and phys:GetMass() < CARRY_WEIGHT_LIMIT
        and not PlayerStandsOn(target)
        and target.CanPickup ~= false
        and (ctype ~= CARRY_TYPE_RAGDOLL or cvAllowRagCarry:GetBool())
        and (ctype ~= CARRY_TYPE_WEAPON or cvAllowWepCarry:GetBool())
        ---
        -- @realm shared
        and not hook.Run("TTT2PlayerPreventPickupEnt", ply, target)
end

---
-- @param Entity target
-- @realm shared
function SWEP:CanBeMoved(target)
    local phys = target:GetPhysicsObject()

    if not IsValid(phys) or not phys:IsMoveable() or phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then
        return false
    end

    return true
end

---
-- @param Entity trEnt
-- @param TraceResult trace
-- @param boolean pull Whether to pull it, instead of push
-- @realm shared
function SWEP:PushObject(trEnt, trace, pull)
    -- pull heavy stuff
    local phys2 = trEnt:GetPhysicsObject()
    local pdir = trace.Normal
    if pull then
        pdir = pdir * -1
    end

    local is_ragdoll = DetermineCarryType(trEnt) == CARRY_TYPE_RAGDOLL
    if is_ragdoll then
        phys2 = trEnt:GetPhysicsObjectNum(trace.PhysicsBone)
    end

    if IsValid(phys2) then
        self:MoveObject(phys2, pdir, self.moveForce, is_ragdoll)

        return true
    end
end

---
-- @param boolean pickup
-- @realm shared
function SWEP:DoAttack(pickup)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    -- allows us to "drop" on SecondaryAttack, and "release" with PrimaryAttack
    local want_throw = cvPropThrow:GetBool() and not pickup
    local ctarget = self:GetCarryTarget()
    local ctype = DetermineCarryType(ctarget)

    if IsValid(ctarget) then
        self:SendWeaponAnim(ACT_VM_MISSCENTER)

        if not pickup and ctype == CARRY_TYPE_RAGDOLL then
            -- see if we can pin this ragdoll to a wall in front of us
            if not self:PinRagdoll() then
                -- else just drop it as usual
                self:Drop(false)
            end
        else
            self:Drop(want_throw)
        end

        self:SetNextSecondaryFire(CurTime() + self.carryPickupReleaseDelay)

        return
    end

    -- if we let the client mess with physics, desync ensues
    if CLIENT then
        return
    end

    local ply = self:GetOwner()
    local trace = ply:GetEyeTrace(MASK_SHOT)
    local trEnt = trace.Entity

    if not IsValid(trEnt) or not self:CanBeMoved(trEnt) then
        return
    end

    local within_range = (ply:EyePos() - trace.HitPos):Length() < self:GetRange(trEnt)

    if not within_range then
        return
    end

    if pickup then
        if self:AllowPickup(trEnt) then
            self:Pickup()
            self:SendWeaponAnim(ACT_VM_HITCENTER)

            -- make the refire slower to avoid immediately dropping
            local delay = (ctype == CARRY_TYPE_RAGDOLL) and self.carryPickupRagdoll
                or self.carryPickupDelay

            self:SetNextSecondaryFire(CurTime() + delay)

            return
        else
            -- pull heavy stuff
            self:PushObject(trEnt, trace, true)
        end
    elseif self:PushObject(trEnt, trace, false) then
        self:SetNextPrimaryFire(CurTime() + self.carryPushDelay)
    end
end

---
-- Perform a pickup
-- @realm shared
function SWEP:Pickup()
    local ctarget = self:GetCarryTarget()

    if CLIENT or IsValid(ctarget) then
        return
    end

    local ply = self:GetOwner()
    local trace = ply:GetEyeTrace(MASK_SHOT)
    local ent = trace.Entity
    local entphys = ent:GetPhysicsObject()

    local ctype = DetermineCarryType(ent)
    ctarget = ent
    self:SetCarryTarget(ent)

    if IsValid(ent) and IsValid(entphys) then
        local carryHack = ents.Create("prop_physics")

        if IsValid(carryHack) then
            carryHack:SetPos(ent:GetPos())

            carryHack:SetModel("models/weapons/w_bugbait.mdl")

            carryHack:SetColor(color_cached)
            carryHack:SetNoDraw(true)
            carryHack:DrawShadow(false)

            carryHack:SetHealth(self.carryHealth)
            carryHack:SetOwner(ply)
            carryHack:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            carryHack:SetSolid(SOLID_NONE)

            -- set the desired angles before adding the constraint
            carryHack:SetAngles(ply:GetAngles())

            carryHack:Spawn()

            -- if we already are owner before pickup, we will not want to disown
            -- this entity when we drop it
            -- weapons should not have their owner changed in this way
            if ctype ~= CARRY_TYPE_WEAPON then
                self.PrevOwner = ent:GetOwner()

                ent:SetOwner(ply)
            end

            local phys = carryHack:GetPhysicsObject()

            if IsValid(phys) then
                phys:SetMass(self.carryMass)
                phys:SetDamping(self.carryMinDamping, self.carryMaxDamping)
                phys:EnableGravity(false)
                phys:EnableCollisions(false)
                phys:EnableMotion(false)
                phys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
            end

            entphys:AddGameFlag(FVPHYSICS_PLAYER_HELD)

            local bone = math.Clamp(trace.PhysicsBone, 0, 1)
            local max_force = cvPropForce:GetInt()

            if ctype == CARRY_TYPE_RAGDOLL then
                self:SetCarryTarget(ent)
                bone = trace.PhysicsBone
                max_force = 0
            end

            self.Constr = constraint.Weld(carryHack, ent, 0, bone, max_force, true, false)
        end

        self.CarryHack = carryHack
    end
end

---
-- @return boolean
-- @realm shared
function SWEP:AllowEntityDrop()
    local ply = self:GetOwner()
    local ent = self.CarryHack

    if not IsValid(ply) or not IsValid(ent) then
        return false
    end

    local ground = ply:GetGroundEntity()

    if ground and (ground:IsWorld() or IsValid(ground)) then
        return true
    end

    local diff = (ent:GetPos() - ply:GetShootPos()):GetNormalized()

    return down:Dot(diff) <= self.dropAngleThreshold
end

---
-- @param boolean keep_velocity
-- @realm shared
function SWEP:Drop(keep_velocity)
    if not self:CheckValidity() or not self:AllowEntityDrop() then
        return
    end

    if SERVER then
        local ctarget = self:GetCarryTarget()
        local ctype = DetermineCarryType(ctarget)
        local ent = ctarget

        if not ctarget then
            self:Reset(keep_velocity)
            return
        end
        local phys = ent:GetPhysicsObject()

        if IsValid(phys) then
            phys:EnableCollisions(true)
            phys:EnableGravity(true)
            phys:EnableDrag(true)
            phys:EnableMotion(true)
            phys:Wake()
            phys:ApplyForceCenter(self:GetOwner():GetAimVector() * self.dropWakeForce)

            phys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
            phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
        end

        -- Try to limit ragdoll slinging
        if not keep_velocity or ctype == CARRY_TYPE_RAGDOLL then
            KillVelocity(ent)
        end

        ent:SetPhysicsAttacker(self:GetOwner())
    end

    self:Reset(keep_velocity)
end

---
-- @realm shared
function SWEP:PinRagdoll()
    if CLIENT or not self:CanRagPin() then
        return
    end

    local ctarget = self:GetCarryTarget()
    local ply = self:GetOwner()

    local tr = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * self.pinRagRange,
        filter = {
            ply,
            self,
            ctarget,
            self.CarryHack,
        },
        mask = MASK_SOLID,
    })

    if tr.HitWorld and not tr.HitSky then
        -- find bone we're holding the ragdoll by
        local bone = self.Constr.Bone2

        -- only allow one rope per bone
        for _, c in pairs(constraint.FindConstraints(ctarget, self.constraintType)) do
            if c.Bone1 == bone then
                c.Constraint:Remove()
            end
        end

        local bonephys = ctarget:GetPhysicsObjectNum(bone)

        if not IsValid(bonephys) then
            return
        end

        local bonepos = bonephys:GetPos()
        local attachpos = tr.HitPos
        local length = (bonepos - attachpos):Length() * self.pinBoneAttachFactor

        -- we need to convert using this particular physobj to get the right
        -- coordinates
        bonepos = bonephys:WorldToLocal(bonepos)

        -- the constraint has to be created to break with at least as much force as the moveForce or else
        -- pinned bodies couldn't be taken down by innocents
        constraint.Rope(
            ctarget,
            tr.Entity,
            bone,
            0,
            bonepos,
            attachpos,
            length,
            length * self.pinBoneLengthFactor,
            self.moveForce,
            self.pinRopeWidth,
            self.pinMaterial,
            false,
            color_white
        )

        ctarget.pinned_constraint_type = self.constraintType
        ctarget.is_pinned = true
        ---
        -- @param Entity rag
        -- @param DamageInfo dmginfo
        -- @realm server
        ctarget.OnPinnedDamage = function(rag, dmginfo)
            local att = dmginfo:GetAttacker()
            if not IsValid(att) then
                return
            end

            -- drop from pinned position upon dmg
            constraint.RemoveConstraints(rag, self.pinned_constraint_type)

            rag:PhysWake()
            rag:SetHealth(0)

            rag.pinned_constraint_type = nil
            rag.is_pinned = false
        end

        -- lets EntityTakeDamage run for the ragdoll
        ctarget:SetHealth(self.pinnedHealth)

        self:Reset(true)
        return true
    end
end

---
-- @ignore
function SWEP:SetupDataTables()
    -- client actually has no idea what we're holding, and almost never needs to know
    self:NetworkVar("Entity", 0, "CarryTarget")

    return BaseClass.SetupDataTables(self)
end

---
-- @realm client
function SWEP:OnRemove()
    BaseClass.OnRemove(self)

    self:Reset()
end

---
-- @ignore
function SWEP:Deploy()
    self:Reset()

    return true
end

---
-- @ignore
function SWEP:Holster()
    self:Reset()

    return true
end

if SERVER then
    ---
    -- @ignore
    function SWEP:Initialize()
        self:SetCarryTarget(NULL)

        return BaseClass.Initialize(self)
    end

    ---
    -- A cancelable hook that is called once a player tries to pickup an entity.
    -- @note This hook is not called if prior checks prevent the pickup already
    -- @param Player ply The player that tries to pick up an entity
    -- @param Entity ent The entity that is about to be picked up
    -- @return boolean Return true to cancel the pickup
    -- @hook
    -- @realm server
    function GAMEMODE:TTT2PlayerPreventPickupEnt(ply, ent) end

    local ent_diff = vector_origin
    local ent_diff_time = CurTime()
    local stand_time = 0

    ---
    -- @realm server
    function SWEP:Think()
        BaseClass.Think(self)

        local ctarget = self:GetCarryTarget()
        local ctype = DetermineCarryType(ctarget)

        if ctype == CARRY_TYPE_NONE or not self:CheckValidity() then
            return
        end

        -- If we are too far from our object, force a drop. To avoid doing this
        -- vector math extremely often (esp. when everyone is carrying something)
        -- even though the occurrence is very rare, limited to once per
        -- second. This should be plenty to catch the rare glitcher.
        if CurTime() > ent_diff_time then
            ent_diff = self:GetPos() - ctarget:GetPos()

            if ent_diff:Dot(ent_diff) > self.entDiffDistanceThreshold then
                self:Reset()

                return
            end

            ent_diff_time = CurTime() + self.entDiffCheckFrequency
        end

        if CurTime() > stand_time then
            if PlayerStandsOn(ctarget) then
                self:Reset()

                return
            end

            stand_time = CurTime() + self.standCheckFrequency
        end

        local owner = self:GetOwner()

        if IsValid(self.CarryHack) then
            self.CarryHack:SetPos(owner:EyePos() + owner:GetAimVector() * self.carryDistance)
            self.CarryHack:SetAngles(owner:GetAngles())
        end

        ctarget:PhysWake()
    end
end

if CLIENT then
    ---
    -- @ignore
    function SWEP:Initialize()
        self:RefreshTTT2HUDHelp()

        return BaseClass.Initialize(self)
    end

    ---
    -- @ignore
    function SWEP:Think()
        self:RefreshTTT2HUDHelp()
    end

    ---
    -- Show relevant strings for the current action.
    -- @realm shared
    function SWEP:RefreshTTT2HUDHelp()
        local ctarget = self:GetCarryTarget()
        local ctype = DetermineCarryType(ctarget)

        if ctype ~= CARRY_TYPE_NONE and IsValid(ctarget) then
            if ctype == CARRY_TYPE_RAGDOLL then
                self:AddTTT2HUDHelp(
                    self:CanPinCurrentRag() and "magneto_stick_help_carry_rag_pin"
                        or "magneto_stick_help_carry_rag_drop",
                    "magneto_stick_help_carry_rag_drop"
                )
            elseif ctype == CARRY_TYPE_PROP or ctype == CARRY_TYPE_WEAPON then
                self:AddTTT2HUDHelp(
                    cvPropThrow:GetBool() and "magneto_stick_help_carry_prop_release"
                        or "magneto_stick_help_carry_prop_drop",
                    "magneto_stick_help_carry_prop_drop"
                )
            end
        else
            self:AddTTT2HUDHelp("magneto_help_primary", "magneto_help_secondary")
        end
    end

    ---
    -- @return boolean
    -- @realm client
    function SWEP:CanPinCurrentRag()
        local ctarget = self:GetCarryTarget()
        local ctype = DetermineCarryType(ctarget)
        local ply = self:GetOwner()
        if
            ctype == CARRY_TYPE_RAGDOLL
            and IsValid(ctarget)
            and self:CanRagPin()
            and ply:IsTerror()
        then
            local tr = util.TraceLine({
                start = ply:EyePos(),
                endpos = ply:EyePos() + ply:GetAimVector() * self.pinRagRange,
                filter = {
                    ply,
                    self,
                    ctarget,
                },
                mask = MASK_SOLID,
            })

            if tr.HitWorld and not tr.HitSky then
                return true
            end
        end

        return false
    end

    ---
    -- @ignore
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

        form:MakeCheckBox({
            serverConvar = "ttt_ragdoll_carrying",
            label = "label_ragdoll_carrying",
        })

        local enbWepCarry = form:MakeCheckBox({
            serverConvar = "ttt_weapon_carrying",
            label = "label_weapon_carrying",
        })

        form:MakeSlider({
            serverConvar = "ttt_weapon_carrying_range",
            label = "label_weapon_carrying_range",
            min = 0,
            max = 150,
            decimal = 0,
            master = enbWepCarry,
        })

        form:MakeSlider({
            serverConvar = "ttt_prop_carrying_force",
            label = "label_prop_carrying_force",
            min = 0,
            max = 250000,
            decimal = 0,
        })

        form:MakeCheckBox({
            serverConvar = "ttt_prop_throwing",
            label = "label_prop_throwing",
        })
    end
end
