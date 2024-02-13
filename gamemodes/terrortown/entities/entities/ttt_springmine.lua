if SERVER then
    AddCSLuaFile()

    resource.AddFile("sound/springmine/boing.wav")
    resource.AddFile("materials/vgui/ttt/icon_springmine.png")
end

ENT.Base = "ttt_base_placeable"

if CLIENT then
    ENT.PrintName = "name_springmine"
    ENT.Icon = "vgui/ttt/icon_springmine.png"
end

ENT.Projectile = true
ENT.CanHavePrints = true

ENT.WarningSound = Sound("weapons/boing.wav")

ENT.Height = 1000

ENT.Model = Model("models/props_phx/smallwheel.mdl")
ENT.Color = Color(50, 50, 50, 255)

if SERVER then
    local soundBoing = Sound("springmine/boing.wav")

    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetMaterial("models/debug/debugwhite")
        self:SetColor(self.Color)

        self.BaseClass.Initialize(self)

        timer.Simple(1, function()
            if not IsValid(self) then
                return
            end

            self:SetSolidFlags(FSOLID_TRIGGER)
            self:WeldToSurface(true)
        end)

        self:SetHealth(50)

        local mvObject = self:AddMarkerVision("spring_owner")
        mvObject:SetOwner(self:GetOriginator())
        mvObject:SetVisibleFor(VISIBLE_FOR_TEAM)
        mvObject:SyncToClients()
    end

    function ENT:OnRemove()
        self:RemoveMarkerVision("spring_owner")
    end

    function ENT:StartTouch(ent)
        if ent:IsValid() and ent:IsPlayer() then
            self:Boing(ent)
        end
    end

    function ENT:WasDestroyed()
        local originator = self:GetOriginator()

        if not IsValid(originator) then
            return
        end

        LANG.Msg(originator, "msg_springmine_destroyed", nil, MSG_MSTACK_WARN)
    end

    function ENT:Boing(ply)
        self:EmitSound(soundBoing, 100)

        if not self:IsValid() then
            return
        end

        local velPly = ply:GetVelocity()

        ply:SetVelocity(Vector(velPly.x * 2, velPly.y * 2, self.Height))
        ply.was_pushed = {
            att = self:GetOriginator(),
            t = CurTime(),
            infl = self,
        }

        self:Remove()
    end
end

if CLIENT then
    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local materialSpringmine = Material("vgui/ttt/marker_vision/springmine")

    -- handle looking at C4
    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDSpringmine", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not client:IsTerror()
            or not IsValid(ent)
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "ttt_springmine"
            or client:GetTeam() ~= ent:GetOriginator():GetTeam()
        then
            return
        end

        -- enable targetID rendering
        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(TryT(ent.PrintName))
        tData:AddIcon(materialSpringmine)
    end)

    hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionSpringMine", function(mvData)
        local client = LocalPlayer()
        local ent = mvData:GetEntity()
        local mvObject = mvData:GetMarkerVisionObject()

        if not client:IsTerror() or not mvObject:IsObjectFor(ent, "spring_owner") then
            return
        end

        local originator = ent:GetOriginator()
        local nick = IsValid(originator) and originator:Nick() or "---"

        local distance = math.Round(util.HammerUnitsToMeters(mvData:GetEntityDistance()), 1)

        mvData:EnableText()

        mvData:AddIcon(materialSpringmine)
        mvData:SetTitle(TryT(ent.PrintName))

        mvData:AddDescriptionLine(ParT("marker_vision_owner", { owner = nick }))
        mvData:AddDescriptionLine(ParT("marker_vision_distance", { distance = distance }))

        mvData:AddDescriptionLine(TryT(mvObject:GetVisibleForTranslationKey()), COLOR_SLATEGRAY)
    end)
end
