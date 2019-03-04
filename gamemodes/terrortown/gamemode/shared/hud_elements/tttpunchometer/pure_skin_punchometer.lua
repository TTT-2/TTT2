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

	function HUDELEMENT:Initialize()
		w, h = w_default, h_default
		margin = margin_default

		self:RecalculateBasePos()

		self:SetSize(w, h)
		self:SetMinSize(min_w, min_h)

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:RecalculateBasePos()
		self:SetBasePos(ScrW() * 0.5 - w * 0.5, (margin + 72) * self.scale)
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

		pad = pad_default * self.scale
		margin = margin_default * self.scale
		w, h = size.w, size.h

		BaseClass.PerformLayout(self)
	end

	local key_params = {usekey = Key("+use", "USE")}

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if client:Alive() and client:Team() ~= TEAM_SPEC then return end

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
