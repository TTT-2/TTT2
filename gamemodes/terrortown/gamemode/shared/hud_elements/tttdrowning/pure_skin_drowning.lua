local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local x = 0
	local y = 0

	local pad_default = 14
	local bh_default = 8 -- bar height
	local w_default, h_default = 321, 36

	local w, h = w_default, h_default
	local min_w, min_h = 75, 36
	local pad = pad_default -- padding
	
	function HUDELEMENT:Initialize()
		w, h = w_default, h_default
		pad = pad_default
		self.basecolor = self:GetHUDBasecolor()

		self:RecalculateBasePos()
		
		self:SetMinSize(min_w, min_h)
		self:SetSize(w, h)

		BaseClass.Initialize(self)
	end
	
	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:RecalculateBasePos()
		self:SetBasePos(math.Round(ScrW() * 0.5 - w * 0.5), ScrH() - pad - h)
	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return HUDManager.IsEditing or client.drowningProgress and client:Alive() and client.drowningProgress ~= -1
	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		local size = self:GetSize()
		local scale = self:GetHUDScale()

		self.basecolor = self:GetHUDBasecolor()

		pad = pad_default * scale
		x = pos.x
		y = pos.y
		w = size.w
		h = size.h

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)
	
		self:DrawBar(x + pad, y + pad, w - pad * 2, h - pad * 2, Color(36, 154, 198), HUDManager.IsEditing and 1 or (client.drowningProgress or 1), 1)

		-- draw lines around the element
		self:DrawLines(x, y, w, h, self.basecolor.a)
	end
end
