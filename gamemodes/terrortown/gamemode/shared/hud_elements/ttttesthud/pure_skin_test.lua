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
		self:DrawBg(x, y, 200, 150, Color(150, 100, 200))
	end
end
