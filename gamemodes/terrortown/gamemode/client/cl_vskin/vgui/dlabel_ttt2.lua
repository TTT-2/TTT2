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
--   OnVSkinUpdate
--   OnTranslationUpdate
--   OnRebuildLayout

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
AccessorFunc(PANEL, "m_bAutoStretchVertical", "AutoStretchVerticalEnabled", FORCE_BOOL_IS, true) -- ?? do we use this anywhere?

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL) -- ??? needed in TTT2:DComboBox?

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bPaintBackground", "PaintBackground", FORCE_BOOL)

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
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nTextAlign", "TextAlign", FORCE_NUMBER, true)

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "m_cColor", "Color", FORCE_COLOR, true)

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "m_cOutlineColor", "OutlineColor", FORCE_COLOR, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nColorShift", "ColorShift", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nOutlineColorShift", "OutlineColorShift", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_TranslatedText", "TranslatedText", FORCE_STRING, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_TranslatedDescription", "TranslatedDescription", FORCE_STRING, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_TranslatedDescriptionLines", "TranslatedDescriptionLines", nil, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nVerticalTextAlign", "VerticalTextAlign", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nHorizontalTextAlign", "HorizontalTextAlign", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nVerticalTextAlign", "VerticalTextAlign", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nPadding", "Padding", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nBackgroundAlpha", "BackgroundAlpha", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_nOutlineAlpha", "OutlineAlpha", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_bFitToContentX", "FitToContentX", FORCE_BOOL, true)

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_bFitToContentY", "FitToContentY", FORCE_BOOL, true)

---
-- @ignore
function PANEL:Init()
    -- data attached to the panel is put in its own scope
    self._eventListeners = {}
    self._attached = {}
    self._vskinColor = {}
    self._vskinDimension = {}
    self._tooltip = {}

    -- enable the panel
    self:SetEnabled(true)

    -- disable toggling and set state to false
    self:SetIsToggle(false)
    self:SetToggle(false)

    -- disable keyboard and mouse input
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    self:SetDoubleClickingEnabled(false)

    -- turn off the engine drawing
    self:SetPaintBackgroundEnabled(false)

    -- set visual defaults
    self:SetPaintBackground(true)
    self:SetTall(20)
    self:SetFont("DermaTTT2Text")
    self:SetDescriptionFont("DermaTTT2Text")
    self:SetTextAlign(TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

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
-- @param any ... The hook parameters
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
-- @param any ... The hook parameters
-- @return any Returns whatever the specific hook may return
-- @internal
-- @realm client
function PANEL:TriggerOnWithBase(eventName, ...)
    self:TriggerOn(eventName, ...)

    if isfunction(self["On" .. eventName]) then
        return self["On" .. eventName](self, ...)
    end
end

---
-- Calls the deprecated hook function directly registered on the Panel.
-- @param string eventName The name of the event
-- @param any ... The hook parameters
-- @return any Returns whatever the specific hook may return
-- @internal
-- @realm client
function PANEL:TriggerDeprecatedEvent(eventName, ...)
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
-- Applies a vskin color. VSkin colors are updated on vskin change and are then
-- cached for further use. They are set in @{OnVSkinUpdate}.
-- @param string identifier A unique identifer with the name of the color
-- @param Color color The color that is set here
-- @return Color Returns the added color as a pass-through
-- @internal
-- @realm client
function PANEL:ApplyVSkinColor(identifier, color)
    -- the color is copied here to make sure that any modifications to that
    -- color won't change anything downstram
    self._vskinColor[identifier] = table.Copy(color)

    return color
end

---
-- Returns the defined vSkin color for that identifier.
-- @param string identifier A unique identifer with the name of the color
-- @return Color The vskin color for that identifier
-- @imternal
-- @realm client
function PANEL:GetVSkinColor(identifier)
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
function PANEL:ApplyVSkinDimension(identifier, dimension)
    self._vskinDimension[identifier] = dimension

    return dimension
end

---
-- Returns the defined vSkin color for that identifier.
-- @param string identifier A unique identifer with the name of the dimension
-- @return dimension The vskin dimension for that identifier
-- @imternal
-- @realm client
function PANEL:GetVSkinDimension(identifier)
    return self._vskinDimension[identifier]
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
-- Sets the font of the panel.
-- @param string fontName The name of the font
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetFont(fontName)
    self.m_FontName = fontName

    self:SetFontInternal(self.m_FontName)
    self:InvalidateLayout()

    return self
end

---
-- Sets the font of the description of the panel.
-- @param string fontName The name of the font
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetDescriptionFont(fontName)
    self.m_DescriptionFontName = fontName

    self:InvalidateLayout()

    return self
end

---
-- Returns the name of the font used for the description
-- @return string The description font name
-- @realm client
function PANEL:GetDescriptionFont()
    return self.m_DescriptionFontName
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
-- Toggles the state of the panel.
-- @realm client
function PANEL:Toggle()
    if not self:GetIsToggle() then
        return
    end

    self:SetToggle(not self:GetToggle())

    self:TriggerOnWithBase("Toggle", self:GetToggle())
end

---
-- Adds an icon to the panel. The icon can have a dropshadow and a fixed size.
-- @note Horizontal text alignment is also applied to the icon.
-- @param Material iconMaterial The icon material that should be added
-- @param[default=DRAW_SHADOW_DISABLED] boolean isShadowed Set to enable/disable drop shadow
-- @param[default=DRAW_ICON_SIMPLE] boolean isSimple Set to enable/disable icon coloring
-- @param[opt] number size The size in pixels, automatically determined if not set
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetIcon(iconMaterial, isShadowed, isSimple, size)
    self.m_mIconMaterial = iconMaterial
    self.m_bIconShadow = isShadowed or DRAW_SHADOW_DISABLED
    self.m_bIconSimple = isSimple or DRAW_ICON_SIMPLE
    self.m_nIconSize = size

    return self
end

---
-- Returns the added icon material, nil if none was added.
-- @return Material|nil The added material
-- @realm client
function PANEL:GetIcon()
    return self.m_mIconMaterial
end

---
-- Checks whether the panel has an attached icon.
-- @return boolean True if there is an icon attached
-- @realm client
function PANEL:HasIcon()
    return self.m_mIconMaterial ~= nil
end

---
-- Returns if the icon should have a drop shadow, nil if not set.
-- @return boolean|nil True if drop shadow is enabled
-- @realm client
function PANEL:HasIconShadow()
    return self.m_bIconShadow
end

---
-- Returns the icon size nil if not set.
-- @return number|nil The size in pixels
-- @realm client
function PANEL:GetIconSize()
    return self.m_nIconSize
end

-- Returns whether the icon is simple or has RGB colors.
-- @return boolean Returns true if the icon is simple
-- @realm client
function PANEL:IsIconSimple()
    return self.m_bIconSimple
end

---
-- Enables a pulsating background flash color used to hightlight things. The
-- color is determined automatically by the panel color.
-- @param boolean state Set to true to enable pulsating background.
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:EnableFlashColor(state)
    self.m_bEnableFlashColor = state

    return self
end

---
-- Checks whether the panel has background flash color enabled.
-- @return boolean Returns true if the flash color is enabled
-- @realm client
function PANEL:HasFlashColor()
    return self.m_bEnableFlashColor or false
end

---
-- Sets the text alignment in both directions.
-- @param number horizontal The horizontal text alignment
-- @param number vertical The vertical text alignment
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetTextAlign(horizontal, vertical)
    self:SetHorizontalTextAlign(horizontal)
    self:SetVerticalTextAlign(vertical)

    return self
end

---
-- Sets the text to a panel.
-- @param string The text of a panel, can be a language identifier
-- @param[opt] table params Translation params that should be added to the text
-- @param[default=false] boolean translateParams Should the parameters be translated as well
-- @param[default=false] boolean isShadowed Should the text be rendered with a shadow
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetText(text, params, translateParams, isShadowed)
    self.m_Text = text
    self.m_TextParams = params
    self.m_bTranslateTextParams = translateParams
    self.m_bTextShadow = isShadowed

    return self
end

---
-- Gets the text set to the panel.
-- @return string Rerturns the attached text
-- @realm client
function PANEL:GetText()
    return self.m_Text or ""
end

---
-- Checks whether a panel has any text set to it.
-- @return boolean Returns true if text is added to the panel
-- @realm client
function PANEL:HasText()
    return self.m_Text ~= nil
end

---
-- Returns if a panel has text params set.
-- @return boolean Returns true if a label has text params
-- @realm client
function PANEL:GetTextParams()
    return self.m_TextParams
end

---
-- Returns if a panel has text params set.
-- @return boolean Returns true if a label has text params
-- @realm client
function PANEL:HasTextParams()
    return self.m_TextParams ~= nil
end

---
-- Whether the text params should be translated.
-- @return boolean True if the text params should be translated
-- @realm client
function PANEL:ShouldTranslateTextParams()
    return self.m_bTranslateTextParams or LANG_DONT_TRANSLATE_PARAMS
end

---
-- Returns if the text should have a drop shadow.
-- @return boolean True if drop shadow is enabled
-- @realm client
function PANEL:HasTextShadow()
    return self.m_bTextShadow or DRAW_SHADOW_ENABLED
end

---
-- Sets the description to a panel.
-- @param string The description of a panel, can be a language identifier
-- @param[opt] table params Translation params that should be added to the description
-- @param[default=false] boolean translateParams Should the parameters be translated as well
-- @param[default=false] boolean isShadowed Should the description be rendered with a shadow
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetDescription(description, params, translateParams, isShadowed)
    self.m_Description = description
    self.m_DescriptionParams = params
    self.m_bTranslateDescriptionParams = translateParams
    self.m_bDescriptionShadow = isShadowed

    return self
end

---
-- Gets the description set to the panel.
-- @return string Rerturns the attached description
-- @realm client
function PANEL:GetDescription()
    return self.m_Description or ""
end

---
-- Checks whether a panel has any description set to it.
-- @return boolean Returns true if description is added to the panel
-- @realm client
function PANEL:HasDescription()
    return self.m_Description ~= nil
end

---
-- Returns if a panel has description params set.
-- @return boolean Returns true if a label has description params
-- @realm client
function PANEL:GetDescriptionParams()
    return self.m_DescriptionParams
end

---
-- Returns if a panel has description params set.
-- @return boolean Returns true if a label has description params
-- @realm client
function PANEL:HasDescriptionParams()
    return self.m_DescriptionParams ~= nil
end

---
-- Whether the description params should be translated.
-- @return boolean True if the description params should be translated
-- @realm client
function PANEL:ShouldTranslateDescriptionParams()
    return self.m_bTranslateDescriptionParams or LANG_DONT_TRANSLATE_PARAMS
end

---
-- Returns if the description should have a drop shadow.
-- @return boolean True if drop shadow is enabled
-- @realm client
function PANEL:HasDescriptionShadow()
    return self.m_bDescriptionShadow or DRAW_SHADOW_ENABLED
end

---
-- Enables a corner radius. If set to false, the box is a normal rectange, if set to true, the
-- box has rounded corners.
-- @note Backgroun drawing has to be enabled.
-- @param boolean state Set to true to enable corner radius
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:EnableCornerRadius(state)
    self.m_bCornerRadius = state

    return self
end

---
-- Checks whether this panel has corner radius enabled.
-- @return boolean Returns true if the corner radius is enabled
-- @realm client
function PANEL:HasCornerRadius()
    return self.m_bCornerRadius or false
end

---
-- Sets the outline thickness of a panel.
-- @note If one parameter is provided, this value is for all four sides. If two values
-- are provided, the first is for the vertival outlines, the second for the horizontal.
-- If four are provided they are set left, top, right, bottom.
-- @param number ... The outline thickness
-- @return Panel Returns the panel itself
-- @realm client
function PANEL:SetOutline(...)
    local sizes = { ... }

    if #sizes == 0 then
        self.m_nOutlineLeft = nil
        self.m_nOutlineTop = nil
        self.m_nOutlineRight = nil
        self.m_nOutlineBottom = nil
    elseif #sizes == 1 then
        self.m_nOutlineLeft = sizes[1]
        self.m_nOutlineTop = sizes[1]
        self.m_nOutlineRight = sizes[1]
        self.m_nOutlineBottom = sizes[1]
    elseif #sizes == 2 then
        self.m_nOutlineLeft = sizes[1]
        self.m_nOutlineTop = sizes[2]
        self.m_nOutlineRight = sizes[1]
        self.m_nOutlineBottom = sizes[2]
    elseif #sizes == 4 then
        self.m_nOutlineLeft = sizes[1]
        self.m_nOutlineTop = sizes[2]
        self.m_nOutlineRight = sizes[3]
        self.m_nOutlineBottom = sizes[4]
    else
        error(
            "[TTT2] PANEL:SetOutline expects 1, 2 or 4 arguments, "
                .. tostring(#sizes)
                .. " were provided."
        )
    end

    return self
end

---
-- Gets the outline ticknesses for all four sides.
-- @return number The left outline
-- @return number The top outline
-- @return number The rihgt outline
-- @return number The bottom outline
-- @realm client
function PANEL:GetOutline()
    return self.m_nOutlineLeft, self.m_nOutlineTop, self.m_nOutlineRight, self.m_nOutlineBottom
end

---
-- Checks whether the panel has an outline applied.
-- @return boolean Returns true if the panel has an outline
-- @realm client
function PANEL:HasOutline()
    return self.m_nOutlineLeft ~= nil
end

---
-- Checks whether a paint hook name is defined for this panel.
-- @return boolean Returns true if defined
-- @realm client
function PANEL:HasPaintHookName()
    return self.m_PaintHookName ~= nil
end

---
-- Returns the background color of the parent panel if the parent exists and
-- has a background color defined.
-- @return Color|nil Returns the color or nil
-- @realm client
function PANEL:GetParentColor()
    local parent = self:GetParent()

    if not IsValid(parent) then
        return
    end

    return parent:GetColor()
end

-- HOOKS DEFINED IN THE ENGINE --

---
-- Called every frame to paint the element.
-- @note This hook will not run if the panel is completely off the screen, and will still run if
-- any parts of the panel are still on screen.
-- @param number w The panel's width
-- @param number h The panel's height
-- @return boolean Returning true prevents the background from being drawn
-- @realm client
function PANEL:Paint(w, h)
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

---
-- Called whenever the panel should apply its vskin. It is called
-- on perform layout.
-- @hook
-- @realm client
function PANEL:OnVSkinUpdate()
    local colorBackground, colorText, colorOutline

    colorBackground = util.GetAlphaColorColorAlpha(
        util.GetChangedColor(
            self:GetColor() or self:GetParentColor() or vskin.GetBackgroundColor(),
            self:GetColorShift() or 0
        ),
        self:GetBackgroundAlpha()
    )
    colorText = util.GetDefaultColor(colorBackground)
    colorOutline = util.GetAlphaColor(
        util.GetChangedColor(self:GetOutlineColor() or colorText, self:GetOutlineColorShift() or 0),
        self:GetOutlineAlpha()
    )

    self:ApplyVSkinColor("background", colorBackground)
    self:ApplyVSkinColor("text", colorText)
    self:ApplyVSkinColor("description", colorText)
    self:ApplyVSkinColor("icon", colorText)
    self:ApplyVSkinColor("outline", colorOutline)
    self:ApplyVSkinColor("flash", colorText)
end

---
-- Called whenever the panel should retranslate its content. It is called
-- on perform layout after the vskin data is updated and before the UI is.
-- rebuilt.
-- @hook
-- @realm client
function PANEL:OnTranslationUpdate()
    if self:HasText() then
        self:SetTranslatedText(
            LANG.GetDynamicTranslation(
                self:GetText(),
                self:GetTextParams(),
                self:ShouldTranslateTextParams()
            )
        )
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
function PANEL:OnRebuildLayout(w, h)
    local shortestEdge = math.min(w, h)
    local textTranslated = self:GetTranslatedText() or ""
    local widthText, heightText = draw.GetTextSize(textTranslated, self:GetFont())

    -- as a basic fallback, this should be a solid padding
    local padding = self:GetPadding() or math.Round(0.1 * shortestEdge)

    -- PRECALCULATE ICON SIZE
    local sizeIcon = self:GetIconSize()
    local posIconX, posIconY, marginIcon

    if self:HasIcon() then
        if not sizeIcon then
            marginIcon = padding

            sizeIcon = shortestEdge - 2 * marginIcon
            posIconY = marginIcon
        elseif sizeIcon == 0 then
            sizeIcon = shortestEdge
            marginIcon = 0

            posIconY = 0
        else
            marginIcon = padding

            posIconY = 0.5 * (shortestEdge - sizeIcon)
        end
    end

    -- RESIZE ELEMENT
    if self:GetFitToContentX() then
        if self:HasIcon() and self:HasText() then
            w = widthText + sizeIcon + marginIcon + 2 * padding
        elseif self:HasIcon() then
            w = sizeIcon + 2 * marginIcon
        elseif self:HasText() then
            w = widthText + 2 * padding
        end

        self:SetWide(w)
    -- if the panel has text and the box size isn't influenced by the content, the text should
    -- be cut off if it is too long to fix
    elseif self:HasText() then
        local maxWidthText = w - 2 * padding

        if self:HasIcon() then
            maxWidthText = maxWidthText - sizeIcon - marginIcon
        end

        -- trim the text if necessary
        textTranslated =
            draw.GetLimitedLengthText(textTranslated, maxWidthText, self:GetFont(), "...")

        self:SetTranslatedText(textTranslated)

        -- update to the new text length after trimming
        widthText, _ = draw.GetTextSize(textTranslated, self:GetFont())
    end

    -- CALCULATE TEXT AND ICON POSITION
    local hor = self:GetHorizontalTextAlign()
    local ver = self:GetVerticalTextAlign()

    local posTextX, posTextY, posDescriptionY

    if hor == TEXT_ALIGN_LEFT then
        if self:HasIcon() and self:HasText() then
            posIconX = marginIcon
            posTextX = posIconX + sizeIcon + padding
        elseif self:HasIcon() then
            posIconX = marginIcon
        elseif self:HasText() then
            posTextX = padding
        end
    elseif hor == TEXT_ALIGN_CENTER then
        if self:HasIcon() and self:HasText() then
            posTextX = 0.5 * (w + sizeIcon + padding)
            posIconX = posTextX - sizeIcon - padding - 0.5 * widthText
        elseif self:HasIcon() then
            posIconX = 0.5 * (w - sizeIcon)
        elseif self:HasText() then
            posTextX = 0.5 * w
        end
    elseif hor == TEXT_ALIGN_RIGHT then
        if self:HasIcon() and self:HasText() then
            posIconX = w - marginIcon - sizeIcon
            posTextX = posIconX - padding
        elseif self:HasIcon() then
            posIconX = w - marginIcon - sizeIcon
        elseif self:HasText() then
            posTextX = w - padding
        end
    end

    -- to simplify things, size to contentsX ignores the description text
    local descriptionLines, heightDescription

    if self:HasDescription() then
        local maxWidthDescription = w - 2 * padding

        if self:HasIcon() then
            maxWidthDescription = maxWidthDescription - padding - sizeIcon - marginIcon
        end

        descriptionLines, _, heightDescription = draw.GetWrappedText(
            self:GetTranslatedDescription(),
            maxWidthDescription,
            self:GetDescriptionFont()
        )

        self:SetTranslatedDescriptionLines(descriptionLines)
    end

    if self:GetFitToContentY() then
        local enlarge = 0

        if self:HasText() then
            enlarge = heightText + 2 * padding
        end

        if self:HasDescription() then
            enlarge = enlarge + heightDescription + padding
        end

        if self:HasIcon() then
            enlarge = math.max(enlarge, sizeIcon + 2 * marginIcon)
        end

        h = enlarge

        self:SetTall(h)
    end

    if ver == TEXT_ALIGN_TOP then
        posTextY = padding

        if self:HasIcon() then
            posIconY = marginIcon
        end
    elseif ver == TEXT_ALIGN_CENTER then
        posTextY = 0.5 * h

        -- icon position already exists for this case
    elseif ver == TEXT_ALIGN_BOTTOM then
        posTextY = h - padding

        if self:HasIcon() then
            posIconY = h - sizeIcon - marginIcon
        end
    end

    if self:HasDescription() then
        local _, heightDescriptionLine =
            draw.GetTextSize(descriptionLines[1], self:GetDescriptionFont())

        -- move text out of the way
        if ver == TEXT_ALIGN_TOP then
            posTextY = posTextY
        elseif ver == TEXT_ALIGN_CENTER then
            posTextY = posTextY - 0.5 * (heightDescription + padding)
        elseif ver == TEXT_ALIGN_BOTTOM then
            posTextY = posTextY - #descriptionLines * heightDescriptionLine - padding
        end

        posDescriptionY = {}

        for i = 1, #descriptionLines do
            posDescriptionY[i] = posTextY + heightText + padding + (i - 1) * heightDescriptionLine
        end
    end

    -- APPLY CALCULATED SIZES AND POSITIONS
    if self:HasText() then
        self:ApplyVSkinDimension("posTextX", posTextX)
        self:ApplyVSkinDimension("posTextY", posTextY)
    end

    if self:HasDescription() then
        self:ApplyVSkinDimension("posTextX", posTextX)
        self:ApplyVSkinDimension("posTableDescriptionY", posDescriptionY)
    end

    if self:HasIcon() then
        self:ApplyVSkinDimension("sizeIcon", sizeIcon)

        self:ApplyVSkinDimension("posIconX", posIconX)
        self:ApplyVSkinDimension("posIconY", posIconY)
    end
end

---
-- Called every frame while Panel:IsVisible is true.
-- @ref https://wiki.facepunch.com/gmod/PANEL:Think
-- @hook
-- @realm client
function PANEL:Think()
    self:TriggerOn("Think")
end

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
function PANEL:PerformLayout(w, h)
    w = w or self:GetWide()
    h = h or self:GetTall()

    -- call internal hooks that are used to rebuild the design. First, the color cache is rebuilt,
    -- then the translation and lastly the design scaling is redone.
    self:TriggerOnWithBase("VSkinUpdate")
    self:TriggerOnWithBase("TranslationUpdate")
    self:TriggerOnWithBase("RebuildLayout", w, h)
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
-- @param Panel panel The panel that should be attached
-- @return Panel Returns the panel itself
-- @realm client
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
        w = (w or 0) + 2,
        h = (h or 0) + (self._tooltip.sizeArrow or 0) + 2,
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
