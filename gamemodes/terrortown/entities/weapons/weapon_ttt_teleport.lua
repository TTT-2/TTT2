---
-- @class SWEP
-- @section weapon_ttt_teleport

local ttt_telefrags

if SERVER then
    AddCSLuaFile()

    ---
    -- @realm server
    ttt_telefrags = CreateConVar("ttt_teleport_telefrags", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY })
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "normal"

if CLIENT then
    SWEP.PrintName = "tele_name"
    SWEP.Slot = 7

    SWEP.ShowDefaultViewModel = false
    SWEP.CSMuzzleFlashes = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "tele_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_tport"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"

SWEP.Primary.ClipSize = 16
SWEP.Primary.DefaultClip = 16
SWEP.Primary.ClipMax = 16
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "GaussEnergy"
SWEP.Primary.Delay = 0.5

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
SWEP.WeaponID = AMMO_TELEPORT
SWEP.builtin = true

SWEP.AllowDrop = true
SWEP.NoSights = true

local delay_beamup = 1
local delay_beamdown = 1

---
-- @ignore
function SWEP:SetTeleportMark(pos, ang)
    self.teleport = { pos = pos, ang = ang }
end

---
-- @ignore
function SWEP:GetTeleportMark()
    return self.teleport
end

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if self:Clip1() <= 0 then
        self:DryFire(self.SetNextSecondaryFire)

        return
    end

    -- Disallow initiating teleports during post, as it will occur across the
    -- restart and allow the user an advantage during prep
    if gameloop.GetRoundState() == ROUND_POST then
        return
    end

    if SERVER then
        self:TeleportRecall()
    else
        surface.PlaySound("buttons/combine_button7.wav")
    end
end

---
-- @ignore
function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    if SERVER then
        self:TeleportStore()
    else
        surface.PlaySound("ui/buttonrollover.wav")
    end
end

local zap = Sound("ambient/levels/labs/electric_explosion4.wav")
local unzap = Sound("ambient/levels/labs/electric_explosion2.wav")

local function Telefrag(victim, attacker, weapon)
    if not IsValid(victim) then
        return
    end

    local dmginfo = DamageInfo()
    dmginfo:SetDamage(5000)
    dmginfo:SetDamageType(DMG_SONIC)
    dmginfo:SetAttacker(attacker)
    dmginfo:SetInflictor(weapon)
    dmginfo:SetDamageForce(Vector(0, 0, 10))
    dmginfo:SetDamagePosition(attacker:GetPos())

    victim:TakeDamageInfo(dmginfo)
end

local shouldNotCollideList = {
    [COLLISION_GROUP_WEAPON] = true,
    [COLLISION_GROUP_DEBRIS] = true,
    [COLLISION_GROUP_DEBRIS_TRIGGER] = true,
    [COLLISION_GROUP_INTERACTIVE_DEBRIS] = true,
}
-- @ignore
local function ShouldCollide(ent)
    return not shouldNotCollideList[ent:GetCollisionGroup()]
end

-- Teleport a player to a {pos, ang}
local function TeleportPlayer(ply, teleport)
    local oldpos = ply:GetPos()
    local pos = teleport.pos
    local ang = teleport.ang

    -- print decal on destination
    util.PaintDown(pos + Vector(0, 0, 25), "GlassBreak", ply)

    -- perform teleport
    ply:SetPos(pos)
    ply:SetEyeAngles(ang) -- ineffective due to freeze...

    timer.Simple(delay_beamdown, function()
        if not IsValid(ply) then
            return
        end

        ply:Freeze(false)
    end)

    sound.Play(zap, oldpos, 65, 100)
    sound.Play(unzap, pos, 55, 100)

    -- print decal on source now that we're gone, because else it will refuse
    -- to draw for some reason
    util.PaintDown(oldpos + Vector(0, 0, 25), "GlassBreak", ply)
end

-- Checks teleport destination. Returns bool and table, if bool is true then
-- location is blocked by world or prop. If table is non-nil it contains a list
-- of blocking players.
local function CanTeleportToPos(ply, pos)
    -- first check if we can teleport here at all, because any solid object or
    -- brush will make us stuck and therefore kills/blocks us instead, so the
    -- trace checks for anything solid to players that isn't a player
    local tr = nil
    local traceData = {
        start = pos,
        endpos = pos,
        mask = MASK_PLAYERSOLID,
        filter = player.GetAll(),
    }
    local collide = false

    -- This thing is unnecessary if we can supply a collision group to trace
    -- functions, like we can in source and sanity suggests we should be able
    -- to do so, but I have not found a way to do so yet. Until then, re-trace
    -- while extending our filter whenever we hit something we don't want to
    -- hit (like weapons or ragdolls).
    repeat
        tr = util.TraceEntity(traceData, ply)

        if tr.HitWorld then
            collide = true
        elseif IsValid(tr.Entity) then
            if ShouldCollide(tr.Entity) then
                collide = true
            else
                table.insert(traceData.filter, tr.Entity)
            end
        end
    until (not tr.Hit) or collide

    if collide then
        return true, nil
    else
        -- find all players in the place where we will be and telefrag them
        local blockers = ents.FindInBox(pos + Vector(-16, -16, 0), pos + Vector(16, 16, 64))

        local blocking_plys = {}

        for i = 1, #blockers do
            local block = blockers[i]

            if
                not IsValid(block)
                or not block:IsPlayer()
                or block == ply
                or not block:IsTerror()
            then
                continue
            end

            blocking_plys[#blocking_plys + 1] = block
        end

        return false, blocking_plys
    end

    return false, nil
end

local function DoTeleport(ply, teleport, weapon)
    if IsValid(ply) and ply:IsTerror() and teleport then
        local fail = false

        local block_world, block_plys = CanTeleportToPos(ply, teleport.pos)

        if block_world then
            -- if blocked by prop/world, always fail
            fail = true
        elseif block_plys and #block_plys > 0 then
            -- if blocked by player, maybe telefrag
            if ttt_telefrags:GetBool() then
                for i = 1, #block_plys do
                    Telefrag(block_plys[i], ply, weapon)
                end
            else
                fail = true
            end
        end

        if not fail then
            TeleportPlayer(ply, teleport)
        else
            ply:Freeze(false)
            LANG.Msg(ply, "tele_failed", nil, MSG_MSTACK_ROLE)
        end
    elseif IsValid(ply) then
        -- should never happen, but at least unfreeze
        ply:Freeze(false)
        LANG.Msg(ply, "tele_failed", nil, MSG_MSTACK_ROLE)
    end
end

local function StartTeleport(ply, teleport, weapon)
    if not IsValid(ply) or not ply:IsTerror() or not teleport then
        return
    end

    teleport.ang = ply:EyeAngles()

    timer.Simple(delay_beamup, function()
        DoTeleport(ply, teleport, weapon)
    end)

    local ang = ply:GetAngles()

    local edata_up = EffectData()
    edata_up:SetOrigin(ply:GetPos())
    edata_up:SetAngles(Angle(0, ang.y, ang.r)) -- deep copy
    edata_up:SetEntity(ply)
    edata_up:SetMagnitude(delay_beamup)
    edata_up:SetRadius(delay_beamdown)

    util.Effect("teleport_beamup", edata_up)

    local edata_dn = EffectData()
    edata_dn:SetOrigin(teleport.pos)
    edata_dn:SetAngles(Angle(0, ang.y, ang.r)) -- deep copy
    edata_dn:SetEntity(ply)
    edata_dn:SetMagnitude(delay_beamup)
    edata_dn:SetRadius(delay_beamdown)

    util.Effect("teleport_beamdown", edata_dn)
end

---
-- @ignore
function SWEP:TeleportRecall()
    local ply = self:GetOwner()

    if not IsValid(ply) or not ply:IsTerror() then
        return
    end

    local mark = self:GetTeleportMark()

    if mark then
        local g = ply:GetGroundEntity()

        if g ~= game.GetWorld() and not IsValid(g) then
            LANG.Msg(ply, "tele_no_ground", nil, MSG_MSTACK_WARN)

            return
        end

        if ply:Crouching() then
            LANG.Msg(ply, "tele_no_crouch", nil, MSG_MSTACK_WARN)

            return
        end

        ply:Freeze(true)

        self:TakePrimaryAmmo(1)

        timer.Simple(0.2, function()
            StartTeleport(ply, mark, self)
        end)
    else
        LANG.Msg(ply, "tele_no_mark", nil, MSG_MSTACK_ROLE)
    end
end

local function CanStoreTeleportPos(ply, pos)
    local g = ply:GetGroundEntity()

    if g ~= game.GetWorld() or (IsValid(g) and g:GetMoveType() ~= MOVETYPE_NONE) then
        return false, "tele_no_mark_ground"
    elseif ply:Crouching() then
        return false, "tele_no_mark_crouch"
    end

    return true, nil
end

---
-- @ignore
function SWEP:TeleportStore()
    local ply = self:GetOwner()

    if IsValid(ply) and ply:IsTerror() then
        local allow, msg = CanStoreTeleportPos(ply, self:GetPos())

        if not allow then
            LANG.Msg(ply, msg, nil, MSG_MSTACK_WARN)

            return
        end

        self:SetTeleportMark(ply:GetPos(), ply:EyeAngles())

        LANG.Msg(ply, "tele_marked", nil, MSG_MSTACK_ROLE)
    end
end

---
-- @ignore
function SWEP:Reload()
    return false
end

if CLIENT then
    ---
    -- @ignore
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("tele_help_pri", "tele_help_sec")

        return BaseClass.Initialize(self)
    end

    ---
    -- @ignore
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

        form:MakeCheckBox({
            serverConvar = "ttt_teleport_telefrags",
            label = "label_teleport_telefrags",
        })
    end
end

---
-- @ignore
function SWEP:ShootEffects() end
