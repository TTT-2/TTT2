---
-- @class PANEL
-- @section DButtonTTT2

local PANEL = {}

local soundClick = Sound("common/talk.wav")

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL)

---
-- @accessor bool
-- @realm client
AccessorFunc(PANEL, "ignoreCallbackEnabledVar", "IgnoreCallbackEnabledVar", FORCE_BOOL)

---
-- @ignore
function PANEL:Init()
    self:SetContentAlignment(5)

    self:SetTall(22)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    self:SetCursor("hand")
    self:SetFont("DermaTTT2Button")
    -- remove label and overwrite function
    self:SetText("")
    self.SetText = function(slf, text)
        slf.data.text = text
    end

    self.data = {}

    -- hack a sound into the DoClick function after it is initialized
    timer.Simple(0, function()
        if not IsValid(self) then
            return
        end

        local oldClick = self.DoClick
        local oldRightClick = self.DoRightClick

        self.DoClick = function(slf)
            sound.ConditionalPlay(soundClick, SOUND_TYPE_BUTTONS)

            oldClick(slf)
        end

        self.DoRightClick = function(slf)
            sound.ConditionalPlay(soundClick, SOUND_TYPE_BUTTONS)

            oldRightClick(slf)
        end
    end)
end

---
-- This is only used temporarily to keep old variables without breaking the style of "no enable to disable" checkboxes
-- @param bool invert
-- @realm client
function PANEL:SetInverted(invert)
    self.inverted = invert
end

---
-- @param string cvar
-- @realm client
function PANEL:SetConVar(cvar)
    if not ConVarExists(cvar or "") then
        return
    end

    self.convar = GetConVar(cvar)

    self:SetDefaultValue(tobool(self.convar:GetDefault()))
    self:SetValue(self.convar:GetBool())
end

local callbackEnabledVarTracker = 0
---
-- @param string cvar
-- @realm client
function PANEL:SetServerConVar(cvar)
    if not cvar or cvar == "" then
        return
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
            -- We need to remove the callback in a timer, because otherwise the ConVar change callback code
            -- will throw an error while looping over the callbacks.
            -- This happens, because the callback is removed from the same table that is iterated over.
            -- Thus, the table size changes while iterating over it and leads to a nil callback as the last entry.
            timer.Simple(0, function()
                cvars.RemoveChangeCallback(conVarName, myIdentifierString)
            end)

            return
        end

        self:SetValue(tobool(newValue), true)
    end

    cvars.AddChangeCallback(cvar, callback, myIdentifierString)
end

---
-- @param table databaseInfo containing {name, itemName, key}
-- @realm client
function PANEL:SetDatabase(databaseInfo)
    if not istable(databaseInfo) then
        return
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
end

---
-- @param any val
-- @param boolean ignoreCallbackEnabledVar To avoid endless loops, separated setting of convars and UI values
-- @realm client
function PANEL:SetValue(val, ignoreCallbackEnabledVar)
    self:SetIgnoreCallbackEnabledVar(ignoreCallbackEnabledVar)

    if self.inverted then
        val = not val
    end

    self.value = val

    self:OnChange(self.value)
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

        noDefault = false
    else
        self.default = nil
    end
end

---
-- @return boolean defaultValue, if unset returns false
-- @realm client
function PANEL:GetDefaultValue()
    return tobool(self.default)
end

---
-- @param any val
-- @realm client
function PANEL:ValueChanged(val)
    if self.inverted then
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
-- @return string
-- @realm client
function PANEL:GetText()
    return self.data.text
end

---
-- @param table params
-- @realm client
function PANEL:SetTextParams(params)
    self.data.params = params
end

---
-- @return table
-- @realm client
function PANEL:GetTextParams()
    return self.data.params
end

---
-- @return boolean
-- @realm client
function PANEL:HasTextParams()
    return self.data.params ~= nil
end

---
-- @return boolean
-- @realm client
function PANEL:IsDown()
    return self.Depressed
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "ButtonTTT2", self, w, h)

    return false
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

derma.DefineControl("DButtonTTT2", "A standard Button", PANEL, "DLabelTTT2")
