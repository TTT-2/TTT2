---
-- @class PANEL
-- @section TTT2:DPanel/Settings

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bDisplayInverted", "Inverted", FORCE_BOOL_IS, true)

local callbackEnabledVarTracker = 0

---
-- Sets the attached variable type, used for internal parsing.
-- @param number varType The variable type
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetVariableType(varType)
    self.m_nVarType = varType

    return self
end

---
-- Returns the assigned variable type.
-- @return boolean The variable type
-- @realm client
function METAPANEL:GetVariableType()
    return self.m_nVarType or TYPE_BOOL
end

---
-- Attaches a client side convar to this button, its state also
-- reflects on the state of the button.
-- @param string cvar The convar name
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:AttachConVar(cvar)
    if not ConVarExists(cvar or "") then
        return self
    end

    self.m_ClientConvar = GetConVar(cvar)

    local varType = self:GetVariableType()

    if varType == TYPE_BOOL then
        self:SetDefaultValue(tobool(self.m_ClientConvar:GetDefault()))
        self:SetValue(self.m_ClientConvar:GetBool())
    elseif varType == TYPE_NUMBER then
        self:SetDefaultValue(tonumber(self.m_ClientConvar:GetDefault()))
        self:SetValue(self.m_ClientConvar:GetNumber())
    elseif varType == TYPE_STRING then
        self:SetDefaultValue(self.m_ClientConvar:GetDefault())
        self:SetValue(self.m_ClientConvar:GetString())
    end

    return self
end

---
-- Attaches a server side convar to this button, its state also
-- reflects on the state of the button.
-- @param string cvar The convar name
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:AttachServerConVar(cvar)
    if not cvar or cvar == "" then
        return self
    end

    self.m_ServerConvar = cvar

    cvars.ServerConVarGetValue(cvar, function(wasSuccess, value, default)
        -- check if self is valid before calling SetValue on object
        if not wasSuccess or not IsValid(self) then
            return
        end

        local varType = self:GetVariableType()

        if varType == TYPE_BOOL then
            self:SetDefaultValue(tobool(default))
            self:SetValue(tobool(value), true)
        elseif varType == TYPE_NUMBER then
            self:SetDefaultValue(tonumber(default))
            self:SetValue(tonumber(value), true)
        elseif varType == TYPE_STRING then
            self:SetDefaultValue(tostring(default))
            self:SetValue(tostring(value), true)
        end
    end)

    callbackEnabledVarTracker = callbackEnabledVarTracker + 1

    local myIdentifierString = "TTT2CheckBoxConVarChangeCallback"
        .. tostring(callbackEnabledVarTracker)

    local callback = function(conVarName, oldValue, newValue)
        if not IsValid(self) then
            -- We need to remove the callback in a timer, because otherwise the ConVar change
            -- callback code will throw an error while looping over the callbacks.
            -- This happens, because the callback is removed from the same table that is
            -- iterated over. Thus, the table size changes while iterating over it and leads to
            -- a nil callback as the last entry.
            timer.Simple(0, function()
                cvars.RemoveChangeCallback(conVarName, myIdentifierString)
            end)

            return
        end

        local varType = self:GetVariableType()

        if varType == TYPE_BOOL then
            self:SetValue(tobool(newValue), true)
        elseif varType == TYPE_NUMBER then
            self:SetValue(tonumber(newValue), true)
        elseif varType == TYPE_STRING then
            self:SetValue(tostring(newValue), true)
        end
    end

    cvars.AddChangeCallback(cvar, callback, myIdentifierString)

    return self
end

---
-- Attaches a database object to this button, its state also
-- reflects on the state of the button.
-- @param table databaseInfo DatabaseInfo object containing {name, itemName, key}
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:AttachDatabase(databaseInfo)
    if not istable(databaseInfo) then
        return self
    end

    local name = databaseInfo.name
    local itemName = databaseInfo.itemName
    local key = databaseInfo.key

    if not name or not itemName or not key then
        return
    end

    self.m_DatabaseInfo = databaseInfo

    database.GetValue(name, itemName, key, function(databaseExists, value)
        if not databaseExists then
            return
        end

        self:SetValue(value, true)
    end)

    self:SetDefaultValue(database.GetDefaultValue(name, itemName, key))

    callbackEnabledVarTracker = callbackEnabledVarTracker + 1
    local myIdentifierString = "TTT2CheckBoxDatabaseChangeCallback"
        .. tostring(callbackEnabledVarTracker)

    local function OnDatabaseChangeCallback(_, _, _, _, newValue)
        if not IsValid(self) then
            database.RemoveChangeCallback(name, itemName, key, myIdentifierString)

            return
        end

        self:SetValue(newValue, true)
    end

    database.AddChangeCallback(name, itemName, key, OnDatabaseChangeCallback, myIdentifierString)

    return self
end

---
-- Sets the value attached to a button. This can be controlled by convars, or manually.
-- @param boolean|number|string val The value that should be set
-- @param[opt] boolean ignoreCallbackEnabledVar To avoid endless loops, separated setting of
-- convars and UI values
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetValue(val, ignoreCallbackEnabledVar)
    self:SetIgnoreCallbackEnabledVar(ignoreCallbackEnabledVar)

    if self:IsInverted() then
        val = not val
    end

    self.m_Value = val

    self:TriggerOnWithBase("Change", self.m_Value)

    return self
end

---
-- Returns the value of the panel that can be assigned by database or convar.
-- @return boolean|number|string|nil Returns the value of the button if there is one
-- assigned. It can be assigned by attaching convars or database values.
-- @realm client
function METAPANEL:GetValue()
    return self.m_Value
end

---
-- Sets the default value. If it is set, it can be used to reset the value
-- to its default.
-- @param boolean|number|string value The default value
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetDefaultValue(value)
    if isbool(value) then
        -- note: even when it is inverted, the default is not inverted here
        -- as it is inverted when the default button is pressed

        self.m_Default = value
    else
        self.m_Default = nil -- TODO: really nil here?
    end

    self:TriggerOnWithBase("DefaultChanged", self.default)

    return self
end

---
-- Returns true if this panel has a default value assigned.
-- @return boolean True if a default value is assigned
-- @realm client
function METAPANEL:HasDefaultValue()
    return self.default ~= nil
end

---
-- Returns the default value assigned to the panel.
-- @return boolean defaultValue, if unset returns false
-- @realm client
function METAPANEL:GetDefaultValue()
    return self.default or false
end

---
-- TODO this has to be refactored - this shouldn't be split into two functions
-- there is currently OnChange and OnValueChange - why??
-- TODO make sure this supports all data types
-- @param any val
-- @realm client
function METAPANEL:ValueChanged(val)
    if self:IsInverted() then
        val = not val
    end

    if self.convar then
        self.convar:SetBool(val)
    elseif self.serverConVar and not self:GetIgnoreCallbackEnabledVar() then
        cvars.ChangeServerConVar(self.serverConVar, val and "1" or "0")
    elseif self.databaseInfo and not self:GetIgnoreCallbackEnabledVar() then
        database.SetValue(
            self.databaseInfo.name,
            self.databaseInfo.itemName,
            self.databaseInfo.key,
            val
        )
    else
        self:SetIgnoreCallbackEnabledVar(false)
    end

    self:TriggerOnWithBase("ValueChanged", val)
end

---
-- overwrites the base function with an empty function
-- @param any val
-- @realm client
function METAPANEL:OnValueChanged(val) end

---
-- @param any val
-- @realm client
function METAPANEL:OnChange(val) end

---
-- @param any val
-- @realm client
function METAPANEL:OnDefaultChange(val) end
