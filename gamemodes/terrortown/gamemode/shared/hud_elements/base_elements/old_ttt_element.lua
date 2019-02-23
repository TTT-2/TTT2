local surface = surface
local draw = draw
local math = math

HUDELEMENT.Base = "hud_element_base"

if CLIENT then
	local hudWidth = CreateClientConVar("ttt2_base_hud_width", "0")
	local hudTeamicon = CreateClientConVar("ttt2_base_hud_teamicon", "1")

	-- Color presets
	HUDELEMENT.bg_colors = {
		background_main = Color(0, 0, 10, 200),
		noround = Color(100, 100, 100, 200)
	}

	HUDELEMENT.health_colors = {
		border = COLOR_WHITE,
		background = Color(100, 25, 25, 222),
		fill = Color(200, 50, 50, 250)
	}

	HUDELEMENT.ammo_colors = {
		border = COLOR_WHITE,
		background = Color(20, 20, 5, 222),
		fill = Color(205, 155, 0, 255)
	}

	HUDELEMENT.sprint_colors = {
		border = COLOR_WHITE,
		background = Color(10, 50, 73, 222),
		fill = Color(36, 154, 198, 255)
	}

	-- Modified RoundedBox
	HUDELEMENT.Tex_Corner8 = surface.GetTextureID("gui/corner8")

	---- The bar painting is loosely based on:
	---- http://wiki.garrysmod.com/?title=Creating_a_HUD
	function HUDELEMENT:RoundedMeter(bs, x, y, w, h, color)
		surface.SetDrawColor(clr(color))

		surface.DrawRect(x + bs, y, w - bs * 2, h)
		surface.DrawRect(x, y + bs, bs, h - bs * 2)

		surface.SetTexture(self.Tex_Corner8)
		surface.DrawTexturedRectRotated(x + bs * 0.5, y + bs * 0.5, bs, bs, 0)
		surface.DrawTexturedRectRotated(x + bs * 0.5, y + h - bs * 0.5, bs, bs, 90)

		if w > 14 then
			surface.DrawRect(x + w - bs, y + bs, bs, h - bs * 2)
			surface.DrawTexturedRectRotated(x + w - bs * 0.5, y + bs * 0.5, bs, bs, 270)
			surface.DrawTexturedRectRotated(x + w - bs * 0.5, y + h - bs * 0.5, bs, bs, 180)
		else
			surface.DrawRect(x + math.max(w - bs, bs), y, bs * 0.5, h)
		end
	end

	function HUDELEMENT:PaintBar(x, y, w, h, colors, value)
		-- Background
		-- slightly enlarged to make a subtle border
		draw.RoundedBox(8, x - 1, y - 1, w + 2, h + 2, colors.background)

		-- Fill
		local width = w * math.Clamp(value, 0, 1)

		if width > 0 then
			self:RoundedMeter(8, x, y, width, h, colors.fill)
		end
	end

	HUDELEMENT.roundstate_string = {
		[ROUND_WAIT] = "round_wait",
		[ROUND_PREP] = "round_prep",
		[ROUND_ACTIVE] = "round_active",
		[ROUND_POST] = "round_post"
	}

	HUDELEMENT.margin = 10
	HUDELEMENT.dmargin = HUDELEMENT.margin * 2
	HUDELEMENT.smargin = 2
	HUDELEMENT.maxheight = 90
	HUDELEMENT.maxwidth = hudWidth:GetInt() + HUDELEMENT.maxheight + HUDELEMENT.margin + 170
	HUDELEMENT.hastewidth = 80
	HUDELEMENT.bgheight = 30

	-- Returns player's ammo information
	function HUDELEMENT:GetAmmo(ply)
		local weap = ply:GetActiveWeapon()

		if not weap or not ply:Alive() then
			return - 1
		end

		local ammo_inv = weap.Ammo1 and weap:Ammo1() or 0
		local ammo_clip = weap:Clip1() or 0
		local ammo_max = weap.Primary.ClipSize or 0

		return ammo_clip, ammo_max, ammo_inv
	end

	function HUDELEMENT:DrawBg(x, y, width, height, client)
		-- Traitor area sizes
		local th = self.bgheight
		local tw = width - self.hastewidth - (hudTeamicon:GetBool() and self.bgheight or 0) - self.smargin * 2 -- bgheight = team icon

		-- Adjust for these
		y = y - th
		height = height + th

		-- main bg area, invariant
		-- encompasses entire area
		draw.RoundedBox(8, x, y, width, height, self.bg_colors.background_main)

		-- main border, role based
		local col = INNOCENT.color

		if GAMEMODE.round_state ~= ROUND_ACTIVE then
			col = self.bg_colors.noround
		elseif client:IsSpecial() then
			col = client:GetRoleColor()
		end

		draw.RoundedBox(8, x, y, tw, th, col)
	end

	function HUDELEMENT:ShadowedText(text, font, x, y, color, xalign, yalign)
		draw.SimpleText(text, font, x + 2, y + 2, COLOR_BLACK, xalign, yalign)
		draw.SimpleText(text, font, x, y, color, xalign, yalign)
	end
end
