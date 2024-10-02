---
-- A handler for the skin colors
-- @author Mineotopia
-- @module vskin

if SERVER then
    AddCSLuaFile()

    return -- the rest of the vskin library is client only
end

---
-- @realm client
local cv_selectedVSkin = CreateConVar("ttt2_selected_vskin", "dark_ttt2", { FCVAR_ARCHIVE })

---
-- @realm client
local cv_blurVSkin = CreateConVar("ttt2_vskin_blur", 1, { FCVAR_ARCHIVE })

---
-- @realm client
local cv_colorVSkin = CreateConVar("ttt2_vskin_color", 1, { FCVAR_ARCHIVE })

vskin = vskin or {}

vskin.skins = vskin.skins or {}

---
-- Register a new vskin.
-- @param string name The unique name of your vskin
-- @param table skin The skin table
-- @realm client
function vskin.RegisterVSkin(name, skin)
    if vskin.skins[name] then
        ErrorNoHaltWithStack("[TTT2 Skin] A skin with this name already exists!")

        return
    end

    vskin.skins[name] = skin
end

---
-- Select a registered vskin.
-- @param string name The unique name of the vskin,
-- @return boolean Returns true if skin was selected
-- @realm client
function vskin.SelectVSkin(skinName)
    local oldSkinName = vskin.GetVSkinName()

    if not skinName or not vskin.skins[skinName] or skinName == oldSkinName then
        return false
    end

    cv_selectedVSkin:SetString(skinName)

    vguihandler.InvalidateVSkin()

    vskin.UpdatedVSkin(oldSkinName, skinName)

    return true
end

---
-- This function is called after the skin is changed. It updates the color and
-- sizes caching, while also calling @{GM:TTT2UpdatedVSkin}
-- @param string oldSkinName The old skin name
-- @param string skinName The new skin name
-- @realm client
-- @internal
function vskin.UpdatedVSkin(oldSkinName, skinName)
    -- run SKIN function to update color table
    derma.GetSkinTable()["ttt2_default"]:UpdatedVSkin()

    ---
    -- Run hook for other addons to use
    -- @realm client
    hook.Run("TTT2UpdatedVSkin", oldSkinName, skinName)
end

---
-- Returns a table of the names of all registered vskins.
-- @return table The list of all names
-- @realm client
function vskin.GetVSkinList()
    local names = {}

    for name in pairs(vskin.skins) do
        names[#names + 1] = name
    end

    return names
end

---
-- Returns the name of the currently selected vskin.
-- @return string The name of the vskin
-- @realm client
function vskin.GetVSkinName()
    return cv_selectedVSkin:GetString()
end

---
-- Returns the name of the default vskin.
-- @return string The name of the vskin
-- @realm client
function vskin.GetDefaultVSkinName()
    return cv_selectedVSkin:GetDefault()
end

---
-- Sets the background blur state.
-- @param[default=true] boolean state
-- @realm client
function vskin.SetBlurBackground(state)
    cv_blurVSkin:SetBool(state == nil and true or state)
end

---
-- Returns if the background of vskin elements should
-- be blurred or not
-- @return boolean Should the background be blurred
-- @realm client
function vskin.ShouldBlurBackground()
    return cv_blurVSkin:GetBool()
end

---
-- Sets the background color state.
-- @param[default=true] boolean state
-- @realm client
function vskin.SetColorBackground(state)
    cv_colorVSkin:SetBool(state == nil and true or state)
end

---
-- Returns if the background of vskin elements should
-- be colored or not
-- @return boolean Should the background be colored
-- @realm client
function vskin.ShouldColorBackground()
    return cv_colorVSkin:GetBool()
end

---
-- Returns the background color of the currently selected vskin.
-- @return[default=Color(255, 255, 255, 255)] Color The background color
-- @realm client
function vskin.GetBackgroundColor()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return COLOR_WHITE
    end

    return vskinObject.colors.background
end

---
-- Returns the accent color of the currently selected vskin.
-- @return[default=Color(255, 255, 255, 255)] Color The accent color
-- @realm client
function vskin.GetAccentColor()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return COLOR_WHITE
    end

    return vskinObject.colors.accent
end

---
-- Returns the dark accent color of the currently selected vskin.
-- @return[default=Color(255, 255, 255, 255)] Color The dark accent color
-- @realm client
function vskin.GetDarkAccentColor()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return COLOR_WHITE
    end

    return vskinObject.colors.accent_dark
end

---
-- Returns the scrollbar color of the currently selected vskin.
-- @return[default=Color(255, 255, 255, 255)] Color The scrollbar color
-- @realm client
function vskin.GetScrollbarColor()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return COLOR_WHITE
    end

    return vskinObject.colors.scroll
end

---
-- Returns the screen color of the currently selected vskin.
-- @return[default=Color(255, 255, 255, 255)] Color The scrollbar color
-- @realm client
function vskin.GetScreenColor()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return COLOR_WHITE
    end

    return vskinObject.colors.screen
end

---
-- Returns the shadow color of the currently selected vskin.
-- @return[default=Color(255, 255, 255, 255)] Color The shadow color
-- @realm client
function vskin.GetShadowColor()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return COLOR_WHITE
    end

    return vskinObject.colors.shadow
end

---
-- Returns the title text color of the currently selected vskin.
-- @return[default=Color(255, 255, 255, 255)] Color The title text color
-- @realm client
function vskin.GetTitleTextColor()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return COLOR_WHITE
    end

    return vskinObject.colors.title_text
end

---
-- Returns the shadow size of the currently selected vskin.
-- @return[default=5] number The shadow size
-- @realm client
function vskin.GetShadowSize()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return 5
    end

    return vskinObject.params.shadow_size
end

---
-- Returns the header height of the currently selected vskin.
-- @return[default=45] number The header height
-- @realm client
function vskin.GetHeaderHeight()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return 45
    end

    return vskinObject.params.header_height
end

---
-- Returns the collapsable height of the currently selected vskin.
-- @return[default=45] number The collapsable height
-- @realm client
function vskin.GetCollapsableHeight()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return 30
    end

    return vskinObject.params.collapsable_height
end

---
-- Returns the border size of the currently selected vskin.
-- @return[default=3] number The border size
-- @realm client
function vskin.GetBorderSize()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return 3
    end

    return vskinObject.params.border_size
end

---
-- Returns the corner radius of the currently selected vskin.
-- @return[default=6] number The corner radius
-- @realm client
function vskin.GetCornerRadius()
    local vskinObject = vskin.skins[vskin.GetVSkinName()]

    if not vskinObject then
        return 6
    end

    return vskinObject.params.corner_radius
end

---
-- A hook that is called when the vskin is changed.
-- @param string oldSkinName The name of the previous selected vskin
-- @param string skinName The name of the newly selected vskin
-- @hook
-- @realm client
function GM:TTT2UpdatedVSkin(oldSkinName, skinName) end
