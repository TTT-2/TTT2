local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local x = 0
	local y = 0

	local w, h = 321, 36
	local min_w, min_h = 75, 36
	local bh = 8 -- bar height
	local pad = 14 -- padding
	
	function HUDELEMENT:Initialize()
		self:RecalculateBasePos()
		self:SetSize(w, h)
		self:SetMinSize(min_w, min_h)

		BaseClass.Initialize(self)
		
		self.defaults.minWidth = bh + 2 * pad
		self.defaults.resizeableY = false
	end

	function HUDELEMENT:RecalculateBasePos()
		self:SetBasePos(math.Round(ScrW() * 0.5 - w * 0.5), ScrH() - pad - h)
	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		local size = self:GetSize()

		x = pos.x
		y = pos.y
		w = size.w
		h = size.h

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if not HUDManager.IsEditing and (not client.drowningProgress or not client:Alive() or client.drowningProgress == -1) then return end

		pad = 14 * self.scale

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)
	
		self:DrawBar(x + pad, y + pad, w - pad * 2, h - pad * 2, Color(36, 154, 198), HUDManager.IsEditing and 1 or (client.drowningProgress or 1), 1)

		-- draw lines around the element
		self:DrawLines(x, y, w, h, self.basecolor.a)
	end
end
