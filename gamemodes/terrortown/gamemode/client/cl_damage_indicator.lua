---
-- @section Damage Indicator

DMGINDICATOR = {}
DMGINDICATOR.themes = {}

local dmgindicator_enable = CreateClientConVar("ttt_dmgindicator_enable", "1", true)
local dmgindicator_mode = CreateClientConVar("ttt_dmgindicator_mode", "Default", true)
local dmgindicator_duration = CreateClientConVar("ttt_dmgindicator_duration", "1.5", true)
local dmgindicator_maxdamage = CreateClientConVar("ttt_dmgindicator_maxdamage", "50.0", true)
local dmgindicator_maxalpha = CreateClientConVar("ttt_dmgindicator_maxalpha", "255", true)

local lastDamage = CurTime()
local damageAmount = 0.0
local maxDamageAmount = 0.0

local function collectDmgIndicatorTextures()
	local pathBase = "materials/vgui/ttt/dmgindicator/themes/"

	local materials, _ = file.Find(pathBase .. "*.png", "GAME")

	for i = 1, #materials do
		local material = materials[i]
		local materialStringBase = "vgui/ttt/dmgindicator/themes/"

		local materialName = string.StripExtension(material)

		DMGINDICATOR.themes[materialName] = Material(materialStringBase .. material)
	end
end
collectDmgIndicatorTextures()

net.Receive("ttt2_damage_received", function()
	local damageReceived = net.ReadFloat()

	lastDamage = CurTime()
	maxDamageAmount = math.min(1.0, math.max(damageAmount, 0.0) + damageReceived / dmgindicator_maxdamage:GetFloat())
	damageAmount = maxDamageAmount
end)

function GM:HUDPaintBackground()
	if not dmgindicator_enable:GetBool() then
		return
	end

	local indicatorDuration = dmgindicator_duration:GetFloat()
	
	if damageAmount > 0 then
		local remainingTimeFactor = math.max(0, indicatorDuration - (CurTime() - lastDamage)) / indicatorDuration
		damageAmount = maxDamageAmount * remainingTimeFactor

		local theme = DMGINDICATOR.themes[dmgindicator_mode:GetString()] or DMGINDICATOR.themes["Default"]
		surface.SetDrawColor(255, 255, 255, dmgindicator_maxalpha:GetInt() * damageAmount)
		surface.SetMaterial(theme)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end

