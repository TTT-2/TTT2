local HUDS_ABSTRACT_FOLDER = "base_huds"

local function includeFoldersFiles(base, fld, fls)
    for i = 1, #fls do
        local fl = fls[i]
        local filename = base .. fld .. "/" .. fl

        if SERVER then
            AddCSLuaFile(filename)
        end

        if CLIENT and fl == "cl_init.lua" then
            include(filename)
        elseif SERVER and fl == "init.lua" then
            include(filename)
        elseif fl == "shared.lua" then
            include(filename)
        end
    end
end

--
-- Load abstract HUDs
--

local pathBase = "terrortown/gamemode/shared/huds/" .. HUDS_ABSTRACT_FOLDER .. "/"
local pathFiles = file.Find(pathBase .. "*.lua", "LUA")

-- include HUD Elements files
for i = 1, #pathFiles do
    local fl = pathFiles[i]

    HUD = {}

    if SERVER then
        AddCSLuaFile(pathBase .. fl)
    end

    include(pathBase .. fl)

    local cls = string.sub(fl, 0, #fl - 4)

    HUD.isAbstract = true

    huds.Register(HUD, cls)

    Dev(1, "[TTT2][Huds] Registered abstract HUD " .. cls)

    HUD = nil
end

-- include HUD Elements folders
local _, subFolders = file.Find(pathBase .. "*", "LUA")

for i = 1, #subFolders do
    local folder = subFolders[i]
    local subFiles = file.Find(pathBase .. folder .. "/*.lua", "LUA")

    -- all huds will be loaded here
    HUD = {}

    includeFoldersFiles(pathBase, folder, subFiles)

    HUD.isAbstract = true

    huds.Register(HUD, folder)

    Dev(1, "[TTT2][Huds] Registered abstract HUD " .. folder)

    HUD = nil
end

--
-- load HUDs
--

pathBase = "terrortown/gamemode/shared/huds/"

local pathFiles2 = file.Find(pathBase .. "*.lua", "LUA")

-- include HUD Elements files
for i = 1, #pathFiles2 do
    local fl = pathFiles2[i]

    HUD = {}

    if SERVER then
        AddCSLuaFile(pathBase .. fl)
    end

    include(pathBase .. fl)

    local cls = string.sub(fl, 0, #fl - 4)

    huds.Register(HUD, cls)

    Dev(1, "[TTT2][Huds] Registered HUD " .. cls)

    HUD = nil
end

-- include HUD Elements folders
local _, subFolders2 = file.Find(pathBase .. "*", "LUA")

for i = 1, #subFolders2 do
    local folder = subFolders2[i]

    if folder == HUDS_ABSTRACT_FOLDER then
        continue
    end

    local subFiles = file.Find(pathBase .. folder .. "/*.lua", "LUA")

    -- all huds will be loaded here
    HUD = {}

    includeFoldersFiles(pathBase, folder, subFiles)

    huds.Register(HUD, folder)

    Dev(1, "[TTT2][Huds] Registered HUD " .. folder)

    HUD = nil
end
