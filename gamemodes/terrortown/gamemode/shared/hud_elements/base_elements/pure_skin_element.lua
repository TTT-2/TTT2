---
-- @class HUDELEMENT
-- @section pure_skin_element

local surface = surface

local base = "dynamic_hud_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	---
	-- Draws the main background
	-- @param number x
	-- @param number y
	-- @param number w width
	-- @param number h height
	-- @param Color c color
	-- @realm client
	function HUDELEMENT:DrawBg(x, y, w, h, c)
		DrawHUDElementBg(x, y, w, h, c)
	end

	---
	-- Draws the shadow effect
	-- @param number x
	-- @param number y
	-- @param number w width
	-- @param number h height
	-- @param number a alpha of line's color
	-- @realm client
	function HUDELEMENT:DrawLines(x, y, w, h, a)
		DrawHUDElementLines(x, y, w, h, a or 255)
	end

	---
	-- Draws the main background
	-- @param number x
	-- @param number y
	-- @param number w width
	-- @param number h height
	-- @param Color c color
	-- @param number p progress
	-- @param number s scale
	-- @param string t text
	-- @realm client
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
			draw.AdvancedText(t, "PureSkinBar", x + 14, y + 1, util.GetDefaultColor(c), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, true, s)
		end
	end

	---
	-- Returns @{Color} white OR black based on the bgcolor
	-- @param Color bgcolor background color
	-- @realm client
	-- @deprecated
	-- @see util.GetDefaultColor
	function HUDELEMENT:GetDefaultFontColor(bgcolor)
		return util.GetDefaultColor(bgcolor)
	end

	HUDELEMENT.roundstate_string = {
		[ROUND_WAIT] = "round_wait",
		[ROUND_PREP] = "round_prep",
		[ROUND_ACTIVE] = "round_active",
		[ROUND_POST] = "round_post"
	}
end
