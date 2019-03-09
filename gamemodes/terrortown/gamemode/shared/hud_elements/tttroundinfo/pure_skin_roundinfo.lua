local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

HUDELEMENT.togglable = true

if CLIENT then
	local GetLang = LANG.GetUnsafeLanguageTable

	local w_default, h_default = 96, 72
	local pad_default = 14

	local x, y = 0, 0
	local w, h = w_default, h_default
	local pad = pad_default -- padding

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 96, h = 72},
						minsize = {w = 96, h = 72}
	}

	function HUDELEMENT:Initialize()
		w, h = w_default, h_default
		pad = pad_default
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		local defaults = self:GetDefaults()

		self.disabledUnlessForced = true
		
		self:SetBasePos(defaults.basepos.x, defaults.basepos.y)
		self:SetMinSize(defaults.size.w, defaults.size.h)
		self:SetSize(defaults.minsize.w, defaults.minsize.h)

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, true
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = { x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = 4 * self.scale}
		return const_defaults
 	end

	function HUDELEMENT:PerformLayout()
		local pos = self:GetPos()
		local size = self:GetSize()
		self.scale = math.min(size.w / w_default, size.h / h_default)
		self.basecolor = self:GetHUDBasecolor()

		x, y = pos.x, pos.y
		w, h = size.w, size.h
		pad = pad_default * self.scale

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

		local vert_align_clock = TEXT_ALIGN_TOP

		-- Time displays differently depending on whether haste mode is on,
		-- whether the player is traitor or not, and whether it is overtime.
		if is_haste then
			local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
			if hastetime < 0 then
				if not is_traitor or math.ceil(CurTime()) % 7 <= 2 then
					-- innocent or blinking "overtime"
					text = L.overtime
					font = "PureSkinMSTACKMsg"

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
			vert_align_clock = TEXT_ALIGN_CENTER
			
			-- bog standard time when haste mode is off (or round not active)
			text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
		end
		
		self:AdvancedText(text, font, rx, ry, color, TEXT_ALIGN_CENTER, vert_align_clock, true, self.scale)

		if is_haste then
			self:AdvancedText(L.hastemode, "PureSkinMSTACKMsg", tmpx, y + pad, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, true, self.scale)
		end

		-- draw lines around the element
		local border_pos, border_size = self:GetBorderParams()
		self:DrawLines(border_pos.x, border_pos.y, border_size.w, border_size.h, self.basecolor.a)
	end
end
