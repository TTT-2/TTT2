---
-- @class PANEL
-- @section TTT2:DLabel

-- HOOKS ATTACHABLE WITH ON FOR TTT2:DLABEL:
-- engine:
--   Think
--   CursorEntered
--   CursorExited
-- custom:
--   OnDepressed(mouseCode)
--   OnReleased(mouseCode)
--   OnToggled(mouseCode)
--   OnLeftClick
--   OnLeftClickInternal
--   OnRightClick
--   OnMiddleClick
--   OnDoubleClick
--   OnDoubleClickInternal

CONTENT_ALIGN_BOTTOM_LEFT = 1
CONTENT_ALIGN_BOTTOM_CENTER = 2
CONTENT_ALIGN_BOTTOM_RIGHT = 3
CONTENT_ALIGN_CENTER_LEFT = 4
CONTENT_ALIGN_CENTER = 5
CONTENT_ALIGN_CENTER_RIGHT = 6
CONTENT_ALIGN_TOP_LEFT = 7
CONTENT_ALIGN_TOP_CENTER = 8
CONTENT_ALIGH_TOP_RIGHT = 9

local PANEL = {}

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "m_FontName", "Font", true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDoubleClicking", "DoubleClickingEnabled", FORCE_BOOL_IS, true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bAutoStretchVertical", "AutoStretchVerticalEnabled", FORCE_BOOL_IS, true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL) -- ??? needed in TTT2:DComboBox?

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBackground", "PaintBackground", FORCE_BOOL) -- ??? needed in TTT2:DButton?

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bIsToggle", "IsToggle", FORCE_BOOL, true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bToggle", "Toggle", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDepressed", "Depressed", FORCE_BOOL_IS)

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "m_PaintHookName", "PaintHookName", FORCE_STRING, true)

---
-- @accessor table
-- @realm client
AccessorFunc(PANEL, "m_TextParams", "TextParams", nil, true)

-- data attached to the panel is put in its own scope
PANEL._eventListeners = {}
PANEL._attached = {}
PANEL._tooltip = {}

---
-- @ignore
function PANEL:Init()
    -- enable the panel
    self:SetEnabled(true)

    -- disable toggling and set state to false
    self:SetIsToggle(false)
    self:SetToggle(false)

    -- disable keyboard and mouse input
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    self:SetDoubleClickingEnabled(true)

    -- turn off the engine drawing
    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)

    -- set the default name for the paint hook
    self:SetPaintHookName("LabelTTT2")

    -- set visual defaults
    self:SetTall(20)
    self:SetFont("DermaTTT2Text")

    -- set the defaults for the tooltip
    self:SetTooltipFixedPosition(nil)
    self:SetTooltipFixedSize(nil)
    self:SetTooltipOpeningDelay(0)
    self:SetTooltipFont("DermaTTT2Text")
    self:SetTooltipArrowSize(8)

    -- some basic engine defined functions of panels have to be extended to
    -- support method chaining
    local _SetSize = self.SetSize
    self.SetSize = function(slf, ...)
        _SetSize(slf, ...)

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
end

-- SPECIAL FUNCTIONS TO HANDLE HOOKS AND EXTENDED FEATURES --

---
-- Used to register an event on the panel. This can be stuff such as "Click" etc.
-- @param string eventName The name of the event
-- @param function callback The callback function that is called in this event
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:On(eventName, callback)
    self._eventListeners[eventName] = self._eventListeners[eventName] or {}

    self._eventListeners[eventName][#self._eventListeners[eventName] + 1] = callback

    return self
end

---
-- Calls the functions on the hook table that are registered to this hook.
-- @param string eventName The name of the event
-- @return any Returns whatever the specific hook may return
-- @internal
-- @realm client
function PANEL:TriggerOn(eventName, ...)
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
-- @return any Returns whatever the specific hook may return
-- @internal
-- @realm client
function PANEL:TriggerOnWith(eventName, ...)
    self:TriggerOn(eventName, ...)

    if isfunction(self["On" .. eventName]) then
        return self["On" .. eventName](...)
    end
end

---
-- Calls the deprecated hook function directly registered on the Panel.
-- @param string eventName The name of the event
-- @return any Returns whatever the specific hook may return
-- @internal
-- @realm client
function PANEL:TriggerDeprecatedEvent(eventName, ...)
    if isfunction(self[eventName]) then
        ErrorNoHaltWithStack(
            "[DEPRECATION WARNING]: Overwriting hooks for panels is no longer recommended, use PANEL:On() instead. Hook: "
                .. eventName
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
function PANEL:After(delay, callback)
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
function PANEL:Attach(identifier, data)
    self._attached[identifier] = data

    return self
end

---
-- Returns previously attached data if set.
-- @param string identifier A unique identifer to access the data
-- @return any The data that was attached to this identifier
-- @realm client
function PANEL:GetAttached(identifier)
    return self._attached[identifier]
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", self:GetPaintHookName(), self, w, h)

    return true
end

-- SET THE PRIMARY TO THE DEPENDENT --

---
-- Sets the primary of this panel which is then able to control this dependent.
-- @param Panel primary The primary panel
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetPrimary(primary)
    if IsValid(primary) then
        self.primary = primary
    end

    return self
end

---
-- Returns the indentation margin based on the amount of primary levels above this deoendent.
-- @return number The identation amount
-- @realm client
function PANEL:GetIndentationMargin()
    if not IsValid(self.primary) then
        return 0
    end

    return 10 + self.primary:GetIndentationMargin()
end

-- SETTERS/GETTERS THAT SET BASIC PARAMETERS --

---
-- Sets the font of the label.
-- @param string fontName The name of the font
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetFont(fontName)
    self.m_FontName = fontName

    self:SetFontInternal(self.m_FontName)
    self:ApplySchemeSettings()

    return self
end

---
-- Sets the enabled state of a disable-able panel object, such as a DButton or DTextEntry.
-- @param boolean state Whether to enable or disable the panel object
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetEnabled(state)
    self.m_bEnabled = state

    self:InvalidateLayout()

    return self
end

---
-- Returns whether the the panel is enabled or disabled.
-- @return boolean Whether the panel is enabled or disabled
-- @realm client
function PANEL:IsEnabled()
    return self.m_bEnabled
end

---
-- Returns if a label has text params set.
-- @return boolean Returns true if a label has text params
-- @realm client
function PANEL:HasTextParams()
    return self.m_TextParams ~= nil
end

---
-- Toggles the state of the panel.
-- @realm client
function PANEL:Toggle()
    if not self:GetIsToggle() then
        return
    end

    self:SetToggle(not self:GetToggle())

    self:TriggerOnWithBase("Toggle", self:GetToggle())
end

-- HOOKS DEFINED IN THE ENGINE --

---
-- Called whenever the panel should apply its scheme (colors, fonts, style). It is called
-- a few frames after panel's creation once.
-- @ref https://wiki.facepunch.com/gmod/PANEL:ApplySchemeSettings
-- @hook
-- @realm client
function PANEL:ApplySchemeSettings() end

---
-- Called every frame while Panel:IsVisible is true.
-- @ref https://wiki.facepunch.com/gmod/PANEL:Think
-- @hook
-- @realm client
function PANEL:Think()
    self:TriggerOn("Think")

    if self:IsAutoStretchVerticalEnabled() then
        self:SizeToContentsY()
    end
end

---
-- Called whenever the panels' layout needs to be performed again. This means all child panels must
-- be re-positioned to fit the possibly new size of this panel.
-- @ref https://wiki.facepunch.com/gmod/PANEL:PerformLayout
-- @hook
-- @realm client
function PANEL:PerformLayout()
    self:ApplySchemeSettings()
end

---
-- Called whenever the cursor entered the panels bounds.
-- @ref https://wiki.facepunch.com/gmod/PANEL:OnCursorEntered
-- @hook
-- @realm client
function PANEL:OnCursorEntered()
    self:TriggerOn("CursorEntered")

    self:InvalidateLayout(true)
end

---
-- Called whenever the cursor left the panels bounds.
-- @ref https://wiki.facepunch.com/gmod/PANEL:OnCursorExited
-- @hook
-- @realm client
function PANEL:OnCursorExited()
    self:TriggerOn("CursorExited")

    self:InvalidateLayout(true)
end

---
-- Called whenever a mouse key was pressed while the panel is focused.
-- @ref https://wiki.facepunch.com/gmod/PANEL:OnMousePressed
-- @param number mouseCode The key code of the mouse button pressed
-- @hook
-- @realm client
function PANEL:OnMousePressed(mouseCode)
    if not self:IsEnabled() then
        return
    end

    if
        mouseCode == MOUSE_LEFT
        and not dragndrop.IsDragging()
        and self:IsDoubleClickingEnabled()
    then
        if self.LastClickTime and SysTime() - self.LastClickTime < 0.2 then
            self:TriggerDeprecatedEvent("DoDoubleClickInternal")
            self:TriggerDeprecatedEvent("DoDoubleClick")

            self:TriggerOnWithBase("DoubleClickInternal")
            self:TriggerOnWithBase("DoubleClick")

            return
        end

        self.LastClickTime = SysTime()
    end

    -- If we're selectable and have shift held down then go up
    -- the parent until we find a selection canvas and start box selection
    if self:IsSelectable() and mouseCode == MOUSE_LEFT and input.IsShiftDown() then
        return self:StartBoxSelection()
    end

    self:MouseCapture(true)
    self:SetDepressed(true)

    self:TriggerOnWithBase("Depressed", mouseCode)

    self:InvalidateLayout(true)

    -- tell DragNDrop that we're down, and might start getting dragged!
    self:DragMousePress(mouseCode)
end

---
-- Called whenever a mouse key was released while the panel is focused.
-- @ref https://wiki.facepunch.com/gmod/PANEL:OnMouseReleased
-- @param number mouseCode The key code of the mouse button released
-- @hook
-- @realm client
function PANEL:OnMouseReleased(mouseCode)
    self:MouseCapture(false)

    if self:GetDisabled() then
        return
    end

    if not self:IsDepressed() and dragndrop.m_DraggingMain ~= self then
        return
    end

    if self:IsDepressed() then
        self:SetDepressed(false)

        self:TriggerOnWithBase("Released", mouseCode)

        self:InvalidateLayout(true)
    end

    -- If we were being dragged then don't do the default behaviour!
    if self:DragMouseRelease(mouseCode) then
        return
    end

    if self:IsSelectable() and mouseCode == MOUSE_LEFT then
        local canvas = self:GetSelectionCanvas()

        if canvas then
            canvas:UnselectAll()
        end
    end

    if not self:IsHovered() then
        return
    end

    -- For the purposes of these callbacks we want to keep depressed true. This helps
    -- us out in controls like the checkbox in the properties dialog. Because the
    -- properties dialog will only manually change the value if IsEditing() is true -
    -- and the only way to work out if a label/button based control is editing is when
    -- it's depressed.
    self:SetDepressed(true)

    if mouseCode == MOUSE_RIGHT then
        self:TriggerDeprecatedEvent("DoRightClick")

        self:TriggerOnWithBase("RightClick")
    elseif mouseCode == MOUSE_LEFT then
        self:TriggerDeprecatedEvent("DoClickInternal")
        self:TriggerDeprecatedEvent("DoClick")

        self:TriggerOnWithBase("LeftClickInternal")
        self:TriggerOnWithBase("LeftClick")
    elseif mouseCode == MOUSE_MIDDLE then
        self:TriggerDeprecatedEvent("DoMiddleClick")

        self:TriggerOnWithBase("MiddleClick")
    end

    self:SetDepressed(false)
end

-- HOOKS DEFINED FROM HERE ON ARE LUA BASED HOOKS AND NOT PROVIDED BY THE ENGINE --

---
-- Called when the player releases any mouse button on the label.
-- @param number mouseCode The mouse code defines the button that was released.
-- @hook
-- @realm client
function PANEL:OnDepressed(mouseCode) end

---
-- Called when the player presses the label with any mouse button.
-- @param number mouseCode The mouse code defines the button that was released.
-- @hook
-- @realm client
function PANEL:OnReleased(mouseCode) end

---
-- Called when the toggle state of the label is changed by Label.
-- @note In order to use toggle functionality, you must first call `DLabel:SetIsToggle()` with
-- `true`, as it is disabled by default.
-- @param boolean state The current toggle state
-- @hook
-- @realm client
function PANEL:OnToggled(state) end

---
-- Called after the left mouse mouse was released on a button, performing a click.
-- @note Calls the internal toggle functionality if enabled.
-- @hook
-- @realm client
function PANEL:OnLeftClick()
    self:Toggle()
end

---
-- Called after the left mouse mouse was released on a button, performing a left click. This
-- function is called immidiately before OnLeftClick.
-- @hook
-- @realm client
function PANEL:OnLeftClickInternal() end

---
-- Called after the right mouse mouse was released on a button, performing a right click.
-- @hook
-- @realm client
function PANEL:OnRightClick() end

---
-- Called after the middle mouse mouse was released on a button, performing a middle click.
-- @hook
-- @realm client
function PANEL:OnMiddleClick() end

---
-- Called after the left mouse mouse was released on a button, performing a double click.
-- @note Calls the internal toggle functionality if enabled.
-- @hook
-- @realm client
function PANEL:OnDoubleClick() end

---
-- Called after the left mouse mouse was released on a button, performing a double click. This
-- function is called immidiately before OnDoubleClick.
-- @hook
-- @realm client
function PANEL:OnDoubleClickInternal() end

-- TOOLTIP RELATED FUNCTIONS --

---
-- @param string text
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetTooltip(text)
    if text then
        self:SetTooltipPanelOverride("TTT2:DTooltip")
    end

    self._tooltip.text = text

    return self
end

-- TODO review this - do we actually need this? what of this code is needed? looks strange.
-- @return Panel Returns the panel itself
function PANEL:SetTooltipPanel(panel)
    if panel then
        self:SetTooltipPanelOverride("TTT2:DTooltip")
    end

    -- original code before the overwrite
    self.pnlTooltipPanel = panel

    if IsValid(panel) then
        panel:SetVisible(false)
    end

    return self
end

---
-- @param number x
-- @param number y
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetTooltipFixedPosition(x, y)
    self._tooltip.fixedPosition = {
        x = x,
        y = y,
    }

    return self
end

---
-- @return number, number
-- @realm client
function PANEL:GetTooltipFixedPosition()
    return self._tooltip.fixedPosition.x, self._tooltip.fixedPosition.y
end

---
-- @return boolean
-- @realm client
function PANEL:HasTooltipFixedPosition()
    return self._tooltip.fixedPosition ~= nil
end

---
-- @param number w
-- @param number h
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetTooltipFixedSize(w, h)
    -- +2 are the outline pixels
    self._tooltip.fixedSize = {
        w = w + 2,
        h = h + (self._tooltip.sizeArrow or 0) + 2,
    }

    return self
end

---
-- @return number, number
-- @realm client
function PANEL:GetTooltipFixedSize()
    return self._tooltip.fixedSize.w, self._tooltip.fixedSize.h
end

---
-- @realm client
function PANEL:HasTooltipFixedSize()
    return self._tooltip.fixedSize ~= nil
end

---
-- @param number delay
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetTooltipOpeningDelay(delay)
    self._tooltip.delay = delay

    return self
end

---
-- @return number
-- @realm client
function PANEL:GetTooltipOpeningDelay()
    return self._tooltip.delay
end

---
-- @param number size
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetTooltipArrowSize(size)
    self._tooltip.delay = sizeArrow

    return self
end

---
-- @return number
-- @realm client
function PANEL:GetTooltipArrowSize()
    return self._tooltip.sizeArrow
end

---
-- @return string
-- @realm client
function PANEL:GetTooltipText()
    return self._tooltip.text
end

---
-- @return boolean
-- @realm client
function PANEL:HasTooltipText()
    return self._tooltip.text ~= nil and self._tooltip.text ~= ""
end

---
-- @param string font
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetTooltipFont(font)
    self._tooltip.font = font

    return self
end

---
-- @return string
-- @realm client
function PANEL:GetTooltipFont()
    return self._tooltip.font
end

derma.DefineControl("TTT2:DLabel", "The basic Label everything in TTT2 is based on", PANEL, "Label")
