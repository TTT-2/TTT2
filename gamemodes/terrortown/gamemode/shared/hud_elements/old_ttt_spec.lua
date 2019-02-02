local math = math
local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp
local util = util
local IsValid = IsValid
local draw = draw

HUDELEMENT.Base = "old_ttt_element"
HUDELEMENT.type = "TTTSpecHUD"

if CLIENT then

	-- Paint punch-o-meter
	local function PunchPaint(el, client)
		local L = GetLang()
		local punch = client:GetNWFloat("specpunches", 0)
		local width, height = 200, 25
		local x = ScrW() * 0.5 - width * 0.5
		local y = el.margin * 0.5 + height

		el:PaintBar(x, y, width, height, el.ammo_colors, punch)

		local color = el.bg_colors.background_main

		draw.SimpleText(L.punch_title, "HealthAmmo", ScrW() * 0.5, y, color, TEXT_ALIGN_CENTER)
		draw.SimpleText(L.punch_help, "TabLarge", ScrW() * 0.5, el.margin, COLOR_WHITE, TEXT_ALIGN_CENTER)

		local bonus = client:GetNWInt("bonuspunches", 0)
		if bonus ~= 0 then
			local text

			if bonus < 0 then
				text = interp(L.punch_bonus, {num = bonus})
			else
				text = interp(L.punch_malus, {num = bonus})
			end

			draw.SimpleText(text, "TabLarge", ScrW() * 0.5, y * 2, COLOR_WHITE, TEXT_ALIGN_CENTER)
		end
	end

	local key_params = {usekey = Key("+use", "USE")}

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if client:Alive() and client:Team() ~= TEAM_SPEC then return end

		local L = GetLang() -- for fast direct table lookups

		-- Draw round state
		local margin = self.margin
		local smargin = self.smargin
		local x = margin
		local height = self.bgheight
		local width = self.maxwidth
		local hastewidth = self.hastewidth
		local bg_colors = self.bg_colors
		local round_y = ScrH() - height - margin

		-- move up a little on low resolutions to allow space for spectator hints
		if ScrW() < 1000 then
			round_y = round_y - 15
		end

		local time_x = width - hastewidth
		local time_y = round_y + 4

		draw.RoundedBox(8, x, round_y, width, height, bg_colors.background_main)
		draw.RoundedBox(8, x, round_y, time_x, height, bg_colors.noround)

		-- Draw current round state
		local text = L[roundstate_string[GAMEMODE.round_state]]
		self:ShadowedText(text, "TraitorState", x + (width - hastewidth) * 0.5, round_y, COLOR_WHITE, TEXT_ALIGN_CENTER)

		-- Draw round/prep/post time remaining
		text = util.SimpleTime(math.max(0, GetGlobalFloat("ttt_round_end", 0) - CurTime()), "%02i:%02i")
		self:ShadowedText(text, "TimeLeft", x + time_x + smargin + hastewidth * 0.5, time_y, COLOR_WHITE, TEXT_ALIGN_CENTER)

		local tgt = client:GetObserverTarget()

		if IsValid(tgt) and tgt:IsPlayer() then
			self:ShadowedText(tgt:Nick(), "TimeLeft", ScrW() * 0.5, margin, COLOR_WHITE, TEXT_ALIGN_CENTER) -- draw name of the spectators target
		elseif IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == client then
			PunchPaint(self, client) -- punch bar if you are spectator and inside of an entity
		else
			self:ShadowedText(interp(L.spec_help, key_params), "TabLarge", ScrW() * 0.5, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)
		end
	end
end
