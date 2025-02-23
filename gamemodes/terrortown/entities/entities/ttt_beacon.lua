---
-- @class ENT
-- @section ttt_beacon

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("ttt_base_placeable")

if CLIENT then
    ENT.Icon = "vgui/ttt/icon_beacon"
    ENT.PrintName = "beacon_name"
end

ENT.Base = "ttt_base_placeable"

ENT.Model = "models/props_lab/reciever01a.mdl"

ENT.CanHavePrints = true

ENT.pickupWeaponClass = "weapon_ttt_beacon"

ENT.timeLastBeep = CurTime()
ENT.lastPlysFound = {}

local beaconDetectionRange = 135

---
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)

    BaseClass.Initialize(self)

    if SERVER then
        self:SetMaxHealth(100)
    end
    self:SetHealth(100)

    if SERVER then
        self:SetUseType(SIMPLE_USE)
        self:NextThink(CurTime() + 1)

        local mvObject = self:AddMarkerVision("beacon_owner")
        mvObject:SetOwner(ROLE_DETECTIVE)
        mvObject:SetVisibleFor(VISIBLE_FOR_ROLE)
        mvObject:SyncToClients()
    end
end

---
-- @param Player activator
-- @realm shared
function ENT:PlayerCanPickupWeapon(activator)
    return self:GetOriginator() == activator
end

if SERVER then
    local soundBeep = Sound("weapons/c4/cc4_beep1.wav")

    ---
    -- @realm server
    function ENT:WasDestroyed()
        local originator = self:GetOriginator()

        if not IsValid(originator) then
            return
        end

        LANG.Msg(originator, "msg_beacon_destroyed", nil, MSG_MSTACK_WARN)
    end

    ---
    -- @realm server
    function ENT:Think()
        if self.timeLastBeep + 5 >= CurTime() then
            sound.Play(soundBeep, self:GetPos(), 100, 80)

            self.timeLastBeep = CurTime()
        end

        local entsFound = ents.FindInSphere(self:GetPos(), beaconDetectionRange)
        local plysFound = {}
        local affectedPlayers = {}

        for i = 1, #entsFound do
            local ent = entsFound[i]

            if not IsValid(ent) or not ent:IsPlayer() or not ent:IsTerror() then
                continue
            end

            ---
            -- @realm server
            if hook.Run("TTT2BeaconDetectPlayer", ent, self) == false then
                continue
            end

            plysFound[ent] = true
            affectedPlayers[ent] = true
        end

        table.Merge(affectedPlayers, self.lastPlysFound)

        for ply in pairs(affectedPlayers) do
            if plysFound[ply] and not self.lastPlysFound[ply] then
                -- newly added player in range
                local mvObject = ply:AddMarkerVision("beacon_player")
                mvObject:SetOwner(self:GetOriginator())
                mvObject:SetVisibleFor(VISIBLE_FOR_ALL)
                mvObject:SetColor(roles.DETECTIVE.color)
                mvObject:SyncToClients()
            elseif not plysFound[ply] and self.lastPlysFound[ply] then
                -- player lost in range
                ply:RemoveMarkerVision("beacon_player")
            end
        end

        self.lastPlysFound = plysFound

        self:NextThink(CurTime() + 0.25)

        return true
    end

    ---
    -- @realm server
    function ENT:OnRemove()
        for ply in pairs(self.lastPlysFound) do
            ply:RemoveMarkerVision("beacon_player")
        end

        self:RemoveMarkerVision("beacon_owner")
    end

    ---
    -- @realm server
    function ENT:UpdateTransmitState()
        return TRANSMIT_ALWAYS
    end

    hook.Add("PlayerDeath", "BeaconTrackPlayerDeath", function(victim)
        local entsFound = ents.FindInSphere(victim:GetPos(), beaconDetectionRange)
        local beaconsFound = {}
        local playersNotified = {}

        for i = 1, #entsFound do
            local ent = entsFound[i]

            if not IsValid(ent) or ent:GetClass() ~= "ttt_beacon" then
                continue
            end

            beaconsFound[#beaconsFound + 1] = ent
        end

        for i = 1, #beaconsFound do
            local beacon = beaconsFound[i]
            local beaconOwner = beacon:GetOriginator()

            if not IsValid(beaconOwner) or table.HasValue(playersNotified, beaconOwner) then
                continue
            end

            ---
            -- @realm server
            if hook.Run("TTT2BeaconDeathNotify", victim, beacon) == false then
                continue
            end

            LANG.Msg(beaconOwner, "msg_beacon_death", nil, MSG_MSTACK_WARN)

            -- make sure a player is only notified once, even if multiple beacons are triggered
            playersNotified[#playersNotified + 1] = beaconOwner
        end
    end)

    ---
    -- Hook that is called when a player is about to be found by a beacon.
    -- This hook can be used to cancel the detection.
    -- @param Player ply The player that the beacon has found
    -- @param Entity ent The beacon entity that found the player
    -- @return boolean Return false to cancel the player being detected
    -- @hook
    -- @realm server
    function GAMEMODE:TTT2BeaconDetectPlayer(ply, ent) end

    ---
    -- Hook that is called when a beacon is about to report a death.
    -- This hook can be used to cancel the notification.
    -- @param Player victim The player that died
    -- @param Entity beacon The beacon entity that the player died near
    -- @return boolean Return false to cancel the death being reported
    -- @hook
    -- @realm server
    function GAMEMODE:TTT2BeaconDeathNotify(victim, beacon) end
end

if CLIENT then
    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local baseOpacity = 35
    local factorRenderDistance = 3

    local materialBeacon = Material("vgui/ttt/marker_vision/beacon")
    local materialPlayer = Material("vgui/ttt/tid/tid_big_role_not_known")

    -- handle looking at Beacon
    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDBeacon", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not IsValid(client)
            or not client:IsTerror()
            or not client:Alive()
            or not IsValid(ent)
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "ttt_beacon"
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
            tData:AddIcon(roles.DETECTIVE.iconMaterial)
            tData:SetSubtitle(TryT("entity_pickup_owner_only"))
        end

        tData:AddDescriptionLine(TryT("beacon_short_desc"))
    end)

    hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionBeacon", function(mvData)
        local ent = mvData:GetEntity()
        local mvObject = mvData:GetMarkerVisionObject()

        if not mvObject:IsObjectFor(ent, "beacon_owner") then
            return
        end

        local owner = ent:GetOriginator()
        local nick = IsValid(owner) and owner:Nick() or "---"

        local distance = util.DistanceToString(mvData:GetEntityDistance(), 1)

        mvData:EnableText()

        mvData:AddIcon(materialBeacon)
        mvData:SetTitle(TryT(ent.PrintName))

        mvData:AddDescriptionLine(ParT("marker_vision_owner", { owner = nick }))
        mvData:AddDescriptionLine(ParT("marker_vision_distance", { distance = distance }))

        mvData:AddDescriptionLine(TryT(mvObject:GetVisibleForTranslationKey()), COLOR_SLATEGRAY)
    end)

    hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionBeaconPlys", function(mvData)
        local ent = mvData:GetEntity()
        local mvObject = mvData:GetMarkerVisionObject()

        if not mvObject:IsObjectFor(ent, "beacon_player") or ent == LocalPlayer() then
            return
        end

        mvData:EnableText()

        mvData:AddIcon(materialPlayer)
        mvData:SetTitle(TryT("beacon_marker_vision_player"))

        mvData:AddDescriptionLine(TryT("beacon_marker_vision_player_tracked"))

        mvData:AddDescriptionLine(TryT(mvObject:GetVisibleForTranslationKey()), COLOR_SLATEGRAY)
    end)

    hook.Add("PostDrawTranslucentRenderables", "BeaconRenderRadius", function(_, bSkybox)
        if bSkybox then
            return
        end

        local client = LocalPlayer()

        if not client:GetSubRoleData().isPolicingRole then
            return
        end

        local maxRenderDistance = beaconDetectionRange * factorRenderDistance
        local entities = ents.FindInSphere(client:GetPos(), maxRenderDistance)

        local colorSphere = util.ColorLighten(roles.DETECTIVE.color, 120)

        for i = 1, #entities do
            local ent = entities[i]

            if ent:GetClass() ~= "ttt_beacon" or ent:GetOriginator() ~= client then
                continue
            end

            local distance = math.max(beaconDetectionRange, client:GetPos():Distance(ent:GetPos()))
            colorSphere.a = baseOpacity
                * math.max(maxRenderDistance - distance, 0)
                / maxRenderDistance

            render.SetColorMaterial()

            render.DrawSphere(ent:GetPos(), beaconDetectionRange, 30, 30, colorSphere)
            render.CullMode(MATERIAL_CULLMODE_CW)

            render.DrawSphere(ent:GetPos(), beaconDetectionRange, 30, 30, colorSphere)
            render.CullMode(MATERIAL_CULLMODE_CCW)
        end
    end)
end
