---
-- @class ENT
-- @desc Radio equipment playing distraction sounds
-- @section ttt_radio

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("ttt_base_placeable")

if CLIENT then
    -- this entity can be DNA-sampled so we need some display info
    ENT.Icon = "vgui/ttt/icon_radio"
    ENT.PrintName = "radio_name"
end

ENT.Base = "ttt_base_placeable"

ENT.Model = "models/props/cs_office/radio.mdl"

ENT.CanHavePrints = false

ENT.pickupWeaponClass = "weapon_ttt_radio"

ENT.SoundLimit = 5
ENT.SoundDelay = 0.5

---
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)

    BaseClass.Initialize(self)

    if SERVER then
        self:SetMaxHealth(40)
    end

    self:SetHealth(40)

    if SERVER then
        self:SetUseType(SIMPLE_USE)

        local mvObject = self:AddMarkerVision("radio_owner")
        mvObject:SetOwner(self:GetOriginator())
        mvObject:SetVisibleFor(VISIBLE_FOR_TEAM)
        mvObject:SyncToClients()
    end

    -- Register with owner
    if CLIENT then
        local client = LocalPlayer()

        if client == self:GetOriginator() then
            client.radio = self
        end
    end

    self.SoundQueue = {}
    self.Playing = false
    self.fingerprints = {}
end

---
-- @param Player activator
-- @realm shared
function ENT:PlayerCanPickupWeapon(activator)
    return activator == self:GetOriginator()
end

if SERVER then
    ---
    -- @realm server
    function ENT:WasDestroyed()
        local originator = self:GetOriginator()

        if not IsValid(originator) then
            return
        end

        LANG.Msg(originator, "radio_broken", nil, MSG_MSTACK_WARN)
    end

    ---
    -- @param Player activator
    -- @param Weapon wep
    -- @realm server
    function ENT:OnPickup(activator, wep)
        local prints = self.fingerprints or {}

        wep.fingerprints = wep.fingerprints or {}

        table.Add(wep.fingerprints, prints)
    end
end

---
-- @realm shared
function ENT:OnRemove()
    if CLIENT then
        local client = LocalPlayer()

        if client ~= self:GetOriginator() then
            return
        end

        client.radio = nil
    else
        self:RemoveMarkerVision("radio_owner")
    end
end
---
-- @param Sound snd
-- @realm shared
function ENT:AddSound(snd)
    if #self.SoundQueue < self.SoundLimit then
        self.SoundQueue[#self.SoundQueue + 1] = snd
    end
end

local simplesounds = {
    scream = {
        Sound("vo/npc/male01/pain07.wav"),
        Sound("vo/npc/male01/pain08.wav"),
        Sound("vo/npc/male01/pain09.wav"),
        Sound("vo/npc/male01/no02.wav"),
    },
    explosion = {
        Sound("BaseExplosionEffect.Sound"),
    },
}

local serialsounds = {
    footsteps = {
        sound = {
            {
                Sound("player/footsteps/concrete1.wav"),
                Sound("player/footsteps/concrete2.wav"),
            },
            {
                Sound("player/footsteps/concrete3.wav"),
                Sound("player/footsteps/concrete4.wav"),
            },
        },
        times = { 8, 16 },
        delay = 0.35,
        ampl = 80,
    },
    burning = {
        sound = {
            Sound("General.BurningObject"),
            Sound("General.StopBurning"),
        },
        times = { 2, 2 },
        delay = 4,
    },
    beeps = {
        sound = {
            Sound("weapons/c4/c4_beep1.wav"),
        },
        delay = 0.75,
        times = { 8, 12 },
        ampl = 70,
    },
}

local gunsounds = {
    shotgun = {
        sound = Sound("Weapon_XM1014.Single"),
        delay = 0.8,
        times = { 1, 3 },
        burst = false,
    },
    pistol = {
        sound = Sound("Weapon_FiveSeven.Single"),
        delay = 0.4,
        times = { 2, 4 },
        burst = false,
    },
    mac10 = {
        sound = Sound("Weapon_mac10.Single"),
        delay = 0.065,
        times = { 5, 10 },
        burst = true,
    },
    deagle = {
        sound = Sound("Weapon_Deagle.Single"),
        delay = 0.6,
        times = { 1, 3 },
        burst = false,
    },
    m16 = {
        sound = Sound("Weapon_M4A1.Single"),
        delay = 0.2,
        times = { 1, 5 },
        burst = true,
    },
    rifle = {
        sound = Sound("weapons/scout/scout_fire-1.wav"),
        delay = 1.5,
        times = { 1, 1 },
        burst = false,
        ampl = 80,
    },
    huge = {
        sound = Sound("Weapon_m249.Single"),
        delay = 0.055,
        times = { 6, 12 },
        burst = true,
    },
}

---
-- @param Sound snd
-- @param number ampl
-- @param boolean last
-- @realm shared
function ENT:PlayDelayedSound(snd, ampl, last)
    -- maybe we can get destroyed while a timer is still up
    if not IsValid(self) then
        return
    end

    if istable(snd) then
        snd = table.Random(snd)
    end

    self:BroadcastSound(snd, ampl)

    self.Playing = not last
end

---
-- @param Sound snd
-- @realm shared
function ENT:PlaySound(snd)
    local slf = self

    if simplesounds[snd] then
        self:BroadcastSound(table.Random(simplesounds[snd]))
    elseif gunsounds[snd] then
        local gunsound = gunsounds[snd]
        local times = math.random(gunsound.times[1], gunsound.times[2])
        local t = 0

        for i = 1, times do
            timer.Simple(t, function()
                if not IsValid(slf) then
                    return
                end

                slf:PlayDelayedSound(gunsound.sound, gunsound.ampl or 90, i == times)
            end)

            if gunsound.burst then
                t = t + gunsound.delay
            else
                t = t + math.Rand(gunsound.delay, gunsound.delay * 2)
            end
        end
    elseif serialsounds[snd] then
        local serialsound = serialsounds[snd]
        local num = #serialsound.sound
        local times = math.random(serialsound.times[1], serialsound.times[2])
        local t = 0
        local idx = 1

        for i = 1, times do
            timer.Simple(t, function()
                if not IsValid(slf) then
                    return
                end

                slf:PlayDelayedSound(serialsound.sound[idx], serialsound.ampl or 75, i == times)
            end)

            t = t + serialsound.delay
            idx = idx + 1

            if idx > num then
                idx = 1
            end
        end
    end
end

local nextplay = 0

---
-- @realm shared
function ENT:Think()
    if CurTime() <= nextplay or not istable(self.SoundQueue) or #self.SoundQueue <= 0 then
        return
    end

    if not self.Playing then
        self:PlaySound(table.remove(self.SoundQueue, 1))
    end

    -- always do slf, makes timing work out a little better
    nextplay = CurTime() + self.SoundDelay
end

if CLIENT then
    local materialRadio = Material("vgui/ttt/marker_vision/radio")

    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    -- handle looking at radio
    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDRadio", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not IsValid(client)
            or not client:IsTerror()
            or not client:Alive()
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "ttt_radio"
        then
            return
        end

        -- enable targetID rendering
        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(TryT(ent.PrintName))

        if ent:PlayerCanPickupWeapon(client) then
            tData:SetKeyBinding("+use")
            tData:SetSubtitle(ParT("target_pickup", { usekey = Key("+use", "USE") }))
        else
            tData:SetSubtitle(TryT("entity_pickup_owner_only"))
        end

        tData:AddDescriptionLine(TryT("radio_short_desc"))
    end)

    hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionRadio", function(mvData)
        local ent = mvData:GetEntity()
        local mvObject = mvData:GetMarkerVisionObject()

        if not mvObject:IsObjectFor(ent, "radio_owner") then
            return
        end

        local originator = ent:GetOriginator()
        local nick = IsValid(originator) and originator:Nick() or "---"

        local distance = util.DistanceToString(mvData:GetEntityDistance(), 1)

        mvData:EnableText()

        mvData:SetTitle(TryT(ent.PrintName))
        mvData:AddIcon(materialRadio)

        mvData:SetSubtitle(ParT("use_entity", { usekey = Key("+use", "USE") }))

        mvData:AddDescriptionLine(ParT("marker_vision_owner", { owner = nick }))
        mvData:AddDescriptionLine(ParT("marker_vision_distance", { distance = distance }))

        mvData:AddDescriptionLine(TryT(mvObject:GetVisibleForTranslationKey()), COLOR_SLATEGRAY)
    end)

    ---
    -- This is triggered, when you focus a marker of an entity and press 'Use'-Key
    -- Opens the radio menu
    -- @param Player ply The player that used this entity. Always LocalPlayer here.
    -- @return bool True, because this shouldn't be used serverside
    -- @realm client
    function ENT:RemoteUse(ply)
        TRADIO:Toggle(self)

        return true
    end
end

if SERVER then
    local soundtypes = {
        "scream",
        "shotgun",
        "explosion",
        "pistol",
        "mac10",
        "deagle",
        "m16",
        "rifle",
        "huge",
        "burning",
        "beeps",
        "footsteps",
    }

    local function RadioCmd(ply, cmd, args)
        if not IsValid(ply) or not ply:IsActive() or #args ~= 2 then
            return
        end

        local eidx = tonumber(args[1])
        local snd = tostring(args[2])

        if not eidx or not snd then
            return
        end

        local radio = Entity(eidx)

        if ply:GetTeam() ~= radio:GetOriginator():GetTeam() then
            return
        end

        if
            not IsValid(radio)
            or radio:GetOriginator() ~= ply
            or radio:GetClass() ~= "ttt_radio"
        then
            return
        end

        if not table.HasValue(soundtypes, snd) then
            ErrorNoHaltWithStack("Received radio sound not in table from", ply)

            return
        end

        radio:AddSound(snd)
    end
    concommand.Add("ttt_radio_play", RadioCmd)
end
