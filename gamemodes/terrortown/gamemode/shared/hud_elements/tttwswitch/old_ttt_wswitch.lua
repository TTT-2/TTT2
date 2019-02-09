local draw = draw
local surface = surface
local math = math
local IsValid = IsValid
local TryTranslation = LANG.TryTranslation

HUDELEMENT.Base = "old_ttt_element"

if CLIENT then
	local width = 300
	local height = 20

	HUDELEMENT.margin = 10
	HUDELEMENT.barcorner = surface.GetTextureID("gui/corner8")

	-- Draw a bar in the style of the the weapon pickup ones
	local round = math.Round

	-- color defines
	HUDELEMENT.col_active = {
		bg = Color(20, 20, 20, 250),
		text_empty = Color(200, 20, 20, 255),
		text = Color(255, 255, 255, 255),
		shadow = 255
	}

	HUDELEMENT.col_dark = {
		bg = Color(20, 20, 20, 200),
		text_empty = Color(200, 20, 20, 100),
		text = Color(255, 255, 255, 100),
		shadow = 100
	}

	function HUDELEMENT:DrawBarBg(x, y, w, h, col)
		local rx = round(x - 4)
		local ry = round(y - h * 0.5 - 4)
		local rw = round(w + 9)
		local rh = round(h + 8)

		local b = 8 -- bordersize
		local bh = b * 0.5

		local ply = LocalPlayer()
		local c = (col == self.col_active and ply:GetRoleColor() or ply:GetRoleDkColor()) or (col == self.col_active and INNOCENT.color or INNOCENT.dkcolor)

		-- Draw the colour tip
		surface.SetTexture(self.barcorner)

		surface.SetDrawColor(c.r, c.g, c.b, c.a)
		surface.DrawTexturedRectRotated(rx + bh, ry + bh, b, b, 0)
		surface.DrawTexturedRectRotated(rx + bh, ry + rh - bh, b, b, 90)
		surface.DrawRect(rx, ry + b, b, rh - b * 2)
		surface.DrawRect(rx + b, ry, h - 4, rh)

		-- Draw the remainder
		-- Could just draw a full roundedrect bg and overdraw it with the tip, but
		-- I don't have to do the hard work here anymore anyway
		c = col.bg

		surface.SetDrawColor(c.r, c.g, c.b, c.a)
		surface.DrawRect(rx + b + h - 4, ry, rw - (h - 4) - b * 2, rh)
		surface.DrawTexturedRectRotated(rx + rw - bh, ry + rh - bh, b, b, 180)
		surface.DrawTexturedRectRotated(rx + rw - bh, ry + bh, b, b, 270)
		surface.DrawRect(rx + rw - b, ry + b, b, rh - b * 2)
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
		local _tmp = {x + 4, y}
		local spec = {
			text = wep.Slot + 1,
			font = "Trebuchet22",
			pos = _tmp,
			yalign = TEXT_ALIGN_CENTER,
			color = c.text
		}

		draw.TextShadow(spec, 1, c.shadow)

		-- Name
		spec.text = name
		spec.font = "TimeLeft"
		spec.pos[1] = x + 10 + height

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

	local x = 0
	--local y = 0

	function HUDELEMENT:Initialize()
		local weps = WSWITCH.WeaponCache
		local count = #weps
		local h = count * (height + self.margin)

		LocalPlayer().oldWSWeps = count

		self:SetPos(ScrW() - (width + self.margin * 2), ScrH() - self.margin - h)
		self:SetSize(width, h)
	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		--local size = self:GetSize()

		x = pos.x
		y = pos.y
		--w = size.w
		--h = size.h

		self.BaseClass:PerformLayout()
	end

	function HUDELEMENT:Draw()
		if not WSWITCH.Show and not HUDManager.IsEditing then return end

		local client = LocalPlayer()
		local weps = WSWITCH.WeaponCache
		local count = #weps
		local tmp = height + self.margin
		local h = count * tmp
		local difH = client.oldWSWeps * tmp

		client.oldWSWeps = count

		y = y - (h - difH)

		self:SetPos(x, y)
		self:SetSize(width, h)

		local y_elem = y

		local col = self.col_dark

		for k, wep in ipairs(weps) do
			if WSWITCH.Selected == k then
				col = self.col_active
			else
				col = self.col_dark
			end

			self:DrawBarBg(x, y_elem, width, height, col)

			if not self:DrawWeapon(x, y_elem, col, wep) then
				WSWITCH:UpdateWeaponCache()

				return
			end

			y_elem = y_elem + height + self.margin
		end
	end
end
