---
-- @class ENT
-- @section GameText

ENT.Type = "point"
ENT.Base = "base_point"

ENT.Message = ""
ENT.Color = COLOR_WHITE

local RECEIVE_ACTIVATOR = 0
local RECEIVE_ALL = 1
local RECEIVE_DETECTIVE = 2
local RECEIVE_TRAITOR = 3
local RECEIVE_INNOCENT = 4
local RECEIVE_CUSTOMROLE = 5

ENT.Receiver = RECEIVE_ACTIVATOR

---
-- @param string key
-- @param string|number value
-- @realm shared
function ENT:KeyValue(key, value)
    if key == "message" then
        self.Message = tostring(value) or "ERROR: bad value"
    elseif key == "color" then
        local mr, mg, mb = string.match(value, "(%d*) (%d*) (%d*)")

        self.Color = Color(tonumber(mr) or 255, tonumber(mg) or 255, tonumber(mb) or 255)
    elseif key == "receive" then
        self.teamReceiver = nil

        if isstring(value) and _G[value] then
            self.teamReceiver = _G[value]
            value = RECEIVE_CUSTOMROLE
        end

        self.Receiver = tonumber(value)

        if not self.Receiver or self.Receiver < 0 or self.Receiver > 5 then
            ErrorNoHalt("ERROR: ttt_game_text has invalid inputReceiver value\n")

            self.Receiver = RECEIVE_ACTIVATOR
        end
    end
end

---
-- @param string name
-- @param Entity|Player activator
-- @return[default=true] boolean
-- @realm shared
function ENT:AcceptInput(name, activator)
    if name ~= "Display" then
        return false
    end

    local inputReceiver = self.Receiver
    local messageReceiver = activator

    if inputReceiver == RECEIVE_ALL then
        messageReceiver = nil
    elseif inputReceiver == RECEIVE_DETECTIVE then
        messageReceiver = GetRoleChatFilter(ROLE_DETECTIVE)
    elseif inputReceiver == RECEIVE_TRAITOR then
        messageReceiver = GetTeamChatFilter(TEAM_TRAITOR)
    elseif inputReceiver == RECEIVE_INNOCENT then
        -- TTT originally defined this as "All except traitors" even though it is labeled as "RECEIVE_INNOCENT",
        -- but the implementation literally only checked that a player was not a traitor, therefore the intent is
        -- preserved here since maps aren't likely to be updated
        messageReceiver = GetPlayerFilter(function(p)
            local plyRoleData = p:GetSubRoleData()
            return p:GetTeam() ~= TEAM_TRAITOR and not plyRoleData.disabledTeamChatRecv
        end)
    elseif inputReceiver == RECEIVE_ACTIVATOR then
        if not IsValid(activator) or not activator:IsPlayer() then
            ErrorNoHalt("ttt_game_text tried to show message to invalid !activator\n")

            return true
        end
    elseif inputReceiver == RECEIVE_CUSTOMROLE and self.teamReceiver then
        messageReceiver = GetTeamChatFilter(self.teamReceiver)
    end

    CustomMsg(messageReceiver, self.Message, self.Color)

    return true
end
