---
-- @class PANEL
-- @section TTT2:DTextEntry
-- heavily based on https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dtextentry.lua

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
--   OnVSkinUpdate
--   OnTranslationUpdate
--   OnRebuildLayout
--   VSkinColorPostProcess

local strAllowedNumericCharacters = "1234567890.-"

---
-- @accessor boolean
-- @realm client
AccessorFunc(DPANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL) -- ??? needed in TTT2:DComboBox?

AccessorFunc(DPANEL, "m_bAllowEnter", "EnterAllowed", FORCE_BOOL_IS)
AccessorFunc(DPANEL, "m_bEnableTabbing", "TabbingEnabled", FORCE_BOOL_IS)

AccessorFunc(DPANEL, "m_bNumeric", "Numeric", FORCE_BOOL_IS)

AccessorFunc(DPANEL, "m_bFocused", "Focused", FORCE_BOOL_IS)

DPANEL.derma = {
    className = "TTT2:DTextEntry",
    description = "The default TTT3 Text box",
    baseClassName = "TextEntry",
}

DPANEL.implements = {
    -- core elements contain method chaining, paint hooks and ttt2 dlabel core features
    "core",
    -- box, as the name implies, contains the background box and its outline
    "box",
    -- text has everything related to text and description
    "text",
    -- icon handles the addition of icons
    "icon",
    -- text, description and icon can have different alignments, this is set in this module
    "alignment",
    -- dynamic things contain coloring, translating, rescaling to fit contents and automatic positioning of text/icons
    "dynamic",
    -- functions related to tooltips
    "tooltip",
}

---
-- @ignore
function DPANEL:Initialize()
    self._autoCompleteList = {}

    self:SetEnterAllowed(true)
    self:SetTabbingEnabled(true)
    self:SetNumeric(false)
    self:SetAllowNonAsciiCharacters(true)

    self:SetEditable(true)
    self:SetEnabled(true)

    self:SetCursor("beam")

    -- set visual defaults
    self:SetPaintBackground(true)
    self:SetTall(20)
    self:SetFont("DermaTTT2Text")
    self:SetDescriptionFont("DermaTTT2Text")
    self:SetTextAlign(TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    self:SetVerticalAlignment(false)
    self:SetPadding(8)
    self:EnableCornerRadius(true)
    self:SetText("type...")

    -- set the defaults for the tooltip
    self:SetTooltipFixedPosition(nil)
    self:SetTooltipFixedSize(nil)
    self:SetTooltipOpeningDelay(0)
    self:SetTooltipFont("DermaTTT2Text")
    self:SetTooltipArrowSize(8)

    -- there is a hook implimented in base gmod that handles focus losing:
    -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dtextentry.lua#L410-L429
    -- we set this flag to enable that hook
    self.m_bLoseFocusOnClickAway = true
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
    elseif self:IsDepressed() or self:IsSelected() or self:GetToggle() or self:IsFocused() then
        colorBackground = util.GetActiveColor(
            self:GetColor() or util.GetChangedColor(vskin.GetBackgroundColor(), 15)
        )
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 110)
        colorOutline = util.GetActiveColor(
            self:GetOutlineColor() or util.GetChangedColor(vskin.GetBackgroundColor(), 150)
        )

    -- PANEL IS HOVERED
    elseif self:IsHovered() then
        colorBackground = util.GetHoverColor(
            self:GetColor() or util.GetChangedColor(vskin.GetBackgroundColor(), 15)
        )
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 80)
        colorOutline = util.GetHoverColor(
            self:GetOutlineColor() or util.GetChangedColor(vskin.GetBackgroundColor(), 150)
        )

    -- NORMAL COLORS
    else
        colorBackground = self:GetColor() or util.GetChangedColor(vskin.GetBackgroundColor(), 15)
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 75)
        colorOutline = self:GetOutlineColor()
            or util.GetChangedColor(vskin.GetBackgroundColor(), 150)
    end

    local textTyped = util.GetChangedColor(util.GetDefaultColor(colorBackground), 35)

    self:ApplyVSkinColor("background", colorBackground)
    self:ApplyVSkinColor("text", colorText)
    self:ApplyVSkinColor("description", colorText)
    self:ApplyVSkinColor("icon", colorText)
    self:ApplyVSkinColor("outline", colorOutline)
    self:ApplyVSkinColor("flash", colorText)

    self:ApplyVSkinColor("text_typed", textTyped)
    self:ApplyVSkinColor("text_suggestion", ColorAlpha(textTyped, 120))
    self:ApplyVSkinColor("text_selection", vskin.GetAccentColor())
end

--
-- This is a hacky solution to the problem that we do not want to reinvent the rendering of the
-- text selection. It is a cleaner reimplementation of the way base GMod handled this:
-- https://github.com/Facepunch/garrysmod/blob/2566248a4878e0580e0767d36b3540eb04f81632/garrysmod/lua/skins/default.lua#L462-L494

---
-- @ignore
function DPANEL:PrePaint(w, h)
    local text = self:GetTextInternal()

    if text and text ~= "" then
        return false -- prevents normal content from being drawn
    end

    return true
end

---
-- @ignore
function DPANEL:PostPaint(w, h)
    local colorText = self:GetVSkinColor("text_typed")
    local colorHighlight = self:GetVSkinColor("text_selection")

    -- a hacky workaround to render the tabbing preview
    -- todo: cache color
    if self:IsTabbingEnabled() and self.m_CommonBase then
        local typedText = self:GetTextInternal()
        local cursorPos = self:GetCaretPos()

        -- note: setting the text resets the cursor position. Therefore it is reset here.
        -- It is done twice so only one cursor is rendered in the end, otherwise the cursor from
        -- the autocpmplete preview would always be rendered at position 0.
        self:SetTextInternal(self.m_CommonBase)
        self:SetCaretPos(cursorPos)
        self:DrawTextEntryText(self:GetVSkinColor("text_suggestion"), colorHighlight, colorText)
        self:SetTextInternal(typedText)
        self:SetCaretPos(cursorPos)
    end

    self:DrawTextEntryText(colorText, colorHighlight, colorText)
end

---
-- Checks whether the panel is currently acitve editing.
-- @return boolean Returns true if this panel is currently in editing mode
-- @realm client
function DPANEL:IsEditing()
    return self == vgui.GetKeyboardFocus()
end

---
-- Makes the text entry editable / uneditable.
-- @param boolean state Set to true to make editable
-- @return Panel Returns the panel itself
-- @realm client
function DPANEL:SetEditable(state)
    self:SetKeyboardInputEnabled(state)
    self:SetMouseInputEnabled(state)

    self:GetParent():SetKeyboardInputEnabled(state)
    self:GetParent():SetMouseInputEnabled(state)

    return self
end

local function GetCommonBase(list, start)
    local needle = string.sub(list[1], 1, start)

    for i = 1, #list do
        local startPos, _, _ = string.find(list[i], needle, 1, true)

        if not startPos or startPos ~= 1 then
            return string.sub(list[i], 1, start - 1)
        end
    end

    return GetCommonBase(list, start + 1)
end

---
-- Searches for a string in the cadidates list for auto completion. If only one element
-- is found, it returns the whole cadindate. If multiple are found, the common base is
-- returned.
-- @return nil|string nil if nothing was found, a string otherwise
-- @realm client
function DPANEL:GetAutoComplete()
    if #self._autoCompleteList == 0 then
        return
    end

    local currentText = self:GetTextInternal()

    if not currentText or currentText == "" then
        return
    end

    local candidates = {}

    for i = 1, #self._autoCompleteList do
        local startPos, _, _ = string.find(self._autoCompleteList[i], currentText, 1, true)

        if not startPos or startPos ~= 1 then
            continue
        end

        candidates[#candidates + 1] = self._autoCompleteList[i]
    end

    if #candidates == 0 then
        return
    elseif #candidates == 1 then
        return candidates[1]
    else
        return GetCommonBase(candidates, string.len(currentText))
    end
end

---
-- Registers a new string to the autocomplete list.
-- param string text The string to be added
-- @return Panel Returns the panel itself
-- @realm client
function DPANEL:RegisterAutoCompleteEntry(text)
    self._autoCompleteList[#self._autoCompleteList + 1] = text

    return self
end

---
-- Sets the value of the panel, only works when not editing it.
-- @note The cursor position is kept.
-- @param string strValue The new value that should be set
-- @return Panel Returns the panel itself
-- @realm client
function DPANEL:SetValue(strValue)
    if self:IsEditing() then
        return
    end

    local caretPos = self:GetCaretPos()

    self:SetTextInternal(strValue)
    self:TriggerOnWithBase("ValueChanged", strValue)

    self:SetCaretPos(caretPos)

    return self
end

---
-- Called from engine whenever a valid character is typed while the text entry is focused.
-- @ref https://wiki.facepunch.com/gmod/TextEntry:OnKeyCodeTyped
-- @param number keyCode The key code of the key pressed
-- @return boolean Whether you've handled the key press. Returning true prevents the default text entry behavior from occurring.
-- @hook
-- @realm client
function DPANEL:OnKeyCodeTyped(keyCode)
    self:TriggerOnWithBase("KeyCode", keyCode)

    if keyCode == KEY_ENTER and not self:IsMultiline() and self:IsEnterAllowed() then
        self:FocusNext()

        self:TriggerOnWithBase("Enter", self:GetTextInternal())
    elseif keyCode == KEY_TAB and self:IsTabbingEnabled() then
        local textComplete = self:GetAutoComplete()

        if textComplete then
            self:SetTextInternal(textComplete)
            self:SetCaretPos(string.len(textComplete))

            self:TriggerOnWithBase("ValueChanged", textComplete)
        end

        return true
    end
end

---
-- Engine hook that is called when the content of the element has changed.
-- @ref https://wiki.facepunch.com/gmod/DTextEntry:OnTextChanged
-- @param boolean noMenuRemoval Determines whether to remove the autocomplete menu (false) or not (true)
-- @hook
-- @realm client
function DPANEL:OnTextChanged(noMenuRemoval)
    local currentText = self:GetTextInternal()

    self:TriggerOnWithBase("ValueChanged", currentText)

    -- always show a highlight of possible matches
    if not self:IsTabbingEnabled() then
        return
    end

    self.m_CommonBase = self:GetAutoComplete()

    -- remove the common base in cases where it should not exist
    if not currentText or currentText == "" or currentText == self.m_CommonBase then
        self.m_CommonBase = nil
    end
end

---
-- Called after a key was pressed on the focused panel.
-- @param number keyCode The key code of the key pressed
-- @hook
-- @realm client
function DPANEL:OnKeyCode(keyCode) end

---
-- Called after the value of the textpanel changed.
-- @param string newValue The new content of the panel
-- @hook
-- @realm client
function DPANEL:OnValueChanged(newValue) end

---
-- @ignore
function DPANEL:OnDepressed()
    self:TriggerOnWithBase("GetFocus")
end

---
-- Hook that is called when the panel is focused by clicking on it.
-- @hook
-- @realm client
function DPANEL:OnGetFocus()
    -- cache the panel's original keyboard state
    self.isKeyBoardEnabled = self:IsKeyboardInputEnabled()

    util.GetHighestPanelParent(self):SetKeyboardInputEnabled(true)

    self:SetFocused(true)
end

---
-- Hook that is called when the panel loses focus.
-- @hook
-- @realm client
function DPANEL:OnLoseFocus()
    -- reset the original keyboard interaction state
    util.GetHighestPanelParent(self):SetKeyboardInputEnabled(self.isKeyBoardEnabled or false)

    self:SetFocused(false)
    self:InvalidateLayout()
end

---
-- Called whenever the value of the panel has been updated (whether by user input or otherwise).
-- It allows you to determine whether a user can modify the TextEntry's text.
-- @ref https://wiki.facepunch.com/gmod/DTextEntry:AllowInput
-- @param string strValue The newly typed char
-- @return boolean False to prevent the character from being added
-- @realm client
function DPANEL:AllowInput(strValue)
    if self:IsNumeric() then
        return string.find(strAllowedNumericCharacters, strValue, 1, true) == nil
    end

    return false
end

---
-- Returns the raw string in the text field, alias for GetTextInternal.
-- @return string The current content of the text field
-- @realm client
function DPANEL:GetString()
    return self:GetTextInternal() or ""
end

---
-- Returns the current content of the panel converted to a rounded number if possible.
-- @return nil|number The content as a number
-- @realm client
function DPANEL:GetInt()
    local num = tonumber(self:GetTextInternal())

    if not num then
        return nil
    end

    return math.Round(num)
end

---
-- Returns the current content of the panel converted to a float if possible.
-- @return nil|number The content as a float
-- @realm client
function DPANEL:GetFloat()
    return tonumber(self:GetTextInternal())
end
