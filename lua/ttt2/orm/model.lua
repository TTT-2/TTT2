---
-- Object Relational Model
-- @author Histalek

local ormodel = {}

---
-- Creates a model with the given name and datastructure which (for now) includes an autoincrementing primarykey.
-- @param string tableName The name of the model and hence the tablename in the database.
-- @param table dataStructure The datastructure of the model. An array containing a table for each column/datavalue, with the identifier and the type of the data.
-- @usage model = makeORModel("myOwnTable", {{colname = "name", coltype = "TEXT"}, {colname = "percent", coltype = "REAL"}, {colname = "count", coltype = "INTEGER"}})
-- @realm shared
-- @return table The created model.
function makeORModel(tableName, dataStructure)
    local model = table.Copy(ormodel)

    sanTableName = sql.SQLStr(tableName)

    model._tableName = tableName
    --model._datastructure = datastructure
    --model._primaryKey = primaryKey

    if not sql.TableExists(tableName) then
        local query = "CREATE TABLE " .. sanTableName .. " (id INTEGER PRIMARY KEY AUTOINCREMENT"

        -- populate columns with dataStructure
        for _, v in ipairs(dataStructure) do
            query = query .. ", " .. sql.SQLStr(v.colname) .. " " .. sql.SQLStr(v.coltype)
        end

        query = query .. ")"

        sql.Query(query)
    end

    -- this might be completely dumb
    model.save = function(self)

        if not self._id then
            local query = "INSERT INTO " .. sanTableName .. " VALUES (NULL"

            for _, v in ipairs(dataStructure) do
                query = query .. ", " .. (sql.SQLStr(self[v.colname] or "NULL"))
            end

            query = query .. ")"

            sql.Query(query)
            self._id = sql.QueryValue("SELECT last_insert_rowid()")
        else
            local query = "UPDATE " .. sanTableName .. " SET id=id"

            for k, v in ipairs(dataStructure) do
                query = query .. ", " .. v.colname .. "=" .. (sql.SQLStr(self[v.colname] or "NULL"))
            end

            query = query .. " WHERE id=" .. sql.SQLStr(self._id)
            sql.Query(query)
        end
    end

    model.delete = function(self)
        return sql.Query("DELETE FROM " .. sanTableName .. " WHERE id=" .. sql.SQLStr(self._id))
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
    return sql.Query("SELECT * FROM " .. sql.SQLStr(self._tableName))
end

---
-- Retrieves a specific object by their primarykey from the database.
-- @param number|string primaryValue The value of the primarykey to search for.
-- @return table Returns the table of the found object.
function ormodel:find(primaryValue)
    return sql.QueryRow("SELECT * FROM " .. sql.SQLStr(self._tableName) .. " WHERE id=" .. sql.SQLStr(primaryValue))
end

---
-- Deletes the given object from the database storage.
-- @note This function will be defined when the model is made.
-- @see `makeORModel()`
-- @return boolean Returns if the deletion was successful.
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
    local mymodel = makeORModel("a_`better_test", {{colname = "testing", coltype = "TEXT"}, {colname = "percent", coltype = "REAL"}, {colname = "jup", coltype = "INTEGER"}})

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
    print(myobject:delete())

    if not IsValid(mymodel:find(myobject._id)) then return end

    PrintTable(mymodel:find(myobject._id))
end)
