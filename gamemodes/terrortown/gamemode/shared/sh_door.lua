---
-- Shared extensions to entity table
-- @author Mineotopia
-- @ref https://wiki.facepunch.com/gmod/Entity
-- @class Entity

local entmeta = assert(FindMetaTable("Entity"), "FAILED TO FIND ENTITY TABLE")

-- builds a data string based on a player and the previous data string
local function GetDataString(ply, data)
    local dataTable = {}

    if IsValid(ply) then
        dataTable[#dataTable + 1] = "sid=" .. ply:SteamID64()
    end

    if data and data ~= "" then
        dataTable[#dataTable + 1] = data
    end

    return table.concat(dataTable, "||")
end

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
    if not self:IsDoor() then
        return
    end

    return self:GetNW2Bool("ttt2_door_locked", false)
end

---
-- Returns if a door is forceclosed, if it forceclosed it will close no matter what.
-- @return boolean The door state; true: forceclosed, false: not forceclosed, nil: no valid door
-- @realm shared
function entmeta:IsDoorForceclosed()
    if not self:IsDoor() then
        return
    end

    return self:GetNW2Bool("ttt2_door_forceclosed", false)
end

---
-- Returns if this door can be opened with the use key, traitor room doors or doors.
-- opened with a button press can't be opened with the use key for example
-- @return boolean If the door can be opened with the use key
-- @realm shared
function entmeta:UseOpensDoor()
    if not self:IsDoor() then
        return
    end

    return self:GetNW2Bool("ttt2_door_player_use", false)
end

---
-- Returns if this door can be opened by close proximity of a player.
-- @return boolean If the door can be opened with proximity
-- @realm shared
function entmeta:TouchOpensDoor()
    if not self:IsDoor() then
        return
    end

    return self:GetNW2Bool("ttt2_door_player_touch", false)
end

---
-- Returns if this door can be opened by a player.
-- @return boolean If the door can be opened
-- @realm shared
function entmeta:PlayerCanOpenDoor()
    if not self:IsDoor() then
        return
    end

    return self:UseOpensDoor() or self:TouchOpensDoor()
end

---
-- Returns if this door closes automatically after a certain time.
-- @return boolean If the door closes automatically
-- @realm shared
function entmeta:DoorAutoCloses()
    if not self:IsDoor() then
        return
    end

    return self:GetNW2Bool("ttt2_door_auto_close", false)
end

---
-- Returns if a door is destructible.
-- @return boolean If a door is destructible
-- @realm shared
function entmeta:DoorIsDestructible()
    if not self:IsDoor() then
        return
    end

    -- might be a little hacky
    if
        self:Health() > 0
        and self:GetMaxHealth() > 0
        and (self:GetInternalVariable("m_takedamage") or 2) > 1
    then
        return true
    end

    return self:GetNW2Bool("ttt2_door_is_destructable", false)
end

---
-- Returns if a door is open.
-- @return boolean The door state; true: open, false: close, nil: no valid door
-- @realm shared
function entmeta:IsDoorOpen()
    if not self:IsDoor() then
        return
    end

    return self:GetNW2Bool("ttt2_door_open", false)
end

---
-- Returns the fast synced health of the door entity. This is useful for UI applications.
-- @return number The synced health
-- @realm shared
function entmeta:GetFastSyncedHealth()
    return math.max(0, self:GetNW2Int("fast_sync_health", self:Health()))
end

if SERVER then
    ---
    -- @realm server
    local cvDoorHealth = CreateConVar("ttt2_doors_health", "100", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvDoorPropHealth =
        CreateConVar("ttt2_doors_prop_health", "50", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- Locks a door.
    -- @param[opt] Player ply The player that will be passed through as the activator
    -- @param[opt] string data Optional data that can be passed through
    -- @param[default=0] number delay The delay until the event is fired
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:LockDoor(ply, data, delay, surpressPair)
        if not self:IsDoor() then
            return
        end

        self:Fire("Lock", GetDataString(ply, data), delay or 0)

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:LockDoor(ply, data, delay, true)
        end
    end

    ---
    -- Unlocks a door.
    -- @param[opt] Player ply The player that will be passed through as the activator
    -- @param[opt] string data Optional data that can be passed through
    -- @param[default=0] number delay The delay until the event is fired
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:UnlockDoor(ply, data, delay, surpressPair)
        if not self:IsDoor() then
            return
        end

        self:Fire("Unlock", GetDataString(ply, data), delay or 0)

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:UnlockDoor(ply, data, delay, true)
        end
    end

    ---
    -- Opens the door.
    -- @param[opt] Player ply The player that will be passed through as the activator
    -- @param[opt] string data Optional data that can be passed through
    -- @param[default=0] number delay The delay until the event is fired
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:OpenDoor(ply, data, delay, surpressPair)
        if not self:IsDoor() then
            return
        end

        self:Fire("Open", GetDataString(ply, data), delay or 0)

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:OpenDoor(ply, data, delay, true)
        end
    end

    ---
    -- Closes a door.
    -- @param[opt] Player ply The player that will be passed through as the activator
    -- @param[opt] string data Optional data that can be passed through
    -- @param[default=0] number delay The delay until the event is fired
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:CloseDoor(ply, data, delay, surpressPair)
        if not self:IsDoor() then
            return
        end

        self:Fire("Close", GetDataString(ply, data), delay or 0)

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:CloseDoor(ply, data, delay, true)
        end
    end

    ---
    -- Toggles a door between open and closed.
    -- @param[opt] Player ply The player that will be passed through as the activator
    -- @param[opt] string data Optional data that can be passed through
    -- @param[default=0] number delay The delay until the event is fired
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:ToggleDoor(ply, data, delay, surpressPair)
        if not self:IsDoor() then
            return
        end

        self:Fire("Toggle", GetDataString(ply, data), delay or 0)

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:ToggleDoor(ply, data, delay, true)
        end
    end

    ---
    -- Sets the state if a door can be opened on touch.
    -- @param boolean state The new state
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:SetDoorCanTouchOpen(state, surpressPair)
        door.SetPlayerCanTouch(self, state)

        self:SetNW2Bool("ttt2_door_player_touch", door.PlayerCanTouch(self))

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:SetDoorCanTouchOpen(state, true)
        end
    end

    ---
    -- Sets the state if a door can be opened on use.
    -- @param boolean state The new state
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:SetDoorCanUseOpen(state, surpressPair)
        door.SetPlayerCanUse(self, state)

        self:SetNW2Bool("ttt2_door_player_use", door.PlayerCanUse(self))

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:SetDoorCanUseOpen(state, true)
        end
    end

    ---
    -- Sets the state if a door closes automatically.
    -- @param boolean state The new state
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:SetDoorAutoCloses(state, surpressPair)
        door.SetAutoClose(self, state)

        self:SetNW2Bool("ttt2_door_auto_close", door.AutoCloses(self))

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:SetDoorAutoCloses(state, true)
        end
    end

    ---
    -- Sets the state if a door is destructible.
    -- @param boolean state The new state
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @realm server
    function entmeta:MakeDoorDestructable(state, surpressPair)
        if not self:PlayerCanOpenDoor() or not door.IsValidNormal(self:GetClass()) then
            return
        end

        self:SetNW2Bool("ttt2_door_is_destructable", state)

        if self:Health() == 0 then
            self:SetHealth(cvDoorHealth:GetInt())

            self:SetNW2Int("fast_sync_health", self:Health())
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
    -- @param Player ply The player that wants to destroy the door
    -- @param[default=Vector(0, 0, 0)] Vector pushForce The push force for the door
    -- @param[default=false] boolean surpressPair Should the call of the other door (if in a pair) be omitted?
    -- @return Entity Returns the entity of the created prop
    -- @realm server
    function entmeta:SafeDestroyDoor(ply, pushForce, surpressPair)
        if
            self.isDestroyed
            or not self:PlayerCanOpenDoor()
            or not door.IsValidNormal(self:GetClass())
        then
            return
        end

        ---
        -- @realm server
        if hook.Run("TTT2BlockDoorDestruction", self, ply) then
            return
        end

        -- if door is destroyed, spawn a prop in the world
        local doorProp = ents.Create("prop_physics")
        doorProp:SetCollisionGroup(COLLISION_GROUP_NONE)
        doorProp:SetMoveType(MOVETYPE_VPHYSICS)
        doorProp:SetSolid(SOLID_BBOX)
        doorProp:SetPos(self:GetPos() + Vector(0, 0, 2))
        doorProp:SetAngles(self:GetAngles())
        doorProp:SetModel(self:GetModel())
        doorProp:SetSkin(self:GetSkin())

        door.HandleDestruction(self)

        -- disable the door move sound for the destruction
        self:SetKeyValue("soundmoveoverride", "")

        -- before the entity is killed, we have to trigger a door opening
        self:OpenDoor()

        -- set flag that this door is destroyed to prevent multiple prop spawns in case
        -- this function is called multiple times for the same door in the same tick
        self.isDestroyed = true

        -- if the door is grouped as a pair, call the other one as well
        if not surpressPair and IsValid(self.otherPairDoor) then
            self.otherPairDoor:SafeDestroyDoor(ply, pushForce, true)
        end

        timer.Simple(0, function()
            if not IsValid(self) or not IsValid(doorProp) then
                return
            end

            -- we have to kill the entity here instead of removing it because this way we
            -- have no problems with area portals (invisible rooms after door is destroyed)
            self:Fire("Kill", "", 0)

            if IsValid(ply) and ply:IsPlayer() then
                DamageLog(
                    "TTT2Doors: The door with the index "
                        .. self:EntIndex()
                        .. " has been destroyed by "
                        .. ply:Nick()
                        .. "."
                )
            else
                DamageLog(
                    "TTT2Doors: The door with the index "
                        .. self:EntIndex()
                        .. " has been destroyed."
                )
            end

            doorProp:Spawn()
            doorProp:SetHealth(cvDoorPropHealth:GetInt())

            doorProp.isDoorProp = true

            doorProp:GetPhysicsObject():ApplyForceCenter(pushForce or Vector(0, 0, 0))

            ---
            -- @realm server
            hook.Run("TTT2DoorDestroyed", doorProp, ply)
        end)

        return doorProp
    end

    ---
    -- Returns if a door is currently transitioning between beeing opened and closed
    -- @return boolean The door state; true: open, false: close, nil: no valid door
    -- @realm server
    function entmeta:DoorIsTransitioning()
        if not self:IsDoor() then
            return
        end

        local cls = self:GetClass()

        if door.IsValidNormal(cls) then
            -- some doors have an auto-close feature
            if self:DoorAutoCloses() and self:GetInternalVariable("m_eDoorState") == 2 then
                return true
            end

            return self:GetInternalVariable("m_eDoorState") == 1
                or self:GetInternalVariable("m_eDoorState") == 3
        elseif door.IsValidSpecial(cls) then
            -- some doors have an auto-close feature
            if self:DoorAutoCloses() and self:GetInternalVariable("m_toggle_state") == 0 then
                return true
            end

            return self:GetInternalVariable("m_toggle_state") == 2
                or self:GetInternalVariable("m_toggle_state") == 3
        end
    end
end
