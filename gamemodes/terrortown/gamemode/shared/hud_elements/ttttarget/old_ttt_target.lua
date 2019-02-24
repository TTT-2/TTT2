if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("TTTHTargetHit")
end

local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

local plymeta = FindMetaTable("Player")

if not plymeta then return end

function plymeta:GetTargetPlayer()
	return self.targetPlayer
end

function plymeta:SetTargetPlayer(ply)
	self.targetPlayer = ply

	if SERVER then
		net.Start("TTTHTargetHit")
		net.WriteEntity(ply)
		net.Send(self)
	end
end

if CLIENT then -- CLIENT
	net.Receive("TTTHTargetHit", function(len)
		local client = LocalPlayer()

		if not IsValid(client) then return end

		local target = net.ReadEntity()

		if IsValid(target) and target:IsPlayer() and target:IsActive() then
			client:SetTargetPlayer(target)
		end
	end)

	-- Creating Font
	surface.CreateFont("HUDFont", {font = "Trebuchet24", size = 24, weight = 750})

	function HUDELEMENT:Initialize()
		local width, height = self.maxwidth, 45

	    self:SetBasePos(15, ScrH() - height - self.maxheight - self.margin)
		self:SetSize(width, height)

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:DrawComponent(name, col, val)
		local client = LocalPlayer()

		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local width, height = size.w, size.h

		self:DrawBg(x, y, width, height, client)

		local bar_width = width - self.dmargin
		local bar_height = height - self.dmargin

		local tx = x + self.margin
		local ty = y + self.margin

		self:PaintBar(tx, ty, bar_width, bar_height, col)
		self:ShadowedText(name, "HealthAmmo", tx + bar_width * 0.5, ty + bar_height * 0.5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText("Target", "TabLarge", x + self.margin * 2, y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	function HUDELEMENT:Draw()
		local ply = LocalPlayer()

		if not IsValid(ply) then return end

		local tgt = ply:GetTargetPlayer()

		if HUDManager.IsEditing then
			self:DrawComponent("TARGET", Color(100, 100, 100, 255), "- TARGET -")
		elseif IsValid(tgt) and ply:IsActive() then
			self:DrawComponent("TARGET", tgt:GetRoleColor(), tgt:Nick())
		end
	end
end

hook.Add("TTTEndRound", "TTTEndRound4TTTHTargetHit", function(result)
	for _, pl in ipairs(player.GetAll()) do
		pl.targetPlayer = nil
	end
end)
