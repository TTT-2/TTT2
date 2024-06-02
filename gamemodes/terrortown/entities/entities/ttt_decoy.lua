---
-- @class ENT
-- @desc Decoy sending out a radar blip and redirecting DNA scans. Based on old beacon
-- code.
-- @section ttt_decoy

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("ttt_base_placeable")

ENT.Base = "ttt_base_placeable"

ENT.Model = "models/props_lab/reciever01b.mdl"

ENT.CanHavePrints = false

ENT.pickupWeaponClass = "weapon_ttt_decoy"

---
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)

    BaseClass.Initialize(self)

    if SERVER then
        self:SetMaxHealth(100)
    end

    self:SetHealth(100)

    -- can pick this up if we own it
    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end
end

-- @realm shared
function ENT:OnRemove()
    if not IsValid(self:GetOriginator()) then
        return
    end

    self:GetOriginator().decoy = nil
end

---
-- @param Player activator
-- @realm shared
function ENT:PlayerCanPickupWeapon(activator)
    return activator:HasTeam()
        and self:GetNWString("decoy_owner_team", "none") == activator:GetTeam()
end

if SERVER then
    ---
    -- @realm server
    function ENT:WasDestroyed()
        local originator = self:GetOriginator()

        if not IsValid(originator) then
            return
        end

        LANG.Msg(originator, "decoy_broken", nil, MSG_MSTACK_WARN)
    end
end

if CLIENT then
    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    -- handle looking at decoy
    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDDecoy", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not IsValid(client)
            or not client:IsTerror()
            or not client:Alive()
            or not IsValid(ent)
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "ttt_decoy"
        then
            return
        end

        -- enable targetID rendering
        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(TryT("decoy_name"))
        tData:AddDescriptionLine(TryT("decoy_short_desc"))

        if ent:PlayerCanPickupWeapon(client) then
            tData:SetSubtitle(ParT("target_pickup", { usekey = Key("+use", "USE") }))
            tData:SetKeyBinding("+use")
        else
            tData:SetSubtitle(TryT("entity_pickup_owner_only"))
        end

        if ent:GetNWString("decoy_owner_team", "none") == client:GetTeam() then
            return
        end

        tData:AddDescriptionLine(TryT("decoy_pickup_wrong_team"), COLOR_ORANGE)
    end)
end
