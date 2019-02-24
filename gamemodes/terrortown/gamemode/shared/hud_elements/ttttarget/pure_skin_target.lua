if SERVER then
	AddCSLuaFile()
end

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
	-- Creating Font
	surface.CreateFont("HUDFont", {font = "Trebuchet24", size = 24, weight = 750})

	local pad = 14 -- padding
	local iconSize = 64
	local target_icon = Material("vgui/ttt/target_icon")

	function HUDELEMENT:Initialize()
		local width, height = 365, 32

	    self:SetBasePos(pad, ScrH() - height - 146 - pad)
		self:SetSize(width, height)

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:DrawComponent(name)
		local client = LocalPlayer()

		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local width, height = size.w, size.h

		self:DrawBg(x, y, width, height, self.basecolor)
		self:ShadowedText(name, "HealthAmmo", x + iconSize + pad, y + height * 0.5, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		self:DrawLines(x, y, width, height, self.basecolor.a)

		local nSize = iconSize - 8

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(target_icon)
		surface.DrawTexturedRect(x + 4, y - 4 - (nSize - height), nSize, nSize)
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
