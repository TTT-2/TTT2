---
-- sql extensions
-- @author Histalek

---
-- Checks if the specified column exists in the specified table.
-- @param string tableName The name of the table to search.
-- @param string columnName The name of the column to check.
-- @return boolean Returns true if the column exists in the table.
function sql.ColumnExists(tableName, columnName)
    return sql.Query("SELECT COUNT(*) FROM pragma_table_info(" .. sql.SQLIdent(tableName) .. ") WHERE name=" .. sql.SQLStr(columnName)) == 1
end

---
-- Returns the Primarykey columns of the specified table in order of their index.
-- @param string tableName The name of the table to search.
-- @return table|nil Returns a table of the Primarykey columns.
function sql.GetPrimaryKey(tableName)
    return sql.Query("SELECT name FROM pragma_table_info(" .. sql.SQLIdent(tableName) .. ") WHERE pk!=0 ORDER BY pk")
end

---
-- Returns the column names of the specified table.
-- @param string tableName The name of the table to search.
-- @return table|nil Returns a table of the column names.
function sql.GetTableColumns(tableName)
    return sql.Query("SELECT name FROM pragma_table_info(" .. sql.SQLIdent(tableName) .. ")")
end

---
-- Escapes a string for use as an identifier (tablename, columnname) for sqlite.
-- @param string str The string to escape.
-- @return string Returns the escaped string.
function sql.SQLIdent(str)
    return "\"" .. str:gsub( "\"", "\"\"" ) .. "\""
end

---
-- Undoes all queries of the last transaction started by `sql.Begin()`.
-- This is equivalent to `sql.Query("Rollback;")`.
function sql.Rollback()
    sql.Query("Rollback;")
end
