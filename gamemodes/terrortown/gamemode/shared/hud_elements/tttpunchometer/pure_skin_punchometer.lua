--- @ignore

local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp
local IsValid = IsValid
local draw = draw

local base = "pure_skin_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

if CLIENT then
	local draw_col = Color(205, 155, 0, 255)

	local pad = 7
	local margin = 14

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 200, h = 40},
		minsize = {w = 100, h = 40}
	}

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		self.pad = pad
		self.margin = margin

		self.cv_ttt_spectator_mode = GetConVar("ttt_spectator_mode");

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = ScrW() * 0.5 - self.size.w * 0.5, y = self.margin + 72 * self.scale}

		return const_defaults
	end

	-- Paint punch-o-meter
	function HUDELEMENT:PunchPaint()
		local client = LocalPlayer()
		local L = GetLang()
		local punch = client:GetNWFloat("specpunches", 0)
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local w, h = size.w, size.h

		self:DrawBg(x, y, w, h, self.basecolor)
		self:DrawBar(x + self.pad, y + self.pad, w - self.pad * 2, h - self.pad * 2, draw_col, punch, self.scale, L.punch_title)
		self:DrawLines(x, y, w, h, self.basecolor.a)

		draw.AdvancedText(L.punch_help, "TabLarge", x + w * 0.5, y, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

		local bonus = client:GetNWInt("bonuspunches", 0)
		if bonus ~= 0 then
			local text

			if bonus < 0 then
				text = interp(L.punch_bonus, {num = bonus})
			else
				text = interp(L.punch_malus, {num = bonus})
			end

			draw.AdvancedText(text, "TabLarge", x + w * 0.5, y + self.margin * 2 + 20, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)
		end
	end

	function HUDELEMENT:PerformLayout()
		self.scale = appearance.GetGlobalScale()
		self.basecolor = self:GetHUDBasecolor()
		self.pad = pad * self.scale
		self.margin = margin * self.scale

		BaseClass.PerformLayout(self)
	end

	local key_params = {usekey = Key("+use", "USE"), helpkey = Key("gm_showhelp", "F1")}

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return not client:Alive() or client:Team() == TEAM_SPEC
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		local L = GetLang() -- for fast direct table lookups

		-- Draw round state
		local tgt = client:GetObserverTarget()

		local pos = self:GetPos()
		local x, y = pos.x, pos.y

		if IsValid(tgt) and not tgt:IsPlayer() and tgt:GetNWEntity("spec_owner", nil) == client then
			self:PunchPaint() -- punch bar if you are spectator and inside of an entity
		else
			draw.AdvancedText(interp(L.spec_help, key_params), "TabLarge", x + self.size.w * 0.5, y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)
			if self.cv_ttt_spectator_mode:GetBool() then
				draw.AdvancedText(interp(L.spec_help2, key_params), "TabLarge", x + self.size.w * 0.5, y + 20, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)
			end
		end
	end
end
