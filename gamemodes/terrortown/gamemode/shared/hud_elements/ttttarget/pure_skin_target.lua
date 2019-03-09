local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
	local iconSize_default = 64
	local pad_default = 14
	local w_default, h_default = 365, 32

	local w, h = w_default, h_default
	local min_w, min_h = 225, 32
	local pad = pad_default -- padding
	local iconSize = iconSize_default
	HUDELEMENT.icon = Material("vgui/ttt/target_icon")

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 365, h = 32},
						minsize = {w = 225, h = 32}
	}

	function HUDELEMENT:Initialize()
		w, h = w_default, h_default
		pad = pad_default
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		local defaults = self:GetDefaults()

		self:SetBasePos(defaults.basepos.x, defaults.basepos.y)
		self:SetMinSize(defaults.size.w, defaults.size.h)
		self:SetSize(defaults.minsize.w, defaults.minsize.h)

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = { x = 10 * self.scale, y = ScrH() - h - 146 * self.scale - pad - 10 * self.scale}
		return const_defaults
 	end

	function HUDELEMENT:PerformLayout()
		local size = self:GetSize()

		self.scale = self:GetHUDScale()
		self.basecolor = self:GetHUDBasecolor()
		
		iconSize = iconSize_default * self.scale
		pad = pad_default * self.scale

		w, h = size.w, size.h
	end

	function HUDELEMENT:DrawComponent(name)
		local pos = self:GetPos()
		local x, y = pos.x, pos.y

		self:DrawBg(x, y, w, h, self.basecolor)
		self:AdvancedText(name, "PureSkinBar", x + iconSize + pad, y + h * 0.5, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)
		self:DrawLines(x, y, w, h, self.basecolor.a)

		local nSize = iconSize - 8

		util.DrawFilteredTexturedRect(x, y + 2 - (nSize - h), nSize, nSize, self.icon)
	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return IsValid(client)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		local tgt = client:GetTargetPlayer()

		if HUDEditor.IsEditing then
			self:DrawComponent("- TARGET -")
		elseif IsValid(tgt) and client:IsActive() then
			self:DrawComponent(tgt:Nick())
		end
	end
end
