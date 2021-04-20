---
-- @class PANEL
-- @section DColoredBoxTTT2

local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation
local drawGetWrappedText = draw.GetWrappedText
local drawGetTextSize = draw.GetTextSize
local mathmax = math.max

local PANEL = {}

---
-- @ignore
function PANEL:Init()
	self:SetText("")

	self.contents = {
		title_font = "DermaTTT2TextLargest",
		font = "DermaTTT2MenuButtonTitle",
		event = nil
	}
end

function PANEL:SetEvent(event)
	self.contents.event = event
end

function PANEL:GetIcon()
	return self.contents.event.icon
end

function PANEL:GetTitle()
	return self.contents.event.title
end

function PANEL:GetText()
	return self.contents.event:GetText()
end

---
-- @param string title_font
-- @realm client
function PANEL:SetTitleFont(title_font)
	self.contents.title_font = title_font or ""
end

---
-- @return string
-- @realm client
function PANEL:GetTitleFont()
	return self.contents.title_font
end

---
-- @param string font
-- @realm client
function PANEL:SetTitleFont(font)
	self.contents.font = font or ""
end

---
-- @return string
-- @realm client
function PANEL:GetTitleFont()
	return self.contents.font
end

function PANEL:GetContentHeight(width)
	local size = 50 -- title height

	local textTable = self:GetText()

	for i = 1, #textTable do
		local text = textTable[i]
		local params = {}

		if text.translateParams then
			for key, value in pairs(text.params) do
				params[key] = TryT(value)
			end
		else
			params = text.params
		end

		local textTranslated = ParT(text.string, params or {})

		local textWrapped = drawGetWrappedText(
			textTranslated,
			width - 50,
			self:GetFont()
		)

		local _, heightText = drawGetTextSize("", self:GetFont())

		size = size + #textWrapped * heightText + 15 -- 15: paragraph end
	end

	return mathmax(size, 75)
end

---
-- @param number w
-- @param number h
-- @realm client
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "EventBoxTTT2", self, w, h)

	return false
end

derma.DefineControl("DEventBoxTTT2", "", PANEL, "DPanelTTT2")
