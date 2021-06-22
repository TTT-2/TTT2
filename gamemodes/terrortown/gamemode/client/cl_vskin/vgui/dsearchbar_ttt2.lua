---
-- @class PANEL
-- @section DSearchBarTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	self:SetPaintBackground(false)
end

---
-- @realm client
function PANEL:Rebuild()

end

---
-- @ignore
function PANEL:PerformLayoutInternal()
	self:Rebuild()
end

---
-- @ignore
function PANEL:PerformLayout()
	self:PerformLayoutInternal()
end

---
-- @return boolean
-- @realm client
function PANEL:Clear()
	return true
end

derma.DefineControl("DSearchBarTTT2", "", PANEL, "DPanelTTT2")
