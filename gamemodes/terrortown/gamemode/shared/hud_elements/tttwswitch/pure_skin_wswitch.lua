local draw = draw
local surface = surface
local IsValid = IsValid
local TryTranslation = LANG.TryTranslation

HUDELEMENT.Base = "pure_skin_element"

if CLIENT then
	HUDELEMENT.margin = 5
	HUDELEMENT.width = 365
	HUDELEMENT.height = 28
	HUDELEMENT.lpw = 22 -- left panel width

	-- Draw a bar in the style of the the weapon pickup ones

	-- color defines
	HUDELEMENT.col_active = {
		text_empty = Color(200, 20, 20, 255),
		text = Color(255, 255, 255, 255),
		shadow = 255
	}

	HUDELEMENT.col_dark = {
		text_empty = Color(200, 20, 20, 100),
		text = Color(255, 255, 255, 100),
		shadow = 100
	}

	function HUDELEMENT:DrawBarBg(x, y, w, h, col)
		local ply = LocalPlayer()
		local c = (col == self.col_active and ply:GetRoleColor() or ply:GetRoleDkColor()) or Color(100, 100, 100)

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)

		if col == self.col_active then
			surface.SetDrawColor(0, 0, 0, 90)
			surface.DrawRect(x, y, w, h)
		end

		-- Draw the colour tip
		surface.SetDrawColor(c.r, c.g, c.b, c.a)
		surface.DrawRect(x, y, self.lpw, h)

		-- draw lines around the element
		self:DrawLines(x, y, w, h)
	end

	function HUDELEMENT:DrawWeapon(x, y, c, wep)
		if not IsValid(wep) then
			return false
		end

		local name = TryTranslation(wep:GetPrintName() or wep.PrintName or "...")
		local cl1, am1 = wep:Clip1(), (wep.Ammo1 and wep:Ammo1() or false)
		local ammo = false

		-- Clip1 will be -1 if a melee weapon
		-- Ammo1 will be false if weapon has no owner (was just dropped)
		if cl1 ~= -1 and am1 ~= false then
			ammo = Format("%i + %02i", cl1, am1)
		end

		-- Slot
		local _tmp = {x + self.lpw * 0.5, y + self.height * 0.5}
		local spec = {
			text = wep.Slot + 1,
			font = "Trebuchet22",
			pos = _tmp,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			color = c.text
		}

		draw.TextShadow(spec, 1, c.shadow)

		-- Name
		spec.text = name
		spec.font = "PureSkinWep"
		spec.pos[1] = x + 10 + self.height
		spec.xalign = nil

		draw.Text(spec)

		if ammo then
			local col = (wep:Clip1() == 0 and wep:Ammo1() == 0) and c.text_empty or c.text

			-- Ammo
			spec.text = ammo
			spec.pos[1] = ScrW() - self.margin * 3
			spec.xalign = TEXT_ALIGN_RIGHT
			spec.color = col

			draw.Text(spec)
		end

		return true
	end

	function HUDELEMENT:Draw(client)
		if not WSWITCH.Show then return end

		local weps = WSWITCH.WeaponCache

		local x = ScrW() - self.width - self.margin * 2
		local y = ScrH() - #weps * (self.height + self.margin) - self.margin

		local col = self.col_dark

		for k, wep in ipairs(weps) do
			if WSWITCH.Selected == k then
				col = self.col_active
			else
				col = self.col_dark
			end

			self:DrawBarBg(x, y, self.width, self.height, col)

			if not self:DrawWeapon(x, y, col, wep) then
				WSWITCH:UpdateWeaponCache()

				return
			end

			y = y + self.height + self.margin
		end
	end
end
