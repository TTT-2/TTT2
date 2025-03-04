---
-- @class PANEL
-- @section TTT2:DPanel/Dynamic

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bDoubleClicking", "DoubleClickingEnabled", FORCE_BOOL_IS, true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bIsToggle", "IsToggle", FORCE_BOOL, true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bToggle", "Toggle", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bDepressed", "Depressed", FORCE_BOOL_IS)

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bFitToContentX", "FitToContentX", FORCE_BOOL, true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bFitToContentY", "FitToContentY", FORCE_BOOL, true)

---
-- Returns the background color of the parent panel if the parent exists and
-- has a background color defined.
-- @return Color|nil Returns the color or nil
-- @realm client
function METAPANEL:GetParentColor()
    local parent = self:GetParent()

    if not IsValid(parent) or not isfunction(parent.GetColor) then
        return
    end

    return parent:GetColor()
end

---
-- Called after a color is applied to the color cache. Can be used to modify these colors
-- in a post processing step.
-- @param string identifier The name of the color
-- @param Color color The unchanged color
-- @return Color|nil Return the color to change it, return nil to keep it unchanged
-- @hook
-- @realm client
function METAPANEL:OnVSkinColorPostProcess(identifier, color)
    local colorShiftBackground = self:HasModule("box") and self:GetColorShift()
    local colorShiftOutline = self:HasModule("box") and self:GetOutlineColorShift()

    if identifier == "background" and colorShiftBackground and colorShiftBackground ~= 0 then
        return util.GetChangedColor(color, colorShiftBackground)
    end

    if identifier == "outline" and colorShiftOutline and colorShiftOutline ~= 0 then
        return util.GetChangedColor(color, colorShiftOutline)
    end
end

---
-- Called whenever the panel should apply its vskin. It is called
-- on perform layout.
-- @note This should be overwritten with more sensible colors.
-- @hook
-- @realm client
function METAPANEL:OnVSkinUpdate()
    self:ApplyVSkinColor("background", COLOR_WHITE)
    self:ApplyVSkinColor("text", COLOR_BLACK)
    self:ApplyVSkinColor("description", COLOR_BLACK)
    self:ApplyVSkinColor("icon", COLOR_BLACK)
    self:ApplyVSkinColor("outline", COLOR_WHITE)
    self:ApplyVSkinColor("flash", COLOR_RED)
end

---
-- Called whenever the panel should retranslate its content. It is called
-- on perform layout after the vskin data is updated and before the UI is.
-- rebuilt.
-- @hook
-- @realm client
function METAPANEL:OnTranslationUpdate()
    if not self:HasModule("text") then
        return
    end

    if self:HasText() and self:HasKeyBinding() then
        self:SetTranslatedText(
            LANG.GetDynamicTranslation(
                self:GetText(),
                self:GetTextParams(),
                self:ShouldTranslateTextParams()
            )
                .. " "
                .. self:GetTranslatedKeyBindingKey()
        )
    elseif self:HasText() then
        self:SetTranslatedText(
            LANG.GetDynamicTranslation(
                self:GetText(),
                self:GetTextParams(),
                self:ShouldTranslateTextParams()
            )
        )
    elseif self:HasKeyBinding() then
        self:SetTranslatedText(self:GetTranslatedKeyBindingKey())
    end

    if self:HasDescription() then
        self:SetTranslatedDescription(
            LANG.GetDynamicTranslation(
                self:GetDescription(),
                self:GetDescriptionParams(),
                self:ShouldTranslateDescriptionParams()
            )
        )
    end
end

---
-- Called whenever the panel should rebuild its layout. It is called
-- on perform layout after the vskin data is updated.
-- @param number w The panel's width
-- @param number h The panel's height
-- @hook
-- @realm client
function METAPANEL:OnRebuildLayout(w, h)
    local hasIcon = self:HasModule("icon") and self:HasIcon()
    local hasText = self:HasModule("text") and self:HasText()
    local hasDescription = self:HasModule("text") and self:HasDescription()

    local textTranslated = ""
    local textFont = "DermaTTT2Text"

    if hasText then
        textTranslated = self:GetTranslatedText() or ""
        textFont = self:GetFont() or "DermaTTT2Text"
    end

    local widthText, heightText = draw.GetTextSize(textTranslated, textFont)

    local padLeft, padTop, padRight, padBottom = 0, 0, 0, 0
    local hor = TEXT_ALIGN_CENTER
    local ver = TEXT_ALIGN_CENTER
    local hasVerticalAlignment = false

    if self:HasModule("alignment") then
        padLeft, padTop, padRight, padBottom = self:GetPadding()

        hor = self:GetHorizontalTextAlign()
        ver = self:GetVerticalTextAlign()

        hasVerticalAlignment = self:HasVerticalAlignment()
    end

    -- PRECALCULATE ICON SIZE
    local sizeIcon = 0
    local posIconX, posIconY, posTextX, posTextY, posDescriptionStartY, posDescriptionY

    if hasIcon then
        sizeIcon = self:GetIconSize()

        if not sizeIcon then
            if w < h then
                sizeIcon = w - padLeft - padRight
            else
                sizeIcon = h - padTop - padBottom
            end
        elseif sizeIcon == 0 then
            sizeIcon = math.min(w, h)
        end
    end

    -- RESIZE ELEMENT: the vertical resizing is different for vertical and horizontal alignment
    if self:GetFitToContentX() then
        -- to simplify things, FitToContentsX ignores the description text
        w = padLeft + padRight

        if hasVerticalAlignment then
            if hasIcon then
                w = sizeIcon + padLeft + padRight
            end

            if hasText then
                w = math.max(w, widthText + padLeft + padRight)
            end
        else
            if hasIcon and hasText then
                -- todo: is this a good idea to have padLeft as distance for icon?
                w = widthText + sizeIcon + 2 * padLeft + padRight
            elseif hasIcon then
                w = sizeIcon + padLeft + padRight
            elseif hasText then
                w = widthText + padLeft + padRight
            end
        end

        self:SetWide(w)
    end

    -- if the panel has text and the box size isn't influenced by the content, the text should
    -- be cut off if it is too long to fit
    if not self:GetFitToContentX() and hasText then
        local maxWidthText = w - padLeft - padRight

        -- only substract the width of the icon, if it is next to the text
        if not hasVerticalAlignment and hasIcon then
            maxWidthText = maxWidthText - sizeIcon - padLeft
        end

        -- trim the text if necessary
        textTranslated = draw.GetLimitedLengthText(textTranslated, maxWidthText, textFont, "...")

        self:SetTranslatedText(textTranslated)

        -- update to the new text length after trimming
        widthText, _ = draw.GetTextSize(textTranslated, textFont)
    end

    -- CALCULATE TEXT AND ICON POSITION
    if hasVerticalAlignment then
        if hor == TEXT_ALIGN_LEFT then
            posIconX = padLeft
            posTextX = padLeft
        elseif hor == TEXT_ALIGN_CENTER then
            posTextX = 0.5 * w
            posIconX = 0.5 * (w - sizeIcon)
        elseif hor == TEXT_ALIGN_RIGHT then
            posIconX = w - padRight - sizeIcon
            posTextX = w - padRight
        end
    else
        if hor == TEXT_ALIGN_LEFT then
            if hasIcon and (hasText or hasDescription) then
                posIconX = padLeft
                posTextX = posIconX + sizeIcon + padLeft
            elseif hasIcon then
                posIconX = padLeft
            elseif hasText or hasDescription then
                posTextX = padLeft
            end
        elseif hor == TEXT_ALIGN_CENTER then
            if hasIcon and (hasText or hasDescription) then
                posTextX = 0.5 * (w + sizeIcon + padLeft)
                posIconX = posTextX - sizeIcon - padLeft - 0.5 * widthText
            elseif hasIcon then
                posIconX = 0.5 * (w - sizeIcon)
            elseif hasText or hasDescription then
                posTextX = 0.5 * w
            end
        elseif hor == TEXT_ALIGN_RIGHT then
            if hasIcon and (hasText or hasDescription) then
                posIconX = w - padRight - sizeIcon
                posTextX = posIconX - padLeft
            elseif hasIcon then
                posIconX = w - padRight - sizeIcon
            elseif hasText or hasDescription then
                posTextX = w - padRight
            end
        end
    end

    local descriptionLines, heightDescription, heightDescriptionLine

    -- HANDLE DESCRIPTION WORD WRAP
    if hasDescription then
        local maxWidthDescription = w - padLeft - padRight

        -- only substract the width of the icon, if it is next to the text
        if not hasVerticalAlignment and hasIcon then
            maxWidthDescription = maxWidthDescription - padLeft - sizeIcon
        end

        descriptionLines, _, heightDescription = draw.GetWrappedText(
            self:GetTranslatedDescription(),
            maxWidthDescription,
            self:GetDescriptionFont()
        )

        _, heightDescriptionLine = draw.GetTextSize(descriptionLines[1], self:GetDescriptionFont())

        self:SetTranslatedDescriptionLines(descriptionLines)
    end

    -- RESIZE ELEMENT: the handle the vertical panel extension
    if self:GetFitToContentY() then
        h = padTop + padBottom

        if hasVerticalAlignment then
            local padMultiplier = 0

            if hasIcon then
                h = h + sizeIcon

                padMultiplier = padMultiplier + 1
            end

            if hasText then
                h = h + heightText

                padMultiplier = padMultiplier + 1
            end

            if hasDescription then
                h = h + heightDescription

                padMultiplier = padMultiplier + 1
            end

            h = h + math.max(padMultiplier - 1, 0) * padTop
        else
            if hasText and hasDescription then
                h = heightText + heightDescription + 2 * padTop + padBottom
            elseif hasText then
                h = heightText + padTop + padBottom
            elseif hasDescription then
                h = heightDescription + padTop + padBottom
            end

            if hasIcon then
                h = math.max(h, sizeIcon + padTop + padBottom)
            end
        end

        self:SetTall(h)
    end

    -- VERTICAL POSITIONING
    if hasVerticalAlignment then
        if ver == TEXT_ALIGN_TOP then
            -- used to chain positioning
            local nextPos = padTop

            if hasIcon then
                posIconY = nextPos

                nextPos = nextPos + sizeIcon + padTop
            end

            if hasText then
                posTextY = nextPos

                nextPos = nextPos + heightText + padTop
            end

            if hasDescription then
                posDescriptionStartY = nextPos
            end
        elseif ver == TEXT_ALIGN_CENTER then
            posIconY = 0.5 * (h - (sizeIcon or 0))
            posTextY = 0.5 * h
            posDescriptionStartY = 0.5
                * (h - (#(descriptionLines or {}) - 1) * (heightDescriptionLine or 0))

            if hasIcon then
                posTextY = posTextY + 0.5 * (sizeIcon + padTop)
                posDescriptionStartY = posDescriptionStartY + 0.5 * (sizeIcon + padTop)
            end

            if hasText then
                posIconY = posIconY - 0.5 * (heightText + padTop)
                posDescriptionStartY = posDescriptionStartY + 0.5 * (heightText + padTop)
            end

            if hasDescription then
                posIconY = posIconY - 0.5 * (heightDescription + padTop)
                posTextY = posTextY - 0.5 * (heightDescription + padTop)
            end
        elseif ver == TEXT_ALIGN_BOTTOM then
            -- used to chain positioning
            local nextPos = h - padBottom

            if hasDescription then
                posDescriptionStartY = nextPos - (#descriptionLines - 1) * heightDescriptionLine

                nextPos = nextPos - heightDescription - padTop
            end

            if hasText then
                posTextY = nextPos

                nextPos = nextPos - heightText - padTop
            end

            if hasIcon then
                posIconY = nextPos - sizeIcon
            end
        end
    else
        if ver == TEXT_ALIGN_TOP then
            posTextY = padTop

            if hasIcon then
                posIconY = padTop
            end
        elseif ver == TEXT_ALIGN_CENTER then
            posTextY = 0.5 * h

            if hasIcon then
                posIconY = 0.5 * (h - sizeIcon)
            end
        elseif ver == TEXT_ALIGN_BOTTOM then
            posTextY = h - padBottom

            if hasIcon then
                posIconY = h - sizeIcon - padBottom
            end
        end

        if hasDescription then
            -- move text out of the way
            if ver == TEXT_ALIGN_TOP then
                if hasText then
                    posDescriptionStartY = posTextY + heightText + padTop
                else
                    posDescriptionStartY = posTextY
                end
            elseif ver == TEXT_ALIGN_CENTER then
                if hasText then
                    posTextY = posTextY - 0.5 * (heightDescription + padTop)
                    posDescriptionStartY = posTextY + heightText + padTop
                else
                    posDescriptionStartY = 0.5
                        * (h - (#descriptionLines - 1) * heightDescriptionLine)
                end
            elseif ver == TEXT_ALIGN_BOTTOM then
                if hasText then
                    posTextY = posTextY - heightDescription - padBottom
                    posDescriptionStartY = posTextY + heightText + padTop
                else
                    posDescriptionStartY = h
                        - (#descriptionLines - 1) * heightDescriptionLine
                        - padBottom
                end
            end
        end
    end

    -- HANDLE POSITIONING OF DESCRIPTION LINES
    if hasDescription then
        posDescriptionY = {}

        for i = 1, #descriptionLines do
            posDescriptionY[i] = posDescriptionStartY + (i - 1) * heightDescriptionLine
        end
    end

    -- APPLY CALCULATED SIZES AND POSITIONS
    if hasText then
        self:ApplyVSkinDimension("posTextX", posTextX)
        self:ApplyVSkinDimension("posTextY", posTextY)
    end

    if hasDescription then
        self:ApplyVSkinDimension("posTextX", posTextX)
        self:ApplyVSkinDimension("posTableDescriptionY", posDescriptionY)
    end

    if hasIcon then
        self:ApplyVSkinDimension("sizeIcon", sizeIcon)

        self:ApplyVSkinDimension("posIconX", posIconX)
        self:ApplyVSkinDimension("posIconY", posIconY)
    end

    -- if the panel changed size and the panel has a parent, the parent should
    -- be recalculcating its size as well
    if self:GetFitToContentX() or self:GetFitToContentY() then
        self:InvalidateParent(true)
    end
end

-- HOOKS DEFINED IN THE ENGINE --

---
-- Called whenever the panels' layout needs to be performed again. This means all child panels must
-- be re-positioned to fit the possibly new size of this panel.
-- @note Be careful when overwriting this function, consider using @{OnVSkinUpdate} and
-- @{OnRebuildLayout} instead.
-- @ref https://wiki.facepunch.com/gmod/PANEL:PerformLayout
-- @param number w The panel's width
-- @param number h The panel's height
-- @hook
-- @realm client
function METAPANEL:PerformLayout(w, h)
    -- call internal hooks that are used to rebuild the design. First, the color cache is rebuilt,
    -- then the translation and lastly the design scaling is redone.
    self:TriggerOnWithBase("VSkinUpdate")
    self:TriggerOnWithBase("TranslationUpdate")
    self:TriggerOnWithBase("RebuildLayout", w, h)
end

---
-- Called every frame while Panel:IsVisible is true.
-- @ref https://wiki.facepunch.com/gmod/PANEL:Think
-- @hook
-- @realm client
function METAPANEL:Think()
    self:TriggerOn("Think")
end

---
-- Called whenever the cursor entered the panels bounds.
-- @ref https://wiki.facepunch.com/gmod/PANEL:OnCursorEntered
-- @hook
-- @realm client
function METAPANEL:OnCursorEntered()
    self:TriggerOn("CursorEntered")

    self:InvalidateLayout(true)
end

---
-- Called whenever the cursor left the panels bounds.
-- @ref https://wiki.facepunch.com/gmod/PANEL:OnCursorExited
-- @hook
-- @realm client
function METAPANEL:OnCursorExited()
    self:TriggerOn("CursorExited")

    self:InvalidateLayout(true)
end

---
-- Called whenever a mouse key was pressed while the panel is focused.
-- @ref https://wiki.facepunch.com/gmod/PANEL:OnMousePressed
-- @param number mouseCode The key code of the mouse button pressed
-- @hook
-- @realm client
function METAPANEL:OnMousePressed(mouseCode)
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
function METAPANEL:OnMouseReleased(mouseCode)
    self:MouseCapture(false)

    if not self:IsEnabled() then
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
function METAPANEL:OnDepressed(mouseCode) end

---
-- Called when the player presses the label with any mouse button.
-- @param number mouseCode The mouse code defines the button that was released.
-- @hook
-- @realm client
function METAPANEL:OnReleased(mouseCode) end

---
-- Called when the toggle state of the label is changed by Label.
-- @note In order to use toggle functionality, you must first call `DLabel:SetIsToggle()` with
-- `true`, as it is disabled by default.
-- @param boolean state The current toggle state
-- @hook
-- @realm client
function METAPANEL:OnToggled(state) end

---
-- Called after the left mouse mouse was released on a button, performing a click.
-- @note Calls the internal toggle functionality if enabled.
-- @hook
-- @realm client
function METAPANEL:OnLeftClick()
    self:Toggle()
end

---
-- Called after the left mouse mouse was released on a button, performing a left click. This
-- function is called immidiately before OnLeftClick.
-- @hook
-- @realm client
function METAPANEL:OnLeftClickInternal() end

---
-- Called after the right mouse mouse was released on a button, performing a right click.
-- @hook
-- @realm client
function METAPANEL:OnRightClick() end

---
-- Called after the middle mouse mouse was released on a button, performing a middle click.
-- @hook
-- @realm client
function METAPANEL:OnMiddleClick() end

---
-- Called after the left mouse mouse was released on a button, performing a double click.
-- @note Calls the internal toggle functionality if enabled.
-- @hook
-- @realm client
function METAPANEL:OnDoubleClick() end

---
-- Called after the left mouse mouse was released on a button, performing a double click. This
-- function is called immidiately before OnDoubleClick.
-- @hook
-- @realm client
function METAPANEL:OnDoubleClickInternal() end

---
-- Toggles the state of the panel.
-- @realm client
function METAPANEL:Toggle()
    if not self:GetIsToggle() then
        return
    end

    self:SetToggle(not self:GetToggle())

    self:TriggerOnWithBase("Toggled", self:GetToggle())
end
