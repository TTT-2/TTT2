local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp
local IsValid = IsValid
local draw = draw

local base = "old_ttt_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

if CLIENT then
	function HUDELEMENT:Initialize()
		self:SetBasePos(ScrW() * 0.5 - width * 0.5, margin + height)
		self:SetSize(200, 25)

		BaseClass.Initialize(self)

		self.defaults.resizeableY = false
	end

	local draw_col = Color(205, 155, 0, 255)
	local pad = 7
	local margin = 14

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
		self:DrawBar(x + pad, y + pad, width - pad * 0.5, height - pad * 0.5, draw_col, punch, L.punch_title)
		self:DrawLines(x, y, width, height)

		draw.SimpleText(L.punch_help, "TabLarge", x, y + margin + 10, COLOR_WHITE, TEXT_ALIGN_CENTER)

		local bonus = client:GetNWInt("bonuspunches", 0)
		if bonus ~= 0 then
			local text

			if bonus < 0 then
				text = interp(L.punch_bonus, {num = bonus})
			else
				text = interp(L.punch_malus, {num = bonus})
			end

			draw.SimpleText(text, "TabLarge", x, y + margin * 2 + 10, COLOR_WHITE, TEXT_ALIGN_CENTER)
		end
	end

	local key_params = {usekey = Key("+use", "USE")}

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if client:Alive() and client:Team() ~= TEAM_SPEC then return end

		local L = GetLang() -- for fast direct table lookups

		-- Draw round state
		local tgt = client:GetObserverTarget()

		local pos = self:GetPos()
		local x, y = pos.x, pos.y

		if IsValid(tgt) and tgt:IsPlayer() then
			self:ShadowedText(tgt:Nick(), "TimeLeft", x, y, COLOR_WHITE, TEXT_ALIGN_CENTER) -- draw name of the spectators target
		elseif IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == client then
			self:PunchPaint() -- punch bar if you are spectator and inside of an entity
		else
			self:ShadowedText(interp(L.spec_help, key_params), "TabLarge", x, y, COLOR_WHITE, TEXT_ALIGN_CENTER)
		end
	end
end
