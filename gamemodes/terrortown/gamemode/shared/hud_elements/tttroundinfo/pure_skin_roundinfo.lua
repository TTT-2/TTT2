local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local GetLang = LANG.GetUnsafeLanguageTable

	local x, y = 0, 0
	local w, h = 96, 72
	local pad = 14 -- padding

	function HUDELEMENT:Initialize()
		self:RecalculateBasePos()

		self.disabledUnlessForced = true

		self:SetSize(w, h)

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:RecalculateBasePos()
		self:SetBasePos(math.Round(ScrW() * 0.5 - w * 0.5), 4)
	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		local size = self:GetSize()

		x, y = pos.x, pos.y
		w, h = size.w, size.h

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local L = GetLang()
		local round_state = GAMEMODE.round_state

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)

		-- draw haste / time
		-- Draw round time
		local is_haste = HasteMode() and round_state == ROUND_ACTIVE
		local is_traitor = client:IsActive() and client:HasTeam(TEAM_TRAITOR)
		local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()
		local font = "TimeLeft"
		local color = COLOR_WHITE

		local tmpx = x + w * 0.5
		local tmpy = y + h * 0.5

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
			draw.SimpleText(L.hastemode, "TabLarge", tmpx, y + 14, COLOR_WHITE, TEXT_ALIGN_CENTER)
		end

		-- draw lines around the element
		self:DrawLines(x, y, w, h, self.basecolor.a)
	end
end
