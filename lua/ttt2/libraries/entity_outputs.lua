---
-- A small library that enables registering map entity
-- output triggers to lua hooks.
-- @author Mineotopia
-- @module entityOutputs

if CLIENT then
    return
end -- this is a serverside-only module

entityOutputs = entityOutputs or {}
entityOutputs.hooks = entityOutputs.hooks or {}

---
-- Sets up the entityOutputs library by creating a lua_run map entitiy
-- to add hook to these entities. Has to be run in @{GM:PostCleanupMap}.
-- @internal
-- @realm server
function entityOutputs.SetUp()
    if IsValid(entityOutputs.mapLuaRun) then
        return
    end

    entityOutputs.mapLuaRun = ents.Create("lua_run")
    entityOutputs.mapLuaRun:SetName("triggerhook")
    entityOutputs.mapLuaRun:Spawn()
end

---
-- Cleans up the entityOutputs library hooks prior to the map cleanup.
-- Has to be called in @{GM:PreCleanupMap}.
-- @internal
-- @realm server
function entityOutputs.CleanUp()
    for hookName in pairs(entityOutputs.hooks) do
        hook.Remove(hookName .. "_Internal", hookName .. "_name")
    end

    entityOutputs.hooks = {}
end

---
-- Registers a new hook in the entityOutputs library if it isn't already registered.
-- @param string hookName The desired name of the registered hook
-- @internal
-- @realm server
function entityOutputs.RegisterHook(hookName)
    if entityOutputs.hooks[hookName] then
        return
    end

    entityOutputs.hooks[hookName] = true

    hook.Add(hookName .. "_Internal", hookName .. "_name", function()
        -- The `ACTIVATOR` and `CALLER` globals are only available during execution
        -- see note at https://wiki.facepunch.com/gmod/ENTITY:TriggerOutput#example
        local activator, caller = ACTIVATOR, CALLER

        ---
        -- @ignore
        hook.Run(hookName, caller, activator)
    end)
end

---
-- Registers a map entity output trigger hook.
-- Keep in mind, this function has to be called after every map cleanup.
-- It is recommended to use this function inside the @{GM:TTT2PostCleanupMap} hook.
-- @note The created hook has the params: caller, activator.
-- @param Entity The map entity
-- @param string outputName The name of the entity output
-- @param string hookName The desired name of the registered hook
-- @param[default=0] number delay The delay between the fired output and the hook call
-- @param[default=-1] number repetitions The amount of repetitions until the output is removed, -1 for infinite
-- @ref https://developer.valvesoftware.com/wiki/Lua_run
-- @ref https://wiki.facepunch.com/gmod/Entity:Fire
-- @realm server
function entityOutputs.RegisterMapEntityOutput(ent, outputName, hookName, delay, repititions)
    if not IsValid(ent) then
        return
    end

    delay = delay or 0
    repititions = repititions or -1

    -- @ignore
    ent:Fire(
        "AddOutput",
        outputName
            .. " triggerhook:RunPassedCode:hook.Run('"
            .. hookName
            .. "_Internal'):"
            .. delay
            .. ":"
            .. repititions
    )

    entityOutputs.RegisterHook(hookName)
end
