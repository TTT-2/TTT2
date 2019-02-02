HUDELEMENT.Base = "pure_skin_element"

if CLIENT then
	local x = 0
	local y = 0

	function HUDELEMENT:Initialize()
		self:SetPos(500, 500)
		self:PerformLayout()
	end

	function HUDELEMENT:PerformLayout()
		x = self.pos.x
		y = ScrH() - self.pos.y
	end

	function HUDELEMENT:Draw()
		--local scrW = ScrW()
		--local scrH = ScrH()

		local w = 365
		local h = 146

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, Color(49, 71, 94))

		-- draw left panel
		local c = LocalPlayer():GetRoleColor()
		local lpw = 44

		surface.SetDrawColor(clr(c))
		surface.DrawRect(x, y, lpw, h)

		-- draw dark bottom overlay
		surface.SetDrawColor(0, 0, 0, 90)
		surface.DrawRect(x, y + lpw, w, h - lpw)

		-- draw lines
		self:DrawLines(x, y, w, h)
	end
end
