HUDELEMENT.Base = "pure_skin_element"

if CLIENT then
	local GetLang = LANG.GetUnsafeLanguageTable

	local x = 0
	local y = 0

	local w = 365 -- width
	local h = 146 -- height
	local pad = 14 -- padding

	local secondaryRoleInformationFunc = nil

	function HUDELEMENT:Initialize()
		self:SetPos(10, ScrH() - (10 + h))
		self:PerformLayout()
	end

	function HUDELEMENT:PerformLayout()
		x = self.pos.x
		y = self.pos.y
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
			secondaryRoleInformationFunc = func
		end
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local L = GetLang()
		local round_state = GAMEMODE.round_state

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)

		-- draw left panel
		local c

		if round_state == ROUND_ACTIVE then
			c = LocalPlayer():GetRoleColor()
		else
			c = Color(100, 100, 100, 200)
		end

		local lpw = 44 -- left panel width

		surface.SetDrawColor(clr(c))
		surface.DrawRect(x, y, lpw, h)

		-- draw role icon
		local rd = client:GetSubRoleData()
		if rd then
			if round_state == ROUND_ACTIVE then
				local icon = Material("vgui/ttt/dynamic/roles/icon_" .. rd.abbr)
				if icon then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(icon)
					surface.DrawTexturedRect(x, y, lpw, lpw)
				end
			end

			-- draw role string name
			local text

			if round_state == ROUND_ACTIVE then
				text = L[rd.name]
			else
				text = L[self.roundstate_string[round_state]]
			end

			self:ShadowedText(text, "PureSkinRole", x + lpw + pad, y + pad, COLOR_WHITE, TEXT_ALIGN_LEFT)
		end

		-- draw secondary role information
		if round_state == ROUND_ACTIVE and secondaryRoleInformationFunc then
			local secInfoTbl = secondaryRoleInformationFunc()

			if secInfoTbl and secInfoTbl.color and secInfoTbl.text then
				local sri_text_width, sri_text_height = surface.GetTextSize(secInfoTbl.text)
				local sri_padding_inner_top_bottom = 0
				local sri_text_width_padding = 20
				local sri_margin_top_bottom = 6
				local sri_margin_right = 16
				local sri_width = sri_text_width + sri_text_width_padding * 2
				local sri_xoffset = w - sri_width - sri_margin_right

				surface.SetDrawColor(clr(secInfoTbl.color))
				surface.DrawRect(x + sri_xoffset, y + sri_margin_top_bottom, sri_width, lpw - sri_margin_top_bottom * 2)
				self:ShadowedText(secInfoTbl.text, "PureSkinRole", x + sri_xoffset + sri_text_width_padding, y + sri_margin_top_bottom + sri_padding_inner_top_bottom + sri_text_height, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end

		-- draw dark bottom overlay
		surface.SetDrawColor(0, 0, 0, 90)
		surface.DrawRect(x, y + lpw, w, h - lpw)

		-- draw bars
		local ty = y + lpw + pad -- new y
		local nx = x + lpw + pad -- new x
		local bw = w - lpw - pad * 2 -- bar width
		local bh = 26 --  bar height
		local sbh = 8 -- spring bar height
		local spc = 7 -- space between bars

		-- health bar
		local health = math.max(0, client:Health())

		self:DrawBar(nx, ty, bw, bh, Color(212, 68, 5), health / client:GetMaxHealth(), "Health: " .. health)

		-- ammo bar
		ty = ty + bh + spc

		-- Draw ammo
		if client:GetActiveWeapon().Primary then
			local ammo_clip, ammo_max, ammo_inv = self:GetAmmo(client)

			if ammo_clip ~= -1 then
				local text = string.format("%i + %02i", ammo_clip, ammo_inv)

				self:DrawBar(nx, ty, bw, bh, Color(238, 151, 0), ammo_clip / ammo_max, text)
			end
		end

		-- sprint bar
		ty = ty + bh + spc

		if GetGlobalBool("ttt2_sprint_enabled", true) then
			self:DrawBar(nx, ty, bw, sbh, Color(36, 154, 198), client.sprintProgress)
		end

		-- draw lines around the element
		self:DrawLines(x, y, w, h)
	end
end
