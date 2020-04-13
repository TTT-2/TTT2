---
-- Object Relational Model
-- @author Histalek

local baseclass = baseclass
local ipairs = ipairs
local sql = sql
local table = table
local string = string

local ormodel = {}

---
-- Creates a model with the given name and datastructure which (for now) includes an autoincrementing primarykey.
-- @param string tableName The name of the model and hence the tablename in the database.
-- @param table dataStructure The datastructure of the model. An array containing a table for each column/datavalue, with the identifier and the type of the data.
-- @param string primaryKey The primarykey of the database table. If not explicitly set it will generate an autoincrementing INTEGER primary key. Should match one or multiple `colname` from the dataStructure seperated by `,`.
-- @usage model = makeORModel("myOwnTable", {{colname = "name", coltype = "TEXT"}, {colname = "percent", coltype = "REAL"}, {colname = "count", coltype = "INTEGER"}}, "name, count")
-- @realm shared
-- @return table The created model.
function makeORModel(tableName, dataStructure, primaryKey)
    local model = table.Copy(ormodel)

    local sanTableName = sql.SQLIdent(tableName)

    model._tableName = tableName
    --model._datastructure = datastructure
    model._primaryKey = primaryKey

    if not sql.TableExists(tableName) then
        local query = "CREATE TABLE " .. sanTableName .. " ("
        local columndata

        -- populate columns with dataStructure
        for _, v in ipairs(dataStructure) do
            if not columndata then
                columndata = sql.SQLIdent(v.colname) .. " " .. sql.validateSqlType(v.coltype)
            else
                columndata = columndata .. ", " .. sql.SQLIdent(v.colname) .. " " .. sql.validateSqlType(v.coltype)
            end
        end

        if primaryKey then
            columndata = columndata .. ", PRIMARY KEY (" .. primaryKey .. ")" -- TODO escape primaryKey
        else
            columndata = columndata .. ", " .. "id INTEGER PRIMARY KEY AUTOINCREMENT"
        end

        query = query .. columndata .. ")"

        if primaryKey then
            query = query .. "WITHOUT ROWID;"
        end

        sql.Query(query)
    end

    -- this might be completely dumb
    model.save = function(self)
        sql.Begin()

        local updateQuery = "UPDATE " .. sanTableName .. " SET "
        local columndata

        -------START UPDATE QUERY ----------------
        for _, v in ipairs(dataStructure) do
            if not columndata then
                columndata = sql.SQLIdent(v.colname) .. "=" .. (sql.SQLStr(self[v.colname] or "NULL"))
            else
                columndata = columndata .. ", " .. sql.SQLIdent(v.colname) .. "=" .. (sql.SQLStr(self[v.colname] or "NULL"))
            end
        end

        updateQuery = updateQuery .. columndata

        if not primaryKey then
            updateQuery = updateQuery .. " WHERE id=" .. sql.SQLStr(self._id)
        elseif not string.find(primaryKey, ",") then
            updateQuery = updateQuery .. " WHERE " .. sql.SQLIdent(primaryKey) .. sql.SQLStr(self[primaryKey])
        else
            local keys = string.Explode(",", primaryKey)
            local where

            for _, v in ipairs(keys) do
                if not where then
                    where = sql.SQLIdent(v) .. "=" .. sql.SQLStr(self[v])
                else
                    where = where .. " AND " .. sql.SQLIdent(v) .. "=" .. sql.SQLStr(self[string.Trim(v)])
                end
            end
        end

        sql.Query(updateQuery)
        -------END UPDATE QUERY ----------------

        -------START INSERT QUERY ----------------
        local insertQuery = "INSERT OR IGNORE INTO " .. sanTableName .. " ("
        local columns
        local columnvalues

        for _, v in ipairs(dataStructure) do
            if not columns then
                columns = sql.SQLIdent(v.colname)
            else
                columns = columns .. ", " .. sql.SQLIdent(v.colname)
            end

            if not columnvalues then
                columnvalues = (sql.SQLStr(self[v.colname] or "NULL"))
            else
                columnvalues = columnvalues .. ", " .. (sql.SQLStr(self[v.colname] or "NULL"))
            end
        end

        insertQuery = insertQuery .. columns .. ") VALUES (" .. columnvalues .. ")"

        sql.Query(insertQuery)
        -------END INSERT QUERY ----------------

        if not self._id and not primaryKey then
            self._id = sql.QueryValue("SELECT last_insert_rowid()")
        end

        sql.Commit()
    end

    model.delete = function(self)
        if not primaryKey then
            return sql.Query("DELETE FROM " .. sanTableName .. " WHERE id=" .. sql.SQLStr(self._id))
        elseif not string.find(primaryKey, ",") then
            return sql.Query("DELETE FROM " .. sanTableName .. " WHERE " .. sql.SQLIdent(primaryKey) .. "=" .. sql.SQLStr(self[primaryKey]))
        else
            local keys = string.Explode(",", primaryKey)
            local where

            for _, v in ipairs(keys) do
                if not where then
                    where = sql.SQLIdent(v) .. "=" .. self[v]
                else
                    where = where .. " AND " .. sql.SQLIdent(v) .. "=" .. self[string.Trim(v)]
                end
            end

            sql.Query("DELETE FROM " .. sanTableName .. " WHERE " .. where)
        end
    end

    baseclass.Set(tableName, model)

    return model
end

---
-- Creates a new object of the model.
-- @return table The created object.
function ormodel:new()
    local object = {}

    object.BaseClass = baseclass.Get(self._tableName)

    object.save = object.BaseClass.save
    object.delete = object.BaseClass.delete

    return object
end

---
-- Retrieves all saved objects of the model from the database.
-- @return table Returns an array of all found objects.
function ormodel:all()
    return sql.Query("SELECT * FROM " .. sql.SQLIdent(self._tableName))
end

---
-- Retrieves a specific object by their primarykey from the database.
-- @param number|string primaryValue The value of the primarykey to search for.
-- @note Only works for models with one primarykey.
-- @return table Returns the table of the found object.
function ormodel:find(primaryValue)

    if string.find(self._primaryKey, ",") then return end

    if not self._primaryKey then
        return sql.QueryRow("SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE id=" .. sql.SQLStr(primaryValue))
    else
        return sql.QueryRow("SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. sql.SQLIdent(self._primaryKey) .. "=" .. sql.SQLStr(primaryValue))
    end
end

---
-- Deletes the given object from the database storage.
-- @note This function will be defined when the model is made.
-- @see `makeORModel()`
function ormodel:delete()
end

---
-- Saves the data of the given object to the database storage.
-- @note This function will be defined when the model is made.
-- @see `makeORModel()`
function ormodel:save()
end

-- testing / example usage
hook.Add("TTTBeginRound", "ormtest", function()
    local mymodel = makeORModel("a_new`_test", {{colname = "testing", coltype = "TEXT"}, {colname = "percent", coltype = "REAL"}, {colname = "jup", coltype = "INTEGER"}})
    local myobject = mymodel:new()

    myobject.testing = "hello world! x2"
    myobject.percent = 1.5464532
    myobject.jop = 345

    myobject:save()

    PrintTable(mymodel:find(myobject._id))

    myobject.testing = "you should` read this"
    myobject.percent = 6.78
    myobject.jop = 4444

    myobject:save()

    PrintTable(mymodel:find(myobject._id))
    PrintTable(mymodel:all())

    myobject:delete()
    if not IsValid(mymodel:find(myobject._id)) then
        print("Successfully deleted myobject from database")
    end

    local myothermodel = makeORModel("something_stupid", {{colname = "name", coltype = "TEXT"}, {colname = "percent", coltype = "REAL"}, {colname = "number", coltype = "INTEGER"}}, "name, percent")
    local myotherobject = myothermodel:new()

    myotherobject.name = "jackal"
    myotherobject.percent = 0.13
    myotherobject.number = 6

    myotherobject:save()

    myotherobject:delete()

    PrintTable(myothermodel:all())
end)
