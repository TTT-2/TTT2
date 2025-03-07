---
-- @class ENT
-- @desc c4 explosive
-- @section C4

local math = math
local hook = hook
local table = table
local net = net
local IsValid = IsValid
local playerGetAll = player.GetAll

local defuserNearRadius = 90000

if SERVER then
    AddCSLuaFile("cl_init.lua")
    AddCSLuaFile("shared.lua")
end

DEFINE_BASECLASS("ttt_base_placeable")

if CLIENT then
    -- this entity can be DNA-sampled so we need some display info
    ENT.Icon = "vgui/ttt/icon_c4"
    ENT.PrintName = "C4"
end

C4_WIRE_COUNT = 6
C4_MINIMUM_TIME = 45
C4_MAXIMUM_TIME = 600

ENT.Base = "ttt_base_placeable"
ENT.Model = "models/weapons/w_c4_planted.mdl"

ENT.CanHavePrints = true
ENT.Avoidable = true

ENT.isDestructible = false

---
-- @accessor Entity
-- @realm shared
AccessorFunc(ENT, "thrower", "Thrower")

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "radius", "Radius", FORCE_NUMBER)

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "radius_inner", "RadiusInner", FORCE_NUMBER)

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "arm_time", "ArmTime", FORCE_NUMBER)

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "timer_length", "TimerLength", FORCE_NUMBER)

ENT.timeBeep = 0
ENT.safeWires = nil

---
-- Initializes the data
-- @realm shared
function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)

    self:NetworkVar("Int", 0, "ExplodeTime")
    self:NetworkVar("Bool", 0, "Armed")
end

---
-- Initializes the C4
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)

    BaseClass.Initialize(self)

    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end

    self.safeWires = nil
    self.timeBeep = 0
    self.DisarmCausedExplosion = false

    self:SetTimerLength(0)
    self:SetExplodeTime(0)
    self:SetArmed(false)

    if not self:GetThrower() then
        self:SetThrower(nil)
    end

    if not self:GetRadiusInner() then
        self:SetRadiusInner(GetConVar("ttt2_c4_radius_inner"):GetInt() or 500)
    end

    if not self:GetRadius() then
        self:SetRadius(GetConVar("ttt2_c4_radius"):GetInt() or 600)
    end

    if not self:GetDmg() then
        self:SetDmg(200 * (weapons.GetStored("weapon_ttt_c4").damageScaling or 1))
    end
end

---
-- @param number length time
-- @realm shared
function ENT:SetDetonateTimer(length)
    self:SetTimerLength(length)
    self:SetExplodeTime(CurTime() + length)
end

---
-- @param number t
-- @return number
-- @realm shared
function ENT.SafeWiresForTime(t)
    local m = t / 60

    if m > 4 then
        return 1
    elseif m > 3 then
        return 2
    elseif m > 2 then
        return 3
    elseif m > 1 then
        return 4
    else
        return 5
    end
end

local c4boom = Sound("c4.explode")

---
-- @param table tr Trace Structure
-- @realm shared
function ENT:Explode(tr)
    ---
    -- @realm shared
    local result, message = hook.Run("TTTC4Explode", self)

    if result == false then
        if SERVER and message then
            LANG.Msg(self:GetThrower(), message, nil, MSG_MSTACK_WARN)
        end

        return
    end

    if SERVER then
        self:SetNoDraw(true)
        self:SetSolid(SOLID_NONE)

        -- pull out of the surface
        if tr.Fraction ~= 1.0 then
            self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
        end

        local pos = self:GetPos()

        if
            util.PointContents(pos) == CONTENTS_WATER
            or gameloop.GetRoundState() ~= ROUND_ACTIVE
        then
            self:Remove()
            self:SetExplodeTime(0)

            return
        end

        local dmgowner = self:GetThrower()
        dmgowner = IsValid(dmgowner) and dmgowner or self

        local r_inner = self:GetRadiusInner()
        local r_outer = self:GetRadius()

        if self.DisarmCausedExplosion then
            r_inner = r_inner / 2.5
            r_outer = r_outer / 2.5
        end

        gameEffects.ExplosiveSphereDamage(
            dmgowner,
            ents.Create("weapon_ttt_c4"),
            self:GetDmg(),
            pos,
            r_outer,
            r_inner
        )

        local effect = EffectData()
        effect:SetStart(pos)
        effect:SetOrigin(pos)

        -- these don't have much effect with the default Explosion
        effect:SetScale(r_outer)
        effect:SetRadius(r_outer)
        effect:SetMagnitude(self:GetDmg())

        if tr.Fraction ~= 1.0 then
            effect:SetNormal(tr.HitNormal)
        end

        effect:SetOrigin(pos)

        util.Effect("Explosion", effect, true, true)
        util.Effect("HelicopterMegaBomb", effect, true, true)

        self:BroadcastSound(c4boom, 100)

        -- extra push
        local phexp = ents.Create("env_physexplosion")
        phexp:SetPos(pos)
        phexp:SetKeyValue("magnitude", self:GetDmg())
        phexp:SetKeyValue("radius", r_outer)
        phexp:SetKeyValue("spawnflags", "19")
        phexp:Spawn()
        phexp:Fire("Explode", "", 0)

        -- few fire bits to ignite things
        timer.Simple(0.2, function()
            gameEffects.StartFires(pos, tr, 4, 5, true, dmgowner, 500, false, 132, 0)
        end)

        self:SetExplodeTime(0)

        events.Trigger(EVENT_C4EXPLODE, dmgowner)

        self:Remove()
    else
        local spos = self:GetPos()
        local trs = util.TraceLine({
            start = spos + Vector(0, 0, 64),
            endpos = spos + Vector(0, 0, -128),
            filter = self,
        })

        util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)

        self:SetExplodeTime(0)
    end
end

---
-- Checks if a player with the defuser weapon is in range.
-- @return[default=false] boolean
-- @realm shared
function ENT:IsDefuserInRange()
    local center = self:GetPos()
    local d = 0.0
    local diff = nil

    local plys = playerGetAll()
    for i = 1, #plys do
        local ply = plys[i]
        if not ply:IsActive() or not ply:GetSubRoleData().isPolicingRole then
            continue
        end

        -- dot of the difference with itself is distance squared
        diff = center - ply:GetPos()
        d = diff:Dot(diff)

        if d < defuserNearRadius and ply:HasWeapon("weapon_ttt_defuser") then
            return true
        end
    end

    return false
end

local soundBeep = Sound("weapons/c4/c4_beep1.wav")
local MAX_MOVE_RANGE = 1000000 -- sq of 1000

---
-- @realm shared
function ENT:Think()
    if not self:GetArmed() then
        return
    end

    if SERVER then
        local curpos = self:GetPos()

        if self.LastPos and self.LastPos:DistToSqr(curpos) > MAX_MOVE_RANGE then
            self:Disarm(nil)

            return
        end

        self.LastPos = curpos
    end

    local etime = self:GetExplodeTime()

    if self:GetArmed() and etime ~= 0 and etime < CurTime() then
        -- find the ground if it's near and pass it to the explosion
        local spos = self:GetPos()
        local tr = util.TraceLine({
            start = spos,
            endpos = spos + Vector(0, 0, -32),
            mask = MASK_SHOT_HULL,
            filter = self:GetThrower(),
        })

        local success, err = pcall(self.Explode, self, tr)
        if not success then
            -- prevent effect spam on Lua error
            self:Remove()

            ErrorNoHaltWithStack("ERROR CAUGHT: ttt_c4: " .. err .. "\n")
        end
    elseif self:GetArmed() and CurTime() > self.timeBeep then
        local amp = 48

        if self:IsDefuserInRange() then
            amp = 65

            local dlight = CLIENT and DynamicLight(self:EntIndex())
            if dlight then
                dlight.Pos = self:GetPos()
                dlight.r = 255
                dlight.g = 0
                dlight.b = 0
                dlight.Brightness = 1
                dlight.Size = 128
                dlight.Decay = 500
                dlight.DieTime = CurTime() + 0.1
            end
        elseif SERVER then
            -- volume lower for long fuse times, bottoms at 50 at +5mins
            amp = amp + math.max(0, 12 - (0.03 * self:GetTimerLength()))
        end

        if SERVER then
            self:BroadcastSound(soundBeep, amp)
        end

        local btime = (etime - CurTime()) / 30

        self.timeBeep = CurTime() + btime
    end
end

---
-- @return boolen
-- @see ENT:GetArmed
-- @realm shared
function ENT:Defusable()
    return self:GetArmed()
end

-- Timer configuration handling

if SERVER then
    ---
    -- @realm server
    function ENT:OnRemove()
        self:RemoveMarkerVision("c4_owner")
    end

    ---
    -- @param Player ply
    -- @realm server
    function ENT:Disarm(ply)
        local owner = self:GetOriginator()

        events.Trigger(EVENT_C4DISARM, owner, ply, true)

        if ply ~= owner and IsValid(owner) then
            LANG.Msg(owner, "c4_disarm_warn")
        end

        self:SetExplodeTime(0)
        self:SetArmed(false)

        self:RemoveMarkerVision("c4_owner")

        self.DisarmCausedExplosion = false
    end

    ---
    -- @param Player ply
    -- @realm server
    function ENT:FailedDisarm(ply)
        self.DisarmCausedExplosion = true

        events.Trigger(EVENT_C4DISARM, self:GetOriginator(), ply, false)

        -- tiny moment of zen and realization before the bang
        self:SetExplodeTime(CurTime() + 0.1)
    end

    ---
    -- @param Player ply
    -- @param number time
    -- @realm server
    function ENT:Arm(ply, time)
        -- Initialize armed state
        self:SetDetonateTimer(time)
        self:SetArmTime(CurTime())

        self:SetArmed(true)

        self.DisarmCausedExplosion = false

        -- ply may be a different player than he who dropped us.
        -- Arming player should be the damage owner = "thrower"
        self:SetThrower(ply)

        -- Owner determines who gets messages and can quick-disarm if traitor,
        -- make that the armer as well for now. Theoretically the dropping player
        -- should also be able to quick-disarm, but that's going to be rare.
        self:SetOriginator(ply)

        -- Wire stuff:

        self.safeWires = {}

        -- list of possible wires to make safe
        local choices = {}

        for i = 1, C4_WIRE_COUNT do
            choices[i] = i
        end

        -- random selection process, lot like traitor selection
        local safe_count = self.SafeWiresForTime(time)
        local picked = 0

        while picked < safe_count do
            local pick = math.random(#choices)
            local w = choices[pick]

            if not self.safeWires[w] then
                self.safeWires[w] = true

                table.remove(choices, pick)

                -- owner will end up having the last safe wire on his corpse
                ply.bomb_wire = w

                picked = picked + 1
            end
        end

        events.Trigger(EVENT_C4PLANT, ply)

        local mvObject = self:AddMarkerVision("c4_owner")
        mvObject:SetOwner(ply)
        mvObject:SetVisibleFor(VISIBLE_FOR_TEAM)
        mvObject:SyncToClients()
    end

    local function ReceiveC4Config(ply, cmd, args)
        if not (IsValid(ply) and ply:IsTerror() and #args == 2) then
            return
        end

        local idx = tonumber(args[1])
        local time = tonumber(args[2])

        if not idx or not time then
            return
        end

        local bomb = ents.GetByIndex(idx)

        if IsValid(bomb) and bomb:GetClass() == "ttt_c4" and (not bomb:GetArmed()) then
            if bomb:GetPos():Distance(ply:GetPos()) > 256 then
                -- These cases should never arise in normal play, so no messages
                return
            elseif time < C4_MINIMUM_TIME or time > C4_MAXIMUM_TIME then
                return
            elseif
                IsValid(bomb:GetPhysicsObject())
                and bomb:GetPhysicsObject():HasGameFlag(FVPHYSICS_PLAYER_HELD)
            then
                return
            else
                ---
                -- @realm server
                local result, message = hook.Run("TTTC4Arm", bomb, ply)

                if result ~= false then
                    LANG.Msg(ply, "c4_armed", nil, MSG_MSTACK_ROLE)

                    bomb:Arm(ply, time)
                elseif message then
                    LANG.Msg(ply, message, nil, MSG_MSTACK_WARN)
                end
            end
        end
    end
    concommand.Add("ttt_c4_config", ReceiveC4Config)

    local function SendDisarmResult(ply, bomb, disarmResult)
        ---
        -- @realm server
        local result, message = hook.Run("TTTC4Disarm", bomb, disarmResult, ply)

        if result == false then
            if message then
                LANG.Msg(ply, message, nil, MSG_MSTACK_WARN)
            end

            return
        end

        net.Start("TTT_C4DisarmResult")
        net.WriteEntity(bomb)
        net.WriteBit(disarmResult) -- this way we can squeeze this bit into 16
        net.Send(ply)
    end

    local function ReceiveC4Disarm(ply, cmd, args)
        if not (IsValid(ply) and ply:IsTerror() and #args == 2) then
            return
        end

        local idx = tonumber(args[1])
        local wire = tonumber(args[2])

        if not idx or not wire then
            return
        end

        local bomb = ents.GetByIndex(idx)

        if
            IsValid(bomb)
            and bomb:GetClass() == "ttt_c4"
            and not bomb.DisarmCausedExplosion
            and bomb:GetArmed()
        then
            if bomb:GetPos():Distance(ply:GetPos()) > 256 then
                return
            elseif bomb.safeWires[wire] or ply:IsTraitor() or ply == bomb:GetOriginator() then
                LANG.Msg(ply, "c4_disarmed")

                bomb:Disarm(ply)

                -- only case with success net message
                SendDisarmResult(ply, bomb, true)
            else
                SendDisarmResult(ply, bomb, false)

                -- wrong wire = bomb goes boom
                bomb:FailedDisarm(ply)
            end
        end
    end
    concommand.Add("ttt_c4_disarm", ReceiveC4Disarm)

    local function ReceiveC4Pickup(ply, cmd, args)
        if not (IsValid(ply) and ply:IsTerror() and #args == 1) then
            return
        end

        local idx = tonumber(args[1])
        if not idx then
            return
        end

        local bomb = ents.GetByIndex(idx)

        if IsValid(bomb) and bomb:GetClass() == "ttt_c4" and not bomb:GetArmed() then
            if bomb:GetPos():Distance(ply:GetPos()) > 256 then
                return
            else
                local prints = bomb.fingerprints or {}

                ---
                -- @realm server
                local result, message = hook.Run("TTTC4Pickup", bomb, ply)

                if result == false then
                    if message then
                        LANG.Msg(ply, message, nil, MSG_MSTACK_WARN)
                    end

                    return
                end

                -- picks up weapon, switches if possible and needed, returns weapon if successful
                local wep = ply:SafePickupWeaponClass("weapon_ttt_c4", true)

                if not IsValid(wep) then
                    LANG.Msg(ply, "c4_no_room")

                    return
                end

                wep.fingerprints = wep.fingerprints or {}

                table.Add(wep.fingerprints, prints)

                bomb:Remove()
            end
        end
    end
    concommand.Add("ttt_c4_pickup", ReceiveC4Pickup)

    local function ReceiveC4Destroy(ply, cmd, args)
        if not (IsValid(ply) and ply:IsTerror() and #args == 1) then
            return
        end

        local idx = tonumber(args[1])
        if not idx then
            return
        end

        local bomb = ents.GetByIndex(idx)

        if
            not IsValid(bomb)
            or bomb:GetClass() ~= "ttt_c4"
            or bomb:GetArmed()
            or bomb:GetPos():Distance(ply:GetPos()) > 256
        then
            return
        end

        ---
        -- @realm server
        local result, message = hook.Run("TTTC4Destroyed", bomb, ply)

        if result == false then
            if message then
                LANG.Msg(ply, message, nil, MSG_MSTACK_WARN)
            end

            return
        end

        -- spark to show onlookers we destroyed this bomb
        util.EquipmentDestroyed(bomb:GetPos())

        bomb:Remove()
    end
    concommand.Add("ttt_c4_destroy", ReceiveC4Destroy)

    ---
    -- This hook is run when the C4 is about to be armed.
    -- @param Entity bomb The C4 bomb entity
    -- @param Player ply The player that armed the C4
    -- @return boolean Return false to cancel arming
    -- @return string Return a string with a reason why the arming was canceled,
    -- this message is send as a @{MSTACK} to the player that tried to arm the C4
    -- @hook
    -- @realm server
    function GAMEMODE:TTTC4Arm(bomb, ply) end

    ---
    -- This hook is run when the C4 is about to be disarmed.
    -- @param Entity bomb The C4 bomb entity
    -- @param boolean result The disarming attempt result
    -- @param Player ply The player that armed the C4
    -- @return boolean Return false to cancel disarming
    -- @return string Return a string with a reason why the disarming was canceled,
    -- this message is send as a @{MSTACK} to the player that tried to disarm the C4
    -- @hook
    -- @realm server
    function GAMEMODE:TTTC4Disarm(bomb, result, ply) end

    ---
    -- This hook is run when the C4 is about to be picked up.
    -- @param Entity bomb The C4 bomb entity
    -- @param Player ply The player that tries to picl up the C4
    -- @return boolean Return false to cancel the pickup
    -- @return string Return a string with a reason why the pickup was canceled,
    -- this message is send as a @{MSTACK} to the player that tried to pickup the C4
    -- @hook
    -- @realm server
    function GAMEMODE:TTTC4Pickup(bomb, ply) end

    ---
    -- This hook is run when the C4 is about to be armed.
    -- @param Entity bomb The C4 bomb entity
    -- @param Player ply The player that tries to destroy the C4
    -- @return boolean Return false to cancel the destruction
    -- @return string Return a string with a reason why the destruction was canceled,
    -- this message is send as a @{MSTACK} to the player that tried to destroy the C4
    -- @hook
    -- @realm server
    function GAMEMODE:TTTC4Destroyed(bomb, ply) end
else -- CLIENT
    local materialC4 = Material("vgui/ttt/marker_vision/c4")

    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local key_params = {
        primaryfire = Key("+attack", "MOUSE1"),
        usekey = Key("+use", "USE"),
        walkkey = Key("+walk", "WALK"),
    }

    surface.CreateFont("C4ModelTimer", {
        font = "Default",
        size = 13,
        weight = 0,
        antialias = false,
    })

    ---
    -- Hook that is called if a player uses their use key while focusing on the entity.
    -- Shows C4 UI
    -- @return bool True to prevent pickup
    -- @realm client
    function ENT:ClientUse()
        if IsValid(self) then
            if not self:GetArmed() then
                ShowC4Config(self)
            else
                ShowC4Disarm(self)
            end
        end

        return true
    end

    ---
    -- @return table pos
    -- @realm client
    function ENT:GetTimerPos()
        local att = self:GetAttachment(self:LookupAttachment("controlpanel0_ur"))
        if att then
            return att
        else
            local ang = self:GetAngles()

            ang:RotateAroundAxis(self:GetUp(), -90)

            local pos = self:GetPos()
                + self:GetForward() * 4.5
                + self:GetUp() * 9.0
                + self:GetRight() * 7.8
            return {
                Pos = pos,
                Ang = ang,
            }
        end
    end

    local strtime = util.SimpleTime
    local max = math.max

    ---
    -- @realm client
    function ENT:Draw()
        self:DrawModel()

        if not self:GetArmed() then
            return
        end

        local angpos_ur = self:GetTimerPos()
        if not angpos_ur then
            return
        end

        cam.Start3D2D(angpos_ur.Pos, angpos_ur.Ang, 0.2)

        draw.DrawText(
            strtime(max(0, self:GetExplodeTime() - CurTime()), "%02i:%02i"),
            "C4ModelTimer",
            -1,
            1,
            COLOR_RED,
            TEXT_ALIGN_RIGHT
        )

        cam.End3D2D()
    end

    -- handle looking at C4
    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDC4", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()
        local c_wep = client:GetActiveWeapon()

        if
            not client:IsTerror()
            or not IsValid(ent)
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "ttt_c4"
        then
            return
        end

        local defuser_useable = (IsValid(c_wep) and ent:GetArmed())
                and c_wep:GetClass() == "weapon_ttt_defuser"
            or false

        -- enable targetID rendering
        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(TryT(ent.PrintName))

        if ent:GetArmed() and defuser_useable then
            tData:SetSubtitle(ParT("target_c4_armed_defuser", key_params))
        elseif ent:GetArmed() then
            tData:SetSubtitle(ParT("target_c4_armed", key_params))
        else
            tData:SetSubtitle(ParT("target_c4", key_params))
        end

        tData:SetKeyBinding(defuser_useable and "+attack" or "+use")
        tData:AddDescriptionLine(TryT("c4_short_desc"))
    end)

    hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionC4", function(mvData)
        local ent = mvData:GetEntity()
        local mvObject = mvData:GetMarkerVisionObject()

        if not mvObject:IsObjectFor(ent, "c4_owner") then
            return
        end

        local owner = ent:GetOriginator()
        local nick = IsValid(owner) and owner:Nick() or "---"

        local time = util.SimpleTime(ent:GetExplodeTime() - CurTime(), "%02i:%02i")
        local distance = util.DistanceToString(mvData:GetEntityDistance(), 1)

        mvData:EnableText()

        mvData:SetTitle(TryT(ent.PrintName))

        mvData:AddDescriptionLine(ParT("marker_vision_owner", { owner = nick }))
        mvData:AddDescriptionLine(ParT("c4_marker_vision_time", { time = time }))
        mvData:AddDescriptionLine(ParT("marker_vision_distance", { distance = distance }))

        mvData:AddDescriptionLine(TryT(mvObject:GetVisibleForTranslationKey()), COLOR_SLATEGRAY)

        local color = COLOR_WHITE

        --Calculating damage falloff with inverse square method
        --100% from 0 to innerRadius
        --100% to 0% from innerRadius to outerRadius
        --0% from outerRadius to infinity
        local dFraction = math.max(
            1.0
                - math.max(
                    (mvData:GetEntityDistance() - ent:GetRadiusInner())
                        / (ent:GetRadius() - ent:GetRadiusInner()),
                    0.0
                ),
            0.0
        )
        local dmg = math.Round(ent:GetDmg() * dFraction * dFraction)

        if dmg <= 0 then
            mvData:AddDescriptionLine(TryT("c4_marker_vision_safe_zone"), COLOR_GREEN)
        elseif dmg < 100 then
            mvData:AddDescriptionLine(TryT("c4_marker_vision_damage_zone"), COLOR_ORANGE)

            color = COLOR_ORANGE
        else
            mvData:AddDescriptionLine(TryT("c4_marker_vision_kill_zone"), COLOR_RED)

            color = COLOR_RED
        end

        mvData:AddIcon(
            materialC4,
            (mvData:IsOffScreen() or not mvData:IsOnScreenCenter()) and color
        )

        mvData:SetCollapsedLine(time)
    end)
end

---
-- This hook is called when the C4 is about to explode.
-- @note To cancel a explosion, this hook has to be added on the
-- server and on the client.
-- @param Entity bomb The C4 bomb entity
-- @return boolean Return false to cancel explosion
-- @return string Return a string with a reason why the explosion was canceled
-- @hook
-- @realm shared
function GAMEMODE:TTTC4Explode(bomb) end
