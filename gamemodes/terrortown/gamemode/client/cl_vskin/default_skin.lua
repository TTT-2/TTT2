-- @class SKIN
-- @section default_skin

local materialClose = Material("vgui/ttt/vskin/icon_close")
local materialBack = Material("vgui/ttt/vskin/icon_back")
local materialCollapseOpened = Material("vgui/ttt/vskin/icon_collapse_opened")
local materialCollapseClosed = Material("vgui/ttt/vskin/icon_collapse_closed")
local materialRhombus = Material("vgui/ttt/vskin/rhombus")
local materialCardAdded = Material("vgui/ttt/vskin/card_added")
local materialCardRemoved = Material("vgui/ttt/vskin/card_removed")
local materialHeadboxYes = Material("vgui/ttt/vskin/icon_headbox_yes")
local materialHeadboxNo = Material("vgui/ttt/vskin/icon_headbox_no")
local materialHattableYes = Material("vgui/ttt/vskin/icon_hattable_yes")
local materialHattableNo = Material("vgui/ttt/vskin/icon_hattable_no")

local colorCardAdded = Color(80, 190, 25)
local colorCardInheritAdded = Color(25, 190, 175)
local colorCardInheritRemoved = Color(185, 45, 25)

local SKIN = {
    Name = "ttt2_default",
}

local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation
local DynT = LANG.GetDynamicTranslation

local mathRound = math.Round

local utilGetDefaultColor = util.GetDefaultColor
local utilGetChangedColor = util.GetChangedColor
local utilGetHoverColor = util.GetHoverColor
local utilGetActiveColor = util.GetActiveColor
local utilColorDarken = util.ColorDarken

local vskinGetBackgroundColor = vskin.GetBackgroundColor
local vskinGetAccentColor = vskin.GetAccentColor
local vskinGetDarkAccentColor = vskin.GetDarkAccentColor
local vskinGetShadowColor = vskin.GetShadowColor
local vskinGetTitleTextColor = vskin.GetTitleTextColor
local vskinGetScrollbarColor = vskin.GetScrollbarColor
local vskinGetShadowSize = vskin.GetShadowSize
local vskinGetHeaderHeight = vskin.GetHeaderHeight
local vskinGetBorderSize = vskin.GetBorderSize
local vskinGetCornerRadius = vskin.GetCornerRadius

local drawRoundedBox = draw.RoundedBox
local drawRoundedBoxEx = draw.RoundedBoxEx
local drawBox = draw.Box
local drawShadowedText = draw.ShadowedText
local drawFilteredShadowedTexture = draw.FilteredShadowedTexture
local drawOutlinedBox = draw.OutlinedBox
local drawFilteredTexture = draw.FilteredTexture
local drawSimpleText = draw.SimpleText
local drawLine = draw.Line
local drawGetWrappedText = draw.GetWrappedText
local drawGetTextSize = draw.GetTextSize
local drawGetLimitedLengthText = draw.GetLimitedLengthText

local alphaDisabled = 100

local colors = {}
local sizes = {}

-- register fonts
surface.CreateAdvancedFont(
    "DermaTTT2Title",
    { font = "Tahoma", size = 26, weight = 300, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2TitleSmall",
    { font = "Tahoma", size = 18, weight = 600, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2MenuButtonTitle",
    { font = "Tahoma", size = 22, weight = 300, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2MenuButtonDescription",
    { font = "Tahoma", size = 14, weight = 300, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2SubMenuButtonTitle",
    { font = "Tahoma", size = 18, weight = 600, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2MenuButtonDescription",
    { font = "Tahoma", size = 14, weight = 300, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2SubMenuButtonTitle",
    { font = "Tahoma", size = 18, weight = 600, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2Button",
    { font = "Tahoma", size = 14, weight = 600, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2CatHeader",
    { font = "Tahoma", size = 16, weight = 900, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2TextSmall",
    { font = "Tahoma", size = 12, weight = 300, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2Text",
    { font = "Tahoma", size = 16, weight = 300, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2TextLarge",
    { font = "Tahoma", size = 18, weight = 300, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2TextLarger",
    { font = "Tahoma", size = 20, weight = 900, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2TextLargest",
    { font = "Tahoma", size = 24, weight = 900, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2TextHuge",
    { font = "Tahoma", size = 72, weight = 900, extended = true }
)
surface.CreateAdvancedFont(
    "DermaTTT2SmallBold",
    { font = "Tahoma", size = 14, weight = 900, extended = true }
)

---
-- Updates the @{SKIN}
-- @realm client
function SKIN:UpdatedVSkin()
    colors = {
        background = vskinGetBackgroundColor(),
        accent = vskinGetAccentColor(),
        accentHover = utilGetHoverColor(vskinGetAccentColor()),
        accentActive = utilGetActiveColor(vskinGetAccentColor()),
        accentText = utilGetDefaultColor(vskinGetAccentColor()),
        accentDark = vskinGetDarkAccentColor(),
        accentDarkHover = utilGetHoverColor(vskinGetDarkAccentColor()),
        accentDarkActive = utilGetActiveColor(vskinGetDarkAccentColor()),
        sliderInactive = utilGetChangedColor(vskinGetBackgroundColor(), 75),
        shadow = vskinGetShadowColor(),
        titleText = vskinGetTitleTextColor(),
        default = utilGetDefaultColor(vskinGetBackgroundColor()),
        content = utilGetChangedColor(vskinGetBackgroundColor(), 30),
        handle = utilGetChangedColor(vskinGetBackgroundColor(), 15),
        settingsBox = utilGetChangedColor(vskinGetBackgroundColor(), 150),
        helpBox = utilGetChangedColor(vskinGetBackgroundColor(), 20),
        helpBar = utilGetChangedColor(vskinGetBackgroundColor(), 80),
        helpText = utilGetChangedColor(
            utilGetDefaultColor(utilGetChangedColor(vskinGetBackgroundColor(), 20)),
            40
        ),
        settingsText = utilGetDefaultColor(utilGetChangedColor(vskinGetBackgroundColor(), 150)),
        scrollBar = vskinGetScrollbarColor(),
        scrollBarActive = utilColorDarken(vskinGetScrollbarColor(), 5),
    }

    sizes = {
        shadow = vskinGetShadowSize(),
        header = vskinGetHeaderHeight(),
        border = vskinGetBorderSize(),
        cornerRadius = vskinGetCornerRadius(),
    }
end

---
-- Draws the @{SKIN}'s frame
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintFrameTTT2(panel, w, h)
    if panel:GetPaintShadow() then
        DisableClipping(true)
        drawRoundedBox(
            sizes.shadow,
            -sizes.shadow,
            -sizes.shadow,
            w + 2 * sizes.shadow,
            h + 2 * sizes.shadow,
            colors.shadow
        )
        DisableClipping(false)
    end

    -- draw main panel box
    drawBox(0, 0, w, h, colors.background)

    -- draw panel header area
    drawBox(0, 0, w, sizes.header, colors.accent)
    drawBox(0, sizes.header, w, sizes.border, colors.accentDark)

    local title = panel:GetTitle()
    local text = ""

    if istable(title) then
        text = ParT(title.body, title.params)
    else
        text = TryT(title)
    end

    drawShadowedText(
        text,
        panel:GetTitleFont(),
        0.5 * w,
        0.5 * sizes.header,
        colors.titleText,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER,
        1
    )
end

---
-- Draws the Panel
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintPanel(panel, w, h) end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintNavPanelTTT2(panel, w, h)
    local _, _, rightPad = panel:GetDockPadding()
    drawBox(w - rightPad, 0, rightPad, h, ColorAlpha(colors.default, 200))
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintButtonPanelTTT2(panel, w, h)
    drawBox(0, 0, w, 1, ColorAlpha(colors.default, 200))
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintContentPanelTTT2(panel, w, h)
    drawBox(0, 0, w, h, colors.content)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintWindowCloseButton(panel, w, h)
    local colorBackground = colors.accent
    local colorText = ColorAlpha(colors.accentText, 150)
    local shift = 0
    local padding = 15

    if not panel:IsEnabled() then
        colorText = ColorAlpha(colors.accentText, 70)
    elseif panel.Depressed or panel:IsSelected() then
        colorBackground = colors.accentActive
        colorText = ColorAlpha(colors.accentText, 200)
        shift = 1
    elseif panel.Hovered then
        colorBackground = colors.accentHover
        colorText = colors.accentText
    end

    drawBox(0, 0, w, h, colorBackground)
    drawFilteredShadowedTexture(
        padding,
        padding + shift,
        w - 2 * padding,
        h - 2 * padding,
        materialClose,
        colorText.a,
        colorText
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintWindowBackButton(panel, w, h)
    local colorBackground = colors.accent
    local colorText = ColorAlpha(colors.accentText, 150)
    local shift = 0
    local padding_w = 10
    local padding_h = 15

    if not panel:IsEnabled() then
        colorText = ColorAlpha(colors.accentText, 70)
    elseif panel.Depressed or panel:IsSelected() then
        colorBackground = colors.accentActive
        colorText = ColorAlpha(colors.accentText, 200)
        shift = 1
    elseif panel.Hovered then
        colorBackground = colors.accentHover
        colorText = colors.accentText
    end

    drawBox(0, 0, w, h, colorBackground)
    drawFilteredShadowedTexture(
        padding_w,
        padding_h + shift,
        h - 2 * padding_h,
        h - 2 * padding_h,
        materialBack,
        colorText.a,
        colorText
    )
    drawShadowedText(
        TryT("button_menu_back"),
        "DermaTTT2TitleSmall",
        h - padding_w,
        0.5 * h + shift,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER,
        1
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintScrollBarGrip(panel, w, h)
    local colorScrollbar = colors.scrollBar
    local posX = 4
    local sizeX = w - 8

    if panel.Depressed then
        colorScrollbar = colors.scrollBarActive
        posX = 0
        sizeX = w
    elseif panel.Hovered then
        posX = 0
        sizeX = w
    end

    drawRoundedBox(sizes.cornerRadius, posX, 0, sizeX, h, colorScrollbar)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintMenuButtonTTT2(panel, w, h)
    if not panel.m_bBackground then
        return
    end

    local colorOutline = utilGetChangedColor(colors.default, 170)
    local colorDescription = utilGetChangedColor(colors.default, 145)
    local colorText = utilGetChangedColor(colors.default, 65)
    local colorIcon = utilGetChangedColor(colors.default, 170)
    local shift = 0
    local paddingText = 10
    local paddingIcon = 25

    if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
        colorOutline = utilGetChangedColor(colors.default, 135)
        colorDescription = utilGetChangedColor(colors.default, 135)
        colorIcon = utilGetChangedColor(colors.default, 160)
        colorText = utilGetChangedColor(colors.default, 50)
        shift = 1
    elseif panel.Hovered then
        colorOutline = utilGetChangedColor(colors.default, 135)
        colorDescription = utilGetChangedColor(colors.default, 135)
        colorIcon = utilGetChangedColor(colors.default, 160)
        colorText = utilGetChangedColor(colors.default, 50)
    end

    drawOutlinedBox(0, 0, w, h, 1, colorOutline)
    drawFilteredTexture(
        paddingIcon,
        paddingIcon + shift,
        h - 2 * paddingIcon,
        h - 2 * paddingIcon,
        panel:GetImage(),
        colorIcon.a,
        colorIcon
    )
    drawSimpleText(
        TryT(panel:GetTitle()),
        panel:GetTitleFont(),
        h,
        paddingText + shift,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_TOP
    )

    local desc_wrapped = drawGetWrappedText(
        TryT(panel:GetDescription()),
        w - h - 2 * paddingText,
        panel:GetDescriptionFont()
    )
    local line_pos = 35

    for i = 1, #desc_wrapped do
        drawSimpleText(
            desc_wrapped[i],
            panel:GetDescriptionFont(),
            h,
            line_pos + paddingText + shift,
            colorDescription,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_TOP
        )

        line_pos = line_pos + 20
    end
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintSubMenuButtonTTT2(panel, w, h)
    if not panel.m_bBackground then
        return
    end

    local colorBackground = colors.background
    local colorBar = colors.background
    local colorText = utilGetChangedColor(colors.default, 75)
    local colorIcon = utilGetChangedColor(COLOR_WHITE, 32)
    local shift = 0
    local pad = mathRound(0.3 * h)
    local hasIcon = panel:HasIcon()
    local isIconFullSize = panel:IsIconFullSize()
    local padIcon = isIconFullSize and 0 or pad
    local iconBadge = panel:GetIconBadge()
    local iconBadgeSize = panel:GetIconBadgeSize()
    local iconAlpha = isIconFullSize and 255 or colorText.a
    local sizeIcon = h - 2 * padIcon

    if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
        colorBackground = utilGetActiveColor(ColorAlpha(colors.accent, 50))
        colorBar = colors.accentActive
        colorText = utilGetActiveColor(utilGetChangedColor(colors.default, 25))
        colorIcon = utilGetActiveColor(utilGetChangedColor(COLOR_WHITE, 32))
        shift = 1
    elseif panel.Hovered then
        colorBackground = utilGetHoverColor(ColorAlpha(colors.accent, 50))
        colorBar = colors.accentHover
        colorText = utilGetHoverColor(utilGetChangedColor(colors.default, 75))
        colorIcon = utilGetHoverColor(utilGetChangedColor(COLOR_WHITE, 48))
    elseif panel:IsActive() then
        colorBackground = utilGetHoverColor(ColorAlpha(colors.accent, 50))
        colorBar = colors.accentHover
        colorText = utilGetHoverColor(utilGetChangedColor(colors.default, 75))
        colorIcon = utilGetHoverColor(utilGetChangedColor(COLOR_WHITE, 48))
    end

    drawBox(0, 0, sizes.border, h, colorBar)
    drawBox(sizes.border, 0, w - sizes.border, h, colorBackground)

    if hasIcon then
        drawFilteredShadowedTexture(
            pad + sizes.border,
            padIcon + shift,
            sizeIcon,
            sizeIcon,
            panel:GetIcon(),
            iconAlpha,
            colorIcon
        )
        if iconBadge then
            drawFilteredShadowedTexture(
                pad + sizes.border + sizeIcon - iconBadgeSize,
                padIcon + shift + sizeIcon - iconBadgeSize,
                iconBadgeSize,
                iconBadgeSize,
                iconBadge,
                iconAlpha,
                colors.accent
            )
        end
    end

    drawSimpleText(
        TryT(panel:GetTitle()),
        panel:GetTitleFont(),
        sizes.border + pad + (hasIcon and (sizeIcon + pad) or pad),
        0.5 * h + shift,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintCheckBox(panel, w, h)
    local colorBox, colorCenter, offset

    if panel:GetChecked() then
        if not panel:IsEnabled() then
            colorBox = ColorAlpha(colors.handle, alphaDisabled)
            colorCenter = ColorAlpha(colors.handle, alphaDisabled)
            offset = w - h
        elseif panel.Hovered then
            colorBox = colors.handle
            colorCenter = colors.accentHover
            offset = w - h
        else
            colorBox = colors.handle
            colorCenter = colors.accent
            offset = w - h
        end
    else
        if not panel:IsEnabled() then
            colorBox = ColorAlpha(colors.handle, alphaDisabled)
            colorCenter = ColorAlpha(colors.settingsBox, alphaDisabled)
            offset = 0
        elseif panel.Hovered then
            colorBox = colors.handle
            colorCenter = colors.accentHover
            offset = 0
        else
            colorBox = colors.handle
            colorCenter = colors.settingsBox
            offset = 0
        end
    end

    drawRoundedBox(4, 0, 0, w, h, colorBox)
    drawRoundedBox(4, offset + 3, 3, h - 6, h - 6, colorCenter)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintCheckBoxLabel(panel, w, h)
    local colorBox = colors.settingsBox
    local colorText = colors.settingsText

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
        colorText = ColorAlpha(colors.settingsText, alphaDisabled)
    end

    drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBox, true, false, true, false)

    local params = panel:GetTextParams()

    drawSimpleText(
        params and ParT(panel:GetText(), params) or TryT(panel:GetText()),
        panel:GetFont(),
        panel:GetTextPosition(),
        0.5 * h,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintCollapsibleCategoryTTT2(panel, w, h)
    drawBox(0, 0, w, h, colors.background)
    drawBox(0, h - sizes.border, w, sizes.border, colors.accent)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintCategoryHeaderTTT2(panel, w, h)
    local colorLine = utilGetChangedColor(colors.background, 50)
    local colorText = utilGetChangedColor(colors.default, 50)
    local paddingX = 10
    local paddingY = 10

    drawBox(0, 0, w, h, colors.background)

    if panel:GetParent():GetExpanded() then
        drawLine(0, h - 1, w, h - 1, colorLine)

        drawFilteredShadowedTexture(
            paddingX,
            paddingY + 1,
            h - 2 * paddingY,
            h - 2 * paddingY,
            materialCollapseOpened,
            colorText.a * 0.5,
            colorText
        )
    else
        drawFilteredShadowedTexture(
            paddingX,
            paddingY,
            h - 2 * paddingY,
            h - 2 * paddingY,
            materialCollapseClosed,
            colorText.a * 0.5,
            colorText
        )
    end

    drawSimpleText(
        string.upper(TryT(panel.text)),
        panel:GetFont(),
        h,
        0.5 * h,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintButtonTTT2(panel, w, h)
    local colorLine = colors.accentDark
    local colorBox = colors.accent
    local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)
    local shift = 0

    if not panel:IsEnabled() then
        local colorAccentDisabled = utilGetChangedColor(colors.default, 150)

        colorLine = utilColorDarken(colorAccentDisabled, 50)
        colorBox = utilGetChangedColor(colors.default, 150)
        colorText = ColorAlpha(utilGetDefaultColor(colorAccentDisabled), 220)
    elseif panel.Depressed or panel:IsSelected() or panel:GetToggle() then
        colorLine = colors.accentDarkActive
        colorBox = colors.accentActive
        colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)
        shift = 1
    elseif panel.Hovered then
        colorLine = colors.accentDarkHover
        colorBox = colors.accentHover
        colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)
    end

    drawBox(0, 0, w, h, colorBox)
    drawBox(0, h - sizes.border, w, sizes.border, colorLine)

    local translatedText = ""
    if panel:HasTextParams() then
        translatedText = string.upper(ParT(panel:GetText(), panel:GetTextParams()))
    else
        translatedText = string.upper(TryT(panel:GetText()))
    end

    local font = panel:GetFont()
    local xText = 0.5 * w

    if panel:HasIcon() then
        local widthText = drawGetTextSize(translatedText, font)
        local padding = 5
        local sizeIcon = panel:GetIconSize()
        local yIcon = 0.5 * (h - sizeIcon)

        xText = 0.5 * (w + sizeIcon + padding)

        local xIcon = xText - sizeIcon - padding - 0.5 * widthText

        if panel:IsIconShadowed() then
            drawFilteredShadowedTexture(
                xIcon,
                yIcon,
                sizeIcon,
                sizeIcon,
                panel:GetIcon(),
                255,
                colorText
            )
        else
            drawFilteredTexture(xIcon, yIcon, sizeIcon, sizeIcon, panel:GetIcon(), 255, COLOR_WHITE)
        end
    end

    drawShadowedText(
        translatedText,
        font,
        xText,
        0.5 * (h - sizes.border) + shift,
        colorText,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintFormButtonIconTTT2(panel, w, h)
    local colorBox = colors.accent

    if panel.colorBackground then
        if IsColor(panel.colorBackground) then
            colorBox = panel.colorBackground
        else
            colorBox = panel.colorBackground[panel.state or 1]
        end
    end

    local colorBoxBack = colors.settingsBox
    local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
    local shift = 0
    local pad = 6

    if not panel:IsEnabled() then
        colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
        colorBox = ColorAlpha(colorBox, alphaDisabled)
        colorText = ColorAlpha(utilGetDefaultColor(colorBox), alphaDisabled)
    elseif panel.noDefault then
        colorBox = ColorAlpha(colorBox, alphaDisabled)
        colorText = ColorAlpha(utilGetDefaultColor(colorBox), alphaDisabled)
    elseif panel.Depressed or panel:IsSelected() or panel:GetToggle() then
        colorBox = utilGetActiveColor(colorBox)
        colorText = ColorAlpha(utilGetDefaultColor(colorBox), 150)
        shift = 1
    elseif panel.Hovered then
        colorBox = utilGetHoverColor(colorBox)
        colorText = ColorAlpha(utilGetDefaultColor(colorBox), 150)
    end

    if panel.roundedCorner then
        drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
    else
        drawBox(0, 0, w, h, colorBoxBack)
    end

    drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorBox)

    local iconMaterial = panel.iconMaterial or panel.material

    if not iconMaterial then
        return
    end

    if not iconMaterial.GetTexture then
        iconMaterial = iconMaterial[panel.state or 1]
    end

    drawFilteredShadowedTexture(
        pad,
        pad + shift,
        w - 2 * pad,
        h - 2 * pad,
        iconMaterial,
        colorText.a,
        colorText
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintFormButtonTTT2(panel, w, h)
    local colorBoxBack = colors.settingsBox
    local colorBox = colors.accent
    local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
    local shift = 0

    if not panel:IsEnabled() then
        colorBoxBack = ColorAlpha(colors.settingsBox, alphaDisabled)
        colorBox = ColorAlpha(colors.accent, alphaDisabled)
        colorText = ColorAlpha(utilGetDefaultColor(colors.accent), alphaDisabled)
    elseif panel.Depressed or panel:IsSelected() or panel:GetToggle() then
        colorBox = colors.accentActive
        colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
        shift = 1
    elseif panel.Hovered then
        colorBox = colors.accentHover
        colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
    end

    drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
    drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorBox)

    drawShadowedText(
        TryT(panel:GetText()),
        panel:GetFont(),
        0.5 * w,
        0.5 * h + shift,
        colorText,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintBinderButtonTTT2(panel, w, h)
    local colorBoxBack = colors.settingsBox
    local colorBox = colors.accent
    local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
    local shift = 0

    if not panel:IsEnabled() then
        colorBoxBack = ColorAlpha(colors.settingsBox, alphaDisabled)
        colorBox = ColorAlpha(colors.accent, alphaDisabled)
        colorText = ColorAlpha(colors.settingsText, alphaDisabled)
    end

    if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
        colorBoxBack = colors.settingsBox
        colorBox = colors.accentActive
        colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
        shift = 1
    end

    if panel.Hovered then
        colorBoxBack = colors.settingsBox
        colorBox = colors.accentActive
        colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
    end

    drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
    drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorBox)

    drawShadowedText(
        string.upper(TryT(panel:GetText())),
        panel:GetFont(),
        0.5 * w,
        0.5 * h + shift,
        colorText,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintLabelSpacerTTT2(panel, w, h)
    local text = TryT(panel:GetText())
    local font = panel:GetFont()

    local padding = 10
    local heightBar = 5
    local barX1 = 0
    local barY1 = 0.5 * (h - heightBar) + 1
    local widthBar1 = 20
    local textX = barX1 + widthBar1 + padding
    local widthText = drawGetTextSize(text, font)
    local barX2 = textX + widthText + padding
    local widthBar2 = w - barX2

    local colorLine = utilGetChangedColor(colors.default, 170)

    drawBox(barX1, barY1, widthBar1, heightBar, colorLine)
    drawBox(barX2, barY1, widthBar2, heightBar, colorLine)

    drawSimpleText(
        text,
        font,
        textX,
        0.5 * h,
        utilGetChangedColor(colors.default, 40),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintLabelTTT2(panel, w, h)
    drawSimpleText(
        TryT(panel:GetText()),
        panel:GetFont(),
        0,
        0.5 * h,
        utilGetChangedColor(colors.default, 40),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintLabelRightTTT2(panel, w, h)
    drawSimpleText(
        TryT(panel:GetText()),
        panel:GetFont(),
        w,
        0.5 * h,
        utilGetChangedColor(colors.default, 40),
        TEXT_ALIGN_RIGHT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintFormLabelTTT2(panel, w, h)
    local colorText = colors.settingsText
    local colorBox = colors.settingsBox

    if not panel:IsEnabled() then
        colorText = ColorAlpha(colors.settingsText, alphaDisabled)
        colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
    end

    drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBox, true, false, true, false)
    drawSimpleText(
        TryT(panel:GetText()),
        panel:GetFont(),
        10,
        0.5 * h,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintFormBoxTTT2(panel, w, h)
    local colorBox = colors.settingsBox
    local colorHandle = colors.handle

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
        colorHandle = ColorAlpha(colors.handle, alphaDisabled)
    end

    drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBox, false, true, false, true)
    drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorHandle)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintMenuLabelTTT2(panel, w, h)
    drawSimpleText(
        TryT(panel:GetText()),
        panel:GetFont(),
        0,
        0.5 * h,
        colors.settingsText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintHelpLabelTTT2(panel, w, h)
    local colorBox = colors.helpBox
    local colorBar = colors.helpBar
    local colorText = colors.helpText

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colorBox, alphaDisabled)
        colorBar = ColorAlpha(colorBar, alphaDisabled)
        colorText = ColorAlpha(colorText, 0.5 * alphaDisabled)
    end

    drawBox(0, 0, w, h, colorBox)
    drawBox(0, 0, 4, h, colorBar)

    local textTranslated = ParT(panel:GetText(), TryT(panel:GetTextParams()))
    local textWrapped = drawGetWrappedText(textTranslated, w - 2 * panel.paddingX, panel:GetFont())

    local _, heightText = drawGetTextSize("", panel:GetFont())
    local posY = panel.paddingY

    for i = 1, #textWrapped do
        drawSimpleText(
            textWrapped[i],
            panel:GetFont(),
            panel.paddingX,
            posY,
            colorText,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_TOP
        )

        posY = posY + heightText
    end
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintSliderKnob(panel, w, h)
    local colorBox = colors.accent

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colors.accent, alphaDisabled)
    end

    if panel.Depressed then
        colorBox = colors.accentActive
    end

    if panel.Hovered then
        colorBox = colors.accentHover
    end

    drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, colorBox)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintNumSliderTTT2(panel, w, h)
    local colorBox = colors.settingsBox
    local colorHandle = colors.handle
    local colorLineActive = colors.accent
    local colorLinePassive = colors.sliderInactive
    local pad = 5

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
        colorHandle = ColorAlpha(colors.handle, alphaDisabled)
        colorLineActive = ColorAlpha(colors.accent, alphaDisabled)
        colorLinePassive = ColorAlpha(colors.sliderInactive, alphaDisabled)
    end

    drawBox(0, 0, w, h, colorBox)
    drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorHandle)

    -- draw selection line
    drawBox(5, 0.5 * h - 1, w - 2 * pad, 2, colorLinePassive)
    drawBox(5, 0.5 * h - 1, (w - pad) * panel:GetFraction() - pad, 2, colorLineActive)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintSliderTextAreaTTT2(panel, w, h)
    local colorBox = colors.settingsBox
    local colorText = colors.settingsText

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
        colorText = ColorAlpha(colors.settingsText, alphaDisabled)
    end

    -- Draw normal text if currently not in input mode, otherwise draw the TTT2 Text Entry
    if not panel:GetParent():GetTextBoxEnabled() then
        drawBox(0, 0, w, h, colorBox)
        drawSimpleText(
            panel:GetText(),
            panel:GetFont(),
            0.5 * w,
            0.5 * h,
            colorText,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    else
        self:PaintTextEntryTTT2(panel, w, h)
        local vguiColor = utilGetActiveColor(
            utilGetChangedColor(utilGetDefaultColor(vskinGetBackgroundColor()), 25)
        )
        panel:DrawTextEntryText(vguiColor, vguiColor, vguiColor)
    end
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintBinderPanelTTT2(panel, w, h)
    local colorBox = colors.settingsBox

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
    end

    drawBox(0, 0, w, h, colorBox)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintComboBoxTTT2(panel, w, h)
    local colorBox = colors.settingsBox
    local colorHandle = colors.handle
    local colorText = utilGetChangedColor(utilGetDefaultColor(colors.handle), 50)

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
        colorHandle = ColorAlpha(utilGetActiveColor(colors.handle), alphaDisabled)
        colorText = ColorAlpha(colorText, alphaDisabled)
    end

    if panel.Depressed or panel:IsMenuOpen() then
        colorHandle = utilGetHoverColor(colors.handle)
    end

    if panel.Hovered then
        colorHandle = utilGetActiveColor(colors.handle)
    end

    drawBox(0, 0, w, h, colorBox)
    drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorHandle)
    drawSimpleText(
        TryT(panel:GetText()),
        panel:GetFont(),
        10,
        0.5 * h,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintColoredTextBoxTTT2(panel, w, h)
    local colorBackground

    -- get the background color
    if panel:HasDynamicColor() then
        colorBackground = utilGetChangedColor(
            panel:GetDynamicParentColor() or colors.background,
            panel:GetDynamicParentColorShift()
        )
    else
        colorBackground = panel:GetColor()
    end

    -- set the dynamic background color for the child elements
    panel.dynBaseColor = colorBackground

    local colorText = utilGetDefaultColor(colorBackground)
    local align = panel:GetTitleAlign()
    local alpha = mathRound(colorText.a * panel:GetTitleOpacity())
    local hasIcon = panel:HasIcon()
    local pad = mathRound(0.1 * h)
    local sizeIcon = h - 2 * pad

    drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorBackground)

    if panel:HasFlashColor() then
        local colorFlash = table.Copy(colorText)
        colorFlash.a = math.Round(15 * (math.sin((CurTime() % 2 - 1) * math.pi) + 1.1))

        drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorFlash)
    end

    drawShadowedText(
        TryT(panel:GetTitle()),
        panel:GetTitleFont(),
        (align == TEXT_ALIGN_CENTER) and (0.5 * w)
            or (hasIcon and (sizeIcon + 4 * pad) or (2 * pad)),
        0.5 * h,
        ColorAlpha(colorText, alpha),
        align,
        TEXT_ALIGN_CENTER,
        1
    )

    if hasIcon then
        drawFilteredShadowedTexture(pad, pad, sizeIcon, sizeIcon, panel:GetIcon(), alpha, colorText)
    end
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintColoredBoxTTT2(panel, w, h)
    -- get the background color
    if panel:HasDynamicColor() then
        panel.dynBaseColor =
            utilGetChangedColor(panel:GetDynamicParentColor() or colors.background, 30)
    else
        panel.dynBaseColor = panel:GetColor()
    end

    drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, panel.dynBaseColor)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintVerticalBorderedBoxTTT2(panel, w, h)
    drawBox(w - 1, 0, 1, h, ColorAlpha(colors.default, 200))
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintButtonRoundEndLeftTTT2(panel, w, h)
    local colorForeground = colors.accent
    local shift = 0

    if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
        shift = 1
    elseif panel.Hovered then
        colorForeground = colors.accentHover
    elseif not panel.isActive then
        colorForeground = colors.handle
    end

    local colorText = ColorAlpha(utilGetDefaultColor(colorForeground), 220)

    drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colors.content, true, false, true, false)
    drawRoundedBox(sizes.cornerRadius, 2, 2, w - 3, h - 4, colorForeground)

    drawSimpleText(
        TryT(panel:GetText()),
        panel:GetFont(),
        0.5 * w,
        0.5 * h + shift,
        colorText,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintButtonRoundEndRightTTT2(panel, w, h)
    local colorForeground = colors.accent
    local shift = 0

    if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
        shift = 1
    elseif panel.Hovered then
        colorForeground = colors.accentHover
    elseif not panel.isActive then
        colorForeground = colors.handle
    end

    local colorText = ColorAlpha(utilGetDefaultColor(colorForeground), 220)

    drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colors.content, false, true, false, true)
    drawRoundedBox(sizes.cornerRadius, 1, 2, w - 3, h - 4, colorForeground)

    drawSimpleText(
        TryT(panel:GetText()),
        panel:GetFont(),
        0.5 * w,
        0.5 * h + shift,
        colorText,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintTooltipTTT2(panel, w, h)
    local colorLine = ColorAlpha(colors.default, 100)

    local sizeArrow = panel:GetArrowSize()
    local sizeRhombus = 2 * sizeArrow

    drawBox(0, sizeArrow, w, h - sizeArrow, colorLine)
    drawFilteredTexture(
        sizeArrow,
        0,
        sizeRhombus,
        sizeRhombus,
        materialRhombus,
        colorLine.a,
        colorLine
    )

    drawBox(1, sizeArrow + 1, w - 2, h - sizeArrow - 2, colors.background)
    drawFilteredTexture(
        sizeArrow,
        1,
        sizeRhombus,
        sizeRhombus,
        materialRhombus,
        colors.background.a,
        colors.background
    )

    if panel:HasText() then
        local text = TryT(panel:GetText())
        local textColor = utilGetDefaultColor(colors.background)

        local wrapped = drawGetWrappedText(text, ScrW() - 20, panel:GetFont())
        local _, lineHeight = drawGetTextSize("", panel:GetFont())
        local y = 4 + sizeArrow
        for i = 1, #wrapped do
            drawSimpleText(
                wrapped[i],
                panel:GetFont(),
                10,
                y,
                textColor,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_TOP
            )
            y = y + lineHeight
        end
    end
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintEventBoxTTT2(panel, w, h)
    local event = panel:GetEvent()

    local colorLine = ColorAlpha(colors.default, 25)
    local colorText = ColorAlpha(colors.default, 200)

    local sizeIcon = 30
    local padding = 8
    local widthLine = 4
    local offsetXLine = 0.5 * sizeIcon + padding
    local offsetXIcon = offsetXLine - 0.5 * (sizeIcon - widthLine)
    local offsetYIcon = 20 + padding
    local offsetYLine = offsetYIcon + padding + sizeIcon
    local offsetXText = offsetXIcon + sizeIcon + padding
    local offsetYTitle = offsetYIcon + 0.5 * sizeIcon
    local widthScoreBox = w - offsetXText - 2 * padding

    drawBox(offsetXLine, 0, widthLine, offsetYIcon - padding, colorLine)
    drawBox(offsetXLine, offsetYLine, widthLine, h - offsetYLine, colorLine)

    drawFilteredShadowedTexture(
        offsetXIcon,
        offsetYIcon,
        sizeIcon,
        sizeIcon,
        panel:GetIcon(),
        colorText.a,
        colorText
    )

    drawShadowedText(
        TryT(panel:GetTitle()),
        panel:GetTitleFont(),
        offsetXText,
        offsetYTitle,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER,
        1
    )

    local time = event:GetTime()
    local minutes = math.floor(time / 60)
    local seconds = math.floor(time % 60)

    drawSimpleText(
        string.format("[%02d:%02d]", minutes, seconds),
        panel:GetFont(),
        w - 20,
        offsetYTitle,
        colorLine,
        TEXT_ALIGN_RIGHT,
        TEXT_ALIGN_CENTER
    )

    local posY = offsetYIcon + sizeIcon + padding
    local textTable = panel:GetText()
    local _, heightText = drawGetTextSize("", panel:GetFont())

    for i = 1, #textTable do
        local text = textTable[i]
        local params = {}

        if text.translateParams then
            for key, value in pairs(text.params) do
                params[key] = TryT(value)
            end
        else
            params = text.params
        end

        local textTranslated = ParT(text.string, params or {})

        local textWrapped = drawGetWrappedText(textTranslated, w - offsetXText, panel:GetFont())

        for k = 1, #textWrapped do
            drawSimpleText(
                textWrapped[k],
                panel:GetFont(),
                offsetXText,
                posY,
                colorText,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_TOP
            )

            posY = posY + heightText
        end

        posY = posY + 15
    end

    if not event:HasScore() then
        return
    end

    local colorBox = ColorAlpha(colors.default, 10)
    local scoredPlayers = event:GetScoredPlayers()
    local sid64 = LocalPlayer():SteamID64()

    for i = 1, #scoredPlayers do
        local ply64 = scoredPlayers[i]

        if event.onlyLocalPlayer and ply64 ~= sid64 then
            continue
        end

        local rawScoreTexts = event:GetRawScoreText(ply64)
        local scoreRows = #rawScoreTexts

        if scoreRows == 0 then
            continue
        end

        local height = (scoreRows + 1) * heightText + 2 * padding

        drawRoundedBox(sizes.cornerRadius, offsetXText, posY, widthScoreBox, height, colorBox)

        drawSimpleText(
            ParT("title_player_score", { player = event:GetNameFrom64(ply64) }),
            panel:GetFont(),
            offsetXText + padding,
            posY + padding,
            colorText,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_TOP
        )

        for k = 1, scoreRows do
            local rawScoreText = rawScoreTexts[k]

            drawSimpleText(
                TryT(rawScoreText.name),
                panel:GetFont(),
                offsetXText + 2 * padding,
                posY + padding + k * heightText,
                colorText,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_TOP
            )

            drawSimpleText(
                rawScoreText.score,
                panel:GetFont(),
                offsetXText + 2 * padding + 175,
                posY + padding + k * heightText,
                colorText,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_TOP
            )
        end

        posY = posY + height + 15
    end
end

local MODE_ADDED = ShopEditor.MODE_ADDED
local MODE_INHERIT_ADDED = ShopEditor.MODE_INHERIT_ADDED
local MODE_INHERIT_REMOVED = ShopEditor.MODE_INHERIT_REMOVED

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintShopCardTTT2(panel, w, h)
    local widthBorder = 2
    local widthBorder2 = widthBorder * 2
    local sizeIcon = 64
    local padding = 5
    local posIcon = widthBorder + padding
    local posText = posIcon + sizeIcon + 2 * padding
    local heightMode = 35
    local widthMode = w - sizeIcon - 3 * padding
    local posIconModeX = w - widthMode + 2 * padding
    local posIconModeY = h - heightMode + 2 * padding
    local sizeIconMode = heightMode - 4 * padding
    local posTextModeX = posIconModeX + sizeIconMode + 2 * padding
    local posTextModeY = posIconModeY + 0.5 * sizeIconMode - 1

    local colorBackground = colors.settingsBox
    local colorText = colors.settingsText
    local colorMode = utilGetChangedColor(colors.background, 75)

    local materialMode = materialCardRemoved
    local textMode = "equip_not_added"

    if panel:GetMode() == MODE_ADDED then
        colorMode = colorCardAdded
        materialMode = materialCardAdded
        textMode = "equip_added"
    elseif panel:GetMode() == MODE_INHERIT_ADDED then
        colorMode = colorCardInheritAdded
        materialMode = materialCardAdded
        textMode = "equip_inherit_added"
    elseif panel:GetMode() == MODE_INHERIT_REMOVED then
        colorMode = colorCardInheritRemoved
        textMode = "equip_inherit_removed"
    end

    local colorTextMode = utilGetDefaultColor(colorMode)

    if panel.Hovered then
        colorBackground = colors.accentHover
    end

    drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorMode)
    drawRoundedBox(
        sizes.cornerRadius,
        widthBorder,
        widthBorder,
        w - widthBorder2,
        h - widthBorder2,
        colorBackground
    )

    drawFilteredTexture(posIcon, posIcon, sizeIcon, sizeIcon, panel:GetIcon())

    drawSimpleText(
        TryT(panel:GetText()),
        panel:GetFont(),
        posText,
        posIcon + padding,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_TOP
    )

    drawRoundedBoxEx(
        sizes.cornerRadius,
        w - widthMode,
        h - heightMode,
        widthMode,
        heightMode,
        colorMode,
        true,
        false,
        false,
        true
    )

    drawFilteredTexture(
        posIconModeX,
        posIconModeY,
        sizeIconMode,
        sizeIconMode,
        materialMode,
        175,
        colorTextMode
    )

    drawSimpleText(
        TryT(textMode),
        "DermaTTT2TextSmall",
        posTextModeX,
        posTextModeY,
        colorTextMode,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintComboCardTTT2(panel, w, h)
    local widthBorder = 2
    local widthBorder2 = widthBorder * 2
    local widthBorder4 = widthBorder2 * 2
    local shift = 0

    local colorBackground = utilGetChangedColor(colors.background, 75)
    local colorBox = colors.settingsBox
    local opacity = 255

    if panel:GetChecked() then
        colorBox = colors.accent
    end

    if panel.Hovered then
        colorBox = utilGetHoverColor(colorBox)
        opacity = 230
    end

    if panel.Depressed then
        opacity = 240
        shift = 1
    end

    local colorText = utilGetDefaultColor(colorBox)

    drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorBackground)

    drawRoundedBox(
        sizes.cornerRadius,
        widthBorder,
        widthBorder,
        w - widthBorder2,
        h - widthBorder2,
        colorBox
    )

    if panel:GetIcon() then
        draw.FilteredTexture(
            widthBorder2,
            widthBorder2 + shift,
            w - widthBorder4,
            w - widthBorder4,
            panel:GetIcon(),
            opacity,
            COLOR_WHITE
        )
    end

    local tagText = panel:GetTagText()

    if tagText then
        local width = drawGetTextSize(tagText, panel:GetFont())
        local colorTag = panel:GetTagColor() or COLOR_WARMGRAY

        width = width + 20

        drawRoundedBox(sizes.cornerRadius, widthBorder4, widthBorder4, width, 20, colorTag)

        drawSimpleText(
            TryT(tagText),
            panel:GetFont(),
            widthBorder4 + 0.5 * width,
            widthBorder4 + 10,
            utilGetDefaultColor(colorTag),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end

    drawSimpleText(
        drawGetLimitedLengthText(
            TryT(panel:GetText()),
            w - 2 * widthBorder4,
            panel:GetFont(),
            "..."
        ),
        panel:GetFont(),
        widthBorder4,
        w + shift,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_TOP
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintRoleImageTTT2(panel, w, h)
    local widthBorder = 2
    local widthBorder2 = widthBorder * 2
    local sizeIconRole = w - widthBorder2
    local padding = 3
    local sizeMode = 18 * w / 64
    local sizeIconMode = sizeMode - 2 * padding
    local posIconModeX = w - sizeMode + padding
    local posIconModeY = h - sizeMode + padding

    local colorBackground = panel:GetColor()
    local colorIcon = utilGetDefaultColor(colorBackground)

    local colorBorder = colorCardAdded
    local iconBorder = materialCardAdded

    if not panel:GetValue() then -- convar value
        colorBackground = colors.settingsBox
        colorIcon = colors.settingsText
        colorBorder = colorCardInheritRemoved
        iconBorder = materialCardRemoved
    end

    local colorBorderIcon = utilGetDefaultColor(colorBorder)

    if panel:GetIsActiveIndicator() then
        drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorBorder)

        drawRoundedBox(
            sizes.cornerRadius,
            widthBorder,
            widthBorder,
            w - widthBorder2,
            h - widthBorder2,
            colorBackground
        )
    else
        drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorBackground)

        widthBorder = 0
        widthBorder2 = 0
        sizeIconRole = w
    end

    if panel:GetValue() then
        drawFilteredShadowedTexture(
            widthBorder,
            widthBorder,
            sizeIconRole,
            sizeIconRole,
            panel:GetMaterial(),
            colorIcon.a,
            colorIcon
        )
    else
        drawFilteredTexture(
            widthBorder,
            widthBorder,
            sizeIconRole,
            sizeIconRole,
            panel:GetMaterial(),
            colorIcon.a * 0.5,
            colorIcon
        )
    end

    if not panel:GetIsActiveIndicator() then
        return
    end

    drawRoundedBoxEx(
        sizes.cornerRadius,
        w - sizeMode,
        h - sizeMode,
        sizeMode,
        sizeMode,
        colorBorder,
        true,
        false,
        false,
        true
    )

    drawFilteredTexture(
        posIconModeX,
        posIconModeY,
        sizeIconMode,
        sizeIconMode,
        iconBorder,
        175,
        utilGetDefaultColor(colorBorderIcon)
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintRoleLayeringSenderTTT2(panel, w, h)
    local colorBox = utilGetChangedColor(colors.background, 40)
    local colorText = utilGetDefaultColor(colorBox)

    drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorBox)

    drawSimpleText(
        TryT("layering_not_layered"),
        "DermaTTT2Text",
        10,
        0.5 * h,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintRoleLayeringReceiverTTT2(panel, w, h)
    local colorBox = utilGetChangedColor(colors.background, 20)
    local colorText = utilGetDefaultColor(colorBox)

    for i = 1, #panel.layerBoxes do
        local layerBox = panel.layerBoxes[i]

        drawRoundedBox(sizes.cornerRadius, 0, layerBox.y, w, layerBox.h, colorBox)

        drawSimpleText(
            ParT("layering_layer", { layer = i }),
            "DermaTTT2Text",
            10,
            layerBox.label,
            colorText,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )
    end
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintSearchbar(panel, w, h)
    local colorBox = colors.helpBox
    local colorBar = colors.accentHover
    local colorText = utilGetActiveColor(utilGetChangedColor(colors.default, 25))
    local heightMult = panel:GetHeightMult()

    local leftPad, topPad, rightPad, bottomPad = panel:GetDockPadding()
    local widthPad = leftPad + rightPad
    local heightPad = topPad + bottomPad

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colorBox, alphaDisabled)
        colorBar = ColorAlpha(colorBar, alphaDisabled)
        colorText = ColorAlpha(colorText, alphaDisabled)
    end

    -- Draw custom box background for the searchBar
    drawBox(
        leftPad,
        h * (1 - heightMult) * 0.5 + topPad,
        w - widthPad,
        h * heightMult - heightPad,
        colorBox
    )

    -- Draw small blue bar on the bottom
    drawBox(leftPad, h - sizes.border - bottomPad, w - widthPad, sizes.border, colorBar)

    -- If not focussed draw placeholder text
    if panel:GetIsOnFocus() then
        return
    end

    drawSimpleText(
        TryT(panel:GetCurrentPlaceholderText()),
        panel:GetFont(),
        leftPad + w * 0.02,
        0.5 * h,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintTextEntryTTT2(panel, w, h)
    local colorBox = colors.settingsBox
    local colorHandle = colors.handle

    if not panel:IsEnabled() then
        colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
        colorHandle = ColorAlpha(colors.handle, alphaDisabled)
    end

    drawBox(0, 0, w, h, colorBox)
    drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorHandle)
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintImageCheckBoxTTT2(panel, w, h)
    local widthBorder = 2
    local widthBorder2 = widthBorder * 2
    local padding = 5
    local heightMode = 35
    local widthMode = 175
    local posIconModeX = w - widthMode + 2 * padding
    local posIconModeY = h - heightMode + 2 * padding
    local sizeIconMode = heightMode - 4 * padding
    local posTextModeX = posIconModeX + sizeIconMode + 2 * padding
    local posTextModeY = posIconModeY + 0.5 * sizeIconMode - 1
    local posStatusIconBoxX = 8
    local sizeStatusIconBox = 32
    local sizeStatusIcon = sizeStatusIconBox - 2 * padding
    local posStatusIconX = posStatusIconBoxX + padding

    local posHeadIconBoxY = 8
    local posHeadIconY = posHeadIconBoxY + padding
    local posHattableIconBoxY = posHeadIconBoxY + sizeStatusIconBox + padding
    local posHattableIconY = posHattableIconBoxY + padding

    local colorBackground = colors.settingsBox
    local colorMode = utilGetChangedColor(colors.background, 75)
    local colorTextMode = utilGetDefaultColor(colorMode)
    local colorHeadIcon = colorCardInheritRemoved
    local colorHattableIcon = colorCardInheritRemoved

    local materialMode = materialCardRemoved
    local materialHeadIcon = materialHeadboxNo
    local materialHattableIcon = materialHattableNo

    if panel.Hovered then
        colorBackground = colors.accentHover
    end

    if panel:IsModelSelected() then
        colorMode = colorCardAdded
        materialMode = materialCardAdded
    end

    if panel:HasHeadBox() then
        colorHeadIcon = colorCardAdded
        materialHeadIcon = materialHeadboxYes
    end

    if panel:IsModelHattable() then
        colorHattableIcon = colorCardAdded
        materialHattableIcon = materialHattableYes
    end

    drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorMode)
    drawRoundedBox(
        sizes.cornerRadius,
        widthBorder,
        widthBorder,
        w - widthBorder2,
        h - widthBorder2,
        colorBackground
    )

    if panel:HasModel() then
        panel:DrawModel()
    end

    drawRoundedBoxEx(
        sizes.cornerRadius,
        w - widthMode,
        h - heightMode,
        widthMode,
        heightMode,
        colorMode,
        true,
        false,
        false,
        true
    )
    drawFilteredTexture(
        posIconModeX,
        posIconModeY,
        sizeIconMode,
        sizeIconMode,
        materialMode,
        175,
        colorTextMode
    )

    drawSimpleText(
        TryT(panel:GetText()),
        "DermaTTT2Text",
        posTextModeX,
        posTextModeY,
        colorTextMode,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )

    drawRoundedBox(
        sizes.cornerRadius,
        posStatusIconBoxX,
        posHeadIconBoxY,
        sizeStatusIconBox,
        sizeStatusIconBox,
        colorHeadIcon
    )
    drawFilteredTexture(
        posStatusIconX,
        posHeadIconY,
        sizeStatusIcon,
        sizeStatusIcon,
        materialHeadIcon,
        200,
        COLOR_WHITE
    )

    drawRoundedBox(
        sizes.cornerRadius,
        posStatusIconBoxX,
        posHattableIconBoxY,
        sizeStatusIconBox,
        sizeStatusIconBox,
        colorHattableIcon
    )
    drawFilteredTexture(
        posStatusIconX,
        posHattableIconY,
        sizeStatusIcon,
        sizeStatusIcon,
        materialHattableIcon,
        200,
        COLOR_WHITE
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintProfilePanelTTT2(panel, w, h)
    local padding = 5

    local heightBottom = 100

    local widthRender = w - 2 * padding
    local heightRender = h - padding - heightBottom

    local sizePlayerIcon = 64
    local xRoleIcon = 0.5 * (widthRender - sizePlayerIcon) + padding
    local yRoleIcon = heightRender + padding - 0.5 * sizePlayerIcon

    local sizePlayerIconBox = sizePlayerIcon + 2 * padding
    local xPlayerIconBox = xRoleIcon - padding
    local yPlayerIconBox = yRoleIcon - padding

    local sizeRoleIcon = 32
    local posRoleIcon = 2 * padding

    local yTextTeam = h - 26
    local yTextRole = yTextTeam - 22
    local xText = 0.5 * w

    -- cache colors
    local colorBackground = colors.background
    local colorRole = panel:GetPlayerRoleColor()
    local colorRoleText = utilGetDefaultColor(colorRole)
    local colorRoleIcon = utilGetDefaultColor(colorBackground)

    -- cache materials
    local materialPlayerIcon = panel:GetPlayerIcon()
    local materialRole = panel:GetPlayerRoleIcon()

    drawBox(0, 0, w, h, colorRole)
    drawBox(padding, padding, widthRender, heightRender, colorBackground)

    if panel:HasModel() then
        panel:DrawModel(padding, padding, widthRender, heightRender)
    end

    drawBox(xPlayerIconBox, yPlayerIconBox, sizePlayerIconBox, sizePlayerIconBox, colorRole)
    drawFilteredTexture(
        xRoleIcon,
        yRoleIcon,
        sizePlayerIcon,
        sizePlayerIcon,
        materialPlayerIcon,
        255,
        COLOR_WHITE
    )

    drawFilteredShadowedTexture(
        posRoleIcon,
        posRoleIcon,
        sizeRoleIcon,
        sizeRoleIcon,
        materialRole,
        255,
        colorRoleIcon
    )

    drawShadowedText(
        TryT(panel:GetPlayerRoleString()),
        "DermaTTT2TextLargest",
        xText,
        yTextRole,
        colorRoleText,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    drawShadowedText(
        TryT(panel:GetPlayerTeamString()),
        "DermaTTT2TextLarger",
        xText,
        yTextTeam,
        colorRoleText,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintInfoItemTTT2(panel, w, h)
    local hasIcon = panel:HasIcon()

    local padding = 5

    local widthBorder = 2
    local widthBorder2 = 2 * widthBorder

    local sizeIcon = 64
    local posIcon = widthBorder + padding

    local posText = hasIcon and (posIcon + sizeIcon + 2 * padding) or (posIcon + padding)
    local heightText = 15

    local colorBackground = panel:GetColor() or colors.settingsBox
    local colorBorderDefault = utilGetChangedColor(colors.background, 75)
    local colorText = utilGetDefaultColor(colorBackground)

    drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorBorderDefault)
    drawRoundedBox(
        sizes.cornerRadius,
        widthBorder,
        widthBorder,
        w - widthBorder2,
        h - widthBorder2,
        colorBackground
    )

    if hasIcon then
        drawFilteredTexture(posIcon, posIcon, sizeIcon, sizeIcon, panel:GetIcon())
    end

    if hasIcon and panel:HasIconTextFunction() then
        local textString = panel:GetIconText()

        local widthIconText = drawGetTextSize(textString, "DermaTTT2SmallBold")
        local xIconText = posIcon + 0.5 * sizeIcon
        local yIconText = posIcon + 0.75 * sizeIcon
        local widthIconTextBox = widthIconText + 8
        local heightIconTextBox = 16

        local colorLiveTimeBackground = colors.settingsBox

        drawRoundedBox(
            sizes.cornerRadius,
            xIconText - 0.5 * widthIconTextBox,
            yIconText - 7,
            widthIconTextBox,
            heightIconTextBox,
            colorLiveTimeBackground
        )

        drawShadowedText(
            textString,
            "DermaTTT2SmallBold",
            xIconText,
            yIconText,
            COLOR_ORANGE,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
    end

    local title = panel:GetTitle()
    local text_title = ""

    if title then
        if title.params then
            text_title = ParT(title.body, title.params)
        else
            text_title = TryT(title.body)
        end
    end

    drawSimpleText(
        text_title,
        "DermaTTT2TitleSmall",
        posText,
        posIcon,
        colorText,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_TOP
    )

    local text = panel:GetText()
    local text_translated = ""

    if text then
        for i = 1, #text do
            local params = text[i].params
            local body = text[i].body

            if not body then
                continue
            end

            if i == 1 then
                text_translated = DynT(body, params, true)
            else
                text_translated = text_translated .. " " .. DynT(body, params, true)
            end
        end
    end

    local text_wrapped = drawGetWrappedText(text_translated, w - posText - padding, "DermaDefault")

    local posY = posIcon + heightText + 4

    for k = 1, #text_wrapped do
        drawSimpleText(
            text_wrapped[k],
            "DermaDefault",
            posText,
            posY,
            colorText,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_TOP
        )

        posY = posY + heightText
    end
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintWeaponPreviewTTT2(panel, w, h)
    if panel:HasModel() then
        panel:DrawModel()
    end
end

---
-- @param Panel panel
-- @param number w
-- @param number h
-- @realm client
function SKIN:PaintPlayerGraphTTT2(panel, w, h)
    local renderData = panel.renderData
    local padding = panel:GetPadding()

    if panel.title ~= "" then
        -- title text
        drawSimpleText(
            panel.title,
            panel:GetFont(),
            renderData.titleX,
            renderData.titleY,
            colors.helpText,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_TOP
        )
    end

    local barColor = utilGetChangedColor(colors.background, 30)
    local valueInsideColor = utilGetDefaultColor(barColor)
    local valueOutsideColor = utilGetDefaultColor(colors.background)

    if renderData.sepY then
        -- title separator
        drawBox(0, renderData.sepY, w, 1, barColor)
    end

    local hBarColor = colors.accent
    local hValueInsideColor = colors.accentText

    -- then the items
    for i = 1, #renderData.order do
        local item = renderData.order[i]
        -- first, draw the bar
        local thisBarColor
        if item.data.highlight then
            thisBarColor = hBarColor
        else
            thisBarColor = barColor
        end
        drawBox(item.x, item.y, item.w, item.h, thisBarColor)
        -- then the value text
        if item.valueWidth > w - item.x - item.w - padding then
            -- the value would take up too much space outside, put it inside
            local thisTextCol
            if item.data.highlight then
                thisTextCol = hValueInsideColor
            else
                thisTextCol = valueInsideColor
            end
            local x = item.x + item.w - item.valueWidth - padding
            drawSimpleText(
                tostring(item.data.value),
                panel:GetFont(),
                x,
                item.y,
                thisTextCol,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_TOP
            )
        else
            -- the value will fit outside the bar, draw it there
            drawSimpleText(
                tostring(item.data.value),
                panel:GetFont(),
                item.x + item.w + padding,
                item.y,
                valueOutsideColor,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_TOP
            )
        end
    end
end

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
