---
-- @class ENT
-- @section ttt_traitor_check

ENT.Type = "brush"
ENT.Base = "base_brush"

if CLIENT then
    return
end

---
-- Called when the engine sets a value for this scripted entity.
-- @param string key The key that was affected
-- @param string value The new value
-- @realm server
function ENT:KeyValue(key, value)
    if key == "TraitorsFound" then
        -- this is our output, so handle it as such
        self:StoreOutput(key, value)
    end
end

---
-- Counts the amount of evil players inside the entity
-- @param Entity|Player activator The initial cause for the input getting triggered
-- @param Entity caller The entity that directly triggered the input
-- @param string data The data passed
-- @return[default=0] number The amount of evil valid players found
-- @realm server
function ENT:CountValidPlayers(activator, caller, data)
    local mins = self:LocalToWorld(self:OBBMins())
    local maxs = self:LocalToWorld(self:OBBMaxs())

    local plys = player.GetAll()
    local count = 0

    for i = 1, #plys do
        local ply = plys[i]

        -- only count if it is a valid player that is in range
        if
            not IsValid(ply)
            or not ply:Alive()
            or not util.VectorInBounds(ply:GetPos(), mins, maxs)
        then
            continue
        end

        ---
        -- @realm server
        local _, team = hook.Run("TTT2ModifyLogicRoleCheck", ply, self, activator, caller, data)

        -- only count if it is a evil role
        if not util.IsEvilTeam(team) then
            continue
        end

        count = count + 1
    end

    return count
end

---
-- Called when another entity fires an event to this entity.
-- @param string name The name of the input that was triggered
-- @param Entity|Player activator The initial cause for the input getting triggered (e.g. the player who pushed a button)
-- @param Entity caller The entity that directly triggered the input (e.g. the button that was pushed)
-- @param string data The data passed
-- @return[default=true] boolean Return true if the default action should be supressed
-- @realm server
function ENT:AcceptInput(name, activator, caller, data)
    if name == "CheckForTraitor" then
        local traitorCount = self:CountValidPlayers(activator, caller, data)

        self:TriggerOutput("TraitorsFound", activator, traitorCount)

        return true
    end
end

---
-- A hook that is called when either the `ttt_logic_role` or `ttt_traitor_check` entity
-- is triggered from the map. This hook can be used to modify the role used by the
-- check on the map.
-- @param Player ply The player whose role is checked
-- @param Entity ent The entity that is used (either `ttt_logic_role` or `ttt_traitor_check`)
-- @param Entity|Player activator The initial cause for the input getting triggered (e.g. the player who pushed a button)
-- @param Entity caller The entity that directly triggered the input (e.g. the button that was pushed)
-- @param string data The data passed
-- @return Return the role of the player that should be used for this check
-- @return Return the team of the player that should be used for this check
-- @hook
-- @realm server
function GAMEMODE:TTT2ModifyLogicRoleCheck(ply, ent, activator, caller, data)
    return ply:GetBaseRole(), ply:GetTeam()
end
