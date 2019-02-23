HUDELEMENT.Base = "pure_skin_element"

if CLIENT then
	local GetLang = LANG.GetUnsafeLanguageTable

	local x = 0
	local y = 0

	local w = 168 -- width
	local h = 72 -- height
	local pad = 14 -- padding

	function HUDELEMENT:Initialize()
		self:SetPos(math.Round(ScrW() * 0.5 - w * 0.5), 4)
		self:SetSize(w, h)
	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		local size = self:GetSize()

		x = pos.x
		y = pos.y
		w = size.w
		h = size.h

		local bclass = baseclass.Get("pure_skin_element")

		bclass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local L = GetLang()
		local round_state = GAMEMODE.round_state

		local x2, y2, w2, h2 = x, y, w, h -- caching

		local iconSize = h2 - pad * 2
		local mpw = w2 - h2 -- mid panel width
		local c -- icon color
		local icon -- team icon

		-- draw team icon
		local team = client:GetTeam()
		local tm = TEAMS[team]

		if round_state == ROUND_ACTIVE and team ~= TEAM_NONE and tm and not tm.alone then
			icon = Material(tm.icon)
			c = tm.color or Color(0, 0, 0, 255)
		end

		if not c then
			x2 = x2 + h2
			w2 = mpw
		end

		-- draw bg and shadow
		self:DrawBg(x2, y2, w2, h2, self.basecolor)

		if c then
			surface.SetDrawColor(0, 0, 0, 90)
			surface.DrawRect(x2, y2, h2, h2)

			surface.SetDrawColor(clr(c))
			surface.DrawRect(x2 + pad, y2 + pad, iconSize, iconSize)

			if icon then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(icon)
				surface.DrawTexturedRect(x2 + pad, y2 + pad, iconSize, iconSize)
			end

			-- draw lines around the element
			self:DrawLines(x2 + pad, y2 + pad, iconSize, iconSize)
		end

		-- draw haste / time
		-- Draw round time
		local is_haste = HasteMode() and round_state == ROUND_ACTIVE
		local is_traitor = client:IsActive() and client:HasTeam(TEAM_TRAITOR)
		local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()
		local font = "TimeLeft"
		local color = COLOR_WHITE

		local tmpx = (c and (x2 + h2) or x2) + mpw * 0.5
		local tmpy = y2 + h2 * 0.5

		local rx = tmpx
		local ry = tmpy

		-- Time displays differently depending on whether haste mode is on,
		-- whether the player is traitor or not, and whether it is overtime.
		if is_haste then
			local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
			if hastetime < 0 then
				if not is_traitor or math.ceil(CurTime()) % 7 <= 2 then
					-- innocent or blinking "overtime"
					text = L.overtime
					font = "Trebuchet18"

					-- need to hack the position a little because of the font switch
					ry = ry + 5
					rx = rx - 3
				else
					-- traitor and not blinking "overtime" right now, so standard endtime display
					text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
					color = COLOR_RED
				end
			else
				-- still in starting period
				local t = hastetime

				if is_traitor and math.ceil(CurTime()) % 6 < 2 then
					t = endtime
					color = COLOR_RED
				end

				text = util.SimpleTime(math.max(0, t), "%02i:%02i")
			end
		else
			-- bog standard time when haste mode is off (or round not active)
			text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
		end

		self:ShadowedText(text, font, rx, ry, color, TEXT_ALIGN_CENTER)

		if is_haste then
			draw.SimpleText(L.hastemode, "TabLarge", tmpx, y2 + 14, COLOR_WHITE, TEXT_ALIGN_CENTER)
		end

		-- draw lines around the element
		self:DrawLines(x2, y2, w2, h2)
	end
end
