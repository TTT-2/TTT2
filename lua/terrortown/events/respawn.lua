--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/respawn")
    EVENT.title = "title_event_respawn"

    function EVENT:GetText()
        return {
            {
                string = "desc_event_respawn",
                params = {
                    player = self.event.nick,
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
    return self.event.nick .. " just respawned."
end
