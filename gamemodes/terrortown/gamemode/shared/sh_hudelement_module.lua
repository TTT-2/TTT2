local HUDELEMENTS_SHARED_FUNCTIONS_FOLDER = "shared_base"
local HUDELEMENTS_ABSTRACT_FOLDER = "base_elements"

local function includeFoldersFiles(pathBase, folder, filestbl)
    for i = 1, #filestbl do
        local fl = filestbl[i]
        local filename = pathBase .. folder .. "/" .. fl

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
-- load HUD Elements
--

local pathBase = "terrortown/gamemode/shared/hud_elements/"

local _, pathFolders = file.Find(pathBase .. "*", "LUA")

for i = 1, #pathFolders do
    local typ = pathFolders[i]
    local shortPath = pathBase .. typ .. "/"
    local pathFiles = file.Find(shortPath .. "*.lua", "LUA")

    -- include HUD Elements files
    for k = 1, #pathFiles do
        local fl = pathFiles[k]

        HUDELEMENT = {}

        if SERVER then
            AddCSLuaFile(shortPath .. fl)
        end

        include(shortPath .. fl)

        local cls = string.sub(fl, 0, #fl - 4)

        if typ ~= HUDELEMENTS_ABSTRACT_FOLDER then
            HUDELEMENT.type = typ
        end

        hudelements.Register(HUDELEMENT, cls)

        HUDELEMENT = nil
    end

    -- include HUD Elements folders
    local _, subFolders = file.Find(shortPath .. "*", "LUA")

    for k = 1, #subFolders do
        local folder = subFolders[k]
        local subFiles = file.Find(shortPath .. folder .. "/*.lua", "LUA")

        -- add special folder to clients, this is for shared functions between
        -- different implementations of element types
        if folder == HUDELEMENTS_SHARED_FUNCTIONS_FOLDER then
            for kk = 1, #subFiles do
                local fl = subFiles[kk]
                local filename = pathBase .. folder .. "/" .. fl

                if SERVER then
                    AddCSLuaFile(filename)
                end
            end
        else
            HUDELEMENT = {}

            includeFoldersFiles(shortPath, folder, subFiles)

            if typ ~= HUDELEMENTS_ABSTRACT_FOLDER then
                HUDELEMENT.type = typ
            end

            hudelements.Register(HUDELEMENT, folder)

            HUDELEMENT = nil
        end
    end
end
