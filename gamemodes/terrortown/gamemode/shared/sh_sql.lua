---
-- @author Alf21
-- @author saibotk
-- @module sql

local pairs = pairs

sql = sql or {}

--
--
--
--

---
-- Transformes parsed data into usable data
-- Opposite of @{sql.ParseData}
-- @param string key the data you wanna get
-- @param table data data with data.typ
-- @param table res resource / parsed data
-- @return any usable data
-- @realm shared
-- @todo usage
function sql.GetParsedData(key, data, res)
    if key == "BaseClass" then
        return
    end

    local val = res[key]

    if val == "NULL" then
        return nil
    end

    if data.typ == "number" or data.typ == "float" then
        val = tonumber(val)
    elseif data.typ == "bool" then
        val = val == "1"
    elseif data.typ == "pos" then
        val = {
            x = tonumber(res[key .. "_x"]),
            y = tonumber(res[key .. "_y"]),
        }

        if not val.x or not val.y then
            val = nil
        end
    elseif data.typ == "size" then
        val = {
            w = tonumber(res[key .. "_w"]),
            h = tonumber(res[key .. "_h"]),
        }

        if not val.w or not val.h then
            val = nil
        end
    elseif data.typ == "color" then
        val = {}
        val.r = tonumber(res[key .. "_r"])
        val.g = tonumber(res[key .. "_g"])
        val.b = tonumber(res[key .. "_b"])
        val.a = tonumber(res[key .. "_a"] or 255)

        if not val.r or not val.g or not val.b then
            val = nil
        else
            val = Color(val.r, val.g, val.b, val.a)
        end
    end

    return val
end

---
-- Transformes usable data into parsed data
-- Opposite of @{sql.GetParsedData}
-- @param table tbl table with data
-- @param table keys the data you wanna save
-- @return any parsed data
-- @realm shared
-- @todo usage
function sql.ParseData(tbl, keys)
    local tmp = {}

    for key, data in pairs(keys) do
        if key == "BaseClass" then
            continue
        end

        local dat = tbl[key]

        if dat == nil then
            dat = data.default
        end

        if dat == nil then
            continue
        end

        if data.typ == "bool" then
            dat = dat and 1 or 0

            tmp[key] = dat
        elseif data.typ == "pos" then
            tmp[key .. "_x"] = dat.x or 0
            tmp[key .. "_y"] = dat.y or 0
        elseif data.typ == "size" then
            tmp[key .. "_w"] = dat.w or 0
            tmp[key .. "_h"] = dat.h or 0
        elseif data.typ == "color" then
            tmp[key .. "_r"] = dat.r or 255
            tmp[key .. "_g"] = dat.g or 255
            tmp[key .. "_b"] = dat.b or 255
            tmp[key .. "_a"] = dat.a or 255
        else
            tmp[key] = dat
        end
    end

    return tmp
end

---
-- Transformes a string into a data string (to work with SQL)
-- @param string key
-- @param table data data table with data.typ
-- @return string data string
-- @realm shared
-- @todo usage
function sql.ParseDataString(key, data)
    if key == "BaseClass" then
        return
    end

    local sanitizedKey = sql.SQLStr(key, true)

    if data.typ == "bool" or data.typ == "number" then
        return sanitizedKey .. " INTEGER"
    elseif data.typ == "float" then
        return sanitizedKey .. " REAL"
    elseif data.typ == "pos" then
        return sanitizedKey .. "_x INTEGER," .. sanitizedKey .. "_y INTEGER"
    elseif data.typ == "size" then
        return sanitizedKey .. "_w INTEGER," .. sanitizedKey .. "_h INTEGER"
    elseif data.typ == "color" then
        return sanitizedKey
            .. "_r INTEGER,"
            .. sanitizedKey
            .. "_g INTEGER,"
            .. sanitizedKey
            .. "_b INTEGER,"
            .. sanitizedKey
            .. "_a INTEGER"
    end

    return sanitizedKey .. " TEXT"
end

--
--
--
--

---
-- Builds a SQL "Insert" @{string}
-- @param string tableName name of the database table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return string SQL "Insert" @{string}
-- @realm shared
-- @todo usage
function sql.BuildInsertString(tableName, name, tbl, keys)
    if not keys then
        return
    end

    local tmp = sql.ParseData(tbl, keys)

    local str = "INSERT INTO " .. sql.SQLStr(tableName) .. " (name"

    for k in pairs(tmp) do
        str = str .. "," .. sql.SQLStr(k)
    end

    str = str .. ") VALUES (" .. sql.SQLStr(name)

    for _, v in pairs(tmp) do
        str = str .. "," .. sql.SQLStr(v)
    end

    str = str .. ")"

    return str
end

---
-- Builds a SQL "Update" @{string}
-- @param string tableName name of the database table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return string SQL "Update" @{string}
-- @realm shared
-- @todo usage
function sql.BuildUpdateString(tableName, name, tbl, keys)
    if not keys then
        return
    end

    local tmp = sql.ParseData(tbl, keys)

    local b = true
    local str = "UPDATE " .. sql.SQLStr(tableName) .. " SET "

    for k, v in pairs(tmp) do
        if not b then
            str = str .. ","
        end

        b = false
        str = str .. sql.SQLStr(k) .. "=" .. sql.SQLStr(v)
    end

    str = str .. " WHERE name=" .. sql.SQLStr(name)

    return str
end

---
-- Creates the database table
-- @param string tableName the database table name
-- @param table keys the keys for the data @{table}
-- @return boolean Whether the database table was created successfully
-- @realm shared
-- @todo usage
function sql.CreateSqlTable(tableName, keys)
    local result

    if not sql.TableExists(tableName) then
        local str = "CREATE TABLE " .. sql.SQLStr(tableName) .. " (name TEXT PRIMARY KEY"

        for key, data in pairs(keys) do
            str = str .. ", " .. sql.ParseDataString(key, data)
        end

        str = str .. ")"

        result = sql.Query(str)
    else
        local clmns = sql.Query("PRAGMA table_info(" .. sql.SQLStr(tableName) .. ")")

        for key, data in pairs(keys) do
            local exists = false

            for i = 1, #clmns do
                if clmns[i].name ~= key then
                    continue
                end

                exists = true
            end

            if exists then
                continue
            end

            local res = sql.ParseDataString(key, data)
            if not res then
                continue
            end

            local resArr = string.Explode(",", res)

            for i = 1, #resArr do
                sql.Query("ALTER TABLE " .. sql.SQLStr(tableName) .. " ADD " .. resArr[i])
            end
        end
    end

    return result ~= false
end

---
-- Initializes a database table and inserts all necessary data
-- @param string tableName name of the database table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return table false is returned if there is an error, nil if the query returned no data.
-- @realm shared
-- @todo usage
function sql.Init(tableName, name, tbl, keys)
    if not keys or table.IsEmpty(keys) then
        return
    end

    local query = sql.BuildInsertString(tableName, name, tbl, keys)
    if not query then
        return
    end

    return sql.Query(query)
end

---
-- Saves/updates all necessary data in the database table.
-- @param string tableName name of the database table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return table false is returned if there is an error, nil if the query returned no data.
-- @realm shared
-- @todo usage
function sql.Save(tableName, name, tbl, keys)
    if not keys or table.IsEmpty(keys) then
        return
    end

    local query = sql.BuildUpdateString(tableName, name, tbl, keys)
    if not query then
        return
    end

    return sql.Query(query)
end

---
-- Loads a database table and set all necessary data of the data @{table}
-- @param string tableName name of the database table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return table false is returned if there is an error, nil if the query returned no data.
-- @return boolean returns whether there is a difference between the given data `tbl` and the sqlite data,
-- so that's an indicator whether old data was overwritten
-- @realm shared
-- @todo usage
function sql.Load(tableName, name, tbl, keys)
    if not keys or table.IsEmpty(keys) then
        return
    end

    local result =
        sql.Query("SELECT * FROM " .. sql.SQLStr(tableName) .. " WHERE name = " .. sql.SQLStr(name))

    if not result or not result[1] then
        return false, false
    end

    local res = result[1]
    local changed = false

    for key, data in pairs(keys) do
        if key == "BaseClass" then
            continue
        end

        local nres = sql.GetParsedData(key, data, res)
        if nres == nil or nres == "NULL" or tbl[key] == nres then
            continue
        end

        tbl[key] = nres -- overwrite with saved one
        changed = true
    end

    return true, changed
end
