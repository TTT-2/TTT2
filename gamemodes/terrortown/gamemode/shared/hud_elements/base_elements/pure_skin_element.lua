if CLIENT then
	local defaultColor = Color(49, 71, 94)
	local shadowColor = Color(0, 0, 0, 220)

	function HUDELEMENT:DrawBg(x, y, w, h, c)
		DrawHUDElementBg(x, y, w, h, c)
	end

	function HUDELEMENT:DrawLines(x, y, w, h, a)
		DrawHUDElementLines(x, y, w, h, a)
	end

	-- x, y, width, height, color, progress, text
	function HUDELEMENT:DrawBar(x, y, w, h, c, p, t)
		surface.SetDrawColor(clr(c))
		surface.DrawRect(x, y, w, h)

		local w2 = math.Round(w * (p or 1))

		surface.SetDrawColor(0, 0, 0, 165)
		surface.DrawRect(x + w2, y, w - w2, h)

		-- draw lines around this bar
		self:DrawLines(x, y, w, h)

		-- draw text
		self:ShadowedText(t or "", "PureSkinBar", x + 14, y + 1, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end

	function HUDELEMENT:ShadowedText(text, font, x, y, color, xalign, yalign)
		draw.SimpleText(text, font, x + 2, y + 2, shadowColor, xalign, yalign)
		draw.SimpleText(text, font, x, y, color, xalign, yalign)
	end

	HUDELEMENT.roundstate_string = {
		[ROUND_WAIT] = "round_wait",
		[ROUND_PREP] = "round_prep",
		[ROUND_ACTIVE] = "round_active",
		[ROUND_POST] = "round_post"
	}

	HUDELEMENT.savingKeys = {
		pos = {typ = "pos"},
		size = {typ = "size"}
	}

	HUDELEMENT.basecolor = defaultColor

	function HUDELEMENT:Reset()
		self.basecolor = defaultColor

		local defaultPos = self.defaults.pos
		local defaultSize = self.defaults.size

		self:SetPos(defaultPos.x, defaultPos.y)
		self:SetSize(defaultSize.w, defaultSize.h)

		self:PerformLayout()
	end
end
