ENT.Type = "point"
ENT.Base = "base_point"

function ENT:AcceptInput(name, activator, caller)
	if name == "TraitorWin" then
		GAMEMODE:MapTriggeredEnd(WIN_ROLE, ROLE_TRAITOR)
	  
		return true
	elseif name == "InnocentWin" then
		GAMEMODE:MapTriggeredEnd(WIN_ROLE, ROLE_INNOCENT)
	  
		return true
	end
end
