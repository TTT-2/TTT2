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
local white = Color(255, 255, 255)
local surface = surface
local crc = util.CRC
local _bot_avatar = Material("vgui/ttt/b-draw/icon_avatar_bot.vmt")
local _default_avatar = Material("vgui/ttt/b-draw/icon_avatar_default.vmt")
local mats = {}

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
        h = height,
    })

    render.PopRenderTarget()

    return data
end

---
-- Creates an avatar material for a given SteamID64 if it doesn't exist
-- @param string id64 The SteamID64 of the user
-- @param string size The avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @return Material The created avatar material or the default material
-- @realm client
local function CreateAvatarMaterial(id64, size)
    if not id64 then
        return _bot_avatar
    end

    local avatarSize = 32

    if size == "large" then
        avatarSize = 184
    elseif size == "medium" then
        avatarSize = 64
    end

    local renderTargetName = id64 .. avatarSize
    local crcUrl = crc(renderTargetName)
    local filePath = "downloaded_assets/" .. crcUrl .. ".png"

    if mats[renderTargetName] then
        return mats[renderTargetName]
    end

    ---
    -- @realm client
    local data = hook.Run("TTT2FetchAvatar", id64, avatarSize)

    if data then
        write(filePath, data)
        mats[renderTargetName] = Material("data/" .. filePath)

        return mats[renderTargetName]
    end

    local avatarImage = vgui.Create("AvatarImage")
    avatarImage:SetSize(avatarSize, avatarSize)
    avatarImage:SetSteamID(id64, avatarSize)
    avatarImage:SetPaintedManually(true)

    local renderTarget = GetRenderTargetEx(
        renderTargetName,
        avatarSize,
        avatarSize,
        RT_SIZE_NO_CHANGE,
        MATERIAL_RT_DEPTH_NONE,
        16,
        CREATERENDERTARGETFLAGS_HDR,
        IMAGE_FORMAT_RGBA8888
    )

    if not renderTarget then
        avatarImage:Remove()

        return _default_avatar
    end

    render.PushRenderTarget(renderTarget)
    cam.Start2D()
    avatarImage:PaintManual(true)
    cam.End2D()
    render.PopRenderTarget()

    local material = CreateMaterial(id64 .. avatarSize, "UnlitGeneric", {
        ["$basetexture"] = renderTargetName,
        ["$nodecal"] = 1,
        ["$nolod"] = 1,
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$vertexcolor"] = 1,
    })

    local captureData = CaptureRenderTarget(renderTarget, material, avatarSize, avatarSize)

    if captureData then
        write(filePath, captureData)
    end

    avatarImage:Remove()
    mats[renderTargetName] = material

    return material
end

---
-- Refreshes the avatar images by deleting old cached images and generating new ones
-- @param string id64 The steamid64 of the player
-- @realm client
function draw.RefreshAvatars(id64)
    draw.DropCacheAvatar(id64, "small")
    draw.DropCacheAvatar(id64, "medium")
    draw.DropCacheAvatar(id64, "large")
    draw.CacheAvatar(id64, "small")
    draw.CacheAvatar(id64, "medium")
    draw.CacheAvatar(id64, "large")
end

---
-- Creates the avatar material for a steamid64
-- When an avatar is found it will be cached
-- @param string id64 The steamid64
-- @param string size The avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @realm client
function draw.CacheAvatar(id64, size)
    CreateAvatarMaterial(id64, size)
end

---
-- Deletes the avatar material for a steamid64
-- When a cached avatar is found it will be destroyed
-- @param string id64 The player's steamid64
-- @param string size The avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @realm client
function draw.DropCacheAvatar(id64, size)
    local avatarSize = 32

    if size == "large" then
        avatarSize = 184
    elseif size == "medium" then
        avatarSize = 64
    end

    local key = id64 .. avatarSize
    local crcUrl = crc(key)
    local uri = "downloaded_assets/" .. crcUrl .. ".png"

    if exists(uri, "DATA") then
        delete(uri, "DATA")
    end

    mats[key] = nil
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
-- @param boolean cornerorigin If it is set to <code>true</code>, the WebImage will be centered based on the x- and y-coordinate
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
-- Draws a SteamAvatar while caching it before
-- @param string id64 The steamid64
-- @param string size The avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @param number x
-- @param number y
-- @param number width
-- @param number height
-- @param Color color
-- @param Angle angle
-- @param boolean cornerorigin If it is set to <code>true</code>, the WebImage will be centered based on the x- and y-coordinate
-- @realm client
function draw.SteamAvatar(id64, size, x, y, width, height, color, angle, cornerorigin)
    DrawImage(
        CreateAvatarMaterial(id64, size) or _default_avatar,
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
-- Creates and returns the avatar material for a steamid64
-- When an avatar is found it will be cached
-- @param string id64 The steamid64
-- @param string size The avatar's size, this can be <code>small</code>, <code>medium</code> or <code>large</code>
-- @return Material The created avatar material or the default material
-- @realm client
function draw.GetAvatarMaterial(id64, size)
    return CreateAvatarMaterial(id64, size) or _default_avatar
end
