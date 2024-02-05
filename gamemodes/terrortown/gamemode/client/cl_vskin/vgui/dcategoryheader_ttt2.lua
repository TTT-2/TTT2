---
-- @class PANEL
-- @section DCategoryHeaderTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self:SetContentAlignment(4)
    self:SetTextInset(5, 0)
    self:SetFont("DermaTTT2CatHeader")

    self.text = ""

    self:SetText("")
end

---
-- @ignore
function PANEL:DoClick()
    self:GetParent():Toggle()
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "CategoryHeaderTTT2", self, w, h)

    return false
end

derma.DefineControl("DCategoryHeaderTTT2", "Category Header", PANEL, "DButton")
