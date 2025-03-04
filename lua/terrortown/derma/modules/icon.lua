---
-- @class PANEL
-- @section TTT2:DPanel/Icon

---
-- Adds an icon to the panel. The icon can have a dropshadow and a fixed size.
-- @note Horizontal text alignment is also applied to the icon.
-- @param Material iconMaterial The icon material that should be added
-- @param[default=DRAW_SHADOW_DISABLED] boolean isShadowed Set to enable/disable drop shadow
-- @param[default=DRAW_ICON_SIMPLE] boolean isSimple Set to enable/disable icon coloring
-- @param[opt] number size The size in pixels, automatically determined if not set
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetIcon(iconMaterial, isShadowed, isSimple, size)
    self.m_mIconMaterial = iconMaterial
    self.m_bIconShadow = isShadowed or DRAW_SHADOW_DISABLED
    self.m_bIconSimple = isSimple or DRAW_ICON_SIMPLE
    self.m_nIconSize = size

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Returns the added icon material, nil if none was added.
-- @return Material|nil The added material
-- @realm client
function METAPANEL:GetIcon()
    return self.m_mIconMaterial
end

---
-- Checks whether the panel has an attached icon.
-- @return boolean True if there is an icon attached
-- @realm client
function METAPANEL:HasIcon()
    return self.m_mIconMaterial ~= nil
end

---
-- Returns if the icon should have a drop shadow, nil if not set.
-- @return boolean|nil True if drop shadow is enabled
-- @realm client
function METAPANEL:HasIconShadow()
    return self.m_bIconShadow
end

---
-- Returns the icon size nil if not set.
-- @return number|nil The size in pixels
-- @realm client
function METAPANEL:GetIconSize()
    return self.m_nIconSize
end

-- Returns whether the icon is simple or has RGB colors.
-- @return boolean Returns true if the icon is simple
-- @realm client
function METAPANEL:IsIconSimple()
    return self.m_bIconSimple
end
