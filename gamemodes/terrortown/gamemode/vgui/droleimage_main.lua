local PANEL = {}

AccessorFunc(PANEL, "m_Material", "Material")
AccessorFunc(PANEL, "m_Material2", "Material2")
AccessorFunc(PANEL, "m_Material2", "Material3")
AccessorFunc(PANEL, "m_Color", "ImageColor")
AccessorFunc(PANEL, "m_bKeepAspect", "KeepAspect")
AccessorFunc(PANEL, "m_strMatName", "MatName")
AccessorFunc(PANEL, "m_strMatName2", "MatName2")
AccessorFunc(PANEL, "m_strMatName2", "MatName3")

function PANEL:Init()
	self:SetImageColor(Color(255, 255, 255, 255))
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	self:SetKeepAspect(false)

	self.ImageName = ""
	self.ImageName2 = ""
	self.ImageName3 = ""

	self.ActualWidth = 10
	self.ActualHeight = 10
end

function PANEL:SetOnViewMaterial(MatName, MatName2, MatName3)
	self:SetMatName(MatName)
	self:SetMatName2(MatName2)
	self:SetMatName3(MatName3)

	self.ImageName = MatName
	self.ImageName2 = MatName2
	self.ImageName3 = MatName3
end

function PANEL:Unloaded()
	return self.m_strMatName ~= nil
end

function PANEL:LoadMaterial()
	if not self:Unloaded() then return end

	self:DoLoadMaterial()

	self:SetMatName(nil)
	self:SetMatName2(nil)
	self:SetMatName3(nil)
end

function PANEL:DoLoadMaterial()
	local mat = Material(self:GetMatName())
	local mat2 = Material(self:GetMatName2())
	local mat3 = Material(self:GetMatName3())

	self:SetMaterial(mat)
	self:FixVertexLitMaterial()

	if mat2 then
		self:SetMaterial2(mat2)
		self:FixVertexLitMaterial2()
	end

	if mat3 then
		self:SetMaterial3(mat3)
		self:FixVertexLitMaterial3()
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

function PANEL:SetMaterial3(Mat)
	-- Everybody makes mistakes,
	-- that's why they put erasers on pencils.
	if type(Mat) == "string" then
		self:SetImage3(Mat)

		return
	end

	self.m_Material3 = Mat
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

function PANEL:SetImage3(strImage3)
	self.ImageName3 = strImage3

	local Mat = Material(strImage3)

	self:SetMaterial3(Mat)
	self:FixVertexLitMaterial3()
end

function PANEL:UnloadImage2()
	self.ImageName2 = nil
	self.m_Material2 = nil
end

function PANEL:UnloadImage3()
	self.ImageName3 = nil
	self.m_Material3 = nil
end

function PANEL:GetImage()
	return self.ImageName
end

function PANEL:GetImage2()
	return self.ImageName2
end

function PANEL:GetImage3()
	return self.ImageName3
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

function PANEL:FixVertexLitMaterial3()
	--
	-- If it's a vertexlitgeneric material we need to change it to be
	-- UnlitGeneric so it doesn't go dark when we enter a dark room
	-- and flicker all about
	--

	local Mat = self:GetMaterial3()
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

	self:SetMaterial3(Mat)
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

		surface.DrawTexturedRect(OffX + x, OffY + y, w, h)

		if self.m_Material2 then
			surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
			surface.SetMaterial(self.m_Material2)
			surface.DrawTexturedRect(OffX + x, OffY + y, w, h)
		end

		if self.m_Material3 then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self.m_Material3)
			surface.DrawTexturedRect(OffX + x, OffY + y, w, h)
		end

		return true
	end

	surface.DrawTexturedRect(x, y, dw, dh)

	if self.m_Material2 then
		surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a)
		surface.SetMaterial(self.m_Material2)
		surface.DrawTexturedRect(x, y, dw, dh)
	end

	if self.m_Material3 then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.m_Material3)
		surface.DrawTexturedRect(x, y, dw, dh)
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
