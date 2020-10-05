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
		title_font = "DermaTTT2MenuButtonTitle",
		description = "",
		description_font = "DermaTTT2MenuButtonDescription",
		icon = nil
	}
end

function PANEL:IsDown()
	return self.Depressed
end

function PANEL:SetImage(mat)
	self.contents.icon = mat
end

function PANEL:GetImage()
	return self.contents.icon
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

function PANEL:SetDescription(description)
	self.contents.description = description or ""
end

function PANEL:GetDescription()
	return self.contents.description
end

function PANEL:SetDescriptionFont(description_font)
	self.contents.description_font = description_font or ""
end

function PANEL:GetDescriptionFont()
	return self.contents.description_font
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "MenuButtonTTT2", self, w, h)

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

derma.DefineControl("DMenuButtonTTT2", "A standard Button", PANEL, "DLabel")
