--[[
    A Simple Garry's mod drawing library
    Copyright (C) 2016 Bull [STEAM_0:0:42437032] [76561198045139792]
    Freely acquirable at https://github.com/bull29/b_draw-lib
    You can use this anywhere for any purpose as long as you acredit the work to the original author with this notice.
    Optionally, if you choose to use this within your own software, it would be much appreciated if you could inform me of it.
    I love to see what people have done with my code! :)

	-- This code got fixed and modified by the TTT2 dev group, ty for the lib @Bull !
]]--

file.CreateDir("downloaded_assets")

local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local white = Color(255, 255, 255)
local surface = surface
local crc = util.CRC
local _error = Material("error")
local math = math
local mats = {}
local fetchedavatars = {}

local function fetch_asset(url, fallback)
	if not url then
		return _error
	end

	if mats[url] then
		return mats[url]
	end

	local crc = crc(url)

	if exists("downloaded_assets/" .. crc .. ".png", "DATA") then
		mats[url] = Material("data/downloaded_assets/" .. crc .. ".png")

		return mats[url]
	end

	mats[url] = fallback or _error

	fetch(url, function(data)
		write("downloaded_assets/" .. crc .. ".png", data)

		mats[url] = Material("data/downloaded_assets/" .. crc .. ".png")
	end)

	return mats[url]
end

local function fetchAvatarAsset(id64, size, onFetched)
	id64 = id64 or "BOT"
	size = size == "medium" and "medium" or size == "small" and "" or size == "large" and "full" or ""

	if fetchedavatars[id64 .. " " .. size] then
		return fetchedavatars[id64 .. " " .. size]
	end

	fetchedavatars[id64 .. " " .. size] = id64 == "BOT" and "http://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/09/09962d76e5bd5b91a94ee76b07518ac6e240057a_full.jpg" or "http://i.imgur.com/uaYpdq7.png"

	if id64 == "BOT" then
		if isfunction(onFetched) then
			onFetched(fetchedavatars[id64 .. " " .. size])
		end

		return
	end

	fetch("http://steamcommunity.com/profiles/" .. id64 .. "/?xml=1", function(body)
		local link = body:match("https://steamcdn%-a%.akamaihd%.net/steamcommunity/public/images/avatars/.-%.jpg") -- fix this with new https and gmod regex
		if not link then return end

		fetchedavatars[id64 .. " " .. size] = link:Replace(".jpg", (size ~= "" and "_" .. size or "") .. ".jpg")

		if isfunction(onFetched) then
			onFetched(fetchedavatars[id64 .. " " .. size])
		end
	end)
end

function draw.CacheAvatar(id64, size)
	fetch_asset(fetchAvatarAsset(id64, size, function(url)
		fetch_asset(url)
	end))
end

function draw.WebImage(url, x, y, width, height, color, angle, cornerorigin)
	color = color or white

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(fetch_asset(url))

	if not angle then
		surface.DrawTexturedRect(x, y, width, height)
	else
		if not cornerorigin then
			surface.DrawTexturedRectRotated(x, y, width, height, angle)
		else
			surface.DrawTexturedRectRotated(x + width / 2, y + height / 2, width, height, angle)
		end
	end
end

function draw.SeamlessWebImage(url, parentwidth, parentheight, xrep, yrep, color)
	color = color or white

	local xiwx, yihy = math.ceil(parentwidth / xrep), math.ceil(parentheight / yrep)

	for x = 0, xrep - 1 do
		for y = 0, yrep - 1 do
			draw.WebImage(url, x * xiwx, y * yihy, xiwx, yihy, color)
		end
	end
end

function draw.SteamAvatar(id64, size, x, y, width, height, color, ang, corner)
	draw.WebImage(fetchAvatarAsset(id64, size), x, y, width, height, color, ang, corner)
end

function draw.GetAvatarMaterial(id64, size, fallback)
	return fetch_asset(fetchAvatarAsset(id64, size), fallback)
end
