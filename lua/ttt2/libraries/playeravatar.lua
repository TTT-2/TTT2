---
--
--
-- @author
--
-- @module playeravatar

if SERVER then
    AddCSLuaFile()

    return
end

file.CreateDir("player_avatars")

local fileExists = file.Exists
local fileWrite = file.Write
local fileDelete = file.Delete
local surface = surface
local crc = util.CRC
local bot_avatar = Material("vgui/ttt/b-draw/icon_avatar_bot")
local default_avatar = Material("vgui/ttt/b-draw/icon_avatar_default")
local playeravatar_cache = {}

playeravatar = {}

---@enum
PLAYERAVATAR_SIZE = {
    small = 32,
    medium = 64,
    large = 128,
    -- `large` was 184, but we use this for the `width/height` parameter of `GetRenderTargetEx`
    -- which according to the wiki must be a power of 2
    -- ref.: https://wiki.facepunch.com/gmod/Global.GetRenderTargetEx#arguments
}

---
-- Captures the content of a render target as a PNG image
-- @param ITexture renderTarget The render target to capture
-- @param IMaterial material The material to use for rendering
-- @param number width The width of the capture
-- @param number height The height of the capture
-- @return string|nil The captured binary PNG data
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

local function GetAvatarCacheKey(id64, avatarSize)
    return id64 .. avatarSize
end

local function GetAvatarUri(id64, avatarSize)
    local key = GetAvatarCacheKey(id64, avatarSize)
    local crcUrl = crc(key)
    return "player_avatars/" .. crcUrl .. ".png"
end

---
-- Creates an avatar material for a given SteamID64 if it doesn't exist
-- @param string id64 The SteamID64 of the user
-- @param PLAYERAVATAR_SIZE avatarSize The avatar's size
-- @return IMaterial The created avatar material or the default material
-- @realm client
local function CreateAvatarMaterial(id64, avatarSize)
    if not id64 then
        return bot_avatar
    end

    local cacheKey = GetAvatarCacheKey(id64, avatarSize)
    local uri = GetAvatarUri(id64, avatarSize)

    ---
    -- @realm client
    -- TODO: declare that this needs to return a PNG, JPEG, GIF, or TGA file
    -- the file extension does not matter we will append `.png` to it
    local data = hook.Run("TTT2FetchAvatar", id64, avatarSize)

    if data then
        fileWrite(uri, data)
        playeravatar_cache[cacheKey] = Material("data/" .. uri)

        return playeravatar_cache[cacheKey]
    end

    -- TODO: according to the wiki render targets are not garbage collected and remain in memory
    -- until disconnect.
    -- ref: https://wiki.facepunch.com/gmod/Global.GetRenderTarget#description
    -- Test if this is actually the case and if we can get away with reusing a single render target
    local renderTarget = GetRenderTargetEx(
        cacheKey,
        avatarSize,
        avatarSize,
        RT_SIZE_NO_CHANGE,
        MATERIAL_RT_DEPTH_NONE,
        16,
        CREATERENDERTARGETFLAGS_HDR,
        IMAGE_FORMAT_RGBA8888
    )

    if not renderTarget then
        return default_avatar
    end

    local avatarImage = vgui.Create("AvatarImage")
    avatarImage:SetSize(avatarSize, avatarSize)
    avatarImage:SetSteamID(id64, avatarSize)
    avatarImage:SetPaintedManually(true)

    render.PushRenderTarget(renderTarget)
    cam.Start2D()
    avatarImage:PaintManual(true)
    cam.End2D()
    render.PopRenderTarget()

    local material = CreateMaterial(cacheKey, "UnlitGeneric", {
        ["$basetexture"] = cacheKey,
        ["$nodecal"] = 1,
        ["$nolod"] = 1,
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$vertexcolor"] = 1,
    })

    local captureData = CaptureRenderTarget(renderTarget, material, avatarSize, avatarSize)

    if captureData then
        fileWrite(uri, captureData)
    end

    avatarImage:Remove()
    playeravatar_cache[cacheKey] = material

    return material
end

---
-- Refreshes the avatar images by deleting old cached images and generating new ones
-- @param string id64 The steamid64 of the player
-- @realm client
function playeravatar.Refresh(id64)
    playeravatar.DropCache(id64, PLAYERAVATAR_SIZE.small)
    playeravatar.DropCache(id64, PLAYERAVATAR_SIZE.medium)
    playeravatar.DropCache(id64, PLAYERAVATAR_SIZE.large)
    playeravatar.Cache(id64, PLAYERAVATAR_SIZE.small)
    playeravatar.Cache(id64, PLAYERAVATAR_SIZE.medium)
    playeravatar.Cache(id64, PLAYERAVATAR_SIZE.large)
end

---
-- Creates the avatar material for a steamid64
-- When an avatar is found it will be cached
-- @param string id64 The steamid64
-- @param PLAYERAVATAR_SIZE size The avatar's size
-- @realm client
-- TODO: Make this local? Or actually use this somewhere? Or merge/replace with
-- `playeravatar.GetMaterial()`
function playeravatar.Cache(id64, size)
    CreateAvatarMaterial(id64, size)
end

---
-- Deletes the avatar material for a steamid64
-- When a cached avatar is found it will be destroyed
-- @param string id64 The player's steamid64
-- @param PLAYERAVATAR_SIZE avatarSize The avatar's size
-- @realm client
-- TODO: Make this local? Or actually use this somewhere?
-- TODO: Also it does not really make much sense to only drop a single avatarSize by default. We
-- probably should by default just iterate over small,medium,large
function playeravatar.DropCache(id64, avatarSize)
    local key = GetAvatarCacheKey(id64, avatarSize)
    local uri = GetAvatarUri(id64, avatarSize)

    if fileExists(uri, "DATA") then
        fileDelete(uri, "DATA")
    end

    playeravatar_cache[key] = nil
end

---
-- Creates and returns the avatar material for a steamid64
-- When an avatar is found it will be cached
-- @param string id64 The steamid64
-- @param PLAYERAVATAR_SIZE avatarSize The avatar's size
-- @return IMaterial The created avatar material or the default material
-- @realm client
function playeravatar.GetMaterial(id64, avatarSize)
    local rendertargetKey = GetAvatarCacheKey(id64, avatarSize)

    if playeravatar_cache[rendertargetKey] then
        return playeravatar_cache[rendertargetKey]
    end

    return CreateAvatarMaterial(id64, avatarSize)
end
