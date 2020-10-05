local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment(4)
	self:SetTextInset(5, 0)
	self:SetFont("DermaTTT2CatHeader")

	self.text = ""

	self:SetText("")
end

function PANEL:DoClick()
	self:GetParent():Toggle()
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "CategoryHeaderTTT2", self, w, h)

	return false
end

derma.DefineControl("DCategoryHeaderTTT2", "Category Header", PANEL, "DButton")
