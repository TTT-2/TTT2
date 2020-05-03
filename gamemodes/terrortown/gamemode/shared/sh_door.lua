--- LOCAL DOOR RELATED STUFF ---

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

local function RemoveSpawnFlag(ent, flag)
	if CLIENT then return end

	if not ent:HasSpawnFlags(flag) then return end

	ent:SetKeyValue("spawnflags", ent:GetSpawnFlags() - flag)
end

local function AddSpawnFlag(ent, flag)
	if CLIENT then return end

	if ent:HasSpawnFlags(flag) then return end

	ent:SetKeyValue("spawnflags", ent:GetSpawnFlags() + flag)
end

-- Returns if a door is open
local function IsDoorOpen(ent)
	if CLIENT then return end

	local cls = ent:GetClass()

	if door.IsValidNormal(cls) then
		return ent:GetInternalVariable("m_eDoorState") ~= 0
	elseif door.IsValidSpecial(cls) then
		return ent:GetInternalVariable("m_toggle_state") == 0
	end

	return false
end

-- Returns if a player can interact with a door
local function PlayerCanUseDoor(ent)
	if CLIENT then return end

	local cls = ent:GetClass()

	if door.IsValidNormal(cls) then
		-- 32768: ignore player +use
		return not ent:HasSpawnFlags(32768)
	elseif door.IsValidSpecial(cls) then
		-- 256: use opens
		return ent:HasSpawnFlags(256)
	end

	return false
end

-- Returns if touching a door opens it
local function PlayerCanTouchDoor(ent)
	if CLIENT then return end

	local cls = ent:GetClass()

	if door.IsValidNormal(cls) then
		-- this door type has no touch mode
		return false
	elseif door.IsValidSpecial(cls) then
		-- 1024: touch opens
		return ent:HasSpawnFlags(1024)
	end

	return false
end

-- Returns if a door autocloses after some time
local function DoorAutoCloses(ent)
	if CLIENT then return end

	local cls = ent:GetClass()

	if door.IsValidNormal(cls) then
		-- 8192: door closes on use
		return not ent:HasSpawnFlags(8192)
	elseif door.IsValidSpecial(cls) then
		-- 32: door is in toggle mode
		return not ent:HasSpawnFlags(32)
	end

	return false
end

local function DoorIsDestructible(ent)
	if CLIENT then return end

	local cls = ent:GetClass()

	if door.IsValidNormal(cls) then
		-- 524288 : Start Breakable
		return ent:HasSpawnFlags(524288)
	elseif door.IsValidSpecial(cls) then
		return false
	end

	return false
end

local function SetPlayerCanUseDoor(ent, state)
	if CLIENT then return end

	local cls = ent:GetClass()

	if door.IsValidNormal(cls) then
		-- 32768: ignore player +use
		if state then
			RemoveSpawnFlag(ent, 32768)
		else
			AddSpawnFlag(ent, 32768)
		end
	elseif door.IsValidSpecial(cls) then
		-- 256: use opens
		if state then
			AddSpawnFlag(ent, 256)
		else
			RemoveSpawnFlag(ent, 256)
		end
	end
end

local function SetPlayerCanTouchDoor(ent, state)
	if CLIENT then return end

	local cls = ent:GetClass()

	if door.IsValidSpecial(cls) then
		-- 1024: touch opens
		if state then
			AddSpawnFlag(ent, 1024)
		else
			RemoveSpawnFlag(ent, 1024)
		end
	end
end

local function SetDoorAutoCloses(ent, state)
	if CLIENT then return end

	local cls = ent:GetClass()

	if door.IsValidNormal(cls) then
		-- 8192: door closes on use
		if state then
			RemoveSpawnFlag(ent, 8192)
			ent:SetKeyValue("returndelay", 3)
		else
			AddSpawnFlag(ent, 8192)
		end
	elseif door.IsValidSpecial(cls) then
		-- 32: door is in toggle mode
		if state then
			RemoveSpawnFlag(ent, 32)
		else
			AddSpawnFlag(ent, 32)
		end
	end
end

local function HandleDoorDestruction(ent)
	if CLIENT then return end

	ent:EmitSound("physics/wood/wood_crate_break3.wav")

	local effectdata = EffectData()
	effectdata:SetOrigin(ent:GetPos() + ent:OBBCenter())
	effectdata:SetMagnitude(5)
	effectdata:SetScale(2)
	effectdata:SetRadius(5)

	util.Effect("Sparks", effectdata)
end

local function HandleDoorPairs(ent)
	local master = ent:GetInternalVariable("m_hMaster")
	local owner = ent:GetInternalVariable("m_hOwnerEntity")

	local pair

	if IsValid(master) then
		pair = master
	elseif IsValid(owner) then
		pair = owner
	else
		return
	end

	ent.otherPairDoor = pair
	pair.otherPairDoor = ent
end

--- DOORS MODULE STUFF ---

---
-- @module door
-- @author Mineotopia
-- @desc A bunch of functions that handle all doors found on a map

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
		ent:SetNWBool("ttt2_door_open", IsDoorOpen(ent) or false)

		ent:SetNWBool("ttt2_door_player_use", PlayerCanUseDoor(ent))
		ent:SetNWBool("ttt2_door_player_touch", PlayerCanTouchDoor(ent))
		ent:SetNWBool("ttt2_door_auto_close", DoorAutoCloses(ent))
		ent:SetNWBool("ttt2_door_is_destructable", DoorIsDestructible(ent))

		entityOutputs.RegisterMapEntityOutput(ent, "OnOpen", "TTT2DoorOpens")
		entityOutputs.RegisterMapEntityOutput(ent, "OnClose", "TTT2DoorCloses")
		entityOutputs.RegisterMapEntityOutput(ent, "OnFullyOpen", "TTT2DoorFullyOpen")
		entityOutputs.RegisterMapEntityOutput(ent, "OnFullyClosed", "TTT2DoorFullyClosed")

		HandleDoorPairs(ent)
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
	local function HandleUseCancel(ent)
		ent:EmitSound("doors/door_locked2.wav")
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

		ent:SetHealth(ent:Health() - dmginfo:GetDamage())

		if ent:Health() > 0 then return end

		ent:SafeDestroyDoor(dmginfo:GetAttacker():GetForward() * 15000)
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

		HandleDoorDestruction(ent)

		ent:Remove()
	end

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


--- ENTITY EXTENSION STUFF ---

---
-- @module Entity
-- @author Mineotopia
-- @ref https://wiki.facepunch.com/gmod/Entity
-- @desc shared extensions to entity table

local entmeta = assert(FindMetaTable("Entity"), "FAILED TO FIND ENTITY TABLE")

---
-- Returns whether this entity is a door or not.
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
-- Returns the lock state of a door.
-- @return boolean The door state; true: locked, false: unlocked, nil: no valid door
-- @realm shared
function entmeta:IsDoorLocked()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_locked", false)
end

---
-- Returns if a door is forceclosed, if it forceclosed it will close no matter what.
-- @return boolean The door state; true: forceclosed, false: not forceclosed, nil: no valid door
-- @realm shared
function entmeta:IsDoorForceclosed()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_forceclosed", false)
end

---
-- Returns if this door can be opened with the use key, traitor room doors or doors.
-- opened with a button press can't be opened with the use key for example
-- @return boolean If the door can be opened with the use key
-- @realm shared
function entmeta:UseOpensDoor()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_player_use", false)
end

---
-- Returns if this door can be opened by close proximity of a player.
-- @return boolean If the door can be opened with proximity
-- @realm shared
function entmeta:TouchOpensDoor()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_player_touch", false)
end

---
-- Returns if this door can be opened by a player.
-- @return boolean If the door can be opened
-- @realm shared
function entmeta:PlayerCanOpenDoor()
	if not self:IsDoor() then return end

	return self:UseOpensDoor() or self:TouchOpensDoor()
end

---
-- Returns if this door closes automatically after a certain time.
-- @return boolean If the door closes automatically
-- @realm shared
function entmeta:DoorAutoCloses()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_auto_close", false)
end

---
-- Retuens if a door is destructible.
-- @return boolean If a door is destructible
-- @realm shared
function entmeta:DoorIsDestructible()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_is_destructable", false)
end

---
-- Returns if a door is open.
-- @return boolean The door state; true: open, false: close, nil: no valid door
-- @realm shared
function entmeta:IsDoorOpen()
	if not self:IsDoor() then return end

	return self:GetNWBool("ttt2_door_open", false)
end

if SERVER then
	-- builds a data string based on a player and the previous data string
	local function GetDataString(ply, data)
		local dataTable = {}

		if IsValid(ply) then
			dataTable[#dataTable + 1] = "sid=" .. ply:SteamID64()
		end

		if data and data ~= "" then
			dataTable[#dataTable + 1] = data
		end

		return string.Implode("||", dataTable)
	end

	---
	-- Locks a door.
	-- @param [opt]Player ply The player that will be passed through as the activator
	-- @param [opt]string data Optional data that can be passed through
	-- @param [default=0]number delay The delay until the event is fired
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:LockDoor(ply, data, delay, surpressPair)
		if not self:IsDoor() then return end

		self:Fire("Lock", GetDataString(ply, data), delay or 0)

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:LockDoor(ply, data, delay, true)
		end
	end

	---
	-- Unlocks a door.
	-- @param [opt]Player ply The player that will be passed through as the activator
	-- @param [opt]string data Optional data that can be passed through
	-- @param [default=0]number delay The delay until the event is fired
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:UnlockDoor(ply, data, delay, surpressPair)
		if not self:IsDoor() then return end

		self:Fire("Unlock", GetDataString(ply, data), delay or 0)

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:UnlockDoor(ply, data, delay, true)
		end
	end

	---
	-- Opens the door.
	-- @param [opt]Player ply The player that will be passed through as the activator
	-- @param [opt]string data Optional data that can be passed through
	-- @param [default=0]number delay The delay until the event is fired
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:OpenDoor(ply, data, delay, surpressPair)
		if not self:IsDoor() then return end

		self:Fire("Open", GetDataString(ply, data), delay or 0)

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:OpenDoor(ply, data, delay, true)
		end
	end

	---
	-- Closes a door.
	-- @param [opt]Player ply The player that will be passed through as the activator
	-- @param [opt]string data Optional data that can be passed through
	-- @param [default=0]number delay The delay until the event is fired
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:CloseDoor(ply, data, delay, surpressPair)
		if not self:IsDoor() then return end

		self:Fire("Close", GetDataString(ply, data), delay or 0)

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:CloseDoor(ply, data, delay, true)
		end
	end

	---
	-- Toggles a door between open and closed.
	-- @param [opt]Player ply The player that will be passed through as the activator
	-- @param [opt]string data Optional data that can be passed through
	-- @param [default=0]number delay The delay until the event is fired
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:ToggleDoor(ply, data, delay, surpressPair)
		if not self:IsDoor() then return end

		self:Fire("Toggle", GetDataString(ply, data), delay or 0)

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:ToggleDoor(ply, data, delay, true)
		end
	end

	---
	-- Sets the state if a door can be opened on touch.
	-- @param boolean state The new state
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:SetDoorCanTouchOpen(state, surpressPair)
		SetPlayerCanTouchDoor(self, state)

		self:SetNWBool("ttt2_door_player_touch", PlayerCanTouchDoor(self))

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:SetDoorCanTouchOpen(state, true)
		end
	end

	---
	-- Sets the state if a door can be opened on use.
	-- @param boolean state The new state
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:SetDoorCanUseOpen(state, surpressPair)
		SetPlayerCanUseDoor(self, state)

		self:SetNWBool("ttt2_door_player_use", PlayerCanUseDoor(self))

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:SetDoorCanUseOpen(state, true)
		end
	end

	---
	-- Sets the state if a door closes automatically.
	-- @param boolean state The new state
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:SetDoorAutoCloses(state, surpressPair)
		SetDoorAutoCloses(self, state)

		self:SetNWBool("ttt2_door_auto_close", DoorAutoCloses(self))

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:SetDoorAutoCloses(state, true)
		end
	end

	---
	-- Sets the state if a dooris destructible.
	-- @param boolean state The new state
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @realm server
	function entmeta:MakeDoorDestructable(state, surpressPair)
		if not self:PlayerCanOpenDoor() or not door.IsValidNormal(self:GetClass()) then return end

		self:SetNWBool("ttt2_door_is_destructable", state)

		if self:Health() == 0 then
			self:SetHealth(20)
		end

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:MakeDoorDestructable(state, true)
		end
	end

	---
	-- Destroys a door in a safe manner. This means the door will be removed and spawned a
	-- prop. Furthermore it makes sure that the door will not leave a unrendered room behind
	-- (problems with area portals). If it is a double door, both doors will be destroyed by
	-- default.
	-- @param [default=Vector(0, 0, 0)]Vector pushForce The push force for the door
	-- @param [default=false]boolean surpressPair Should the call of the other door (if in a pair) be omitted?
	-- @return Entity Returns the entity of the created prop
	-- @realm server
	function entmeta:SafeDestroyDoor(pushForce, surpressPair)
		if not self:PlayerCanOpenDoor() or not door.IsValidNormal(self:GetClass()) then return end

		-- if door is destroyed, spawn a prop in the world
		local doorProp = ents.Create("prop_physics")
		doorProp:SetCollisionGroup(COLLISION_GROUP_NONE)
		doorProp:SetMoveType(MOVETYPE_VPHYSICS)
		doorProp:SetSolid(SOLID_BBOX)
		doorProp:SetPos(self:GetPos() + Vector(0, 0, 2))
		doorProp:SetAngles(self:GetAngles())
		doorProp:SetModel(self:GetModel())
		doorProp:SetSkin(self:GetSkin())

		HandleDoorDestruction(self)

		-- before the entity is killed, we have to trigger a door opening
		self:OpenDoor()

		-- we have to kill the entity here instead of removing it because this way we
		-- have no problems with area portals (invisible rooms after door is destroyed)
		self:Fire("Kill", "", 0)

		doorProp:Spawn()
		doorProp:SetHealth(50)

		doorProp.isDoorProp = true

		doorProp:GetPhysicsObject():ApplyForceCenter(pushForce or Vector(0, 0, 0))

		-- if the door is grouped as a pair, call the other one as well
		if not surpressPair and IsValid(self.otherPairDoor) then
			self.otherPairDoor:SafeDestroyDoor(pushForce, true)
		end

		return doorProp
	end

	---
	-- Returns if a door is currently transitioning between beeing opened and closed
	-- @return boolean The door state; true: open, false: close, nil: no valid door
	-- @realm server
	function entmeta:DoorIsTransitioning()
		if not self:IsDoor() then return end

		local cls = self:GetClass()

		if door.IsValidNormal(cls) then
			-- some doors have an auto-close feature
			if self:DoorAutoCloses() and self:GetInternalVariable("m_eDoorState") == 2 then
				return true
			end

			return self:GetInternalVariable("m_eDoorState") == 1 or self:GetInternalVariable("m_eDoorState") == 3
		elseif door.IsValidSpecial(cls) then
			-- some doors have an auto-close feature
			if self:DoorAutoCloses() and self:GetInternalVariable("m_toggle_state") == 0 then
				return true
			end

			return self:GetInternalVariable("m_toggle_state") == 2 or self:GetInternalVariable("m_toggle_state") == 3
		end
	end
end
