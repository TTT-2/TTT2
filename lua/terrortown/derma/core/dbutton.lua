---
-- @class PANEL
-- @section TTT2:DButton

DPANEL.derma = {
    className = "TTT2:DButton",
    description = "The standard button used in TTT2 with convar and database support",
    baseClassName = "TTT2:DPanel",
}

local soundClick = Sound("common/talk.wav")

---
-- @accessor boolean
-- @realm client
AccessorFunc(DPANEL, "m_bIgnoreCallbackEnabledVar", "IgnoreCallbackEnabledVar", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(DPANEL, "m_bDisplayInverted", "Inverted", FORCE_BOOL_IS, true)

---
-- @ignore
function DPANEL:Init()
    -- enable mouse and keyboard input to interact with button
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    -- set the cursor to show the user they can interact
    self:SetCursor("hand")

    -- set visual defaults
    self:SetFont("DermaTTT2Button")
end

---
-- @ignore
function DPANEL:OnVSkinUpdate()
    local colorBackground, colorText, colorOutline

    -- PANEL DISABLED
    if not self:IsEnabled() then
        local colorDefault = util.GetDefaultColor(vskin.GetBackgroundColor())
        local colorAccentDisabled = util.GetChangedColor(colorDefault, 150)

        colorBackground = util.GetChangedColor(colorAccentDisabled, 120)
        colorText = ColorAlpha(util.GetDefaultColor(colorAccentDisabled), 220)
        colorOutline = util.ColorDarken(colorAccentDisabled, 50)

    -- PANEL IS PRESSED
    elseif self:IsDepressed() or self:IsSelected() or self:GetToggle() then
        colorBackground = util.GetActiveColor(self:GetColor() or vskin.GetAccentColor())
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 35)
        colorOutline = util.GetActiveColor(self:GetOutlineColor() or vskin.GetDarkAccentColor())

    -- PANEL IS HOVERED
    elseif self:IsHovered() then
        colorBackground = util.GetHoverColor(self:GetColor() or vskin.GetAccentColor())
        colorText = util.GetDefaultColor(colorBackground)
        colorOutline = util.GetHoverColor(self:GetOutlineColor() or vskin.GetDarkAccentColor())

    -- NORMAL COLORS
    else
        colorBackground = self:GetColor() or vskin.GetAccentColor()
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 25)
        colorOutline = self:GetOutlineColor() or vskin.GetDarkAccentColor()
    end

    self:ApplyVSkinColor("background", colorBackground)
    self:ApplyVSkinColor("text", colorText)
    self:ApplyVSkinColor("description", colorText)
    self:ApplyVSkinColor("icon", colorText)
    self:ApplyVSkinColor("outline", colorOutline)
    self:ApplyVSkinColor("flash", colorText)
end

---
-- @ignore
function DPANEL:OnRebuildLayout(w, h)
    DBase("TTT2:DPanel").OnRebuildLayout(self, w, h)

    -- if the panel is depressed, the text and icon should be shifted by one pixel
    if self:IsDepressed() or self:IsSelected() or self:GetToggle() then
        if self:HasIcon() then
            self:ApplyVSkinDimension("posIconY", self:GetVSkinDimension("posIconY") + 1)
        end

        if self:HasText() then
            self:ApplyVSkinDimension("posTextY", self:GetVSkinDimension("posTextY") + 1)
        end

        if self:HasDescription() then
            local posY = self:GetVSkinDimension("posTableDescriptionY")

            for i = 1, #posY do
                posY[i] = posY[i] + 1
            end

            self:ApplyVSkinDimension("posTableDescriptionY", posY)
        end
    end
end

---
-- Attaches a client side convar to this button, its state also
-- reflects on the state of the button.
-- @param string cvar The convar name
-- @return Panel Returns the panel itself
-- @realm client
function DPANEL:AttachConVar(cvar)
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
function DPANEL:AttachServerConVar(cvar)
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
function DPANEL:AttachDatabase(databaseInfo)
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
function DPANEL:SetValue(val, ignoreCallbackEnabledVar)
    self:SetIgnoreCallbackEnabledVar(ignoreCallbackEnabledVar)

    if self:GetInverted() then
        val = not val
    end

    self.value = val

    self:TriggerOnWithBase("Change", self.value)

    return self
end

---
-- Returns the value of the panel that can be assigned by database or convar.
-- @return boolean Returns the value of the button if there is one
-- assigned. It can be assigned by attaching convars or database values.
-- @realm client
function DPANEL:GetValue()
    return self.value or false
end

---
-- Sets the default value. If it is set, it can be used to reset the value
-- to its default.
-- @param boolean value The default value
-- @return Panel Returns the panel itself
-- @realm client
function DPANEL:SetDefaultValue(value)
    if isbool(value) then
        -- note: even when it is inverted, the default is not inverted here
        -- as it is inverted when the default button is pressed

        self.default = value
    else
        self.default = nil
    end

    self:TriggerOnWithBase("DefaultChanged", self.default)

    return self
end

---
-- Returns true if this panel has a default value assigned.
-- @return boolean True if a default value is assigned
-- @realm client
function DPANEL:HasDefaultValue()
    return self.default ~= nil
end

---
-- Returns the default value assigned to the panel.
-- @return boolean defaultValue, if unset returns false
-- @realm client
function DPANEL:GetDefaultValue()
    return self.default or false
end

---
-- TODO this has to be refactored - this shouldn't be split into two functions
-- @param any val
-- @realm client
function DPANEL:ValueChanged(val)
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
function DPANEL:OnValueChanged(val) end

---
-- @param any val
-- @realm client
function DPANEL:OnChange(val) end

---
-- @param any val
-- @realm client
function DPANEL:OnDefaultChange(val) end

-- TODO END

---
-- Adds a new console command to be called when the button is clicked.
-- @param string command The command name
-- @param string arguments The parameters as a string
-- @return Panel Returns the panel itself
-- @realm client
function DPANEL:AddConsoleCommand(command, arguments)
    self:On("LeftClick", function()
        RunConsoleCommand(command, arguments)
    end)

    return self
end

-- SET DEFAULT HOOK BEHAVIOUR --

---
-- @ignore
function DPANEL:OnLeftClickInternal()
    sound.ConditionalPlay(soundClick, SOUND_TYPE_BUTTONS)
end

---
-- I'm not sure why I have to do this - this isn't necessary for other functions
-- @ignore
function DPANEL:OnMousePressed(mouseCode)
    DBase("TTT2:DLabel").OnMousePressed(self, mouseCode)
end

---
-- I'm not sure why I have to do this - this isn't necessary for other functions
-- @ignore
function DPANEL:OnMouseReleased(mouseCode)
    DBase("TTT2:DLabel").OnMouseReleased(self, mouseCode)
end
