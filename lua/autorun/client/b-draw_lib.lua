if engine.ActiveGamemode() ~= "terrortown" then return end

---
-- A Simple Garry's mod drawing library
-- Copyright (C) 2016 Bull [STEAM_0:0:42437032] [76561198045139792]
-- Freely acquirable at https://github.com/bull29/b_draw-lib
-- You can use this anywhere for any purpose as long as you acredit the work to the original author with this notice.
-- Optionally, if you choose to use this within your own software, it would be much appreciated if you could inform me of it.
-- I love to see what people have done with my code! :)
-- This code got fixed and modified by the TTT2 dev group, ty for the lib @Bull !
--
-- @author Bull
-- @author Alf21
--
-- @module draw

file.CreateDir("downloaded_assets")

local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local white = Color(255, 255, 255)
local surface = surface
local crc = util.CRC
local _error = Material("error")
local _bot_avatar = Material("vgui/ttt/b-draw/icon_avatar_bot.vmt")
local _default_avatar = Material("vgui/ttt/b-draw/icon_avatar_default.vmt")
local math = math
local mats = {}
local fetched_avatar_urls = {}

local function FetchAsset(url)
	if not url then return end

	if mats[url] then
		return mats[url]
	end

	local crcUrl = crc(url)

	if exists("downloaded_assets/" .. crcUrl .. ".png", "DATA") then
		mats[url] = Material("data/downloaded_assets/" .. crcUrl .. ".png")

		return mats[url]
	end

	fetch(url, function(data)
		write("downloaded_assets/" .. crcUrl .. ".png", data)

		mats[url] = Material("data/downloaded_assets/" .. crcUrl .. ".png")
	end)
end

local function FetchAvatarAsset(id64, size)
	if not id64 then
		return _bot_avatar
	end

	size = size == "medium" and "_medium" or size == "large" and "_full" or ""

	local key = id64 .. size

	if fetched_avatar_urls[key] then
		return FetchAsset(fetched_avatar_urls[key])
	end

	fetch("http://steamcommunity.com/profiles/" .. id64 .. "/?xml=1", function(body)
		local link = body:match("<avatarIcon><%!%[CDATA%[(.-)%]%]><%/avatarIcon>")

		if not link then return end

		fetched_avatar_urls[key] = link:Replace(".jpg", size .. ".jpg")
		FetchAsset(fetched_avatar_urls[key])
	end)
end

---
-- fetches the avatar material for a steamid64
-- when an avatar is found it will be cached
-- @param string id64 the steamid64
-- @param string size the avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @realm client
function draw.CacheAvatar(id64, size)
	FetchAvatarAsset(id64, size)
end

---
-- Draws an Image
-- @param string url the url to the WebImage
-- @param number x
-- @param number y
-- @param number width
-- @param number height
-- @param Color color
-- @param Angle angle
-- @param boolean cornerorigin if it is set to <code>true</code>, the WebImage will be centered based on the x- and y-coordinate
-- @realm client
local function DrawImage(material, x, y, width, height, color, angle, cornerorigin)
	color = color or white

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(material)

	if not angle then
		surface.DrawTexturedRect(x, y, width, height)
	else
		if not cornerorigin then
			surface.DrawTexturedRectRotated(x, y, width, height, angle)
		else
			surface.DrawTexturedRectRotated(x + width * 0.5, y + height * 0.5, width, height, angle)
		end
	end
end

---
-- Draws a WebImage
-- @param string url the url to the WebImage
-- @param number x
-- @param number y
-- @param number width
-- @param number height
-- @param Color color
-- @param Angle angle
-- @param boolean cornerorigin if it is set to <code>true</code>, the WebImage will be centered based on the x- and y-coordinate
-- @realm client
function draw.WebImage(url, x, y, width, height, color, angle, cornerorigin)
	DrawImage(FetchAsset(url) or _error, x, y, width, height, color, angle, cornerorigin)
end

---
-- @todo description
-- @param string url
-- @param number parentwidth
-- @param number parentheight
-- @param number xrep
-- @param number yrep
-- @param Color color
-- @realm client
function draw.SeamlessWebImage(url, parentwidth, parentheight, xrep, yrep, color)
	color = color or white

	local xiwx, yihy = math.ceil(parentwidth / xrep), math.ceil(parentheight / yrep)

	for x = 0, xrep - 1 do
		for y = 0, yrep - 1 do
			draw.WebImage(url, x * xiwx, y * yihy, xiwx, yihy, color)
		end
	end
end

---
-- Draws a SteamAvatar while caching it before
-- @param string id64 the steamid64
-- @param string size the avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @param number x
-- @param number y
-- @param number width
-- @param number height
-- @param Color color
-- @param Angle angle
-- @param boolean cornerorigin if it is set to <code>true</code>, the WebImage will be centered based on the x- and y-coordinate
-- @realm client
function draw.SteamAvatar(id64, size, x, y, width, height, color, angle, cornerorigin)
	DrawImage(FetchAvatarAsset(id64, size) or _default_avatar, x, y, width, height, color, angle, cornerorigin)
end

---
-- fetches and returns the avatar material for a steamid64
-- when an avatar is found it will be cached
-- @param string id64 the steamid64
-- @param string size the avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @return Material
-- @realm client
function draw.GetAvatarMaterial(id64, size)
	return FetchAvatarAsset(id64, size) or _default_avatar
end
