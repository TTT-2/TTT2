---
-- @class PANEL
-- @section DLabelTTT2

local PANEL = {}

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "m_colText", "TextColor")

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "m_colTextStyle", "TextStyleColor")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "m_FontName", "Font")

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDoubleClicking", "DoubleClickingEnabled", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bAutoStretchVertical", "AutoStretchVertical", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBackground", "PaintBackground", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bIsToggle", "IsToggle", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bToggle", "Toggle", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBright", "Bright", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDark", "Dark", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bHighlight", "Highlight", FORCE_BOOL)

---
-- @ignore
function PANEL:Init()
	self:SetIsToggle(false)
	self:SetToggle(false)
	self:SetEnabled(true)
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	self:SetDoubleClickingEnabled(true)

	-- Nicer default height
	self:SetTall(20)

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)

	self:SetFont("DermaTTT2Text")
end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "LabelTTT2", self, w, h)

	return true
end

---
-- @param string strFont
-- @realm client
function PANEL:SetFont(strFont)
	self.m_FontName = strFont

	self:SetFontInternal(self.m_FontName)
	self:ApplySchemeSettings()
end

---
-- @param Color clr
-- @realm client
function PANEL:SetTextColor(clr)
	self.m_colText = clr

	self:UpdateFGColor()
end

---
-- @return Color
-- @realm client
function PANEL:GetColor()
	return self.m_colText or self.m_colTextStyle
end

---
-- @realm client
function PANEL:UpdateFGColor()
	local col = self:GetTextColor() or self:GetTextStyleColor()

	if not col then return end

	self:SetFGColor(col.r, col.g, col.b, col.a)
end

---
-- @realm client
function PANEL:Toggle()
	if not self:GetIsToggle() then return end

	self:SetToggle(not self:GetToggle())
	self:OnToggled(self:GetToggle())
end

---
-- @param boolean bEnabled
-- @realm client
function PANEL:SetEnabled(bEnabled)
	self.m_bEnabled = bEnabled

	self:InvalidateLayout()
end

---
-- @return boolean
-- @realm client
function PANEL:IsEnabled()
	return self.m_bEnabled
end

---
-- @return boolean
-- @realm client
function PANEL:GetDisabled()
	return not self:IsEnabled()
end

---
-- @param table skin
-- @return Color
-- @realm client
function PANEL:UpdateColours(skin)
	if self:GetBright() then
		return self:SetTextStyleColor(skin.Colours.Label.Bright)
	end

	if self:GetDark() then
		return self:SetTextStyleColor(skin.Colours.Label.Dark)
	end

	if self:GetHighlight() then
		return self:SetTextStyleColor(skin.Colours.Label.Highlight)
	end

	return self:SetTextStyleColor(skin.Colours.Label.Default)
end

---
-- @ignore
function PANEL:ApplySchemeSettings()
	self:UpdateColours(self:GetSkin())

	self:UpdateFGColor()
end

---
-- @ignore
function PANEL:Think()
	if self:GetAutoStretchVertical() then
		self:SizeToContentsY()
	end
end

---
-- @ignore
function PANEL:PerformLayout()
	self:ApplySchemeSettings()
end

---
-- @realm client
function PANEL:OnCursorEntered()
	self:InvalidateLayout(true)
end

---
-- @realm client
function PANEL:OnCursorExited()
	self:InvalidateLayout(true)
end

---
-- @param number mcode
-- @realm client
function PANEL:OnMousePressed(mcode)
	if self:GetDisabled() then return end

	if mcode == MOUSE_LEFT and not dragndrop.IsDragging() and self.m_bDoubleClicking then
		if self.LastClickTime and SysTime() - self.LastClickTime < 0.2 then
			self:DoDoubleClickInternal()
			self:DoDoubleClick()

			return
		end

		self.LastClickTime = SysTime()
	end

	-- If we're selectable and have shift held down then go up
	-- the parent until we find a selection canvas and start box selection
	if self:IsSelectable() and mcode == MOUSE_LEFT and input.IsShiftDown() then
		return self:StartBoxSelection()
	end

	self:MouseCapture(true)
	self.Depressed = true
	self:OnDepressed()
	self:InvalidateLayout(true)

	--
	-- Tell DragNDrop that we're down, and might start getting dragged!
	--
	self:DragMousePress(mcode)
end

---
-- @param number mcode
-- @realm client
function PANEL:OnMouseReleased(mcode)
	self:MouseCapture(false)

	if self:GetDisabled() then return end

	if not self.Depressed and dragndrop.m_DraggingMain ~= self then return end

	if self.Depressed then
		self.Depressed = nil
		self:OnReleased()
		self:InvalidateLayout(true)
	end

	-- If we were being dragged then don't do the default behaviour!
	if self:DragMouseRelease(mcode) then return end

	if self:IsSelectable() and mcode == MOUSE_LEFT then
		local canvas = self:GetSelectionCanvas()

		if canvas then
			canvas:UnselectAll()
		end
	end

	if not self.Hovered then return end

	--
	-- For the purposes of these callbacks we want to
	-- keep depressed true. This helps us out in controls
	-- like the checkbox in the properties dialog. Because
	-- the properties dialog will only manually change the value
	-- if IsEditing() is true - and the only way to work out if
	-- a label/button based control is editing is when it's depressed.
	--
	self.Depressed = true

	if mcode == MOUSE_RIGHT then
		self:DoRightClick()
	elseif mcode == MOUSE_LEFT then
		self:DoClickInternal()
		self:DoClick()
	elseif mcode == MOUSE_MIDDLE then
		self:DoMiddleClick()
	end

	self.Depressed = nil
end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:OnReleased()

end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:OnDepressed()

end

---
-- overwrites the base function with an empty function
-- @param boolean bool
-- @realm client
function PANEL:OnToggled(bool)

end

---
-- @realm client
function PANEL:DoClick()
	self:Toggle()
end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:DoRightClick()

end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:DoMiddleClick()

end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:DoClickInternal()

end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:DoDoubleClick()

end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:DoDoubleClickInternal()

end

derma.DefineControl("DLabelTTT2", "A Label", PANEL, "Label")
