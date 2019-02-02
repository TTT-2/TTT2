if HUDManager then return end

require("huds")
require("hudelements")

HUDManager = {}

-----------------------------------------
-- now load the HUDs and the HUD Elements
-----------------------------------------

local autoload = {
	"hud_elements",
	"huds"
}

for _, savedFolder in ipairs(autoload) do
	local pathBase = "terrortown/gamemode/shared/" .. savedFolder .. "/"

	local hudelementsFiles = file.Find(pathBase .. "*.lua", "LUA")

	-- include HUD Elements files
	for _, fl in ipairs(hudelementsFiles) do
		if savedFolder == "hud_elements" then
			HUDELEMENT = {}
		elseif savedFolder == "huds" then
			HUD = {}
		end

		if SERVER then
			AddCSLuaFile(pathBase .. fl)
		end

		include(pathBase .. fl)

		local cls = string.sub(fl, 0, #fl - 4)

		if savedFolder == "hud_elements" then
			hudelements.Register(HUDELEMENT, cls)

			HUDELEMENT = nil
		elseif savedFolder == "huds" then
			huds.Register(HUD, cls)

			HUD = nil
		end
	end

	-- include HUD Elements folders
	local _, subFolders = file.Find(pathBase .. "*", "LUA")

	for _, folder in ipairs(subFolders) do
		if savedFolder == "hud_elements" then
			HUDELEMENT = {}
		elseif savedFolder == "huds" then
			HUD = {}
		end

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

		if savedFolder == "hud_elements" then
			hudelements.Register(HUDELEMENT, folder)

			HUDELEMENT = nil
		elseif savedFolder == "huds" then
			huds.Register(HUD, folder)

			HUD = nil
		end
	end
end

if SERVER then
	ttt_include("sv_hud_manager")
else
	ttt_include("cl_hud_manager")
end
