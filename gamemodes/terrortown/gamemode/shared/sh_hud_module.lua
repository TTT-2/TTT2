-- load huds
local hudsPre = "terrortown/gamemode/client/huds/"
local _, hudsFolders = file.Find(hudsPre .. "*", "LUA")

for _, folder in ipairs(hudsFolders) do
	-- add modules to download
	local hudmodulesPre = hudsPre .. folder .. "/hud_modules/"
	local hudmodulesFiles = file.Find(hudmodulesPre .. "*.lua", "LUA")
	local _, hudmodulesFolders = file.Find(hudmodulesPre .. "*", "LUA")

	for _, fl in ipairs(hudmodulesFiles) do
		AddCSLuaFile(hudmodulesPre .. fl)
	end

	for _, folder2 in ipairs(hudmodulesFolders) do
		local subFiles2 = file.Find(hudmodulesPre .. folder2 .. "/*.lua", "LUA")

		for _, fl in ipairs(subFiles2) do
			AddCSLuaFile(hudmodulesPre .. folder2 .. "/" .. fl)
		end
	end

	HUD = {}

	local subFiles = file.Find(hudsPre .. folder .. "/*.lua", "LUA")

	for _, fl in ipairs(subFiles) do
		if SERVER then
			AddCSLuaFile(hudsPre .. folder .. "/" .. fl)
		end

		if fl == "cl_init" then
			include(hudsPre .. folder .. "/" .. fl)
		end
	end

	huds.Register(HUD, folder)

	HUD = nil
end
