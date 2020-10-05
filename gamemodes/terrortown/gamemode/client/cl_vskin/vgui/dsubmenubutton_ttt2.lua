local PANEL = {}

AccessorFunc(PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL)

function PANEL:Init()
	self:SetContentAlignment(5)

	self:SetDrawBorder(true)
	self:SetPaintBackground(true)

	self:SetTall(22)
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	self:SetCursor("hand")
	self:SetText("")

	self.contents = {
		title = "",
		title_font = "DermaTTT2SubMenuButtonTitle",
		selected = false
	}
end

function PANEL:IsDown()
	return self.Depressed
end

function PANEL:SetTitle(title)
	self.contents.title = title or ""
end

function PANEL:GetTitle()
	return self.contents.title
end

function PANEL:SetTitleFont(title_font)
	self.contents.title_font = title_font or ""
end

function PANEL:GetTitleFont()
	return self.contents.title_font
end

function PANEL:SetActive(active)
	self.contents.active = active == nil and true or false
end

function PANEL:IsActive()
	return self.contents.active or false
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "SubMenuButtonTTT2", self, w, h)

	return false
end

function PANEL:PerformLayout()
	DLabel.PerformLayout(self)
end

function PANEL:SetConsoleCommand(strName, strArgs)
	self.DoClick = function(slf, val)
		RunConsoleCommand(strName, strArgs)
	end
end

function PANEL:SizeToContents()
	local w, h = self:GetContentSize()

	self:SetSize(w + 8, h + 4)
end

derma.DefineControl("DSubMenuButtonTTT2", "A standard Button", PANEL, "DLabel")
