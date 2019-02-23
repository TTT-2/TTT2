local base = "pure_skin_element"

HUDELEMENT.Base = base

if CLIENT then
	local x = 0
	local y = 0

	local w = 321 -- width
	local h = 36 -- height
	local bh = 8 -- bar height
	local pad = 14 -- padding

	function HUDELEMENT:Initialize()
		self:SetBasePos(math.Round(ScrW() * 0.5 - w * 0.5), ScrH() - pad - h)
		self:SetSize(w, h)
	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		local size = self:GetSize()

		x = pos.x
		y = pos.y
		w = size.w
		h = size.h

		local bclass = baseclass.Get(base)

		bclass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if not client.drowningProgress or not client:Alive() or client.drowningProgress == -1 then return end

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)

		self:DrawBar(x + pad, y + pad, w - pad * 2, bh, Color(36, 154, 198), client.drowningProgress)

		-- draw lines around the element
		self:DrawLines(x, y, w, h)
	end

	local defaults

	function HUDELEMENT:GetDefaults()
		if not defaults then
			local bclass = baseclass.Get(base)

			defaults = bclass.GetDefaults(self)
			defaults.resizeableY = false
		end

		return table.Copy(defaults)
	end
end
