local PANEL = {}

AccessorFunc(PANEL, "m_bBackground", "PaintBackground", FORCE_BOOL)
AccessorFunc(PANEL, "m_bBackground", "DrawBackground", FORCE_BOOL) -- deprecated
AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL)
AccessorFunc(PANEL, "m_bDisableTabbing", "TabbingDisabled", FORCE_BOOL)

AccessorFunc(PANEL, "m_bgColor", "BackgroundColor")

Derma_Hook(PANEL, "Paint", "Paint", "Panel")
Derma_Hook(PANEL, "ApplySchemeSettings", "Scheme", "Panel")
Derma_Hook(PANEL, "PerformLayout", "Layout", "Panel")

function PANEL:Init()
	self:SetPaintBackground(true)

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "ContentPanelTTT2", self, w, h)

	return false
end

function PANEL:SetEnabled(bEnabled)
	self.m_bEnabled = not bEnabled

	if bEnabled then
		self:SetAlpha(255)
		self:SetMouseInputEnabled(true)
	else
		self:SetAlpha(75)
		self:SetMouseInputEnabled(false)
	end
end

function PANEL:IsEnabled()
	return self.m_bEnabled
end

function PANEL:OnMousePressed(mousecode)
	if self:IsSelectionCanvas() and not dragndrop.IsDragging() then
		self:StartBoxSelection()

		return
	end

	if self:IsDraggable() then
		self:MouseCapture(true)
		self:DragMousePress(mousecode)
	end
end

function PANEL:OnMouseReleased(mousecode)
	if self:EndBoxSelection() then return end

	self:MouseCapture(false)
end

-- overwrites the base function with an empty function
function PANEL:UpdateColours()

end

derma.DefineControl("DContentPanelTTT2", "", PANEL, "Panel")
