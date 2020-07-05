---
-- Object Relational Model
-- @author Histalek

if SERVER then
	AddCSLuaFile()
end

local sql = sql

orm = orm or {}

local ormodel = {}

---
-- Returns an object relational model according to the specified databasetable. Does nothing if no databasetable with the given name exists.
-- @param string tableName The name of the table in the database to create a model for.
-- @param[opt] boolean force If set to `true` the function will not return a cached version of the model.
-- @realm shared
-- @return table The model of the database table.
function orm.Make(tableName, force)

	if IsValid(orm[tableName]) and not force then return orm[tableName] end

	if not sql.TableExists(tableName) then return end

	local model = {}
	--baseclass.Set(tableName, model)
	local primaryKey = sql.GetPrimaryKey(tableName)
	local dataStructure = sql.GetTableColumns(tableName)

	model._tableName = tableName
	model._primaryKey = primaryKey
	model._dataStructure = dataStructure
	model.All = ormodel.All
	model.Find = ormodel.Find
	model.New = ormodel.New

	-- DO NOT setup delete/save functions if no primarykey is found.
	-- In those cases the 'rowid' column would function as the primarykey, but as the rowid could change anytime (https://www.sqlite.org/rowidtable.html) data could be deleted unintentionally.
	-- Most likely rowids wont change in gmod as there is no vacuum operation but just to be safe we will not allow to use such tables. ref: https://wiki.facepunch.com/gmod/sql

	if not primaryKey then return model end

	model.Delete = ormodel.Delete
	model.Save = ormodel.Save

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
function ormodel:All()
	return sql.Query("SELECT * FROM " .. sql.SQLIdent(self._tableName))
end

---
-- Deletes the given object from the database storage.
function ormodel:Delete()
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
-- @return table|boolean|nil Returns the table of the found object. Returns `false` if the number of supplied primaryvalues does not match the number of elements in the primarykey. Returns `nil` if no object is found.
function ormodel:Find(primaryValue)
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

	if result then return self:New(result) end
end

---
-- Creates a new object of the model.
-- @param[opt] table data preexisting data the model should be initialized with.
-- @return table The created object.
function ormodel:New(data)
	local object = data or {}

	object.Save = self.Save
	object.Delete = self.Delete
	object._tableName = self._tableName
	object._dataStructure = self._dataStructure
	object._primaryKey = self._primaryKey
	object._primaryKeyList = self._primaryKeyList
	object._columnList = self._columnList

	return object
end

---
-- Saves the data of the given object to the database storage.
function ormodel:Save()
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
