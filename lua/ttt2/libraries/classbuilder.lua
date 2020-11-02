---
-- A builder to handle the creation of classes from files
-- @author Mineotopia
-- @module classbuilder

if SERVER then
	AddCSLuaFile()
end

local tableCopy = table.Copy
local tableDeepInherit = table.DeepInherit
local stringSplit = string.Split
local stringLower = string.lower
local stringSub = string.sub
local isfunction = isfunction

classbuilder = classbuilder or {}

function classbuilder.BuildFromFolder(path, realm, scope, OnInitialization, shouldInherit, SpecialCheck)
	-- In case this function is run on the server but the class should only exist
	-- ono the client, this function should work only as a proxy.
	if SERVER and realm == CLIENT_FILE then
		fileloader.LoadFolder(path, false, realm)

		return
	end

	-- In the first step make sure to cache the scope variable to keep
	-- compatibility with addons that may use the same scope.
	local cachedScope = _G[scope]

	-- Now a global scope has to be created.
	_G[scope] = {}

	-- This variable will be used to store the loaded classes from the folder.
	local classTable = {}

	fileloader.LoadFolder(path, false, realm, function(filePath)
		-- get the filename from the file path
		local pathArray = stringSplit(filePath, "/")
		local name = stringLower(stringSub(pathArray[#pathArray], 0, -5))

		-- copy the table from the loaded class file
		classTable[name] = tableCopy(_G[scope])

		-- reset the scope for the next class
		_G[scope] = {}

		if isfunction(OnInitialization) then
			OnInitialization(classTable[name], path, name)
		end
	end)

	-- In the last step, the cached scope should be reset to the global scope.
	_G[scope] = cachedScope

	-- Now that all classes are loaded, they should inherit from their base
	-- class if enabled.
	if shouldInherit then
		for name, class in pairs(classTable) do
			classTable[name] = tableDeepInherit(class, classTable[class.base], SpecialCheck)
		end
	end

	return classTable
end
