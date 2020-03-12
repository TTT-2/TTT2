---
-- A handler of the skin colors
-- @author Mineotopia

local cv_selectedVSkin = CreateConVar("ttt2_selected_vskin", "ttt2_light", {FCVAR_ARCHIVE})
local cv_blurVSkin = CreateConVar("ttt2_vskin_blur", 1, {FCVAR_ARCHIVE})

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
-- @param string name The unique name of the vskin, if nil the convar value is read
-- @return boolean Returns true if skin was selected
-- @realm client
function VSKIN.SelectVSkin(skinName)
	if not skinName then
		VSKIN.selected = cv_selectedVSkin:GetString()

		return true
	end

	if not VSKIN.skins[skinName] then
		return false
	end

	VSKIN.selected = skinName
	cv_selectedVSkin:SetString(skinName)

	VHDL.UpdateVSkinSetting("skin")

	return true
end

---
-- Returns a table of the names of all registered vskins
-- @return table The list of all names
-- @realm client
function VSKIN.GetVSkinList()
	local names = {}

	for name, _ in pairs(VSKIN.skins) do
		names[#names + 1] = name
	end

	return names
end

---
-- Returns the name of the currently selected skin
-- @return string The name of the skin
-- @realm client
function VSKIN.GetVSkinName()
	return VSKIN.selected
end

---
-- Sets the background blur state
-- @param [default=true] boolean state
-- @realm client
function VSKIN.SetBlurBackground(state)
	cv_blurVSkin:SetBool(state == nil and true or state)

	VHDL.UpdateVSkinSetting("blur")
end

---
-- Returns if the background of vskin elements should
-- be blurred or not
-- @realm client
function VSKIN.ShouldBlurBackground()
	return cv_blurVSkin:GetBool()
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
-- Returns the collapsable height of the currently selected vskin
-- @return [default=45] number The collapsable height
-- @realm client
function VSKIN.GetCollapsableHeight()
	if not VSKIN.skins[VSKIN.selected] then
		return 30
	end

	return VSKIN.skins[VSKIN.selected].params.collapsable_height
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
