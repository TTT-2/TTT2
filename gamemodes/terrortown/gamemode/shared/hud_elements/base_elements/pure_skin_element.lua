local base = "dynamic_hud_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	function HUDELEMENT:DrawBg(x, y, w, h, c)
		DrawHUDElementBg(x, y, w, h, c)
	end

	function HUDELEMENT:DrawLines(x, y, w, h, a)
		a = a or 255

		DrawHUDElementLines(x, y, w, h, a)
	end

	-- x, y, width, height, color, progress, scale, text, color2, progress2
	function HUDELEMENT:DrawBar(x, y, w, h, c, p, s, t)
		s = s or 1

		surface.SetDrawColor(clr(c))
		surface.DrawRect(x, y, w, h)

		local w_ = math.Round(w * (p or 1))

		surface.SetDrawColor(0, 0, 0, 165)
		surface.DrawRect(x + w_, y, w - w_, h)

		-- draw lines around this bar
		self:DrawLines(x, y, w, h, c.a)

		-- draw text
		if t then
			draw.AdvancedText(t, "PureSkinBar", x + 14, y + 1, self:GetDefaultFontColor(c), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, true, s)
		end
	end

	function HUDELEMENT:GetDefaultFontColor(bgcolor)
		local color = 0
		if bgcolor.r + bgcolor.g + bgcolor.b < 500 then
			return COLOR_WHITE
		else
			return COLOR_BLACK
		end
	end

	HUDELEMENT.roundstate_string = {
		[ROUND_WAIT] = "round_wait",
		[ROUND_PREP] = "round_prep",
		[ROUND_ACTIVE] = "round_active",
		[ROUND_POST] = "round_post"
	}
end
