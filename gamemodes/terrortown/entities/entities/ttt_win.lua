---
-- @class ENT
-- @section ttt_win

ENT.Type = "point"
ENT.Base = "base_point"

local string = string

---
-- @param string name
-- @param Entity|Player activator
-- @param Entity|Player caller
-- @return[default=true] boolean
-- @realm shared
function ENT:AcceptInput(name, activator, caller)
    if name == "TraitorWin" then
        GAMEMODE:MapTriggeredEnd(WIN_TRAITOR)

        return true
    elseif name == "InnocentWin" then
        GAMEMODE:MapTriggeredEnd(WIN_INNOCENT)

        return true
    elseif string.len(name) > 3 and string.sub(name, -3) == "Win" then
        name = "TEAM_" .. string.upper(string.sub(name, 1, -4))

        if TEAMS[name] then
            GAMEMODE:MapTriggeredEnd(name)

            return true
        end
    end
end
