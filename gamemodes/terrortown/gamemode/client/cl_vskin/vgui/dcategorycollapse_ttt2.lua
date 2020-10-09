local PANEL = {}

AccessorFunc(PANEL, "m_bSizeExpanded", "Expanded", FORCE_BOOL)
AccessorFunc(PANEL, "m_iContentHeight", "StartHeight")
AccessorFunc(PANEL, "m_fAnimTime", "AnimTime")
AccessorFunc(PANEL, "m_bDrawBackground", "PaintBackground", FORCE_BOOL)
AccessorFunc(PANEL, "m_iPadding", "Padding")
AccessorFunc(PANEL, "m_pList", "List")

function PANEL:Init()
	self.Header = vgui.Create("DCategoryHeaderTTT2", self)
	self.Header:Dock(TOP)
	self.Header:SetSize(20, vskin.GetCollapsableHeight())

	self:SetSize(16, 16)
	self:SetExpanded(true)
	self:SetMouseInputEnabled(true)

	self:SetPaintBackground(true)
	self:DockMargin(10, 10, 10, 5)
	self:DockPadding(0, 0, 0, 0)
end

function PANEL:Add(strName)
	local button = vgui.Create("DButton", self)

	button.Paint = function(panel, w, h)
		derma.SkinHook("Paint", "CategoryButtonTTT2", panel, w, h)
	end

	button:SetHeight(17)
	button:SetTextInset(4, 0)

	button:SetContentAlignment(4)
	button:DockMargin(1, 0, 1, 0)
	button.DoClickInternal = function()
		if self:GetList() then
			self:GetList():UnselectAll()
		else
			self:UnselectAll()
		end

		button:SetSelected(true)
	end

	button:Dock(TOP)
	button:SetText(strName)

	self:InvalidateLayout(true)
	self:UpdateAltLines()

	return button
end

function PANEL:UnselectAll()
	local children = self:GetChildren()

	for i = 1, #children do
		local child = children[i]

		if not isfunction(child.SetSelected) then continue end

		child:SetSelected(false)
	end
end

function PANEL:UpdateAltLines()
	local children = self:GetChildren()

	for i = 1, #children do
		children[i].AltLine = i % 2 ~= 1
	end
end

function PANEL:SetLabel(strLabel)
	self.Header.text = strLabel
end

function PANEL:GetLabel()
	return self.Header.text
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "CollapsibleCategoryTTT2", self, w, h)

	return false
end

function PANEL:SetContents(pContents)
	self.Contents = pContents
	self.Contents:SetParent(self)
	self.Contents:Dock(FILL)

	if not self:GetExpanded() then
		self.OldHeight = self:GetTall()
	elseif self:GetExpanded() and IsValid(self.Contents) and self.Contents:GetTall() < 1 then
		self.Contents:SizeToChildren(false, true)
		self.OldHeight = self.Contents:GetTall()
		self:SetTall(self.OldHeight)
	end

	self:InvalidateLayout(true)
end

function PANEL:SetExpanded(expanded)
	self.m_bSizeExpanded = tobool(expanded)

	if not self:GetExpanded() then
		self.OldHeight = self:GetTall()
	end
end

function PANEL:Toggle()
	self:SetExpanded(not self:GetExpanded())
	self:InvalidateLayout(true)
	self:OnToggle(self:GetExpanded())
end

function PANEL:OnToggle(expanded)

end

function PANEL:DoExpansion(b)
	if self:GetExpanded() == b then return end

	self:Toggle()
end

function PANEL:PerformLayout()
	if IsValid(self.Contents) then
		if self:GetExpanded() then
			self.Contents:InvalidateLayout(true)
			self.Contents:SetVisible(true)
		else
			self.Contents:SetVisible(false)
		end
	end

	if self:GetExpanded() then
		if IsValid(self.Contents) and #self.Contents:GetChildren() > 0 then
			self.Contents:SizeToChildren(false, true)
		end

		self:SizeToChildren(false, true)

		-- hacky solution to make sure box is always big enough
		-- I don't know why I have to do this though
		local w, h = self:GetSize()
		self:SetSize(w, h + 15)
	else
		if IsValid(self.Contents) and not self.OldHeight then
			self.OldHeight = self.Contents:GetTall()
		end

		self:SetTall(self.Header:GetTall() + vskin:GetBorderSize() + 2)
	end

	-- Make sure the color of header text is set
	self.Header:ApplySchemeSettings()
	self.Header:SetSize(20, vskin.GetCollapsableHeight())

	self:UpdateAltLines()
end

function PANEL:OnMousePressed(mcode)
	if not self:GetParent().OnMousePressed then return end

	return self:GetParent():OnMousePressed(mcode)
end

function PANEL:GenerateExample(ClassName, PropertySheet, Width, Height)
	local ctrl = vgui.Create(ClassName)

	ctrl:SetLabel("Category List Test Category")
	ctrl:SetSize(300, 300)
	ctrl:SetPadding(10)

	-- The contents can be any panel, even a DPanelList
	local Contents = vgui.Create("DButton")

	Contents:SetText("This is the content of the control")
	ctrl:SetContents(Contents)
	ctrl:InvalidateLayout(true)

	PropertySheet:AddSheet(ClassName, ctrl, nil, true, true)
end

derma.DefineControl("DCollapsibleCategoryTTT2", "Collapsable Category Panel", PANEL, "Panel")
