---
-- @module door
-- @author Mineotopia
-- @desc A bunch of functions that handle all doors found on a map

if SERVER then
	AddCSLuaFile()
end

local cvDestructableDoor = CreateConVar("ttt2_destructible_doors_enable", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local cvDestructableDoorLocked = CreateConVar("ttt2_destructible_doors_locked_indestructible", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local cvDestructableDoorForced = CreateConVar("ttt2_destructible_doors_force_pairs", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- DOOR SPAWNFLAG ENUMS
-- @ref https://developer.valvesoftware.com/wiki/prop_door_rotating
-- @ref https://developer.valvesoftware.com/wiki/func_door
-- @ref https://developer.valvesoftware.com/wiki/func_door_rotating

SF_PROP_DOOR_STARTS_OPEN = 1
SF_PROP_DOOR_STARTS_LOCKED = 2048
SF_PROP_DOOR_SILENT_GENERAL = 4096
SF_PROP_DOOR_USE_CLOSES = 8192
SF_PROP_DOOR_SILENT_TO_NPC = 16384
SF_PROP_DOOR_IGNORE_PLAYER_USE = 32768
SF_PROP_DOOR_START_BREAKABLE = 524288

SF_FUNC_DOOR_NON_SOLID_TO_PLAYER = 4
SF_FUNC_DOOR_NON_SOLID_GENERAL = 8
SF_FUNC_DOOR_MODE_TOGGLE = 32
SF_FUNC_DOOR_PLAYER_USE_OPENS = 256
SF_FUNC_DOOR_IGNORE_NPC = 512
SF_FUNC_DOOR_TOUCH_OPENS = 1024
SF_FUNC_DOOR_STARTS_LOCKED = 2048
SF_FUNC_DOOR_SILENT_GENERAL = 4096

door = door or {}

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

local function FindPair(ent)
	local entsTable = ents.FindInSphere(ent:GetPos(), 94)

	for i = 1, #entsTable do
		local foundEnt = entsTable[i]

		if foundEnt == ent or foundEnt:GetClass() ~= ent:GetClass() then continue end

		return foundEnt
	end
end

local function HandleDoorPairs(ent)
	local master = ent:GetInternalVariable("m_hMaster")
	local owner = ent:GetInternalVariable("m_hOwnerEntity")

	local pair

	if IsValid(master) then
		pair = master
	elseif IsValid(owner) then
		pair = owner
	elseif cvDestructableDoorForced:GetBool() then
		pair = FindPair(ent)
	end

	if not IsValid(pair) then return end

	ent.otherPairDoor = pair
	pair.otherPairDoor = ent
end

local function HandleUseCancel(ent)
	ent:EmitSound("doors/door_locked2.wav")
end

local function RemoveSpawnFlag(ent, flag)
	if not ent:HasSpawnFlags(flag) then return end

	ent:SetKeyValue("spawnflags", ent:GetSpawnFlags() - flag)
end

local function AddSpawnFlag(ent, flag)
	if ent:HasSpawnFlags(flag) then return end

	ent:SetKeyValue("spawnflags", ent:GetSpawnFlags() + flag)
end

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
		ent:SetNWBool("ttt2_door_open", door.IsOpen(ent) or false)

		ent:SetNWBool("ttt2_door_player_use", door.PlayerCanUse(ent))
		ent:SetNWBool("ttt2_door_player_touch", door.PlayerCanTouch(ent))
		ent:SetNWBool("ttt2_door_auto_close", door.AutoCloses(ent))
		ent:SetNWBool("ttt2_door_is_destructable", door.IsDestructible(ent))

		entityOutputs.RegisterMapEntityOutput(ent, "OnOpen", "TTT2DoorOpens")
		entityOutputs.RegisterMapEntityOutput(ent, "OnClose", "TTT2DoorCloses")
		entityOutputs.RegisterMapEntityOutput(ent, "OnFullyOpen", "TTT2DoorFullyOpen")
		entityOutputs.RegisterMapEntityOutput(ent, "OnFullyClosed", "TTT2DoorFullyClosed")

		-- handles door pairs, this means double doors will be handles as one
		-- door by the door module to prevent weird problems
		HandleDoorPairs(ent)

		-- makes doors destructible if enabled by convar
		if cvDestructableDoor:GetBool() and not (cvDestructableDoorLocked:GetBool() and ent:IsDoorLocked()) then
			ent:MakeDoorDestructable(true)
		end
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
-- Returns if a passed door class is a valid normal door (prop_door_rotating)
-- @return boolean True if it is a valid normal door
-- @realm shared
function door.IsValidNormal(cls)
	return valid_doors.normal[cls] or false
end

---
-- Returns if a passed door class is a valid special door (func_door, func_door_rotating)
-- @return boolean True if it is a valid special door
-- @realm shared
function door.IsValidSpecial(cls)
	return valid_doors.special[cls] or false
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
	-- Returns if a door is open by reading out the internal variable.
	-- @param Entity ent The door entity that should be checked
	-- @return boolean Returns if the door is open
	-- @internal
	-- @realm server
	function door.IsOpen(ent)
		local cls = ent:GetClass()

		if door.IsValidNormal(cls) then
			return ent:GetInternalVariable("m_eDoorState") ~= 0
		elseif door.IsValidSpecial(cls) then
			return ent:GetInternalVariable("m_toggle_state") == 0
		end

		return false
	end

	---
	-- Returns if a player can use interact with a door by reading out the internal variable.
	-- @param Entity ent The door entity that should be checked
	-- @return boolean Returns if the door reacts to a player use
	-- @internal
	-- @realm server
	function door.PlayerCanUse(ent)
		local cls = ent:GetClass()

		if door.IsValidNormal(cls) then
			return not ent:HasSpawnFlags(SF_PROP_DOOR_IGNORE_PLAYER_USE)
		elseif door.IsValidSpecial(cls) then
			return ent:HasSpawnFlags(SF_FUNC_DOOR_PLAYER_USE_OPENS)
		end

		return false
	end

	---
	-- Returns if touching a door opens it by reading out the internal variable.
	-- @param Entity ent The door entity that should be checked
	-- @return boolean Returns if the door opens by a player touch
	-- @internal
	-- @realm server
	function door.PlayerCanTouch(ent)
		local cls = ent:GetClass()

		if door.IsValidNormal(cls) then
			-- this door type has no touch mode
			return false
		elseif door.IsValidSpecial(cls) then
			return ent:HasSpawnFlags(SF_FUNC_DOOR_TOUCH_OPENS)
		end

		return false
	end

	---
	-- Returns if a door autocloses after some time by reading out the internal variable.
	-- @param Entity ent The door entity that should be checked
	-- @return boolean Returns if the door autocloses after some time
	-- @internal
	-- @realm server
	function door.AutoCloses(ent)
		local cls = ent:GetClass()

		if door.IsValidNormal(cls) then
			return not ent:HasSpawnFlags(SF_PROP_DOOR_USE_CLOSES)
		elseif door.IsValidSpecial(cls) then
			return not ent:HasSpawnFlags(SF_FUNC_DOOR_MODE_TOGGLE)
		end

		return false
	end

	---
	-- Returns if a door is destructible by reading out the internal variable.
	-- @param Entity ent The door entity that should be checked
	-- @return boolean Returns if the door is destructible
	-- @internal
	-- @realm server
	function door.IsDestructible(ent)
		local cls = ent:GetClass()

		if door.IsValidNormal(cls) then
			return ent:HasSpawnFlags(SF_PROP_DOOR_START_BREAKABLE)
		elseif door.IsValidSpecial(cls) then
			return false
		end

		return false
	end

	---
	-- Sets if a player can use interact with a door by setting the internal variable.
	-- @param Entity ent The door entity that should be checked
	-- @param boolean state The new player use state
	-- @internal
	-- @realm server
	function door.SetPlayerCanUse(ent, state)
		local cls = ent:GetClass()

		if door.IsValidNormal(cls) then
			if state then
				RemoveSpawnFlag(ent, SF_PROP_DOOR_IGNORE_PLAYER_USE)
			else
				AddSpawnFlag(ent, SF_PROP_DOOR_IGNORE_PLAYER_USE)
			end
		elseif door.IsValidSpecial(cls) then
			-- 256: use opens
			if state then
				AddSpawnFlag(ent, SF_FUNC_DOOR_PLAYER_USE_OPENS)
			else
				RemoveSpawnFlag(ent, SF_FUNC_DOOR_PLAYER_USE_OPENS)
			end
		end
	end

	---
	-- Sets if a player can touch interact with a door by setting the internal variable.
	-- @param Entity ent The door entity that should be checked
	-- @param boolean state The new player touch state
	-- @internal
	-- @realm server
	function door.SetPlayerCanTouch(ent, state)
		local cls = ent:GetClass()

		if door.IsValidSpecial(cls) then
			-- 1024: touch opens
			if state then
				AddSpawnFlag(ent, SF_FUNC_DOOR_TOUCH_OPENS)
			else
				RemoveSpawnFlag(ent, SF_FUNC_DOOR_TOUCH_OPENS)
			end
		end
	end

	---
	-- Sets if a door autocloses by setting the internal variable.
	-- @param Entity ent The door entity that should be checked
	-- @param boolean state The new autoclose state
	-- @internal
	-- @realm server
	function door.SetAutoClose(ent, state)
		local cls = ent:GetClass()

		if door.IsValidNormal(cls) then
			-- 8192: door closes on use
			if state then
				RemoveSpawnFlag(ent, SF_PROP_DOOR_USE_CLOSES)
				ent:SetKeyValue("returndelay", 3)
			else
				AddSpawnFlag(ent, SF_PROP_DOOR_USE_CLOSES)
			end
		elseif door.IsValidSpecial(cls) then
			if state then
				RemoveSpawnFlag(ent, SF_FUNC_DOOR_MODE_TOGGLE)
			else
				AddSpawnFlag(ent, SF_FUNC_DOOR_MODE_TOGGLE)
			end
		end
	end

	---
	-- Handles the damage of doors that are still in the wall.
	-- Called in @{GM:EntityTakeDamage}.
	-- @param Entity ent The entity that is damages
	-- @param CTakeDamageInfo dmginfo The damage info object
	-- @internal
	-- @realm server
	function door.HandleDamage(ent, dmginfo)
		if not ent:DoorIsDestructible() then return end

		local damage = math.max(0, dmginfo:GetDamage())

		ent:SetHealth(ent:Health() - damage)
		ent:SetNWInt("fast_sync_health", ent:Health())

		if ent:Health() > 0 then return end

		-- capping the force factor is sufficient because
		-- the forward vector is normalizes
		local forceFactor = math.min(50000, 500 * damage)

		ent:SafeDestroyDoor(forceFactor * dmginfo:GetAttacker():GetForward())
	end

	---
	-- Handles the damage of doors that are lying as props on the groudn.
	-- Called in @{GM:EntityTakeDamage}.
	-- @param Entity ent The entity that is damages
	-- @param CTakeDamageInfo dmginfo The damage info object
	-- @internal
	-- @realm server
	function door.HandlePropDamage(ent, dmginfo)
		if not ent.isDoorProp then return end

		ent:SetHealth(ent:Health() - dmginfo:GetDamage())

		if ent:Health() > 0 then return end

		door.HandleDestruction(ent)

		ent:Remove()
	end

	---
	-- Handles the door desctruction particles of a given door.
	-- @param Entity ent The entity that is destroxed
	-- @internal
	-- @realm server
	function door.HandleDestruction(ent)
		ent:EmitSound("physics/wood/wood_crate_break3.wav")

		local effectdata = EffectData()
		effectdata:SetOrigin(ent:GetPos() + ent:OBBCenter())
		effectdata:SetMagnitude(5)
		effectdata:SetScale(2)
		effectdata:SetRadius(5)

		util.Effect("Sparks", effectdata)
	end
end

-- HOOKS AND STUFF
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

		name = string.lower(name)

		-- if there is a SID64 in the data string, it should be extracted
		local sid

		if data and data ~= "" then
			local dataTable = string.Explode("||", data)
			local dataTableCleared = {}

			for i = 1, #dataTable do
				local dataLine = dataTable[i]

				if string.sub(dataLine, 1, 4) == "sid=" then
					sid = string.sub(dataLine, 5)
				else
					dataTableCleared[#dataTableCleared + 1] = dataLine
				end
			end

			data = string.Implode("||", dataTableCleared)
		end

		local ply = player.GetBySteamID64(sid)

		if IsValid(ply) then
			activator = IsValid(activator) and activator or ply
			caller = IsValid(caller) and caller or ply
		end

		-- always play sound if door is locked
		if name == "use" and door.IsValidSpecial(ent:GetClass()) and ent:IsDoorLocked() then
			HandleUseCancel(ent)
		end

		-- handle the entity input types
		if name == "lock" then
			local shouldCancel = hook.Run("TTT2BlockDoorLock", ent, activator, caller)

			if shouldCancel then
				return true
			end

			-- we expect the door to be locked now, but we check the real state after a short
			-- amount of time to be sure
			ent:SetNWBool("ttt2_door_locked", true)

			-- check if the assumed state was correct
			timer.Create("ttt2_recheck_door_lock_" .. ent:EntIndex(), 1, 1, function()
				if not IsValid(ent) then return end

				ent:SetNWBool("ttt2_door_locked", ent:GetInternalVariable("m_bLocked") or false)
			end)
		elseif name == "unlock" then
			local shouldCancel = hook.Run("TTT2BlockDoorUnlock", ent, activator, caller)

			if shouldCancel then
				return true
			end

			-- we expect the door to be unlocked now, but we check the real state after a short
			-- amount of time to be sure
			ent:SetNWBool("ttt2_door_locked", false)

			-- check if the assumed state was correct
			timer.Create("ttt2_recheck_door_unlock_" .. ent:EntIndex(), 1, 1, function()
				if not IsValid(ent) then return end

				ent:SetNWBool("ttt2_door_locked", ent:GetInternalVariable("m_bLocked") or false)
			end)
		elseif name == "use" and ent:IsDoorOpen() then
			-- do not stack closing time if door closes automatically
			if ent:DoorAutoCloses() then
				return true
			end

			local shouldCancel = hook.Run("TTT2BlockDoorClose", ent, activator, caller)

			if shouldCancel then
				HandleUseCancel(ent)

				return true
			end

		elseif name == "use" and not ent:IsDoorOpen() then
			local shouldCancel = hook.Run("TTT2BlockDoorOpen", ent, activator, caller)

			if shouldCancel then
				HandleUseCancel(ent)

				return true
			end
		end
	end

	---
	-- This hook is called after the door started opening.
	-- @param Entity doorEntity The door entity
	-- @param Entity activator The activator entity, it seems to be the door entity for most doors
	-- @hook
	-- @realm server
	function GM:TTT2DoorOpens(doorEntity, activator)
		if not doorEntity:IsDoor() then return end

		doorEntity:SetNWBool("ttt2_door_open", true)
	end

	---
	-- This hook is called after the door finished opening and is fully opened.
	-- @param Entity doorEntity The door entity
	-- @param Entity activator The activator entity, it seems to be the door entity for most doors
	-- @hook
	-- @realm server
	function GM:TTT2DoorFullyOpen(doorEntity, activator)
		if not doorEntity:IsDoor() then return end

		doorEntity:SetNWBool("ttt2_door_open", true)
	end

	---
	-- This hook is called after the door started closing.
	-- @param Entity doorEntity The door entity
	-- @param Entity activator The activator entity, it seems to be the door entity for most doors
	-- @hook
	-- @realm server
	function GM:TTT2DoorCloses(doorEntity, activator)
		if not doorEntity:IsDoor() then return end

		doorEntity:SetNWBool("ttt2_door_open", false)
	end

	---
	-- This hook is called after the door finished closing and is fully closed.
	-- @param Entity doorEntity The door entity
	-- @param Entity activator The activator entity, it seems to be the door entity for most doors
	-- @hook
	-- @realm server
	function GM:TTT2DoorFullyClosed(doorEntity, activator)
		if not doorEntity:IsDoor() then return end

		doorEntity:SetNWBool("ttt2_door_open", false)
	end

	---
	-- This hook is called when the door is about to be locked. You can cancel the event.
	-- @param Entity doorEntity The door entity
	-- @param Entity activator The activator entity
	-- @param Entity caller The caller entity
	-- @return boolean Return true to cancel the door lock
	-- @hook
	-- @realm server
	function GM:TTT2BlockDoorLock(doorEntity, activator, caller)

	end

	---
	-- This hook is called when the door is about to be unlocked. You can cancel the event.
	-- @param Entity doorEntity The door entity
	-- @param Entity activator The activator entity
	-- @param Entity caller The caller entity
	-- @return boolean Return true to cancel the door unlock
	-- @hook
	-- @realm server
	function GM:TTT2BlockDoorUnlock(doorEntity, activator, caller)

	end

	---
	-- This hook is called when the door is about to be opened. You can cancel the event.
	-- @param Entity doorEntity The door entity
	-- @param Entity activator The activator entity
	-- @param Entity caller The caller entity
	-- @return boolean Return true to cancel the door opening
	-- @hook
	-- @realm server
	function GM:TTT2BlockDoorOpen(doorEntity, activator, caller)

	end

	---
	-- This hook is called when the door is about to be closed. You can cancel the event.
	-- @param Entity doorEntity The door entity
	-- @param Entity activator The activator entity
	-- @param Entity caller The caller entity
	-- @return boolean Return true to cancel the door closing
	-- @hook
	-- @realm server
	function GM:TTT2BlockDoorClose(doorEntity, activator, caller)

	end
end
