local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local GetLang = LANG.GetUnsafeLanguageTable

	local pad = 14 -- padding
	local lpw = 44 -- left panel width
	local sri_text_width_padding = 8 -- secondary role information padding (needed for size calculations)

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 365, h = 146},
		minsize = {w = 240, h = 146}
	}

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()
		self.pad = pad
		self.lpw = lpw
		self.sri_text_width_padding = sri_text_width_padding
		--self.secondaryRoleInformationFunc = nil

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, true
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = 10 * self.scale, y = ScrH() - (10 * self.scale + self.size.h)}

		return const_defaults
	end

	function HUDELEMENT:PerformLayout()
		local defaults = self:GetDefaults()

		self.basecolor = self:GetHUDBasecolor()
		self.scale = math.min(self.size.w / defaults.minsize.w, self.size.h / defaults.minsize.h)
		self.lpw = lpw * self.scale
		self.pad = pad * self.scale
		self.sri_text_width_padding = sri_text_width_padding * self.scale

		BaseClass.PerformLayout(self)
	end

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

	--[[
		This function expects to receive a function as a parameter which later returns a table with the following keys: { text: "", color: Color }
		The function should also take care of managing the visibility by returning nil to tell the UI that nothing should be displayed
	]]--
	function HUDELEMENT:SetSecondaryRoleInfoFunction(func)
		if func and isfunction(func) then
			self.secondaryRoleInformationFunc = func
		end
	end

	local watching_icon = Material("vgui/ttt/watching_icon")
	local credits_default = Material("vgui/ttt/equip/credits_default")
	local credits_zero = Material("vgui/ttt/equip/credits_zero")

	local icon_armor = Material("vgui/ttt/hud_armor.vmt")
	local icon_armor_rei = Material("vgui/ttt/hud_armor_reinforced.vmt")

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local calive = client:Alive() and client:IsTerror()
		local cactive = client:IsActive()
		local L = GetLang()

		local x2, y2, w2, h2 = self.pos.x, self.pos.y, self.size.w, self.size.h

		if not calive then
			y2 = y2 + h2 - self.lpw
			h2 = self.lpw
		end

		-- draw bg and shadow
		self:DrawBg(x2, y2, w2, h2, self.basecolor)

		-- draw left panel
		local c

		if cactive then
			c = client:GetRoleColor()
		else
			c = Color(100, 100, 100, 200)
		end

		surface.SetDrawColor(clr(c))
		surface.DrawRect(x2, y2, self.lpw, h2)

		local ry = y2 + self.lpw * 0.5
		local ty = y2 + self.lpw + self.pad -- new y
		local nx = x2 + self.lpw + self.pad -- new x

		-- draw role icon
		local rd = client:GetSubRoleData()
		if rd then
			local tgt = client:GetObserverTarget()

			if cactive then
				local icon = Material("vgui/ttt/dynamic/roles/icon_" .. rd.abbr)
				if icon then
					util.DrawFilteredTexturedRect(x2 + 4, y2 + 4, self.lpw - 8, self.lpw - 8, icon)
				end
			elseif IsValid(tgt) and tgt:IsPlayer() then
				util.DrawFilteredTexturedRect(x2 + 4, y2 + 4, self.lpw - 8, self.lpw - 8, watching_icon)
			end

			-- draw role string name
			local text
			local round_state = GAMEMODE.round_state

			if cactive then
				text = L[rd.name]
			else
				if IsValid(tgt) and tgt:IsPlayer() then
					text = tgt:Nick()
				else
					text = L[self.roundstate_string[round_state]]
				end
			end

			--calculate the scale multplier for role text
			surface.SetFont("PureSkinRole")

			local role_text_width = surface.GetTextSize(string.upper(text)) * self.scale
			local role_scale_multiplier = (self.size.w - self.lpw - 2 * self.pad) / role_text_width

			if calive and cactive and isfunction(self.secondaryRoleInformationFunc) then
				local secInfoTbl = self.secondaryRoleInformationFunc()

				if secInfoTbl and secInfoTbl.text then
					surface.SetFont("PureSkinBar")

					local sri_text_width = surface.GetTextSize(string.upper(secInfoTbl.text)) * self.scale

					role_scale_multiplier = (self.size.w - sri_text_width - self.lpw - 2 * self.pad - 3 * self.sri_text_width_padding) / role_text_width
				end
			end

			role_scale_multiplier = math.Clamp(role_scale_multiplier, 0.55, 0.85) * self.scale

			draw.AdvancedText(string.upper(text), "PureSkinRole", nx, ry, self:GetDefaultFontColor(self.basecolor), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, Vector(role_scale_multiplier * 0.9, role_scale_multiplier, role_scale_multiplier))
		end

		-- player informations
		if calive then

			-- draw secondary role information
			if cactive and isfunction(self.secondaryRoleInformationFunc) then
				local secInfoTbl = self.secondaryRoleInformationFunc()

				if secInfoTbl and secInfoTbl.color and secInfoTbl.text then
					surface.SetFont("PureSkinBar")

					local sri_text_caps = string.upper(secInfoTbl.text)
					local sri_text_width = surface.GetTextSize(sri_text_caps) * self.scale
					local sri_margin_top_bottom = 8 * self.scale
					local sri_width = sri_text_width + self.sri_text_width_padding * 2
					local sri_xoffset = w2 - sri_width - self.pad

					local nx2 = x2 + sri_xoffset
					local ny = y2 + sri_margin_top_bottom
					local nh = self.lpw - sri_margin_top_bottom * 2

					surface.SetDrawColor(clr(secInfoTbl.color))
					surface.DrawRect(nx2, ny, sri_width, nh)

					draw.AdvancedText(sri_text_caps, "PureSkinBar", nx2 + sri_width * 0.5, ry, self:GetDefaultFontColor(secInfoTbl.color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

					-- draw lines around the element
					self:DrawLines(nx2, ny, sri_width, nh, secInfoTbl.color.a)
				end
			end

			-- draw dark bottom overlay
			surface.SetDrawColor(0, 0, 0, 90)
			surface.DrawRect(x2, y2 + self.lpw, w2, h2 - self.lpw)

			-- draw bars
			local bw = w2 - self.lpw - self.pad * 2 -- bar width
			local bh = 26 * self.scale --  bar height
			local sbh = 8 * self.scale -- spring bar height
			local spc = 7 * self.scale -- space between bars

			-- health bar
			local health = math.max(0, client:Health())
			local health_print = tostring(health)

			local armor = math.max(0, client:Armor())
			local armor_print = tostring(armor)

			self:DrawBar(nx, ty, bw, bh, Color(234, 41, 41), health / client:GetMaxHealth(), self.scale, "HEALTH: " .. health_print)

			-- draw armor information
			if not GetGlobalBool("ttt_armor_classic", false) and armor > 0 then				
				local icon_mat = client:ArmorIsReinforced() and icon_armor_rei or icon_armor
				
				local a_size = bh - math.Round(11 * self.scale)
				local a_pad = math.Round(5 * self.scale)

				local a_pos_y = ty + math.Round(5 * self.scale)
				local a_pos_x = nx + bw - math.Round(65 * self.scale)

				local at_pos_y = ty + 1
				local at_pos_x = a_pos_x + a_size + a_pad

				util.DrawFilteredTexturedRect(a_pos_x + math.Round(2*self.scale), a_pos_y + math.Round(2*self.scale), a_size, a_size, icon_mat, 200, {r=0, g=0, b=0})
				util.DrawFilteredTexturedRect(a_pos_x + math.Round(self.scale), a_pos_y + math.Round(self.scale), a_size, a_size, icon_mat, 255, {r=0, g=0, b=0})
				util.DrawFilteredTexturedRect(a_pos_x, a_pos_y, a_size, a_size, icon_mat, 255, {r=255, g=255, b=255})
				
				draw.AdvancedText(armor_print, "PureSkinBar", at_pos_x, at_pos_y, self:GetDefaultFontColor(Color(234, 41, 41)), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, true, self.scale)
			end

			-- ammo bar
			ty = ty + bh + spc

			-- Draw ammo
			if client:GetActiveWeapon().Primary then
				local ammo_clip, ammo_max, ammo_inv = self:GetAmmo(client)

				if ammo_clip ~= -1 then
					local text = string.format("%i + %02i", ammo_clip, ammo_inv)

					self:DrawBar(nx, ty, bw, bh, Color(238, 151, 0), ammo_clip / ammo_max, self.scale, text)
				end
			end

			-- sprint bar
			ty = ty + bh + spc

			if GetGlobalBool("ttt2_sprint_enabled", true) then
				self:DrawBar(nx, ty, bw, sbh, Color(36, 154, 198), client.sprintProgress, self.scale, "")
			end

			-- coin info
			if cactive and client:IsShopper() then
				local coinSize = 24 * self.scale
				local x2_pad = math.Round((self.lpw - coinSize) * 0.5)

				if client:GetCredits() > 0 then
					util.DrawFilteredTexturedRect(x2 + x2_pad, y2 + self.size.h - coinSize - x2_pad, coinSize, coinSize, credits_default, 200)
				else
					util.DrawFilteredTexturedRect(x2 + x2_pad, y2 + self.size.h - coinSize - x2_pad, coinSize, coinSize, credits_zero, 100)
				end
			end
		end

		-- draw lines around the element
		self:DrawLines(x2, y2, w2, h2, self.basecolor.a)
	end
end
