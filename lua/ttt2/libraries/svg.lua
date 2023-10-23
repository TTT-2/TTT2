---
-- svg library functions
-- Adds the possibility to render svg files as normal materials
-- @author Mineotopia
-- @author noaccessl
-- @module svg

if SERVER then
	AddCSLuaFile()

	return
end

local stringFormat = string.format
local stringSub = string.sub
local stringFind = string.find
local fileRead = file.Read
local format = format
local match = match

local svgTemplate = [[
<html>
	<head>
		<style>
			body {
				margin: 0;
				padding: %dpx;
				overflow: hidden;
			}
		</style>
	</head>
	<body>
		%s
	</body>
</html>
]]

local function SetIfEmpty(haystack, needle, pos, needed)
	if not stringFind(haystack, needle) then
		return string.sub(haystack, 1, pos) .. needed .. string.sub(haystack, pos + string.len(needed))
	end

	return haystack
end

local function GenerateHTMLElement(w, h, padding, strSVG)
	-- make sure svg file has opening and closing tag
	local open = string.find(strSVG, "<svg%s(.-)>")
	local _, close = string.find(strSVG, "</svg>%s*$")

	if not open or not close then return end

	strSVG = stringSub(strSVG, open, close)

	-- todo make sure that the svg size in combination witht the padding works here
	strSVG = SetIfEmpty(strSVG, "width='(.-)'", 5, "width='' ")
	strSVG = SetIfEmpty(strSVG, "height='(.-)'", 5, "height='' ")

	strSVG = string.gsub(strSVG, "width='(.-)'", "width='" .. w - 2 * padding .. "'")
	strSVG = string.gsub(strSVG, "height='(.-)'", "height='" .. h - 2 * padding .. "'")

	local htmlElement = vgui.Create("DHTML")
	htmlElement:SetVisible(false)
	htmlElement:SetSize(w, h)
	htmlElement:SetHTML(stringFormat(svgTemplate, padding, strSVG))

	return htmlElement
end

local materialAttributes = {
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
}

local function SetupMaterial(name, width, height, mipmapping)
	-- set individual material attributes
	materialAttributes["$basetexture"] = name

	-- enable mipmapping if not explicitly disabled
	if mipmapping ~= false then
		materialAttributes["$mipmaps"] = 1
		--materialAttributes["$flags"] = {
		--	["bilinear"] = 1,
		--	["mips"] = 1
		--}
	--materialAttributes["$mips"] = mipmapping -- does this work to create mipmaps?
	end

	return CreateMaterial(name, "UnlitGeneric", materialAttributes)
end

svg = svg or {}

---
-- Creates a material from an SVG file that can be used as any other material in GMod. Since normal
-- materials are created from pixelated sources instead of vectorized sources, a basewidth has to be
-- provided.
-- @param string path The filepath to the svg file
-- @param[default=64] number width The base width of the generated material
-- @param[default=64] number height The base height of the generated material
-- @param[default=0] number padding The padding around the material, is included in the set width and height
-- @param[default=true] boolean mipmapping Set to false to disable mipmapping for this material
-- @return nil|Material Returns the created material, nil if failed
-- @note This function is rather compute heavy and it should be therefore avoided to call
-- it from within a rendering hook. Caching of the returned matial is recommended.
-- @realm client
function svg.CreateSVGMaterial(path, width, height, padding, mipmapping)
	width = width or 64
	height = height or 64
	padding = padding or 0

	local svgString = fileRead("materials/" .. path, "GAME")

	if not svgString then return end

	local htmlElement = GenerateHTMLElement(width, height, padding, svgString)

	--return htmlElement

	if not htmlElement then return end

	-- the HTML element texture has to be updated once to generate a material
	htmlElement:UpdateHTMLTexture()

	-- then the material can be extracted from the HTML element
	local materialInternal = htmlElement:GetHTMLMaterial()

	-- todo: can the htmlElement be deleted after extracting the material?

	return SetupMaterial(materialInternal:GetName(), width, height, 1)
end
