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

function ENT:KeyValue(key, value)
	if key == "message" then
		self.Message = tostring(value) or "ERROR: bad value"
	elseif key == "color" then
		local mr, mg, mb = string.match(value, "(%d*) (%d*) (%d*)")

		self.Color = Color(tonumber(mr) or 255, tonumber(mg) or 255, tonumber(mb) or 255)
	elseif key == "receive" then
		self.Receiver = tonumber(value)

		if not self.Receiver or self.Receiver < 0 or self.Receiver > 4 then
			ErrorNoHalt("ERROR: ttt_game_text has invalid receiver value\n")

			self.Receiver = RECEIVE_ACTIVATOR
		end
	end
end

function ENT:AcceptInput(name, activator)
	if name == "Display" then
		local recv = activator

		local r = self.Receiver
		if r == RECEIVE_ALL then
			recv = nil
		elseif r == RECEIVE_DETECTIVE then
			recv = GetRoleFilter(ROLE_DETECTIVE)
		elseif r == RECEIVE_TRAITOR then
			recv = GetTeamFilter(TEAM_TRAITOR)
		elseif r == RECEIVE_INNOCENT then
			recv = GetTeamFilter(TEAM_INNOCENT)
		elseif r == RECEIVE_ACTIVATOR then
			if not IsValid(activator) or not activator:IsPlayer() then
				ErrorNoHalt("ttt_game_text tried to show message to invalid !activator\n")

				return true
			end
		elseif r == RECEIVE_CUSTOMROLE and self.teamReceiver then
			recv = GetTeamFilter(self.teamReceiver)
		end

		CustomMsg(recv, self.Message, self.Color)

		return true
	end
end
