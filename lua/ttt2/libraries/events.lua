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

---
-- This function is called once an event is loaded from disc.
-- @param string path The path to the event file
-- @internal
-- @realm shared
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

---
-- Initialialized the events after everything is loaded. This included the
-- inheritance from their base classes.
-- @internal
-- @realm shared
function events.OnLoaded()
	for index, event in pairs(eventTypes) do
		eventTypes[index] = TableInherit(event, events.Get(event.base))
	end
end

---
-- Returns a table of all available events.
-- @return table A table of all events
-- @realm shared
function events.GetAll()
	return eventTypes
end

---
-- Returns the reference to a table of the event.
-- @param string name The name identifer of the event
-- @return table The reference to the event table
-- @realm shared
function events.Get(name)
	print(tostring(name))
	return eventTypes[string.lower(name)]
end

---
-- Returns the reference to a copy of the table of the event.
-- @param string name The name identifer of the event
-- @return table The reference to the copied event table
-- @realm shared
function events.New(name)
	return tableCopy(events.Get(name))
end

---
-- Checks if an event with this ID is registered in the event list.
-- @param string name The name identifer of the event
-- @return boolean Returns true if an event of this name exists
-- @realm shared
function events.Exist(name)
	return name and events.Get(name) ~= nil
end

---
-- Resets the managed event list. Usually executed after the end of the round end timer.
-- @internal
-- @realm shared
function events.Reset()
	events.list = {}
end

function events.GetDeprecatedEventData(event)
	if not isfunction(event.GetDeprecatedFormat) then return end

	return event:GetDeprecatedFormat(event.event)
end

function events.GetDeprecatedEventList()
	local deprecatedEvents = {}

	for i = 1, #events.list do
		local event = events.list[i]

		local deprecatedEventData = events.GetDeprecatedEventData(event)

		if not deprecatedEvent then continue end

		deprecatedEvents[#deprecatedEvents + 1] = deprecatedEventData
	end

	return deprecatedEvents
end

if SERVER then
	---
	-- Triggers an event, adds it to a managed list and starts the score calculation for this event.
	-- @param string name The name identifer of the event
	-- @param varag The arguments that should be passed to the event, see the @{EVENT:Trigger} function
	-- @realm server
	function events.Trigger(name, ...)
		if not events.Exist(name) then
			ErrorNoHalt("ERROR: An event with the name '" .. tostring(name) .. "' does not exist.\n")

			return
		end

		local newEvent = events.New(name)
		local eventData = newEvent:Trigger(...)

		-- only add new event to managed event list, if addition was not aborted
		if newEvent:Add(eventData) then
			events.list[#events.list + 1] = newEvent
		end

		-- add to deprecated score list
		local deprecatedEventData = events.GetDeprecatedEventData(newEvent)

		if deprecatedEventData then
			SCORE:AddEvent(deprecatedEventData)
		end

		-- run a hook with the newly added event
		hook.Run("TTT2AddedEvent", name, newEvent)
	end

	---
	-- Streams the whole event table to all clients, usually done after the round ended.
	-- @internal
	-- @realm server
	function events.StreamToClients()
		local eventList = events.list
		local eventStreamData = {}

		for i = 1, #eventList do
			eventStreamData[i] = eventList[i]:GetNetworkedData()
		end

		net.SendStream("TTT2_EventReport", eventStreamData)
	end

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
end

if CLIENT then
	net.ReceiveStream("TTT2_EventReport", function(eventStreamData)
		events.Reset()

		for i = 1, #eventStreamData do
			local eventData = eventStreamData[i]

			local newEvent = events.New(eventData.type)
			newEvent:AddData(eventData.event)

			events.list[#events.list + 1] = newEvent
		end

		-- set old deprecated event table
		local deprecatedEvents = events.GetDeprecatedEventList()

		table.SortByMember(deprecatedEvents, "time", true)
		CLSCORE:ReportEvents(deprecatedEvents)
	end)
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
