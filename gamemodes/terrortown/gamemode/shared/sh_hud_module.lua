require("huds")

local HUDS_ABSTRACT_FOLDER = "base_huds"

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

--------------------------
-- Load abstract HUDs
--------------------------

local pathBase = "terrortown/gamemode/shared/huds/" .. HUDS_ABSTRACT_FOLDER .. "/"

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

	MsgN("[TTT2][Huds] Registered abstract HUD " .. cls)

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

	MsgN("[TTT2][Huds] Registered abstract HUD " .. folder)

	HUD = nil
end

-----------------------------------------
-- load HUDs
-----------------------------------------

pathBase = "terrortown/gamemode/shared/huds/"

pathFiles = file.Find(pathBase .. "*.lua", "LUA")

-- include HUD Elements files
for _, fl in ipairs(pathFiles) do
	HUD = {}

	if SERVER then
		AddCSLuaFile(pathBase .. fl)
	end

	include(pathBase .. fl)

	local cls = string.sub(fl, 0, #fl - 4)

	huds.Register(HUD, cls)

	MsgN("[TTT2][Huds] Registered HUD " .. cls)

	HUD = nil
end

-- include HUD Elements folders
_, subFolders = file.Find(pathBase .. "*", "LUA")

for _, folder in ipairs(subFolders) do
	if folder == HUDS_ABSTRACT_FOLDER then continue end

	--appearently we need this check, because file.Find returns old weirdly cached directories
	if SERVER and not file.Exists(pathBase .. folder, "LUA") then
		MsgN("Skipped a folder that doesn't exists! " .. folder)

		continue
	end

	local subSubFiles = file.Find(pathBase .. folder .. "/*.lua", "LUA")

	-- all huds will be loaded here
	HUD = {}

	includeFoldersFiles(pathBase, folder, subSubFiles)

	huds.Register(HUD, folder)

	MsgN("[TTT2][Huds] Registered HUD " .. folder)

	HUD = nil
end
