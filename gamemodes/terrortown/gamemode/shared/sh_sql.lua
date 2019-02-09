local pairs = pairs
local sql = sql

SQL = {}

function SQL.GetParsedData(key, data, res)
	local val = res[key]

	if val then
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
				x = res[key .. "_x"],
				y = res[key .. "_y"]
			}
		elseif data.typ == "size" then
			val = {
				w = res[key .. "_w"],
				h = res[key .. "_h"]
			}
		end
	end

	return val
end

function SQL.ParseData(tbl, keys)
	local tmp = {}

	for key, data in pairs(keys) do
		if tbl[key] ~= nil then
			local dat = tbl[key]

			if data.typ == "bool" then
				dat = dat and 1 or 0

				tmp[key] = dat
			elseif data.typ == "pos" then
				tmp[key .. "_x"] = dat.x
				tmp[key .. "_y"] = dat.y
			elseif data.typ == "size" then
				tmp[key .. "_w"] = dat.w
				tmp[key .. "_h"] = dat.h
			else
				tmp[key] = dat
			end
		end
	end

	return tmp
end

function SQL.ParseDataString(key, data)
	if data.typ == "bool" or data.typ == "number" then
		return key .. " INTEGER"
	elseif data.typ == "pos" then
		return key .. "_x INTEGER," .. key .. "_y INTEGER"
	elseif data.typ == "size" then
		return key .. "_w INTEGER," .. key .. "_h INTEGER"
	end

	return key .. " TEXT"
end

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
				sql.Query("ALTER TABLE " .. tableName .. " ADD " .. SQL.ParseDataString(key, data))
			end
		end
	end

	return result ~= false
end

function SQL.Init(tableName, name, tbl, keys)
	return sql.Query(SQL.BuildInsertString(tableName, name, tbl, keys))
end

function SQL.Save(tableName, name, tbl, keys)
	return sql.Query(SQL.BuildUpdateString(tableName, name, tbl, keys))
end

function SQL.Load(tableName, name, tbl, keys)
	if not keys then return end

	local result = sql.Query("SELECT * FROM " .. tableName .. " WHERE name = '" .. name .. "'")

	if not result or not result[1] then
		return false, false
	end

	local res = result[1]
	local changed = false

	for key, data in pairs(keys) do
		local nres = res[key]
		if nres then
			local val = SQL.GetParsedData(key, data, res)

			if tbl[key] == nil or tbl[key] ~= val then
				if nres == "NULL" then
					tbl[key] = tbl[key] or val -- keep old or init new
				else
					tbl[key] = val -- override with saved one
				end

				changed = true
			end
		end
	end

	return true, changed
end
