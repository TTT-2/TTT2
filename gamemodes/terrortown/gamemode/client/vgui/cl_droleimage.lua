local PANEL = {}

local math = math
local surface = surface
local vgui = vgui

AccessorFunc(PANEL, "m_Material", "Material")
AccessorFunc(PANEL, "m_Material2", "Material2")
AccessorFunc(PANEL, "m_MaterialOverlay", "MaterialOverlay")
AccessorFunc(PANEL, "m_RoleIcon", "RoleIcon")
AccessorFunc(PANEL, "m_Color", "ImageColor")
AccessorFunc(PANEL, "m_bKeepAspect", "KeepAspect")
AccessorFunc(PANEL, "m_strMatName", "MatName")
AccessorFunc(PANEL, "m_strMatName2", "MatName2")
AccessorFunc(PANEL, "m_strMatOverName", "MatOverName")
AccessorFunc(PANEL, "m_strRoleIconName", "RoleIconName")

function PANEL:Init()
	self:SetImageColor(Color(255, 255, 255, 255))
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	self:SetKeepAspect(false)

	self.ImageName = ""
	self.ImageName2 = ""
	self.ImageOverlayName = ""
	self.RoleIconImageName = ""

	self.ActualWidth = 10
	self.ActualHeight = 10
end

function PANEL:SetOnViewMaterial(MatName, MatName2, RoleIconName, MatOverName)
	self:SetMatName(MatName)
	self:SetMatName2(MatName2)
	self:SetMatOverName(MatOverName)
	self:SetRoleIconName(RoleIconName)

	self.ImageName = MatName
	self.ImageName2 = MatName2
	self.ImageOverlayName = MatOverName
	self.RoleIconImageName = RoleIconName
end

function PANEL:Unloaded()
	return self.m_strMatName ~= nil
end

function PANEL:LoadMaterial()
	if not self:Unloaded() then return end

	self:DoLoadMaterial()

	self:SetMatName(nil)
	self:SetMatName2(nil)
	self:SetRoleIconName(nil)
	self:SetMatOverName(nil)
end

function PANEL:DoLoadMaterial()
	local mat = Material(self:GetMatName())
	local mat2 = Material(self:GetMatName2())
	local matover = Material(self:GetMatOverName())
	local roleIcon = Material(self:GetRoleIconName())

	self:SetMaterial(mat)
	self:FixVertexLitMaterial()

	if mat2 then
		self:SetMaterial2(mat2)
		self:FixVertexLitMaterial2()
	end

	if matover then
		self:MaterialOverlay(matover)
		self:FixVertexLitMaterialOverlay()
	end

	if roleIcon then
		self:SetRoleIcon(roleIcon)
		self:FixVertexLitRoleIcon()
	end

	--
	-- This isn't ideal, but it will probably help you out of a jam
	-- in cases where you position the image according to the texture
	-- size and you want to load on view - instead of on load.
	--
	self:InvalidateParent()
end

function PANEL:SetMaterial(Mat)
	-- Everybody makes mistakes,
	-- that's why they put erasers on pencils.
	if type(Mat) == "string" then
		self:SetImage(Mat)

		return
	end

	self.m_Material = Mat

	if not self.m_Material then return end

	local Texture = self.m_Material:GetTexture("$basetexture")
	if Texture then
		self.ActualWidth = Texture:Width()
		self.ActualHeight = Texture:Height()
	else
		self.ActualWidth = self.m_Material:Width()
		self.ActualHeight = self.m_Material:Height()
	end
end

function PANEL:SetMaterial2(Mat)
	-- Everybody makes mistakes,
	-- that's why they put erasers on pencils.
	if type(Mat) == "string" then
		self:SetImage2(Mat)

		return
	end

	self.m_Material2 = Mat
end

function PANEL:SetMaterialOverlay(Mat)
	-- Everybody makes mistakes,
	-- that's why they put erasers on pencils.
	if type(Mat) == "string" then
		self:SetImageOverlay(Mat)

		return
	end

	self.m_MaterialOverlay = Mat
end

function PANEL:SetRoleIcon(Mat)
	-- Everybody makes mistakes,
	-- that's why they put erasers on pencils.
	if type(Mat) == "string" then
		self:SetRoleIconImage(Mat)

		return
	end

	self.m_RoleIcon = Mat
end

function PANEL:SetImage(strImage)
	self.ImageName = strImage

	local Mat = Material(strImage)

	self:SetMaterial(Mat)
	self:FixVertexLitMaterial()
end

function PANEL:SetImage2(strImage2)
	self.ImageName2 = strImage2

	local Mat = Material(strImage2)

	self:SetMaterial2(Mat)
	self:FixVertexLitMaterial2()
end

function PANEL:SetImageOverlay(strImageOverlay)
	self.ImageOverlayName = strImageOverlay

	local Mat = Material(strImageOverlay)

	self:SetMaterialOverlay(Mat)
	self:FixVertexLitMaterialOverlay()
end

function PANEL:SetRoleIconImage(strImage)
	self.RoleIconImageName = strImage

	local Mat = Material(strImage)

	self:SetRoleIcon(Mat)
	self:FixVertexLitRoleIcon()
end

function PANEL:UnloadImage2()
	self.ImageName2 = nil
	self.m_Material2 = nil
end

function PANEL:UnloadImageOverlay()
	self.ImageOverlayName = nil
	self.m_MaterialOverlay = nil
end

function PANEL:UnloadRoleIconImage()
	self.RoleIconImageName = nil
	self.m_RoleIcon = nil
end

function PANEL:GetImage()
	return self.ImageName
end

function PANEL:GetImage2()
	return self.ImageName2
end

function PANEL:GetImageOverlay()
	return self.ImageOverlayName
end

function PANEL:GetRoleIconImage()
	return self.RoleIconImageName
end

function PANEL:FixVertexLitMaterial()
	--
	-- If it's a vertexlitgeneric material we need to change it to be
	-- UnlitGeneric so it doesn't go dark when we enter a dark room
	-- and flicker all about
	--

	local Mat = self:GetMaterial()
	local strImage = Mat:GetName()

	if string.find(Mat:GetShader(), "VertexLitGeneric") or string.find(Mat:GetShader(), "Cable") then
		local t = Mat:GetString("$basetexture")
		if t then
			local params = {}
			params["$basetexture"] = t
			params["$vertexcolor"] = 1
			params["$vertexalpha"] = 1

			Mat = CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
		end
	end

	self:SetMaterial(Mat)
end

function PANEL:FixVertexLitMaterial2()
	--
	-- If it's a vertexlitgeneric material we need to change it to be
	-- UnlitGeneric so it doesn't go dark when we enter a dark room
	-- and flicker all about
	--

	local Mat = self:GetMaterial2()
	local strImage = Mat:GetName()

	if string.find(Mat:GetShader(), "VertexLitGeneric") or string.find(Mat:GetShader(), "Cable") then
		local t = Mat:GetString("$basetexture")
		if t then
			local params = {}
			params["$basetexture"] = t
			params["$vertexcolor"] = 1
			params["$vertexalpha"] = 1

			Mat = CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
		end
	end

	self:SetMaterial2(Mat)
end

function PANEL:FixVertexLitMaterialOverlay()
	--
	-- If it's a vertexlitgeneric material we need to change it to be
	-- UnlitGeneric so it doesn't go dark when we enter a dark room
	-- and flicker all about
	--

	local Mat = self:GetMaterialOverlay()
	local strImage = Mat:GetName()

	if string.find(Mat:GetShader(), "VertexLitGeneric") or string.find(Mat:GetShader(), "Cable") then
		local t = Mat:GetString("$basetexture")
		if t then
			local params = {}
			params["$basetexture"] = t
			params["$vertexcolor"] = 1
			params["$vertexalpha"] = 1

			Mat = CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
		end
	end

	self:SetMaterialOverlay(Mat)
end

function PANEL:FixVertexLitRoleIcon()
	--
	-- If it's a vertexlitgeneric material we need to change it to be
	-- UnlitGeneric so it doesn't go dark when we enter a dark room
	-- and flicker all about
	--

	local Mat = self:GetRoleIcon()
	local strImage = Mat:GetName()

	if string.find(Mat:GetShader(), "VertexLitGeneric") or string.find(Mat:GetShader(), "Cable") then
		local t = Mat:GetString("$basetexture")
		if t then
			local params = {}
			params["$basetexture"] = t
			params["$vertexcolor"] = 1
			params["$vertexalpha"] = 1

			Mat = CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
		end
	end

	self:SetRoleIcon(Mat)
end

function PANEL:SizeToContents()
	self:SetSize(self.ActualWidth, self.ActualHeight)
end

function PANEL:Paint()
	self:PaintAt(0, 0, self:GetWide(), self:GetTall())
end

function PANEL:PaintAt(x, y, dw, dh)
	dw, dh = dw or self:GetWide(), dh or self:GetTall()

	self:LoadMaterial()

	if not self.m_Material then
		return true
	end

	surface.SetMaterial(self.m_Material)
	surface.SetDrawColor(255, 255, 255, 255)

	if self:GetKeepAspect() then
		local w = self.ActualWidth
		local h = self.ActualHeight

		-- Image is bigger than panel, shrink to suitable size
		if w > dw and h > dh then
			if w > dw then
				local diff = dw / w

				w = w * diff
				h = h * diff
			end

			if h > dh then
				local diff = dh / h

				w = w * diff
				h = h * diff
			end
		end

		if w < dw then
			local diff = dw / w

			w = w * diff
			h = h * diff
		end

		if h < dh then
			local diff = dh / h

			w = w * diff
			h = h * diff
		end

		local OffX = (dw - w) * 0.5
		local OffY = (dh - h) * 0.5

		local tx = OffX + x
		local ty = OffY + y

		surface.DrawTexturedRect(tx, ty, w, h)

		if self.m_Material2 then
			surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
			surface.SetMaterial(self.m_Material2)
			surface.DrawTexturedRect(tx, ty, w, h)
		end

		if self.m_MaterialOverlay then
			surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
			surface.SetMaterial(self.m_MaterialOverlay)
			surface.DrawTexturedRect(tx, ty, w, h)
		end

		if self.m_RoleIcon then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self.m_RoleIcon)
			surface.DrawTexturedRect(tx + 8, ty + 8, w - 16, h - 16)
		end

		return true
	end

	surface.DrawTexturedRect(x, y, dw, dh)

	if self.m_Material2 then
		surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
		surface.SetMaterial(self.m_Material2)
		surface.DrawTexturedRect(x, y, dw, dh)
	end

	if self.m_MaterialOverlay then
		surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
		surface.SetMaterial(self.m_MaterialOverlay)
		surface.DrawTexturedRect(x, y, dw, dh)
	end

	if self.m_RoleIcon then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.m_RoleIcon)
		surface.DrawTexturedRect(x + 8, y + 8, dw - 16, dh - 16)
	end

	return true
end

function PANEL:GenerateExample(ClassName, PropertySheet, Width, Height)
	local ctrl = vgui.Create(ClassName)
	ctrl:SetImage("brick/brick_model")
	ctrl:SetSize(200, 200)

	PropertySheet:AddSheet(ClassName, ctrl, nil, true, true)
end

derma.DefineControl("DRoleImage", "A simple role image", PANEL, "DPanel")

----------
local matHover = Material("vgui/spawnmenu/hover")

PANEL = {}

AccessorFunc(PANEL, "m_iIconSize", "IconSize")

function PANEL:Init()
	self.Icon = vgui.Create("DRoleImage", self)
	self.Icon:SetMouseInputEnabled(false)
	self.Icon:SetKeyboardInputEnabled(false)

	self.animPress = Derma_Anim("Press", self, self.PressedAnim)

	self:SetIconSize(64)
end

function PANEL:OnMousePressed(mcode)
	if mcode == MOUSE_LEFT then
		self:DoClick()

		self.animPress:Start(0.1)
	end
end

function PANEL:OnMouseReleased()

end

function PANEL:DoClick()

end

function PANEL:OpenMenu()

end

function PANEL:ApplySchemeSettings()

end

local oldPaintOver = PANEL.PaintOver
function PANEL:PaintOver(w, h)
	if self.toggled then
		surface.SetDrawColor(0, 200, 0, 255)
		surface.SetMaterial(matHover)

		self:DrawTexturedRect()
	end

	if isfunction(oldPaintOver) then
		oldPaintOver(self, w, h)
	end
end

function PANEL:OnCursorEntered()
	self.PaintOverOld = self.PaintOver
	self.PaintOver = self.PaintOverHovered
end

function PANEL:OnCursorExited()
	if self.PaintOver == self.PaintOverHovered then
		self.PaintOver = self.PaintOverOld
	end
end

function PANEL:PaintOverHovered()
	if self.animPress:Active() or self.toggled then return end

	surface.SetDrawColor(255, 255, 255, 80)
	surface.SetMaterial(matHover)

	self:DrawTexturedRect()
end

function PANEL:PerformLayout()
	if self.animPress:Active() then return end

	self:SetSize(self.m_iIconSize, self.m_iIconSize)

	self.Icon:StretchToParent(0, 0, 0, 0)
end

function PANEL:SetIcon(icon)
	self.Icon:SetImage(icon)
end

function PANEL:GetIcon()
	return self.Icon:GetImage()
end

function PANEL:SetIconColor(c)
	self.Icon:SetImageColor(c)
end

function PANEL:Think()
	self.animPress:Run()
end

function PANEL:PressedAnim(anim, delta, data)
	if anim.Started then return end

	if anim.Finished then
		self.Icon:StretchToParent(0, 0, 0, 0)

		return
	end

	local border = math.sin(delta * math.pi) * (self.m_iIconSize * 0.05)

	self.Icon:StretchToParent(border, border, border, border)
end

function PANEL:Toggle(b)
	self.toggled = b
end

vgui.Register("SimpleRoleIcon", PANEL, "Panel")
