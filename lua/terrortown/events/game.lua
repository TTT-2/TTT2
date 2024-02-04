--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/game")
    EVENT.title = "title_event_game"

    function EVENT:GetText()
        return {
            {
                string = "desc_event_game",
            },
        }
    end
end

if SERVER then
    function EVENT:Trigger(roundstate)
        return self:Add({
            newstate = roundstate,
        })
    end
end

function EVENT:Serialize()
    return "A new round has started."
end

function EVENT:GetDeprecatedFormat()
    local event = self.event

    if event.roundState ~= ROUND_ACTIVE then
        return
    end

    return {
        id = self.type,
        t = event.time / 1000,
        state = event.newstate,
    }
end
