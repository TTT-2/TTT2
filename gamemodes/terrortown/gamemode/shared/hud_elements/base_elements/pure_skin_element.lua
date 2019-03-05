local base = "hud_element_base"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local defaultColor = Color(49, 71, 94)
	local shadowColor = Color(0, 0, 0, 200)

	function HUDELEMENT:DrawBg(x, y, w, h, c)
		DrawHUDElementBg(x, y, w, h, c)
	end

	function HUDELEMENT:DrawLines(x, y, w, h, a)
		a = a or 255

		DrawHUDElementLines(x, y, w, h, a)
	end

	-- x, y, width, height, color, progress, scale, text
	function HUDELEMENT:DrawBar(x, y, w, h, c, p, s, t)
		s = s or 1

		surface.SetDrawColor(clr(c))
		surface.DrawRect(x, y, w, h)

		local w2 = math.Round(w * (p or 1))

		surface.SetDrawColor(0, 0, 0, 165)
		surface.DrawRect(x + w2, y, w - w2, h)

		-- draw lines around this bar
		self:DrawLines(x, y, w, h, c.a)

		-- draw text
		if t then
			self:AdvancedText(t, "PureSkinBar", x + 14, y + 1, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, true, s)
		end
	end

	function HUDELEMENT:ShadowedText(text, font, x, y, color, xalign, yalign)
		local tmpCol = Color(shadowColor.r, shadowColor.g, shadowColor.b, color.a)

		draw.SimpleText(text, font, x + 2, y + 2, tmpCol, xalign, yalign)
		draw.SimpleText(text, font, x + 1, y + 1, tmpCol, xalign, yalign)
		draw.SimpleText(text, font, x, y, color, xalign, yalign)
	end

	function HUDELEMENT:AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
		local mat
		if isvector(scale) or scale ~= 1.0 then
			mat = Matrix()
			mat:Translate(Vector(x, y))
			mat:Scale(isvector(scale) and scale or Vector(scale, scale, scale))
			mat:Translate(-Vector(ScrW() / 2, ScrH() / 2))

			render.PushFilterMag(TEXFILTER.ANISOTROPIC)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)

			cam.PushModelMatrix(mat)

			x = ScrW() / 2
			y = ScrH() / 2
		end

		if shadow then
			self:ShadowedText(text, font, x, y, color, xalign, yalign)
		else
			draw.SimpleText(text, font, x, y, color, xalign, yalign)
		end

		if isvector(scale) or scale ~= 1.0 then
			cam.PopModelMatrix(mat)

			render.PopFilterMag()
			render.PopFilterMin()
		end
	end

	HUDELEMENT.roundstate_string = {
		[ROUND_WAIT] = "round_wait",
		[ROUND_PREP] = "round_prep",
		[ROUND_ACTIVE] = "round_active",
		[ROUND_POST] = "round_post"
	}

	HUDELEMENT.basecolor = defaultColor

	function HUDELEMENT:Reset()
		self.basecolor = defaultColor

		BaseClass.Reset(self)
	end
end
