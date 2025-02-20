---
-- @class PANEL
-- @section TTT2:DPanel/Core

---
-- @accessor string
-- @realm client
AccessorFunc(METAPANEL, "m_PaintHookName", "PaintHookName", FORCE_STRING, true)

-- data attached to the panel is put in its own scope
METAPANEL._eventListeners = {}
METAPANEL._attached = {}
METAPANEL._vskinColor = {}
METAPANEL._vskinDimension = {}
METAPANEL._tooltip = {}

---
-- Is called on initialization of the panel.
-- @note vgui.Register does not support inheritance for the Init function, therefore
-- this function always has to be set with a call of its base.
-- @hook
-- @realm client
function METAPANEL:Init()
    -- enable the panel
    self:SetEnabled(true)

    -- disable keyboard and mouse input
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    self:SetDoubleClickingEnabled(false)

    -- turn off the engine drawing
    self:SetPaintBackgroundEnabled(false)

    -- some basic engine defined functions of panels have to be extended to
    -- support method chaining
    local _SetSize = self.SetSize
    self.SetSize = function(slf, ...)
        _SetSize(slf, ...)

        return slf
    end

    local _SetWide = self.SetWide
    self.SetWide = function(slf, ...)
        _SetWide(slf, ...)

        return slf
    end

    local _SetWidth = self.SetWidth
    self.SetWidth = function(slf, ...)
        _SetWidth(slf, ...)

        return slf
    end

    local _SetTall = self.SetTall
    self.SetTall = function(slf, ...)
        _SetTall(slf, ...)

        return slf
    end

    local _SetHeight = self.SetHeight
    self.SetHeight = function(slf, ...)
        _SetHeight(slf, ...)

        return slf
    end

    local _SetPos = self.SetPos
    self.SetPos = function(slf, ...)
        _SetPos(slf, ...)

        return slf
    end

    local _DockPadding = self.DockPadding
    self.DockPadding = function(slf, ...)
        _DockPadding(slf, ...)

        return slf
    end

    local _DockMargin = self.DockMargin
    self.DockMargin = function(slf, ...)
        _DockMargin(slf, ...)

        return slf
    end

    local _Dock = self.Dock
    self.Dock = function(slf, ...)
        _Dock(slf, ...)

        return slf
    end

    self:Initialize()
end

---
-- Initialize function that is called on init of the panel. Is called in @{PANEL:Init}
-- to simplify overwriting of this init function.
-- @hook
-- @realm client
function METAPANEL:Initialize() end

-- SPECIAL FUNCTIONS TO HANDLE HOOKS AND EXTENDED FEATURES --

---
-- Used to register an event on the panel. This can be stuff such as "Click" etc.
-- @param string eventName The name of the event
-- @param function callback The callback function that is called in this event
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:On(eventName, callback)
    self._eventListeners[eventName] = self._eventListeners[eventName] or {}

    self._eventListeners[eventName][#self._eventListeners[eventName] + 1] = callback

    return self
end

---
-- Calls the functions on the hook table that are registered to this hook.
-- @param string eventName The name of the event
-- @param any ... The hook parameters
-- @return any Returns whatever the specific hook may return
-- @internal
-- @realm client
function METAPANEL:TriggerOn(eventName, ...)
    local eventTable = self._eventListeners[eventName]

    if not eventTable then
        return
    end

    for i = 1, #eventTable do
        local returnValue = eventTable[i](...)

        if returnValue ~= nil then
            return returnValue
        end
    end
end

---
-- Calls the functions on the hook table that are registered to this hook. Also
-- calls the Panel function with the hook name if it exists
-- @param string eventName The name of the event
-- @param any ... The hook parameters
-- @internal
-- @realm client
function METAPANEL:TriggerOnWithBase(eventName, ...)
    local returnValue = self:TriggerOn(eventName, ...)

    if returnValue ~= nil then
        return returnValue
    end

    if isfunction(self["On" .. eventName]) then
        returnValue = self["On" .. eventName](self, ...)

        if returnValue ~= nil then
            return returnValue
        end
    end
end

---
-- Calls the deprecated hook function directly registered on the Panel.
-- @param string eventName The name of the event
-- @param any ... The hook parameters
-- @return any Returns whatever the specific hook may return
-- @internal
-- @realm client
function METAPANEL:TriggerDeprecatedEvent(eventName, ...)
    if isfunction(self[eventName]) then
        ErrorNoHalt(
            "[DEPRECATION WARNING]: Overwriting hooks for panels is no longer recommended, use PANEL:On() instead. Hook: "
                .. eventName
                .. " Element: "
                .. tostring(self)
        )

        return self[eventName](...)
    end
end

---
-- Used to register an action that happens after a set time afer initialization.
-- @param number delay The delay in seconds when this should trigger
-- @param function callback The callback function that is called after this time
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:After(delay, callback)
    timer.Simple(delay, function()
        if not IsValid(self) or not isfunction(callback) then
            return
        end

        callback(self)
    end)

    return self
end

---
-- Used to attach any data on the panel, this is mostly useful to pass it to
-- the draw hook without defininig loads of setters and getters.
-- @param string identifier A unique identifer to later access the data
-- @param any data The data that should be attached
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:Attach(identifier, data)
    self._attached[identifier] = data

    return self
end

---
-- Returns previously attached data if set.
-- @param string identifier A unique identifer to access the data
-- @return any The data that was attached to this identifier
-- @realm client
function METAPANEL:GetAttached(identifier)
    return self._attached[identifier]
end

---
-- Sets the enabled state of a disable-able panel object, such as a DButton or DTextEntry.
-- @param boolean state Whether to enable or disable the panel object
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetEnabled(state)
    self.m_bEnabled = state

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Returns whether the the panel is enabled or disabled.
-- @return boolean Whether the panel is enabled or disabled
-- @realm client
function METAPANEL:IsEnabled()
    return self.m_bEnabled
end

---
-- Checks whether a paint hook name is defined for this panel.
-- @return boolean Returns true if defined
-- @realm client
function METAPANEL:HasPaintHookName()
    return self.m_PaintHookName ~= nil
end

---
-- Applies a vskin color. VSkin colors are updated on vskin change and are then
-- cached for further use. They are set in @{OnVSkinUpdate}.
-- @param string identifier A unique identifer with the name of the color
-- @param Color color The color that is set here
-- @return Panel Returns the panel itself
-- @internal
-- @realm client
function METAPANEL:ApplyVSkinColor(identifier, color)
    -- the color is copied here to make sure that any modifications to that
    -- color won't change anything downstram
    color = table.Copy(color)
    color = self:TriggerOnWithBase("VSkinColorPostProcess", identifier, color) or color

    self._vskinColor[identifier] = color

    return self
end

---
-- Returns the defined vSkin color for that identifier.
-- @param string identifier A unique identifer with the name of the color
-- @return Color The vskin color for that identifier
-- @imternal
-- @realm client
function METAPANEL:GetVSkinColor(identifier)
    return self._vskinColor[identifier]
end

---
-- Applies a vskin dimension. VSkin dimensions are updated on layout rebuilt and are then
-- cached for further use. They are set in @{OnVSkinUpdate}.
-- @param string identifier A unique identifer with the name of the dimension
-- @param number dimension The dimension that us set here
-- @return number Returns the added dimension as a pass-through
-- @internal
-- @realm client
function METAPANEL:ApplyVSkinDimension(identifier, dimension)
    self._vskinDimension[identifier] = dimension

    return dimension
end

---
-- Returns the defined vSkin color for that identifier.
-- @param string identifier A unique identifer with the name of the dimension
-- @return dimension The vskin dimension for that identifier
-- @imternal
-- @realm client
function METAPANEL:GetVSkinDimension(identifier)
    return self._vskinDimension[identifier]
end

---
-- Checks whether this panel implements a specific module.
-- @return boolean Returns false if the module is not implemented, true if it is
-- @internal
-- @realm client
function METAPANEL:HasModule(name)
    return self._modules[name] or false
end

-- SET THE PRIMARY TO THE DEPENDENT --

---
-- Sets the primary of this panel which is then able to control this dependent.
-- @param Panel primary The primary panel
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetPrimary(primary)
    if IsValid(primary) then
        self.primary = primary
    end

    return self
end

---
-- Returns the indentation margin based on the amount of primary levels above this deoendent.
-- @return number The identation amount
-- @realm client
function METAPANEL:GetIndentationMargin()
    if not IsValid(self.primary) then
        return 0
    end

    return 10 + self.primary:GetIndentationMargin()
end

---
-- Called every frame to paint the element.
-- @note This hook will not run if the panel is completely off the screen, and will still run if
-- any parts of the panel are still on screen.
-- @note You should probably not overwrite this hook unless you know what you do.
-- @param number w The panel's width
-- @param number h The panel's height
-- @return boolean Returning true prevents the background from being drawn
-- @realm client
function METAPANEL:Paint(w, h)
    if self:HasPaintHookName() then
        derma.SkinHook("Paint", "Pre" .. self:GetPaintHookName(), self, w, h)
    end

    if self:GetPaintBackground() then
        derma.SkinHook("Paint", "ColoredBox", self, w, h)
    end

    if self:HasText() then
        derma.SkinHook("Paint", "Text", self, w, h)
    end

    if self:HasDescription() then
        derma.SkinHook("Paint", "Description", self, w, h)
    end

    if self:HasIcon() then
        derma.SkinHook("Paint", "Icon", self, w, h)
    end

    if self:HasPaintHookName() then
        derma.SkinHook("Paint", "Post" .. self:GetPaintHookName(), self, w, h)
    end

    return true
end
