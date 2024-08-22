if engine.ActiveGamemode() ~= "terrortown" then
    return
end

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
local delete = file.Delete
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

---
-- Captures the content of a render target as a PNG image
-- @param RenderTarget renderTarget The render target to capture
-- @param Material material The material to use for rendering
-- @param number width The width of the capture
-- @param number height The height of the capture
-- @return string The captured PNG data
-- @realm client
local function CaptureRenderTarget(renderTarget, material, width, height)
    render.PushRenderTarget(renderTarget)
    cam.Start2D()
    surface.SetMaterial(material)
    cam.End2D()

    local data = render.Capture({
        format = "png",
        x = 0,
        y = 0,
        w = width,
        h = height
    })

    render.PopRenderTarget()

    return data
end

---
-- Creates an avatar material for a given SteamID64 if it doesn't exist
-- @param string id64 The SteamID64 of the user
-- @return Material The created avatar material or nil if creation failed
-- @realm client
local function CreateAvatarMaterial(id64)
    local size = 184 -- maximum allowed size
    local renderTargetName = id64 .. size
    local crcUrl = crc(renderTargetName)
    local filePath = "downloaded_assets/" .. crcUrl .. ".png"

    if exists(filePath, "DATA") then
        return Material("data/" .. filePath)
    end

    local avatarImage = vgui.Create("AvatarImage")
    avatarImage:SetSize(size, size)
    avatarImage:SetSteamID(id64, size)
    avatarImage:SetPaintedManually(true)

    local renderTarget = GetRenderTargetEx(
        renderTargetName,
        size,
        size,
        RT_SIZE_NO_CHANGE,
        MATERIAL_RT_DEPTH_NONE,
        16,
        CREATERENDERTARGETFLAGS_HDR,
        IMAGE_FORMAT_RGBA8888
    )

    if not renderTarget then
        avatarImage:Remove()

        return nil
    end

    render.PushRenderTarget(renderTarget)
    cam.Start2D()
    avatarImage:PaintManual(true)
    cam.End2D()
    render.PopRenderTarget()

    local material = CreateMaterial(id64 .. size, "UnlitGeneric", {
        ["$basetexture"] = renderTargetName,
        ["$nodecal"] = 1,
        ["$nolod"] = 1,
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$vertexcolor"] = 1,
    })

    local data = CaptureRenderTarget(renderTarget, material, size, size)

    if data then
        write(filePath, data)
    end

    avatarImage:Remove()

    return material
end

---
-- Fetches an asset from the specified URL and caches it if successful
-- @param string url The URL of the asset
-- @return Material The material for the fetched asset
-- @realm client
local function FetchAsset(url)
    if not url then
        return
    end

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

---
-- Fetches an avatar asset for a given SteamID64 and size, with fallback support
-- @param string id64 The SteamID64 of the user
-- @param string size The size of the avatar, can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @return Material The avatar material if available or a fallback material if fetching fails
-- @realm client
local function FetchAvatarAsset(id64, size)
    if not id64 then
        return _bot_avatar
    end

    size = size == "medium" and "_medium" or size == "large" and "_full" or ""

    local key = id64 .. size

    if fetched_avatar_urls[key] then
        return FetchAsset(fetched_avatar_urls[key])
    end

    ---
    -- @realm client
    -- stylua: ignore
    local data = hook.Run("TTT2FetchAvatar", id64, size)
    if data ~= nil then
        local url = "hook://" .. key
        local crcUrl = crc(url)

        fetched_avatar_urls[key] = url

        write("downloaded_assets/" .. crcUrl .. ".png", data)

        return
    end

    local url = "http://steamcommunity.com/profiles/" .. id64 .. "/?xml=1"

    fetch(url, function(body)
        local link = body:match("<avatarIcon><%!%[CDATA%[(.-)%]%]><%/avatarIcon>")

        if not link then
            return
        end

        fetched_avatar_urls[key] = link:Replace(".jpg", size .. ".jpg")
        FetchAsset(fetched_avatar_urls[key])
    end, function()
        -- Fallback if fetching from Steam fails
        local material = CreateAvatarMaterial(id64)

        if material then
            mats[key] = material
        end
    end)

    return mats[key]
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
-- Deletes the avatar material for a steamid64
-- when a cached avatar is found it will be destroyed.
-- @param string id64 The player's steamid64
-- @param string size The avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @realm client
function draw.DropCacheAvatar(id64, size)
    size = size == "medium" and "_medium" or size == "large" and "_full" or ""
    local key = id64 .. size

    local url = fetched_avatar_urls[key]
    local crcUrl = crc(url)
    local uri = "data/downloaded_assets/" .. crcUrl .. ".png"

    if exists(uri, "DATA") then
        delete(uri, "DATA")
    end

    mats[url] = nil
    fetched_avatar_urls[key] = nil
end

---
-- Draws an Image
-- @param Material material the material to draw
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
    DrawImage(
        FetchAvatarAsset(id64, size) or _default_avatar,
        x,
        y,
        width,
        height,
        color,
        angle,
        cornerorigin
    )
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
