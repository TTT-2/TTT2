---
-- @class PANEL
-- @section DWeaponPreviewTTT2

local mathMax = math.max
local mathMin = math.min

local PANEL = {}

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_fAnimSpeed", "AnimSpeed")

---
-- @accessor Entity
-- @realm client
AccessorFunc(PANEL, "Entity", "Entity")

---
-- @accessor Vector
-- @realm client
AccessorFunc(PANEL, "vCamPos", "CamPos")

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "fFOV", "FOV")

---
-- @accessor Vector
-- @realm client
AccessorFunc(PANEL, "vLookatPos", "LookAt")

---
-- @accessor Angle
-- @realm client
AccessorFunc(PANEL, "aLookAngle", "LookAng")

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "colAmbientLight", "AmbientLight")

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "colColor", "Color")

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "bAnimated", "Animated")

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "bHoverEffect", "HoverEffect")

---
-- @ignore
function PANEL:Init()
    self.lastPaint = 0
    self.directionalLight = {}
    self.farZ = 4096

    self:SetContentAlignment(5)

    self:SetTall(22)

    self:SetFont("DermaTTT2TextLarge")

    self:SetCamPos(Vector(75, -65, 55))
    self:SetLookAt(Vector(5, 0, 35))
    self:SetFOV(35)

    self:SetAnimSpeed(0.5)
    self:SetAnimated(true)

    -- the mouse input has to be enabled to detect mouse hovering
    self:SetMouseInputEnabled(true)
    self:SetHoverEffect(true)

    self:SetAmbientLight(Color(175, 175, 175))

    self:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
    self:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))

    self:SetColor(COLOR_WHITE)

    -- remove label and overwrite function
    self:SetText("")

    self.data = {
        ply = nil,
        wep = nil,
        HoldType = "normal",
    }
end

---
-- @realm client
function PANEL:OnRemove()
    -- old ent is removed because clientside models are not garbage collected
    if IsValid(self.data.ply) then
        self.data.ply:Remove()
    end
    if IsValid(self.data.wep) then
        self.data.wep:Remove()
    end
end

---
-- @param number iDirections The direction enum: https://wiki.facepunch.com/gmod/Enums/BOX
-- @param Color color
-- @realm client
function PANEL:SetDirectionalLight(iDirection, color)
    self.directionalLight[iDirection] = color
end

---
-- @param string model
-- @realm client
function PANEL:SetPlayerModel(model)
    -- set the entity
    local clientsideEntity = ClientsideModel(model, RENDERGROUP_OTHER)

    if not IsValid(clientsideEntity) then
        return
    end

    clientsideEntity:SetNoDraw(true)
    clientsideEntity:SetIK(false)

    -- before storing the ent, make sure that a possible old ent
    -- is removed because clientside models are not garbage collected
    if IsValid(self.data.ply) then
        self.data.ply:Remove()
    end

    self.data.ply = clientsideEntity
end

---
-- @param string cls
-- @realm client
function PANEL:SetWeaponClass(cls)
    if not IsValid(self.data.ply) then
        return
    end

    -- weapons.Get returns a copy of the weapon table, it is therefore fine to
    -- create modifications on that table
    local wep = weapons.Get(cls)

    if not wep then
        return
    end

    wep:InitializeCustomModels()

    -- if the weapon is created with the SWEP Construction Kit, we have to import the
    -- data into our system. To be on the safe side we also disable to default world
    -- model for these weapons
    if wep.WElements then
        wep.ShowDefaultWorldModel = false

        for identifier, modelData in pairs(wep.WElements) do
            wep:AddCustomWorldModel(identifier, modelData)
        end
    end

    -- before storing the ent, make sure that a possible old ent
    -- is removed because clientside models are not garbage collected
    if IsValid(self.data.wep) then
        self.data.wep:Remove()
    end

    local clientsideEntity = ClientsideModel(wep.WorldModel, RENDERGROUP_OTHER)

    if not IsValid(clientsideEntity) then
        return
    end

    clientsideEntity:SetNoDraw(true)
    clientsideEntity:SetIK(false)

    clientsideEntity:SetParent(self.data.ply)

    -- Applies a bonemerge engine effect. This merges the bones of this entity with the
    -- entity of its parent so that they always move together.
    clientsideEntity:AddEffects(EF_BONEMERGE)

    self.data.wepModel = clientsideEntity
    self.data.wep = wep

    self.data.HoldType = wep.HoldType

    if wep.HoldType == "normal" then
        self.data.ply:SetSequence(self.data.ply:LookupSequence("idle_all_01"))
    else
        self.data.ply:SetSequence(self.data.ply:LookupSequence("idle_" .. wep.HoldType))
    end

    self.data.ply:SetupBones()
end

---
-- @realm client
function PANEL:DrawModel()
    local ply = self.data.ply
    local wep = self.data.wep
    local wepModel = self.data.wepModel

    if not IsValid(ply) then
        return
    end

    local w, h = self:GetSize()
    local xBaseStart, yBaseStart = self:LocalToScreen(0, 0)

    local xLimitStart, yLimitStart = xBaseStart, yBaseStart
    local xLimitEnd, yLimitEnd = self:LocalToScreen(self:GetWide(), self:GetTall())

    local currentParent = self

    -- iterate till the top is found to make sure the image is not out of bounds
    while currentParent:GetParent() do
        currentParent = currentParent:GetParent()

        local x1, y1 = currentParent:LocalToScreen(0, 0)
        local x2, y2 = currentParent:LocalToScreen(currentParent:GetWide(), currentParent:GetTall())

        xLimitStart = mathMax(xLimitStart, x1)
        yLimitStart = mathMax(yLimitStart, y1)
        xLimitEnd = mathMin(xLimitEnd, x2)
        yLimitEnd = mathMin(yLimitEnd, y2)
    end

    -- only the player has to be layouted (animated) because the weapon is tied to them
    self:LayoutEntity(ply)

    local ang = self.aLookAngle or (self.vLookatPos - self.vCamPos):Angle()

    cam.Start3D(self.vCamPos, ang, self.fFOV, xBaseStart, yBaseStart, w, h, 5, self.farZ)
    render.SuppressEngineLighting(true)
    render.SetLightingOrigin(ply:GetPos())
    render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)

    -- iterates over the model lighting enum: https://wiki.facepunch.com/gmod/Enums/BOX
    for i = 0, 6 do
        local col = self.directionalLight[i]

        if col then
            render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
        end
    end

    -- make a mask to make sure the graphic is limited
    render.SetScissorRect(xLimitStart, yLimitStart, xLimitEnd, yLimitEnd, true)

    if self.Hovered and self.bHoverEffect then
        render.ResetModelLighting(1.0, 1.0, 1.0)
        render.SetBlend(0.2)
    else
        render.ResetModelLighting(
            self.colAmbientLight.r / 255,
            self.colAmbientLight.g / 255,
            self.colAmbientLight.b / 255
        )
        render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))
    end

    ply:DrawModel()

    render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))

    weaponrenderer.RenderWorldModel(
        wep,
        wepModel,
        wep.customWorldModelElements or wep.WElements,
        ply
    )

    render.SetScissorRect(0, 0, 0, 0, false)
    render.SuppressEngineLighting(false)
    cam.End3D()

    self.lastPaint = RealTime()
end

---
-- This function is to be overriden
-- @param Entity ent
-- @realm client
function PANEL:LayoutEntity(ent)
    if self.bAnimated then
        self:RunAnimation()
    end
end

---
-- @realm client
function PANEL:RunAnimation()
    self.data.ply:FrameAdvance((RealTime() - self.lastPaint) * self.m_fAnimSpeed)
end

---
-- @return boolean
-- @realm client
function PANEL:HasModel()
    return IsValid(self.data.ply)
end

---
-- @ignore
function PANEL:IsDown()
    return self.Depressed
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "WeaponPreviewTTT2", self, w, h)

    return false
end

derma.DefineControl(
    "DWeaponPreviewTTT2",
    "A box that renders a player with an equipped weapon",
    PANEL,
    "DLabelTTT2"
)
