---
-- sql extensions
-- @author Histalek

---
-- Checks if the given string is one of the following: INTEGER, TEXT, REAL, BLOB, NUMERIC.
-- @param string str The string to check.
-- @return boolean Returns true if the string is valid. Returns false otherwise.
function sql.IsValidType(str)
    return str == "INTEGER" or str == "TEXT" or str == "REAL" or str == "BLOB" or str == "NUMERIC"
end

---
-- Checks if the given string is a valid constraint.
-- @param string str The string to check.
-- @return boolean Returns true if the string is a valid constraint.
function sql.IsValidConstraint()
    -- Todo
end

---
-- Returns the given string if it is a valid Type.
-- @param string str The string to check and return
-- @return string Returns the string if valid.
function sql.validateSqlType(str)
    assert(sql.IsValidType(str), str .. " is not a valid database type. (INTEGER, TEXT, REAL, BLOB or NUMERIC expected)")
    return str
end

---
-- Escapes a string for use as an identifier (tablename, columnname) for sqlite.
-- @param string str The string to escape.
-- @return string Returns the escaped string.
function sql.SQLIdent(str)
    return "\"" .. str:gsub( "\"", "\"\"" ) .. "\""
end
