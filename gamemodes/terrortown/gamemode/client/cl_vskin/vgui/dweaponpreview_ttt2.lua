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

	self:SetFont("DermaTTT2TextLarge")

	self:SetCamPos(Vector(75, -65, 55))
	self:SetLookAt(Vector(5, 0, 35))
	self:SetFOV(35)

	self:SetAnimSpeed(0.5)
	self:SetAnimated(true)

	self:SetAmbientLight(Color(100, 100, 100))

	self:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
	self:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))

	self:SetColor(COLOR_WHITE)

	-- remove label and overwrite function
	self:SetText("")

	self.data = {
		ply = nil,
		wep = nil,
		wepClass = "",
		HoldType = "normal",
		worldModelData = nil
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

	-- make sure it is reset in case different weapon was used before
	self.data.worldModelData = nil
	self.data.wepClass = cls

	-- if WElements are set, this weapon is created with the SWEP Construction Kit
	-- and special handling has to be used to render the weapon
	if wep.WElements then
		for name, data in pairs(wep.WElements) do
			if data.type ~= "Model" then continue end

			self.data.worldModelData = data

			break -- only use first valid entry
		end
	end

	local cEnt = ClientsideModel(self.data.worldModelData and self.data.worldModelData.model or wep.WorldModel, RENDERGROUP_OTHER)

	if not IsValid(cEnt) then return end

	cEnt:SetNoDraw(true)
	cEnt:SetIK(false)

	self.data.HoldType = wep.HoldType

	if wep.HoldType == "normal" then
		self.data.ply:SetSequence(self.data.ply:LookupSequence("idle_all_01"))
	else
		self.data.ply:SetSequence(self.data.ply:LookupSequence("idle_" .. wep.HoldType))

		-- only merge bones if no special handling is needed
		if not self.data.worldModelData then
			cEnt:SetParent(self.data.ply)
			cEnt:AddEffects(EF_BONEMERGE)
		end
	end

	self.data.ply:SetupBones()

	-- before storing the ent, make sure that a possible old ent
	-- is removed because clientside models are not garbage collected
	if IsValid(self.data.wep) then
		self.data.wep:Remove()
	end

	if wep.HoldType ~= "normal" then
		self.data.wep = cEnt
	end
end

---
-- @realm client
function PANEL:DrawModel()
	local ply = self.data.ply
	local wep = self.data.wep

	if not IsValid(ply) then return end

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

	-- This adds support for the "SWEP Construction Kit" that is used by many weapons such as the
	-- boomerang or the melon mine: https://steamcommunity.com/sharedfiles/filedetails/?id=109724869
	--
	-- This code is taken and slightly modified from its WorldModel renderer
	if self.data.worldModelData then
		local worldModelData = self.data.worldModelData
		local wepEnt = weapons.Get(self.data.wepClass)
		local pos, ang

		if worldModelData.bone then
			pos, ang = wepEnt:GetBoneOrientation(wepEnt.WElements, worldModelData, self.data.ply)
		else
			pos, ang = wepEnt:GetBoneOrientation(wepEnt.WElements, worldModelData, self.data.ply, "ValveBiped.Bip01_R_Hand")
		end

		wep:SetPos(pos + ang:Forward() * worldModelData.pos.x + ang:Right() * worldModelData.pos.y + ang:Up() * worldModelData.pos.z)

		ang:RotateAroundAxis(ang:Up(), worldModelData.angle.y)
		ang:RotateAroundAxis(ang:Right(), worldModelData.angle.p)
		ang:RotateAroundAxis(ang:Forward(), worldModelData.angle.r)

		wep:SetAngles(ang)

		local matrix = Matrix()
		matrix:Scale(worldModelData.size)
		wep:EnableMatrix("RenderMultiply", matrix)

		if worldModelData.material == "" then
			wep:SetMaterial("")
		elseif wep:GetMaterial() ~= worldModelData.material then
			wep:SetMaterial( worldModelData.material )
		end

		if worldModelData.skin and worldModelData.skin ~= wep:GetSkin() then
			wep:SetSkin(worldModelData.skin)
		end

		if worldModelData.bodygroup then
			for k, v in pairs(worldModelData.bodygroup) do
				if wep:GetBodygroup(k) ~= v then
					wep:SetBodygroup(k, v)
				end
			end
		end
	end -- end of SWEP Construction Kit support

	self:LayoutEntity(ply)

	if IsValid(wep) then
		self:LayoutEntity(wep)
	end

	local ang = self.aLookAngle or (self.vLookatPos - self.vCamPos):Angle()

	cam.Start3D(self.vCamPos, ang, self.fFOV, xBaseStart, yBaseStart, w, h, 5, self.farZ)
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(ply:GetPos())
		render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)

		for i = 0, 6 do
			local col = self.directionalLight[i]

			if col then
				render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
			end
		end

		-- make a mask to make sure the graphic is limited
		render.SetScissorRect(xLimitStart, yLimitStart, xLimitEnd, yLimitEnd, true)

		if self.Hovered then
			render.ResetModelLighting(1.0, 1.0, 1.0)
			render.SetBlend(0.2)
		else
			render.ResetModelLighting(self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255)
			render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))
		end

		ply:DrawModel()

		if IsValid(wep) then
			render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))

			wep:DrawModel()
		end

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
