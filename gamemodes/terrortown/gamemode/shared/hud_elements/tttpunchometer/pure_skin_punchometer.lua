local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp
local IsValid = IsValid
local draw = draw

local base = "pure_skin_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

if CLIENT then
	local width, height = 200, 40
	local min_w, min_h = 100, 40
	local draw_col = Color(205, 155, 0, 255)
	local pad = 7
	local margin = 14

	function HUDELEMENT:Initialize()
		self:RecalculateBasePos()
		self:SetSize(width, height)
		self:SetMinSize(min_w, min_h)

		BaseClass.Initialize(self)

		self.defaults.resizeableY = false
	end

	function HUDELEMENT:RecalculateBasePos()
		self:SetBasePos(ScrW() * 0.5 - width * 0.5, (margin + 72) * self.scale)
	end

	-- Paint punch-o-meter
	function HUDELEMENT:PunchPaint()
		local client = LocalPlayer()
		local L = GetLang()
		local punch = client:GetNWFloat("specpunches", 0)
		local size = self:GetSize()
		local pos = self:GetPos()
		local width, height = size.w, size.h
		local x, y = pos.x, pos.y

		self:DrawBg(x, y, width, height, self.basecolor)
		self:DrawBar(x + pad, y + pad, width - pad * 2, height - pad * 2, draw_col, punch, self.scale, L.punch_title)
		self:DrawLines(x, y, width, height, self.basecolor.a)

		self:AdvancedText(L.punch_help, "TabLarge", x + width * 0.5, y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

		local bonus = client:GetNWInt("bonuspunches", 0)
		if bonus ~= 0 then
			local text

			if bonus < 0 then
				text = interp(L.punch_bonus, {num = bonus})
			else
				text = interp(L.punch_malus, {num = bonus})
			end

			self:AdvancedText(text, "TabLarge", x, y + margin * 2 + 20, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)
		end
	end

	function HUDELEMENT:PerformLayout()
		local size = self:GetSize()

		width, height = size.w, size.h

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
		pad = 7 * self.scale
		margin = 14 * self.scale

		if IsValid(tgt) and not tgt:IsPlayer() and tgt:GetNWEntity("spec_owner", nil) == client then
			self:PunchPaint() -- punch bar if you are spectator and inside of an entity
		else
			self:AdvancedText(interp(L.spec_help, key_params), "TabLarge", x + size.w  * 0.5, y, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)
		end
	end
end
