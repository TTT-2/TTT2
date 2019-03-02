-- include modules
require("roles")

-- load roles
local rolesPre = "terrortown/entities/roles/"
local rolesFiles = file.Find(rolesPre .. "*.lua", "LUA")
local _, rolesFolders = file.Find(rolesPre .. "*", "LUA")

for _, fl in ipairs(rolesFiles) do
	ROLE = {}

	include(rolesPre .. fl)

	local cls = string.sub(fl, 0, #fl - 4)

	roles.Register(ROLE, cls)

	ROLE = nil
end

for _, folder in ipairs(rolesFolders) do
	ROLE = {}

	local subFiles = file.Find(rolesPre .. folder .. "/*.lua", "LUA")

	for _, fl in ipairs(subFiles) do
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
