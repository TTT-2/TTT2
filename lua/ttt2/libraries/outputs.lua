---
-- @desc A small library that handles all basics to register map entity
-- output triggers to lua hooks.
-- @author Mineotopia

outputs = outputs or {}

outputs.hooks = outputs.hooks or {}

---
-- Sets up the outputs library by creating a lua_run map entitiy
-- to add hook to these entities. Has to be run in @{GM:PostCleanupMap}.
-- @internal
-- @realm server
function outputs.SetUp()
	if IsValid(outputs.mapLuaRun) then return end

	outputs.mapLuaRun = ents.Create("lua_run")
	outputs.mapLuaRun:SetName("triggerhook")
	outputs.mapLuaRun:Spawn()
end

---
-- Cleans up the outputs library hooks prior to the map cleanup.
-- Has to called in @{GM:PreCleanupMap}.
-- @internal
-- @realm server
function outputs.CleanUp()
	for hookName in pairs(outputs.hooks) do
		hook.Remove(hookName .. "_Internal", hookName .. "_name")
	end

	outputs.hooks = {}
end

---
-- Registers a new hook in the outputs library if it isn't already registered.
-- @param string hookName The desired name of the registered hook
-- @internal
-- @realm server
function outputs.RegisterHook(hookName)
	if outputs.hooks[hookName] then return end

	outputs.hooks[hookName] = true

	hook.Add(hookName .. "_Internal", hookName .. "_name", function()
		local activator, caller = ACTIVATOR, CALLER

		hook.Run(hookName, caller, activator)
	end)
end

---
-- Registers a map entity output trigger hook. Keep in mind, this function
-- has to be called after every map cleanup. It is recommended to use this
-- function inside the @{GM:TTT2PostCleanupMap} hook.
-- @param Entity The map entity
-- @param string outputName The name of the entity output
-- @param string hookName The desired name of the registered hook
-- @param [default=0]number delay The delay between the fired output and the hook call
-- @param [default=-1]number repititions The amount of repititions until the output is removed, -1 for infinite
-- @ref https://developer.valvesoftware.com/wiki/Lua_run
-- @ref https://wiki.facepunch.com/gmod/Entity:Fire
-- @realm server
function outputs.RegisterMapEntityOutput(ent, outputName, hookName, delay, repititions)
	if not IsValid(ent) then return end

	delay = delay or 0
	repititions = repititions or -1

	ent:Fire("AddOutput", outputName .. " triggerhook:RunPassedCode:hook.Run('" .. hookName .. "_Internal'):" .. delay .. ":" .. repititions)

	outputs.RegisterHook(hookName)
end
