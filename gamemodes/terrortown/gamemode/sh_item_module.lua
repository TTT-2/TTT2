ITEM = {}

-- include modules
require("items")

-- include base item files
if SERVER then
	AddCSLuaFile("terrortown/entities/items/item_base/shared.lua")
end

include("terrortown/entities/items/item_base/shared.lua")

items.Register(ITEM, "item_base")

ITEM = {}

-- load items
local itemsPre = "terrortown/entities/items/"
local itemsFiles = file.Find(itemsPre .. "*.lua", "LUA")
local _, itemsFolders = file.Find(itemsPre .. "*", "LUA")

for _, fl in ipairs(itemsFiles) do
	include(itemsPre .. fl)

	local cls = string.sub(fl, 0, #fl - 4)

	items.Register(ITEM, cls)

	ITEM = {}
end

for _, folder in ipairs(itemsFolders) do
	if folder ~= "item_base" then
		local subFiles = file.Find(itemsPre .. folder .. "/*.lua", "LUA")

		for _, fl in ipairs(subFiles) do
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

		ITEM = {}
	end
end
