---
-- Object Relational Model
-- @author Histalek

if SERVER then
	AddCSLuaFile()
end

local sql = sql

orm = orm or {}

local ORMMODEL = {}

---
-- Returns an object relational model according to the specified databasetable. Does nothing if no databasetable with the given name exists.
-- @param string tableName The name of the table in the database to create a model for.
-- @param[opt] boolean force If set to `true` the function will not return a cached version of the model.
-- @return ormmodel The model of the database table.
-- @realm shared
function orm.Make(tableName, force)
	if IsValid(orm[tableName]) and not force then
		return orm[tableName]
	end

	if not sql.TableExists(tableName) then return end

	local model = {}
	local primaryKey = sql.GetPrimaryKey(tableName)
	local dataStructure = sql.GetTableColumns(tableName)

	model._tableName = tableName
	model._primaryKey = primaryKey
	model._dataStructure = dataStructure
	model.All = ORMMODEL.All
	model.Find = ORMMODEL.Find
	model.New = ORMMODEL.New

	-- DO NOT setup delete/save functions if no primarykey is found.
	-- In those cases the 'rowid' column would function as the primarykey, but as the rowid could change anytime (https://www.sqlite.org/rowidtable.html) data could be deleted unintentionally.
	-- Most likely rowids wont change in gmod as there is no vacuum operation but just to be safe we will not allow to use such tables. ref: https://wiki.facepunch.com/gmod/sql

	if not primaryKey then return
		model
	end

	model.Delete = ORMMODEL.Delete
	model.Save = ORMMODEL.Save
	model.Refresh = ORMMODEL.Refresh

	-- Prepare strings that will not change unless the model itself changes. So we don't have to create these strings everytime we use `model.Save()`.
	local columnList = {nil, nil}

	for i = 1, #primaryKey do
		columnList[i] = sql.SQLIdent(primaryKey[i])
	end

	model._primaryKeyList = table.concat(columnList, ",")

	for i = 1, #dataStructure do
		columnList[i] = sql.SQLIdent(dataStructure[i])
	end

	model._columnList = table.concat(columnList, ",")

	orm[tableName] = model

	return model
end

---
-- Retrieves all saved objects of the model from the database.
-- @return table Returns an array of all found objects.
function ORMMODEL:All()
	return sql.Query("SELECT * FROM " .. sql.SQLIdent(self._tableName))
end

---
-- Deletes the given object from the database storage.
-- @return nil|false Returns false if an error occurred, nil otherwise.
function ORMMODEL:Delete()
	local where = {}
	local primaryKey = self._primaryKey

	for i = 1, #primaryKey do
		where[i] = sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(self[primaryKey[i]])
	end

	where = table.concat(where, " AND ")

	return sql.Query("DELETE FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. where)
end

---
-- Retrieves a specific object by their primarykey from the database.
-- @param number|string|table primaryValue The value(s) of the primarykey to search for.
-- @note In the case of multiple columns in the primarykey you have to specify the corresponding values in the same order.
-- @return ormobject|boolean|nil Returns the table of the found object. Returns `false` if the number of supplied primaryvalues does not match the number of elements in the primarykey. Returns `nil` if no object is found.
function ORMMODEL:Find(primaryValue)
	local where = {}
	local primaryKey = self._primaryKey

	if not istable(primaryValue) and #primaryKey == 1 then
		where = sql.SQLIdent(primaryKey[1]) .. "=" .. sql.SQLStr(primaryValue)
	elseif istable(primaryValue) and #primaryValue == #primaryKey then
		for i = 1, #primaryKey do
			where[i] = sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(primaryValue[i])
		end

		where = table.concat(where, " AND ")
	else
		print("[ORM] Number of primaryvalues does not match number of primarykeys!")

		return false
	end

	local result = sql.QueryRow("SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. where)

	if result then
		return self:New(result)
	end
end

---
-- Creates a new object of the model.
-- @param[opt] table data Preexisting data the object should be initialized with.
-- @return ormobject The created object.
function ORMMODEL:New(data)
	local object = data or {}

	object.Save = self.Save
	object.Delete = self.Delete
	object.Refresh = self.Refresh
	object._tableName = self._tableName
	object._dataStructure = self._dataStructure
	object._primaryKey = self._primaryKey
	object._primaryKeyList = self._primaryKeyList
	object._columnList = self._columnList

	return object
end

---
-- Saves the data of the given object to the database storage.
-- @return nil|false Returns false if an error occurred, nil otherwise.
function ORMMODEL:Save()
	local query = "INSERT INTO " .. sql.SQLIdent(self._tableName) .. "("
	local valueList = {nil, nil}
	local dataStructure = self._dataStructure

	for i = 1, #dataStructure do
		valueList[i] = sql.SQLStr(self[dataStructure[i]])
	end

	valueList = table.concat(valueList, ",")

	query = query .. self._columnList .. ") VALUES(" .. valueList .. ") ON CONFLICT(" .. self._primaryKeyList .. ") DO UPDATE SET(" .. self._columnList .. ")=(" .. valueList .. ");"

	return sql.Query(query)
end

---
-- Refreshes the object by setting all values to those saved in the database.
-- @return boolean Returns true if refresh was successful, false otherwise.
function ORMMODEL:Refresh()
	local where = {}
	local primaryKey = self._primaryKey
	local dataStructure = self._dataStructure

	if #primaryKey == 1 then
		where = sql.SQLIdent(primaryKey[1]) .. "=" .. sql.SQLStr(self[primaryKey[1]])
	else
		for i = 1, #primaryKey do
			where[i] = sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(self[primaryKey[i]])
		end

		where = table.concat(where, " AND ")
	end

	local result = sql.QueryRow("SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. where)

	if result then
		for i = 1, #dataStructure do
			self[dataStructure[i]] = result[dataStructure[i]]
		end

		return true
	end

	return false

end

---
-- Retrieves all saved objects of the model with the given filters from the database.
-- @param table filters An Array of filters. Each filter should contain a `column`, `op`, `value` and `concat`(if it is not the last filter).
-- @return table Returns an array of all found objects.
function ORMMODEL:Where(filters)
	local query = "SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE "
	local whereList = {}

	for i = 1, #filters do
		local curFilter = filters[i]
		whereList[i] = sql.SQLIdent(curFilter[column]) .. (curFilter[op] or "=") .. sql.SQLStr(curFilter[value]) .. (curFilter[concat] or "")
	end

	whereList = table.concat(whereList)

	query = query .. whereList

	return sql.Query(query)
end
