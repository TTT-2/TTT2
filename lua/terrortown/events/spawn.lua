--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/spawn")
    EVENT.title = "title_event_spawn"

    function EVENT:GetText()
        return {
            {
                string = "desc_event_spawn",
                params = {
                    player = self.event.finder.nick,
                },
            },
        }
    end
end

if SERVER then
    function EVENT:Trigger(ply)
        self:AddAffectedPlayers({ ply:SteamID64() }, { ply:Nick() })

        return self:Add({
            nick = ply:Nick(),
            sid64 = ply:SteamID64(),
        })
    end
end

function EVENT:Serialize()
    return self.event.nick .. " just spawned."
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
        sid64 = event.sid64,
    }
end
