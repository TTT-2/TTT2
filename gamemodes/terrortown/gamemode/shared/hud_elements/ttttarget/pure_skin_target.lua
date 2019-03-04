if SERVER then
	AddCSLuaFile()
end

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
	local target_icon = Material("vgui/ttt/target_icon")

	function HUDELEMENT:Initialize()
		w, h = w_default, h_default
		pad = pad_default

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
	    self:SetBasePos(10 * self.scale, ScrH() - h - 146 * self.scale - pad - 10 * self.scale)
	end

	function HUDELEMENT:PerformLayout()
		local size = self:GetSize()

		iconSize = iconSize_default * self.scale
		pad = pad_default * self.scale

		w, h = size.w, size.h
	end

	function HUDELEMENT:DrawComponent(name)
		local client = LocalPlayer()

		local pos = self:GetPos()
		local x, y = pos.x, pos.y

		self:DrawBg(x, y, w, h, self.basecolor)
		self:AdvancedText(name, "PureSkinBar", x + iconSize + pad, y + h * 0.5, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, true, self.scale)
		self:DrawLines(x, y, w, h, self.basecolor.a)

		local nSize = iconSize - 8

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(target_icon)
		surface.DrawTexturedRect(x, y + 2 - (nSize - h), nSize, nSize)
	end

	function HUDELEMENT:Draw()
		local ply = LocalPlayer()

		if not IsValid(ply) then return end

		local tgt = ply:GetTargetPlayer()

		if HUDManager.IsEditing then
			self:DrawComponent("- TARGET -")
		elseif IsValid(tgt) and ply:IsActive() then
			self:DrawComponent(tgt:Nick())
		end
	end
end
