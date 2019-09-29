local oldITEM = ITEM

-- include modules
require("items")

-- load items
local itemsPre = "terrortown/entities/items/"
local itemsFiles = file.Find(itemsPre .. "*.lua", "LUA")
local _, itemsFolders = file.Find(itemsPre .. "*", "LUA")

for _, fl in ipairs(itemsFiles) do
	ITEM = {}

	include(itemsPre .. fl)

	local cls = string.sub(fl, 0, #fl - 4)

	items.Register(ITEM, cls)

	ITEM = nil
end

for _, folder in ipairs(itemsFolders) do
	ITEM = {}

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

	ITEM = nil
end

ITEM = oldITEM

-- Initialize old items and convert them to the new item system
hook.Add("TTTInitPostEntity", "InitTTT2OldItems", function()
	for subrole, tbl in pairs(EquipmentItems or {}) do
		for _, v in ipairs(tbl) do
			if v.avoidTTT2 then continue end

			local name = v.ClassName or v.name or WEPS.GetClass(v)
			if not name then continue end

			local item = items.GetStored(GetEquipmentFileName(name))
			if not item then
				local ITEMDATA = table.Copy(v)
				ITEMDATA.oldId = v.id
				ITEMDATA.id = name
				ITEMDATA.EquipMenuData = v.EquipMenuData or {
					type = v.type,
					name = v.name,
					desc = v.desc
				}
				ITEMDATA.type = nil
				ITEMDATA.desc = nil
				ITEMDATA.name = name
				ITEMDATA.material = v.material
				ITEMDATA.CanBuy = {subrole}

				-- reset this old hud bool
				if ITEMDATA.hud == true then
					ITEMDATA.oldHud = true
					ITEMDATA.hud = nil
				end

				-- set the converted indicator
				ITEMDATA.converted = true

				-- don't add icon and desc to the search panel if it's not intended
				ITEMDATA.noCorpseSearch = ITEMDATA.noCorpseSearch or true

				items.Register(ITEMDATA, GetEquipmentFileName(name))

				timer.Simple(0, function()
					print("[TTT2][INFO] Automatically converted not adjusted ITEM", name, ITEMDATA.oldId)
				end)
			else
				item.CanBuy = item.CanBuy or {}

				if not table.HasValue(item.CanBuy, subrole) then
					item.CanBuy[#item.CanBuy + 1] = subrole
				end
			end
		end
	end

	items.OnLoaded() -- init baseclasses
end)
