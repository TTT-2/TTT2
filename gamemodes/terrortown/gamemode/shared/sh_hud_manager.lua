local HUDELEMENTS_SHARED_FUNCTIONS_FOLDER = "shared_base"
local HUDELEMENTS_ABSTRACT_FOLDER = "base_elements"
local HUDS_ABSTRACT_FOLDER = "base_huds"

if not HUDManager then
	require("hudelements")
	require("huds")

	HUDManager = {}
	HUDManager.defaultHUD = "pure_skin"

	local function includeFoldersFiles(pathBase, folder, filestbl)
		for _, fl in ipairs(filestbl) do
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

	-----------------------------------------
	-- load HUD Elements
	-----------------------------------------

	local pathBase = "terrortown/gamemode/shared/hud_elements/"

	local _, pathFolders = file.Find(pathBase .. "*", "LUA")

	for _, typ in ipairs(pathFolders) do
		local shortPath = pathBase .. typ .. "/"
		local pathFiles = file.Find(shortPath .. "*.lua", "LUA")

		-- include HUD Elements files
		for _, fl in ipairs(pathFiles) do
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

		for _, folder in ipairs(subFolders) do
			local subFiles = file.Find(shortPath .. folder .. "/*.lua", "LUA")

			-- add special folder to clients, this is for shared functions between
			-- different implementations of element types
			if folder == HUDELEMENTS_SHARED_FUNCTIONS_FOLDER then
				for _, fl in ipairs(subFiles) do
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

	--------------------------
	-- Load abstract HUDs
	--------------------------

	pathBase = "terrortown/gamemode/shared/huds/" .. HUDS_ABSTRACT_FOLDER .. "/"

	local pathFiles = file.Find(pathBase .. "*.lua", "LUA")

	-- include HUD Elements files
	for _, fl in ipairs(pathFiles) do
		HUD = {}

		if SERVER then
			AddCSLuaFile(pathBase .. fl)
		end

		include(pathBase .. fl)

		local cls = string.sub(fl, 0, #fl - 4)

		HUD.isAbstract = true

		huds.Register(HUD, cls)

		HUD = nil
	end

	-- include HUD Elements folders
	local _, subFolders = file.Find(pathBase .. "*", "LUA")

	for _, folder in ipairs(subFolders) do

		local subSubFiles = file.Find(pathBase .. folder .. "/*.lua", "LUA")

		-- all huds will be loaded here
		HUD = {}

		includeFoldersFiles(pathBase, folder, subSubFiles)

		HUD.isAbstract = true

		huds.Register(HUD, folder)

		HUD = nil
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

		huds.Register(HUD, cls)

		HUD = nil
	end

	-- include HUD Elements folders
	local _, subFolders = file.Find(pathBase .. "*", "LUA")

	for _, folder in ipairs(subFolders) do
		if folder == HUDS_ABSTRACT_FOLDER then continue end

		local subSubFiles = file.Find(pathBase .. folder .. "/*.lua", "LUA")

		-- all huds will be loaded here
		HUD = {}

		includeFoldersFiles(pathBase, folder, subSubFiles)

		huds.Register(HUD, folder)

		HUD = nil
	end
end

if SERVER then
	ttt_include("sv_hud_manager")
else
	ttt_include("cl_hud_editor")
	ttt_include("cl_hud_manager")
end
