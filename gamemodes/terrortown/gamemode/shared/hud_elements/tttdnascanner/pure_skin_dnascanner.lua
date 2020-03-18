local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local pad = 14

	local drowning_color = Color(36, 154, 198)

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 321, h = 100},
		minsize = {w = 75, h = 100}
	}

	function HUDELEMENT:Initialize()
		self.scale = 1
		self.pad = pad
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = ScrH() - self.pad - self.size.h}

		return const_defaults
	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return HUDEditor.IsEditing or IsValid(client:GetActiveWeapon()) and client:GetActiveWeapon():GetClass() == "weapon_ttt_wtester"
	end

	function HUDELEMENT:PerformLayout()
		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()
		self.pad = pad * self.scale

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:DrawMarker(x, y, size, thickness, color)	
		local margin = 3
		local marker_x = x - margin - thickness
		local marker_y = y - margin - thickness
		local marker_size = size + margin * 2 + thickness * 2
		
		surface.SetDrawColor(color)
		for i=0, thickness - 1 do
			surface.DrawOutlinedRect( marker_x + i, marker_y + i, marker_size - i * 2, marker_size - i * 2 )
		end
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local w, h = size.w, size.h
		local scanner = client:GetWeapon("weapon_ttt_wtester")
		local chargeAmount =  HUDEditor.IsEditing and 1 or scanner:GetCharge() / scanner.MAX_CHARGE

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)

		local tmp_x = x + self.pad
		local tmp_y = y + self.pad
		local icon_size = 64 * self.scale

		if not HUDEditor.IsEditing then
			-- self:DrawBar(x + self.pad, y + self.pad, w - self.pad * 2, h - self.pad * 2, drowning_color, chargeAmount, 1)
			for i = 1, scanner.MAX_ITEM do
				local identifier = string.char(64 + i)
				
				if not scanner.ItemSamples[i] then
					surface.SetDrawColor(50, 50, 50, 255)
				else
					surface.SetDrawColor(self.basecolor)
				end
				surface.DrawRect(tmp_x, tmp_y, icon_size, icon_size)

				draw.AdvancedText(identifier, "PureSkinRole", tmp_x + icon_size * 0.5, tmp_y + icon_size * 0.5, COLOR_BLACK, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

				self:DrawLines(tmp_x, tmp_y, icon_size, icon_size, 255)

				if scanner.ActiveSample == i then
					self:DrawMarker(tmp_x, tmp_y, icon_size, 2, COLOR_WHITE)
				end

				tmp_x = tmp_x + self.pad + icon_size
			end
		end

		-- draw lines around the element
		self:DrawLines(x, y, w, h, self.basecolor.a)
	end
end
