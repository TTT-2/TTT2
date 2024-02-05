--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/rolechange")
    EVENT.title = "title_event_rolechange"

    function EVENT:GetText()
        return {
            {
                string = "desc_event_rolechange",
                params = {
                    player = self.event.nick,
                    orole = roles.GetByIndex(self.event.oldRole).name,
                    oteam = self.event.oldTeam,
                    nrole = roles.GetByIndex(self.event.newRole).name,
                    nteam = self.event.newTeam,
                },
                translateParams = true,
            },
        }
    end
end

if SERVER then
    function EVENT:Trigger(ply, oldRole, newRole, oldTeam, newTeam)
        -- do not trigger events if the role or team is nil
        if not oldRole or not newRole or not oldTeam or not newTeam then
            return
        end

        self:AddAffectedPlayers({ ply:SteamID64() }, { ply:Nick() })

        return self:Add({
            nick = ply:Nick(),
            sid64 = ply:SteamID64(),
            oldRole = oldRole,
            newRole = newRole,
            oldTeam = oldTeam,
            newTeam = newTeam,
        })
    end
end

function EVENT:Serialize()
    return self.event.nick .. " just changed their tole."
end
