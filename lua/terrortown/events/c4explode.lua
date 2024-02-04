--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/c4explode")
    EVENT.title = "title_event_c4_explode"

    function EVENT:GetText()
        return {
            {
                string = "desc_event_c4_explode",
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
    function EVENT:Trigger(owner)
        self:AddAffectedPlayers({ owner:SteamID64() }, { owner:Nick() })

        return self:Add({
            nick = owner:Nick(),
            sid64 = owner:SteamID64(),
            role = owner:GetSubRole(),
            team = owner:GetTeam(),
        })
    end
end

function EVENT:Serialize()
    return "The C4 charge placed by " .. self.event.nick .. " exploded."
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
