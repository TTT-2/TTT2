local oldITEM = ITEM

-- load items
local itemsPre = "terrortown/entities/items/"
local itemsFiles = file.Find(itemsPre .. "*.lua", "LUA")
local _, itemsFolders = file.Find(itemsPre .. "*", "LUA")

for i = 1, #itemsFiles do
    local fl = itemsFiles[i]

    ITEM = {}

    include(itemsPre .. fl)

    local cls = string.sub(fl, 0, #fl - 4)

    items.Register(ITEM, cls)

    ITEM = nil
end

for i = 1, #itemsFolders do
    local folder = itemsFolders[i]

    ITEM = {}

    local subFiles = file.Find(itemsPre .. folder .. "/*.lua", "LUA")

    for k = 1, #subFiles do
        local fl = subFiles[k]

        if fl == "init.lua" then
            if SERVER then
                include(itemsPre .. folder .. "/" .. fl)
            end
        elseif fl == "cl_init.lua" then
            if SERVER then
                AddCSLuaFile(itemsPre .. folder .. "/" .. fl)
            else
                include(itemsPre .. folder .. "/" .. fl)
            end
        else
            if SERVER and fl == "shared.lua" then
                AddCSLuaFile(itemsPre .. folder .. "/" .. fl)
            end

            include(itemsPre .. folder .. "/" .. fl)
        end
    end

    items.Register(ITEM, folder)

    ITEM = nil
end

ITEM = oldITEM
