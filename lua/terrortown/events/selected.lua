--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/selected")
    EVENT.title = "title_event_selected"

    function EVENT:GetText()
        return {
            {
                string = "desc_event_selected",
                params = {
                    amount = #self.event.plys,
                },
            },
        }
    end
end

if SERVER then
    function EVENT:Trigger()
        local event = {
            plys = {},
        }
        local eventPlys = event.plys
        local plys = player.GetAll()

        for i = 1, #plys do
            local ply = plys[i]

            eventPlys[i] = {
                nick = ply:Nick(),
                sid64 = ply:SteamID64(),
                role = ply:GetSubRole(),
                team = ply:GetTeam(),
            }

            self:AddAffectedPlayers({ ply:SteamID64() }, { ply:Nick() })
        end

        return self:Add(event)
    end
end

function EVENT:Serialize()
    return "The roles have been selected."
end

function EVENT:GetDeprecatedFormat()
    local event = self.event

    if event.roundState ~= ROUND_ACTIVE then
        return
    end

    local eventRoles, eventTeams = {}, {}

    for i = 1, #event.plys do
        local ply = event.plys[i]

        local subrole = ply.role
        local team = ply.team

        eventRoles[subrole] = eventRoles[subrole] or {}
        eventRoles[subrole][#eventRoles[subrole] + 1] = ply.sid64

        if team ~= TEAM_NONE then
            eventTeams[team] = eventTeams[team] or {}
            eventTeams[team][#eventTeams[team] + 1] = ply.sid64
        end
    end

    return {
        id = self.type,
        t = event.time / 1000,
        rt = eventRoles,
        tms = eventTeams,
    }
end
