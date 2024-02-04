---
-- @class PANEL
-- @section DBinderPanelTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self.binder = vgui.Create("DBinderTTT2", self)
    self.disable = vgui.Create("DButtonTTT2", self)

    self.binder.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "BinderButtonTTT2", slf, w, h)

        return false
    end

    self.disable.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "FormButtonIconTTT2", slf, w, h)

        return true
    end
end

---
-- @ignore
function PANEL:PerformLayout(w, h)
    self.binder:SetSize(150, h)
    self.binder:SetPos(0, 0)

    self.disable:SetSize(h, h)
    self.disable:SetPos(w - h, 0)
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "BinderPanelTTT2", self, w, h)

    return false
end

derma.DefineControl("DBinderPanelTTT2", "", PANEL, "DPanelTTT2")
