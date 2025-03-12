---
-- @class SWEP
-- @section weapon_zm_improvised

local cvCrowbarUnlocks, cvCrowbarPushForce, cvCrowbarDelay

if SERVER then
    AddCSLuaFile()

    ---
    -- @realm server
    cvCrowbarDelay =
        CreateConVar("ttt2_crowbar_shove_delay", "1.0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    cvCrowbarUnlocks = CreateConVar("ttt_crowbar_unlocks", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY })

    ---
    -- @realm server
    cvCrowbarPushForce =
        CreateConVar("ttt_crowbar_pushforce", "395", { FCVAR_ARCHIVE, FCVAR_NOTIFY })
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "melee"

if CLIENT then
    SWEP.PrintName = "crowbar_name"
    SWEP.Slot = 0

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_cbar"
end

SWEP.Base = "weapon_tttbase"

SWEP.notBuyable = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Damage = 20
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.5
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 5

SWEP.Kind = WEAPON_MELEE
SWEP.WeaponID = AMMO_CROWBAR
SWEP.builtin = true

SWEP.NoSights = true
SWEP.IsSilent = true

SWEP.Weight = 5
SWEP.AutoSpawnable = false

SWEP.AllowDelete = false -- never removed for weapon reduction
SWEP.AllowDrop = false
SWEP.overrideDropOnDeath = DROP_ON_DEATH_TYPE_DENY

local sound_single = Sound("Weapon_Crowbar.Single")

-- only open things that have a name (and are therefore likely to be meant to
-- open) and are the right class. Opening behaviour also differs per class, so
-- return one of the OPEN_ values
local pmnc_tbl = {
    prop_door_rotating = OPEN_ROT,
    func_door = OPEN_DOOR,
    func_door_rotating = OPEN_DOOR,
    func_button = OPEN_BUT,
    func_movelinear = OPEN_NOTOGGLE,
}

local function OpenableEnt(ent)
    return ent:GetName() ~= "" and pmnc_tbl[ent:GetClass()] or OPEN_NO
end

local function CrowbarCanUnlock(t)
    return not GAMEMODE.crowbar_unlocks or GAMEMODE.crowbar_unlocks[t]
end

---
-- Will open door AND return what it did
-- @param Entity hitEnt
-- @return number Entity types a crowbar might open
-- @realm shared
function SWEP:OpenEnt(hitEnt)
    -- Get ready for some prototype-quality code, all ye who read this
    if SERVER and cvCrowbarUnlocks:GetBool() then
        local openable = OpenableEnt(hitEnt)

        if openable == OPEN_DOOR or openable == OPEN_ROT then
            local unlock = CrowbarCanUnlock(openable)
            if unlock then
                hitEnt:Fire("Unlock", nil, 0)
            end

            if unlock or hitEnt:HasSpawnFlags(256) then -- SF_DOOR_PUSE
                if openable == OPEN_ROT then
                    hitEnt:Fire("OpenAwayFrom", self:GetOwner(), 0)
                end

                hitEnt:Fire("Toggle", nil, 0)
            else
                return OPEN_NO
            end
        elseif openable == OPEN_BUT then
            if CrowbarCanUnlock(openable) then
                hitEnt:Fire("Unlock", nil, 0)
                hitEnt:Fire("Press", nil, 0)
            else
                return OPEN_NO
            end
        elseif openable == OPEN_NOTOGGLE then
            if CrowbarCanUnlock(openable) then
                hitEnt:Fire("Open", nil, 0)
            else
                return OPEN_NO
            end
        end

        return openable
    else
        return OPEN_NO
    end
end

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local owner = self:GetOwner()
    if not IsValid(owner) then
        return
    end

    if isfunction(owner.LagCompensation) then -- for some reason not always true
        owner:LagCompensation(true)
    end

    local spos = owner:GetShootPos()
    local sdest = spos + owner:GetAimVector() * 100

    local tr_main = util.TraceLine({
        start = spos,
        endpos = sdest,
        filter = owner,
        mask = MASK_SHOT_HULL,
    })

    local hitEnt = tr_main.Entity

    self:EmitSound(sound_single)
    owner:SetAnimation(PLAYER_ATTACK1)

    if IsValid(hitEnt) or tr_main.HitWorld then
        self:SendWeaponAnim(ACT_VM_HITCENTER)

        if SERVER or IsFirstTimePredicted() then
            local edata = EffectData()
            edata:SetStart(spos)
            edata:SetOrigin(tr_main.HitPos)
            edata:SetNormal(tr_main.Normal)
            edata:SetSurfaceProp(tr_main.SurfaceProps)
            edata:SetHitBox(tr_main.HitBox)
            --edata:SetDamageType(DMG_CLUB)
            edata:SetEntity(hitEnt)

            if hitEnt:IsPlayer() or hitEnt:IsPlayerRagdoll() then
                util.Effect("BloodImpact", edata)

                -- does not work on players rah
                --util.Decal("Blood", tr_main.HitPos + tr_main.HitNormal, tr_main.HitPos - tr_main.HitNormal)

                -- do a bullet just to make blood decals work sanely
                -- need to disable lagcomp because firebullets does its own
                owner:LagCompensation(false)
                owner:FireBullets({
                    Num = 1,
                    Src = spos,
                    Dir = owner:GetAimVector(),
                    Spread = Vector(0, 0, 0),
                    Tracer = 0,
                    Force = 1,
                    Damage = 0,
                })
            else
                util.Effect("Impact", edata)
            end
        end
    else
        self:SendWeaponAnim(ACT_VM_MISSCENTER)
    end

    if SERVER then
        -- Do another trace that sees nodraw stuff like func_button
        local tr_all = util.TraceLine({
            start = spos,
            endpos = sdest,
            filter = owner,
        })

        local trEnt = tr_all.Entity

        if IsValid(hitEnt) then
            if self:OpenEnt(hitEnt) == OPEN_NO and IsValid(trEnt) then
                self:OpenEnt(trEnt) -- See if there's a nodraw thing we should open
            end

            local dmg = DamageInfo()
            dmg:SetDamage(self.Primary.Damage)
            dmg:SetAttacker(owner)
            dmg:SetInflictor(self)
            dmg:SetDamageForce(owner:GetAimVector() * 1500)
            dmg:SetDamagePosition(owner:GetPos())
            dmg:SetDamageType(DMG_CLUB)

            hitEnt:DispatchTraceAttack(dmg, spos + owner:GetAimVector() * 3, sdest)
        elseif IsValid(trEnt) then -- See if our nodraw trace got the goods
            self:OpenEnt(trEnt)
        end
    end

    if isfunction(owner.LagCompensation) then
        owner:LagCompensation(false)
    end
end

---
-- @ignore
function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(CurTime() + 0.1)

    local owner = self:GetOwner()
    if not IsValid(owner) then
        return
    end

    if isfunction(owner.LagCompensation) then
        owner:LagCompensation(true)
    end

    local tr = owner:GetEyeTrace(MASK_SHOT)
    local ply = tr.Entity

    if
        tr.Hit
        and IsValid(ply)
        and ply:IsPlayer()
        and (owner:EyePos() - tr.HitPos):LengthSqr() < 10000 -- 100hu
    then
        ---
        -- @realm shared
        if SERVER and not ply:IsFrozen() and not hook.Run("TTT2PlayerPreventPush", owner, ply) then
            local pushvel = tr.Normal * cvCrowbarPushForce:GetFloat()
            pushvel.z = math.Clamp(pushvel.z, 50, 100) -- limit the upward force to prevent launching

            ply:SetVelocity(ply:GetVelocity() + pushvel)

            ply.was_pushed = {
                att = owner,
                t = CurTime(),
                wep = self:GetClass(),
                -- infl = self
            }
        end

        self:EmitSound(sound_single)
        self:SendWeaponAnim(ACT_VM_HITCENTER)
        owner:SetAnimation(PLAYER_ATTACK1)

        self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
    end

    if isfunction(owner.LagCompensation) then
        owner:LagCompensation(false)
    end
end

if SERVER then
    ---
    -- A cancelable hook that is called if a player tries to push another player.
    -- @param Player ply The player that tries to push
    -- @param Player pushPly The player that is about to be pushed
    -- @return boolean Return true to cancel the push
    -- @hook
    -- @realm server
    function GAMEMODE:TTT2PlayerPreventPush(ply, pushPly) end
end

if SERVER then
    -- manipulate shove attack for all crowbar alikes
    local function ChangeShoveDelay()
        local weps = weapons.GetList()

        for i = 1, #weps do
            local wep = weps[i]

            --all weapons on the WEAPON_MELEE slot should be Crowbars or Crowbar alikes
            if not wep.Kind or wep.Kind ~= WEAPON_MELEE then
                continue
            end

            wep.Secondary.Delay = cvCrowbarDelay:GetFloat()
        end
    end

    cvars.AddChangeCallback(cvCrowbarDelay:GetName(), ChangeShoveDelay, "TTT2CrowbarShoveDelay")

    hook.Add("TTT2Initialize", "TTT2ChangeMeleesSecondaryDelay", ChangeShoveDelay)
end

if CLIENT then
    ---
    -- @ignore
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("crowbar_help_primary", "crowbar_help_secondary")

        return BaseClass.Initialize(self)
    end

    ---
    -- @ignore
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

        form:MakeCheckBox({
            serverConvar = "ttt_crowbar_unlocks",
            label = "label_crowbar_unlocks",
        })

        form:MakeSlider({
            serverConvar = "ttt_crowbar_pushforce",
            label = "label_crowbar_pushforce",
            min = 0,
            max = 750,
            decimal = 0,
        })

        form:MakeSlider({
            serverConvar = "ttt2_crowbar_shove_delay",
            label = "label_crowbar_shove_delay",
            min = 0,
            max = 10,
            decimal = 1,
        })
    end
end
