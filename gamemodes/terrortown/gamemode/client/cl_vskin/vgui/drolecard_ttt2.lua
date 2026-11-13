---
-- A clickable card that presents a role with its icon, its name, its team and some tags.
-- @class PANEL
-- @section DRoleCardTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    self:SetCursor("hand")
    self:SetFont("DermaTTT2TextLarge")

    -- remove label and overwrite function
    self:SetText("")
    self.SetText = function(slf, text)
        slf.data.text = text
    end

    self.data = {
        text = "",
        icon = nil,
        color = COLOR_WHITE,
        teamText = "",
        teamColor = COLOR_WARMGRAY,
        tags = {},
        selected = false,
    }
end

---
-- @return string
-- @realm client
function PANEL:GetText()
    return self.data.text
end

---
-- @param Material icon
-- @realm client
function PANEL:SetIcon(icon)
    self.data.icon = icon
end

---
-- @return Material
-- @realm client
function PANEL:GetIcon()
    return self.data.icon
end

---
-- Sets the color of the box the role icon is drawn on.
-- @param Color color
-- @realm client
function PANEL:SetColor(color)
    self.data.color = color
end

---
-- @return Color
-- @realm client
function PANEL:GetColor()
    return self.data.color
end

---
-- @param string text The team name, can be a language identifier
-- @realm client
function PANEL:SetTeamText(text)
    self.data.teamText = text
end

---
-- @return string
-- @realm client
function PANEL:GetTeamText()
    return self.data.teamText
end

---
-- @param Color color
-- @realm client
function PANEL:SetTeamColor(color)
    self.data.teamColor = color
end

---
-- @return Color
-- @realm client
function PANEL:GetTeamColor()
    return self.data.teamColor
end

---
-- Sets the tags that are shown in the top right corner of the card.
-- @param table tags A list of texts, can be language identifiers
-- @realm client
function PANEL:SetTags(tags)
    self.data.tags = tags or {}
end

---
-- @return table
-- @realm client
function PANEL:GetTags()
    return self.data.tags
end

---
-- @param boolean selected
-- @realm client
function PANEL:SetSelected(selected)
    self.data.selected = selected
end

---
-- @return boolean
-- @realm client
function PANEL:IsSelected()
    return self.data.selected
end

---
-- @return boolean
-- @realm client
function PANEL:IsDown()
    return self.Depressed
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "RoleCardTTT2", self, w, h)

    return false
end

derma.DefineControl(
    "DRoleCardTTT2",
    "A card that presents a role with its team",
    PANEL,
    "DButtonTTT2"
)
