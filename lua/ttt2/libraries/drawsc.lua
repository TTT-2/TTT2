---
-- drawsc library functions
-- @author Mineotopia

AddCSLuaFile()

if SERVER then return end

-- TODO REMOVE PLACEHOLDER!
GLAPP = {}
function GLAPP.GetGlobalScale()
	return 2
end
-- REMOVE END

local GetGlobalScale = GLAPP.GetGlobalScale

local mRound = math.Round
local drawOutlinedBox = draw.OutlinedBox
local drawOutlinedShadowedBox = draw.OutlinedShadowedBox
local drawBox = draw.Box
local drawShadowedBox = draw.ShadowedBox
local drawOutlinedCircle = draw.OutlinedCircle
local drawOutlinedShadowedCircle = draw.OutlinedShadowedCircle
local drawLine = draw.Line
local drawShadowedLine = draw.ShadowedLine
local drawFilteredTexture = draw.FilteredTexture
local drawFilteredShadowedTexture = draw.FilteredShadowedTexture
local drawAdvancedText = draw.AdvancedText

drawsc = {}

function drawsc.OutlinedBox(x, y, w, h, t, color)
	local scale = GetGlobalScale()

	drawOutlinedBox(mRound(x * scale), mRound(y * scale), mRound(w * scale), mRound(h * scale), mRound(t * scale), color)
end

function drawsc.OutlinedShadowedBox(x, y, w, h, t, color)
	local scale = GetGlobalScale()

	drawOutlinedShadowedBox(mRound(x * scale), mRound(y * scale), mRound(w * scale), mRound(h * scale), mRound(t * scale), color, scale)
end

function drawsc.Box(x, y, w, h, color)
	local scale = GetGlobalScale()

	drawBox(mRound(x * scale), mRound(y * scale), mRound(w * scale), mRound(h * scale), color)
end

function drawsc.ShadowedBox(x, y, w, h, color)
	local scale = GetGlobalScale()

	drawShadowedBox(mRound(x * scale), mRound(y * scale), mRound(w * scale), mRound(h * scale), color, scale)
end

function drawsc.OutlinedCircle(x, y, r, color)
	local scale = GetGlobalScale()

	drawOutlinedCircle(mRound(x * scale), mRound(y * scale), mRound(r * scale), color)
end

function drawsc.OutlinedShadowedCircle(x, y, r, color)
	local scale = GetGlobalScale()

	drawOutlinedShadowedCircle(mRound(x * scale), mRound(y * scale), mRound(r * scale), color, scale)
end

function drawsc.Line(startX, startY, endX, endY, color)
	local scale = GetGlobalScale()

	drawLine(mRound(startX * scale), mRound(startY * scale), mRound(endX * scale), mRound(endY * scale), color)
end

function drawsc.ShadowedLine(startX, startY, endX, endY, color)
	local scale = GetGlobalScale()

	drawShadowedLine(mRound(startX * scale), mRound(startY * scale), mRound(endX * scale), mRound(endY * scale), color, scale)
end

function drawsc.FilteredTexture(x, y, w, h, material, alpha, color)
	local scale = GetGlobalScale()

	drawFilteredTexture(mRound(x * scale), mRound(y * scale), mRound(w * scale), mRound(h * scale), material, alpha, color)
end

function drawsc.FilteredShadowedTexture(x, y, w, h, material, alpha, color)
	local scale = GetGlobalScale()

	drawFilteredShadowedTexture(mRound(x * scale), mRound(y * scale), mRound(w * scale), mRound(h * scale), material, alpha, color, scale)
end

function drawsc.AdvancedText(text, font, x, y, color, xalign, yalign)
	local scale = GetGlobalScale()

	drawAdvancedText(text, font, mRound(x * scale), mRound(y * scale), color, xalign, yalign, false, scale)
end

function drawsc.AdvancedShadowedText(text, font, x, y, color, xalign, yalign)
	local scale = GetGlobalScale()

	drawAdvancedText(text, font, mRound(x * scale), mRound(y * scale), color, xalign, yalign, true, scale)
end
