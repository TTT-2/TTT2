---
-- @class PANEL
-- @section DImageCheckBoxTTT2

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
AccessorFunc(PANEL, "bRotating", "Rotating")

---
-- @ignore
function PANEL:Init()
    self.lastPaint = 0
    self.directionalLight = {}
    self.farZ = 4096

    self:SetContentAlignment(5)

    self:SetTall(22)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    self:SetCursor("hand")
    self:SetFont("DermaTTT2TextLarge")

    self:SetCamPos(Vector(55, 55, 55))
    self:SetLookAt(Vector(0, 0, 55))
    self:SetFOV(35)

    self:SetAnimSpeed(0.5)
    self:SetAnimated(true)
    self:SetRotating(false)

    self:SetAmbientLight(Color(50, 50, 50))

    self:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
    self:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))

    self:SetColor(COLOR_WHITE)

    -- remove label and overwrite function
    self:SetText("")
    self.SetText = function(slf, text)
        slf.data.text = text
    end

    self.data = {
        text = "",
        img = nil,
        mdl = nil,
        ent = nil,
        headbox = false,
        hattable = false,
        selected = false,
    }
end

---
-- @realm client
function PANEL:OnRemove()
    -- old ent is removed because clientside models are not garbage collected
    if IsValid(self.data.ent) then
        self.data.ent:Remove()
    end
end

---
-- @param number iDirections
-- @param Color color
-- @realm client
function PANEL:SetDirectionalLight(iDirection, color)
    self.directionalLight[iDirection] = color
end

---
-- @ignore
function PANEL:GetText()
    return self.data.text
end

---
-- @param Material image
-- @realm client
function PANEL:SetImage(image)
    self.data.img = image
end

---
-- @param boolean state
-- @realm client
function PANEL:SetHeadBox(state)
    self.data.headbox = state
end

---
-- @return boolean
-- @realm client
function PANEL:HasHeadBox()
    return self.data.headbox or false
end

---
-- @param boolean state
-- @param boolean userTriggered
-- @realm client
function PANEL:SetModelHattable(state, userTriggered)
    self.data.hattable = state

    self:OnModelHattable(userTriggered or false, state)
end

---
-- @return boolean
-- @realm client
function PANEL:IsModelHattable()
    return self.data.hattable or false
end

---
-- @param string model
-- @realm client
function PANEL:SetModel(model)
    self.data.mdl = model

    -- set the entity
    local ent = ClientsideModel(model, RENDERGROUP_OTHER)

    if not IsValid(ent) then
        return
    end

    ent:SetNoDraw(true)
    ent:SetIK(false)

    -- now try to find a nice sequence to play
    local iSeq = ent:LookupSequence("walk_all")

    if iSeq <= 0 then
        iSeq = ent:LookupSequence("WalkUnarmed_all")
    end

    if iSeq <= 0 then
        iSeq = ent:LookupSequence("walk_all_moderate")
    end

    if iSeq > 0 then
        ent:ResetSequence(iSeq)
    end

    -- before storing the ent, make sure that a possible old ent
    -- is removed because clientside models are not garbage collected
    if IsValid(self.data.ent) then
        self.data.ent:Remove()
        self.data.ent = nil
    end

    self.data.ent = ent
end

---
-- @realm client
function PANEL:DrawModel()
    local ent = self.data.ent

    if not IsValid(ent) then
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

    self:LayoutEntity(ent)

    local ang = self.aLookAngle or (self.vLookatPos - self.vCamPos):Angle()

    cam.Start3D(self.vCamPos, ang, self.fFOV, xBaseStart, yBaseStart, w, h, 5, self.farZ)
    render.SuppressEngineLighting(true)
    render.SetLightingOrigin(ent:GetPos())
    render.ResetModelLighting(
        self.colAmbientLight.r / 255,
        self.colAmbientLight.g / 255,
        self.colAmbientLight.b / 255
    )
    render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)
    render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))

    -- iterates over the model lighting enum: https://wiki.facepunch.com/gmod/Enums/BOX
    for i = 0, 6 do
        local col = self.directionalLight[i]

        if col then
            render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
        end
    end

    -- make a mask to make sure the graphic is limited
    render.SetScissorRect(xLimitStart, yLimitStart, xLimitEnd, yLimitEnd, true)

    ent:DrawModel()

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

    if self.bRotatin then
        ent:SetAngles(Angle(0, RealTime() * 10 % 360, 0))
    end
end

---
-- @realm client
function PANEL:RunAnimation()
    self.data.ent:FrameAdvance((RealTime() - self.lastPaint) * self.m_fAnimSpeed)
end

---
-- @return Material
-- @realm client
function PANEL:GetImage()
    return self.data.img
end

---
-- @return string
-- @realm client
function PANEL:GetModel()
    return self.data.mdl
end

---
-- @return boolean
-- @realm client
function PANEL:HasImage()
    return self.data.img ~= nil
end

---
-- @return boolean
-- @realm client
function PANEL:HasModel()
    return self.data.mdl ~= nil
end

---
-- @param boolean selected
-- @param boolean userTriggered
-- @realm client
function PANEL:SetModelSelected(selected, userTriggered)
    self.data.selected = selected

    self:OnModelSelected(userTriggered or false, self.data.selected)
end

---
-- @return boolean
-- @realm client
function PANEL:IsModelSelected()
    return self.data.selected or false
end

---
-- @ignore
function PANEL:OnMouseReleased(keyCode)
    if keyCode == MOUSE_LEFT then
        local state = not self:IsModelSelected()

        self:SetModelSelected(state, true)
    elseif keyCode == MOUSE_RIGHT then
        local state = not self:IsModelHattable()

        self:SetModelHattable(state, true)
    end

    self.BaseClass.OnMouseReleased(self, keyCode)
end

---
-- Is called when the model selection state is updated. Should be overwritten.
-- @param boolean userTriggered
-- @param boolean state
-- @realm client
function PANEL:OnModelSelected(userTriggered, state) end

---
-- Is called when the hattable state is updated. Should be overwritten.
-- @param boolean userTriggered
-- @param boolean state
-- @realm client
function PANEL:OnModelHattable(userTriggered, state) end

---
-- @ignore
function PANEL:IsDown()
    return self.Depressed
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "ImageCheckBoxTTT2", self, w, h)

    return false
end

derma.DefineControl(
    "DImageCheckBoxTTT2",
    "A special button with image or model that acts as a checkbox",
    PANEL,
    "DButtonTTT2"
)
