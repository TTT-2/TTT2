---
-- A builder to handle the creation of classes from files
-- @author Mineotopia
-- @module classbuilder

if SERVER then
    AddCSLuaFile()
end

local tableDeepInherit = table.DeepInherit
local stringSplit = string.Split
local stringLower = string.lower
local isfunction = isfunction

---
-- recursive inheritance function
local function Inherit(class, classTable, passthrough, SpecialCheck)
    -- do not do anything if the base has no base class name assigned
    if not class.base then
        return class
    end

    -- get the base class entry from the class table
    local baseclass = classTable[class.base] or passthrough[class.base]

    -- if the special inheritance check is failed, no inheritance should take place
    if isfunction(SpecialCheck) and not SpecialCheck(class, baseclass) then
        return class
    end

    local deepbaseclass = classTable[baseclass.base] or passthrough[baseclass.base]

    -- assign a reference to the base class functions
    class.BaseClass = baseclass

    if
        not baseclass.base
        or (isfunction(SpecialCheck) and not SpecialCheck(baseclass, deepbaseclass))
    then
        -- the base of the baseclass is non-existent: only inherit one last time
        return tableDeepInherit(class, baseclass)
    else
        -- the base of the baseclass exists: call inheritance function recursively
        return tableDeepInherit(class, Inherit(baseclass, classTable, passthrough, SpecialCheck))
    end
end

classbuilder = classbuilder or {}

---
-- Builds a class from a file in a given scope. Uses the @{fileloader} to load files from a folder
-- that are loaded as classes. Supports inheriting from base class.
-- @note Has to be run on both server and client for client and shared files.
-- @param string path The absolute path to search in, has to end with `/`
-- @param[default=SHARED_FILE] number realm The realm where the file should be included
-- @param string scope The scope where the new class will be registered, for example `ITEM`
-- @param[opt] function OnInitialization This callback function is called on initialization of the class
-- @param[default=false] boolean shouldInherit Set this to true if this class should inherit from its base
-- @param[opt] function SpecialCheck A function that makes a special check, inheritance is blocked if false is returned
-- @param[opt] table passthrough A table that can be passed through if the classdata table should be extended
-- @param[opt] function PostInherit A callback function that is called for all classes post inheritance
-- @return table Returns a table of all the created classes
-- @realm shared
function classbuilder.BuildFromFolder(
    path,
    realm,
    scope,
    OnInitialization,
    shouldInherit,
    SpecialCheck,
    passthrough,
    PostInherit
)
    -- In case this function is run on the server but the class should only exist
    -- on the client, this function should work only as a proxy.
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
        local name = stringLower(util.GetFileName(pathArray[#pathArray]))

        -- copy the table from the loaded class file
        classTable[name] = _G[scope]

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
            classTable[name] = Inherit(class, classTable, passthrough, SpecialCheck)
        end
    end

    -- call callback function for all classes once they are all set up and finished
    -- their inheritance
    if isfunction(PostInherit) then
        for name, class in pairs(classTable) do
            PostInherit(class, path, name)
        end
    end

    return classTable
end
