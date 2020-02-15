--- DOORS MODULE STUFF ---

---
-- @module door
-- @author Mineotopia
-- @desc A bunch of functions that handle all doors found on a map

local door_list = {
	doors = {}
}

local valid_doors = {
	special = {
		["func_door"] = true,
		["func_door_rotating"] = true
	},
	normal = {
		["prop_door_rotating"] = true
	}
}

door = {}

---
-- Setting up all doors found on a map, this is done on every map reset (on prepare round)
-- @internal
-- @realm shared
function door.SetUp()
	local all_ents = ents.GetAll()
	local doors = {}

	-- search for new doors
	for i = 1, #all_ents do
		local ent = all_ents[i]

		if not ent:IsDoor() then continue end

		doors[#doors + 1] = ent

		-- set up synced states if on server
		if CLIENT then continue end

		ent:SetNWBool("ttt2_door_locked", ent:GetInternalVariable("m_bLocked") or false)
		ent:SetNWBool("ttt2_door_forceclosed", ent:GetInternalVariable("forceclosed") or false)
		ent:SetNWBool("ttt2_door_open", ent:InternalIsDoorOpen() or false)
	end

	door_list.doors = doors
end

---
-- Returns all valid door entity class names
-- @return table A table of door class names
-- @realm shared
function door.GetValid()
	return valid_doors
end

---
-- Returns all valid door entities found on a map
-- @return table A table of door entities
-- @realm shared
function door.GetAll()
	return door_list.doors
end

if SERVER then
	---
	-- Called when a map I/O event occurs.
	-- @param Entity ent Entity that receives the input
	-- @param string input The input name. Is not guaranteed to be a valid input on the entity.
	-- @param Entity activator Activator of the input
	-- @param Entity caller Caller of the input
	-- @param any data Data provided with the input
	-- @return boolean Return true to prevent this input from being processed.
	-- @ref https://wiki.facepunch.com/gmod/GM:AcceptInput
	-- @hook
	-- @realm server
	function GM:AcceptInput(ent, name, activator, caller, data)
		if not IsValid(ent) or not ent:IsDoor() then return end

		if name == "lock" then
			-- we expect the door to be locked now, but we check the real state after a short
			-- amount of time to be sure
			ent:SetNWBool("ttt2_door_locked", true)

			-- check if the assumed state was correct
			timer.Create("ttt2_recheck_door_lock_" .. ent:EntIndex(), 1, 1, function()
				if not IsValid(ent) then return end

				ent:SetNWBool("ttt2_door_locked", ent:GetInternalVariable("m_bLocked") or false)
			end)
		elseif name == "unlock" then
			-- we expect the door to be unlocked now, but we check the real state after a short
			-- amount of time to be sure
			ent:SetNWBool("ttt2_door_locked", false)

			-- check if the assumed state was correct
			timer.Create("ttt2_recheck_door_unlock_" .. ent:EntIndex(), 1, 1, function()
				if not IsValid(ent) then return end

				ent:SetNWBool("ttt2_door_locked", ent:GetInternalVariable("m_bLocked") or false)
			end)
		elseif name == "Use" then
			-- do not change state if door is locked
			if ent:IsDoorLocked() then return end

			-- do not change state if door autocloses and is currently transitioning
			if ent:DoorIsTransitioning() and door.GetValid().special[ent:GetClass()] then return end

			-- upon triggering the state change of the door, the state does not change
			-- instanly but after the animation finished. Therefore we calculate an assumned
			-- value on the fly and check the real state a few seconds later

			ent:SetNWBool("ttt2_door_open", not ent:GetNWBool("ttt2_door_open", false))

			-- Check if the assumed state was correct
			-- This is a bit tricky here: doors have an animation time, therefore we have
			-- to recheck a triggered time to make sure their state is correct
			timer.Create("ttt2_recheck_door_use_" .. ent:EntIndex(), 0.25, 50, function()
				-- only recheck door if it is valid, not locked and not transitioning
				if not IsValid(ent) or ent:IsDoorLocked() or ent:DoorIsTransitioning() then return end

				-- update door state
				ent:SetNWBool("ttt2_door_open", ent:InternalIsDoorOpen() or false)

				-- remove timer since transition is now stopped
				timer.Remove("ttt2_recheck_door_use_" .. ent:EntIndex())
			end)
		end
	end
end


--- ENTITY EXTENSION STUFF ---

---
-- @module Entity
-- @author Mineotopia
-- @ref https://wiki.facepunch.com/gmod/Entity
-- @desc shared extensions to entity table

local entmeta = assert(FindMetaTable("Entity"), "FAILED TO FIND ENTITY TABLE")

---
-- Returns whether this entity is a door or not
-- @return boolean Returns true if it is a valid door
-- @realm shared
function entmeta:IsDoor()
	local cls = self:GetClass()
	local valid = door.GetValid()

	if IsValid(self) and (valid.normal[cls] or valid.special[cls]) then
		return true
	end

	return false
end

---
-- Returns the lock state of a door
-- @return boolean The door state; true: locked, false: unlocked, nil: no valid door
-- @realm shared
function entmeta:IsDoorLocked()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_locked", false)
end

---
-- Returns if a door is forceclosed, traitor room doors for example are forceclosed
-- @return boolean The door state; true: forceclosed, false: not forceclosed, nil: no valid door
-- @realm shared
function entmeta:IsDoorForceclosed()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_forceclosed", false)
end

---
-- Returns if this door can be opened with the use key, traitor room doors or doors
-- opened with a button press can't be opened with the use key
-- @return boolean If the door can be opened with the use key
-- @realm shared
function entmeta:UseOpensDoor()
	if not self:IsDoor() then return end

	return not door.GetValid().special[self:GetClass()] or not self:IsDoorForceclosed()
end

---
-- Returns if a door is open
-- @return boolean The door state; true: open, false: close, nil: no valid door
-- @realm shared
function entmeta:IsDoorOpen()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_open", false)
end

if SERVER then
	---
	-- Locks/unlocks an entity if it is a door
	-- @param boolean door_state Should the door be locked
	-- @realm server
	function entmeta:LockDoor(door_state)
		if not self:IsDoor() then return end

		if state then
			self:Fire("lock", "", 0)
		else
			self:Fire("unlock", "", 0)
		end
	end

	---
	-- Returns if a door is open
	-- @return boolean The door state; true: open, false: close, nil: no valid door
	-- @internal
	-- @realm server
	function entmeta:InternalIsDoorOpen()
		if not self:IsDoor() then return end

		local cls = self:GetClass()

		if cls == "func_door" or cls == "func_door_rotating" then
			return self:GetInternalVariable("m_toggle_state") == 0
		elseif cls == "prop_door_rotating" then
			return self:GetInternalVariable("m_eDoorState") ~= 0
		end
	end

	---
	-- Returns if a door autocloses after a given time
	-- @return boolean If the door autocloses
	-- @realm server
	function entmeta:DoesAutoClose()
		if not self:IsDoor() then return end

		return self:GetInternalVariable("m_flMoveDoneTime") ~= -1
	end

	---
	-- Returns if a door is currently transitioning between beeing opened and closed
	-- @return boolean The door state; true: open, false: close, nil: no valid door
	-- @realm server
	function entmeta:DoorIsTransitioning()
		if not self:IsDoor() then return end

		local cls = self:GetClass()

		if cls == "func_door" or cls == "func_door_rotating" then
			-- some doors have an auto-close feature
			if self:DoesAutoClose() and self:GetInternalVariable("m_toggle_state") == 0 then
				return true
			end

			return self:GetInternalVariable("m_toggle_state") == 2 or self:GetInternalVariable("m_toggle_state") == 3
		elseif cls == "prop_door_rotating" then
			-- some doors have an auto-close feature
			if self:DoesAutoClose() and self:GetInternalVariable("m_eDoorState") == 2 then
				return true
			end

			return self:GetInternalVariable("m_eDoorState") == 1 or self:GetInternalVariable("m_eDoorState") == 3
		end
	end
end
