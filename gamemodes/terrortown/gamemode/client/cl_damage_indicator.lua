---
-- @section Damage Indicator

local indicatorDuration = 1.5

local blood_material = Material("vgui/ttt/BloodTest.png")
local lastDamage = CurTime()
local damageAmount = 0.0

net.Receive("ttt2_damage_received", function()
	local damageReceived = net.ReadFloat()

	lastDamage = CurTime()
	damageAmount = math.min(1.0, damageReceived / 50.0)
end)

function GM:HUDPaintBackground()
	local alpha = 0
	if damageAmount > 0 then
		local remainingTimeFactor = math.max(0, indicatorDuration - (CurTime() - lastDamage)) / indicatorDuration
		alpha = damageAmount * remainingTimeFactor
	end

	if(alpha > 0) then
		surface.SetDrawColor(255, 255, 255, 255 * alpha)
		surface.SetMaterial(blood_material)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end

