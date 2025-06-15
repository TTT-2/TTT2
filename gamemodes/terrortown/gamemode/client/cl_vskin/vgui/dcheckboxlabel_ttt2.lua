---
-- @class PANEL
-- @section DCheckBoxLabelTTT2

local PANEL = {}

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_iIndent", "Indent")

---
-- @ignore
function PANEL:Init()
    self.Button = vgui.Create("DCheckBox", self)
    self.Button.OnChange = function(_, val)
        self:ValueChanged(val)

        -- enable / disable followers on change
        self:UpdateFollowers(val)
    end

    self.OnChange = function(_, val)
        self.Button:SetValue(val)
    end

    local oldSetEnabled = self.SetEnabled

    self.SetEnabled = function(slf, enabled)
        oldSetEnabled(slf, enabled)

        slf.Button:SetEnabled(enabled)

        -- make sure sub-followers are updated as well
        if not enabled then
            slf:UpdateFollowers(false)
        else
            slf:UpdateFollowers(slf.Button:GetChecked())
        end
    end

    self:SetFont("DermaTTT2Text")

    -- store followers in here to be updates on change of this value
    self.followers = {}
end

---
-- @param boolean val
-- @realm client
function PANEL:UpdateFollowers(val)
    for i = 1, #self.followers do
        self.followers[i]:SetEnabled(val)
    end
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "CheckBoxLabel", self, w, h)

    return true
end

---
-- overwrites the default function
-- @param boolean value
-- @realm client
function PANEL:SetDefaultValue(value)
    local noDefault = true

    if isbool(value) then
        -- note: even when it is inverted, the default is not inverted here
        -- as it is inverted when the default button is pressed

        self.default = value

        noDefault = false
    else
        self.default = nil
    end

    local reset = self:GetResetButton()

    if ispanel(reset) then
        reset.noDefault = noDefault
    end
end

---
-- @param any val
-- @realm client
function PANEL:SetChecked(val)
    self.Button:SetChecked(val)
end

---
-- @return any
-- @realm client
function PANEL:GetChecked()
    return self.Button:GetChecked()
end

---
-- @realm client
function PANEL:Toggle()
    self.Button:Toggle()
end

---
-- @param Panel reset
-- @realm client
function PANEL:SetResetButton(reset)
    if not ispanel(reset) then
        return
    end

    self.resetButton = reset

    reset.DoClick = function(slf)
        self:SetValue(self:GetDefaultValue())
    end

    reset.noDefault = self.default == nil
end

---
-- @return Panel reset
-- @realm client
function PANEL:GetResetButton()
    return self.resetButton
end

---
-- @param Panel follower
-- @realm client
function PANEL:AddFollower(follower)
    if not IsValid(follower) then
        return
    end

    self.followers[#self.followers + 1] = follower

    follower:SetEnabled(self.Button:GetChecked())
end

---
-- @ignore
function PANEL:PerformLayout()
    local x = self.m_iIndent or 0

    local height = self:GetTall()
    local paddingButton = 4
    local heightButton = height - 2 * paddingButton
    local widthButton = 1.5 * heightButton

    self.Button:SetSize(widthButton, heightButton)
    self.Button:SetPos(x + paddingButton, paddingButton)

    self.textPos = 2 * paddingButton + widthButton + x + 5
end

---
-- @return number
-- @realm client
function PANEL:GetTextPosition()
    return self.textPos or 0
end

---
-- @param string text
-- @realm client
function PANEL:SetText(text)
    self.text = text
end

---
-- @param table params
-- @realm client
function PANEL:SetTextParams(params)
    self.params = params
end

---
-- @param string font
-- @realm client
function PANEL:SetFont(font)
    self.font = font
end

---
-- @return string
-- @realm client
function PANEL:GetFont()
    return self.font or ""
end

---
-- @return string
-- @realm client
function PANEL:GetText()
    return self.text or ""
end

---
-- @return table
-- @realm client
function PANEL:GetTextParams()
    return self.params
end

derma.DefineControl("DCheckBoxLabelTTT2", "", PANEL, "TTT2:DButton")
