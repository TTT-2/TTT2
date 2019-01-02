local tableName = "ttt2_items"

local pairs = pairs
local sql = sql

local newestVersion = 3
local db_version = CreateConVar("ttt2_item_db_version", tostring(newestVersion), {FCVAR_ARCHIVE})

function ShopEditor.BuildInsertString(name, item, keys)
	keys = keys or ShopEditor.savingKeys

	local tmp = {}

	for key, data in pairs(keys) do
		if item[key] then
			local dat = item[key]

			if data.typ == "bool" then
				dat = dat and 1 or 0
			end

			tmp[key] = dat
		end
	end

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

function ShopEditor.BuildUpdateString(name, item, keys)
	keys = keys or ShopEditor.savingKeys

	local tmp = {}

	for key, data in pairs(keys) do
		if item[key] then
			local dat = item[key]

			if data.typ == "bool" then
				dat = dat and 1 or 0
			end

			tmp[key] = dat
		end
	end

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

function ShopEditor.CreateSqlTable()
	local result

	if not sql.TableExists(tableName) then
		result = sql.Query("CREATE TABLE " .. tableName .. " (name TEXT PRIMARY KEY, credits INTEGER, globalLimited INTEGER, minPlayers INTEGER, limited INTEGER, NoRandom INTEGER)")
	else
		local version = db_version:GetInt()

		if version < 1 or version > newestVersion then
			print("[TTT2][SQL] There is an error with your sql table...")
		elseif version < newestVersion then
			if version < 2 then -- add limited column
				sql.Query("ALTER TABLE " .. tableName .. " ADD limited INTEGER")
			end

			if version < 3 then -- add limited column
				sql.Query("ALTER TABLE " .. tableName .. " ADD NoRandom INTEGER")
			end

			RunConsoleCommand("ttt2_item_db_version", tostring(newestVersion))
		end
	end

	return result ~= false
end

function ShopEditor.InitItem(name, item, keys)
	return sql.Query(ShopEditor.BuildInsertString(name, item, keys))
end

function ShopEditor.SaveItem(name, item, keys)
	return sql.Query(ShopEditor.BuildUpdateString(name, item, keys))
end

function ShopEditor.LoadItem(name, item, keys)
	keys = keys or ShopEditor.savingKeys

	local result = sql.Query("SELECT * FROM " .. tableName .. " WHERE name = '" .. name .. "'")

	if not result or not result[1] then
		return false, false
	end

	local changed = false

	for k, v in pairs(result[1]) do
		for key, data in pairs(keys) do
			if k == key then
				local val = v

				if data.typ == "number" then
					if val == "NULL" then
						val = 0
					else
						val = tonumber(v)
					end
				elseif data.typ == "bool" then
					val = val == "1"
				end

				if not item[k] or item[k] ~= val then
					if v == "NULL" then
						item[k] = item[k] or val -- keep old or init new
					else
						item[k] = val -- override with saved one
					end

					changed = true
				end
			end
		end
	end

	return true, changed
end
