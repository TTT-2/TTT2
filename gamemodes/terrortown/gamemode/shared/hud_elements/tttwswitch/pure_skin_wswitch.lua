local surface = surface
local IsValid = IsValid
local TryTranslation = LANG.TryTranslation

local base = "base_stacking_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	-- color defines
	local col_active = {
		text_empty = Color(200, 20, 20, 255),
		text = Color(255, 255, 255, 255),
		shadow = 255
	}

	local col_dark = {
		text_empty = Color(200, 20, 20, 100),
		text = Color(255, 255, 255, 100),
		shadow = 100
	}

	local element_height = 28
	local margin = 5
	local lpw = 22 -- left panel width

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 365, h = 28},
						minsize = {w = 240, h = 28}
	}

	function HUDELEMENT:PreInitialize()
		self.drawer =  hudelements.GetStored("pure_skin_element")
	end

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()
		self.element_height = element_height
		self.margin = margin
		self.lpw = lpw

		WSWITCH:UpdateWeaponCache()

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = { x = ScrW() - (self.size.w + self.margin * 2), y = ScrH() - self.margin}
		return const_defaults
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:PerformLayout()
		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()
		self.element_height = element_height * self.scale
		self.margin = margin * self.scale
		self.lpw = lpw * self.scale

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:DrawBarBg(x, y, w, h, col)
		local ply = LocalPlayer()
		local c = (col == col_active and ply:GetRoleColor() or ply:GetRoleDkColor()) or Color(100, 100, 100)

		-- draw bg and shadow
		self.drawer:DrawBg(x, y, w, h, self.basecolor)

		if col == col_active then
			surface.SetDrawColor(0, 0, 0, 90)
			surface.DrawRect(x, y, w, h)
		end

		-- Draw the colour tip
		surface.SetDrawColor(c.r, c.g, c.b, c.a)
		surface.DrawRect(x, y, self.lpw, h)

		-- draw lines around the element
		self.drawer:DrawLines(x, y, w, h, self.basecolor.a)
	end

	function HUDELEMENT:DrawWeapon(x, y, c, wep)
		if not IsValid(wep) or not IsValid(wep.Owner) or not isfunction(wep.Owner.GetAmmoCount) then
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
		self.drawer:AdvancedText(MakeKindValid(wep.Kind), "PureSkinWepNum", x + self.lpw * 0.5, y + self.element_height * 0.5, c.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

		-- Name
		self.drawer:AdvancedText(string.upper(name), "PureSkinWep", x + 10 + self.element_height, y + self.element_height * 0.5, c.text, nil, TEXT_ALIGN_CENTER, true, self.scale)

		if ammo then
			local col = (wep:Clip1() == 0 and wep:Ammo1() == 0) and c.text_empty or c.text

			-- Ammo
			self.drawer:AdvancedText(tostring(ammo), "PureSkinWep", x + self.size.w - self.margin * 3, y + self.element_height * 0.5, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, false, self.scale)
		end

		return true
	end

	function HUDELEMENT:ShouldDraw()
		return HUDEditor.IsEditing or WSWITCH.Show
	end

	function HUDELEMENT:Draw()
		local weaponList = {}
		local weps = WSWITCH.WeaponCache
		for k, wep in ipairs(weps) do
			table.insert(weaponList, {h = self.element_height})
		end
		self:SetElements(weaponList)
		self:SetElementMargin(self.margin)

		BaseClass.Draw(self)
	end

	function HUDELEMENT:DrawElement(i, x, y, w, h)
		local col = col_dark
		if WSWITCH.Selected == i then
			col = col_active
		end
		self:DrawBarBg(x, y, w, h, col)

		if not self:DrawWeapon(x, y, col, WSWITCH.WeaponCache[i]) then
			WSWITCH:UpdateWeaponCache()
			return
		end

	end
end
