local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local ParT = LANG.GetParamTranslation
	local TryT = LANG.TryTranslation

	local pad = 14

	local colorRevivingBar = Color(36, 154, 198)

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 321, h = 74},
		minsize = {w = 250, h = 74}
	}

	function HUDELEMENT:Initialize()
		self.pad = pad
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = 0.5 * ScrH() + 100}

		return const_defaults
	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return HUDEditor.IsEditing or (not client:Alive() and client:IsReviving())
	end

	function HUDELEMENT:PerformLayout()
		local scale = self:GetHUDScale()

		self.scale = scale
		self.basecolor = self:GetHUDBasecolor()
		self.pad = pad * scale

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local w, h = size.w, size.h
		local defaults = self:GetDefaults()

		local timeLeft = HUDEditor.IsEditing and 1 or math.ceil(math.max(0, client:GetRevivalTime() - (CurTime() - client:GetRevivalStartTime())))
		local progress = HUDEditor.IsEditing and 1 or ((CurTime() - client:GetRevivalStartTime()) / client:GetRevivalTime())

		local posHeaderY = y + self.pad
		local posBarY = posHeaderY + 20 * self.scale
		local boxHeight = 26 * self.scale
		local posReasonY = posBarY + boxHeight + self.pad

		local revivalReasonLines = {}
		local lineHeight = 0

		if client:HasRevivalReason() then
			local rawRevivalReason = client:GetRevivalReason()

			local translatedText
			if rawRevivalReason.params then
				translatedText = ParT(rawRevivalReason.name, rawRevivalReason.params)
			else
				translatedText = TryT(rawRevivalReason.name)
			end

			local lines, _, textHeight = draw.GetWrappedText(
				translatedText,
				w - 2 * self.pad,
				"PureSkinBar",
				self.scale
			)

			revivalReasonLines = lines
			lineHeight = textHeight / #revivalReasonLines

			h = defaults.size.h + textHeight + self.pad
		else
			h = defaults.size.h
		end

		self:SetSize(w, h)

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)

		draw.AdvancedText("reviving_progress", "PureSkinBar", x + self.pad, posHeaderY, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)
		draw.AdvancedText(timeLeft, "PureSkinBar", x + w - self.pad, posHeaderY, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, true, self.scale)

		self:DrawBar(x + self.pad, posBarY, w - self.pad * 2, boxHeight, colorRevivingBar, progress, 1)

		for i = 1, #revivalReasonLines do
			draw.AdvancedText(revivalReasonLines[i], "PureSkinBar", x + self.pad, posReasonY + (i - 1) * lineHeight, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, true, self.scale)
		end

		-- draw lines around the element
		self:DrawLines(x, y, w, h, self.basecolor.a)
	end
end
