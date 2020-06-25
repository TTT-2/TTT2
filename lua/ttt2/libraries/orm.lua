---
-- Object Relational Model
-- @author Histalek

--local baseclass = baseclass
local sql = sql

orm = orm or {}

local ormodel = {}

local function SetupModelFunctions(tableName, primaryKey, dataStructure)

	local model = {}
	local sanTableName = sql.SQLIdent(tableName)

	model.New = function(self, data)
		local object = data or {}

		-- TODO needed?
		--object.BaseClass = baseclass.Get(tableName)

		object.Save = self.Save --object.BaseClass.Save
		object.Delete = self.Delete --object.BaseClass.Delete

		return object
	end

	model.All = function(self)
		return sql.Query("SELECT * FROM " .. sanTableName)
	end

	model.Find = function(self, primaryValue)
		local where

		if not istable(primaryValue) and #primaryKey == 1 then
			where = sql.SQLIdent(primaryKey[1]) .. "=" .. sql.SQLStr(primaryValue)
		elseif istable(primaryValue) and #primaryValue == #primaryKey then
			for i = 1, #primaryKey do
				if not where then
					where = sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(primaryValue[i])
				else
					where = where .. " AND " .. sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(primaryValue[i])
				end
			end
		else
			print("[ORM] Number of primaryvalues does not match number of primarykeys!")
			return false
		end

		local result = sql.QueryRow("SELECT * FROM " .. sanTableName .. " WHERE " .. where)

		return self:New(result)
	end

	-- DO NOT setup delete/save functions if no primarykey is found.
	-- In those cases the 'rowid' column would function as the primarykey, but as the rowid could change anytime (https://www.sqlite.org/rowidtable.html) data could be deleted unintentionally.
	-- Most likely rowids wont change in gmod as there is no vacuum operation but just to be safe we will not allow to use such tables. ref: https://wiki.facepunch.com/gmod/sql
	if not primaryKey then return model end

	-- Prepare strings that will not change unless the model itself changes. So we don't have to create these strings everytime we use `model.Save()`.
	local columnList
	local primaryKeyList

	for i = 1, #primaryKey do
		if i == 1 then
			primaryKeyList = primaryKey[1]
		else
			primaryKeyList = primaryKeyList .. primaryKey[i]
		end
	end

	for i = 1, #dataStructure do
		if i == 1 then
			columnList = dataStructure[1]
		else
			columnList = columnList .. dataStructure[i]
		end
	end

	model.Save = function(self)
		local query = "INSERT INTO " .. sanTableName .. "("
		local valueList

		for i = 1, #dataStructure do
			if i == 1 then
				valueList = self[dataStructure[1]]
			else
				valueList = valueList .. self[dataStructure[i]]
			end
		end

		query = query .. columnList .. ") VALUES(" .. valueList .. ") ON CONFLICT(" .. primaryKeyList .. ") DO UPDATE SET(" .. columnList .. ")=(" .. valueList .. ");"

		return sql.Query(query)
	end

	model.Delete = function(self)
		local where

		for i = 1, #primaryKey do
				if not where then
					where = sql.SQLIdent(primaryKey[1]) .. "=" .. sql.SQLStr(self[primaryKey[1]])
				else
					where = where .. " AND " .. sql.SQLIdent(primaryKey[i]) .. "=" .. sql.SQLStr(self[primaryKey[i]])
				end
			end

		return sql.Query("DELETE FROM " .. sanTableName .. " WHERE " .. where)
	end

	return model
end

---
-- Returns an object relational model according to the specified databasetable. Does nothing if no databasetable with the given name exists.
-- @param string tableName The name of the table in the database to create a model for.
-- @param[opt] boolean force If set to `true` the function will not return a cached version of the model.
-- @realm shared
-- @return table The model of the database table.
function orm.Make(tableName, force)

	if IsValid(orm[tableName]) and not force then return orm[tableName] end

	if not sql.TableExists(tableName) then return end

	local primaryKey = sql.GetPrimaryKey(tableName)
	local dataStructure = sql.GetTableColumns(tableName)

	local model = SetupModelFunctions(tableName, primaryKey, dataStructure)

	--baseclass.Set(tableName, model)

	orm[tableName] = model

	return model
end

---
-- Retrieves all saved objects of the model from the database.
-- @return table Returns an array of all found objects.
function ormodel:All()
end

---
-- Deletes the given object from the database storage.
function ormodel:Delete()
end

---
-- Retrieves a specific object by their primarykey from the database.
-- @param int|string|table primaryValue The value(s) of the primarykey to search for.
-- @note In the case of multiple columns in the primarykey you have to specify the corresponding values in the same order.
-- @return table Returns the table of the found object. Returns `false` if the number of supplied primaryvalues does not match the number of elements in the primarykey of that model.
function ormodel:Find(primaryValue)
end

---
-- Creates a new object of the model.
-- @param[opt] table data preexisting data the model should be initialized with.
-- @return table The created object.
function ormodel:New(data)
end

---
-- Saves the data of the given object to the database storage.
function ormodel:Save()
end
