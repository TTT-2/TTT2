---
-- Object Relational Model
-- @author Histalek

local baseclass = baseclass
local ipairs = ipairs
local sql = sql
local table = table
local istable = istable
local string = string

local ormodel = {}

---
-- Creates a model with the given name and datastructure.
-- @param string tableName The name of the model and hence the tablename in the database.
-- @param table dataStructure The datastructure of the model. An array containing a table for each column/datavalue, with the identifier and the type of the data.
-- @param[default="_rowid_"] string|table primaryKey The primarykey of the database table. Should match one or multiple `colname` from the dataStructure.
-- @usage model = makeORModel("myOwnTable", {{colname = "name", coltype = "TEXT"}, {colname = "percent", coltype = "REAL"}, {colname = "count", coltype = "INTEGER"}}, {"name", "count"})
-- @realm shared
-- @return table The created model.
function makeORModel(tableName, dataStructure, primaryKey)
    local model = table.Copy(ormodel)
    local sanTableName = sql.SQLIdent(tableName)

    primaryKey = primaryKey or "_rowid_"

    model._tableName = tableName
    model._primaryKey = primaryKey

    if not sql.TableExists(tableName) then
        local query = "CREATE TABLE " .. sanTableName .. " ("
        local columndata = ""

        -- populate columns with dataStructure
        for _, v in ipairs(dataStructure) do
            columndata = columndata .. sql.SQLIdent(v.colname) .. " " .. sql.validateSqlType(v.coltype) .. ", "
        end

        -- delete ", " from the last concatenation
        columndata = string.sub(columndata, 1, -3)

        if primaryKey ~= "_rowid_" then
            columndata = columndata .. ", PRIMARY KEY (" .. sql.SQLIdent(primaryKey) .. ")"
        end

        query = query .. columndata .. ")"

        sql.Query(query)
    end

    model:Init()

    baseclass.Set(tableName, model)

    return model
end

function ormodel:Init()

    local sanTableName = sql.SQLIdent(self._tableName)
    local primaryKey = self._primaryKey

    self.save = function(this)
        sql.Begin()

        local updateQuery = "UPDATE " .. sanTableName .. " SET "
        local columndata = ""

        -------START UPDATE QUERY ----------------
        for _, v in ipairs(dataStructure) do
            columndata = columndata .. sql.SQLIdent(v.colname) .. "=" .. (sql.SQLStr(this[v.colname] or "NULL")) .. ", "
        end

        updateQuery = updateQuery .. string.sub(columndata, 1, -3)

        if not istable(primaryKey) then
            updateQuery = updateQuery .. " WHERE " .. sql.SQLIdent(primaryKey) .. sql.SQLStr(this[primaryKey])
        else
            local where = ""

            for _, v in ipairs(primaryKey) do
                where = where .. sql.SQLIdent(v) .. "=" .. sql.SQLStr(this[v]) .. " AND "
            end

            -- delete " AND " of the last concatenation
            where = string.sub(where, 1, -6)
        end

        sql.Query(updateQuery)
        -------END UPDATE QUERY ----------------

        -------START INSERT QUERY ----------------
        local insertQuery = "INSERT OR IGNORE INTO " .. sanTableName .. " ("
        local columns = ""
        local columnvalues = ""

        for _, v in ipairs(dataStructure) do
            columns = columns .. sql.SQLIdent(v.colname) .. ", "
            columnvalues = columnvalues .. (sql.SQLStr(this[v.colname] or "NULL")) .. ", "
        end

        insertQuery = insertQuery .. string.sub(columns, 1, -3) .. ") VALUES (" .. string.sub(columnvalues, 1, -3) .. ")"

        sql.Query(insertQuery)
        -------END INSERT QUERY ----------------

        if not this._rowid_ and primaryKey == "_rowid_" then
            this._rowid_ = sql.QueryValue("SELECT last_insert_rowid()")
        end

        sql.Commit()
    end

    self.delete = function(this)
        if not istable(primaryKey) then
            return sql.Query("DELETE FROM " .. sanTableName .. " WHERE " .. sql.SQLIdent(primaryKey) .. "=" .. sql.SQLStr(this[primaryKey]))
        else
            local where = ""

            for _, v in ipairs(primaryKey) do
                where = where .. sql.SQLIdent(v) .. "=" .. this[v] .. " AND "
            end

            return sql.Query("DELETE FROM " .. sanTableName .. " WHERE " .. string.sub(where, 1, -6))
        end
    end
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

    if istable(self._primaryKey) then return end

    return sql.QueryRow("SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. sql.SQLIdent(self._primaryKey) .. "=" .. sql.SQLStr(primaryValue))
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

    local myothermodel = makeORModel("something_stupid", {{colname = "name", coltype = "TEXT"}, {colname = "percent", coltype = "REAL"}, {colname = "number", coltype = "INTEGER"}}, {"name", "percent"})
    local myotherobject = myothermodel:new()

    myotherobject.name = "jackal"
    myotherobject.percent = 0.13
    myotherobject.number = 6

    myotherobject:save()

    myotherobject:delete()

    PrintTable(myothermodel:all())
end)
