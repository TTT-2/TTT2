---
-- @class ENT
-- @section ttt_traitor_check

ENT.Type = "brush"
ENT.Base = "base_brush"

if CLIENT then return end

---
-- @realm server
local cv_evil_roles = CreateConVar("ttt2_rolecheck_all_evil_roles", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The rolecheck on maps will always return true for every evil role if enabled")

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

local function VectorInside(vec, mins, maxs)
	return vec.x > mins.x and vec.x < maxs.x
		and vec.y > mins.y and vec.y < maxs.y
		and vec.z > mins.z and vec.z < maxs.z
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

		if not IsValid(ply) or not ply:Alive() or not VectorInside(ply:GetPos(), mins, maxs) then continue end

		---
		-- @realm server
		local plyBaseRole = roles.GetByIndex(hook.Run("TTT2ModifyLogicCheckRole", ply, self, activator, caller, data) or ply:GetSubRole()):GetBaseRole()

		if cv_evil_roles:GetBool() and (plyBaseRole == ROLE_INNOCENT or plyBaseRole == ROLE_DETECTIVE)
			or not cv_evil_roles:GetBool() and (plyBaseRole ~= ROLE_TRAITOR)
		then continue end

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
-- @param Entity ent The entity that is used (either ttt_logic_role` or `ttt_traitor_check`)
-- @param Entity|Player activator The initial cause for the input getting triggered (e.g. the player who pushed a button)
-- @param Entity caller The entity that directly triggered the input (e.g. the button that was pushed)
-- @param string data The data passed
-- @return[default=nil] Return the role of the player that should be used for this check
-- @hook
-- @realm server
function GAMEMODE:TTT2ModifyLogicCheckRole(ply, ent, activator, caller, data)

end
