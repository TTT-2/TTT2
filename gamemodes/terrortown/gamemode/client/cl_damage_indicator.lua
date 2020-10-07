---
-- @section Damage Indicator

DMGINDICATOR = {}
DMGINDICATOR.themes = {}

-- SET UP CONVARS
DMGINDICATOR.cv = {}
DMGINDICATOR.cv.enable = CreateClientConVar("ttt_dmgindicator_enable", "1", true)
DMGINDICATOR.cv.mode = CreateClientConVar("ttt_dmgindicator_mode", "default", true)
DMGINDICATOR.cv.duration = CreateClientConVar("ttt_dmgindicator_duration", "1.5", true)
DMGINDICATOR.cv.maxdamage = CreateClientConVar("ttt_dmgindicator_maxdamage", "50.0", true)
DMGINDICATOR.cv.maxalpha = CreateClientConVar("ttt_dmgindicator_maxalpha", "255", true)

local lastDamage = CurTime()
local damageAmount = 0.0
local maxDamageAmount = 0.0

local materialStringBase = "vgui/ttt/dmgindicator/themes/"
local pathBase = "materials/" .. materialStringBase

local function CollectDmgIndicatorTextures()
	local materials = file.Find(pathBase .. "*.png", "GAME")

	for i = 1, #materials do
		local material = materials[i]
		local materialName = string.StripExtension(material)

		DMGINDICATOR.themes[materialName] = Material(materialStringBase .. material)
	end
end
CollectDmgIndicatorTextures()

net.Receive("ttt2_damage_received", function()
	local damageReceived = net.ReadFloat()
	if damageReceived <= 0 then return end

	lastDamage = CurTime()
	maxDamageAmount = math.min(1.0, math.max(damageAmount, 0.0) + damageReceived / DMGINDICATOR.cv.maxdamage:GetFloat())
	damageAmount = maxDamageAmount
end)

function GM:HUDPaintBackground()
	if not DMGINDICATOR.cv.enable:GetBool() then return end

	local indicatorDuration = DMGINDICATOR.cv.duration:GetFloat()

	if damageAmount > 0 then
		local theme = DMGINDICATOR.themes[DMGINDICATOR.cv.mode:GetString()] or DMGINDICATOR.themes["Default"]
		local remainingTimeFactor = math.max(0, indicatorDuration - (CurTime() - lastDamage)) / indicatorDuration

		damageAmount = maxDamageAmount * remainingTimeFactor

		surface.SetDrawColor(255, 255, 255, DMGINDICATOR.cv.maxalpha:GetInt() * damageAmount)
		surface.SetMaterial(theme)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end

---
-- Returns an indexed table with the names of all themes
-- @return table A table with names of all themes
-- @realm client
function DMGINDICATOR.GetThemeNames()
	return table.GetKeys(DMGINDICATOR.themes)
end
