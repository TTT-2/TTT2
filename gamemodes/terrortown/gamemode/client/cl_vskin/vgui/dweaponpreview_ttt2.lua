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
	self:SetFOV(85)

	self:SetAnimSpeed(0.5)
	self:SetAnimated(true)

	self:SetAmbientLight(Color(50, 50, 50))

	self:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
	self:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))

	self:SetColor(COLOR_WHITE)

	-- remove label and overwrite function
	self:SetText("")

	self.data = {
		ply = nil,
		wep = nil,
		HoldType = "normal"
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
-- @param number iDirections
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
	local cEnt = ClientsideModel(model, RENDERGROUP_OTHER)

	if not IsValid(cEnt) then return end

	cEnt:SetNoDraw(true)
	cEnt:SetIK(false)

	-- before storing the ent, make sure that a possible old ent
	-- is removed because clientside models are not garbage collected
	if IsValid(self.data.ply) then
		self.data.ply:Remove()
	end

	self.data.ply = cEnt
end

function PANEL:SetWeaponClass(cls)
	if not IsValid(self.data.ply) then return end

	local wep = weapons.Get(cls)

	if not wep then return end

	local cEnt = ClientsideModel(wep.WorldModel, RENDERGROUP_OTHER)

	if not IsValid(cEnt) then return end

	cEnt:SetNoDraw(true)
	cEnt:SetIK(false)

	self.data.HoldType = wep.HoldType

	if wep.HoldType == "normal" then
		self.data.ply:SetSequence(self.data.ply:LookupSequence("idle_all_01"))
	else
		self.data.ply:SetSequence(self.data.ply:LookupSequence("idle_" .. wep.HoldType))

		cEnt:SetParent(self.data.ply)
		cEnt:AddEffects(EF_BONEMERGE)
	end

	self.data.ply:SetupBones()

	-- before storing the ent, make sure that a possible old ent
	-- is removed because clientside models are not garbage collected
	if IsValid(self.data.wep) then
		self.data.wep:Remove()
	end

	self.data.wep = cEnt
end

---
-- @realm client
function PANEL:DrawModel()
	local ply = self.data.ply
	local wep = self.data.wep

	if not IsValid(ply) or not IsValid(wep) then return end

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

	self:LayoutEntity(ply)
	self:LayoutEntity(wep)

	local ang = self.aLookAngle or (self.vLookatPos - self.vCamPos):Angle()

	cam.Start3D(self.vCamPos, ang, self.fFOV, xBaseStart, yBaseStart, w, h, 5, self.farZ)
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(ply:GetPos())
		render.ResetModelLighting(self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255)
		render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)
		render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))

		for i = 0, 6 do
			local col = self.directionalLight[i]

			if col then
				render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
			end
		end

		-- make a mask to make sure the graphic is limited
		render.SetScissorRect(xLimitStart, yLimitStart, xLimitEnd, yLimitEnd, true)

		ply:DrawModel()
		wep:DrawModel()

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
-- @return string
-- @realm client
function PANEL:GetModel()
	return self.data.mdl
end

---
-- @return boolean
-- @realm client
function PANEL:HasModel()
	return self.data.mdl ~= nil
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

derma.DefineControl("DWeaponPreviewTTT2", "A box that renders a player with an equipped weapon", PANEL, "DLabelTTT2")
