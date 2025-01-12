---
-- Spectator prop meddling
-- @module PROPSPEC

local string = string
local math = math
local IsValid = IsValid
local timer = timer

PROPSPEC = {}

local cvPropspecToggle = GetConVar("ttt_spec_prop_control")

---
-- @realm server
local cvPropspecBase = CreateConVar("ttt_spec_prop_base", "8", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cvPropspecMin =
    CreateConVar("ttt_spec_prop_maxpenalty", "-6", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cvPropspecMax = CreateConVar("ttt_spec_prop_maxbonus", "16", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cvPropspecDashMulitplier =
    CreateConVar("ttt_spec_prop_dash", "2", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- Forces a @{Player} to spectate an @{Entity}
-- @param Player ply
-- @param Entity ent
-- @realm server
function PROPSPEC.Start(ply, ent)
    ply:Spectate(OBS_MODE_CHASE)
    ply:SpectateEntity(ent, true)

    local bonus =
        math.Clamp(math.ceil(ply:Frags() * 0.5), cvPropspecMin:GetInt(), cvPropspecMax:GetInt())

    ply.propspec = {
        ent = ent,
        t = 0,
        retime = 0,
        punches = 0,
        max = cvPropspecBase:GetInt() + bonus,
    }

    ent:SetNWEntity("spec_owner", ply)
    ply:SetNWInt("bonuspunches", bonus)
end

local function IsWhitelistedClass(cls)
    return string.match(cls, "prop_physics*") or string.match(cls, "func_physbox*")
end

---
-- Attempts to force a @{Player} to spectate an @{Entity}
-- @param Player ply
-- @param Entity ent
-- @realm server
function PROPSPEC.Target(ply, ent)
    if
        not cvPropspecToggle:GetBool()
        or not IsValid(ply)
        or not ply:IsSpec()
        or not IsValid(ent)
        or IsValid(ent:GetNWEntity("spec_owner", nil))
    then
        return
    end

    local phys = ent:GetPhysicsObject()

    if
        ent:GetName() ~= "" and not GAMEMODE.propspec_allow_named
        or not IsValid(phys)
        or not phys:IsMoveable()
    then
        return
    end

    -- normally only specific whitelisted ent classes can be possessed, but
    -- custom ents can mark themselves possessable as well
    if not ent.AllowPropspec and not IsWhitelistedClass(ent:GetClass()) then
        return
    end

    PROPSPEC.Start(ply, ent)
end

---
-- Clear any propspec state a @{Player} has. Safe even if @{Player} is not currently
-- spectating.
-- @param Player ply
-- @realm server
function PROPSPEC.Clear(ply)
    local ent = (ply.propspec and ply.propspec.ent) or ply:GetObserverTarget()

    if IsValid(ent) then
        ent:SetNWEntity("spec_owner", nil)
    end

    ply.propspec = nil

    ply:UnSpectate()
end

---
-- Stops a @{Player} spectating an @{Entity}
-- @param Player ply
-- @realm server
function PROPSPEC.End(ply)
    PROPSPEC.Clear(ply)

    ply:Spectate(OBS_MODE_ROAMING)
    ply:ResetViewRoll()

    timer.Simple(0.1, function()
        if not IsValid(ply) then
            return
        end

        ply:ResetViewRoll()
    end)
end

---
-- @realm server
local propspec_force = CreateConVar("ttt_spec_prop_force", "110", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- Triggers an event based on the pressed key
-- @param Player ply The @{Player} pressing the key. If running client-side, this will always be @{LocalPlayer}
-- @param number key The key that the @{Player} pressed using <a href="https://wiki.facepunch.com/gmod/Enums/IN">IN_Enums</a>.
-- @return boolean
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:KeyPress
function PROPSPEC.Key(ply, key)
    local ent = ply.propspec.ent
    local validEnt = IsValid(ent)
    local phys = validEnt and ent:GetPhysicsObject()

    if not validEnt or not IsValid(phys) then
        PROPSPEC.End(ply)

        return false
    end

    if not phys:IsMoveable() then
        PROPSPEC.End(ply)

        return true
    elseif phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then
        -- we can stay with the prop while it's held, but not affect it
        if key == IN_DUCK then
            PROPSPEC.End(ply)
        end

        return true
    end

    -- always allow leaving
    if key == IN_DUCK then
        PROPSPEC.End(ply)

        return true
    end

    local pSpec = ply.propspec

    if pSpec.t > CurTime() or pSpec.punches < 1 then
        return true
    end

    local mass = math.min(150, phys:GetMass())
    local force = propspec_force:GetInt()
    local mf = mass * force
    local vectorAim = ply:GetAimVector()

    local vectorAimPlanar = Vector(vectorAim.x, vectorAim.y, 0)
    vectorAimPlanar:Normalize()

    local vectorPerpendicularLeft = Vector(-vectorAimPlanar.y, vectorAimPlanar.x, 0)
    local vectorPerpendicularRight = Vector(vectorAimPlanar.y, -vectorAimPlanar.x, 0)

    local multiplierPunches = 1

    pSpec.t = CurTime() + 0.15

    if key == IN_JUMP then
        phys:ApplyForceCenter(Vector(0, 0, mf))

        pSpec.t = CurTime() + 0.05
    elseif key == IN_SPEED then
        multiplierPunches = cvPropspecDashMulitplier:GetInt()

        phys:ApplyForceCenter(vectorAim:GetNormalized() * mf * cvPropspecDashMulitplier:GetInt())
    elseif key == IN_FORWARD then
        phys:ApplyForceCenter(vectorAimPlanar * mf)
    elseif key == IN_BACK then
        phys:ApplyForceCenter(-vectorAimPlanar * mf)
    elseif key == IN_MOVELEFT then
        phys:ApplyForceCenter(vectorPerpendicularLeft * mf * 0.33)
    elseif key == IN_MOVERIGHT then
        phys:ApplyForceCenter(vectorPerpendicularRight * mf * 0.33)
    else
        return true -- eat other keys, and do not decrement punches
    end

    pSpec.punches = math.max(pSpec.punches - multiplierPunches, 0)

    ply:SetNWFloat("specpunches", pSpec.punches / pSpec.max)

    return true
end

---
-- @realm server
local propspec_retime =
    CreateConVar("ttt_spec_prop_rechargetime", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- Recharges the amount of punches a @{Player} can do (if possible)
-- @note This automatically calculates the recharge based on time
-- @param Player ply
-- @realm server
function PROPSPEC.Recharge(ply)
    local pr = ply.propspec

    if pr.retime >= CurTime() then
        return
    end

    pr.punches = math.min(pr.punches + 1, pr.max)

    ply:SetNWFloat("specpunches", pr.punches / pr.max)

    pr.retime = CurTime() + propspec_retime:GetFloat()
end
