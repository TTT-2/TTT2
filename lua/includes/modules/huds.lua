local baseclass = baseclass
local list = list
local duplicator = duplicator
local pairs = pairs

module("huds", package.seeall)

if SERVER then
	AddCSLuaFile()
else
	local HUDList = HUDList or {}

	--[[---------------------------------------------------------
		Name: TableInherit( t, base )
		Desc: Copies any missing data from base to t
	-----------------------------------------------------------]]
	local function TableInherit(t, base)
		for k, v in pairs(base) do
			if t[k] == nil then
				t[k] = v
			elseif k ~= "BaseClass" and istable(t[k]) then
				TableInherit(t[k], v)
			end
		end

		t.BaseClass = base

		return t
	end

	--[[---------------------------------------------------------
		Name: IsBasedOn( name, base )
		Desc: Checks if name is based on base
	-----------------------------------------------------------]]
	function IsBasedOn(name, base)
		local t = GetStored(name)

		if not t then
			return false
		end

		if t.Base == name then
			return false
		end

		if t.Base == base then
			return true
		end

		return IsBasedOn(t.Base, base)
	end

	--[[---------------------------------------------------------
		Name: Register( hud_name, table, string )
		Desc: Used to register your HUDModule with the engine
	-----------------------------------------------------------]]
	function RegisterModule(hud, t, name)
		name = string.lower(name)

		local old = hud.hudmodules[name]

		t.ClassName = name
		t.id = name
		t.shouldDrawHook = t.shouldDrawHook or name

		hud.hudmodules[name] = t

		list.Set("HUDModule", name, {
				ClassName = name,
				id = name
		})

		-- Allow all HUDs to be duplicated, unless specified
		if not t.DisableDuplicator then
			duplicator.Allow(name)
		end

		--
		-- If we're reloading this entity class
		-- then refresh all the existing entities.
		--
		if old ~= nil then

			--
			-- For each entity using this class
			--
			for _, entity in ipairs(ents.FindByClass(name)) do

				--
				-- Replace the contents with this entity table
				--
				table.Merge(entity, t)

				--
				-- Call OnReloaded hook (if it has one)
				--
				if isfunction(entity.OnReloaded) then
					entity:OnReloaded()
				end
			end

			-- Update HUD table of entities that are based on this HUD
			for _, e in ipairs(ents.GetAll()) do
				if IsBasedOn(e:GetClass(), name) then
					table.Merge(e, Get(e:GetClass()))

					if isfunction(e.OnReloaded) then
						e:OnReloaded()
					end
				end
			end
		end
	end

	--[[---------------------------------------------------------
		Name: Register( table, string )
		Desc: Used to register your HUD with the engine
	-----------------------------------------------------------]]
	function Register(t, name)
		name = string.lower(name)

		local old = HUDList[name]

		t.ClassName = name
		t.id = name
		t.hudmodules = {}

		HUDList[name] = t

		list.Set("HUD", name, {
				ClassName = name,
				id = name
		})

		-- Allow all HUDs to be duplicated, unless specified
		if not t.DisableDuplicator then
			duplicator.Allow(name)
		end

		-- load hud modules
		local hudmodulesPre = "terrortown/gamemode/client/huds/" .. name .. "/hud_modules/"
		local hudmodulesFiles = file.Find(hudmodulesPre .. "*.lua", "LUA")
		local _, hudmodulesFolders = file.Find(hudmodulesPre .. "*", "LUA")

		for _, fl in ipairs(hudmodulesFiles) do
			HUDMODULE = {}

			include(hudmodulesPre .. fl)

			local cls = string.sub(fl, 0, #fl - 4)

			RegisterModule(t, HUDMODULE, cls)

			HUDMODULE = nil
		end

		for _, folder in ipairs(hudmodulesFolders) do
			HUDMODULE = {}

			local subFiles = file.Find(hudmodulesPre .. folder .. "/*.lua", "LUA")

			for _, fl in ipairs(subFiles) do
				include(hudmodulesPre .. folder .. "/" .. fl)
			end

			RegisterModule(t, HUDMODULE, folder)

			HUDMODULE = nil
		end

		--
		-- If we're reloading this entity class
		-- then refresh all the existing entities.
		--
		if old ~= nil then

			--
			-- For each entity using this class
			--
			for _, entity in ipairs(ents.FindByClass(name)) do

				--
				-- Replace the contents with this entity table
				--
				table.Merge(entity, t)

				--
				-- Call OnReloaded hook (if it has one)
				--
				if isfunction(entity.OnReloaded) then
					entity:OnReloaded()
				end
			end

			-- Update HUD table of entities that are based on this HUD
			for _, e in ipairs(ents.GetAll()) do
				if IsBasedOn(e:GetClass(), name) then
					table.Merge(e, Get(e:GetClass()))

					if isfunction(e.OnReloaded) then
						e:OnReloaded()
					end
				end
			end
		end
	end

	--
	-- All scripts have been loaded...
	--
	function OnLoaded()

		--
		-- Once all the scripts are loaded we can set up the baseclass
		-- - we have to wait until they're all setup because load order
		-- could cause some entities to load before their bases!
		--
		for k in pairs(HUDList) do
			local newTable = Get(k)
			HUDList[k] = newTable

			baseclass.Set(k, newTable)

			for k2 in pairs(newTable.hudmodules) do
				local newTable2 = GetModule(newTable, k2)
				newTable.hudmodules[k2] = newTable2

				baseclass.Set(k2, newTable2)
			end
		end
	end

	--[[---------------------------------------------------------
		Name: Get( string )
		Desc: Get a item by name.
	-----------------------------------------------------------]]
	function GetModule(hud, name, retTbl)
		local Stored = hud.hudmodules[name]
		if not Stored then return end

		-- Create/copy a new table
		local retval = retTbl or {}

		for k, v in pairs(Stored) do
			if istable(v) then
				retval[k] = table.Copy(v)
			else
				retval[k] = v
			end
		end

		retval.Base = retval.Base or "hud_module_base"

		-- If we're not derived from ourselves (a base item)
		-- then derive from our 'Base' item.
		if retval.Base ~= name then
			local base = GetModule(hud, retval.Base)
			if not base then
				Msg("ERROR: Trying to derive HUDModule " .. tostring(name) .. " from non existant HUDModule " .. tostring(retval.Base) .. "!\n")
			else
				retval = TableInherit(retval, base)
			end
		end

		return retval
	end

	--[[---------------------------------------------------------
		Name: Get( string )
		Desc: Get a item by name.
	-----------------------------------------------------------]]
	function Get(name, retTbl)
		local Stored = GetStored(name)
		if not Stored then return end

		-- Create/copy a new table
		local retval = retTbl or {}

		for k, v in pairs(Stored) do
			if istable(v) then
				retval[k] = table.Copy(v)
			else
				retval[k] = v
			end
		end

		retval.Base = retval.Base or "hud_base"

		-- If we're not derived from ourselves (a base item)
		-- then derive from our 'Base' item.
		if retval.Base ~= name then
			local base = Get(retval.Base)

			if not base then
				Msg("ERROR: Trying to derive HUD " .. tostring(name) .. " from non existant HUD " .. tostring(retval.Base) .. "!\n")
			else
				retval = TableInherit(retval, base)
			end
		end

		return retval
	end

	--[[---------------------------------------------------------
		Name: GetStored( string )
		Desc: Gets the REAL item table, not a copy
	-----------------------------------------------------------]]
	function GetStored(name)
		return HUDList[name]
	end

	--[[---------------------------------------------------------
		Name: GetList( string )
		Desc: Get a list of all the registered HUDs
	-----------------------------------------------------------]]
	function GetList()
		local result = {}

		for _, v in pairs(HUDList) do
			result[#result + 1] = v
		end

		return result
	end
end
