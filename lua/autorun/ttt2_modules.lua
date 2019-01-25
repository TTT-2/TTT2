-- include base item files
if SERVER then
	include("terrortown/entities/items/item_base/init.lua")
else
	include("terrortown/entities/items/item_base/cl_init.lua")
end

-- include modules
require("items")

-- load items
local itemsPre = "terrortown/entities/items/"
local itemsFiles = file.Find(itemsPre .. "*.lua", "LUA")
local _, itemsFolders = file.Find(itemsPre .. "*", "LUA")

ITEM = {}

for _, fl in ipairs(itemsFiles) do
	include(itemsPre .. fl)

	local cls = string.sub(fl, 0, #fl - 4)

	items.Register(ITEM, cls)

	ITEM = {}
end

for _, folder in ipairs(itemsFolders) do
	if folder == "item_base" then return end

	local subFiles = file.Find(itemsPre .. folder .. "/*.lua", "LUA")

	for _, fl in ipairs(subFiles) do
		if fl == "init.lua" then
			if SERVER then
				include(itemsPre .. folder .. fl)
			end
		elseif fl == "cl_init.lua" then
			if CLIENT then
				include(itemsPre .. folder .. fl)
			else
				AddCSLuaFile(itemsPre .. folder .. fl)
			end
		else
			if SERVER and fl == "shared.lua" then
				AddCSLuaFile(itemsPre .. folder .. fl)
			end

			include(itemsPre .. folder .. fl)
		end

		items.Register(ITEM, folder)

		ITEM = {}
	end
end
