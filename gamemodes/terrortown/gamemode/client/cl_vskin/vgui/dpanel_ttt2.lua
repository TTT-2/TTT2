local PANEL = {}

AccessorFunc(PANEL, "m_bBackground", "PaintBackground", FORCE_BOOL)
AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL)
AccessorFunc(PANEL, "m_bDisableTabbing", "TabbingDisabled", FORCE_BOOL)

AccessorFunc(PANEL, "m_bDisabled", "Disabled")
AccessorFunc(PANEL, "m_bgColor", "BackgroundColor")

Derma_Hook(PANEL, "Paint", "Paint", "Panel")
Derma_Hook(PANEL, "ApplySchemeSettings", "Scheme", "Panel")
Derma_Hook(PANEL, "PerformLayout", "Layout", "Panel")

function PANEL:Init()
	self:SetPaintBackground(true)

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)

	self.tooltip = {
		fixedPosition = nil,
		fixedSize = nil,
		delay = 0,
		text = "",
		font = "DermaTTT2Text"
	}

	local oldSetTooltipPanel = self.SetTooltipPanel

	self.SetTooltipPanel = function(slf, panel)
		slf:SetTooltipPanelOverride("DTooltipTTT2")

		oldSetTooltipPanel(slf, panel)
	end
end

function PANEL:SetDisabled(bDisabled)
	self.m_bDisabled = bDisabled

	if bDisabled then
		self:SetAlpha(75)
		self:SetMouseInputEnabled(false)
	else
		self:SetAlpha(255)
		self:SetMouseInputEnabled(true)
	end
end

function PANEL:SetEnabled(bEnabled)
	self:SetDisabled(not bEnabled)
end

function PANEL:IsEnabled()
	return not self:GetDisabled()
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

	if self:DragMouseRelease(mousecode) then
		return
	end
end

function PANEL:UpdateColours()

end

function PANEL:SetTooltipFixedPosition(x, y)
	self.tooltip.fixedPosition = {
		x = x,
		y = y
	}
end

function PANEL:GetTooltipFixedPosition()
	return self.tooltip.fixedPosition.x, self.tooltip.fixedPosition.y
end

function PANEL:HasTooltipFixedPosition()
	return self.tooltip.fixedPosition ~= nil
end

function PANEL:SetTooltipFixedSize(w, h)
	self.tooltip.fixedSize = {
		w = w,
		h = h
	}
end

function PANEL:GetTooltipFixedSize()
	return self.tooltip.fixedSize.w, self.tooltip.fixedSize.h
end

function PANEL:HasTooltipFixedSize()
	return self.tooltip.fixedSize ~= nil
end

function PANEL:SetTooltipOpeningDelay(delay)
	self.tooltip.delay = delay
end

function PANEL:GetTooltipOpeningDelay()
	return self.tooltip.delay
end

-- overwrite the tooltip function
function PANEL:SetTooltip(text)
	self:SetTooltipPanelOverride("DTooltipTTT2")

	self.tooltip.text = text
end

function PANEL:GetTooltipText()
	return self.tooltip.text
end

function PANEL:HasTooltipText()
	return self.tooltip.text ~= nil and self.tooltip.text ~= ""
end

function PANEL:SetTooltipFont(font)
	self.tooltip.font = font
end

function PANEL:GetTooltipFont()
	return self.tooltip.font
end

derma.DefineControl("DPanelTTT2", "", PANEL, "Panel")
