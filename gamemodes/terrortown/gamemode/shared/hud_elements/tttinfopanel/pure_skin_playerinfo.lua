local base = "pure_skin_element"

HUDELEMENT.Base = base

if CLIENT then
	local GetLang = LANG.GetUnsafeLanguageTable

	local x = 0
	local y = 0

	local w = 365 -- width
	local h = 146 -- height
	local pad = 14 -- padding
	local lpw = 44 -- left panel width
	local sri_text_width_padding = 8 --secondary role information padding (needed for size calculations)

	local secondaryRoleInformationFunc = nil

	function HUDELEMENT:Initialize()
		self:SetPos(10, ScrH() - (10 + h))
		self:SetSize(w, h)
	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		local size = self:GetSize()

		x = pos.x
		y = pos.y
		w = size.w
		h = size.h

		local bclass = baseclass.Get(base)

		bclass.PerformLayout(self)
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
		local calive = client:Alive() and client:IsTerror()
		local cactive = client:IsActive()
		local L = GetLang()

		local x2, y2, w2, h2 = x, y, w, h

		if not calive then
			y2 = y2 + h2 - lpw
			h2 = lpw
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
		surface.DrawRect(x2, y2, lpw, h2)

		local ry = y2 + lpw * 0.5
		local ty = y2 + lpw + pad -- new y
		local nx = x2 + lpw + pad -- new x

		-- draw role icon
		local rd = client:GetSubRoleData()
		if rd then
			if cactive then
				local icon = Material("vgui/ttt/dynamic/roles/icon_" .. rd.abbr)
				if icon then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(icon)
					surface.DrawTexturedRect(x2 + 4, y2 + 4, lpw - 8, lpw - 8)
				end
			end

			-- draw role string name
			local text
			local round_state = GAMEMODE.round_state

			if cactive then
				text = L[rd.name]
			else
				text = L[self.roundstate_string[round_state]]
			end

			--calculate the scale multplier for role text
			surface.SetFont("PureSkinRole")
			local role_text_width = surface.GetTextSize(string.upper(text))
			local role_scale_multiplier = (w - lpw - 2 * pad) / role_text_width
			if calive and cactive and isfunction(secondaryRoleInformationFunc) then
				local secInfoTbl = secondaryRoleInformationFunc()

				if secInfoTbl and secInfoTbl.text then
					surface.SetFont("PureSkinBar")
					local sri_text_width = surface.GetTextSize(string.upper(secInfoTbl.text))
					role_scale_multiplier = (w - sri_text_width - lpw - 2 * pad - 3 * sri_text_width_padding) / role_text_width
				end
			end

			role_scale_multiplier = math.Clamp(role_scale_multiplier, 0.55, 0.92)


			--create scaling matrix for the text
			local mat = Matrix()
			mat:Translate( Vector( nx, ry ) )
			mat:Scale( Vector( role_scale_multiplier, role_scale_multiplier, role_scale_multiplier ) )
			mat:Translate( -Vector( nx, ry ) )

			render.PushFilterMag( TEXFILTER.ANISOTROPIC )
			render.PushFilterMin( TEXFILTER.ANISOTROPIC )
			cam.PushModelMatrix( mat )
				self:ShadowedText(string.upper(text), "PureSkinRole", nx, ry, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			cam.PopModelMatrix( mat )
			render.PopFilterMag()
			render.PopFilterMin()
		end

		-- player informations
		if calive then

			-- draw secondary role information
			if cactive and isfunction(secondaryRoleInformationFunc) then
				local secInfoTbl = secondaryRoleInformationFunc()

				if secInfoTbl and secInfoTbl.color and secInfoTbl.text then
					surface.SetFont("PureSkinBar")
					local sri_text_caps = string.upper(secInfoTbl.text)
					local sri_text_width = surface.GetTextSize(sri_text_caps)
					local sri_margin_top_bottom = 8
					local sri_width = sri_text_width + sri_text_width_padding * 2
					local sri_xoffset = w2 - sri_width - pad

					local nx2 = x2 + sri_xoffset
					local ny = y2 + sri_margin_top_bottom
					local nh = lpw - sri_margin_top_bottom * 2

					surface.SetDrawColor(clr(secInfoTbl.color))
					surface.DrawRect(nx2, ny, sri_width, nh)

					self:ShadowedText(sri_text_caps, "PureSkinBar", nx2 + sri_width * 0.5, ry, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					-- draw lines around the element
					self:DrawLines(nx2, ny, sri_width, nh)
				end
			end

			-- draw dark bottom overlay
			surface.SetDrawColor(0, 0, 0, 90)
			surface.DrawRect(x2, y2 + lpw, w2, h2 - lpw)

			-- draw bars
			local bw = w2 - lpw - pad * 2 -- bar width
			local bh = 26 --  bar height
			local sbh = 8 -- spring bar height
			local spc = 7 -- space between bars

			-- health bar
			local health = math.max(0, client:Health())

			self:DrawBar(nx, ty, bw, bh, Color(234, 41, 41), health / client:GetMaxHealth(), "HEALTH: " .. health)

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
		end

		-- draw lines around the element
		self:DrawLines(x2, y2, w2, h2)
	end
end
