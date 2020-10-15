if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_finished"
end

if SERVER then
	function EVENT:Trigger(wintype)
		return {
			wintype = wintype
		}
	end
end

function EVENT:GetDeprecatedFormat(event)
	if self.event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		win = event.wintype
	}
end

function EVENT:Serialize()

end
