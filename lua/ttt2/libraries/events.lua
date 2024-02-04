---
-- An event and scoring handler
-- @author Mineotopia
-- @module events

if SERVER then
    AddCSLuaFile()
end

local tableCopy = table.Copy

local eventTypes = {}

events = events or {}
events.list = events.list or {}

---
-- Returns a table of all available events.
-- @return table A table of all events
-- @realm shared
function events.GetAll()
    return eventTypes
end

---
-- Returns the reference to a table of the event.
-- @param string name The name identifier of the event
-- @return table The reference to the event table
-- @realm shared
function events.Get(name)
    return eventTypes[string.lower(name)]
end

---
-- Returns the reference to a copy of the table of the event.
-- @param string name The name identifier of the event
-- @return table The reference to the copied event table
-- @realm shared
function events.Create(name)
    return tableCopy(events.Get(name))
end

---
-- Checks if an event with this ID is registered in the event list.
-- @param string name The name identifier of the event
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

---
-- Returns an event list that is sorted per player and event. This means that the first
-- layer of this table consists of the player steamIDs and the second layer of the
-- event identifiers. The third layer is an idexed list with the references to the events
-- that satisfy the data from the first two layers.
-- @return table A table with the reordered events
-- @realm shared
function events.SortByPlayerAndEvent()
    local eventList = events.list
    local sortedList = {}

    for i = 1, #eventList do
        local event = eventList[i]
        local type = event.type
        local plys64 = event:GetAffectedPlayer64s()

        -- now that we have a list of all players affected by this event
        -- each of those players should have this event added to their list
        for k = 1, #plys64 do
            local ply64 = plys64[k]

            sortedList[ply64] = sortedList[ply64] or {}
            sortedList[ply64][type] = sortedList[ply64][type] or {}

            sortedList[ply64][type][#sortedList[ply64][type] + 1] = event
        end
    end

    return sortedList
end

---
-- Generates an event list in the deprecated format. Only contains
-- events that were present in default TTT. Is sorted by time.
-- @return table The deprecated event list
-- @realm shared
function events.GetDeprecatedEventList()
    local deprecatedEvents = {}

    for i = 1, #events.list do
        local event = events.list[i]
        local deprecatedEventData = event:GetDeprecatedFormat()

        if not deprecatedEventData then
            continue
        end

        deprecatedEvents[#deprecatedEvents + 1] = deprecatedEventData
    end

    return deprecatedEvents
end

---
-- Returns the events in a timed order.
-- @return table The event list.
-- @realm shared
function events.GetEventList()
    return events.list
end

if SERVER then
    ---
    -- Triggers an event, adds it to a managed list and starts the score calculation for this event.
    -- @param string name The name identifier of the event
    -- @param any ... The arguments that should be passed to the event, see the @{EVENT:Trigger} function
    -- @realm server
    function events.Trigger(name, ...)
        if not events.Exist(name) then
            ErrorNoHaltWithStack(
                "[TTT2] ERROR: An event with the name '" .. tostring(name) .. "' does not exist.\n"
            )

            return
        end

        local newEvent = events.Create(name)

        -- only add new event to managed event list, if addition was not aborted
        if not newEvent:Trigger(...) then
            return
        end

        events.list[#events.list + 1] = newEvent

        -- add to deprecated score list
        local deprecatedEventData = newEvent:GetDeprecatedFormat()

        if deprecatedEventData then
            SCORE:AddEvent(deprecatedEventData)
        end

        ---
        -- run a hook with the newly added event
        -- @realm server
        -- stylua: ignore
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
    -- This function is called in @{GM:TTTEndRound} and updates the scores and kills
    -- of every player in the scoreboard.
    -- @internal
    -- @realm server
    function events.UpdateScoreboard()
        local scores = eventdata.GetPlayerTotalScores()
        local deaths = eventdata.GetPlayerTotalDeaths()

        for ply64, score in pairs(scores) do
            ply = player.GetBySteamID64(ply64)

            if not IsValid(ply) or not ply:ShouldScore() then
                continue
            end

            ply:AddFrags(score)
        end

        for ply64, death in pairs(deaths) do
            ply = player.GetBySteamID64(ply64)

            if not IsValid(ply) or not ply:ShouldScore() then
                continue
            end

            ply:AddDeaths(death)
        end
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
    function GM:TTT2OnTriggeredEvent(type, eventData) end

    ---
    -- This hook is called after the event was successfully added to the
    -- eventmanager.
    -- @param string type The type of the event as in `EVENT_XXX`
    -- @param EVENT event The event that was added with all its functions
    -- @realm server
    -- @hook
    function GM:TTT2AddedEvent(type, event) end
else --CLIENT
    net.ReceiveStream("TTT2_EventReport", function(eventStreamData)
        events.Reset()

        for i = 1, #eventStreamData do
            local eventData = eventStreamData[i]

            local newEvent = events.Create(eventData.type)
            newEvent:SetEventTable(eventData.event)
            newEvent:SetScoreTable(eventData.score)
            newEvent:SetKarmaTable(eventData.karma)
            newEvent:SetPlayersTable(eventData.plys64, eventData.plys)

            events.list[i] = newEvent
        end

        CLSCORE:ReportEvents()
    end)
end

local function ShouldInherit(t, base)
    return t.base ~= t.type
end

local function OnInitialization(class, path, name)
    class.type = name
    class.base = class.base or "base_event"

    _G["EVENT_" .. string.upper(name)] = name

    Dev(1, "Added TTT2 event file: ", path, name)
end

eventTypes = classbuilder.BuildFromFolder(
    "terrortown/events/",
    SHARED_FILE,
    "EVENT", -- class scope
    OnInitialization, -- on class loaded
    true, -- should inherit
    ShouldInherit -- special inheritance check
)
