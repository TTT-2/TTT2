ROLE_DERAND_NONE = 0
ROLE_DERAND_BASEROLE = 1
ROLE_DERAND_SUBROLE = 2
ROLE_DERAND_BOTH = 3

-- load roles
local rolesPre = "terrortown/entities/roles/"
local rolesFiles = file.Find(rolesPre .. "*.lua", "LUA")
local _, rolesFolders = file.Find(rolesPre .. "*", "LUA")

for i = 1, #rolesFiles do
    local fl = rolesFiles[i]

    ROLE = {}

    local cls = string.sub(fl, 0, #fl - 4)

    ROLE.name = cls

    include(rolesPre .. fl)

    roles.Register(ROLE, cls)

    ROLE = nil
end

for i = 1, #rolesFolders do
    local folder = rolesFolders[i]

    ROLE = {}
    ROLE.name = folder

    local subFiles = file.Find(rolesPre .. folder .. "/*.lua", "LUA")

    for k = 1, #subFiles do
        local fl = subFiles[k]

        if fl == "init.lua" then
            if SERVER then
                include(rolesPre .. folder .. "/" .. fl)
            end
        elseif fl == "cl_init.lua" then
            if SERVER then
                AddCSLuaFile(rolesPre .. folder .. "/" .. fl)
            else
                include(rolesPre .. folder .. "/" .. fl)
            end
        else
            if SERVER and fl == "shared.lua" then
                AddCSLuaFile(rolesPre .. folder .. "/" .. fl)
            end

            include(rolesPre .. folder .. "/" .. fl)
        end
    end

    roles.Register(ROLE, folder)

    ROLE = nil
end
