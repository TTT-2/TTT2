if SERVER then
	AddCSLuaFile()
end

local tableCopy = table.Copy

local eventTypes = {}

events = events or {}
events.list = events.list or {}

EVENT = {}

---
-- Copies any missing data from base table to the target table
-- @param table t target table
-- @param table base base (fallback) table
-- @return table t target table
-- @realm shared
local function TableInherit(tbl, base)
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
	eventTypes[name] = tableCopy(EVENT)
	eventTypes[name].type = name

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

	local newEvent = TableInherit(tableCopy(events.Get(name)), events.Get("base_event"))
	newEvent:Trigger(...)

	events.list[#events.list + 1] = newEvent
end

-- load the events itself
fileloader.LoadFolder("terrortown/gamemode/shared/events/", false, SHARED_FILE, function(path)
	events.Initialize(path)

	MsgN("Added TTT2 event file: ", path)
end)

fileloader.LoadFolder("terrortown/events/", false, SHARED_FILE, function(path)
	events.Initialize(path)

	MsgN("Added TTT2 event file: ", path)
end)
