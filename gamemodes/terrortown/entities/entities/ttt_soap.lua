if SERVER then
    AddCSLuaFile()
end

ENT.Base = "ttt_base_placeable"

if CLIENT then
    ENT.PrintName = "weapon_soap_name"
    ENT.Icon = "vgui/ttt/icon_soap"
end

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.CanUseKey = true
ENT.pickupWeaponClass = "weapon_ttt_soap"

if SERVER then
    local cvKickProps = CreateConVar("ttt_soap_kick_props", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })
    local cvVelocity = CreateConVar("ttt_soap_velocity", "300", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    local soundSlip = Sound("soap/slip.wav")

    function ENT:Initialize()
        self:SetModel("models/soap.mdl")
        self:SetModelScale(1.3)

        self.BaseClass.Initialize(self)

        -- enables ENT:Touch
        self:SetSolidFlags(FSOLID_TRIGGER)

        self:SetHealth(100)

        local mvObject = self:AddMarkerVision("soap_owner")
        mvObject:SetOwner(self:GetOriginator())
        mvObject:SetVisibleFor(VISIBLE_FOR_TEAM)
        mvObject:SyncToClients()
    end

    function ENT:OnRemove()
        self:RemoveMarkerVision("soap_owner")
    end

    function ENT:PlayerCanPickupWeapon(activator)
        return self:GetOriginator() == activator
    end

    function ENT:WasDestroyed(pos, dmgInfo)
        local originator = self:GetOriginator()

        LANG.Msg(originator, "weapon_soap_destroyed", nil, MSG_MSTACK_WARN)
    end

    function ENT:Touch(toucher)
        if not IsValid(toucher) then
            return
        end

        if toucher:IsPlayer() then
            self:EmitSound(soundSlip)

            local velocityNormalized = toucher:GetVelocity():GetNormalized()
            local newVelocity =
                Vector(velocityNormalized.x, velocityNormalized.y, velocityNormalized.z + 1)

            toucher:SetVelocity(newVelocity * cvVelocity:GetInt())
        elseif cvKickProps:GetBool() then
            self:EmitSound(soundSlip)

            local velocityToucher = toucher:GetVelocity()
            local newVelocity = Vector(velocityToucher.x, velocityToucher.y, velocityToucher.z + 1)
            local physObj = toucher:GetPhysicsObject()

            physObj:ApplyForceCenter(newVelocity * cvVelocity:GetInt())
        end
    end
end

if CLIENT then
    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local materialSoap = Material("vgui/ttt/marker_vision/soap")

    -- handle looking at C4
    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDSoap", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not client:IsTerror()
            or not IsValid(ent)
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "ttt_soap"
            or client:GetTeam() ~= ent:GetOriginator():GetTeam()
        then
            return
        end

        -- enable targetID rendering
        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(TryT(ent.PrintName))

        if ent:GetOriginator() == client then
            tData:SetKeyBinding("+use")
            tData:SetSubtitle(ParT("target_pickup", { usekey = Key("+use", "USE") }))
        else
            tData:AddIcon(materialSoap)
            tData:SetSubtitle(TryT("target_pickup_disabled"))
        end
    end)

    hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionSoap", function(mvData)
        local client = LocalPlayer()
        local ent = mvData:GetEntity()
        local mvObject = mvData:GetMarkerVisionObject()

        if not client:IsTerror() or not mvObject:IsObjectFor(ent, "soap_owner") then
            return
        end

        local originator = ent:GetOriginator()
        local nick = IsValid(originator) and originator:Nick() or "---"

        local distance = math.Round(util.HammerUnitsToMeters(mvData:GetEntityDistance()), 1)

        mvData:EnableText()

        mvData:AddIcon(materialSoap)
        mvData:SetTitle(TryT(ent.PrintName))

        mvData:AddDescriptionLine(ParT("marker_vision_owner", { owner = nick }))
        mvData:AddDescriptionLine(ParT("marker_vision_distance", { distance = distance }))

        mvData:AddDescriptionLine(TryT(mvObject:GetVisibleForTranslationKey()), COLOR_SLATEGRAY)
    end)
end
