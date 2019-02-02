if not HUDManager then
	require("hudelements")
	require("huds")

	HUDManager = {}
	HUDManager.defaultHUD = "old_ttt"

	-----------------------------------------
	-- load HUD Elements
	-----------------------------------------

	local pathBase = "terrortown/gamemode/shared/hud_elements/"

	local _, pathFolders = file.Find(pathBase .. "*", "LUA")

	for _, typ in ipairs(pathFolders) do
		local pathFiles = file.Find(pathBase .. typ .. "/" .. "*.lua", "LUA")

		-- include HUD Elements files
		for _, fl in ipairs(pathFiles) do
			HUDELEMENT = {}

			if SERVER then
				AddCSLuaFile(pathBase .. typ .. "/" .. fl)
			end

			include(pathBase .. typ .. "/" .. fl)

			local cls = string.sub(fl, 0, #fl - 4)

			if typ ~= "base_elements" then
				HUDELEMENT.type = typ
			end

			hudelements.Register(HUDELEMENT, cls)

			HUDELEMENT = nil
		end

		-- include HUD Elements folders
		local _, subFolders = file.Find(pathBase .. typ .. "/" .. "*", "LUA")

		for _, folder in ipairs(subFolders) do
			HUDELEMENT = {}

			local subFiles = file.Find(pathBase .. typ .. "/" .. folder .. "/*.lua", "LUA")

			for _, fl in ipairs(subFiles) do
				local filename = pathBase .. typ .. "/" .. folder .. "/" .. fl

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

			if typ ~= "base_elements" then
				HUDELEMENT.type = typ
			end

			hudelements.Register(HUDELEMENT, folder)

			HUDELEMENT = nil
		end
	end

	-----------------------------------------
	-- load HUDs
	-----------------------------------------

	pathBase = "terrortown/gamemode/shared/huds/"

	local pathFiles = file.Find(pathBase .. "*.lua", "LUA")

	-- include HUD Elements files
	for _, fl in ipairs(pathFiles) do
		HUD = {}

		if SERVER then
			AddCSLuaFile(pathBase .. fl)
		end

		include(pathBase .. fl)

		local cls = string.sub(fl, 0, #fl - 4)

		hudelements.Register(HUD, cls)

		HUD = nil
	end

	-- include HUD Elements folders
	local _, subFolders = file.Find(pathBase .. "*", "LUA")

	for _, folder in ipairs(subFolders) do
		HUD = {}

		local subFiles = file.Find(pathBase .. folder .. "/*.lua", "LUA")

		for _, fl in ipairs(subFiles) do
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

		hudelements.Register(HUD, folder)

		HUD = nil
	end
end

if SERVER then
	ttt_include("sv_hud_manager")
else
	ttt_include("cl_hud_manager")
end
