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
-- Creates a model with the given name and datastructure.
-- @param string tableName The name of the model and hence the tablename in the database.
-- @param table dataStructure The datastructure of the model. An array containing a table for each column/datavalue, with the identifier and the type of the data.
-- @param[default="_rowid"] table primaryKey The primarykey of the database table. Should match one or multiple `colname` from the dataStructure.
-- @usage model = makeORModel("myOwnTable", {{colname = "name", coltype = "TEXT"}, {colname = "percent", coltype = "REAL"}, {colname = "count", coltype = "INTEGER"}}, {"name", "count"})
-- @realm shared
-- @return table The created model.
function makeORModel(tableName, dataStructure, primaryKey)
    local model = table.Copy(ormodel)
    local sanTableName = sql.SQLIdent(tableName)

    primaryKey = primaryKey or {"_rowid"}

    model._tableName = tableName
    model._primaryKey = primaryKey
    model._dataStructure = dataStructure

    if not sql.TableExists(tableName) then
        local query = "CREATE TABLE " .. sanTableName .. " ("

        -- populate columns with dataStructure
        for _, v in ipairs(dataStructure) do
            query = query .. sql.SQLIdent(v.colname) .. " " .. sql.validateSqlType(v.coltype) .. ", "
        end

        -- delete ", " from the last concatenation
        query = string.sub(query, 1, -3)

        if primaryKey[1] ~= "_rowid" then
            query = query .. ", PRIMARY KEY ("
            for _, v in ipairs(primaryKey) do
                query = query .. sql.SQLIdent(v) .. ", "
            end
            query = string.sub(query, 1, -3) .. ")"
        end

        sql.Query(query .. ")")
    end

    model:Init()

    baseclass.Set(tableName, model)

    return model
end

function ormodel:Init()

    local sanTableName = sql.SQLIdent(self._tableName)
    local dataStructure = self._dataStructure

    self.save = function(this)

        if IsValid(this._rowid) then

            local updateQuery = "UPDATE " .. sanTableName .. " SET "

            for _, v in ipairs(dataStructure) do
                updateQuery = updateQuery .. sql.SQLIdent(v.colname) .. "=" .. (sql.SQLStr(this[v.colname] or "NULL")) .. ", "
            end

            updateQuery = string.sub(updateQuery, 1, -3) .. " WHERE _rowid_=" .. sql.SQLStr(this._rowid)

            sql.Query(updateQuery)

        else
            local insertQuery = "INSERT INTO " .. sanTableName .. " ("
            local columns = ""
            local columnvalues = ""

            for _, v in ipairs(dataStructure) do
                columns = columns .. sql.SQLIdent(v.colname) .. ", "
                columnvalues = columnvalues .. (sql.SQLStr(this[v.colname] or "NULL")) .. ", "
            end

            insertQuery = insertQuery .. string.sub(columns, 1, -3) .. ") VALUES (" .. string.sub(columnvalues, 1, -3) .. ")"

            sql.Query(insertQuery)

            this._rowid = sql.QueryValue("SELECT last_insert_rowid()")
        end
    end

    self.delete = function(this)

        if not IsValid(this._rowid) then return end

        return sql.Query("DELETE FROM " .. sanTableName .. " WHERE _rowid_=" .. sql.SQLStr(this._rowid))
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
-- @param table primaryValue The value(s) of the primarykey(s) to search for.
-- @note In the case of multiple primarykeys you have to specify the corresponding values in the same order.
-- @return table Returns the table of the found object.
function ormodel:find(primaryValue)
    local where = ""

    for i, v in ipairs(primaryValue) do
        where = where .. sql.SQLIdent(self._primaryKey[i]) .. "=" .. sql.SQLStr(v) .. " AND "
    end

    return sql.QueryRow("SELECT * FROM " .. sql.SQLIdent(self._tableName) .. " WHERE " .. string.sub(where, 1, -6))
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

    PrintTable(mymodel:find({myobject._rowid}))

    myobject.testing = "you should` read this"
    myobject.percent = 6.78
    myobject.jop = 4444

    myobject:save()

    PrintTable(mymodel:find({myobject._rowid}))
    PrintTable(mymodel:all())

    myobject:delete()
    if not IsValid(mymodel:find({myobject._rowid})) then
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
