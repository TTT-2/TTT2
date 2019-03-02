local draw = draw
local surface = surface
local IsValid = IsValid
local TryTranslation = LANG.TryTranslation

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local height_default = 28
	local margin_default = 5
	local lpw_default = 22

	local width = 365
	local height = height_default
	local min_w, min_h = 240, 28

	HUDELEMENT.margin = margin_default
	HUDELEMENT.lpw = lpw_default -- left panel width

	function HUDELEMENT:Initialize()
		WSWITCH:UpdateWeaponCache()

		self:RecalculateBasePos()
		self:SetSize(width, -height)
		self:SetMinSize(min_w, min_h)

		BaseClass.Initialize(self)

		self.defaults.resizeableY = false
		self.defaults.minHeight = height
	end

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
		self:DrawLines(x, y, w, h, self.basecolor.a)
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
		self:AdvancedText(tostring(wep.Slot + 1), "PureSkinWepNum", x + self.lpw * 0.5, y + height * 0.5, c.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

		-- Name
		self:AdvancedText(string.upper(name), "PureSkinWep", x + 10 + height, y + height * 0.5, c.text, nil, TEXT_ALIGN_CENTER, true, self.scale)

		if ammo then
			local col = (wep:Clip1() == 0 and wep:Ammo1() == 0) and c.text_empty or c.text

			-- Ammo
			self:AdvancedText(tostring(ammo), "PureSkinWep", x + width - self.margin * 3, y + height * 0.5, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, false, self.scale)
		end

		return true
	end

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

	function HUDELEMENT:RecalculateBasePos()
		self.margin = 5 * self.scale

		self:SetBasePos(ScrW() - (width + self.margin * 2), ScrH() - self.margin)
	end

	function HUDELEMENT:PerformLayout()
		local basepos = self:GetBasePos()

		self:SetPos(basepos.x, basepos.y)

		height = height_default * self.scale
		self.margin = margin_default * self.scale
		self.lpw = lpw_default * self.scale

		local weps = WSWITCH.WeaponCache
		local count = #weps
		local tmp = height + self.margin

		local h = math.max(count * tmp, self.defaults.minHeight)
		width = self:GetSize().w

		self:SetSize(width, -h)

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		if not WSWITCH.Show and not HUDManager.IsEditing then return end

		local client = LocalPlayer()
		local weps = WSWITCH.WeaponCache
		local count = #weps
		local tmp = height + self.margin
		local basepos = self:GetBasePos()
		local h = math.max(count * tmp, self.defaults.minHeight)

		self:SetPos(basepos.x, basepos.y)
		self:SetSize(width, -h)

		local pos = self:GetPos()
		local x_elem = pos.x
		local y_elem = pos.y
		local col = self.col_dark

		for k, wep in ipairs(weps) do
			if WSWITCH.Selected == k then
				col = self.col_active
			else
				col = self.col_dark
			end

			self:DrawBarBg(x_elem, y_elem, width, height, col)

			if not self:DrawWeapon(x_elem, y_elem, col, wep) then
				WSWITCH:UpdateWeaponCache()

				return
			end

			y_elem = y_elem + height + self.margin
		end
	end
end
