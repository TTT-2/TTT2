--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/c4plant")
    EVENT.title = "title_event_c4_plant"

    function EVENT:GetText()
        return {
            {
                string = "desc_event_c4_plant",
                params = {
                    owner = self.event.nick,
                    role = roles.GetByIndex(self.event.role).name,
                    team = self.event.team,
                },
                translateParams = true,
            },
        }
    end
end

if SERVER then
    function EVENT:Trigger(planter)
        self:AddAffectedPlayers({ planter:SteamID64() }, { planter:Nick() })

        return self:Add({
            nick = planter:Nick(),
            sid64 = planter:SteamID64(),
            role = planter:GetSubRole(),
            team = planter:GetTeam(),
        })
    end
end

function EVENT:Serialize()
    return self.event.nick .. " placed a new C4 charge."
end

function EVENT:GetDeprecatedFormat()
    local event = self.event

    if event.roundState ~= ROUND_ACTIVE then
        return
    end

    return {
        id = self.type,
        t = event.time / 1000,
        ni = event.nick,
    }
end
