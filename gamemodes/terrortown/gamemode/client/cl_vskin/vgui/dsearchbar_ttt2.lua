---
-- @class PANEL
-- @section DSearchBarTTT2

local PANEL = {}

local width, height
local font = "DermaTTT2Text"

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "heightMult", "HeightMult")

---
-- @accessor bool
-- @realm client
AccessorFunc(PANEL, "isOnFocus", "IsOnFocus")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "placeholderText", "PlaceholderText")

---
-- @ignore
function PANEL:Init()
	local textEntry = vgui.Create("DTextEntry", self)
	textEntry:SetFont(font)
	local textColor = util.GetActiveColor(util.GetChangedColor(util.GetDefaultColor(vskin.GetBackgroundColor()), 25))
	textEntry:SetTextColor(textColor)
	textEntry:SetCursorColor(textColor)
	textEntry.OnValueChange = function(slf,value)
		self:OnValueChange(value)
	end
	textEntry.OnGetFocus = function(slf)
		self:SetIsOnFocus(true)
		self:OnGetFocus()
	end
	textEntry.OnLoseFocus = function(slf)
		self:SetIsOnFocus(false)
		self:OnLoseFocus()
	end
	self.textEntry = textEntry

	-- This turns off the engine drawing for the text entry
	self.textEntry:SetPaintBackgroundEnabled(false)
	self.textEntry:SetPaintBorderEnabled(false)
	self.textEntry:SetPaintBackground(false)

	-- This turns off the engine drawing of the panel itself
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	self:SetPaintBackground(false)

	-- Sets default value
	self:SetHeightMult(1)
	self:SetIsOnFocus(false)
	self:SetPlaceholderText("Search List...")

	self:PerformLayout()
end

function PANEL:SetFont(newFont)
	self.textEntry:SetFont(newFont)
	font = newFont
end

function PANEL:GetFont()
	return font
end

function PANEL:SetUpdateOnType(enabled)
	self.textEntry:SetUpdateOnType(enabled)
end

function PANEL:OnGetFocus()

end

function PANEL:OnLoseFocus()

end

function PANEL:OnValueChange(value)

end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "Searchbar", self, w, h)

	return true
end

---
-- @ignore
function PANEL:PerformLayout()
	width, height = self:GetSize()
	local heightMult = self:GetHeightMult()
	self.textEntry:SetSize(width, height * heightMult)
	self.textEntry:SetPos(0, height * (1 - heightMult) / 2)
	self.textEntry:InvalidateLayout(true)
end

---
-- @return boolean
-- @realm client
function PANEL:Clear()
	return self.textEntry:Clear()
end

derma.DefineControl("DSearchBarTTT2", "", PANEL, "DPanelTTT2")
