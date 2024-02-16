---
-- Object Relational Model
-- @author Histalek
-- @module orm

if SERVER then
    AddCSLuaFile()
end

local sql = sql

orm = orm or {}

local cachedModels = {}

local ORMMODEL = {}
local ORMOBJECT = {}

---
-- Returns an object relational model according to the specified databasetable. Does nothing if no databasetable with the given name exists.
-- @param string tableName The name of the table in the database to create a model for.
-- @param[opt] boolean force If set to `true` the function will not return a cached version of the model.
-- @return ORMMODEL|nil Returns the model of the database table or nil if the database table does not exist.
-- @realm shared
function orm.Make(tableName, force)
    if IsValid(cachedModels[tableName]) and not force then
        return cachedModels[tableName]
    end

    if not sql.TableExists(tableName) then
        return
    end

    local primaryKey = sql.GetPrimaryKey(tableName)
    local dataStructure = sql.GetTableColumns(tableName)

    if not primaryKey or not dataStructure then
        ErrorNoHaltWithStack(
            "[ORM] An sql error occurred while retrieving the metadata of the following databasetable: "
                .. tableName
        )
    end

    local model = {}
    model._tableName = tableName
    model._dataStructure = dataStructure
    model.All = ORMMODEL.All
    model.New = ORMMODEL.New
    model.Where = ORMMODEL.Where

    if #primaryKey == 0 then
        return model
    end

    model._primaryKey = primaryKey
    model.Find = ORMMODEL.Find

    -- Prepare strings that will not change unless the model itself changes. So we don't have to create these strings everytime we use `model.Save()`.
    local columnList = { nil, nil }

    for i = 1, #primaryKey do
        ---@cast primaryKey -nil
        columnList[i] = sql.SQLIdent(primaryKey[i])
    end

    model._primaryKeyList = table.concat(columnList, ",")

    for i = 1, #dataStructure do
        ---@cast dataStructure -nil
        columnList[i] = sql.SQLIdent(dataStructure[i])
    end

    model._columnList = table.concat(columnList, ",")

    cachedModels[tableName] = model

    return model
end

---
-- @class ORMMODEL

---
-- Retrieves all saved objects of the model from the database.
-- @return table|nil Returns an array of all found @{ORMOBJECT}s or nil in case of an error.
-- @realm shared
function ORMMODEL:All()
    local objects = sql.Query("SELECT * FROM " .. sql.SQLIdent(self._tableName))

    if objects == false then
        return
    end

    -- nothing found, make it an empty table
    objects = objects or {}

    if not self._primaryKey then
        return objects
    end

    for i = 1, #objects do
        objects[i].Save = self.Save
        objects[i].Delete = self.Delete
        objects[i].Refresh = self.Refresh
    end

    return objects
end

---
-- Retrieves a specific object by their primarykey from the database.
-- @param string|table primaryValue The value(s) of the primarykey to search for.
-- @note In the case of multiple columns in the primarykey you have to specify the corresponding values in the same order.
-- @return table|nil Returns the table of the found @{ORMOBJECT}s or nil in case of an error.
-- @realm shared
function ORMMODEL:Find(primaryValue)
    local where = {}
    local primaryKey = self._primaryKey
    local primaryKeyCount = #primaryKey

    if not istable(primaryValue) and primaryKeyCount == 1 then
        where = sql.SQLIdent(primaryKey[1]) .. "=" .. sql.SQLStr(primaryValue)
    elseif istable(primaryValue) and #primaryValue == primaryKeyCount then
        for i = 1, primaryKeyCount do
            where[i] = sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(primaryValue[i])
        end

        where = table.concat(where, " AND ")
    else
        ErrorNoHaltWithStack("[ORM] Number of primaryvalues does not match number of primarykeys!")

        return
    end

    local result =
        sql.QueryRow("SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. where)

    if result == false then
        return
    end

    return result and self:New(result) or nil
end

---
-- Creates a new object of the model.
-- @param[opt] table data Preexisting data the object should be initialized with.
-- @return ORMOBJECT The created object.
-- @realm shared
function ORMMODEL:New(data)
    local object = data or {}

    object._tableName = self._tableName
    object._dataStructure = self._dataStructure

    -- DO NOT setup delete/save/refresh functions if no primarykey is found.
    -- In those cases the 'rowid' column would function as the primarykey, but as the rowid could change anytime (https://www.sqlite.org/rowidtable.html) data could be deleted unintentionally.
    -- Most likely rowids wont change in gmod as there is no vacuum operation but just to be safe we will not allow to use such tables. ref: https://wiki.facepunch.com/gmod/sql

    if not self._primaryKey then
        return object
    end

    object.Delete = ORMOBJECT.Delete
    object.Save = ORMOBJECT.Save
    object.Refresh = ORMOBJECT.Refresh
    object._primaryKey = self._primaryKey
    object._primaryKeyList = self._primaryKeyList
    object._columnList = self._columnList

    return object
end

---
-- Retrieves all saved objects of the model with the given filters from the database.
-- @param table filters An array of filters. Each filter should contain a `column`, `op`, `value` and `concat`(if it is not the last filter).
-- @return table|nil Returns an array of all found @{ORMOBJECT}s or nil in case of an error.
-- @realm shared
function ORMMODEL:Where(filters)
    local query = "SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE "
    local whereList = {}

    for i = 1, #filters do
        local curFilter = filters[i]

        whereList[i] = sql.SQLIdent(curFilter.column)
            .. (curFilter.op or "=")
            .. sql.SQLStr(curFilter.value)
            .. (curFilter.concat or "")
    end

    whereList = table.concat(whereList)

    query = query .. whereList

    local objects = sql.Query(query)

    if objects == false then
        return
    end

    -- nothing found, make it an empty table
    objects = objects or {}

    if not self._primaryKey then
        return objects
    end

    for i = 1, #objects do
        objects[i].Save = ORMOBJECT.Save
        objects[i].Delete = ORMOBJECT.Delete
        objects[i].Refresh = ORMOBJECT.Refresh
    end

    return objects
end

---
-- @class ORMOBJECT

---
-- Deletes the given object from the database storage.
-- @return boolean Returns true if the object was successfully deleted, false otherwise.
-- @realm shared
function ORMOBJECT:Delete()
    local where = {}
    local primaryKey = self._primaryKey

    for i = 1, #primaryKey do
        where[i] = sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(self[primaryKey[i]])
    end

    where = table.concat(where, " AND ")

    local query = "DELETE FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. where

    return sql.Query(query) == nil
end

---
-- Saves the data of the given object to the database storage.
-- @return boolean Returns true if the object was successfully saved to the database, false otherwise.
-- @realm shared
function ORMOBJECT:Save()
    local query = "INSERT INTO " .. sql.SQLIdent(self._tableName) .. "("
    local valueList = { nil, nil }
    local dataStructure = self._dataStructure

    for i = 1, #dataStructure do
        valueList[i] = sql.SQLStr(self[dataStructure[i]])
    end

    valueList = table.concat(valueList, ",")

    query = query
        .. self._columnList
        .. ") VALUES("
        .. valueList
        .. ") ON CONFLICT("
        .. self._primaryKeyList
        .. ") DO UPDATE SET("
        .. self._columnList
        .. ")=("
        .. valueList
        .. ");"

    return sql.Query(query) == nil
end

---
-- Refreshes the object by setting all values to those saved in the database.
-- @return boolean Returns true if refresh was successful, false otherwise.
-- @realm shared
function ORMOBJECT:Refresh()
    local primaryKey = self._primaryKey
    local dataStructure = self._dataStructure
    local where = {}

    if #primaryKey == 1 then
        where = sql.SQLIdent(primaryKey[1]) .. "=" .. sql.SQLStr(self[primaryKey[1]])
    else
        for i = 1, #primaryKey do
            where[i] = sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(self[primaryKey[i]])
        end

        where = table.concat(where, " AND ")
    end

    local result =
        sql.QueryRow("SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. where)

    if result then
        for i = 1, #dataStructure do
            self[dataStructure[i]] = result[dataStructure[i]]
        end

        return true
    end

    return false
end
