---
-- A handler of the skin colors
-- @author Mineotopia

VSKIN = VSKIN or {}

VSKIN.skins = VSKIN.skins or {}

VSKIN.selected = VSKIN.selected or ""

---
-- Register a new vskin
-- @param string name The unique name of your vskin
-- @param table skin The skin table
-- @realm client
function VSKIN.RegisterVSkin(name, skin)
	if VSKIN.skins[name] then
		print("[TTT2 Skin] A skin with this name already exists!")

		return
	end

	VSKIN.skins[name] = skin
end

---
-- Select a registered vskin
-- @param string name The unique name of the vskin
-- @return boolean Returns true if skin was selected
-- @realm client
function VSKIN.SelectVSkin(skinName)
	if not VSKIN.skins[skinName] then
		return false
	end

	VSKIN.selected = skinName

	return true
end

---
-- Returns the background color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The background color
-- @realm client
function VSKIN.GetBackgroundColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.background
end

---
-- Returns the accent color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The accent color
-- @realm client
function VSKIN.GetAccentColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.accent
end

---
-- Returns the hovered accent color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The hovered accent color
-- @realm client
function VSKIN.GetHoverAccentColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.accent_hover
end

---
-- Returns the active accent color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The active accent color
-- @realm client
function VSKIN.GetActiveAccentColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.accent_active
end

---
-- Returns the dark accent color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The dark accent color
-- @realm client
function VSKIN.GetDarkAccentColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.accent_dark
end

---
-- Returns the scrollbar color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The scrollbar color
-- @realm client
function VSKIN.GetScrollbarColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.scroll
end

---
-- Returns the hovered scrollbar color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The hovered scrollbar color
-- @realm client
function VSKIN.GetHoverScrollbarColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.scroll_hover
end

---
-- Returns the active scrollbar color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The active scrollbar color
-- @realm client
function VSKIN.GetActiveScrollbarColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.scroll_active
end

---
-- Returns the scrollbar track color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The scrollbar track color
-- @realm client
function VSKIN.GetScrollbarTrackColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.scroll_track
end

---
-- Returns the shadow color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The shadow color
-- @realm client
function VSKIN.GetShadowColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.shadow
end

---
-- Returns the title text color of the currently selected vskin
-- @return [default=Color(255, 255, 255, 255)] Color The title text color
-- @realm client
function VSKIN.GetTitleTextColor()
	if not VSKIN.skins[VSKIN.selected] then
		return COLOR_WHITE
	end

	return VSKIN.skins[VSKIN.selected].colors.title_text
end

---
-- Returns the shadow size of the currently selected vskin
-- @return [default=5] number The shadow size
-- @realm client
function VSKIN.GetShadowSize()
	if not VSKIN.skins[VSKIN.selected] then
		return 5
	end

	return VSKIN.skins[VSKIN.selected].params.shadow_size
end

---
-- Returns the header height of the currently selected vskin
-- @return [default=45] number The header height
-- @realm client
function VSKIN.GetHeaderHeight()
	if not VSKIN.skins[VSKIN.selected] then
		return 45
	end

	return VSKIN.skins[VSKIN.selected].params.header_height
end

---
-- Returns the border size of the currently selected vskin
-- @return [default=3] number The border size
-- @realm client
function VSKIN.GetBorderSize()
	if not VSKIN.skins[VSKIN.selected] then
		return 3
	end

	return VSKIN.skins[VSKIN.selected].params.border_size
end

---
-- Returns the corner radius of the currently selected vskin
-- @return [default=6] number The corner radius
-- @realm client
function VSKIN.GetCornerRadius()
	if not VSKIN.skins[VSKIN.selected] then
		return 6
	end

	return VSKIN.skins[VSKIN.selected].params.corner_radius
end

-- use https://wiki.facepunch.com/gmod/Panel:InvalidateLayout on skin change
-- to run PerformLayout on all elements




