local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp
local IsValid = IsValid
local draw = draw

local base = "pure_skin_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

if CLIENT then
	local pad_default = 7
	local margin_default = 14
	local w_default, h_default = 200, 40

	local w, h = w_default, h_default
	local min_w, min_h = 100, 40
	local draw_col = Color(205, 155, 0, 255)
	local pad = pad_default
	local margin = margin_default

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 200, h = 40},
						minsize = {w = 100, h = 40}
	}

	function HUDELEMENT:Initialize()
		w, h = w_default, h_default
		margin = margin_default
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = { x = ScrW() * 0.5 - self.size.w * 0.5, y = margin + 72 * self.scale}
		return const_defaults
 	end

	-- Paint punch-o-meter
	function HUDELEMENT:PunchPaint()
		local client = LocalPlayer()
		local L = GetLang()
		local punch = client:GetNWFloat("specpunches", 0)
		local pos = self:GetPos()
		local x, y = pos.x, pos.y

		self:DrawBg(x, y, w, h, self.basecolor)
		self:DrawBar(x + pad, y + pad, w - pad * 2, h - pad * 2, draw_col, punch, self.scale, L.punch_title)
		self:DrawLines(x, y, w, h, self.basecolor.a)

		self:AdvancedText(L.punch_help, "TabLarge", x + w * 0.5, y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

		local bonus = client:GetNWInt("bonuspunches", 0)
		if bonus ~= 0 then
			local text

			if bonus < 0 then
				text = interp(L.punch_bonus, {num = bonus})
			else
				text = interp(L.punch_malus, {num = bonus})
			end

			self:AdvancedText(text, "TabLarge", x + w * 0.5, y + margin * 2 + 20, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)
		end
	end

	function HUDELEMENT:PerformLayout()
		local size = self:GetSize()

		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()

		pad = pad_default * self.scale
		margin = margin_default * self.scale
		w, h = size.w, size.h

		BaseClass.PerformLayout(self)
	end

	local key_params = {usekey = Key("+use", "USE")}

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
		local size = self:GetSize()
		local x, y = pos.x, pos.y

		if IsValid(tgt) and not tgt:IsPlayer() and tgt:GetNWEntity("spec_owner", nil) == client then
			self:PunchPaint() -- punch bar if you are spectator and inside of an entity
		else
			self:AdvancedText(interp(L.spec_help, key_params), "TabLarge", x + size.w * 0.5, y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)
		end
	end
end
