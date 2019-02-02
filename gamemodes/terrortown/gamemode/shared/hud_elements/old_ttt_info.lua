local draw = draw
local math = math
local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local util = util

HUDELEMENT.Base = "old_ttt_element"
HUDELEMENT.type = "TTTInfoPanel"

if CLIENT then
	local ttt_health_label = CreateClientConVar("ttt_health_label", "0", true)
	local hudTeamicon = CreateClientConVar("ttt2_base_hud_teamicon", "1")

	local x = 0
	local y = 0

	function HUDElement:Initialize()
		HUDELEMENT:SetPos(self.margin, self.margin + self.maxheight)
		self:PerformLayout()
	end

	function HUDELEMENT:PerformLayout()
		x = self.pos.x
		y = ScrH() - self.pos.y
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local L = GetLang()
		local maxwidth = self.maxwidth
		local width = maxwidth
		local height = maxheight
		local margin = self.margin


		self:DrawBg(x, y, width, height, client)

		local bar_height = 25
		local bar_width = width - self.dmargin

		-- Draw health
		local health = math.max(0, client:Health())
		local health_y = y + margin

		self:PaintBar(x + margin, health_y, bar_width, bar_height, self.health_colors, health / client:GetMaxHealth())
		self:ShadowedText(tostring(health), "HealthAmmo", bar_width, health_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)

		if ttt_health_label:GetBool() then
			local health_status = util.HealthToString(health, client:GetMaxHealth())

			draw.SimpleText(L[health_status], "TabLarge", x + margin * 2, health_y + bar_height * 0.5, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		-- Draw ammo
		if client:GetActiveWeapon().Primary then
			local ammo_clip, ammo_max, ammo_inv = self:GetAmmo(client)
			if ammo_clip ~= -1 then
				local ammo_y = health_y + bar_height + margin
				local text = string.format("%i + %02i", ammo_clip, ammo_inv)

				self:PaintBar(x + margin, ammo_y, bar_width, bar_height, ammo_colors, ammo_clip / ammo_max)
				self:ShadowedText(text, "HealthAmmo", bar_width, ammo_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
			end
		end

		local hastewidth = self.hastewidth
		local bgheight = self.bgheight
		local smargin = self.smargin
		local tmp = width - hastewidth - (hudTeamicon:GetBool() and bgheight or 0) - smargin * 2

		-- Draw the current role
		local round_state = GAMEMODE.round_state
		local traitor_y = y - 30
		local text

		if round_state == ROUND_ACTIVE then
			text = L[client:GetSubRoleData().name]
		else
			text = L[roundstate_string[round_state]]
		end

		self:ShadowedText(text, "TraitorState", x + tmp * 0.5, traitor_y, COLOR_WHITE, TEXT_ALIGN_CENTER)

		-- Draw team icon
		if hudTeamicon:GetBool() then
			local team = client:GetTeam()

			if team ~= TEAM_NONE and round_state == ROUND_ACTIVE and not TEAMS[team].alone then
				local t = TEAMS[team]
				local icon = Material(t.icon)

				if icon then
					local c = t.color or Color(0, 0, 0, 255)
					local tx = x + tmp + smargin

					DrawOldRoleIcon(tx, traitor_y, bgheight, bgheight, icon, c)
				end
			end
		end

		-- Draw round time
		local is_haste = HasteMode() and round_state == ROUND_ACTIVE
		local is_traitor = client:IsActive() and client:HasTeam(TEAM_TRAITOR)
		local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()
		local font = "TimeLeft"
		local color = COLOR_WHITE

		tmp = width + x - hastewidth + smargin + hastewidth * 0.5

		local rx = tmp
		local ry = traitor_y + 3

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
			draw.SimpleText(L.hastemode, "TabLarge", tmp, traitor_y - 8, COLOR_WHITE, TEXT_ALIGN_CENTER)
		end
	end
end
