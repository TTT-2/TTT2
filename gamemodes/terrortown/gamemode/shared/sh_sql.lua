---
-- @module SQL
-- @author Alf21
-- @author saibotk

local pairs = pairs
local sql = sql

SQL = {}

--
--
--
--

---
-- Transformes parsed data into usable data
-- Opposite of @{SQL.ParseData}
-- @param string key the data you wanna get
-- @param table data data with data.typ
-- @param table res resource / parsed data
-- @return any usable data
-- @realm shared
-- @todo usage
function SQL.GetParsedData(key, data, res)
	if key == "BaseClass" then return end

	local val = res[key]

	if data.typ == "number" then
		if val == "NULL" then
			val = 0
		else
			val = tonumber(val)
		end
	elseif data.typ == "bool" then
		val = val == "1"
	elseif data.typ == "pos" then
		val = {
			x = tonumber(res[key .. "_x"]),
			y = tonumber(res[key .. "_y"])
		}

		if not val.x or not val.y then
			val = nil
		end
	elseif data.typ == "size" then
		val = {
			w = tonumber(res[key .. "_w"]),
			h = tonumber(res[key .. "_h"])
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
-- Opposite of @{SQL.GetParsedData}
-- @param table tbl table with data
-- @param table keys the data you wanna save
-- @return any parsed data
-- @realm shared
-- @todo usage
function SQL.ParseData(tbl, keys)
	local tmp = {}

	for key, data in pairs(keys) do
		if key == "BaseClass" then continue end

		if tbl[key] ~= nil then
			local dat = tbl[key]

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
	end

	return tmp
end

---
-- Transformes a string into a data string (to work with MySQL)
-- @param string key
-- @param table data data table with data.typ
-- @return string data string
-- @realm shared
-- @todo usage
function SQL.ParseDataString(key, data)
	if key == "BaseClass" then return end

	if data.typ == "bool" or data.typ == "number" then
		return key .. " INTEGER"
	elseif data.typ == "pos" then
		return key .. "_x INTEGER," .. key .. "_y INTEGER"
	elseif data.typ == "size" then
		return key .. "_w INTEGER," .. key .. "_h INTEGER"
	elseif data.typ == "color" then
		return key .. "_r INTEGER," .. key .. "_g INTEGER," .. key .. "_b INTEGER," .. key .. "_a INTEGER"
	end

	return key .. " TEXT"
end

--
--
--
--

---
-- Builds a MySQL "Insert" @{string}
-- @param string tableName name of the MySQL table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return string MySQL "Insert" @{string}
-- @realm shared
-- @todo usage
function SQL.BuildInsertString(tableName, name, tbl, keys)
	if not keys then return end

	local tmp = SQL.ParseData(tbl, keys)

	local str = "INSERT INTO " .. tableName .. " (name"

	for k in pairs(tmp) do
		str = str .. "," .. k
	end

	str = str .. ") VALUES ('" .. name .. "'"

	for _, v in pairs(tmp) do
		str = str .. ",'" .. v .. "'"
	end

	str = str .. ")"

	return str
end

---
-- Builds a MySQL "Update" @{string}
-- @param string tableName name of the MySQL table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return string MySQL "Update" @{string}
-- @realm shared
-- @todo usage
function SQL.BuildUpdateString(tableName, name, tbl, keys)
	if not keys then return end

	local tmp = SQL.ParseData(tbl, keys)

	local b = true
	local str = "UPDATE " .. tableName .. " SET "

	for k, v in pairs(tmp) do
		if not b then
			str = str .. ","
		end

		b = false
		str = str .. k .. "='" .. v .. "'"
	end

	str = str .. " WHERE name='" .. name .. "'"

	return str
end

---
-- Creates the MySQL table
-- @param string tableName the MySQL table name
-- @param table keys the keys for the data @{table}
-- @return boolean Whether the MySQL table was created successfully
-- @realm shared
-- @todo usage
function SQL.CreateSqlTable(tableName, keys)
	local result

	if not sql.TableExists(tableName) then
		local str = "CREATE TABLE " .. tableName .. " (name TEXT PRIMARY KEY"

		for key, data in pairs(keys) do
			str = str .. ", " .. SQL.ParseDataString(key, data)
		end

		str = str .. ")"

		result = sql.Query(str)
	else
		local clmns = sql.Query("PRAGMA table_info(" .. tableName .. ")")

		for key, data in pairs(keys) do
			local exists = false

			for _, col in ipairs(clmns) do
				if col.name == key then
					exists = true
				end
			end

			if not exists then
				local res = SQL.ParseDataString(key, data)

				if not res then continue end

				local resArr = string.Explode(",", res)

				for _, query in ipairs(resArr) do
					sql.Query("ALTER TABLE " .. tableName .. " ADD " .. query)
				end
			end
		end
	end

	return result ~= false
end

---
-- Initializes a MySQL table and inserts all necessary data
-- @param string tableName name of the MySQL table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return table false is returned if there is an error, nil if the query returned no data.
-- @realm shared
-- @todo usage
function SQL.Init(tableName, name, tbl, keys)
	if not keys or table.IsEmpty(keys) then return end

	local query = SQL.BuildInsertString(tableName, name, tbl, keys)

	if not query then return end

	return sql.Query(query)
end

---
-- Saves a MySQL table and updates all necessary data
-- @param string tableName name of the MySQL table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return table false is returned if there is an error, nil if the query returned no data.
-- @realm shared
-- @todo usage
function SQL.Save(tableName, name, tbl, keys)
	if not keys or table.IsEmpty(keys) then return end

	local query = SQL.BuildUpdateString(tableName, name, tbl, keys)

	if not query then return end

	return sql.Query(query)
end

---
-- Loads a MySQL table and set all necessary data of the data @{table}
-- @param string tableName name of the MySQL table
-- @param string name ?
-- @param table tbl data @{table}
-- @param table keys keys for the data @{table}
-- @return table false is returned if there is an error, nil if the query returned no data.
-- @realm shared
-- @todo usage
function SQL.Load(tableName, name, tbl, keys)
	if not keys or table.IsEmpty(keys) then return end

	local result = sql.Query("SELECT * FROM " .. tableName .. " WHERE name = '" .. name .. "'")

	if not result or not result[1] then
		return false, false
	end

	local res = result[1]
	local changed = false

	for key, data in pairs(keys) do
		if key == "BaseClass" then continue end

		local nres = SQL.GetParsedData(key, data, res)
		if nres and (tbl[key] == nil or tbl[key] ~= nres) then
			if nres ~= "NULL" then
				tbl[key] = nres -- override with saved one
			end

			changed = true
		end
	end

	return true, changed
end
