---
-- @class PANEL
-- @section TTT2:DButton

DPANEL.derma = {
    className = "TTT2:DButton",
    description = "The standard button used in TTT2 with convar and database support",
    baseClassName = "TTT2:DPanel",
}

DPANEL.implements = {
    "settings",
}

local soundClick = Sound("common/talk.wav")

---
-- @accessor boolean
-- @realm client
AccessorFunc(DPANEL, "m_bIgnoreCallbackEnabledVar", "IgnoreCallbackEnabledVar", FORCE_BOOL)

---
-- @ignore
function DPANEL:Init()
    -- enable mouse and keyboard input to interact with button
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    -- set the cursor to show the user they can interact
    self:SetCursor("hand")
    self:SetVariableType(TYPE_BOOL)

    -- set visual defaults
    self:SetFont("DermaTTT2Button")
    self:SetTextCapitalized(true)
    self:EnableCornerRadius(true)
    self:SetOutline(0, 0, 0, vskin.GetBorderSize())
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
    if self:IsDepressed() then
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
