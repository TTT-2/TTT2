if SERVER then
	AddCSLuaFile()
end

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
	local width, height = 365, 32
	local pad = 14 -- padding
	local iconSize = 64
	local target_icon = Material("vgui/ttt/target_icon")

	function HUDELEMENT:Initialize()
	    self:RecalculateBasePos()
		self:SetSize(width, height)

		BaseClass.Initialize(self)

		self.defaults.resizeableY = false
	end

	function HUDELEMENT:RecalculateBasePos()
	    self:SetBasePos(10, ScrH() - height - 146 - pad - 10)
	end

	function HUDELEMENT:DrawComponent(name)
		local client = LocalPlayer()

		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local width, height = size.w, size.h

		self:DrawBg(x, y, width, height, self.basecolor)
		self:ShadowedText(name, "PureSkinRole", x + iconSize + pad, y + height * 0.5, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		self:DrawLines(x, y, width, height, self.basecolor.a)

		local nSize = iconSize - 8

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(target_icon)
		surface.DrawTexturedRect(x, y + 2 - (nSize - height), nSize, nSize)
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
