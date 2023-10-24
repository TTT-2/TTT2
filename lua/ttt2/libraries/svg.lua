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
local stringGSub = string.gsub
local stringLen = string.len
local stringFind = string.find
local fileRead = file.Read

local svgTemplate = [[
<html>
	<head>
		<style>
			body {
				margin: 0;
				padding: %dpx;
				overflow: hidden;
				background-color: rgba(255,0,0,0);
			}
		</style>
	</head>
	<body>
		%s
	</body>
</html>
]]

local materialAttributes = {
	["$nodecal"] = 1,
	["$nolod"] = 1,
	["$smooth"] = 1,
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
}

local mipmapSizes = {
	[8] = true,
	[16] = true,
	[32] = true,
	[64] = true,
	[128] = true,
	[256] = true,
	[512] = true,
	[1024] = true
}

local function SetIfEmpty(haystack, needle, pos, needed)
	if not stringFind(haystack, needle) then
		return stringSub(haystack, 1, pos) .. needed .. stringSub(haystack, pos + stringLen(needed))
	end

	return haystack
end

local function SetupMaterial(name, width, height)
	-- set individual material attributes
	materialAttributes["$basetexture"] = name

	return CreateMaterial(name, "UnlitGeneric", materialAttributes)
end

local function GenerateHTMLElement(width, height, padding, strSVG)
	-- make sure svg file has opening and closing tag
	local open = stringFind(strSVG, "<svg%s(.-)>")
	local _, close = stringFind(strSVG, "</svg>%s*$")

	if not open or not close then return end

	strSVG = stringSub(strSVG, open, close)

	-- todo make sure that the svg size in combination witht the padding works here
	strSVG = SetIfEmpty(strSVG, "width='(.-)'", 5, "width='' ")
	strSVG = SetIfEmpty(strSVG, "height='(.-)'", 5, "height='' ")

	strSVG = stringGSub(strSVG, "width='(.-)'", "width='" .. width - 2 * padding .. "'")
	strSVG = stringGSub(strSVG, "height='(.-)'", "height='" .. height - 2 * padding .. "'")

	local htmlElement = vgui.Create("DHTML")
	htmlElement:SetVisible(false)
	htmlElement:SetSize(width, height)
	htmlElement:SetHTML(stringFormat(svgTemplate, padding, strSVG))

	return htmlElement
end

local function GenerateHTMLMaterial(width, height, padding, strSVG)
	width = math.floor(width)
	height = math.floor(height)

	local htmlElement = GenerateHTMLElement(width, height, padding, strSVG)

	if not htmlElement then return end

	-- the HTML element texture has to be updated once to generate a material
	htmlElement:UpdateHTMLTexture()

	-- then the material can be extracted from the HTML element
	local materialInternal = htmlElement:GetHTMLMaterial()
	local material = SetupMaterial(materialInternal:GetName(), width, height)

	--htmlElement:Remove()

	return material
end

svg = svg or {}
svg.customMipmaps = svg.customMipmaps or {}

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

	local strSVG = fileRead("materials/" .. path .. ".svg", "GAME")

	if not strSVG then return end

	-- generate base material
	local material = GenerateHTMLMaterial(width, height, padding, strSVG)
	local name = material:GetName()

	svg.InitializeTable(name)

	-- if not explicitly disabled, mipmaps should be generated as well
	if mipmapping ~= false then
		for size in pairs(mipmapSizes) do
			if size >= height then continue end

			local mult = size / height

			svg.AddCustomMipmap(name, size, GenerateHTMLMaterial(width * mult, size, padding * mult, strSVG))
		end
	end

	return material
end

function svg.InitializeTable(name)
	svg.customMipmaps[name] = svg.customMipmaps[name] or {}
end

function svg.AddCustomMipmap(name, height, material)
	svg.customMipmaps[name][height] = material
end

function svg.GetCustomMipmap(material, height)
	local name = material:GetName()

	if not svg.IsSVGMaterial(name) then
		return material
	end

	local nextSize = util.NextPowerOfTwo(height)

	if not svg.customMipmaps[name][nextSize] then
		return material
	end

	return svg.customMipmaps[name][nextSize]
end

function svg.FileExists(path)
	return file.Exists("materials/" .. path .. ".svg", "GAME")
end

function svg.IsSVGMaterial(name)
	return svg.customMipmaps[name] ~= nil
end
