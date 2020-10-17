---
-- sql extensions
-- @author Histalek

if SERVER then
	AddCSLuaFile()
end

---
-- Checks if the specified column exists in the specified table.
-- @param string tableName The name of the table to search.
-- @param string columnName The name of the column to check.
-- @return boolean Returns true if the column exists in the table.
-- @realm shared
function sql.ColumnExists(tableName, columnName)
	local result = sql.Query("PRAGMA table_info(" .. sql.SQLIdent(tableName) .. ")")

	for i = 1, #result do
		if result[i].name == columnName then
			return true
		end
	end

	return false
end

---
-- Returns the primarykey column names of the specified table in order of their index.
-- @param string tableName The name of the table to search.
-- @return table|nil|false Returns a table of the primarykey columns, nil if no columns are found and false in case of an error.
-- @realm shared
function sql.GetPrimaryKey(tableName)
	local result = sql.Query("PRAGMA table_info(" .. sql.SQLIdent(tableName) .. ")")

	if not result then
		return result
	end

	local primaryKeys = {}

	for i = 1, #result do
		local pk = result[i].pk
		if tonumber(pk) ~= 0 then
			primaryKeys[pk] = result[i].name
		end
	end

	return primaryKeys
end

---
-- Returns the foreignkeys of the specified table.
-- @param string tableName The name of the table to search.
-- @return table|nil|false Returns a table of the foreignkey columns, nil if no columns are found and false in case of an error.
-- @realm shared
function sql.GetForeignKeys(tableName)
	local result = sql.Query("PRAGMA foreign_key_list(" .. sql.SQLIdent(tableName) .. ")")

	if not result then
		return result
	end

	local foreignKeys = {}

	for i = 1, #result do
		local resultRow = result[i]
		local id = tonumber(resultRow.id)
		local seq = tonumber(resultRow.seq)
		local foreignKeysRow = foreignKeys[id][seq]

		foreignKeysRow.table = resultRow.table
		foreignKeysRow.from = resultRow.from
		foreignKeysRow.to = resultRow.to
	end

	return foreignKeys
end

---
-- Returns the column names of the specified table.
-- @param string tableName The name of the table to search.
-- @return table|nil|false Returns a table of the column names, nil if no columns are found and false in case of an error.
-- @realm shared
function sql.GetTableColumns(tableName)
	local result = sql.Query("PRAGMA table_info(" .. sql.SQLIdent(tableName) .. ")")

	if not result then
		return result
	end

	local columnNames = {}

	for i = 1, #result do
		columnNames[i] = result[i].name
	end

	return columnNames
end

---
-- Escapes a string for use as an identifier (tablename, columnname) for sqlite.
-- @param string str The string to escape.
-- @return string Returns the escaped string.
-- @realm shared
function sql.SQLIdent(str)
	return "\"" .. str:gsub("\"", "\"\"") .. "\""
end

---
-- Undoes all queries of the last transaction started by `sql.Begin()`.
-- This is equivalent to `sql.Query("Rollback;")`.
-- @realm shared
function sql.Rollback()
	sql.Query("Rollback;")
end
