---
-- @class PANEL
-- @section ImageCheckBoxTTT2

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

	self:SetFont("DermaTTT2TextLarge")

	self:SetCamPos(Vector(42, -1, 70))
	self:SetLookAt(Vector(0, -1, 58))
	self:SetFOV(35)

	self:SetAnimSpeed(0.5)
	self:SetAnimated(true)
	self:SetRotating(false)

	self:SetAmbientLight(Color(50, 50, 50))

	self:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
	self:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))

	self:SetColor(COLOR_WHITE)

	self:SetText("")

	self.data = {}
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
function PANEL:SetModel(model, color)
	self.data.mdl = Model(model)

	-- set the entity
	local ent = ClientsideModel(model, RENDERGROUP_OTHER)
	--ent:SetColor(Color(color.r * 255, color.g * 255, color.b * 255))

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
function PANEL:DrawModel(x, y, w, h)
	local ent = self.data.ent

	if not IsValid(ent) then return end

	local xBaseStart, yBaseStart = self:LocalToScreen(x, y)

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

		-- make a mask to make sure the graphic is limited
		render.SetScissorRect(xBaseStart, yBaseStart, xBaseStart + w, yBaseStart + h, true)

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

function PANEL:SetPlayerIcon(material)
	self.data.player_icon = material
end

function PANEL:SetPlayerRoleIcon(material)
	self.data.player_role_icon = material
end

function PANEL:SetPlayerRoleColor(color)
	self.data.player_role_color = color
end

function PANEL:SetPlayerRoleString(role)
	self.data.player_role_name = role
end

function PANEL:SetPlayerTeamString(team)
	self.data.player_team_name = team
end

---
-- @return Material
-- @realm client
function PANEL:GetPlayerIcon()
	return self.data.player_icon
end

---
-- @return number
-- @realm client
function PANEL:GetPlayerRoleIcon()
	return self.data.player_role_icon
end

function PANEL:GetPlayerRoleColor()
	return self.data.player_role_color
end

function PANEL:GetPlayerRoleString()
	return self.data.player_role_name
end

function PANEL:GetPlayerTeamString()
	return self.data.player_team_name
end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "ProfilePanelTTT2", self, w, h)

	return false
end

derma.DefineControl("DProfilePanelTTT2", "A special button with image or model that acts as a checkbox", PANEL, "DLabelTTT2")
