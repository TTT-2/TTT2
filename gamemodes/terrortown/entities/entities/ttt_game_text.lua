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
			ErrorNoHalt("ERROR: ttt_game_text has invalid receiver value\n")

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

	if IsValid(activator) and activator:IsPlayer() then
		local recv = activator
		local receiver_tbl = {
			RECEIVE_ALL = nil,
			RECEIVE_DETECTIVE = GetRoleChatFilter(ROLE_DETECTIVE),
			RECEIVE_TRAITOR = GetRoleChatFilter(TEAM_TRAITOR),
			RECEIVE_INNOCENT = GetRoleChatFilter(TEAM_INNOCENT)
		}

		recv = (self.teamReceiver) and GetTeamChatFilter(self.teamReceiver) or receiver_tbl[self.Receiver]
		CustomMsg(recv, self.Message, self.Color)

		recv = nil
		receiver_tbl = nil

		return true
	end

	ErrorNoHalt("ttt_game_text tried to show message to invalid !activator\n")
	return false -- either invalid activator or activator was not a player
end
