EVENT.event = {}
EVENT.type = "base_event"

function EVENT:Add(event)
	event.time = math.Round((CurTime() - GAMEMODE.RoundStartTime) * 1000, 0)

	self.event = event

	PrintTable(self.event)
end

function EVENT:GetNetworkedData()
	return {
		type = self.type,
		event = self.event
	}
end
