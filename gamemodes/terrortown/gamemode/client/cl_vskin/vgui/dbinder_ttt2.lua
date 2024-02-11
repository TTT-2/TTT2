---
-- @class PANEL
-- @section DBinderTTT2

local PANEL = {}

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_iSelectedNumber", "SelectedNumber")

Derma_Install_Convar_Functions(PANEL)

---
-- @ignore
function PANEL:Init()
    self:SetSelectedNumber(0)
    self:SetSize(60, 30)
end

---
-- @realm client
function PANEL:UpdateText()
    local str = input.GetKeyName(self:GetSelectedNumber())

    if not str then
        str = "button_none"
    end

    str = language.GetPhrase(str)

    self:SetText(str)
end

---
-- @realm client
function PANEL:DoClick()
    self:SetText("button_press_key")

    input.StartKeyTrapping()

    self.trapping = true
end

---
-- @realm client
function PANEL:DoRightClick()
    self:SetText("button_none")
    self:SetValue(0)
end

---
-- @param number iNum
-- @realm client
function PANEL:SetSelectedNumber(iNum)
    self.m_iSelectedNumber = iNum
    self:ConVarChanged(iNum)
    self:UpdateText()
    self:OnChange(iNum)
end

---
-- @ignore
function PANEL:Think()
    if input.IsKeyTrapping() and self.trapping then
        local code = input.CheckKeyTrapping()

        if code then
            if code == KEY_ESCAPE then
                self:SetValue(self:GetSelectedNumber())
            else
                self:SetValue(code)
            end

            self.trapping = false
        end
    end

    self:ConVarNumberThink()
end

---
-- @param number iNumValue
-- @realm client
function PANEL:SetValue(iNumValue)
    self:SetSelectedNumber(iNumValue)
end

---
-- @return number
-- @realm client
function PANEL:GetValue()
    return self:GetSelectedNumber()
end

---
-- @realm client
function PANEL:OnChange() end

derma.DefineControl("DBinderTTT2", "", PANEL, "DButtonTTT2")
