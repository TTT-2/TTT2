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

function events.Initialize(path)
	local pathArray = string.Split(path, "/")
	local name = string.lower(string.sub(pathArray[#pathArray], 0, -5))

	-- event table is set in fileloader and can now be inserted in the table
	local newEvent = tableCopy(EVENT)
	newEvent.type = name
	newEvent.base = newEvent.base or "base_event"

	eventTypes[name] = newEvent

	-- store a global identifier for this event
	_G["EVENT_" .. string.upper(name)] = name

	-- reset EVENT table
	EVENT = {}
end

function events.OnLoaded()
	for index, event in pairs(eventTypes) do
		eventTypes[index] = TableInherit(event, events.Get(event.base))
	end
end

function events.GetAll()
	return eventTypes
end

function events.Get(name)
	return eventTypes[string.lower(name)]
end

function events.Trigger(name, ...)
	local newEvent = tableCopy(events.Get(name))
	local eventData = newEvent:Trigger(...)

	-- only add new event to managed event list, if addition was not aborted
	if newEvent:Add(eventData) then
		events.list[#events.list + 1] = newEvent
	end

	PrintTable(newEvent)

	-- run a hook with the newly added event
	hook.Run("TTT2AddedEvent", name, newEvent)
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

---
-- This hook is called once an event occured, the data is processed
-- and it is about to be added. This hook can be used to modify the data
-- or to cancel the event by returning `false`.
-- @param string type The type of the event as in `EVENT_XXX`
-- @param table eventData The table with the event data
-- @return boolean Return false to cancel the addition of this event
-- @realm server
-- @hook
function GM:TTT2OnTriggeredEvent(type, eventData)

end

---
-- This hook is called after the event was successfully added to the
-- eventmanager.
-- @param string type The type of the event as in `EVENT_XXX`
-- @param EVENT event The event that was added with all its functions
-- @realm server
-- @hook
function GM:TTT2AddedEvent(type, event)

end
