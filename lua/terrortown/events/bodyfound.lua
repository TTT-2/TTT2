--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/bodyfound")
    EVENT.title = "title_event_bodyfound"

    function EVENT:GetText()
        local text = {
            {
                string = "desc_event_bodyfound",
                params = {
                    finder = self.event.finder.nick,
                    found = self.event.found.nick,
                    firole = roles.GetByIndex(self.event.finder.role).name,
                    fiteam = self.event.finder.team,
                    forole = roles.GetByIndex(self.event.found.role).name,
                    foteam = self.event.found.team,
                    credits = self.event.found.credits,
                },
                translateParams = true,
            },
        }

        if self.event.found.headshot then
            text[2] = {
                string = "desc_event_bodyfound_headshot",
            }
        end

        return text
    end
end

if SERVER then
    function EVENT:Trigger(finder, rag)
        self:AddAffectedPlayers(
            { finder:SteamID64(), CORPSE.GetPlayerSID64(rag) },
            { finder:Nick(), CORPSE.GetPlayerNick(rag, "A Terrorist") }
        )

        return self:Add({
            finder = {
                nick = finder:Nick(),
                sid64 = finder:SteamID64(),
                role = finder:GetSubRole(),
                team = finder:GetTeam(),
            },
            found = {
                nick = CORPSE.GetPlayerNick(rag, "A Terrorist"),
                sid64 = CORPSE.GetPlayerSID64(rag),
                role = CORPSE.GetPlayerRole(rag),
                team = CORPSE.GetPlayerTeam(rag),
                credits = CORPSE.GetCredits(rag, 0),
                headshot = CORPSE.WasHeadshot(rag) or false,
                time = math.Round(
                    (CORPSE.GetPlayerDeathTime(rag) - gameloop.timeRoundStart) * 1000,
                    0
                ),
            },
        })
    end

    function EVENT:CalculateScore()
        local event = self.event
        local finder = event.finder

        self:SetPlayerScore(finder.sid64, {
            score = roles.GetByIndex(finder.role).score.bodyFoundMuliplier,
        })
    end
end

function EVENT:Serialize()
    return self.event.finder.nick .. " has found the body of " .. self.event.found.nick .. "."
end

function EVENT:GetDeprecatedFormat()
    local event = self.event

    if event.roundState ~= ROUND_ACTIVE then
        return
    end

    local finder = event.finder
    local found = event.found

    return {
        id = self.type,
        t = event.time / 1000,
        ni = finder.nick,
        sid64 = finder.sid64,
        r = finder.role,
        tm = finder.team,
        b = found.nick,
    }
end
