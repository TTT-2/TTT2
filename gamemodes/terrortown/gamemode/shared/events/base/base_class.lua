EVENT.list = {}

function EVENT:Add(event)
	event.time = math.Round((CurTime() - GAMEMODE.RoundStartTime) * 1000, 0)

	self.list[#self.list + 1] = event

	PrintTable(self.list[#self.list])
end

function EVENT:Get(id)
	return self.list[id]
end

function EVENT:GetAll()
	return self.list
end

function EVENT:Reset()
	self.list = {}
end
