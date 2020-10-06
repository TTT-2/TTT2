if SERVER then
	AddCSLuaFile()
end

events = events or {}
EVENT = {}

local eventTypes = {}

---
-- Copies any missing data from base table to the target table
-- @param table t target table
-- @param table base base (fallback) table
-- @return table t target table
-- @realm shared
local function TableInherit(tbl, base)
	if not base then
		return tbl
	end

	for k, v in pairs(base) do
		if tbl[k] ~= nil then continue end

		tbl[k] = v
	end

	return tbl
end

function events.Initialize(path)
	local pathArray = string.Split(path, "/")
	local name = string.lower(string.sub(pathArray[#pathArray], 0, -5))

	-- event table is set in fileloader and can now be inserted in the table
	eventTypes[name] = TableInherit(table.Copy(EVENT), events.Get("base_class"))

	-- store a global identifier for this event
	_G["EVENT_" .. string.upper(name)] = name

	-- reset EVENT table
	EVENT = {}
end

function events.GetAll()
	return eventTypes
end

function events.Get(name)
	return eventTypes[string.lower(name)]
end

function events.Trigger(name, ...)
	if hook.Run("TTT2TriggeredEvent", name, ...) == false then return end

	events.Get(name):Trigger(...)
end

-- load the events itself
fileloader.LoadFolder("terrortown/gamemode/shared/events/base/", false, SHARED_FILE, function(path)
	events.Initialize(path)

	MsgN("Added TTT2 event file: ", path)
end)

fileloader.LoadFolder("terrortown/gamemode/shared/events/", false, SHARED_FILE, function(path)
	events.Initialize(path)

	MsgN("Added TTT2 event file: ", path)
end)

fileloader.LoadFolder("terrortown/events/", false, SHARED_FILE, function(path)
	events.Initialize(path)

	MsgN("Added TTT2 event file: ", path)
end)
