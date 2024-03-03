---
-- @class PANEL
-- @section DEventBoxTTT2

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
        title_font = "DermaTTT2TextLarger",
        font = "DermaTTT2Text",
        event = nil,
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
function PANEL:SetFont(font)
    self.contents.font = font or ""
end

---
-- @return string
-- @realm client
function PANEL:GetFont()
    return self.contents.font
end

---
-- Calculates the required content height based on the width.
-- @param number width The provided width
-- @return number The calculated height
-- @realm client
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

        local textWrapped = drawGetWrappedText(textTranslated, width - 50, self:GetFont())

        size = size + #textWrapped * heightText + 15 -- 15: paragraph end
    end

    local event = self:GetEvent()

    if event:HasScore() then
        local scoredPlayers = event:GetScoredPlayers()
        local sid64 = LocalPlayer():SteamID64()

        for i = 1, #scoredPlayers do
            local ply64 = scoredPlayers[i]

            if event.onlyLocalPlayer and ply64 ~= sid64 then
                continue
            end

            local scoreRows = #event:GetRawScoreText(ply64)

            if scoreRows == 0 then
                continue
            end

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
