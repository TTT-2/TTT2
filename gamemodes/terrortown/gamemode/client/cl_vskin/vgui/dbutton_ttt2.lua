---
-- @class PANEL
-- @section DButtonTTT2

local PANEL = {}

local soundClick = Sound("common/talk.wav")

---
-- @accessor bool
-- @realm client
AccessorFunc(PANEL, "m_bIgnoreCallbackEnabledVar", "IgnoreCallbackEnabledVar", FORCE_BOOL)

---
-- @accessor bool
-- @realm client
AccessorFunc(PANEL, "m_bDisplayInverted", "Inverted", FORCE_BOOL_IS, true)

---
-- @ignore
function PANEL:Init()
    -- sets the content alignment in the element
    self:SetContentAlignment(CONTENT_ALIGN_CENTER) -- TODO: rendering should respect that

    -- enable mouse and keyboard input to interact with button
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    -- set the cursor to show the user they can interact
    self:SetCursor("hand")

    -- set the default name for the paint hook
    self:SetPaintHookName("ButtonTTT2")

    -- set visual defaults
    self:SetFont("DermaTTT2Button")
end

---
-- Attaches a client side convar to this button, its state also
-- reflects on the state of the button.
-- @param string cvar The convar name
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:AttachConVar(cvar)
    if not ConVarExists(cvar or "") then
        return self
    end

    self.convar = GetConVar(cvar)

    self:SetDefaultValue(tobool(self.convar:GetDefault()))
    self:SetValue(self.convar:GetBool())

    return self
end

local callbackEnabledVarTracker = 0

---
-- Attaches a server side convar to this button, its state also
-- reflects on the state of the button.
-- @param string cvar The convar name
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:AttachServerConVar(cvar)
    if not cvar or cvar == "" then
        return self
    end

    self.serverConVar = cvar

    -- Check if self is valid before calling SetValue.
    cvars.ServerConVarGetValue(cvar, function(wasSuccess, value, default)
        if wasSuccess and IsValid(self) then
            self:SetValue(tobool(value), true)
            self:SetDefaultValue(tobool(default))
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

        self:SetValue(tobool(newValue), true)
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
function PANEL:AttachDatabase(databaseInfo)
    if not istable(databaseInfo) then
        return self
    end

    local name = databaseInfo.name
    local itemName = databaseInfo.itemName
    local key = databaseInfo.key

    if not name or not itemName or not key then
        return
    end

    self.databaseInfo = databaseInfo

    database.GetValue(name, itemName, key, function(databaseExists, value)
        if databaseExists then
            self:SetValue(value, true)
        end
    end)

    self:SetDefaultValue(database.GetDefaultValue(name, itemName, key))

    callbackEnabledVarTracker = callbackEnabledVarTracker + 1
    local myIdentifierString = "TTT2CheckBoxDatabaseChangeCallback"
        .. tostring(callbackEnabledVarTracker)

    local function OnDatabaseChangeCallback(_name, _itemName, _key, oldValue, newValue)
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
-- @param boolean val The value that should be set
-- @param boolean ignoreCallbackEnabledVar To avoid endless loops, separated setting of
-- convars and UI values
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetValue(val, ignoreCallbackEnabledVar)
    self:SetIgnoreCallbackEnabledVar(ignoreCallbackEnabledVar)

    if self:GetInverted() then
        val = not val
    end

    self.value = val

    self:TriggerOnWithBase("Change", self.value)

    return self
end

---
-- @return boolean Returns the value of the button if there is one
-- assigned. It can be assigned by attaching convars or database values.
-- @realm client
function PANEL:GetValue()
    return self.value or false
end

---
-- @param boolean value
-- @realm client
function PANEL:SetDefaultValue(value)
    if isbool(value) then
        -- note: even when it is inverted, the default is not inverted here
        -- as it is inverted when the default button is pressed

        self.default = value
    else
        self.default = nil
    end
end

function PANEL:HasDefaultValue()
    return self.default ~= nil
end

---
-- @return boolean defaultValue, if unset returns false
-- @realm client
function PANEL:GetDefaultValue()
    return self.default or false
end

---
-- @param any val
-- @realm client
function PANEL:ValueChanged(val)
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

    self:OnValueChanged(val)
end

---
-- overwrites the base function with an empty function
-- @param any val
-- @realm client
function PANEL:OnValueChanged(val) end

---
-- @param any val
-- @realm client
function PANEL:OnChange(val) end

---
-- @param any val
-- @realm client
function PANEL:OnDefaultChange(val) end

---
-- @return boolean
-- @realm client
function PANEL:IsDown()
    return self.Depressed
end

---
-- @param string strName
-- @param string strArgs
-- @realm client
function PANEL:SetConsoleCommand(strName, strArgs)
    self.DoClick = function(slf, val)
        RunConsoleCommand(strName, strArgs)
    end
end

---
-- @param Color color
-- @realm client
function PANEL:SetColor(color)
    self.data.color = color
end

---
-- @return Color|nil
-- @realm client
function PANEL:GetColor()
    return self.data.color
end

---
-- @param Material icon
-- @param[default=false] boolean is_shadowed
-- @param[default=32] number size
-- @realm client
function PANEL:SetIcon(icon, is_shadowed, size)
    self.data.icon = icon
    self.data.icon_shadow = is_shadowed or false
    self.data.icon_size = size or 32
end

---
-- @return Material|nil
-- @realm client
function PANEL:GetIcon()
    return self.data.icon
end

---
-- @return boolean
-- @realm client
function PANEL:HasIcon()
    return self.data.icon ~= nil
end

---
-- @return boolean|nil
-- @realm client
function PANEL:IsIconShadowed()
    return self.data.icon_shadow
end

---
-- @return number|nil
-- @realm client
function PANEL:GetIconSize()
    return self.data.icon_size
end

---
-- @ignore
function PANEL:SizeToContents()
    local w, h = self:GetContentSize()

    self:SetSize(w + 8, h + 4)
end

-- SET DEFAULT HOOK BEHAVIOUR --

---
-- @ignore
function PANEL:OnLeftClickInternal()
    sound.ConditionalPlay(soundClick, SOUND_TYPE_BUTTONS)
end

derma.DefineControl("DButtonTTT2", "A standard Button", PANEL, "TTT2:DLabel")
