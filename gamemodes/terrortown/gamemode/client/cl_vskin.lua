---
-- A handler of the skin colors
-- @author Mineotopia

VSKIN = VSKIN or {}

VSKIN.skins = {}

VSKIN.selected = ""

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

-- use https://wiki.facepunch.com/gmod/Panel:InvalidateLayout on skin change
-- to run PerformLayout on all elements




