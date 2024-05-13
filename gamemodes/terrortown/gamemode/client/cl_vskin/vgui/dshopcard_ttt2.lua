---
-- @class PANEL
-- @section DShopCardTTT2

local PANEL = {}

local MODE_DEFAULT = ShopEditor.MODE_DEFAULT
local MODE_ADDED = ShopEditor.MODE_ADDED
local MODE_INHERIT_ADDED = ShopEditor.MODE_INHERIT_ADDED
local MODE_INHERIT_REMOVED = ShopEditor.MODE_INHERIT_REMOVED

---
-- @ignore
function PANEL:Init()
    self:SetContentAlignment(5)

    self:SetTall(22)
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
        title = "",
        icon = nil,
        mode = MODE_DEFAULT,
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
-- @return Matieral
-- @realm client
function PANEL:GetIcon()
    return self.data.icon
end

---
-- @param number mode
-- @param[default=false] boolean triggerFunction
-- @realm client
function PANEL:SetMode(mode, triggerFunction)
    if triggerFunction then
        self:OnModeChanged(self.data.mode or MODE_DEFAULT, mode or MODE_DEFAULT)
    end

    self.data.mode = mode or MODE_DEFAULT
end

---
-- @return number
-- @realm client
function PANEL:GetMode()
    return self.data.mode
end

---
-- @param number keyCode
-- @realm client
function PANEL:OnMouseReleased(keyCode)
    if keyCode == MOUSE_LEFT then
        if self:GetMode() == MODE_DEFAULT then
            self:SetMode(MODE_ADDED, true)
        elseif self:GetMode() == MODE_INHERIT_REMOVED then
            self:SetMode(MODE_INHERIT_ADDED, true)
        elseif self:GetMode() == MODE_ADDED then
            self:SetMode(MODE_DEFAULT, true)
        elseif self:GetMode() == MODE_INHERIT_ADDED then
            self:SetMode(MODE_INHERIT_REMOVED, true)
        end
    end

    self.BaseClass.OnMouseReleased(self, keyCode)
end

---
-- @param number oldMode
-- @param number newMode
-- @realm client
function PANEL:OnModeChanged(oldMode, newMode) end

---
-- @return boolean
-- @realm client
function PANEL:IsDown()
    return self.Depressed
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "ShopCardTTT2", self, w, h)

    return false
end

derma.DefineControl(
    "DShopCardTTT2",
    "A special button used for the shop editor",
    PANEL,
    "DButtonTTT2"
)
