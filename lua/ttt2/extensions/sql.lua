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
-- @return table|nil Returns a table of the primarykey columns.
function sql.GetPrimaryKey(tableName)
	local result = sql.Query("PRAGMA table_info(" .. sql.SQLIdent(tableName) .. ")")
	local primaryKeys = {}

	for i = 1, #result do
		local pk = tonumber(result[i].pk)
		if pk ~= 0 then
			primaryKeys[pk] = result[i].name
		end
	end

	return primaryKeys
end

---
-- Returns the foreignkeys of the specified table.
-- @param string tableName The name of the table to search.
-- @return table|nil Returns a table of the foreignkey columns.
function sql.GetForeignKeys(tableName)
	local result = sql.Query("PRAGMA foreign_key_list(" .. sql.SQLIdent(tableName) .. ")")
	local foreignKeys = {}

	if not result then return end

	for i = 1, #result do
		local ressultRow = result[i]
		local id = tonumber(ressultRow.id)
		local seq = tonumber(ressultRow.seq)
		local foreignKeysRow = foreignKeys[id][seq]

		foreignKeysRow.table = ressultRow.table
		foreignKeysRow.from = ressultRow.from
		foreignKeysRow.to = ressultRow.to
	end

	return foreignKeys
end

---
-- Returns the column names of the specified table.
-- @param string tableName The name of the table to search.
-- @return table|nil Returns a table of the column names.
function sql.GetTableColumns(tableName)
	local result = sql.Query("PRAGMA table_info(" .. sql.SQLIdent(tableName) .. ")")
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
function sql.SQLIdent(str)
	return "\"" .. str:gsub("\"", "\"\"") .. "\""
end

---
-- Undoes all queries of the last transaction started by `sql.Begin()`.
-- This is equivalent to `sql.Query("Rollback;")`.
function sql.Rollback()
	sql.Query("Rollback;")
end
