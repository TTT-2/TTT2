---
-- @class PANEL
-- @section DColoredBoxTTT2

local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation
local drawGetWrappedText = draw.GetWrappedText
local drawGetTextSize = draw.GetTextSize
local mathmax = math.max
local tableCount = table.Count

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

---
-- @param EVENT event
-- @realm client
function PANEL:SetEvent(event)
	self.contents.event = event
end

---
-- @return EVENT
-- @realm client
function PANEL:GetEvent()
	return self.contents.event
end

---
-- @return Material
-- @realm client
function PANEL:GetIcon()
	return self.contents.event.icon
end

---
-- @return string
-- @realm client
function PANEL:GetTitle()
	return self.contents.event.title
end

---
-- @return string
-- @realm client
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
	local _, heightText = drawGetTextSize("", self:GetFont())

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

		size = size + #textWrapped * heightText + 15 -- 15: paragraph end
	end

	local event = self:GetEvent()

	if event:HasScore() then
		local scoredPlayers = event:GetScoredPlayers()

		for i = 1, #scoredPlayers do
			local scoreRows = #event:GetRawScoreText(scoredPlayers[i])

			if scoreRows == 0 then continue end

			size = size + (scoreRows + 1) * heightText + 35 -- 35 spacing + padding
		end
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
