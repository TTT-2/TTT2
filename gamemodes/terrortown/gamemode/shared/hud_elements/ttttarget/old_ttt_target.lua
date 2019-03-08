local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
	function HUDELEMENT:Initialize()
		local width, height = self.maxwidth, 45

	    self:SetBasePos(15, ScrH() - height - self.maxheight - self.margin)
		self:SetSize(width, height)

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:DrawComponent(name, col, val)
		local client = LocalPlayer()

		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local width, height = size.w, size.h

		draw.RoundedBox(8, x, y, width, height, self.bg_colors.background_main)

		local bar_width = width - self.dmargin
		local bar_height = height - self.dmargin

		local tx = x + self.margin
		local ty = y + self.margin

		self:PaintBar(tx, ty, bar_width, bar_height, col)
		self:ShadowedText(name, "HealthAmmo", tx + bar_width * 0.5, ty + bar_height * 0.5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText("Target", "TabLarge", x + self.margin * 2, y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	local edit_colors = {
		border = COLOR_WHITE,
		background = Color(0, 0, 10, 200),
		fill = Color(100, 100, 100, 255)
	}

	function HUDELEMENT:Draw()
		local ply = LocalPlayer()

		if not IsValid(ply) then return end

		local tgt = ply:GetTargetPlayer()

		if HUDManager.IsEditing then
			self:DrawComponent("TARGET", edit_colors, "- TARGET -")
		elseif IsValid(tgt) and ply:IsActive() then
			local col_tbl = {
				border = COLOR_WHITE,
				background = tgt:GetRoleDkColor(),
				fill = tgt:GetRoleColor()
			}

			self:DrawComponent("TARGET", col_tbl, tgt:Nick())
		end
	end
end
