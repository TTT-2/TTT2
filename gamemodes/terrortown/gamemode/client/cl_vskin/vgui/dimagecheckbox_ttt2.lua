---
-- @class PANEL
-- @section DCardTTT2

local mathMax = math.max
local mathMin = math.min

local PANEL = {}

AccessorFunc(PANEL, "m_fAnimSpeed", "AnimSpeed")
AccessorFunc(PANEL, "Entity", "Entity")
AccessorFunc(PANEL, "vCamPos", "CamPos")
AccessorFunc(PANEL, "fFOV", "FOV")
AccessorFunc(PANEL, "vLookatPos", "LookAt")
AccessorFunc(PANEL, "aLookAngle", "LookAng")
AccessorFunc(PANEL, "colAmbientLight", "AmbientLight")
AccessorFunc(PANEL, "colColor", "Color")
AccessorFunc(PANEL, "bAnimated", "Animated")
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
		title = "",
		img = nil,
		mdl = nil,
		ent = nil,
		isSelected = false
	}
end

function PANEL:SetDirectionalLight(iDirection, color)
	self.directionalLight[iDirection] = color
end

---
-- @return string
-- @realm client
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
-- @param string model
-- @realm client
function PANEL:SetModel(model)
	self.data.mdl = model

	-- set the entity
	local ent = ClientsideModel(model, RENDERGROUP_OTHER)

	if not IsValid(ent) then return end

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

	self.data.ent = ent
end

function PANEL:DrawModel()
	local ent = self.data.ent

	if not IsValid(ent) then return end

	local w, h = self:GetSize()
	local xBaseStart, yBaseStart = self:LocalToScreen(0, 0)

	local xLimitStart, yLimitStart = xBaseStart, yBaseStart
	local xLimitEnd, yLimitEnd = self:LocalToScreen(self:GetWide(), self:GetTall())

	local curparent = self

	-- iterate till the top is found to make sure the image is not out of bounds
	while curparent:GetParent() do
		curparent = curparent:GetParent()

		local x1, y1 = curparent:LocalToScreen(0, 0)
		local x2, y2 = curparent:LocalToScreen(curparent:GetWide(), curparent:GetTall())

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
		render.ResetModelLighting(self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255)
		render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)
		render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))

		for i = 0, 6 do
			local col = self.directionalLight[i]

			if col then
				render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
			end
		end

		-- make a mask to make sure the graphic is limted
		render.SetScissorRect(xLimitStart, yLimitStart, xLimitEnd, yLimitEnd, true)

		ent:DrawModel()

		render.SetScissorRect(0, 0, 0, 0, false)
		render.SuppressEngineLighting(false)
	cam.End3D()

	self.lastPaint = RealTime()
end

function PANEL:LayoutEntity(ent)
	--
	-- This function is to be overriden
	--
	if self.bAnimated then
		self:RunAnimation()
	end

	if self.bRotatin then
		ent:SetAngles(Angle(0, RealTime() * 10 % 360, 0))
	end
end

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
-- @realm client
function PANEL:SetSelected(selected)
	self.data.selected = selected
end

---
-- @return boolean
-- @realm client
function PANEL:IsSelected()
	return self.data.selected or false
end

---
-- @param number keyCode
-- @realm client
function PANEL:OnMouseReleased(keyCode)
	if keyCode == MOUSE_LEFT then
		local state = not self:IsSelected()

		self:SetSelected(state)
		self:OnSelected(state)
	end

	self.BaseClass.OnMouseReleased(self, keyCode)
end

---
-- @realm client
function PANEL:OnSelected(state)

end

---
-- @return boolean
-- @realm client
function PANEL:IsDown()
	return self.Depressed
end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "ImageCheckBoxTTT2", self, w, h)

	return false
end

derma.DefineControl("DImageCheckBoxTTT2", "A special button with image or model that acts as a checkbox", PANEL, "DLabelTTT2")
